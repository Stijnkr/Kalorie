class QualityInput {
  const QualityInput({
    required this.name,
    this.brand,
    this.kcal,
    this.protein,
    this.carbs,
    this.fat,
    this.fiber,
    this.sugars,
    this.salt,
    this.alcohol,
    this.hasDutchName = false,
    this.countryNl = false,
    this.countryBe = false,
    this.hasServing = false,
    this.hasNutriscore = false,
    this.completeness,
  });

  final String name;
  final String? brand;
  final double? kcal;
  final double? protein;
  final double? carbs;
  final double? fat;
  final double? fiber;
  final double? sugars;
  final double? salt;
  final double? alcohol;
  final bool hasDutchName;
  final bool countryNl;
  final bool countryBe;
  final bool hasServing;
  final bool hasNutriscore;
  final double? completeness;
}

class QualityResult {
  const QualityResult(this.score, this.reject, this.reasons);

  final int score;
  final bool reject;
  final List<String> reasons;
}

const qualityRejectBelow = 55;

double atwaterKcal(double protein, double carbs, double fat, [double alcohol = 0]) =>
    4 * protein + 4 * carbs + 9 * fat + 7 * alcohol;

const _genericNames = {
  'appel',
  'banaan',
  'brood',
  'ei',
  'melk',
  'rijst',
  'water',
  'kaas',
  'yoghurt',
  'kip',
  'pasta',
  'aardappel',
  'boter',
  'suiker',
};

QualityResult scoreQuality(QualityInput inp) {
  final reasons = <String>[];
  if (inp.kcal == null ||
      inp.protein == null ||
      inp.carbs == null ||
      inp.fat == null) {
    return const QualityResult(0, true, ['missing_macros']);
  }
  if (inp.kcal! < 0 || inp.protein! < 0 || inp.carbs! < 0 || inp.fat! < 0) {
    return const QualityResult(0, true, ['negative_macros']);
  }
  if (inp.name.trim().isEmpty) {
    return const QualityResult(0, true, ['empty_name']);
  }
  if (inp.kcal == 0 && (inp.protein! + inp.carbs! + inp.fat!) > 1) {
    return const QualityResult(0, true, ['kcal_zero_with_macros']);
  }

  var points = 25;
  final alcohol = inp.alcohol ?? 0;
  final expected = atwaterKcal(inp.protein!, inp.carbs!, inp.fat!, alcohol);
  if (expected <= 0 || inp.kcal == 0) {
    if (inp.kcal == 0 && expected <= 1) {
      points += 15;
    } else {
      reasons.add('atwater_skip');
    }
  } else {
    final delta = (inp.kcal! - expected).abs() / (expected < 1 ? 1 : expected);
    if (delta <= 0.20) {
      points += 15;
    } else {
      reasons.add('atwater_off');
    }
  }

  if (inp.fiber != null && inp.sugars != null && inp.salt != null) {
    points += 10;
  }
  if (inp.hasDutchName) points += 10;
  if (inp.countryNl) {
    points += 10;
  } else if (inp.countryBe) {
    points += 6;
  }
  final brand = inp.brand?.trim().toLowerCase();
  if (brand != null && brand.isNotEmpty && brand != 'unknown' && brand != '-') {
    points += 8;
  }
  if (inp.hasServing) points += 7;
  if (inp.hasNutriscore) points += 5;
  if (inp.completeness != null && inp.completeness! >= 0.6) points += 5;

  if (_genericNames.contains(inp.name.trim().toLowerCase()) &&
      (inp.brand == null || inp.brand!.trim().isEmpty)) {
    points -= 15;
    reasons.add('generic_name');
  }

  final clamped = points.clamp(0, 100);
  final reject = clamped < qualityRejectBelow;
  if (reject) reasons.add('below_threshold');
  return QualityResult(clamped, reject, reasons);
}

int nlRelevance({required bool countryNl, required bool countryBe}) {
  if (countryNl) return 100;
  if (countryBe) return 70;
  return 0;
}
