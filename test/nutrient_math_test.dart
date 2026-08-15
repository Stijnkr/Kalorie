import 'package:flutter_test/flutter_test.dart';
import 'package:kalorie/core/constants.dart';
import 'package:kalorie/core/day_summary.dart';
import 'package:kalorie/data/local/collections/diary_entry.dart';
import 'package:kalorie/data/local/collections/enums.dart';

void main() {
  group('DateKeys', () {
    test('packs a local calendar date', () {
      expect(DateKeys.fromDateTime(DateTime(2026, 8, 15, 23, 59)), 20260815);
      expect(DateKeys.fromDateTime(DateTime(2026, 1, 2)), 20260102);
    });

    test('round-trips', () {
      const key = 20260815;
      expect(DateKeys.fromDateTime(DateKeys.toDateTime(key)), key);
    });

    test('addDays crosses months', () {
      expect(DateKeys.addDays(20260831, 1), 20260901);
      expect(DateKeys.addDays(20260101, -1), 20251231);
    });

    test('weekContaining starts on Monday', () {
      final week = DateKeys.weekContaining(20260815); // Saturday
      expect(DateKeys.toDateTime(week.first).weekday, DateTime.monday);
      expect(week.length, 7);
      expect(week.contains(20260815), isTrue);
    });
  });

  group('NutrientMath', () {
    test('scales per 100g to grams', () {
      expect(NutrientMath.scale(250, 150), 375);
      expect(NutrientMath.scale(20, 50), 10);
      expect(NutrientMath.scale(0, 100), 0);
    });

    test('rounds kcal to whole numbers', () {
      expect(NutrientMath.roundKcal(374.4), 374);
      expect(NutrientMath.roundKcal(374.5), 375);
    });

    test('rounds macros to one decimal', () {
      expect(NutrientMath.roundMacro(12.34), 12.3);
      expect(NutrientMath.roundMacro(12.35), 12.4);
    });

    test('rescales a snapshot from one amount to another', () {
      expect(NutrientMath.rescale(200, 100, 150), 300);
      expect(NutrientMath.rescale(10, 200, 100), 5);
      expect(NutrientMath.rescale(40, 0, 100), 40);
      expect(NutrientMath.rescaleOrNull(null, 100, 50), isNull);
      expect(NutrientMath.rescaleOrNull(8, 100, 50), 4);
    });
  });

  group('DaySummary', () {
    test('aggregates snapshots', () {
      final a = DiaryEntry()
        ..dateKey = 20260815
        ..meal = MealType.breakfast
        ..foodId = 1
        ..foodName = 'Havermout'
        ..source = FoodSource.nevo
        ..amountG = 40
        ..kcal = 146.8
        ..protein = 5.4
        ..carbs = 23.5
        ..fat = 2.8
        ..createdAt = DateTime(2026, 8, 15);

      final b = DiaryEntry()
        ..dateKey = 20260815
        ..meal = MealType.lunch
        ..foodId = 2
        ..foodName = 'Kipfilet'
        ..source = FoodSource.nevo
        ..amountG = 150
        ..kcal = 235.5
        ..protein = 43.5
        ..carbs = 0
        ..fat = 6.75
        ..createdAt = DateTime(2026, 8, 15);

      final summary = DaySummary.fromEntries(20260815, [a, b]);
      expect(summary.kcal, closeTo(382.3, 0.01));
      expect(summary.protein, closeTo(48.9, 0.01));
      expect(summary.carbs, closeTo(23.5, 0.01));
      expect(summary.fat, closeTo(9.55, 0.01));
      expect(summary.forMeal(MealType.breakfast), hasLength(1));
      expect(summary.forMeal(MealType.dinner), isEmpty);
    });
  });

  group('mealForNow', () {
    test('maps hours to meals', () {
      expect(mealForNow(DateTime(2026, 1, 1, 8)), MealType.breakfast);
      expect(mealForNow(DateTime(2026, 1, 1, 12)), MealType.lunch);
      expect(mealForNow(DateTime(2026, 1, 1, 19)), MealType.dinner);
      expect(mealForNow(DateTime(2026, 1, 1, 15)), MealType.snack);
      expect(mealForNow(DateTime(2026, 1, 1, 23)), MealType.snack);
    });
  });
}
