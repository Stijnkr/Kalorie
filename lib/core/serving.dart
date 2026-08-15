class HouseholdPortion {
  const HouseholdPortion({
    required this.label,
    required this.grams,
    this.liquid = false,
  });

  /// Korte naam zonder aantal: `glas`, `snee`, `eetlepel`.
  final String label;
  final double grams;
  final bool liquid;

  String get unit => liquid ? 'ml' : 'g';

  String get chipLabel => '1 $label';

  String get chipDetail =>
      '$chipLabel (${grams.round()} $unit)';
}

/// Nederlandse huishoudmaten (Voedingscentrum / NEVO-gebruik).
const dutchPortions = <HouseholdPortion>[
  HouseholdPortion(label: 'theelepel', grams: 5, liquid: true),
  HouseholdPortion(label: 'eetlepel', grams: 15, liquid: true),
  HouseholdPortion(label: 'handje', grams: 25),
  HouseholdPortion(label: 'snee', grams: 35),
  HouseholdPortion(label: 'stuk', grams: 80),
  HouseholdPortion(label: 'kop', grams: 125, liquid: true),
  HouseholdPortion(label: 'bakje', grams: 150),
  HouseholdPortion(label: 'glas', grams: 200, liquid: true),
  HouseholdPortion(label: 'kom', grams: 250),
  HouseholdPortion(label: 'blikje', grams: 330, liquid: true),
  HouseholdPortion(label: 'bord', grams: 350),
];

/// Alias voor schermen die alleen label + gram nodig hebben.
const servingPresets = <({String label, double grams})>[
  (label: '1 theelepel', grams: 5),
  (label: '1 eetlepel', grams: 15),
  (label: '1 handje', grams: 25),
  (label: '1 snee', grams: 35),
  (label: '1 stuk', grams: 80),
  (label: '1 kop', grams: 125),
  (label: '1 bakje', grams: 150),
  (label: '1 glas', grams: 200),
  (label: '1 kom', grams: 250),
  (label: '1 blikje', grams: 330),
  (label: '1 bord', grams: 350),
];

class ServingMath {
  static double gramsFromPortions(double portions, double servingG) =>
      portions * servingG;

  static double portionsFromGrams(double grams, double servingG) {
    if (servingG <= 0) return 0;
    return grams / servingG;
  }

  static String formatCount(double value) {
    final half = (value * 2).round() / 2;
    if ((value - half).abs() < 0.05) {
      if (half == half.roundToDouble()) return '${half.round()}';
      return half.toStringAsFixed(1).replaceAll('.', ',');
    }
    return value.toStringAsFixed(1).replaceAll('.', ',');
  }

  static String describe({
    required double grams,
    double? servingG,
    String? servingLabel,
    bool liquid = false,
  }) {
    final unit = liquid ? 'ml' : 'g';
    final rounded = grams.round();
    final portion = matchPortion(
      grams: grams,
      servingG: servingG,
      servingLabel: servingLabel,
    );
    if (portion != null) {
      return '${portion.text} ($rounded $unit)';
    }
    return '$rounded $unit';
  }

  /// Compacte weergave voor recents, bijv. `1 glas` of `40 g`.
  static String describeShort({
    required double grams,
    double? servingG,
    String? servingLabel,
    bool liquid = false,
  }) {
    final portion = matchPortion(
      grams: grams,
      servingG: servingG,
      servingLabel: servingLabel,
    );
    if (portion != null) return portion.text;
    return '${grams.round()} ${liquid ? 'ml' : 'g'}';
  }

  static ({String text, double count})? matchPortion({
    required double grams,
    double? servingG,
    String? servingLabel,
  }) {
    if (servingG != null && servingG > 0) {
      final portions = grams / servingG;
      final snapped = (portions * 2).round() / 2;
      if ((portions - snapped).abs() < 0.08) {
        return (
          text: _countLabel(snapped, servingLabel ?? 'portie'),
          count: snapped,
        );
      }
    }
    final houses = [...dutchPortions]
      ..sort((a, b) => b.grams.compareTo(a.grams));
    for (final house in houses) {
      final portions = grams / house.grams;
      final snapped = portions.roundToDouble();
      if (snapped != 1 && snapped != 2) continue;
      if ((portions - snapped).abs() < 0.08) {
        return (text: _countLabel(snapped, house.label), count: snapped);
      }
    }
    return null;
  }

  /// `1 snee`, `2 snee` — nooit `2 × 1 snee`.
  static String _countLabel(double count, String rawLabel) {
    var label = rawLabel.trim();
    if (label.startsWith('1 ')) {
      label = label.substring(2).trim();
    }
    if (label.isEmpty) label = 'portie';
    if (count == 1) return '1 $label';
    return '${formatCount(count)} $label';
  }

  static double defaultGrams({
    double? lastAmountG,
    double? servingG,
    bool liquid = false,
  }) {
    if (lastAmountG != null && lastAmountG > 0) return lastAmountG;
    if (servingG != null && servingG > 0) return servingG;
    return liquid ? 200 : 100;
  }

  static bool looksLiquid({
    String? name,
    String? category,
    String? servingLabel,
  }) {
    final hay = '${name ?? ''} ${category ?? ''} ${servingLabel ?? ''}'
        .toLowerCase();
    const hints = [
      'melk',
      'karnemelk',
      'sap',
      'juice',
      'water',
      'koffie',
      'thee',
      'cola',
      'frisdrank',
      'limonade',
      'bier',
      'wijn',
      'soep',
      'drink',
      'smoothie',
      'shake',
      'yoghurtdrink',
      'ranja',
      'ijsthee',
      'ice tea',
      'energy',
      'blikje',
      'glas',
    ];
    return hints.any(hay.contains);
  }

  /// Porties die bij dit product horen, productportie eerst.
  static List<HouseholdPortion> suggestionsFor({
    String? name,
    String? category,
    double? servingG,
    String? servingLabel,
  }) {
    final liquid = looksLiquid(
      name: name,
      category: category,
      servingLabel: servingLabel,
    );
    final hay = '${name ?? ''} ${category ?? ''}'.toLowerCase();
    final picked = <HouseholdPortion>[];

    if (servingG != null &&
        servingG > 0 &&
        servingLabel != null &&
        servingLabel.trim().isNotEmpty) {
      var label = servingLabel.trim();
      if (label.startsWith('1 ')) label = label.substring(2).trim();
      if (label.isEmpty || label.toLowerCase() == 'portie') {
        label = liquid ? 'portie' : 'portie';
      }
      picked.add(
        HouseholdPortion(label: label, grams: servingG, liquid: liquid),
      );
    }

    Iterable<HouseholdPortion> extra;
    if (liquid) {
      extra = dutchPortions.where(
        (p) => const {'glas', 'kop', 'eetlepel', 'theelepel', 'blikje', 'kom'}
            .contains(p.label),
      );
    } else if (_any(hay, const ['brood', 'snee', 'toast', 'cracker', 'beschuit'])) {
      extra = dutchPortions.where(
        (p) => const {'snee', 'stuk', 'handje', 'eetlepel'}.contains(p.label),
      );
    } else if (_any(hay, const [
      'olie',
      'saus',
      'jam',
      'honing',
      'pindakaas',
      'halvanaise',
      'mayonaise',
    ])) {
      extra = dutchPortions.where(
        (p) => const {'eetlepel', 'theelepel'}.contains(p.label),
      );
    } else if (_any(hay, const ['noot', 'chips', 'pinda', 'popcorn', 'zoutje'])) {
      extra = dutchPortions.where(
        (p) => const {'handje', 'eetlepel', 'stuk'}.contains(p.label),
      );
    } else if (_any(hay, const ['yoghurt', 'kwark', 'vla', 'pap'])) {
      extra = dutchPortions.where(
        (p) => const {'bakje', 'kom', 'eetlepel', 'bord'}.contains(p.label),
      );
    } else {
      extra = dutchPortions.where(
        (p) =>
            const {'stuk', 'eetlepel', 'snee', 'handje', 'kom', 'glas'}
                .contains(p.label),
      );
    }

    for (final portion in extra) {
      if (picked.any((p) => (p.grams - portion.grams).abs() < 1)) continue;
      picked.add(portion);
    }
    return picked;
  }

  static bool _any(String hay, List<String> needles) =>
      needles.any(hay.contains);
}
