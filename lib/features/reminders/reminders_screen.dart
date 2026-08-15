import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/theme.dart';
import '../../core/l10n/generated/app_localizations.dart';
import '../../core/widgets/kalorie_ui.dart';
import '../../core/widgets/panel.dart';
import '../../data/local/collections/reminder.dart';
import '../../data/providers.dart';

class RemindersScreen extends ConsumerWidget {
  const RemindersScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final tones = context.tones;
    final reminders = ref.watch(remindersProvider).value ?? const <Reminder>[];

    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            KalorieOverlayHeader(
              title: l10n.reminders,
              onBack: () => context.pop(),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(16, 6, 16, 40),
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(4, 0, 4, 14),
                    child: Text(
                      l10n.remindersIntro,
                      style: theme.textTheme.bodySmall?.copyWith(height: 1.5),
                    ),
                  ),
                  KaloriePanel(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        for (var i = 0; i < reminders.length; i++) ...[
                          if (i != 0) const KalorieHairline(),
                          _ReminderRow(reminder: reminders[i]),
                        ],
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(4, 16, 4, 0),
                    child: Text(
                      l10n.remindersFootnote,
                      style: theme.textTheme.labelMedium
                          ?.copyWith(color: tones.hint, height: 1.6),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ReminderRow extends ConsumerWidget {
  const _ReminderRow({required this.reminder});

  final Reminder reminder;

  Future<void> _pickTime(BuildContext context, WidgetRef ref) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(hour: reminder.hour, minute: reminder.minute),
      builder: (context, child) => MediaQuery(
        data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
        child: child!,
      ),
    );
    if (picked == null) return;
    await ref
        .read(reminderRepositoryProvider)
        .setTime(reminder.kind, picked.hour, picked.minute);
    await ref.read(reminderSchedulerProvider).sync();
  }

  Future<void> _pickWeekday(BuildContext context, WidgetRef ref) async {
    final picked = await showModalBottomSheet<int>(
      context: context,
      showDragHandle: true,
      builder: (context) {
        final l10n = AppLocalizations.of(context);
        final labels = [
          l10n.weekdayMonday,
          l10n.weekdayTuesday,
          l10n.weekdayWednesday,
          l10n.weekdayThursday,
          l10n.weekdayFriday,
          l10n.weekdaySaturday,
          l10n.weekdaySunday,
        ];
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (var i = 0; i < labels.length; i++)
                  KaloriePill(
                    label: labels[i],
                    large: true,
                    selected: reminder.weekday == i + 1,
                    onTap: () => Navigator.pop(context, i + 1),
                  ),
              ],
            ),
          ),
        );
      },
    );
    if (picked == null) return;
    await ref.read(reminderRepositoryProvider).setWeekday(reminder.kind, picked);
    await ref.read(reminderSchedulerProvider).sync();
  }

  Future<void> _toggle(BuildContext context, WidgetRef ref, bool value) async {
    final l10n = AppLocalizations.of(context);
    final messenger = ScaffoldMessenger.of(context);
    if (value) {
      final granted =
          await ref.read(reminderServiceProvider).requestPermission();
      if (!granted) {
        messenger.showSnackBar(
          SnackBar(content: Text(l10n.notificationsDenied)),
        );
        return;
      }
    }
    await ref
        .read(reminderRepositoryProvider)
        .setEnabled(reminder.kind, value);
    await ref.read(reminderSchedulerProvider).sync();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final tones = context.tones;
    final time =
        '${reminder.hour.toString().padLeft(2, '0')}:${reminder.minute.toString().padLeft(2, '0')}';

    return ConstrainedBox(
      constraints: const BoxConstraints(minHeight: 64),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    reminderTitle(l10n, reminder.kind),
                    style: theme.textTheme.bodyMedium,
                  ),
                  Text(
                    reminderSubtitle(l10n, reminder.kind),
                    style:
                        theme.textTheme.bodySmall?.copyWith(color: tones.hint),
                  ),
                ],
              ),
            ),
            if (reminder.kind == ReminderKind.weighIn) ...[
              const SizedBox(width: 8),
              InkWell(
                onTap: () => _pickWeekday(context, ref),
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: theme.colorScheme.outline,
                      width: 0.5,
                    ),
                  ),
                  child: Text(
                    _weekdayLabel(l10n, reminder.weekday),
                    style: theme.textTheme.titleSmall?.copyWith(
                      color: reminder.enabled
                          ? theme.colorScheme.onSurface
                          : tones.faint,
                    ),
                  ),
                ),
              ),
            ],
            const SizedBox(width: 8),
            InkWell(
              onTap: () => _pickTime(context, ref),
              borderRadius: BorderRadius.circular(10),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: theme.colorScheme.outline,
                    width: 0.5,
                  ),
                ),
                child: Text(
                  time,
                  style: theme.textTheme.titleSmall?.copyWith(
                    color: reminder.enabled
                        ? theme.colorScheme.onSurface
                        : tones.faint,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            KalorieToggle(
              value: reminder.enabled,
              onChanged: (value) => _toggle(context, ref, value),
            ),
          ],
        ),
      ),
    );
  }
}

String reminderTitle(AppLocalizations l10n, ReminderKind kind) =>
    switch (kind) {
      ReminderKind.breakfast => l10n.breakfast,
      ReminderKind.lunch => l10n.lunch,
      ReminderKind.dinner => l10n.dinner,
      ReminderKind.snack => l10n.snack,
      ReminderKind.weighIn => l10n.reminderWeighIn,
    };

String reminderSubtitle(AppLocalizations l10n, ReminderKind kind) =>
    switch (kind) {
      ReminderKind.breakfast => l10n.reminderBreakfastSub,
      ReminderKind.lunch => l10n.reminderLunchSub,
      ReminderKind.dinner => l10n.reminderDinnerSub,
      ReminderKind.snack => l10n.reminderSnackSub,
      ReminderKind.weighIn => l10n.reminderWeighInSub,
    };

String _weekdayLabel(AppLocalizations l10n, int weekday) => switch (weekday) {
      1 => l10n.weekdayMonday,
      2 => l10n.weekdayTuesday,
      3 => l10n.weekdayWednesday,
      4 => l10n.weekdayThursday,
      5 => l10n.weekdayFriday,
      6 => l10n.weekdaySaturday,
      _ => l10n.weekdaySunday,
    };
