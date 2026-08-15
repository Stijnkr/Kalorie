import 'package:flutter_test/flutter_test.dart';
import 'package:kalorie/data/notifications/reminder_service.dart';
import 'package:timezone/data/latest_all.dart' as tzdata;
import 'package:timezone/timezone.dart' as tz;

void main() {
  setUpAll(() {
    tzdata.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation('Europe/Amsterdam'));
  });

  tz.TZDateTime at(int hour, int minute) =>
      tz.TZDateTime(tz.local, 2026, 8, 17, hour, minute); // maandag

  test('later vandaag blijft vandaag', () {
    final next = ReminderService.nextOccurrence(
      12,
      30,
      now: at(8, 0),
    );
    expect(next.day, 17);
    expect(next.hour, 12);
  });

  test('tijd die al voorbij is schuift naar morgen', () {
    final next = ReminderService.nextOccurrence(
      8,
      0,
      now: at(9, 0),
    );
    expect(next.day, 18);
  });

  test('al gelogd slaat vandaag over', () {
    final next = ReminderService.nextOccurrence(
      12,
      30,
      skipToday: true,
      now: at(8, 0),
    );
    expect(next.day, 18);
  });

  test('wekelijks landen op de gekozen weekdag', () {
    final next = ReminderService.nextOccurrence(
      7,
      30,
      weekday: DateTime.wednesday,
      now: at(6, 0),
    );
    expect(next.weekday, DateTime.wednesday);
    expect(next.day, 19);
  });

  test('wekelijks slaat deze week over als het moment voorbij is', () {
    final next = ReminderService.nextOccurrence(
      7,
      30,
      weekday: DateTime.monday,
      now: at(8, 0),
    );
    expect(next.weekday, DateTime.monday);
    expect(next.day, 24);
  });
}
