import 'package:flutter_test/flutter_test.dart';
import 'package:kalorie/core/food_search_rank.dart';
import 'package:kalorie/data/food/ranking.dart';
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

  test('heel woord gaat voor een prefix midden in een woord', () {
    // "ei" moet Ei kippen- geven, niet Eipoeder.
    expect(textMatch(_food(name: 'Ei kippen- gebakken'), 'ei'), 0.95);
    expect(textMatch(_food(name: 'Eipoeder kippen-'), 'ei'), 0.6);
    expect(textMatch(_food(name: 'Ei'), 'ei'), 1);
    expect(textMatch(_food(name: 'Kwark magere'), 'magere'), 0.8);
  });

  test('kortste naam wint bij een gelijke score', () {
    final long = _food(name: 'Melk chocolade- automaat');
    final short = _food(name: 'Melk volle');
    final items = [long, short]..sort((a, b) => compareFoodSearch(a, b, 'melk'));
    expect(items.first.name, 'Melk volle');
  });

  test('matcht losse woorden in omgekeerde NEVO-namen', () {
    final inverted = _food(name: 'Kwark magere');
    expect(textMatch(inverted, 'magere kwark'), 0.6);
    // Eén woord raak van de twee telt maar half mee.
    expect(textMatch(_food(name: 'Kwark vruchten'), 'magere kwark'), 0.15);
    // Exacte volgorde blijft hoger scoren.
    expect(
      textMatch(_food(name: 'Magere kwark'), 'magere kwark'),
      greaterThan(textMatch(inverted, 'magere kwark')),
    );
  });

  test('catalogScore geeft generic een boost bij korte query', () {
    final generic = _food(name: 'Melk')
      ..kind = FoodKind.generic
      ..qualityScore = 100
      ..nlRelevance = 100;
    final branded = _food(name: 'Melk', source: FoodSource.off)
      ..kind = FoodKind.branded
      ..qualityScore = 70
      ..nlRelevance = 100;
    expect(catalogScore(generic, 'melk'), greaterThan(catalogScore(branded, 'melk')));
  });
}
