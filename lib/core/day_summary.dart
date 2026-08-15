import 'package:flutter/material.dart';

import '../data/local/collections/diary_entry.dart';
import 'constants.dart';

@immutable
class DaySummary {
  const DaySummary({
    required this.dateKey,
    required this.kcal,
    required this.protein,
    required this.carbs,
    required this.fat,
    required this.entries,
  });

  factory DaySummary.fromEntries(int dateKey, List<DiaryEntry> entries) {
    var kcal = 0.0;
    var protein = 0.0;
    var carbs = 0.0;
    var fat = 0.0;
    for (final entry in entries) {
      kcal += entry.kcal;
      protein += entry.protein;
      carbs += entry.carbs;
      fat += entry.fat;
    }
    return DaySummary(
      dateKey: dateKey,
      kcal: kcal,
      protein: protein,
      carbs: carbs,
      fat: fat,
      entries: List.unmodifiable(entries),
    );
  }

  final int dateKey;
  final double kcal;
  final double protein;
  final double carbs;
  final double fat;
  final List<DiaryEntry> entries;

  List<DiaryEntry> forMeal(dynamic meal) =>
      entries.where((e) => e.meal == meal).toList();
}

@immutable
class MacroProgress {
  const MacroProgress({
    required this.eaten,
    required this.goal,
  });

  final double eaten;
  final double goal;

  double get ratio => goal <= 0 ? 0 : (eaten / goal).clamp(0, 2);
  bool get over => eaten > goal + 0.05;
  double get remaining => (goal - eaten).clamp(0, double.infinity);
}

int displayKcal(double kcal) => NutrientMath.roundKcal(kcal);

String displayMacro(double grams) {
  final rounded = NutrientMath.roundMacro(grams);
  if (rounded == rounded.roundToDouble()) {
    return rounded.toStringAsFixed(0);
  }
  return rounded.toStringAsFixed(1);
}
