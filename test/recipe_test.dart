import 'package:flutter_test/flutter_test.dart';
import 'package:kalorie/data/local/collections/recipe.dart';

void main() {
  RecipeItem item({
    required double grams,
    required double kcal100g,
    double? fiber100g,
  }) {
    return RecipeItem(
      foodId: 1,
      name: 'Test',
      grams: grams,
      kcal100g: kcal100g,
      protein100g: 10,
      carbs100g: 20,
      fat100g: 5,
      fiber100g: fiber100g,
    );
  }

  test('schaalt een ingrediënt naar het aantal gram', () {
    final banaan = item(grams: 150, kcal100g: 89);
    expect(banaan.kcal, closeTo(133.5, 0.01));
    expect(banaan.protein, closeTo(15, 0.01));
    expect(banaan.fiber, isNull);
  });

  test('deelt het totaal door het aantal porties', () {
    final recipe = Recipe()
      ..clientId = 'a'
      ..name = 'Kwark met banaan'
      ..portions = 2
      ..updatedAt = DateTime(2026, 8, 15)
      ..items = [
        item(grams: 250, kcal100g: 56),
        item(grams: 150, kcal100g: 89),
      ];

    expect(recipe.totalKcal, closeTo(140 + 133.5, 0.01));
    expect(recipe.totalGrams, 400);
    expect(recipe.kcalPerPortion, closeTo((140 + 133.5) / 2, 0.01));
    expect(recipe.gramsPerPortion, 200);
  });

  test('nul porties valt terug op het totaal', () {
    final recipe = Recipe()
      ..clientId = 'b'
      ..name = 'Los'
      ..portions = 0
      ..updatedAt = DateTime(2026, 8, 15)
      ..items = [item(grams: 100, kcal100g: 200)];

    expect(recipe.kcalPerPortion, closeTo(200, 0.01));
    expect(recipe.gramsPerPortion, 100);
  });

  test('ingrediënten overleven de rondgang door JSON', () {
    final recipe = Recipe()
      ..clientId = 'c'
      ..name = 'Rond'
      ..portions = 1
      ..updatedAt = DateTime(2026, 8, 15)
      ..items = [item(grams: 75, kcal100g: 403, fiber100g: 8)];

    final restored = Recipe()
      ..clientId = 'c'
      ..name = 'Rond'
      ..portions = 1
      ..updatedAt = DateTime(2026, 8, 15)
      ..itemsJson = recipe.itemsJson;

    expect(restored.items, hasLength(1));
    expect(restored.items.first.grams, 75);
    expect(restored.items.first.fiber100g, 8);
    expect(restored.items.first.fiber, closeTo(6, 0.01));
  });
}
