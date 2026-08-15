import 'package:openfoodfacts/openfoodfacts.dart';

import '../local/collections/enums.dart';
import '../local/collections/food.dart';
import '../../core/constants.dart';

Food? mapOffProduct(Product product) {
  final name = (product.productName ?? '').trim();
  if (name.isEmpty) return null;

  final kcal = _kcalPer100g(product);
  if (kcal == null) return null;

  final serving = _servingGrams(product);

  return Food()
    ..source = FoodSource.off
    ..barcode = product.barcode
    ..offId = product.barcode
    ..name = name
    ..brand = product.brands?.split(',').first.trim()
    ..nameNormalized = normalizeName(name)
    ..kcal100g = kcal
    ..protein100g = _nutrient(product, Nutrient.proteins) ?? 0
    ..carbs100g = _nutrient(product, Nutrient.carbohydrates) ?? 0
    ..fat100g = _nutrient(product, Nutrient.fat) ?? 0
    ..servingG = serving
    ..servingLabel = serving != null ? '1 portie' : null
    ..isFavorite = false
    ..cachedAt = DateTime.now()
    ..userOverridden = false;
}

double? _kcalPer100g(Product product) {
  final kcal = _nutrient(product, Nutrient.energyKCal);
  if (kcal != null && kcal > 0) return kcal;
  final kj = _nutrient(product, Nutrient.energyKJ);
  if (kj != null && kj > 0) return kj / 4.184;
  return null;
}

double? _nutrient(Product product, Nutrient nutrient) {
  return product.nutriments?.getValue(nutrient, PerSize.oneHundredGrams);
}

double? _servingGrams(Product product) {
  final qty = product.servingQuantity;
  if (qty != null && qty > 0 && qty <= 2000) return qty.toDouble();
  final raw = product.servingSize;
  if (raw == null) return null;
  final match = RegExp(r'(\d+(?:[.,]\d+)?)\s*g', caseSensitive: false)
      .firstMatch(raw);
  if (match == null) return null;
  return double.tryParse(match.group(1)!.replaceAll(',', '.'));
}
