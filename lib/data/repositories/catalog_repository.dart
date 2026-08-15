import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:isar_community/isar.dart';

import '../food/catalog_product.dart';
import '../food/match_key.dart';
import '../local/collections/app_settings.dart';
import '../local/collections/enums.dart';
import '../local/collections/food.dart';
import '../remote/catalog_client.dart';
import 'food_repository.dart';

class CatalogRepository {
  CatalogRepository(this._isar, this._foods, {CatalogClient? client})
      : _client = client ?? CatalogClient();

  static const snapshotAsset = 'assets/food/nevo_snapshot.min.json';

  final Isar _isar;
  final FoodRepository _foods;
  final CatalogClient _client;

  Future<void> importSnapshotIfNeeded() async {
    final raw = await rootBundle.loadString(snapshotAsset);
    final decoded = jsonDecode(raw) as Map<String, dynamic>;
    final items = (decoded['items'] as List).cast<Map<String, dynamic>>();
    final fileVersion = decoded['version'] as String? ?? snapshotAsset;
    final catalogVersion = (decoded['catalogVersion'] as num?)?.toInt() ?? 1;
    // De revisie verandert bij elke snapshot-build, de NEVO-versie alleen bij
    // een RIVM-release. Zonder revisie zou een correctie binnen dezelfde
    // release nooit landen op een toestel dat al geïmporteerd heeft.
    final revision = decoded['revision'] as String?;
    final importKey = '$fileVersion+${revision ?? ''}+$catalogVersion';
    final existingSettings = await _isar.settings.get(1);
    if (existingSettings?.nevoVersion == importKey) return;

    await _isar.writeTxn(() async {
      final stale = await _isar.foods
          .filter()
          .sourceEqualTo(FoodSource.nevo)
          .userOverriddenEqualTo(false)
          .findAll();
      if (stale.isNotEmpty) {
        await _isar.foods.deleteAll(stale.map((food) => food.id).toList());
      }
      for (final item in items) {
        await _upsertUnlocked(CatalogProduct.fromJson(item));
      }
      final next = (await _isar.settings.get(1)) ?? AppSettings.defaults();
      next
        ..nevoImportedAt = DateTime.now()
        ..nevoVersion = importKey
        ..catalogVersion = next.catalogVersion < catalogVersion
            ? catalogVersion
            : next.catalogVersion;
      await _isar.settings.put(next);
    });
  }

  Future<List<Food>> searchRemote(String query, {int limit = 30}) async {
    if (!_client.isConfigured) return <Food>[];
    final products = await _client.search(query, limit: limit);
    final stored = <Food>[];
    for (final product in products) {
      stored.add(await upsertCatalogProduct(product));
    }
    return stored;
  }

  Future<Food?> getRemoteByBarcode(String barcode) async {
    final local = await _foods.getByBarcode(
      MatchKey.normalizeBarcode(barcode) ?? barcode,
    );
    if (local != null) return local;
    if (!_client.isConfigured) return null;
    final product = await _client.getByBarcode(barcode);
    if (product == null) return null;
    return upsertCatalogProduct(product);
  }

  Future<int> syncDelta() async {
    if (!_client.isConfigured) return 0;
    final settings = await _isar.settings.get(1);
    final localVersion = settings?.catalogVersion ?? 0;
    final remoteVersion = await _client.catalogVersion();
    if (remoteVersion <= localVersion) return 0;
    var applied = 0;
    var cursor = localVersion;
    while (cursor < remoteVersion) {
      final batch = await _client.productsSince(cursor);
      if (batch.isEmpty) break;
      for (final product in batch) {
        await upsertCatalogProduct(product);
        applied++;
        if (product.dataVersion > cursor) cursor = product.dataVersion;
      }
      if (batch.length < 500) break;
    }
    await _isar.writeTxn(() async {
      final next = (await _isar.settings.get(1)) ?? AppSettings.defaults();
      next.catalogVersion = remoteVersion;
      await _isar.settings.put(next);
    });
    return applied;
  }

  Future<Food> upsertCatalogProduct(CatalogProduct product) {
    return _isar.writeTxn(() => _upsertUnlocked(product));
  }

  Future<Food> _upsertUnlocked(CatalogProduct product) async {
    Food? existing;
    if (product.id.isNotEmpty) {
      existing = await _isar.foods
          .filter()
          .catalogIdEqualTo(product.id)
          .findFirst();
    }
    existing ??= product.nevoCode == null
        ? null
        : await _isar.foods.filter().nevoCodeEqualTo(product.nevoCode).findFirst();
    existing ??= product.barcode == null
        ? null
        : await _isar.foods.filter().barcodeEqualTo(product.barcode).findFirst();

    if (existing != null && existing.userOverridden) {
      existing.cachedAt = DateTime.now();
      await _isar.foods.put(existing);
      return existing;
    }

    final food = product.toFood(existing: existing);
    food.cachedAt = DateTime.now();
    await _isar.foods.put(food);
    return food;
  }
}
