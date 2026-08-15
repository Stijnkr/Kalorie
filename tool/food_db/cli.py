from __future__ import annotations

import argparse
import json
import sys
from pathlib import Path

DIR = Path(__file__).resolve().parent
if str(DIR) not in sys.path:
    sys.path.insert(0, str(DIR))

from config import SNAPSHOT_PATH  # noqa: E402
from nevo_import import apply_portions_and_aliases, parse_nevo_csv, write_snapshot  # noqa: E402
from snapshot import snapshot_from_legacy  # noqa: E402


def main() -> None:
    parser = argparse.ArgumentParser(prog="food_db", description="Kalorie food catalog pipeline")
    sub = parser.add_subparsers(dest="cmd", required=True)

    nevo = sub.add_parser("nevo-import", help="Import a NEVO CSV and write the app snapshot")
    nevo.add_argument("csv", type=Path)
    nevo.add_argument("--out", type=Path, default=SNAPSHOT_PATH)
    nevo.add_argument("--version", default="2025/9.0")

    snap = sub.add_parser("snapshot", help="Convert the bundled legacy NEVO JSON to the catalog snapshot")
    snap.add_argument("--from-legacy", type=Path, required=True)
    snap.add_argument("--out", type=Path, default=SNAPSHOT_PATH)

    off = sub.add_parser("off-import", help="Filter an Open Food Facts JSONL dump")
    off.add_argument("jsonl", type=Path)
    off.add_argument("--out", type=Path, default=DIR / "data" / "off_filtered.json")
    off.add_argument("--limit", type=int, default=None)

    pub = sub.add_parser("publish", help="Upsert snapshot products to Supabase")
    pub.add_argument("--file", type=Path, default=SNAPSHOT_PATH)

    args = parser.parse_args()
    if args.cmd == "nevo-import":
        items = apply_portions_and_aliases(parse_nevo_csv(args.csv))
        dest = write_snapshot(items, args.out, version=args.version)
        print(f"Wrote {len(items)} NEVO products to {dest}")
    elif args.cmd == "snapshot":
        dest = snapshot_from_legacy(args.from_legacy, args.out)
        data = json.loads(dest.read_text(encoding="utf-8"))
        print(f"Wrote {len(data['items'])} products to {dest}")
    elif args.cmd == "off-import":
        from dedupe import dedupe_branded
        from off_import import import_jsonl

        kept, seen = import_jsonl(args.jsonl, limit=args.limit)
        unique, candidates = dedupe_branded(kept)
        args.out.parent.mkdir(parents=True, exist_ok=True)
        args.out.write_text(json.dumps({"items": unique, "candidates": candidates}, ensure_ascii=False), encoding="utf-8")
        print(f"Read {seen}, kept {len(unique)}, fuzzy candidates {len(candidates)} → {args.out}")
    elif args.cmd == "publish":
        from publish import publish_products

        payload = json.loads(args.file.read_text(encoding="utf-8"))
        version = publish_products(payload["items"], payload.get("version"))
        # De snapshot bevat dezelfde rijen als de cloud, dus die staat per
        # definitie op de zojuist gepubliceerde versie. Zonder dit denkt de app
        # dat hij achterloopt en haalt hij de hele catalogus nog een keer op.
        if payload.get("catalogVersion") != version:
            payload["catalogVersion"] = version
            args.file.write_text(
                json.dumps(payload, ensure_ascii=False, separators=(",", ":")),
                encoding="utf-8",
            )
        print(f"Published {len(payload['items'])} products as catalog version {version}")


if __name__ == "__main__":
    main()
