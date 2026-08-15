import 'package:isar_community/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../core/constants.dart';
import '../data/local/collections/app_settings.dart';
import '../data/local/collections/diary_entry.dart';
import '../data/local/collections/food.dart';
import '../data/local/collections/recipe.dart';
import '../data/local/collections/reminder.dart';
import '../data/local/collections/sync_cursor.dart';
import '../data/local/collections/water_entry.dart';
import '../data/local/collections/weight_entry.dart';
import '../data/remote/off_client.dart';
import '../data/repositories/catalog_repository.dart';
import '../data/repositories/food_repository.dart';
import '../data/sync/local_identity.dart';

class KalorieBootstrap {
  KalorieBootstrap._();

  static late Isar isar;

  /// `false` wanneer de cloud-client niet startte.
  static bool cloudReady = false;

  static Future<Isar> init() async {
    await initializeDateFormatting('nl');
    final dir = await getApplicationDocumentsDirectory();
    final db = await Isar.open(
      [
        FoodSchema,
        DiaryEntrySchema,
        WeightEntrySchema,
        WaterEntrySchema,
        RecipeSchema,
        ReminderSchema,
        SyncCursorSchema,
        AppSettingsSchema,
      ],
      directory: dir.path,
      name: 'kalorie',
    );

    await db.writeTxn(() async {
      final existing = await db.settings.get(1);
      if (existing == null) {
        await db.settings.put(AppSettings.defaults());
      }
      if (await db.reminders.count() == 0) {
        await db.reminders.putAll([
          for (final (kind, hour, minute) in Reminder.defaults)
            Reminder.seed(kind, hour, minute),
        ]);
      }
    });
    await ensureLocalIdentity(db);

    await CatalogRepository(db, FoodRepository(db)).importSnapshotIfNeeded();
    configureOffClient();
    await _initSupabase();

    isar = db;
    return db;
  }

  static Future<bool> ensureCloud() async {
    if (cloudReady) return true;
    await _initSupabase();
    return cloudReady;
  }

  static Future<void> _initSupabase() async {
    if (!CatalogConfig.isCloudConfigured) return;
    try {
      await Supabase.initialize(
        url: CatalogConfig.supabaseUrl,
        publishableKey: CatalogConfig.supabasePublishableKey,
        authOptions: const FlutterAuthClientOptions(
          authFlowType: AuthFlowType.pkce,
        ),
      );
      cloudReady = true;
    } catch (_) {
      cloudReady = false;
    }
  }
}
