import 'package:flutter_test/flutter_test.dart';
import 'package:kalorie/data/food/catalog_product.dart';
import 'package:kalorie/data/food/quality.dart';
import 'package:kalorie/data/local/collections/enums.dart';

void main() {
  test('NEVO snapshot-item naar CatalogProduct', () {
    final product = CatalogProduct.fromJson({
      'id': 'abc',
      'kind': 'generic',
      'source': 'nevo',
      'nevoCode': '01101',
      'name': 'Aardappel gekookt',
      'category': 'Aardappelen',
      'kcal': 80,
      'protein': 2,
      'carbs': 17.3,
      'fat': 0.1,
      'fiber': 1.8,
      'nutrients': {'VITC': 12},
      'qualityScore': 100,
      'nlRelevance': 100,
      'servingG': 200,
      'servingLabel': '1 opscheplepel',
    });
    expect(product.kind, FoodKind.generic);
    expect(product.source, FoodSource.nevo);
    expect(product.fiber, 1.8);
    expect(product.nutrients['VITC'], 12);

    final food = product.toFood();
    expect(food.nevoCode, '01101');
    expect(food.kcal100g, 80);
    expect(food.fiber100g, 1.8);
    expect(food.qualityScore, 100);
    expect(food.brand, 'Aardappelen');
    expect(food.nameNormalized, 'aardappel gekookt');
  });

  test('complete NL branded product haalt de drempel', () {
    final result = scoreQuality(
      const QualityInput(
        name: 'Halfvolle melk',
        brand: 'Campina',
        kcal: 46,
        protein: 3.4,
        carbs: 4.6,
        fat: 1.5,
        fiber: 0,
        sugars: 4.6,
        salt: 0.1,
        hasDutchName: true,
        countryNl: true,
        hasServing: true,
      ),
    );
    expect(result.reject, isFalse);
    expect(result.score, greaterThanOrEqualTo(70));
  });
}
