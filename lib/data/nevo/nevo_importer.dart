import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:isar_community/isar.dart';

import '../../core/constants.dart';
import '../local/collections/app_settings.dart';
import '../local/collections/enums.dart';
import '../local/collections/food.dart';

class NevoImporter {
  static const assetPath = 'assets/nevo/nevo_2025_9_0.min.json';
  static const version = '2025/9.0+portions';

  static Future<void> importIfNeeded(Isar isar) async {
    final raw = await rootBundle.loadString(assetPath);
    final decoded = jsonDecode(raw) as Map<String, dynamic>;
    final items = (decoded['items'] as List).cast<Map<String, dynamic>>();
    final fileVersion = decoded['version'] as String? ?? version;

    await isar.writeTxn(() async {
      for (final item in items) {
        final code = item['code'] as String;
        final servingG = (item['servingG'] as num?)?.toDouble();
        final servingLabel = item['servingLabel'] as String?;
        final existing =
            await isar.foods.filter().nevoCodeEqualTo(code).findFirst();
        if (existing != null) {
          if (!existing.userOverridden) {
            existing
              ..name = item['name'] as String
              ..nameNormalized = normalizeName(item['name'] as String)
              ..kcal100g = (item['kcal'] as num).toDouble()
              ..protein100g = (item['protein'] as num).toDouble()
              ..carbs100g = (item['carbs'] as num).toDouble()
              ..fat100g = (item['fat'] as num).toDouble();
          }
          if (existing.servingG == null && servingG != null) {
            existing
              ..servingG = servingG
              ..servingLabel = servingLabel;
          }
          await isar.foods.put(existing);
          continue;
        }
        final food = Food()
          ..source = FoodSource.nevo
          ..nevoCode = code
          ..name = item['name'] as String
          ..nameNormalized = normalizeName(item['name'] as String)
          ..brand = item['group'] as String?
          ..kcal100g = (item['kcal'] as num).toDouble()
          ..protein100g = (item['protein'] as num).toDouble()
          ..carbs100g = (item['carbs'] as num).toDouble()
          ..fat100g = (item['fat'] as num).toDouble()
          ..servingG = servingG
          ..servingLabel = servingLabel
          ..isFavorite = false
          ..userOverridden = false;
        await isar.foods.put(food);
      }

      final next = (await isar.settings.get(1)) ?? AppSettings.defaults();
      next
        ..nevoImportedAt = DateTime.now()
        ..nevoVersion = fileVersion;
      await isar.settings.put(next);
    });
  }
}
