from __future__ import annotations

from collections import defaultdict
from typing import Any

from rapidfuzz import fuzz

from normalize import normalize_barcode

FUZZY_THRESHOLD = 92


def dedupe_branded(items: list[dict[str, Any]]) -> tuple[list[dict[str, Any]], list[dict[str, Any]]]:
    """Keep one row per barcode / match_key. Fuzzy pairs go to the candidate list."""
    by_barcode: dict[str, dict[str, Any]] = {}
    no_code: list[dict[str, Any]] = []
    for item in items:
        code = normalize_barcode(item.get("barcode"))
        if not code:
            no_code.append(item)
            continue
        existing = by_barcode.get(code)
        if existing is None or item.get("qualityScore", 0) > existing.get("qualityScore", 0):
            by_barcode[code] = item

    by_key: dict[str, dict[str, Any]] = {}
    for item in list(by_barcode.values()) + no_code:
        key = item.get("matchKey") or ""
        if not key:
            by_key[id(item)] = item  # type: ignore[index]
            continue
        existing = by_key.get(key)
        if existing is None or item.get("qualityScore", 0) > existing.get("qualityScore", 0):
            by_key[key] = item

    unique = list(by_key.values())
    candidates: list[dict[str, Any]] = []
    # Light fuzzy pass on same-brand pairs only
    grouped: dict[str, list[dict[str, Any]]] = defaultdict(list)
    for item in unique:
        brand = (item.get("brandNormalized") or "")
        if brand:
            grouped[brand].append(item)
    for brand_items in grouped.values():
        if len(brand_items) < 2:
            continue
        for i, a in enumerate(brand_items):
            for b in brand_items[i + 1 :]:
                sim = fuzz.token_set_ratio(a.get("nameNormalized") or "", b.get("nameNormalized") or "")
                if sim < FUZZY_THRESHOLD:
                    continue
                ka, kb = a.get("kcal") or 0, b.get("kcal") or 0
                if ka and abs(ka - kb) / max(ka, 1) > 0.10:
                    continue
                candidates.append(
                    {
                        "reason": "fuzzy",
                        "similarity": round(sim / 100, 4),
                        "a": a.get("offId") or a.get("barcode"),
                        "b": b.get("offId") or b.get("barcode"),
                    }
                )
    return unique, candidates
