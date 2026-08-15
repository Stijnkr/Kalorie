import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar_community/isar.dart';

import '../app/bootstrap.dart';
import '../core/constants.dart';
import '../core/day_summary.dart';
import 'export/data_exporter.dart';
import 'local/collections/app_settings.dart';
import 'local/collections/diary_entry.dart';
import 'local/collections/food.dart';
import 'local/collections/weight_entry.dart';
import 'remote/off_client.dart';
import 'repositories/diary_repository.dart';
import 'repositories/food_repository.dart';
import 'repositories/settings_repository.dart';
import 'repositories/weight_repository.dart';

final isarProvider = Provider<Isar>((ref) => KalorieBootstrap.isar);

final foodRepositoryProvider = Provider<FoodRepository>(
  (ref) => FoodRepository(ref.watch(isarProvider)),
);

final diaryRepositoryProvider = Provider<DiaryRepository>(
  (ref) => DiaryRepository(ref.watch(isarProvider)),
);

final settingsRepositoryProvider = Provider<SettingsRepository>(
  (ref) => SettingsRepository(ref.watch(isarProvider)),
);

final weightRepositoryProvider = Provider<WeightRepository>(
  (ref) => WeightRepository(ref.watch(isarProvider)),
);

final offRemoteProvider = Provider<OffRemoteDataSource>(
  (ref) => OffRemoteDataSource(),
);

final dataExporterProvider = Provider<DataExporter>(
  (ref) => DataExporter(ref.watch(isarProvider)),
);

final settingsProvider = StreamProvider<AppSettings>((ref) {
  return ref.watch(settingsRepositoryProvider).watch();
});

class SelectedDateKey extends Notifier<int> {
  @override
  int build() => DateKeys.today();

  void previous() => state = DateKeys.addDays(state, -1);
  void next() => state = DateKeys.addDays(state, 1);
  void previousWeek() => state = DateKeys.addDays(state, -7);
  void nextWeek() => state = DateKeys.addDays(state, 7);
  void setKey(int key) => state = key;
  void toToday() => state = DateKeys.today();
}

final selectedDateKeyProvider = NotifierProvider<SelectedDateKey, int>(
  SelectedDateKey.new,
);

final diaryDayProvider =
    StreamProvider.family<List<DiaryEntry>, int>((ref, dateKey) {
  return ref.watch(diaryRepositoryProvider).watchDay(dateKey);
});

final diaryRangeProvider =
    StreamProvider.family<List<DiaryEntry>, (int, int)>((ref, range) {
  return ref.watch(diaryRepositoryProvider).watchRange(range.$1, range.$2);
});

final daySummaryProvider = Provider.family<DaySummary, int>((ref, dateKey) {
  final entries = ref.watch(diaryDayProvider(dateKey)).value ?? const [];
  return DaySummary.fromEntries(dateKey, entries);
});

final weightLogProvider = StreamProvider<List<WeightEntry>>((ref) {
  return ref.watch(weightRepositoryProvider).watchAll();
});

final recentFoodsProvider = FutureProvider<List<Food>>((ref) {
  return ref.watch(foodRepositoryProvider).recents();
});

final favoriteFoodsProvider = FutureProvider<List<Food>>((ref) {
  return ref.watch(foodRepositoryProvider).favorites();
});
