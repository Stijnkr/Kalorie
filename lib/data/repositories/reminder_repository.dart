import 'package:isar_community/isar.dart';

import '../local/collections/reminder.dart';

class ReminderRepository {
  ReminderRepository(this._isar);

  final Isar _isar;

  Stream<List<Reminder>> watchAll() {
    return _isar.reminders
        .where()
        .sortByKind()
        .watch(fireImmediately: true);
  }

  Future<List<Reminder>> all() =>
      _isar.reminders.where().sortByKind().findAll();

  Future<void> setEnabled(ReminderKind kind, bool enabled) =>
      _update(kind, (r) => r.enabled = enabled);

  Future<void> setTime(ReminderKind kind, int hour, int minute) =>
      _update(kind, (r) {
        r
          ..hour = hour
          ..minute = minute;
      });

  Future<void> setWeekday(ReminderKind kind, int weekday) =>
      _update(kind, (r) => r.weekday = weekday.clamp(1, 7));

  Future<void> _update(ReminderKind kind, void Function(Reminder) change) {
    return _isar.writeTxn(() async {
      final reminder =
          await _isar.reminders.filter().kindEqualTo(kind).findFirst() ??
              (Reminder()
                ..kind = kind
                ..hour = 8
                ..minute = 0
                ..enabled = false);
      change(reminder);
      reminder
        ..updatedAt = DateTime.now()
        ..dirty = true;
      await _isar.reminders.put(reminder);
    });
  }
}
