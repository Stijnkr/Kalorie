import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../app/theme.dart';
import '../../core/constants.dart';
import '../../core/day_summary.dart';
import '../../core/l10n/generated/app_localizations.dart';
import '../../core/widgets/kalorie_ui.dart';
import '../../core/widgets/panel.dart';
import '../../core/widgets/stroke_icon.dart';
import '../../data/local/collections/diary_entry.dart';
import '../../data/local/collections/enums.dart';
import '../../data/providers.dart';
import '../add_food/log_sheet.dart';
import 'calendar_sheet.dart';
import 'day_card.dart';
import 'water_card.dart';

class TodayScreen extends ConsumerWidget {
  const TodayScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final dateKey = ref.watch(selectedDateKeyProvider);
    final summary = ref.watch(daySummaryProvider(dateKey));

    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: Stack(
          children: [
            Column(
              children: [
                _DateHeader(dateKey: dateKey),
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 92),
                    children: [
                      DayCard(
                        summary: summary,
                        kcalGoal: ref.watch(kcalGoalProvider),
                        macroGoals: ref.watch(macroGoalsProvider),
                      ),
                      const SizedBox(height: 12),
                      WaterCard(dateKey: dateKey),
                      for (final meal in MealType.values) ...[
                        const SizedBox(height: 12),
                        _MealCard(meal: meal, entries: summary.forMeal(meal)),
                      ],
                    ],
                  ),
                ),
              ],
            ),
            Positioned(
              left: 32,
              right: 32,
              bottom: 12,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(KalorieSpace.radiusSheet),
                  boxShadow: [
                    BoxShadow(
                      color: KalorieColors.ink.withValues(alpha: 0.16),
                      blurRadius: 22,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: FilledButton(
                  onPressed: () => showLogSheet(context),
                  child: Text(l10n.log),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DateHeader extends ConsumerWidget {
  const _DateHeader({required this.dateKey});

  final int dateKey;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final muted = theme.textTheme.bodySmall?.color;
    final today = DateKeys.today();
    final date = DateKeys.toDateTime(dateKey);
    final label = dateKey == today
        ? l10n.today
        : dateKey == DateKeys.addDays(today, -1)
            ? l10n.yesterday
            : toBeginningOfSentenceCase(
                DateFormat('EEEE d MMMM', 'nl').format(date),
              );

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 14, 6, 4),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () => ref.read(selectedDateKeyProvider.notifier).toToday(),
              child: Text(label, style: theme.textTheme.titleMedium),
            ),
          ),
          KalorieTapTarget(
            tooltip: l10n.calendar,
            onTap: () => showCalendarSheet(context),
            child: StrokeIcon(
              StrokeShape.calendar,
              size: 18,
              color: muted,
              strokeWidth: 1.5,
            ),
          ),
          KalorieTapTarget(
            tooltip: l10n.previousDay,
            onTap: () => ref.read(selectedDateKeyProvider.notifier).previous(),
            child: StrokeIcon(StrokeShape.chevronLeft, color: muted),
          ),
          KalorieTapTarget(
            tooltip: l10n.nextDay,
            enabled: dateKey < today,
            onTap: () => ref.read(selectedDateKeyProvider.notifier).next(),
            child: StrokeIcon(StrokeShape.chevronRight, color: muted),
          ),
        ],
      ),
    );
  }
}

class _MealCard extends StatelessWidget {
  const _MealCard({required this.meal, required this.entries});

  final MealType meal;
  final List<DiaryEntry> entries;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final mealKcal = entries.fold<double>(0, (s, e) => s + e.kcal);

    return KaloriePanel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    mealLabel(l10n, meal),
                    style: theme.textTheme.titleMedium,
                  ),
                ),
                if (entries.isNotEmpty)
                  Text(
                    '${displayKcal(mealKcal)}',
                    style: theme.textTheme.bodySmall,
                  ),
              ],
            ),
          ),
          for (final entry in entries) ...[
            const KalorieHairline(),
            _EntryTile(entry: entry),
          ],
          const KalorieHairline(),
          InkWell(
            onTap: () => showLogSheet(context, meal: meal),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
              child: Row(
                children: [
                  StrokeIcon(
                    StrokeShape.plus,
                    size: 14,
                    color: theme.colorScheme.primary,
                  ),
                  const SizedBox(width: 9),
                  Text(
                    l10n.addToSection,
                    style: theme.textTheme.titleSmall?.copyWith(
                      color: theme.colorScheme.primary,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _EntryTile extends ConsumerWidget {
  const _EntryTile({required this.entry});

  final DiaryEntry entry;

  Future<void> _delete(BuildContext context, WidgetRef ref) async {
    final l10n = AppLocalizations.of(context);
    final messenger = ScaffoldMessenger.of(context);
    final diary = ref.read(diaryRepositoryProvider);
    await diary.delete(entry.id);
    HapticFeedback.lightImpact();
    messenger
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          duration: const Duration(seconds: 5),
          content: Text('${l10n.deleted} · ${entry.foodName}'),
          action: SnackBarAction(
            label: l10n.undo,
            onPressed: () => diary.restore(entry),
          ),
        ),
      );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final tones = context.tones;
    final l10n = AppLocalizations.of(context);
    final amount = entry.servingLabel ?? '${entry.amountG.round()} g';
    final brand = entry.brand;

    return InkWell(
      onTap: () => context.push('/add/amount/${entry.foodId}?entryId=${entry.id}'),
      child: ConstrainedBox(
        constraints: const BoxConstraints(minHeight: 56),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 12, 12),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      entry.foodName,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.bodyMedium,
                    ),
                    if (brand != null && brand.isNotEmpty)
                      Text(
                        brand,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.bodySmall
                            ?.copyWith(color: tones.hint),
                      ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Text(amount, style: theme.textTheme.bodySmall),
              const SizedBox(width: 12),
              SizedBox(
                width: 46,
                child: Text(
                  '${displayKcal(entry.kcal)}',
                  textAlign: TextAlign.right,
                  style: theme.textTheme.titleMedium,
                ),
              ),
              KalorieTapTarget(
                size: 30,
                tooltip: l10n.removeEntry,
                onTap: () => _delete(context, ref),
                child: StrokeIcon(
                  StrokeShape.close,
                  size: 11,
                  color: tones.faint,
                  strokeWidth: 1.6,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

String mealLabel(AppLocalizations l10n, MealType meal) => switch (meal) {
      MealType.breakfast => l10n.breakfast,
      MealType.lunch => l10n.lunch,
      MealType.dinner => l10n.dinner,
      MealType.snack => l10n.snack,
    };
