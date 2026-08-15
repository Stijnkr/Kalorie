import 'package:isar_community/isar.dart';

import '../local/collections/app_settings.dart';
import '../local/collections/enums.dart';

class SettingsRepository {
  SettingsRepository(this._isar);

  final Isar _isar;

  Stream<AppSettings> watch() {
    return _isar.settings
        .watchObject(1, fireImmediately: true)
        .map((value) => value ?? AppSettings.defaults());
  }

  Future<AppSettings> get() async {
    return (await _isar.settings.get(1)) ?? AppSettings.defaults();
  }

  Future<void> save(AppSettings settings) {
    settings.id = 1;
    return _isar.writeTxn(() => _isar.settings.put(settings));
  }

  Future<void> completeOnboarding({
    required int kcal,
    required double protein,
    required double carbs,
    required double fat,
  }) async {
    final settings = await get();
    settings
      ..onboardingDone = true
      ..kcalGoal = kcal
      ..proteinGoal = protein
      ..carbsGoal = carbs
      ..fatGoal = fat;
    await save(settings);
  }

  Future<void> setTheme(ThemeModeSetting theme) async {
    final settings = await get();
    settings.theme = theme;
    await save(settings);
  }

  Future<void> setGoals({
    required int kcal,
    required double protein,
    required double carbs,
    required double fat,
  }) async {
    final settings = await get();
    settings
      ..kcalGoal = kcal
      ..proteinGoal = protein
      ..carbsGoal = carbs
      ..fatGoal = fat;
    await save(settings);
  }
}
