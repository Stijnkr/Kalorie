import 'package:openfoodfacts/openfoodfacts.dart';

import '../food/match_key.dart';
import '../food/nutrients.dart';
import '../food/quality.dart';
import '../local/collections/enums.dart';
import '../local/collections/food.dart';

Food? mapOffProduct(Product product) {
  final name = (product.productName ?? '').trim();
  if (name.isEmpty) return null;

  final kcal = _kcalPer100g(product);
  if (kcal == null) return null;

  final protein = _nutrient(product, Nutrient.proteins) ?? 0;
  final carbs = _nutrient(product, Nutrient.carbohydrates) ?? 0;
  final fat = _nutrient(product, Nutrient.fat) ?? 0;
  final fiber = _nutrient(product, Nutrient.fiber);
  final sugars = _nutrient(product, Nutrient.sugars);
  final satFat = _nutrient(product, Nutrient.saturatedFat);
  final salt = _salt(product);
  final alcohol = _nutrient(product, Nutrient.alcohol);
  final serving = _servingGrams(product);
  final brand = product.brands?.split(',').first.trim();
  final quality = scoreQuality(
    QualityInput(
      name: name,
      brand: brand,
      kcal: kcal,
      protein: protein,
      carbs: carbs,
      fat: fat,
      fiber: fiber,
      sugars: sugars,
      salt: salt,
      alcohol: alcohol,
      hasDutchName: true,
      countryNl: true,
      hasServing: serving != null,
    ),
  );

  final extras = <String, double>{};
  void put(String code, Nutrient nutrient) {
    final value = _nutrient(product, nutrient);
    if (value != null) extras[code] = value;
  }

  put(NutrientCodes.ca, Nutrient.calcium);
  put(NutrientCodes.fe, Nutrient.iron);
  put(NutrientCodes.vitc, Nutrient.vitaminC);
  put('K', Nutrient.potassium);
  put('MG', Nutrient.magnesium);
  put('ZN', Nutrient.zinc);
  put('VITA', Nutrient.vitaminA);
  put('VITD', Nutrient.vitaminD);
  put('THIA', Nutrient.vitaminB1);
  put('RIBF', Nutrient.vitaminB2);
  put('VITB6', Nutrient.vitaminB6);
  put('VITB12', Nutrient.vitaminB12);
  put('FOL', Nutrient.vitaminB9);
  put('ID', Nutrient.iodine);
  if (salt != null) extras[NutrientCodes.na] = salt / 2.5 * 1000;

  return Food()
    ..source = FoodSource.off
    ..kind = FoodKind.branded
    ..barcode = MatchKey.normalizeBarcode(product.barcode) ?? product.barcode
    ..offId = product.barcode
    ..name = name
    ..brand = brand
    ..nameNormalized = MatchKey.normalizeSearch(name)
    ..kcal100g = kcal
    ..protein100g = protein
    ..carbs100g = carbs
    ..fat100g = fat
    ..fiber100g = fiber
    ..sugars100g = sugars
    ..satFat100g = satFat
    ..salt100g = salt
    ..alcohol100g = alcohol
    ..nutrientsJson = encodeNutrients(extras)
    ..servingG = serving
    ..servingLabel = serving != null ? '1 portie' : null
    ..qualityScore = quality.score
    ..nlRelevance = 100
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

double? _salt(Product product) {
  final salt = _nutrient(product, Nutrient.salt);
  if (salt != null) return salt;
  final sodium = _nutrient(product, Nutrient.sodium);
  if (sodium == null) return null;
  return sodium * 2.5;
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
