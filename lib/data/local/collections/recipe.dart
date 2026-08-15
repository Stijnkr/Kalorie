import 'dart:convert';

import 'package:isar_community/isar.dart';

part 'recipe.g.dart';

/// Eén ingrediënt in een recept. De voedingswaarden staan erin gekopieerd
/// zodat een recept blijft kloppen als het bronproduct later verandert.
class RecipeItem {
  const RecipeItem({
    required this.foodId,
    required this.name,
    required this.grams,
    required this.kcal100g,
    required this.protein100g,
    required this.carbs100g,
    required this.fat100g,
    this.fiber100g,
    this.sugars100g,
    this.satFat100g,
    this.salt100g,
  });

  factory RecipeItem.fromJson(Map<String, dynamic> json) {
    double d(String key) => (json[key] as num?)?.toDouble() ?? 0;
    double? n(String key) => (json[key] as num?)?.toDouble();
    return RecipeItem(
      foodId: (json['foodId'] as num?)?.toInt() ?? 0,
      name: json['name'] as String? ?? '',
      grams: d('grams'),
      kcal100g: d('kcal100g'),
      protein100g: d('protein100g'),
      carbs100g: d('carbs100g'),
      fat100g: d('fat100g'),
      fiber100g: n('fiber100g'),
      sugars100g: n('sugars100g'),
      satFat100g: n('satFat100g'),
      salt100g: n('salt100g'),
    );
  }

  final int foodId;
  final String name;
  final double grams;
  final double kcal100g;
  final double protein100g;
  final double carbs100g;
  final double fat100g;
  final double? fiber100g;
  final double? sugars100g;
  final double? satFat100g;
  final double? salt100g;

  double get kcal => kcal100g * grams / 100;
  double get protein => protein100g * grams / 100;
  double get carbs => carbs100g * grams / 100;
  double get fat => fat100g * grams / 100;
  double? get fiber => fiber100g == null ? null : fiber100g! * grams / 100;
  double? get sugars => sugars100g == null ? null : sugars100g! * grams / 100;
  double? get satFat => satFat100g == null ? null : satFat100g! * grams / 100;
  double? get salt => salt100g == null ? null : salt100g! * grams / 100;

  RecipeItem copyWith({double? grams}) => RecipeItem(
        foodId: foodId,
        name: name,
        grams: grams ?? this.grams,
        kcal100g: kcal100g,
        protein100g: protein100g,
        carbs100g: carbs100g,
        fat100g: fat100g,
        fiber100g: fiber100g,
        sugars100g: sugars100g,
        satFat100g: satFat100g,
        salt100g: salt100g,
      );

  Map<String, dynamic> toJson() => {
        'foodId': foodId,
        'name': name,
        'grams': grams,
        'kcal100g': kcal100g,
        'protein100g': protein100g,
        'carbs100g': carbs100g,
        'fat100g': fat100g,
        if (fiber100g != null) 'fiber100g': fiber100g,
        if (sugars100g != null) 'sugars100g': sugars100g,
        if (satFat100g != null) 'satFat100g': satFat100g,
        if (salt100g != null) 'salt100g': salt100g,
      };
}

/// Een vaste combinatie die je in één tik logt.
@Collection(accessor: 'recipes')
class Recipe {
  Id id = Isar.autoIncrement;

  @Index(unique: true, replace: true)
  late String clientId;

  late String name;

  /// Waar het recept voor is gemaakt; één portie is het totaal gedeeld hierdoor.
  int portions = 1;

  /// Ingrediënten als JSON, zodat de lijst in één veld mee kan naar de server.
  String itemsJson = '[]';

  late DateTime updatedAt;

  @Index()
  bool dirty = true;

  @Index()
  bool deleted = false;

  @ignore
  List<RecipeItem> get items {
    final raw = jsonDecode(itemsJson);
    if (raw is! List) return const [];
    return raw
        .whereType<Map<String, dynamic>>()
        .map(RecipeItem.fromJson)
        .toList();
  }

  set items(List<RecipeItem> value) {
    itemsJson = jsonEncode(value.map((i) => i.toJson()).toList());
  }

  @ignore
  double get totalKcal => items.fold(0, (sum, i) => sum + i.kcal);

  @ignore
  double get totalGrams => items.fold(0, (sum, i) => sum + i.grams);

  @ignore
  double get kcalPerPortion => portions <= 0 ? totalKcal : totalKcal / portions;

  @ignore
  double get gramsPerPortion =>
      portions <= 0 ? totalGrams : totalGrams / portions;
}
