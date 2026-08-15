from __future__ import annotations

import json
import re
from functools import lru_cache

from config import NUTRIENT_DEFS_PATH

CORE_TO_COLUMN = {
    "ENERCC": "energy_kcal_100g",
    "PROT": "protein_100g",
    "CHO": "carbs_100g",
    "FAT": "fat_100g",
    "FIBT": "fiber_100g",
    "SUGAR": "sugars_100g",
    "FASAT": "sat_fat_100g",
    "ALC": "alcohol_100g",
}

# Official NEVO codes → our nutrient_defs codes (store both).
CANONICAL_CODES: dict[str, str] = {
    "ENERCJ": "ENERC",
    "FATRS": "FATRN",
    "CHORL": "CHOLE",
    "VITA_RAE": "VITA",
    "CARTBTOT": "CARTB",
}

_HEADER_CODE = re.compile(r"^([A-Za-z][A-Za-z0-9:]*)\s*\(")

# NEVO header fragments → component code (lowercase contains-match, longest first)
HEADER_ALIASES: dict[str, str] = {
    "enercc (kcal)": "ENERCC",
    "enercc_kcal": "ENERCC",
    "enercc": "ENERCC",
    "enerc (kj)": "ENERC",
    "enerc_kj": "ENERC",
    "protpl": "PROTPL",
    "protan": "PROTAN",
    "prot": "PROT",
    "fams cis": "FAMSCIS",
    "famscis": "FAMSCIS",
    "fapun3": "FAPUN3",
    "fapun6": "FAPUN6",
    "fasat": "FASAT",
    "fatrn": "FATRN",
    "fapu": "FAPU",
    "fa18:2cn6": "FA18:2CN6",
    "fa18:3cn3": "FA18:3CN3",
    "fa20:5cn3": "FA20:5CN3",
    "fa22:6cn3": "FA22:6CN3",
    "fibt": "FIBT",
    "sugar": "SUGAR",
    "starch": "STARCH",
    "chole": "CHOLE",
    "water": "WATER",
    "nhaem": "NHAEM",
    "haem": "HAEM",
    "cartbeq": "CARTBEQ",
    "cartb": "CARTB",
    "retol": "RETOL",
    "niaeq": "NIAEQ",
    "folfd": "FOLFD",
    "folac": "FOLAC",
    "vitb12": "VITB12",
    "vitb6": "VITB6",
    "vita": "VITA",
    "vitd": "VITD",
    "vite": "VITE",
    "vitk": "VITK",
    "vitc": "VITC",
    "thia": "THIA",
    "ribf": "RIBF",
    "nia": "NIA",
    "fol": "FOL",
    "cho": "CHO",
    "fat": "FAT",
    "alc": "ALC",
    "ash": "ASH",
    "frus": "FRUS",
    "glus": "GLUS",
    "sucs": "SUCS",
    "lacs": "LACS",
}


@lru_cache(maxsize=1)
def load_defs() -> list[dict]:
    data = json.loads(NUTRIENT_DEFS_PATH.read_text(encoding="utf-8"))
    return list(data["items"])


def known_codes() -> set[str]:
    return {item["code"] for item in load_defs()}


def map_header(header: str) -> str | None:
    h = header.strip().strip('"')
    m = _HEADER_CODE.match(h)
    if m:
        return m.group(1).upper()
    hl = h.lower()
    for fragment, code in sorted(HEADER_ALIASES.items(), key=lambda kv: -len(kv[0])):
        if fragment in hl:
            return code
    for code in known_codes():
        token = code.lower()
        if hl == token or hl.startswith(token + " ") or hl.startswith(token + "("):
            return code
    return None


def canonical_code(code: str) -> str:
    return CANONICAL_CODES.get(code, code)


def sodium_mg_to_salt_g(na_mg: float) -> float:
    return round(na_mg * 2.5 / 1000.0, 4)
