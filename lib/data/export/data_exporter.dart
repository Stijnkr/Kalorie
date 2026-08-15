import 'dart:convert';

import 'package:isar_community/isar.dart';

import '../local/collections/app_settings.dart';
import '../local/collections/diary_entry.dart';
import '../local/collections/enums.dart';
import '../local/collections/food.dart';
import '../local/collections/weight_entry.dart';

class DataExporter {
  DataExporter(this._isar);

  final Isar _isar;

  Future<String> exportJson() async {
    final settings = await _isar.settings.get(1);
    final foods = await _isar.foods
        .filter()
        .sourceEqualTo(FoodSource.custom)
        .or()
        .isFavoriteEqualTo(true)
        .findAll();
    final entries = await _isar.diaryEntries.where().findAll();
    final weights = await _isar.weightEntries.where().findAll();

    final payload = {
      'app': 'Kalorie',
      'version': '0.1.0',
      'exportedAt': DateTime.now().toIso8601String(),
      'settings': {
        'kcalGoal': settings?.kcalGoal,
        'proteinGoal': settings?.proteinGoal,
        'carbsGoal': settings?.carbsGoal,
        'fatGoal': settings?.fatGoal,
        'theme': settings?.theme.name,
      },
      'foods': foods
          .map(
            (f) => {
              'id': f.id,
              'source': f.source.name,
              'name': f.name,
              'brand': f.brand,
              'barcode': f.barcode,
              'kcal100g': f.kcal100g,
              'protein100g': f.protein100g,
              'carbs100g': f.carbs100g,
              'fat100g': f.fat100g,
              'isFavorite': f.isFavorite,
            },
          )
          .toList(),
      'diary': entries
          .map(
            (e) => {
              'dateKey': e.dateKey,
              'meal': e.meal.name,
              'foodName': e.foodName,
              'amountG': e.amountG,
              'kcal': e.kcal,
              'protein': e.protein,
              'carbs': e.carbs,
              'fat': e.fat,
            },
          )
          .toList(),
      'weight': weights
          .map((w) => {'dateKey': w.dateKey, 'kg': w.kg})
          .toList(),
    };

    return const JsonEncoder.withIndent('  ').convert(payload);
  }
}
