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

  static AppSettings defaults() {
    return AppSettings()
      ..id = 1
      ..onboardingDone = false
      ..kcalGoal = 2200
      ..proteinGoal = 120
      ..carbsGoal = 250
      ..fatGoal = 70
      ..theme = ThemeModeSetting.system
      ..catalogVersion = 0;
  }
}
