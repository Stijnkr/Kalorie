import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar_community/isar.dart';
import 'package:supabase_flutter/supabase_flutter.dart' show Session, User;

import '../app/bootstrap.dart';
import '../core/constants.dart';
import '../core/day_summary.dart';
import '../core/macro_goals.dart';
import 'export/data_exporter.dart';
import 'notifications/reminder_scheduler.dart';
import 'notifications/reminder_service.dart';
import 'local/collections/app_settings.dart';
import 'local/collections/diary_entry.dart';
import 'local/collections/enums.dart';
import 'local/collections/food.dart';
import 'local/collections/recipe.dart';
import 'local/collections/reminder.dart';
import 'local/collections/weight_entry.dart';
import 'remote/catalog_client.dart';
import 'remote/off_client.dart';
import 'repositories/catalog_repository.dart';
import 'repositories/diary_repository.dart';
import 'repositories/food_repository.dart';
import 'repositories/auth_repository.dart';
import 'repositories/feedback_repository.dart';
import 'repositories/recipe_repository.dart';
import 'repositories/reminder_repository.dart';
import 'repositories/settings_repository.dart';
import 'repositories/water_repository.dart';
import 'repositories/weight_repository.dart';
import 'sync/sync_engine.dart';

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

final waterRepositoryProvider = Provider<WaterRepository>(
  (ref) => WaterRepository(ref.watch(isarProvider)),
);

final offRemoteProvider = Provider<OffRemoteDataSource>(
  (ref) => OffRemoteDataSource(),
);

final catalogClientProvider = Provider<CatalogClient>(
  (ref) => CatalogClient(),
);

final catalogRepositoryProvider = Provider<CatalogRepository>(
  (ref) => CatalogRepository(
    ref.watch(isarProvider),
    ref.watch(foodRepositoryProvider),
    client: ref.watch(catalogClientProvider),
  ),
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

/// Dagen met minstens één regel, voor de stipjes in de kalender.
final loggedDaysProvider =
    FutureProvider.family<Set<int>, (int, int)>((ref, range) {
  // Meelezen met de dagstroom zodat de kalender bijwerkt na een log.
  ref.watch(diaryRangeProvider(range));
  return ref.watch(diaryRepositoryProvider).loggedDateKeys(range.$1, range.$2);
});

final waterDayProvider = StreamProvider.family<int, int>((ref, dateKey) {
  return ref.watch(waterRepositoryProvider).watchDay(dateKey);
});

/// Dagdoel voor kcal, met een terugval zodat schermen nooit op 0 rekenen.
final kcalGoalProvider = Provider<int>((ref) {
  return ref.watch(settingsProvider).value?.kcalGoal ?? MacroGoals.defaultKcal;
});

final macroGoalsProvider = Provider<MacroGoals>((ref) {
  final settings = ref.watch(settingsProvider).value;
  if (settings == null) return MacroGoals.defaults;
  return MacroGoals(
    protein: settings.proteinGoal,
    carbs: settings.carbsGoal,
    fat: settings.fatGoal,
  );
});

final weightLogProvider = StreamProvider<List<WeightEntry>>((ref) {
  return ref.watch(weightRepositoryProvider).watchAll();
});

final recentFoodsProvider = FutureProvider<List<Food>>((ref) {
  return ref.watch(foodRepositoryProvider).recents();
});

/// Wat bovenaan het logvel staat: je laatst gebruikte producten, en voor een
/// lege database een greep uit de catalogus zodat het vel nooit leeg opent.
final quickLogFoodsProvider = FutureProvider<List<Food>>((ref) async {
  final repo = ref.watch(foodRepositoryProvider);
  final recents = await repo.recents(limit: 6);
  if (recents.isNotEmpty) return recents;
  final browse = await repo.browse(limit: 6);
  return browse.take(6).toList();
});

final favoriteFoodsProvider = FutureProvider<List<Food>>((ref) {
  return ref.watch(foodRepositoryProvider).favorites();
});

final customFoodsProvider = StreamProvider<List<Food>>((ref) {
  return ref
      .watch(isarProvider)
      .foods
      .filter()
      .sourceEqualTo(FoodSource.custom)
      .and()
      .deletedEqualTo(false)
      .sortByName()
      .watch(fireImmediately: true);
});

/// Aantal producten dat je zelf hebt ingevoerd, voor de rij in Meer.
final customFoodCountProvider = Provider<int>((ref) {
  return ref.watch(customFoodsProvider).value?.length ?? 0;
});

// ----------------------------------------------------------------- account

final authRepositoryProvider = Provider<AuthRepository>(
  (ref) => AuthRepository(),
);

final feedbackRepositoryProvider = Provider<FeedbackRepository>(
  (ref) => FeedbackRepository(),
);

/// Volgt in- en uitloggen. `null` betekent: niet ingelogd, alles blijft lokaal.
final authStateProvider = StreamProvider<Session?>((ref) {
  final auth = ref.watch(authRepositoryProvider);
  if (!auth.isAvailable) return Stream.value(null);
  return auth.changes.map((event) => event.session);
});

final currentUserProvider = Provider<User?>((ref) {
  final session = ref.watch(authStateProvider).value;
  if (session != null) return session.user;
  return ref.watch(authRepositoryProvider).user;
});

final isSignedInProvider = Provider<bool>(
  (ref) => ref.watch(currentUserProvider) != null,
);

// -------------------------------------------------------------------- sync

final syncEngineProvider = Provider<SyncEngine>((ref) {
  final engine = SyncEngine(ref.watch(isarProvider));
  ref.onDispose(engine.dispose);
  return engine;
});

final syncStatusProvider = StreamProvider<SyncStatus>((ref) {
  final engine = ref.watch(syncEngineProvider);
  return engine.statusStream;
});

// --------------------------------------------------------------- recepten

final recipeRepositoryProvider = Provider<RecipeRepository>(
  (ref) => RecipeRepository(ref.watch(isarProvider)),
);

final recipesProvider = StreamProvider<List<Recipe>>((ref) {
  return ref.watch(recipeRepositoryProvider).watchAll();
});

// ----------------------------------------------------------- herinneringen

final reminderRepositoryProvider = Provider<ReminderRepository>(
  (ref) => ReminderRepository(ref.watch(isarProvider)),
);

final remindersProvider = StreamProvider<List<Reminder>>((ref) {
  return ref.watch(reminderRepositoryProvider).watchAll();
});

final reminderServiceProvider = Provider<ReminderService>(
  (ref) => ReminderService(FlutterLocalNotificationsPlugin()),
);

final reminderSchedulerProvider = Provider<ReminderScheduler>(
  (ref) => ReminderScheduler(
    ref.watch(reminderServiceProvider),
    ref.watch(reminderRepositoryProvider),
    ref.watch(diaryRepositoryProvider),
    ref.watch(weightRepositoryProvider),
  ),
);

/// Hoeveel herinneringen aanstaan, voor de rij in Meer.
final enabledRemindersProvider = Provider<int>((ref) {
  final reminders = ref.watch(remindersProvider).value ?? const <Reminder>[];
  return reminders.where((r) => r.enabled).length;
});
