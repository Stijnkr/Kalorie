"""Name / brand / barcode normalisation. Keep in sync with lib/data/food/match_key.dart."""

from __future__ import annotations

import re
import unicodedata

_PUNCT = re.compile(r"[®™©'’\".,;:/+&()\[\]{}!?\\-]+")
_SIZE = re.compile(
    r"\b\d+(?:[.,]\d+)?\s*(?:mg|g|kg|ml|cl|l|stuks?|st)\b",
    re.IGNORECASE,
)
_WS = re.compile(r"\s+")
_STOP = frozenset({"de", "het", "een", "en", "van", "met", "voor", "vers"})
_NON_DIGIT = re.compile(r"\D+")


def unaccent(text: str) -> str:
    nfkd = unicodedata.normalize("NFKD", text)
    return "".join(ch for ch in nfkd if not unicodedata.combining(ch))


def normalize_search(text: str) -> str:
    """Lower, unaccent, strip punctuation. Keeps all tokens — used for search."""
    s = unaccent(text.strip().lower())
    s = _PUNCT.sub(" ", s)
    s = _WS.sub(" ", s).strip()
    return s


def normalize_match(text: str) -> str:
    """Search-normalise plus drop pack sizes and stopwords — used for match_key."""
    s = normalize_search(text)
    s = _SIZE.sub(" ", s)
    s = _WS.sub(" ", s).strip()
    tokens = [t for t in s.split(" ") if t and t not in _STOP]
    return " ".join(tokens)


def match_key(brand: str | None, name: str) -> str:
    n = normalize_match(name)
    b = normalize_match(brand or "")
    if not b:
        return n
    return f"{b}|{n}"


def normalize_barcode(code: str | None) -> str | None:
    if not code:
        return None
    digits = _NON_DIGIT.sub("", code)
    if len(digits) == 12:
        digits = "0" + digits
    if 8 <= len(digits) <= 14:
        return digits
    return None
