import '../../core/constants.dart';
import '../../core/l10n/generated/app_localizations.dart';
import '../local/collections/enums.dart';
import '../local/collections/reminder.dart';
import '../repositories/diary_repository.dart';
import '../repositories/reminder_repository.dart';
import '../repositories/weight_repository.dart';
import 'reminder_service.dart';

/// Houdt de geplande meldingen gelijk aan wat er in Herinneringen staat.
///
/// Een melding kan bij het afgaan niet zelf in de database kijken, dus doen we
/// het andersom: bij elke synchronisatie slaan we vandaag over voor maaltijden
/// die al gelogd zijn. Dat is precies de belofte uit het ontwerp — je krijgt
/// geen zetje voor iets dat al binnen is.
class ReminderScheduler {
  ReminderScheduler(
    this._service,
    this._reminders,
    this._diary,
    this._weight,
  );

  final ReminderService _service;
  final ReminderRepository _reminders;
  final DiaryRepository _diary;
  final WeightRepository _weight;

  /// Wordt door de app-root gezet zodat de meldingteksten vertaald zijn.
  AppLocalizations? localizations;

  Future<void> sync() async {
    final l10n = localizations;
    if (l10n == null) return;
    final all = await _reminders.all();
    final today = DateKeys.today();

    for (final reminder in all) {
      if (!reminder.enabled) {
        await _service.cancel(reminder.kind);
        continue;
      }
      final meal = _mealFor(reminder.kind);
      final alreadyLogged = meal != null
          ? await _diary.hasEntryFor(today, meal)
          : reminder.kind == ReminderKind.weighIn &&
              await _weight.hasEntryFor(today);
      await _service.schedule(
        kind: reminder.kind,
        hour: reminder.hour,
        minute: reminder.minute,
        title: _title(l10n, reminder.kind),
        body: _body(l10n, reminder.kind),
        skipToday: alreadyLogged,
        weekday:
            reminder.kind == ReminderKind.weighIn ? reminder.weekday : null,
      );
    }
  }

  Future<void> cancelAll() => _service.cancelAll();

  static MealType? _mealFor(ReminderKind kind) => switch (kind) {
        ReminderKind.breakfast => MealType.breakfast,
        ReminderKind.lunch => MealType.lunch,
        ReminderKind.dinner => MealType.dinner,
        ReminderKind.snack => MealType.snack,
        ReminderKind.weighIn => null,
      };

  static String _title(AppLocalizations l10n, ReminderKind kind) =>
      switch (kind) {
        ReminderKind.breakfast => l10n.breakfast,
        ReminderKind.lunch => l10n.lunch,
        ReminderKind.dinner => l10n.dinner,
        ReminderKind.snack => l10n.snack,
        ReminderKind.weighIn => l10n.reminderWeighIn,
      };

  static String _body(AppLocalizations l10n, ReminderKind kind) {
    if (kind == ReminderKind.weighIn) return l10n.reminderWeighBody;
    return l10n.reminderBody(_title(l10n, kind).toLowerCase());
  }
}
