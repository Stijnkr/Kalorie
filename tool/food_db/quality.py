"""Quality score for catalog products. Keep in sync with lib/data/food/quality.dart."""

from __future__ import annotations

from dataclasses import dataclass, field

REJECT_BELOW = 55


@dataclass
class QualityInput:
    name: str
    brand: str | None = None
    barcode: str | None = None
    kcal: float | None = None
    protein: float | None = None
    carbs: float | None = None
    fat: float | None = None
    fiber: float | None = None
    sugars: float | None = None
    salt: float | None = None
    alcohol: float | None = None
    has_dutch_name: bool = False
    country_nl: bool = False
    country_be: bool = False
    has_serving: bool = False
    has_nutriscore: bool = False
    completeness: float | None = None


@dataclass
class QualityResult:
    score: int
    reject: bool
    reasons: list[str] = field(default_factory=list)


def atwater_kcal(protein: float, carbs: float, fat: float, alcohol: float = 0) -> float:
    return 4 * protein + 4 * carbs + 9 * fat + 7 * alcohol


def score(inp: QualityInput) -> QualityResult:
    reasons: list[str] = []
    points = 0

    if inp.kcal is None or inp.protein is None or inp.carbs is None or inp.fat is None:
        return QualityResult(0, True, ["missing_macros"])
    if inp.kcal < 0 or inp.protein < 0 or inp.carbs < 0 or inp.fat < 0:
        return QualityResult(0, True, ["negative_macros"])
    if not inp.name.strip():
        return QualityResult(0, True, ["empty_name"])

    if inp.kcal == 0 and (inp.protein + inp.carbs + inp.fat) > 1:
        return QualityResult(0, True, ["kcal_zero_with_macros"])

    points += 25
    alcohol = inp.alcohol or 0
    expected = atwater_kcal(inp.protein, inp.carbs, inp.fat, alcohol)
    if expected <= 0 or inp.kcal == 0:
        if inp.kcal == 0 and expected <= 1:
            points += 15
        else:
            reasons.append("atwater_skip")
    else:
        delta = abs(inp.kcal - expected) / max(expected, 1)
        if delta <= 0.20:
            points += 15
        else:
            reasons.append("atwater_off")

    if inp.fiber is not None and inp.sugars is not None and inp.salt is not None:
        points += 10

    if inp.has_dutch_name:
        points += 10
    if inp.country_nl:
        points += 10
    elif inp.country_be:
        points += 6

    if inp.brand and inp.brand.strip().lower() not in {"unknown", "?", "-"}:
        points += 8
    if inp.has_serving:
        points += 7
    if inp.has_nutriscore:
        points += 5
    if inp.completeness is not None and inp.completeness >= 0.6:
        points += 5

    generic = _looks_generic(inp.name, inp.brand)
    if generic:
        points -= 15
        reasons.append("generic_name")

    score_clamped = max(0, min(100, points))
    reject = score_clamped < REJECT_BELOW
    if reject:
        reasons.append("below_threshold")
    return QualityResult(score_clamped, reject, reasons)


def nl_relevance(country_nl: bool, country_be: bool) -> int:
    if country_nl:
        return 100
    if country_be:
        return 70
    return 0


_GENERIC_NAMES = frozenset(
    {
        "appel",
        "banaan",
        "brood",
        "ei",
        "melk",
        "rijst",
        "water",
        "kaas",
        "yoghurt",
        "kip",
        "pasta",
        "aardappel",
        "boter",
        "suiker",
    }
)


def _looks_generic(name: str, brand: str | None) -> bool:
    n = name.strip().lower()
    if n in _GENERIC_NAMES and not (brand and brand.strip()):
        return True
    return False
