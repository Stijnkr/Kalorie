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
  }) {
    final roundedG = grams.round();
    if (servingG != null && servingG > 0 && servingLabel != null && servingLabel.isNotEmpty) {
      final portions = grams / servingG;
      final snapped = (portions * 2).round() / 2;
      if ((portions - snapped).abs() < 0.08) {
        return '${formatCount(snapped)} × $servingLabel ($roundedG g)';
      }
    }
    return '$roundedG g';
  }

  /// Compacte weergave voor recents, bijv. `1 portie` of `40 g`.
  static String describeShort({
    required double grams,
    double? servingG,
    String? servingLabel,
  }) {
    if (servingG != null && servingG > 0) {
      final portions = grams / servingG;
      final snapped = (portions * 2).round() / 2;
      if ((portions - snapped).abs() < 0.08) {
        final label = (servingLabel != null && servingLabel.isNotEmpty)
            ? servingLabel
            : 'portie';
        if (snapped == 1) return label;
        return '${formatCount(snapped)} × $label';
      }
    }
    return '${grams.round()} g';
  }

  static double defaultGrams({double? lastAmountG, double? servingG}) =>
      lastAmountG ?? servingG ?? 100;
}

const servingPresets = <({String label, double grams})>[
  (label: '1 portie', grams: 100),
  (label: '1 snee', grams: 35),
  (label: '1 stuk', grams: 50),
  (label: '1 eetlepel', grams: 15),
  (label: '1 theelepel', grams: 5),
  (label: '1 glas', grams: 200),
  (label: '1 kop', grams: 125),
  (label: '1 kom', grams: 250),
  (label: '1 handje', grams: 25),
];
