import 'package:isar_community/isar.dart';

import '../local/collections/recipe.dart';
import '../sync/sync_stamp.dart';

class RecipeRepository {
  RecipeRepository(this._isar);

  final Isar _isar;

  Stream<List<Recipe>> watchAll() {
    return _isar.recipes
        .filter()
        .deletedEqualTo(false)
        .sortByName()
        .watch(fireImmediately: true);
  }

  Future<List<Recipe>> all() {
    return _isar.recipes.filter().deletedEqualTo(false).sortByName().findAll();
  }

  Future<Recipe?> getById(int id) => _isar.recipes.get(id);

  Future<int> save(Recipe recipe) {
    recipe
      ..clientId = recipe.clientId.isEmpty ? newClientId() : recipe.clientId
      ..updatedAt = DateTime.now()
      ..dirty = true
      ..deleted = false;
    return _isar.writeTxn(() => _isar.recipes.put(recipe));
  }

  Recipe draft() => Recipe()
    ..clientId = newClientId()
    ..name = ''
    ..portions = 1
    ..itemsJson = '[]'
    ..updatedAt = DateTime.now();

  Future<void> delete(int id) {
    return _isar.writeTxn(() async {
      final recipe = await _isar.recipes.get(id);
      if (recipe == null) return;
      recipe
        ..deleted = true
        ..dirty = true
        ..updatedAt = DateTime.now();
      await _isar.recipes.put(recipe);
    });
  }
}
