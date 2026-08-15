import 'package:isar_community/isar.dart';

import 'enums.dart';

part 'diary_entry.g.dart';

@Collection(accessor: 'diaryEntries')
class DiaryEntry {
  Id id = Isar.autoIncrement;

  @Index()
  late int dateKey;

  @enumerated
  late MealType meal;

  late int foodId;
  late String foodName;
  String? brand;

  @enumerated
  late FoodSource source;

  late double amountG;
  String? servingLabel;

  late double kcal;
  late double protein;
  late double carbs;
  late double fat;

  /// Vastgelegd bij het loggen, zodat "Alles zien" op de dagkaart klopt ook als
  /// het product later verandert. Null wanneer de bron ze niet kent.
  double? fiber;
  double? sugars;
  double? satFat;
  double? salt;

  late DateTime createdAt;
}
