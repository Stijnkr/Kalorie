import 'package:flutter_test/flutter_test.dart';
import 'package:kalorie/core/day_summary.dart';
import 'package:kalorie/data/local/collections/diary_entry.dart';
import 'package:kalorie/data/local/collections/enums.dart';

void main() {
  test('DaySummary sums nutrient snapshots', () {
    final entries = [
      DiaryEntry()
        ..dateKey = 20260815
        ..meal = MealType.breakfast
        ..foodId = 1
        ..foodName = 'Havermout'
        ..source = FoodSource.nevo
        ..amountG = 40
        ..kcal = 147
        ..protein = 5.4
        ..carbs = 23.5
        ..fat = 2.8
        ..createdAt = DateTime(2026, 8, 15),
      DiaryEntry()
        ..dateKey = 20260815
        ..meal = MealType.snack
        ..foodId = 2
        ..foodName = 'Appel'
        ..source = FoodSource.nevo
        ..amountG = 150
        ..kcal = 81
        ..protein = 0.5
        ..carbs = 17.7
        ..fat = 0.3
        ..createdAt = DateTime(2026, 8, 15),
    ];

    final summary = DaySummary.fromEntries(20260815, entries);
    expect(summary.kcal, 228);
    expect(summary.protein, closeTo(5.9, 0.01));
    expect(summary.entries, hasLength(2));
  });
}
