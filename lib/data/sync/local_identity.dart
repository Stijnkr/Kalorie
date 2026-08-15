import 'package:isar_community/isar.dart';

import '../local/collections/diary_entry.dart';
import '../local/collections/enums.dart';
import '../local/collections/food.dart';
import '../local/collections/reminder.dart';
import 'sync_stamp.dart';

/// Vult ontbrekende client-id's en weegdagen, zonder rijen dirty te maken.
/// Moet draaien vóór de eerste put op een geüpgraded schema, anders delen
/// oude dagboekregels een lege sleutel.
Future<void> ensureLocalIdentity(Isar isar) {
  return isar.writeTxn(() async {
    final entries = await isar.diaryEntries.where().findAll();
    final missingDiary = <DiaryEntry>[];
    for (final e in entries) {
      if (e.clientId.isNotEmpty) continue;
      e.clientId = newClientId();
      missingDiary.add(e);
    }
    if (missingDiary.isNotEmpty) {
      await isar.diaryEntries.putAll(missingDiary);
    }

    final customs = await isar.foods
        .filter()
        .sourceEqualTo(FoodSource.custom)
        .findAll();
    final missingFoods = <Food>[];
    for (final f in customs) {
      if (f.clientId != null && f.clientId!.isNotEmpty) continue;
      f.clientId = newClientId();
      missingFoods.add(f);
    }
    if (missingFoods.isNotEmpty) {
      await isar.foods.putAll(missingFoods);
    }

    final reminders = await isar.reminders.where().findAll();
    final brokenWeekday = <Reminder>[];
    for (final r in reminders) {
      if (r.weekday >= 1 && r.weekday <= 7) continue;
      r.weekday = DateTime.monday;
      brokenWeekday.add(r);
    }
    if (brokenWeekday.isNotEmpty) {
      await isar.reminders.putAll(brokenWeekday);
    }
  });
}
