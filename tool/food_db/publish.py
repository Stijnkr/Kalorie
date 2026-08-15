from __future__ import annotations

import os
from typing import Any

from datetime import datetime, timezone

from config import NEVO_SOURCE, TOOL_DIR
from normalize import normalize_barcode, normalize_search

ENV_PATH = TOOL_DIR / ".env"


def _load_env() -> None:
    """Leest tool/food_db/.env (gitignored) zodat de service-role key niet in de
    shell-history of in een commando belandt."""
    if not ENV_PATH.exists():
        return
    for line in ENV_PATH.read_text(encoding="utf-8").splitlines():
        line = line.strip()
        if not line or line.startswith("#") or "=" not in line:
            continue
        name, _, value = line.partition("=")
        os.environ.setdefault(name.strip(), value.strip().strip("'\""))


def _client():
    _load_env()
    url = os.environ.get("SUPABASE_URL")
    key = os.environ.get("SUPABASE_SERVICE_ROLE_KEY")
    if not url or not key:
        raise SystemExit(
            "Zet SUPABASE_URL en SUPABASE_SERVICE_ROLE_KEY in de omgeving of in "
            f"{ENV_PATH}."
        )
    from supabase import create_client

    return create_client(url, key)


def to_row(item: dict[str, Any], data_version: int) -> dict[str, Any]:
    return {
        "id": item["id"],
        "kind": item.get("kind") or "generic",
        "source_primary": item.get("source") or "nevo",
        "nevo_code": item.get("nevoCode"),
        "off_id": item.get("offId"),
        "name": item["name"],
        "brand": item.get("brand"),
        "category": item.get("category"),
        "name_normalized": item.get("nameNormalized") or normalize_search(item["name"]),
        "brand_normalized": item.get("brandNormalized"),
        "match_key": item.get("matchKey"),
        "energy_kcal_100g": item["kcal"],
        "protein_100g": item.get("protein") or 0,
        "carbs_100g": item.get("carbs") or 0,
        "fat_100g": item.get("fat") or 0,
        "fiber_100g": item.get("fiber"),
        "sugars_100g": item.get("sugars"),
        "sat_fat_100g": item.get("satFat"),
        "salt_100g": item.get("salt"),
        "alcohol_100g": item.get("alcohol"),
        "nutrients": item.get("nutrients") or {},
        "quality_score": item.get("qualityScore") or 0,
        "popularity": item.get("popularity") or 0,
        "nl_relevance": item.get("nlRelevance") or 0,
        "is_published": True,
        "data_version": data_version,
    }


def publish_products(items: list[dict[str, Any]], nevo_version: str | None = None) -> int:
    sb = _client()
    meta = sb.table("catalog_meta").select("version").eq("id", 1).single().execute()
    version = int(meta.data["version"]) + 1
    rows = [to_row(item, version) for item in items]
    for i in range(0, len(rows), 200):
        chunk = rows[i : i + 200]
        sb.table("products").upsert(chunk, on_conflict="id").execute()
        barcodes = []
        portions = []
        aliases = []
        for item in items[i : i + 200]:
            code = normalize_barcode(item.get("barcode"))
            if code:
                barcodes.append({"barcode": code, "product_id": item["id"], "is_primary": True})
            if item.get("servingG") and item.get("servingLabel"):
                portions.append(
                    {
                        "product_id": item["id"],
                        "label": item["servingLabel"],
                        "grams": item["servingG"],
                        "is_default": True,
                        "source": item.get("source") or "kalorie",
                    }
                )
            # Postgres weigert een upsert waarin dezelfde unieke sleutel twee
            # keer voorkomt, dus per product ontdubbelen op de genormaliseerde
            # vorm ("hüttenkäse" en "huttenkase" zijn één rij).
            seen: set[str] = set()
            for alias in item.get("aliases") or []:
                key = normalize_search(alias)
                if not key or key in seen:
                    continue
                seen.add(key)
                aliases.append(
                    {
                        "product_id": item["id"],
                        "alias": alias,
                        "alias_normalized": key,
                        "source": "kalorie",
                    }
                )
        if barcodes:
            sb.table("product_barcodes").upsert(barcodes, on_conflict="barcode").execute()
        if portions:
            # Één default per product is een partial unique index. Verandert een
            # label tussen twee runs, dan botst de nieuwe rij met de oude, dus
            # eerst de bestaande default weg.
            sb.table("product_portions").delete().eq("is_default", True).in_(
                "product_id", [p["product_id"] for p in portions]
            ).execute()
            sb.table("product_portions").upsert(portions, on_conflict="product_id,label").execute()
        if aliases:
            # De overlay is leidend: eerst weg wat er staat, dan de huidige set
            # terug. Zonder dit blijven aliassen van een vorige run rondslingeren.
            sb.table("product_aliases").delete().in_(
                "product_id", sorted({a["product_id"] for a in aliases})
            ).execute()
            sb.table("product_aliases").upsert(aliases, on_conflict="product_id,alias_normalized").execute()
    sb.table("catalog_meta").update(
        {
            "version": version,
            "nevo_version": nevo_version or NEVO_SOURCE,
            "product_count": len(items),
            "published_at": datetime.now(timezone.utc).isoformat(),
        }
    ).eq("id", 1).execute()
    return version
