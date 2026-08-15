from __future__ import annotations

import re
from pathlib import Path
from typing import NamedTuple

from config import DATA_DIR
from csvfile import read_rows

PORTIONS_PATH = DATA_DIR / "portions.csv"
PORTION_RULES_PATH = DATA_DIR / "portion_rules.csv"


class PortionRule(NamedTuple):
    category: str
    pattern: re.Pattern[str] | None
    label: str
    grams: float


def load_portions(path: Path | None = None) -> dict[str, dict]:
    """Exact portions per NEVO code. Beats every rule."""
    file = path or PORTIONS_PATH
    if not file.exists():
        return {}
    out: dict[str, dict] = {}
    for row in read_rows(file):
        code = (row.get("nevo_code") or "").strip()
        if not code:
            continue
        grams = float(row["grams"].replace(",", "."))
        out[code] = {"label": row["label"].strip(), "grams": grams}
    return out


def load_portion_rules(path: Path | None = None) -> list[PortionRule]:
    """Category defaults, in file order. An empty pattern matches the whole group."""
    file = path or PORTION_RULES_PATH
    if not file.exists():
        return []
    rules: list[PortionRule] = []
    for row in read_rows(file):
        category = (row.get("category") or "").strip()
        if not category:
            continue
        raw = (row.get("pattern") or "").strip()
        rules.append(
            PortionRule(
                category=category,
                pattern=re.compile(raw, re.IGNORECASE) if raw else None,
                label=row["label"].strip(),
                grams=float(row["grams"].replace(",", ".")),
            )
        )
    return rules


def resolve_portion(
    name: str,
    category: str | None,
    rules: list[PortionRule],
) -> dict | None:
    if not category:
        return None
    for rule in rules:
        if rule.category != category:
            continue
        if rule.pattern is None or rule.pattern.search(name):
            return {"label": rule.label, "grams": rule.grams}
    return None
