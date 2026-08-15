from __future__ import annotations

from pathlib import Path

from config import SNAPSHOT_PATH
from nevo_import import from_legacy_snapshot, write_snapshot


def snapshot_from_legacy(legacy: Path, dest: Path | None = None) -> Path:
    items = from_legacy_snapshot(legacy)
    return write_snapshot(items, dest or SNAPSHOT_PATH)
