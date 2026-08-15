import 'package:flutter/material.dart';
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
import '../../data/providers.dart';
import '../today/calendar_sheet.dart';

class HistoryScreen extends ConsumerWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final tones = context.tones;
    final selected = ref.watch(selectedDateKeyProvider);
    final week = DateKeys.weekContaining(selected);
    final today = DateKeys.today();
    final goal = ref.watch(kcalGoalProvider);
    final entries = ref
            .watch(diaryRangeProvider((week.first, week.last)))
            .value ??
        const <DiaryEntry>[];

    final byDay = <int, double>{for (final key in week) key: 0};
    for (final e in entries) {
      byDay[e.dateKey] = (byDay[e.dateKey] ?? 0) + e.kcal;
    }
    final loggedDays = week.where((k) => (byDay[k] ?? 0) > 0).toList();
    final average = loggedDays.isEmpty
        ? 0
        : (loggedDays.fold<double>(0, (s, k) => s + byDay[k]!) /
                loggedDays.length)
            .round();
    final peak = [
      goal.toDouble(),
      ...byDay.values,
    ].fold<double>(1, (a, b) => a > b ? a : b);

    final isCurrentWeek = DateKeys.weekContaining(today).first == week.first;
    final range =
        '${DateFormat('d MMM', 'nl').format(DateKeys.toDateTime(week.first))} – '
        '${DateFormat('d MMM', 'nl').format(DateKeys.toDateTime(week.last))}';

    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 14, 6, 4),
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
                        Text(
                          isCurrentWeek ? range : l10n.tabHistory,
                          style: theme.textTheme.bodySmall
                              ?.copyWith(color: tones.hint, height: 1.3),
                        ),
                      ],
                    ),
                  ),
                  KalorieTapTarget(
                    tooltip: l10n.calendar,
                    onTap: () => showCalendarSheet(context),
                    child: StrokeIcon(
                      StrokeShape.calendar,
                      size: 18,
                      color: theme.textTheme.bodySmall?.color,
                      strokeWidth: 1.5,
                    ),
                  ),
                  KalorieTapTarget(
                    tooltip: l10n.previousWeek,
                    onTap: () =>
                        ref.read(selectedDateKeyProvider.notifier).previousWeek(),
                    child: StrokeIcon(
                      StrokeShape.chevronLeft,
                      color: theme.textTheme.bodySmall?.color,
                    ),
                  ),
                  KalorieTapTarget(
                    tooltip: l10n.nextWeek,
                    enabled: !isCurrentWeek,
                    onTap: () =>
                        ref.read(selectedDateKeyProvider.notifier).nextWeek(),
                    child: StrokeIcon(
                      StrokeShape.chevronRight,
                      color: theme.textTheme.bodySmall?.color,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                children: [
                  KaloriePanel(
                    padding: const EdgeInsets.fromLTRB(16, 18, 16, 12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(2, 0, 2, 4),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.baseline,
                            textBaseline: TextBaseline.alphabetic,
                            children: [
                              Text(
                                '$average',
                                style: theme.textTheme.headlineSmall,
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  l10n.weekAverage(goal),
                                  style: theme.textTheme.bodySmall,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(2, 0, 2, 14),
                          child: Text(
                            l10n.weekLoggedDays(loggedDays.length, 7),
                            style: theme.textTheme.bodySmall
                                ?.copyWith(color: tones.hint),
                          ),
                        ),
                        _WeekChart(
                          week: week,
                          byDay: byDay,
                          peak: peak,
                          goal: goal.toDouble(),
                          today: today,
                          selected: selected,
                          onTapDay: (key) => _openDay(context, ref, key),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  KaloriePanel(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        for (var i = 0; i < week.length; i++) ...[
                          if (i != 0) const KalorieHairline(),
                          _DayRow(
                            dateKey: week[i],
                            kcal: byDay[week[i]] ?? 0,
                            goal: goal,
                            isToday: week[i] == today,
                            isFuture: week[i] > today,
                            onTap: () => _openDay(context, ref, week[i]),
                          ),
                        ],
                      ],
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

  static void _openDay(BuildContext context, WidgetRef ref, int dateKey) {
    ref.read(selectedDateKeyProvider.notifier).setKey(dateKey);
    context.go('/today');
  }
}

class _WeekChart extends StatelessWidget {
  const _WeekChart({
    required this.week,
    required this.byDay,
    required this.peak,
    required this.goal,
    required this.today,
    required this.selected,
    required this.onTapDay,
  });

  static const _barArea = 122.0;

  final List<int> week;
  final Map<int, double> byDay;
  final double peak;
  final double goal;
  final int today;
  final int selected;
  final ValueChanged<int> onTapDay;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final tones = context.tones;

    return Column(
      children: [
        SizedBox(
          height: _barArea,
          child: Stack(
            children: [
              Positioned(
                left: 0,
                right: 0,
                bottom: (goal / peak).clamp(0.0, 1.0) * _barArea,
                child: CustomPaint(
                  size: const Size(double.infinity, 1),
                  painter: _DashedLinePainter(color: tones.dashed),
                ),
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  for (var i = 0; i < week.length; i++) ...[
                    if (i != 0) const SizedBox(width: 8),
                    Expanded(
                      child: GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: week[i] > today ? null : () => onTapDay(week[i]),
                        child: _Bar(
                          height: _height(byDay[week[i]] ?? 0),
                          color: _color(context, week[i]),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            for (var i = 0; i < week.length; i++) ...[
              if (i != 0) const SizedBox(width: 8),
              Expanded(
                child: Text(
                  DateFormat('E', 'nl')
                      .format(DateKeys.toDateTime(week[i]))
                      .substring(0, 2)
                      .toUpperCase(),
                  textAlign: TextAlign.center,
                  style: theme.textTheme.labelSmall?.copyWith(
                    letterSpacing: 0.6,
                    fontWeight:
                        week[i] == selected ? FontWeight.w600 : FontWeight.w400,
                  ),
                ),
              ),
            ],
          ],
        ),
      ],
    );
  }

  double _height(double kcal) {
    if (kcal <= 0) return 3;
    return ((kcal / peak) * _barArea).clamp(3.0, _barArea);
  }

  Color _color(BuildContext context, int dateKey) {
    final theme = Theme.of(context);
    final tones = context.tones;
    if (dateKey > today) return Colors.transparent;
    if ((byDay[dateKey] ?? 0) <= 0) return theme.colorScheme.outline;
    if (dateKey == today) return theme.colorScheme.primary;
    return tones.sageSoft;
  }
}

class _Bar extends StatelessWidget {
  const _Bar({required this.height, required this.color});

  final double height;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeOut,
        height: height,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(5),
        ),
      ),
    );
  }
}

class _DashedLinePainter extends CustomPainter {
  const _DashedLinePainter({required this.color});

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1;
    const dash = 4.0;
    const gap = 4.0;
    var x = 0.0;
    while (x < size.width) {
      canvas.drawLine(Offset(x, 0), Offset(x + dash, 0), paint);
      x += dash + gap;
    }
  }

  @override
  bool shouldRepaint(_DashedLinePainter old) => old.color != color;
}

class _DayRow extends StatelessWidget {
  const _DayRow({
    required this.dateKey,
    required this.kcal,
    required this.goal,
    required this.isToday,
    required this.isFuture,
    required this.onTap,
  });

  final int dateKey;
  final double kcal;
  final int goal;
  final bool isToday;
  final bool isFuture;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final tones = context.tones;
    final date = DateKeys.toDateTime(dateKey);
    final logged = kcal > 0;
    final total = displayKcal(kcal);
    final delta = total - goal;

    return Material(
      color: isToday ? tones.tint.withValues(alpha: 0.5) : Colors.transparent,
      child: InkWell(
        onTap: isFuture ? null : onTap,
        child: ConstrainedBox(
          constraints: const BoxConstraints(minHeight: 60),
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
                        toBeginningOfSentenceCase(
                          DateFormat('EEEE d MMMM', 'nl').format(date),
                        ),
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontWeight:
                              isToday ? FontWeight.w600 : FontWeight.w400,
                        ),
                      ),
                      Text(
                        isFuture
                            ? l10n.notYetHappened
                            : logged
                                ? l10n.eatenOfGoal(total, goal)
                                : l10n.nothingLoggedTap,
                        style: theme.textTheme.bodySmall
                            ?.copyWith(color: tones.hint, height: 1.3),
                      ),
                    ],
                  ),
                ),
                if (logged) ...[
                  Text(
                    delta > 0 ? '+$delta' : '$delta',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: delta > 0 ? tones.danger : tones.hint,
                    ),
                  ),
                  const SizedBox(width: 12),
                ],
                SizedBox(
                  width: 52,
                  child: Text(
                    logged ? '$total' : '—',
                    textAlign: TextAlign.right,
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: logged ? null : tones.faint,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                StrokeIcon(
                  StrokeShape.chevronRight,
                  size: 14,
                  color: tones.faint,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
