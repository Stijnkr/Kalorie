import 'package:isar_community/isar.dart';

import '../../core/constants.dart';
import '../../core/food_search_rank.dart';
import '../local/collections/enums.dart';
import '../local/collections/food.dart';

class FoodRepository {
  FoodRepository(this._isar);

  final Isar _isar;

  Future<Food?> getById(int id) => _isar.foods.get(id);

  Future<Food?> getByBarcode(String barcode) {
    return _isar.foods.filter().barcodeEqualTo(barcode).findFirst();
  }

  Future<Food?> getByNevoCode(String code) {
    return _isar.foods.filter().nevoCodeEqualTo(code).findFirst();
  }

  Future<List<Food>> searchLocal(String query, {int limit = 60}) async {
    final q = query.trim().toLowerCase();
    if (q.isEmpty) {
      return recents(limit: limit);
    }
    final matches = await _isar.foods
        .filter()
        .nameNormalizedContains(q)
        .or()
        .brandContains(q, caseSensitive: false)
        .findAll();
    matches.sort((a, b) => compareFoodSearch(a, b, q));
    if (matches.length <= limit) return matches;
    return matches.sublist(0, limit);
  }

  Future<List<Food>> recents({int limit = 30}) {
    return _isar.foods
        .filter()
        .lastUsedAtIsNotNull()
        .sortByLastUsedAtDesc()
        .limit(limit)
        .findAll();
  }

  Future<List<Food>> favorites({int limit = 60}) {
    return _isar.foods
        .filter()
        .isFavoriteEqualTo(true)
        .sortByName()
        .limit(limit)
        .findAll();
  }

  Future<List<Food>> browse({int limit = 80}) {
    return _isar.foods.where().sortByName().limit(limit).findAll();
  }

  Future<int> upsert(Food food) {
    food.nameNormalized = normalizeName(food.name);
    return _isar.writeTxn(() => _isar.foods.put(food));
  }

  Future<Food> cacheOffProduct(Food incoming) async {
    return _isar.writeTxn(() async {
      Food? existing;
      if (incoming.barcode != null && incoming.barcode!.isNotEmpty) {
        existing = await _isar.foods
            .filter()
            .barcodeEqualTo(incoming.barcode)
            .and()
            .sourceEqualTo(FoodSource.off)
            .findFirst();
      }
      if (existing == null && incoming.offId != null) {
        existing = await _isar.foods
            .filter()
            .offIdEqualTo(incoming.offId)
            .findFirst();
      }
      if (existing != null) {
        if (existing.userOverridden) {
          existing.cachedAt = DateTime.now();
          await _isar.foods.put(existing);
          return existing;
        }
        incoming.id = existing.id;
        incoming.isFavorite = existing.isFavorite;
        incoming.lastUsedAt = existing.lastUsedAt;
        incoming.lastAmountG = existing.lastAmountG;
        incoming.userOverridden = existing.userOverridden;
        incoming.servingG = existing.servingG ?? incoming.servingG;
        incoming.servingLabel = existing.servingLabel ?? incoming.servingLabel;
      }
      incoming.source = FoodSource.off;
      incoming.cachedAt = DateTime.now();
      incoming.nameNormalized = normalizeName(incoming.name);
      await _isar.foods.put(incoming);
      return incoming;
    });
  }

  Future<void> toggleFavorite(int id) async {
    await _isar.writeTxn(() async {
      final food = await _isar.foods.get(id);
      if (food == null) return;
      food.isFavorite = !food.isFavorite;
      await _isar.foods.put(food);
    });
  }

  Future<void> markUsed(int id) async {
    await _isar.writeTxn(() async {
      final food = await _isar.foods.get(id);
      if (food == null) return;
      food.lastUsedAt = DateTime.now();
      await _isar.foods.put(food);
    });
  }

  Future<List<Food>> staleOffRecents({
    required Duration maxAge,
    int limit = 10,
  }) {
    final cutoff = DateTime.now().subtract(maxAge);
    return _isar.foods
        .filter()
        .sourceEqualTo(FoodSource.off)
        .lastUsedAtIsNotNull()
        .and()
        .userOverriddenEqualTo(false)
        .and()
        .cachedAtLessThan(cutoff)
        .sortByLastUsedAtDesc()
        .limit(limit)
        .findAll();
  }
}
