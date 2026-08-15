from pathlib import Path

ROOT = Path(__file__).resolve().parents[2]
TOOL_DIR = Path(__file__).resolve().parent
DATA_DIR = TOOL_DIR / "data"
ASSETS_FOOD = ROOT / "assets" / "food"
NUTRIENT_DEFS_PATH = ASSETS_FOOD / "nutrient_defs.json"
SNAPSHOT_PATH = ASSETS_FOOD / "nevo_snapshot.min.json"

# uuid5 namespace (OID) — same string as Dart Uuid.NAMESPACE_OID
CATALOG_NAMESPACE = "6ba7b812-9dad-11d1-80b3-00c04fd430c8"

QUALITY_REJECT_BELOW = 55
OFF_MAX_PUBLISHED = 25000

NEVO_SOURCE = "NEVO online, version 2025/9.0. RIVM, Bilthoven."
