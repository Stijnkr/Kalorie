import 'package:flutter_test/flutter_test.dart';
import 'package:kalorie/core/food_search_rank.dart';
import 'package:kalorie/data/local/collections/enums.dart';
import 'package:kalorie/data/local/collections/food.dart';

Food _food({
  required String name,
  FoodSource source = FoodSource.nevo,
  bool favorite = false,
  DateTime? lastUsedAt,
}) {
  return Food()
    ..source = source
    ..name = name
    ..nameNormalized = name.toLowerCase()
    ..kcal100g = 100
    ..protein100g = 1
    ..carbs100g = 1
    ..fat100g = 1
    ..isFavorite = favorite
    ..lastUsedAt = lastUsedAt;
}

void main() {
  test('zet recente matches boven favorieten en startsWith', () {
    final recent = _food(name: 'Havermout', lastUsedAt: DateTime(2026, 8, 14));
    final fav = _food(name: 'Haverkoek', favorite: true);
    final start = _food(name: 'Havervlokken');
    final items = [start, fav, recent]..sort((a, b) => compareFoodSearch(a, b, 'haver'));
    expect(items.map((f) => f.name).toList(), [
      'Havermout',
      'Haverkoek',
      'Havervlokken',
    ]);
  });

  test('zet NEVO/custom boven OFF bij gelijke naam', () {
    final off = _food(name: 'Melk', source: FoodSource.off);
    final nevo = _food(name: 'Melk', source: FoodSource.nevo);
    final custom = _food(name: 'Melk', source: FoodSource.custom);
    final items = [off, nevo, custom]..sort((a, b) => compareFoodSearch(a, b, 'melk'));
    expect(items.map((f) => f.source).toList(), [
      FoodSource.custom,
      FoodSource.nevo,
      FoodSource.off,
    ]);
  });

  test('startsWith gaat voor contains', () {
    final contains = _food(name: 'Volkoren havermout');
    final starts = _food(name: 'Havermout');
    final items = [contains, starts]..sort((a, b) => compareFoodSearch(a, b, 'haver'));
    expect(items.first.name, 'Havermout');
  });
}
