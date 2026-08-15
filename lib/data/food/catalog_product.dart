import '../local/collections/enums.dart';
import '../local/collections/food.dart';
import 'match_key.dart';
import 'nutrients.dart';

class CatalogProduct {
  const CatalogProduct({
    required this.id,
    required this.kind,
    required this.source,
    required this.name,
    required this.kcal,
    required this.protein,
    required this.carbs,
    required this.fat,
    this.nevoCode,
    this.offId,
    this.barcode,
    this.brand,
    this.category,
    this.fiber,
    this.sugars,
    this.satFat,
    this.salt,
    this.alcohol,
    this.nutrients = const {},
    this.servingG,
    this.servingLabel,
    this.aliases = const [],
    this.qualityScore = 0,
    this.nlRelevance = 0,
    this.popularity = 0,
    this.dataVersion = 1,
  });

  final String id;
  final FoodKind kind;
  final FoodSource source;
  final String? nevoCode;
  final String? offId;
  final String? barcode;
  final String name;
  final String? brand;
  final String? category;
  final double kcal;
  final double protein;
  final double carbs;
  final double fat;
  final double? fiber;
  final double? sugars;
  final double? satFat;
  final double? salt;
  final double? alcohol;
  final Map<String, double> nutrients;
  final double? servingG;
  final String? servingLabel;
  final List<String> aliases;
  final int qualityScore;
  final int nlRelevance;
  final int popularity;
  final int dataVersion;

  factory CatalogProduct.fromJson(Map<String, dynamic> json) {
    final sourceRaw = (json['source'] ?? json['source_primary'] ?? 'nevo')
        .toString();
    return CatalogProduct(
      id: (json['id'] ?? '').toString(),
      kind: (json['kind']?.toString() == 'branded')
          ? FoodKind.branded
          : FoodKind.generic,
      source: switch (sourceRaw) {
        'off' => FoodSource.off,
        'custom' || 'kalorie' => FoodSource.custom,
        _ => FoodSource.nevo,
      },
      nevoCode: _str(json['nevoCode'] ?? json['nevo_code'] ?? json['code']),
      offId: _str(json['offId'] ?? json['off_id']),
      barcode: _str(json['barcode']),
      name: json['name'] as String,
      brand: _str(json['brand']),
      category: _str(json['category'] ?? json['group']),
      kcal: _num(json['kcal'] ?? json['energy_kcal_100g']) ?? 0,
      protein: _num(json['protein'] ?? json['protein_100g']) ?? 0,
      carbs: _num(json['carbs'] ?? json['carbs_100g']) ?? 0,
      fat: _num(json['fat'] ?? json['fat_100g']) ?? 0,
      fiber: _num(json['fiber'] ?? json['fiber_100g']),
      sugars: _num(json['sugars'] ?? json['sugars_100g']),
      satFat: _num(json['satFat'] ?? json['sat_fat_100g']),
      salt: _num(json['salt'] ?? json['salt_100g']),
      alcohol: _num(json['alcohol'] ?? json['alcohol_100g']),
      nutrients: _nutrientMap(json['nutrients']),
      servingG: _num(json['servingG'] ?? json['serving_g']),
      servingLabel: _str(json['servingLabel'] ?? json['serving_label']),
      aliases: [
        for (final a in (json['aliases'] as List? ?? const [])) a.toString(),
      ],
      qualityScore: _int(json['qualityScore'] ?? json['quality_score']) ?? 0,
      nlRelevance: _int(json['nlRelevance'] ?? json['nl_relevance']) ?? 0,
      popularity: _int(json['popularity']) ?? 0,
      dataVersion: _int(json['dataVersion'] ?? json['data_version']) ?? 1,
    );
  }

  Food toFood({Food? existing}) {
    final food = existing ?? Food();
    food
      ..catalogId = id.isEmpty ? null : id
      ..kind = kind
      ..source = source
      ..nevoCode = nevoCode
      ..offId = offId
      ..barcode = barcode
      ..name = name
      ..brand = brand ?? category
      ..nameNormalized = [
        MatchKey.normalizeSearch(name),
        for (final alias in aliases) MatchKey.normalizeSearch(alias),
      ].where((s) => s.isNotEmpty).join(' ')
      ..kcal100g = kcal
      ..protein100g = protein
      ..carbs100g = carbs
      ..fat100g = fat
      ..fiber100g = fiber
      ..sugars100g = sugars
      ..satFat100g = satFat
      ..salt100g = salt
      ..alcohol100g = alcohol
      ..nutrientsJson = encodeNutrients(nutrients)
      ..servingG = servingG ?? existing?.servingG
      ..servingLabel = servingLabel ?? existing?.servingLabel
      ..qualityScore = qualityScore
      ..nlRelevance = nlRelevance
      ..popularity = popularity
      ..dataVersion = dataVersion
      ..isFavorite = existing?.isFavorite ?? false
      ..lastUsedAt = existing?.lastUsedAt
      ..lastAmountG = existing?.lastAmountG
      ..userOverridden = existing?.userOverridden ?? false;
    return food;
  }

  static int? _int(Object? value) {
    if (value == null) return null;
    if (value is int) return value;
    if (value is num) return value.toInt();
    return int.tryParse(value.toString());
  }

  static String? _str(Object? value) {
    if (value == null) return null;
    final s = value.toString().trim();
    return s.isEmpty ? null : s;
  }

  static double? _num(Object? value) {
    if (value == null) return null;
    if (value is num) return value.toDouble();
    return double.tryParse(value.toString().replaceAll(',', '.'));
  }

  static Map<String, double> _nutrientMap(Object? raw) {
    if (raw is Map) {
      return raw.map(
        (key, value) => MapEntry(key.toString(), (value as num).toDouble()),
      );
    }
    return const {};
  }
}
