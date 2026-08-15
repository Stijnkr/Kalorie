import 'package:isar_community/isar.dart';

import 'enums.dart';

part 'food.g.dart';

@Collection(accessor: 'foods')
class Food {
  Id id = Isar.autoIncrement;

  @enumerated
  late FoodSource source;

  @enumerated
  FoodKind kind = FoodKind.generic;

  @Index()
  String? catalogId;

  @Index()
  String? barcode;

  @Index()
  String? nevoCode;

  @Index()
  String? offId;

  @Index(type: IndexType.value, caseSensitive: false)
  late String name;

  String? brand;

  @Index(type: IndexType.value, caseSensitive: false)
  late String nameNormalized;

  late double kcal100g;
  late double protein100g;
  late double carbs100g;
  late double fat100g;

  double? fiber100g;
  double? sugars100g;
  double? satFat100g;
  double? salt100g;
  double? alcohol100g;
  String? nutrientsJson;

  double? servingG;
  String? servingLabel;

  int qualityScore = 0;
  int popularity = 0;
  int nlRelevance = 0;
  int dataVersion = 1;

  @Index()
  late bool isFavorite;

  @Index()
  DateTime? lastUsedAt;

  double? lastAmountG;

  DateTime? cachedAt;
  bool userOverridden = false;

  /// Alleen eigen producten gaan mee naar de server; catalogusproducten staan
  /// er al. Null voor alles wat uit NEVO of Open Food Facts komt. Niet uniek:
  /// catalogusrijen delen `null` en mogen elkaar niet vervangen.
  @Index()
  String? clientId;

  DateTime? updatedAt;

  @Index()
  bool dirty = false;

  @Index()
  bool deleted = false;
}
