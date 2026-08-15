from __future__ import annotations

import json
from pathlib import Path
from typing import Any

from config import OFF_MAX_PUBLISHED, QUALITY_REJECT_BELOW
from normalize import match_key, normalize_barcode, normalize_search
from nutrient_map import sodium_mg_to_salt_g
from quality import QualityInput, nl_relevance, score

EXCLUDE_CATEGORIES = {
    "en:non-food-products",
    "en:open-beauty-facts",
    "en:dietary-supplements",
    "en:vitamins",
}


def _nutr(n: dict, *keys: str) -> float | None:
    for key in keys:
        val = n.get(key)
        if val is None:
            continue
        try:
            return float(val)
        except (TypeError, ValueError):
            continue
    return None


def map_off_product(raw: dict[str, Any]) -> dict[str, Any] | None:
    tags = raw.get("countries_tags") or []
    country_nl = "en:netherlands" in tags
    country_be = "en:belgium" in tags
    if not country_nl:
        return None

    barcode = normalize_barcode(str(raw.get("code") or raw.get("_id") or ""))
    if not barcode:
        return None

    cats = set(raw.get("categories_tags") or [])
    if cats & EXCLUDE_CATEGORIES:
        return None

    name_nl = (raw.get("product_name_nl") or "").strip()
    name = name_nl or (raw.get("product_name") or "").strip()
    if not name:
        return None

    nutr = raw.get("nutriments") or {}
    kcal = _nutr(nutr, "energy-kcal_100g", "energy-kcal")
    if kcal is None:
        kj = _nutr(nutr, "energy-kj_100g", "energy-kj", "energy_100g")
        if kj is not None:
            kcal = kj / 4.184
    protein = _nutr(nutr, "proteins_100g")
    carbs = _nutr(nutr, "carbohydrates_100g")
    fat = _nutr(nutr, "fat_100g")
    if kcal is None or protein is None or carbs is None or fat is None:
        return None

    fiber = _nutr(nutr, "fiber_100g")
    sugars = _nutr(nutr, "sugars_100g")
    sat_fat = _nutr(nutr, "saturated-fat_100g")
    salt = _nutr(nutr, "salt_100g")
    sodium = _nutr(nutr, "sodium_100g")
    if salt is None and sodium is not None:
        salt = sodium * 2.5
    alcohol = _nutr(nutr, "alcohol_100g", "alcohol")
    serving = raw.get("serving_quantity")
    has_serving = False
    serving_g = None
    try:
        if serving is not None and 0 < float(serving) <= 2000:
            serving_g = float(serving)
            has_serving = True
    except (TypeError, ValueError):
        pass

    brand = (raw.get("brands") or "").split(",")[0].strip() or None
    q = score(
        QualityInput(
            name=name,
            brand=brand,
            barcode=barcode,
            kcal=kcal,
            protein=protein,
            carbs=carbs,
            fat=fat,
            fiber=fiber,
            sugars=sugars,
            salt=salt,
            alcohol=alcohol,
            has_dutch_name=bool(name_nl),
            country_nl=country_nl,
            country_be=country_be,
            has_serving=has_serving,
            has_nutriscore=bool(raw.get("nutriscore_grade")),
            completeness=raw.get("completeness"),
        )
    )
    if q.reject or q.score < QUALITY_REJECT_BELOW:
        return None

    extra: dict[str, float] = {}
    na_mg = None
    if sodium is not None:
        na_mg = sodium * 1000
        extra["NA"] = round(na_mg, 2)
    elif salt is not None:
        extra["NA"] = round(salt / 2.5 * 1000, 2)

    return {
        "kind": "branded",
        "source": "off",
        "offId": str(raw.get("_id") or barcode),
        "barcode": barcode,
        "name": name,
        "brand": brand,
        "category": (raw.get("categories_old") or raw.get("categories") or "").split(",")[0].strip() or None,
        "nameNormalized": normalize_search(name),
        "brandNormalized": normalize_search(brand) if brand else None,
        "matchKey": match_key(brand, name),
        "kcal": round(kcal, 2),
        "protein": round(protein, 2),
        "carbs": round(carbs, 2),
        "fat": round(fat, 2),
        "fiber": fiber,
        "sugars": sugars,
        "satFat": sat_fat,
        "salt": salt if salt is not None else (sodium_mg_to_salt_g(na_mg) if na_mg is not None else None),
        "alcohol": alcohol,
        "nutrients": extra,
        "servingG": serving_g,
        "servingLabel": "1 portie" if serving_g else None,
        "qualityScore": q.score,
        "nlRelevance": nl_relevance(country_nl, country_be),
        "popularity": 0,
    }


def import_jsonl(path: Path, limit: int | None = None) -> tuple[list[dict[str, Any]], int]:
    kept: list[dict[str, Any]] = []
    seen = 0
    with path.open(encoding="utf-8") as fh:
        for line in fh:
            line = line.strip()
            if not line:
                continue
            seen += 1
            try:
                raw = json.loads(line)
            except json.JSONDecodeError:
                continue
            mapped = map_off_product(raw)
            if mapped is None:
                continue
            kept.append(mapped)
            if limit and len(kept) >= limit:
                break
    kept.sort(key=lambda p: (p["qualityScore"] * p["nlRelevance"], p["qualityScore"]), reverse=True)
    return kept[:OFF_MAX_PUBLISHED], seen
