from __future__ import annotations

import csv
from collections import defaultdict
from pathlib import Path

from config import DATA_DIR
from csvfile import read_rows

ALIASES_PATH = DATA_DIR / "aliases.csv"


def load_aliases(path: Path | None = None) -> dict[str, list[str]]:
    file = path or ALIASES_PATH
    if not file.exists():
        return {}
    out: dict[str, list[str]] = defaultdict(list)
    for row in read_rows(file):
        code = (row.get("nevo_code") or "").strip()
        alias = (row.get("alias") or "").strip()
        if code and alias:
            out[code].append(alias)
    return dict(out)
