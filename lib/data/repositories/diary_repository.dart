import 'package:isar_community/isar.dart';

import '../../core/constants.dart';
import '../../core/serving.dart';
import '../local/collections/diary_entry.dart';
import '../local/collections/enums.dart';
import '../local/collections/food.dart';

class DiaryRepository {
  DiaryRepository(this._isar);

  final Isar _isar;

  Stream<List<DiaryEntry>> watchDay(int dateKey) {
    return _isar.diaryEntries
        .filter()
        .dateKeyEqualTo(dateKey)
        .sortByCreatedAt()
        .watch(fireImmediately: true);
  }

  Stream<List<DiaryEntry>> watchRange(int fromKey, int toKey) {
    return _isar.diaryEntries
        .filter()
        .dateKeyBetween(fromKey, toKey)
        .watch(fireImmediately: true);
  }

  Future<List<DiaryEntry>> day(int dateKey) {
    return _isar.diaryEntries
        .filter()
        .dateKeyEqualTo(dateKey)
        .sortByCreatedAt()
        .findAll();
  }

  Future<List<DiaryEntry>> range(int fromKey, int toKey) {
    return _isar.diaryEntries
        .filter()
        .dateKeyBetween(fromKey, toKey)
        .findAll();
  }

  Future<DiaryEntry?> getEntry(int id) => _isar.diaryEntries.get(id);

  Future<int> add({
    required Food food,
    required double amountG,
    required MealType meal,
    required int dateKey,
  }) {
    final entry = DiaryEntry()
      ..dateKey = dateKey
      ..meal = meal
      ..foodId = food.id
      ..foodName = food.name
      ..brand = food.brand
      ..source = food.source
      ..amountG = amountG
      ..servingLabel = ServingMath.describe(
        grams: amountG,
        servingG: food.servingG,
        servingLabel: food.servingLabel,
      )
      ..kcal = NutrientMath.scale(food.kcal100g, amountG)
      ..protein = NutrientMath.scale(food.protein100g, amountG)
      ..carbs = NutrientMath.scale(food.carbs100g, amountG)
      ..fat = NutrientMath.scale(food.fat100g, amountG)
      ..fiber = NutrientMath.scaleOrNull(food.fiber100g, amountG)
      ..sugars = NutrientMath.scaleOrNull(food.sugars100g, amountG)
      ..satFat = NutrientMath.scaleOrNull(food.satFat100g, amountG)
      ..salt = NutrientMath.scaleOrNull(food.salt100g, amountG)
      ..createdAt = DateTime.now();

    return _isar.writeTxn(() async {
      food.lastUsedAt = DateTime.now();
      food.lastAmountG = amountG;
      await _isar.foods.put(food);
      return _isar.diaryEntries.put(entry);
    });
  }

  Future<void> delete(int id) {
    return _isar.writeTxn(() => _isar.diaryEntries.delete(id));
  }

  /// Zet een verwijderde regel terug op zijn oude id, voor "Ongedaan".
  Future<void> restore(DiaryEntry entry) {
    return _isar.writeTxn(() => _isar.diaryEntries.put(entry));
  }

  Future<void> update({
    required DiaryEntry entry,
    required Food food,
    required double amountG,
    required MealType meal,
  }) {
    entry
      ..meal = meal
      ..foodName = food.name
      ..brand = food.brand
      ..amountG = amountG
      ..servingLabel = ServingMath.describe(
        grams: amountG,
        servingG: food.servingG,
        servingLabel: food.servingLabel,
      )
      ..kcal = NutrientMath.scale(food.kcal100g, amountG)
      ..protein = NutrientMath.scale(food.protein100g, amountG)
      ..carbs = NutrientMath.scale(food.carbs100g, amountG)
      ..fat = NutrientMath.scale(food.fat100g, amountG)
      ..fiber = NutrientMath.scaleOrNull(food.fiber100g, amountG)
      ..sugars = NutrientMath.scaleOrNull(food.sugars100g, amountG)
      ..satFat = NutrientMath.scaleOrNull(food.satFat100g, amountG)
      ..salt = NutrientMath.scaleOrNull(food.salt100g, amountG);
    return _isar.writeTxn(() => _isar.diaryEntries.put(entry));
  }

  Future<Set<int>> loggedDateKeys(int fromKey, int toKey) async {
    final entries = await range(fromKey, toKey);
    return entries.map((e) => e.dateKey).toSet();
  }
}
