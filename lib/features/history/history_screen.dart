import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../app/theme.dart';
import '../../core/constants.dart';
import '../../core/day_summary.dart';
import '../../core/l10n/generated/app_localizations.dart';
import '../../core/widgets/panel.dart';
import '../../data/local/collections/diary_entry.dart';
import '../../data/providers.dart';

class HistoryScreen extends ConsumerWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final selected = ref.watch(selectedDateKeyProvider);
    final week = DateKeys.weekContaining(selected);
    final from = week.first;
    final to = week.last;
    final today = DateKeys.today();
    final settings = ref.watch(settingsProvider).value;
    final goal = (settings?.kcalGoal ?? 2200).toDouble();
    final entries =
        ref.watch(diaryRangeProvider((from, to))).value ?? const <DiaryEntry>[];
    final byDay = <int, double>{
      for (final key in week) key: 0,
    };
    for (final e in entries) {
      byDay[e.dateKey] = (byDay[e.dateKey] ?? 0) + e.kcal;
    }
    final peak =
        [goal, ...byDay.values].fold<double>(0, (a, b) => a > b ? a : b);
    final maxY = (peak * 1.15).clamp(100.0, 6000.0);
    final isCurrentWeek = DateKeys.weekContaining(today).first == from;
    final nextWeekDisabled = DateKeys.addDays(selected, 7) > today;
    final range =
        '${DateFormat('d MMM', 'nl').format(DateKeys.toDateTime(from))} – ${DateFormat('d MMM', 'nl').format(DateKeys.toDateTime(to))}';

    return Scaffold(
      appBar: AppBar(title: Text(l10n.tabHistory)),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        isCurrentWeek ? l10n.thisWeek : range,
                        style: theme.textTheme.titleMedium,
                      ),
                      if (isCurrentWeek) ...[
                        const SizedBox(height: 4),
                        Text(range, style: theme.textTheme.titleMedium),
                      ],
                    ],
                  ),
                ),
                IconButton(
                  style: IconButton.styleFrom(minimumSize: const Size(48, 48)),
                  onPressed: () =>
                      ref.read(selectedDateKeyProvider.notifier).previousWeek(),
                  icon: const Icon(Icons.chevron_left, size: 22),
                ),
                IconButton(
                  style: IconButton.styleFrom(minimumSize: const Size(48, 48)),
                  onPressed: nextWeekDisabled
                      ? null
                      : () =>
                          ref.read(selectedDateKeyProvider.notifier).nextWeek(),
                  icon: const Icon(Icons.chevron_right, size: 22),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          KaloriePanel(
            padding: const EdgeInsets.fromLTRB(12, 16, 12, 8),
            child: SizedBox(
              height: 180,
              child: BarChart(
                BarChartData(
                  maxY: maxY,
                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine: false,
                    horizontalInterval: maxY / 4,
                    getDrawingHorizontalLine: (value) => FlLine(
                      color: theme.colorScheme.outline.withValues(alpha: 0.4),
                      strokeWidth: 0.6,
                    ),
                  ),
                  borderData: FlBorderData(show: false),
                  titlesData: FlTitlesData(
                    topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    leftTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          final i = value.toInt();
                          if (i < 0 || i > 6) return const SizedBox.shrink();
                          final date = DateKeys.toDateTime(week[i]);
                          return Text(
                            DateFormat('E', 'nl').format(date).substring(0, 2),
                            style: theme.textTheme.labelSmall,
                          );
                        },
                      ),
                    ),
                  ),
                  extraLinesData: ExtraLinesData(
                    horizontalLines: [
                      HorizontalLine(
                        y: goal,
                        color:
                            theme.colorScheme.outline.withValues(alpha: 0.8),
                        strokeWidth: 0.8,
                        dashArray: [6, 4],
                      ),
                    ],
                  ),
                  barGroups: [
                    for (var i = 0; i < week.length; i++)
                      _weekBar(
                        index: i,
                        kcal: byDay[week[i]] ?? 0,
                        selected: week[i] == selected,
                        maxY: maxY,
                        theme: theme,
                      ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          KaloriePanel(
            child: Column(
              children: [
                for (var i = 0; i < week.length; i++) ...[
                  _DayRow(
                    dateKey: week[i],
                    kcal: byDay[week[i]] ?? 0,
                  ),
                  if (i != week.length - 1) const KalorieHairline(),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _DayRow extends ConsumerWidget {
  const _DayRow({required this.dateKey, required this.kcal});

  final int dateKey;
  final double kcal;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final date = DateKeys.toDateTime(dateKey);

    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16),
      title: Text(DateFormat('EEEE d MMMM', 'nl').format(date)),
      trailing: kcal == 0
          ? Text(l10n.todayEmpty, style: theme.textTheme.bodySmall)
          : Text(
              '${displayKcal(kcal)}',
              style: theme.textTheme.titleMedium?.copyWith(
                fontFeatures: const [FontFeature.tabularFigures()],
              ),
            ),
      onTap: () {
        ref.read(selectedDateKeyProvider.notifier).setKey(dateKey);
        context.go('/today');
      },
    );
  }
}

BarChartGroupData _weekBar({
  required int index,
  required double kcal,
  required bool selected,
  required double maxY,
  required ThemeData theme,
}) {
  final empty = kcal == 0;
  return BarChartGroupData(
    x: index,
    barRods: [
      BarChartRodData(
        toY: empty ? maxY * 0.04 : kcal,
        width: selected ? 12 : 8,
        borderRadius: BorderRadius.circular(4),
        color: empty
            ? theme.colorScheme.outline
            : selected
                ? theme.colorScheme.primary
                : KalorieColors.sageSoft,
      ),
    ],
  );
}
