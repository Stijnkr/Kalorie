from __future__ import annotations

import csv
import hashlib
import io
import json
import re
import uuid
from pathlib import Path
from typing import Any

from aliases import load_aliases
from config import CATALOG_NAMESPACE, NEVO_SOURCE, SNAPSHOT_PATH
from normalize import match_key, normalize_search
from nutrient_map import (
    CANONICAL_CODES,
    CORE_TO_COLUMN,
    map_header,
    sodium_mg_to_salt_g,
)
from portions import load_portion_rules, load_portions, resolve_portion

CORE_CODES = set(CORE_TO_COLUMN) | {"NA"}
_SYNONYM_SPLIT = re.compile(r"[;|,]")
_DASH_SUFFIX = re.compile(r"^([A-Za-zÀ-ÿ]+)-$")


def catalog_id(source: str, key: str) -> str:
    ns = uuid.UUID(CATALOG_NAMESPACE)
    return str(uuid.uuid5(ns, f"{source}:{key}"))


def raw_hash(payload: dict[str, Any]) -> str:
    blob = json.dumps(payload, sort_keys=True, ensure_ascii=True).encode()
    return hashlib.sha256(blob).hexdigest()[:16]


def _num(raw: str) -> float | None:
    s = raw.strip()
    if not s or s in {"-", "NA", "na", "n.b.", "n.a."}:
        return None
    try:
        return float(s.replace(",", "."))
    except ValueError:
        return None


def _detect_delimiter(header: str) -> str:
    counts = {"|": header.count("|"), ";": header.count(";"), ",": header.count(",")}
    return max(counts, key=lambda k: counts[k])


def _read_csv(path: Path) -> tuple[list[str], list[list[str]]]:
    text = path.read_text(encoding="utf-8-sig")
    lines = [ln for ln in text.splitlines() if ln.strip()]
    if not lines:
        raise ValueError("Empty NEVO CSV")
    delim = _detect_delimiter(lines[0])
    reader = csv.reader(io.StringIO("\n".join(lines)), delimiter=delim, quotechar='"')
    rows = [[c.strip() for c in row] for row in reader]
    headers = [h.strip().strip('"') for h in rows[0]]
    return headers, rows[1:]


def dedupe_aliases(aliases: list[str], skip: list[str] | None = None) -> list[str]:
    """Houdt de eerste schrijfwijze per genormaliseerde alias over."""
    seen = {normalize_search(s) for s in (skip or [])}
    seen.discard("")
    out: list[str] = []
    for alias in aliases:
        key = normalize_search(alias)
        if not key or key in seen:
            continue
        seen.add(key)
        out.append(alias)
    return out


def natural_name(name: str) -> str | None:
    """NEVO schrijft 'Melk karne-'; mensen zoeken 'karnemelk'.

    Plakt het streepje-achtervoegsel voor het hoofdwoord. Geeft None als er
    niets te herschikken valt.
    """
    words = name.split()
    if len(words) < 2:
        return None
    head = words[0]
    for idx in range(1, len(words)):
        match = _DASH_SUFFIX.match(words[idx])
        if match is None:
            continue
        modifier = match.group(1)
        rest = words[1:idx] + words[idx + 1 :]
        return " ".join([f"{modifier.lower()}{head.lower()}", *rest])
    return None


def _split_synonyms(raw: str) -> list[str]:
    out: list[str] = []
    seen: set[str] = set()
    for part in _SYNONYM_SPLIT.split(raw):
        name = part.strip().strip('"')
        if not name or name in {"-", "NA"}:
            continue
        key = normalize_search(name)
        if not key or key in seen:
            continue
        seen.add(key)
        out.append(name)
    return out


def parse_nevo_csv(path: Path) -> list[dict[str, Any]]:
    headers, rows = _read_csv(path)
    headers_l = [h.lower() for h in headers]

    def col(*names: str) -> int:
        for name in names:
            for i, h in enumerate(headers_l):
                if name in h:
                    return i
        return -1

    code_i = col("nevo-code", "nevo_code", "nevocode")
    if code_i < 0:
        code_i = col("code")
    name_i = col("voedingsmiddelnaam", "productnaam", "dutch food name")
    if name_i < 0:
        name_i = col("foodname", "food name")
    if name_i < 0:
        name_i = col("name")
    group_i = col("voedingsmiddelgroep", "productgroep", "food group", "foodgroup")
    synonym_i = col("synoniem")
    english_i = col("engelse naam")

    if code_i < 0 or name_i < 0:
        raise ValueError(f"Missing NEVO code/name columns: {headers}")

    skip = {i for i in (code_i, name_i, group_i, synonym_i, english_i) if i >= 0}
    nutrient_cols: list[tuple[int, str]] = []
    for i, header in enumerate(headers):
        if i in skip:
            continue
        ncode = map_header(header)
        if ncode:
            nutrient_cols.append((i, ncode))

    items: list[dict[str, Any]] = []
    for cols in rows:
        name = cols[name_i] if name_i < len(cols) else ""
        code = cols[code_i] if code_i < len(cols) else ""
        if not name or not code:
            continue
        nutrients: dict[str, float] = {}
        for i, ncode in nutrient_cols:
            if i >= len(cols):
                continue
            val = _num(cols[i])
            if val is None:
                continue
            nutrients[ncode] = val
            canon = CANONICAL_CODES.get(ncode)
            if canon and canon not in nutrients:
                nutrients[canon] = val
        if nutrients.get("ENERCC") is None:
            continue
        item = _row_to_product(
            code,
            name,
            cols[group_i] if 0 <= group_i < len(cols) else None,
            nutrients,
        )
        aliases: list[str] = []
        if 0 <= synonym_i < len(cols):
            aliases.extend(_split_synonyms(cols[synonym_i]))
        if 0 <= english_i < len(cols):
            eng = cols[english_i].strip()
            if eng and normalize_search(eng) != normalize_search(name):
                aliases.extend(_split_synonyms(eng))
        # Synoniem- en Engelse kolom overlappen soms; de catalogus heeft een
        # unieke index op (product, genormaliseerde alias).
        aliases = dedupe_aliases(aliases, skip=[name])
        if aliases:
            item["aliases"] = aliases
        items.append(item)
    return items


def _row_to_product(
    code: str,
    name: str,
    group: str | None,
    nutrients: dict[str, float],
) -> dict[str, Any]:
    na = nutrients.get("NA")
    salt = sodium_mg_to_salt_g(na) if na is not None else None
    extra = {k: v for k, v in nutrients.items() if k not in CORE_CODES and v != 0}
    if na is not None and na != 0:
        extra["NA"] = na
    if nutrients.get("ENERC"):
        extra["ENERC"] = nutrients["ENERC"]
    return {
        "id": catalog_id("nevo", code),
        "kind": "generic",
        "source": "nevo",
        "nevoCode": code,
        "name": name,
        "category": group or None,
        "nameNormalized": normalize_search(name),
        "matchKey": match_key(None, name),
        "kcal": nutrients.get("ENERCC", 0),
        "protein": nutrients.get("PROT", 0),
        "carbs": nutrients.get("CHO", 0),
        "fat": nutrients.get("FAT", 0),
        "fiber": nutrients.get("FIBT"),
        "sugars": nutrients.get("SUGAR"),
        "satFat": nutrients.get("FASAT"),
        "salt": salt,
        "alcohol": nutrients.get("ALC"),
        "nutrients": extra,
        "qualityScore": 100,
        "nlRelevance": 100,
        "popularity": 0,
        "rawHash": raw_hash(nutrients),
    }


def apply_portions_and_aliases(items: list[dict[str, Any]]) -> list[dict[str, Any]]:
    portions = load_portions()
    rules = load_portion_rules()
    aliases = load_aliases()
    by_code = {item["nevoCode"]: item for item in items}
    for item in items:
        portion = resolve_portion(item["name"], item.get("category"), rules)
        if portion is not None:
            item["servingG"] = portion["grams"]
            item["servingLabel"] = portion["label"]
        natural = natural_name(item["name"])
        if natural:
            merged = dedupe_aliases(
                [*(item.get("aliases") or []), natural],
                skip=[item["name"]],
            )
            if merged:
                item["aliases"] = merged
    for code, portion in portions.items():
        item = by_code.get(code)
        if item is None:
            continue
        item["servingG"] = portion["grams"]
        item["servingLabel"] = portion["label"]
    for code, names in aliases.items():
        item = by_code.get(code)
        if item is None:
            continue
        item["aliases"] = dedupe_aliases(
            [*(item.get("aliases") or []), *names],
            skip=[item["name"]],
        )
    return items


def parse_nevo_recipes(path: Path) -> list[dict[str, Any]]:
    headers, rows = _read_csv(path)
    headers_l = [h.lower() for h in headers]

    def col(*names: str) -> int:
        for name in names:
            for i, h in enumerate(headers_l):
                if name in h:
                    return i
        return -1

    product_i = col("nevo-code")
    ingr_i = col("ingr_nevo-code", "ingr_nevo")
    amount_i = col("ingr_relatieve", "relative_amount")
    ingr_name_i = col("ingr_voedingsmiddel")
    if product_i < 0 or ingr_i < 0 or amount_i < 0:
        raise ValueError(f"Missing recipe columns: {headers}")
    out: list[dict[str, Any]] = []
    for cols in rows:
        product = cols[product_i] if product_i < len(cols) else ""
        ingredient = cols[ingr_i] if ingr_i < len(cols) else ""
        amount = _num(cols[amount_i]) if amount_i < len(cols) else None
        if not product or not ingredient or amount is None:
            continue
        name = cols[ingr_name_i] if 0 <= ingr_name_i < len(cols) else ""
        out.append(
            {
                "product_nevo_code": product,
                "ingredient_nevo_code": ingredient,
                "relative_amount": amount,
                "ingredient_name": name or None,
            }
        )
    return out


def from_legacy_snapshot(path: Path) -> list[dict[str, Any]]:
    data = json.loads(path.read_text(encoding="utf-8"))
    items: list[dict[str, Any]] = []
    for raw in data.get("items", []):
        code = str(raw.get("code") or raw.get("nevoCode"))
        name = raw["name"]
        nutrients = dict(raw.get("nutrients") or {})
        item = {
            "id": raw.get("id") or catalog_id("nevo", code),
            "kind": raw.get("kind") or "generic",
            "source": raw.get("source") or "nevo",
            "nevoCode": code,
            "name": name,
            "category": raw.get("category") or raw.get("group"),
            "nameNormalized": raw.get("nameNormalized") or normalize_search(name),
            "matchKey": raw.get("matchKey") or match_key(None, name),
            "kcal": raw["kcal"],
            "protein": raw.get("protein") or 0,
            "carbs": raw.get("carbs") or 0,
            "fat": raw.get("fat") or 0,
            "fiber": raw.get("fiber"),
            "sugars": raw.get("sugars"),
            "satFat": raw.get("satFat"),
            "salt": raw.get("salt"),
            "alcohol": raw.get("alcohol"),
            "nutrients": nutrients,
            "servingG": raw.get("servingG"),
            "servingLabel": raw.get("servingLabel"),
            "qualityScore": raw.get("qualityScore") or 100,
            "nlRelevance": raw.get("nlRelevance") or 100,
            "popularity": raw.get("popularity") or 0,
        }
        items.append(item)
    return apply_portions_and_aliases(items)


def write_snapshot(
    items: list[dict[str, Any]],
    dest: Path | None = None,
    version: str = "2025/9.0",
    catalog_version: int = 2,
) -> Path:
    dest = dest or SNAPSHOT_PATH
    dest.parent.mkdir(parents=True, exist_ok=True)
    payload = {
        "version": version,
        "source": NEVO_SOURCE,
        "catalogVersion": catalog_version,
        # Verandert zodra de inhoud verandert (porties, aliassen, correcties),
        # ook als de NEVO-versie gelijk blijft. De app herimporteert daarop.
        "revision": raw_hash({"items": items}),
        "items": items,
    }
    dest.write_text(json.dumps(payload, ensure_ascii=False, separators=(",", ":")), encoding="utf-8")
    return dest
