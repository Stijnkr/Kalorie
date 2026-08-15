import 'package:isar_community/isar.dart';

import '../../core/macro_goals.dart';
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

  /// [synced] is `true` wanneer de wijziging van de server komt; die hoeft niet
  /// meteen terug gepusht te worden.
  Future<void> save(AppSettings settings, {bool synced = false}) {
    settings.id = 1;
    if (!synced) {
      settings
        ..updatedAt = DateTime.now()
        ..dirty = true;
    }
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

  /// Verschuift het dagdoel en schaalt de macro's mee, zodat de verhouding
  /// blijft staan zonder dat je alles opnieuw invult.
  Future<void> setKcalGoal(int kcal) async {
    final settings = await get();
    final current = MacroGoals(
      protein: settings.proteinGoal,
      carbs: settings.carbsGoal,
      fat: settings.fatGoal,
    );
    final scaled = current.scaledTo(settings.kcalGoal, kcal);
    settings
      ..kcalGoal = kcal
      ..proteinGoal = scaled.protein
      ..carbsGoal = scaled.carbs
      ..fatGoal = scaled.fat;
    await save(settings);
  }

  Future<void> setMacroGoals(MacroGoals goals) async {
    final settings = await get();
    settings
      ..proteinGoal = goals.protein
      ..carbsGoal = goals.carbs
      ..fatGoal = goals.fat;
    await save(settings);
  }

  Future<void> setDisplayName(String? name) async {
    final settings = await get();
    settings.displayName = (name?.trim().isEmpty ?? true) ? null : name!.trim();
    await save(settings);
  }

  Future<void> setCloudUserId(String? id) async {
    final settings = await get();
    settings.cloudUserId = id;
    await _isar.writeTxn(() => _isar.settings.put(settings));
  }

  Future<void> setAppLockEnabled(bool value) async {
    final settings = await get();
    settings.appLockEnabled = value;
    await _isar.writeTxn(() => _isar.settings.put(settings));
  }

  Future<void> markReleaseNotesSeen(String version) async {
    final settings = await get();
    if (settings.seenReleaseNotes == version) return;
    settings.seenReleaseNotes = version;
    await _isar.writeTxn(() => _isar.settings.put(settings));
  }

  Future<void> setSyncPreferences({bool? diary, bool? weight}) async {
    final settings = await get();
    if (diary != null) settings.syncDiary = diary;
    if (weight != null) settings.syncWeight = weight;
    await save(settings);
  }
}
