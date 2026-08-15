import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../app/theme.dart';
import '../../core/constants.dart';
import '../../core/day_summary.dart';
import '../../core/l10n/generated/app_localizations.dart';
import '../../core/widgets/macro_bar.dart';
import '../../core/widgets/panel.dart';
import '../../data/local/collections/diary_entry.dart';
import '../../data/local/collections/enums.dart';
import '../../data/providers.dart';
import '../add_food/log_sheet.dart';

class TodayScreen extends ConsumerWidget {
  const TodayScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final dateKey = ref.watch(selectedDateKeyProvider);
    final summary = ref.watch(daySummaryProvider(dateKey));
    final settings = ref.watch(settingsProvider).value;
    final kcalGoal = settings?.kcalGoal ?? 2200;

    return Scaffold(
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.fromLTRB(32, 8, 32, 8),
        child: SizedBox(
          height: KalorieSpace.buttonHeight,
          width: double.infinity,
          child: FilledButton(
            onPressed: () => showLogSheet(context),
            child: Text(l10n.log),
          ),
        ),
      ),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                child: _DateHeader(dateKey: dateKey),
              ),
            ),
            SliverToBoxAdapter(
              child: KaloriePanel(
                margin: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    KcalHero(eaten: summary.kcal, goal: kcalGoal),
                    const SizedBox(height: 20),
                    const KalorieHairline(indent: 0, endIndent: 0),
                    const SizedBox(height: 16),
                    MacroLine(
                      protein: summary.protein,
                      carbs: summary.carbs,
                      fat: summary.fat,
                    ),
                  ],
                ),
              ),
            ),
            ...MealType.values.map(
              (meal) => SliverToBoxAdapter(
                child: _MealCard(
                  meal: meal,
                  entries: summary.forMeal(meal),
                ),
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 32)),
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
    final muted = theme.textTheme.labelSmall?.color;
    final today = DateKeys.today();
    final date = DateKeys.toDateTime(dateKey);
    final label = dateKey == today
        ? l10n.today
        : dateKey == DateKeys.addDays(today, -1)
            ? l10n.yesterday
            : DateFormat('EEEE d MMMM', 'nl').format(date);

    return Row(
      children: [
        Expanded(
          child: GestureDetector(
            onTap: () => ref.read(selectedDateKeyProvider.notifier).toToday(),
            child: Text(label, style: theme.textTheme.titleMedium),
          ),
        ),
        IconButton(
          style: IconButton.styleFrom(minimumSize: const Size(48, 48)),
          color: muted,
          onPressed: () =>
              ref.read(selectedDateKeyProvider.notifier).previous(),
          icon: const Icon(Icons.chevron_left, size: 22),
        ),
        IconButton(
          style: IconButton.styleFrom(minimumSize: const Size(48, 48)),
          color: muted,
          onPressed: dateKey >= today
              ? null
              : () => ref.read(selectedDateKeyProvider.notifier).next(),
          icon: const Icon(Icons.chevron_right, size: 22),
        ),
      ],
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
    final title = switch (meal) {
      MealType.breakfast => l10n.breakfast,
      MealType.lunch => l10n.lunch,
      MealType.dinner => l10n.dinner,
      MealType.snack => l10n.snack,
    };
    final mealKcal = entries.fold<double>(0, (s, e) => s + e.kcal);

    return KaloriePanel(
      margin: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
            child: Row(
              children: [
                Text(title, style: theme.textTheme.titleMedium),
                const Spacer(),
                if (entries.isNotEmpty)
                  Text(
                    '${displayKcal(mealKcal)}',
                    style: theme.textTheme.bodySmall?.copyWith(
                      fontFeatures: const [FontFeature.tabularFigures()],
                    ),
                  ),
              ],
            ),
          ),
          if (entries.isNotEmpty) const KalorieHairline(),
          for (var i = 0; i < entries.length; i++) ...[
            _EntryTile(entry: entries[i]),
            if (i != entries.length - 1) const KalorieHairline(),
          ],
          if (entries.isNotEmpty) const KalorieHairline(),
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(4, 0, 16, 4),
              child: TextButton.icon(
                onPressed: () => showLogSheet(context, meal: meal),
                style: TextButton.styleFrom(
                  foregroundColor: theme.colorScheme.primary,
                  minimumSize: const Size(48, 48),
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                icon: const Icon(Icons.add, size: 20),
                label: Text(l10n.addToSection),
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

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final amount = entry.servingLabel ?? '${entry.amountG.round()} g';

    return Dismissible(
      key: ValueKey(entry.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 16),
        color: Theme.of(context).colorScheme.error.withValues(alpha: 0.12),
        child: Icon(
          Icons.delete_outline,
          color: Theme.of(context).colorScheme.error,
        ),
      ),
      confirmDismiss: (_) async {
        return showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(l10n.deleteEntryTitle),
            content: Text(l10n.deleteEntryBody(entry.foodName)),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: Text(l10n.cancel),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                child: Text(l10n.delete),
              ),
            ],
          ),
        );
      },
      onDismissed: (_) {
        ref.read(diaryRepositoryProvider).delete(entry.id);
        HapticFeedback.lightImpact();
      },
      child: InkWell(
        onTap: () => context.push(
          '/add/amount/${entry.foodId}?entryId=${entry.id}',
        ),
        child: ConstrainedBox(
          constraints: const BoxConstraints(minHeight: 56),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
                      if (entry.brand != null && entry.brand!.isNotEmpty)
                        Text(
                          entry.brand!,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.bodySmall,
                        ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  amount,
                  style: theme.textTheme.bodySmall,
                ),
                const SizedBox(width: 16),
                SizedBox(
                  width: 44,
                  child: Text(
                    '${displayKcal(entry.kcal)}',
                    textAlign: TextAlign.right,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontFeatures: const [FontFeature.tabularFigures()],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
