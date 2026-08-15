import 'package:isar_community/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:intl/date_symbol_data_local.dart';

import '../data/local/collections/app_settings.dart';
import '../data/local/collections/diary_entry.dart';
import '../data/local/collections/food.dart';
import '../data/local/collections/weight_entry.dart';
import '../data/nevo/nevo_importer.dart';
import '../data/remote/off_client.dart';

class KalorieBootstrap {
  KalorieBootstrap._();

  static late Isar isar;

  static Future<Isar> init() async {
    await initializeDateFormatting('nl');
    final dir = await getApplicationDocumentsDirectory();
    final db = await Isar.open(
      [
        FoodSchema,
        DiaryEntrySchema,
        WeightEntrySchema,
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
    });

    await NevoImporter.importIfNeeded(db);
    configureOffClient();

    isar = db;
    return db;
  }
}
