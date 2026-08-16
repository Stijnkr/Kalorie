import 'package:isar_community/isar.dart';

import '../../core/constants.dart';
import '../../core/serving.dart';
import '../local/collections/diary_entry.dart';
import '../local/collections/enums.dart';
import '../local/collections/food.dart';
import '../sync/sync_stamp.dart';

class DiaryRepository {
  DiaryRepository(this._isar);

  final Isar _isar;

  /// Gezet door de app zodat herinneringen opnieuw plannen na een log.
  void Function()? afterWrite;

  void _notify() => afterWrite?.call();

  Stream<List<DiaryEntry>> watchDay(int dateKey) {
    return _isar.diaryEntries
        .filter()
        .dateKeyEqualTo(dateKey)
        .and()
        .deletedEqualTo(false)
        .sortByCreatedAt()
        .watch(fireImmediately: true);
  }

  Stream<List<DiaryEntry>> watchRange(int fromKey, int toKey) {
    return _isar.diaryEntries
        .filter()
        .dateKeyBetween(fromKey, toKey)
        .and()
        .deletedEqualTo(false)
        .watch(fireImmediately: true);
  }

  Future<List<DiaryEntry>> day(int dateKey) {
    return _isar.diaryEntries
        .filter()
        .dateKeyEqualTo(dateKey)
        .and()
        .deletedEqualTo(false)
        .sortByCreatedAt()
        .findAll();
  }

  Future<List<DiaryEntry>> range(int fromKey, int toKey) {
    return _isar.diaryEntries
        .filter()
        .dateKeyBetween(fromKey, toKey)
        .and()
        .deletedEqualTo(false)
        .findAll();
  }

  Future<DiaryEntry?> getEntry(int id) => _isar.diaryEntries.get(id);

  Future<int> add({
    required Food food,
    required double amountG,
    required MealType meal,
    required int dateKey,
  }) async {
    final now = DateTime.now();
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
        name: food.name,
        liquid: ServingMath.looksLiquid(
          name: food.name,
          servingLabel: food.servingLabel,
        ),
      )
      ..kcal = NutrientMath.scale(food.kcal100g, amountG)
      ..protein = NutrientMath.scale(food.protein100g, amountG)
      ..carbs = NutrientMath.scale(food.carbs100g, amountG)
      ..fat = NutrientMath.scale(food.fat100g, amountG)
      ..fiber = NutrientMath.scaleOrNull(food.fiber100g, amountG)
      ..sugars = NutrientMath.scaleOrNull(food.sugars100g, amountG)
      ..satFat = NutrientMath.scaleOrNull(food.satFat100g, amountG)
      ..salt = NutrientMath.scaleOrNull(food.salt100g, amountG)
      ..createdAt = now
      ..clientId = newClientId()
      ..updatedAt = now
      ..dirty = true
      ..deleted = false;

    final id = await _isar.writeTxn(() async {
      food.lastUsedAt = now;
      food.lastAmountG = amountG;
      await _isar.foods.put(food);
      return _isar.diaryEntries.put(entry);
    });
    _notify();
    return id;
  }

  /// Losse regel zonder bronproduct, voor een gelogd recept.
  Future<int> addRaw(DiaryEntry entry) async {
    final now = DateTime.now();
    entry
      ..createdAt = now
      ..clientId = newClientId()
      ..updatedAt = now
      ..dirty = true
      ..deleted = false;
    final id = await _isar.writeTxn(() => _isar.diaryEntries.put(entry));
    _notify();
    return id;
  }

  /// Zachte verwijdering: de regel blijft staan als grafsteen tot de server
  /// hem kent, anders komt hij op je andere toestel gewoon terug.
  Future<void> delete(int id) async {
    await _isar.writeTxn(() async {
      final entry = await _isar.diaryEntries.get(id);
      if (entry == null) return;
      entry
        ..deleted = true
        ..dirty = true
        ..updatedAt = DateTime.now();
      await _isar.diaryEntries.put(entry);
    });
    _notify();
  }

  Future<void> restore(DiaryEntry entry) async {
    entry
      ..deleted = false
      ..dirty = true
      ..updatedAt = DateTime.now();
    await _isar.writeTxn(() => _isar.diaryEntries.put(entry));
    _notify();
  }

  Future<void> update({
    required DiaryEntry entry,
    required Food food,
    required double amountG,
    required MealType meal,
  }) async {
    entry
      ..meal = meal
      ..foodName = food.name
      ..brand = food.brand
      ..amountG = amountG
      ..servingLabel = ServingMath.describe(
        grams: amountG,
        servingG: food.servingG,
        servingLabel: food.servingLabel,
        name: food.name,
        liquid: ServingMath.looksLiquid(
          name: food.name,
          servingLabel: food.servingLabel,
        ),
      )
      ..kcal = NutrientMath.scale(food.kcal100g, amountG)
      ..protein = NutrientMath.scale(food.protein100g, amountG)
      ..carbs = NutrientMath.scale(food.carbs100g, amountG)
      ..fat = NutrientMath.scale(food.fat100g, amountG)
      ..fiber = NutrientMath.scaleOrNull(food.fiber100g, amountG)
      ..sugars = NutrientMath.scaleOrNull(food.sugars100g, amountG)
      ..satFat = NutrientMath.scaleOrNull(food.satFat100g, amountG)
      ..salt = NutrientMath.scaleOrNull(food.salt100g, amountG)
      ..dirty = true
      ..updatedAt = DateTime.now();
    await _isar.writeTxn(() => _isar.diaryEntries.put(entry));
    _notify();
  }

  /// Past een regel zonder bronproduct aan, zoals een gelogd recept.
  Future<void> updateRaw({
    required DiaryEntry entry,
    required double amountG,
    required MealType meal,
  }) async {
    final from = entry.amountG;
    entry
      ..meal = meal
      ..amountG = amountG
      ..servingLabel = '${amountG.round()} g'
      ..kcal = NutrientMath.rescale(entry.kcal, from, amountG)
      ..protein = NutrientMath.rescale(entry.protein, from, amountG)
      ..carbs = NutrientMath.rescale(entry.carbs, from, amountG)
      ..fat = NutrientMath.rescale(entry.fat, from, amountG)
      ..fiber = NutrientMath.rescaleOrNull(entry.fiber, from, amountG)
      ..sugars = NutrientMath.rescaleOrNull(entry.sugars, from, amountG)
      ..satFat = NutrientMath.rescaleOrNull(entry.satFat, from, amountG)
      ..salt = NutrientMath.rescaleOrNull(entry.salt, from, amountG)
      ..dirty = true
      ..updatedAt = DateTime.now();
    await _isar.writeTxn(() => _isar.diaryEntries.put(entry));
    _notify();
  }

  Future<Set<int>> loggedDateKeys(int fromKey, int toKey) async {
    final entries = await range(fromKey, toKey);
    return entries.map((e) => e.dateKey).toSet();
  }

  /// Heeft deze dag al iets in deze maaltijd staan? Gebruikt door de
  /// herinneringen: wat je al gelogd hebt, hoeft geen melding.
  Future<bool> hasEntryFor(int dateKey, MealType meal) async {
    final count = await _isar.diaryEntries
        .filter()
        .dateKeyEqualTo(dateKey)
        .and()
        .mealEqualTo(meal)
        .and()
        .deletedEqualTo(false)
        .count();
    return count > 0;
  }
}
