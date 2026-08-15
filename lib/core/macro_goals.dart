import 'package:flutter/material.dart';

/// Verdeling van het kcal-doel over de macro's. De verhouding blijft staan als
/// je het dagdoel verschuift: "pas het doel aan, de rest schuift mee".
@immutable
class MacroGoals {
  const MacroGoals({
    required this.protein,
    required this.carbs,
    required this.fat,
  });

  static const kcalPerGramProtein = 4.0;
  static const kcalPerGramCarbs = 4.0;
  static const kcalPerGramFat = 9.0;

  /// Standaardverdeling bij 2200 kcal, gelijk aan `AppSettings.defaults()`.
  static const defaultKcal = 2200;
  static const defaults = MacroGoals(protein: 120, carbs: 250, fat: 70);

  final double protein;
  final double carbs;
  final double fat;

  double get kcal =>
      protein * kcalPerGramProtein +
      carbs * kcalPerGramCarbs +
      fat * kcalPerGramFat;

  /// Aandeel van het dagdoel per macro, afgerond op hele procenten.
  int proteinPct(int kcalGoal) => _pct(protein * kcalPerGramProtein, kcalGoal);
  int carbsPct(int kcalGoal) => _pct(carbs * kcalPerGramCarbs, kcalGoal);
  int fatPct(int kcalGoal) => _pct(fat * kcalPerGramFat, kcalGoal);

  static int _pct(double kcalFromMacro, int kcalGoal) =>
      kcalGoal <= 0 ? 0 : (kcalFromMacro / kcalGoal * 100).round();

  /// Schaalt alle macro's mee met een nieuw kcal-doel.
  MacroGoals scaledTo(int fromKcal, int toKcal) {
    if (fromKcal <= 0 || toKcal <= 0) return this;
    final factor = toKcal / fromKcal;
    return MacroGoals(
      protein: _round(protein * factor),
      carbs: _round(carbs * factor),
      fat: _round(fat * factor),
    );
  }

  /// Verdeling voor een kcal-doel, uitgaand van de standaardverhouding.
  static MacroGoals forKcal(int kcalGoal) =>
      defaults.scaledTo(defaultKcal, kcalGoal);

  MacroGoals copyWith({double? protein, double? carbs, double? fat}) {
    return MacroGoals(
      protein: protein ?? this.protein,
      carbs: carbs ?? this.carbs,
      fat: fat ?? this.fat,
    );
  }

  static double _round(double grams) => (grams * 2).roundToDouble() / 2;
}
