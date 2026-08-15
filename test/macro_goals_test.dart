import 'package:flutter_test/flutter_test.dart';
import 'package:kalorie/core/macro_goals.dart';

void main() {
  test('kcal telt op uit de macro-grammen', () {
    expect(MacroGoals.defaults.kcal, closeTo(120 * 4 + 250 * 4 + 70 * 9, 0.01));
  });

  test('percentages verdelen het dagdoel', () {
    const goals = MacroGoals(protein: 125, carbs: 250, fat: 75);
    expect(goals.proteinPct(2200), 23);
    expect(goals.carbsPct(2200), 45);
    expect(goals.fatPct(2200), 31);
  });

  test('schaalt mee met een nieuw dagdoel en houdt de verhouding', () {
    final scaled = MacroGoals.defaults.scaledTo(2200, 1100);
    expect(scaled.protein, 60);
    expect(scaled.carbs, 125);
    expect(scaled.fat, 35);
  });

  test('forKcal gebruikt de standaardverhouding', () {
    final goals = MacroGoals.forKcal(MacroGoals.defaultKcal);
    expect(goals.protein, MacroGoals.defaults.protein);
    expect(goals.carbs, MacroGoals.defaults.carbs);
    expect(goals.fat, MacroGoals.defaults.fat);
  });

  test('een doel van nul laat de macro’s staan', () {
    final scaled = MacroGoals.defaults.scaledTo(0, 1800);
    expect(scaled.protein, MacroGoals.defaults.protein);
  });
}
