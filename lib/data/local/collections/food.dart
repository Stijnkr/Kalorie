import 'package:isar_community/isar.dart';

import 'enums.dart';

part 'food.g.dart';

@Collection(accessor: 'foods')
class Food {
  Id id = Isar.autoIncrement;

  @enumerated
  late FoodSource source;

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

  double? servingG;
  String? servingLabel;

  @Index()
  late bool isFavorite;

  @Index()
  DateTime? lastUsedAt;

  double? lastAmountG;

  DateTime? cachedAt;
  bool userOverridden = false;
}
