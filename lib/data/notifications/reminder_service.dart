import 'dart:io' show Platform;

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tzdata;
import 'package:timezone/timezone.dart' as tz;

import '../local/collections/reminder.dart';

/// Plant de dagelijkse zetjes in. Elke herinnering krijgt een vast id per soort,
/// zodat opnieuw plannen de vorige overschrijft in plaats van te stapelen.
class ReminderService {
  ReminderService(this._plugin);

  final FlutterLocalNotificationsPlugin _plugin;

  static const _channelId = 'kalorie_reminders';
  static const _channelName = 'Herinneringen';

  bool _ready = false;

  Future<void> init() async {
    if (_ready) return;
    tzdata.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation(await _localTimezone()));
    await _plugin.initialize(
      settings: const InitializationSettings(
        iOS: DarwinInitializationSettings(
          requestAlertPermission: false,
          requestBadgePermission: false,
          requestSoundPermission: false,
        ),
        android: AndroidInitializationSettings('@mipmap/ic_launcher'),
      ),
    );
    _ready = true;
  }

  /// Vraagt toestemming; `false` betekent dat de gebruiker het heeft geweigerd.
  Future<bool> requestPermission() async {
    await init();
    if (Platform.isIOS) {
      final granted = await _plugin
          .resolvePlatformSpecificImplementation<
              IOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions(alert: true, badge: true, sound: true);
      return granted ?? false;
    }
    final granted = await _plugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();
    return granted ?? false;
  }

  Future<void> cancel(ReminderKind kind) async {
    await init();
    await _plugin.cancel(id: kind.index);
  }

  Future<void> cancelAll() async {
    await init();
    await _plugin.cancelAll();
  }

  /// Zet één melding klaar. De tekst wordt meegegeven zodat de vertaling uit
  /// de UI-laag komt.
  Future<void> schedule({
    required ReminderKind kind,
    required int hour,
    required int minute,
    required String title,
    required String body,
    bool skipToday = false,
    int? weekday,
  }) async {
    await init();
    await _plugin.cancel(id: kind.index);
    await _plugin.zonedSchedule(
      id: kind.index,
      title: title,
      body: body,
      scheduledDate: nextOccurrence(
        hour,
        minute,
        skipToday: skipToday,
        weekday: weekday,
      ),
      notificationDetails: const NotificationDetails(
        iOS: DarwinNotificationDetails(),
        android: AndroidNotificationDetails(
          _channelId,
          _channelName,
          importance: Importance.defaultImportance,
          priority: Priority.defaultPriority,
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      matchDateTimeComponents: weekday == null
          ? DateTimeComponents.time
          : DateTimeComponents.dayOfWeekAndTime,
    );
  }

  /// Volgende geldige tijd. [weekday] is 1 = maandag … 7 = zondag.
  static tz.TZDateTime nextOccurrence(
    int hour,
    int minute, {
    bool skipToday = false,
    int? weekday,
    tz.TZDateTime? now,
  }) {
    final current = now ?? tz.TZDateTime.now(tz.local);
    var next = tz.TZDateTime(
      current.location,
      current.year,
      current.month,
      current.day,
      hour,
      minute,
    );
    if (weekday != null) {
      final target = weekday.clamp(1, 7);
      var days = (target - next.weekday) % 7;
      if (days < 0) days += 7;
      if (days == 0 && (!next.isAfter(current) || skipToday)) {
        days = 7;
      }
      return next.add(Duration(days: days));
    }
    if (!next.isAfter(current) || skipToday) {
      next = next.add(const Duration(days: 1));
    }
    return next;
  }

  static Future<String> _localTimezone() async {
    // De app is Nederlands; CET/CEST valt op Amsterdam. Andere offsets
    // blijven UTC tot we de platformzone kunnen lezen.
    try {
      final name = DateTime.now().timeZoneName;
      if (tz.timeZoneDatabase.locations.containsKey(name)) return name;
      final offset = DateTime.now().timeZoneOffset;
      if (offset.inHours == 1 || offset.inHours == 2) {
        return 'Europe/Amsterdam';
      }
    } catch (_) {
      // negeren
    }
    return 'UTC';
  }
}
