from __future__ import annotations

import csv
from pathlib import Path
from typing import Iterator


def read_rows(path: Path) -> Iterator[dict[str, str]]:
    """DictReader die #-commentaarregels overslaat, zodat de overlay-CSV's
    uitleg kunnen bevatten."""
    with path.open(encoding="utf-8") as fh:
        lines = [line for line in fh if not line.lstrip().startswith("#")]
    yield from csv.DictReader(lines)
