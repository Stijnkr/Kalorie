import 'package:isar_community/isar.dart';

part 'reminder.g.dart';

/// Waar een herinnering over gaat. De namen komen overeen met de `meal`-kolom
/// van `public.reminders`.
enum ReminderKind { breakfast, lunch, dinner, snack, weighIn }

extension ReminderKindKey on ReminderKind {
  String get key => switch (this) {
        ReminderKind.weighIn => 'weigh_in',
        _ => name,
      };

  static ReminderKind fromKey(String key) => switch (key) {
        'weigh_in' => ReminderKind.weighIn,
        'lunch' => ReminderKind.lunch,
        'dinner' => ReminderKind.dinner,
        'snack' => ReminderKind.snack,
        _ => ReminderKind.breakfast,
      };
}

/// Eén zetje per dag, en alleen als je nog niets hebt gelogd.
@Collection(accessor: 'reminders')
class Reminder {
  Id id = Isar.autoIncrement;

  @Index(unique: true, replace: true)
  @enumerated
  late ReminderKind kind;

  late int hour;
  late int minute;
  late bool enabled;

  /// Alleen voor wegen: 1 = maandag … 7 = zondag (`DateTime.weekday`).
  int weekday = DateTime.monday;

  late DateTime updatedAt;

  @Index()
  bool dirty = true;

  static const defaults = <(ReminderKind, int, int)>[
    (ReminderKind.breakfast, 8, 30),
    (ReminderKind.lunch, 12, 30),
    (ReminderKind.dinner, 18, 30),
    (ReminderKind.snack, 21, 0),
    (ReminderKind.weighIn, 7, 30),
  ];

  static Reminder seed(ReminderKind kind, int hour, int minute) => Reminder()
    ..kind = kind
    ..hour = hour
    ..minute = minute
    ..enabled = false
    ..weekday = DateTime.monday
    ..updatedAt = DateTime.now()
    ..dirty = false;
}
