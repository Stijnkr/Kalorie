import 'package:isar_community/isar.dart';

import 'enums.dart';

part 'app_settings.g.dart';

@Collection(accessor: 'settings')
class AppSettings {
  Id id = 1;

  late bool onboardingDone;
  late int kcalGoal;
  late double proteinGoal;
  late double carbsGoal;
  late double fatGoal;

  @enumerated
  late ThemeModeSetting theme;

  DateTime? nevoImportedAt;
  String? nevoVersion;
  int catalogVersion = 0;

  /// Naam zoals die op het accountscherm staat.
  String? displayName;

  /// Cloud-account waarvan de lokale gebruikersdata is. Blijft na uitloggen
  /// staan, zodat dezelfde gebruiker terugkan zonder data te mengen.
  String? cloudUserId;

  bool syncDiary = true;
  bool syncWeight = true;

  /// Laatst bekeken release-notes. Null betekent: nog niets gezien.
  String? seenReleaseNotes;

  /// `null` = nog niet gekozen, dan staat de vergrendeling aan.
  bool? appLockEnabled;

  DateTime? updatedAt;
  bool dirty = false;

  static AppSettings defaults() {
    return AppSettings()
      ..id = 1
      ..onboardingDone = false
      ..kcalGoal = 2200
      ..proteinGoal = 120
      ..carbsGoal = 250
      ..fatGoal = 70
      ..theme = ThemeModeSetting.system
      ..syncDiary = true
      ..syncWeight = true
      ..catalogVersion = 0
      ..appLockEnabled = true;
  }
}

extension AppSettingsLock on AppSettings {
  /// Aan tenzij iemand hem bewust uitzet.
  bool get lockEnabled => appLockEnabled != false;
}
