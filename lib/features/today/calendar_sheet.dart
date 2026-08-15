import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../app/theme.dart';
import '../../core/constants.dart';
import '../../core/l10n/generated/app_localizations.dart';
import '../../core/widgets/kalorie_ui.dart';
import '../../core/widgets/stroke_icon.dart';
import '../../data/providers.dart';

/// Maandoverzicht als bottom sheet. Een stipje betekent: die dag heb je gelogd.
Future<void> showCalendarSheet(BuildContext context) {
  return showModalBottomSheet<void>(
    context: context,
    useSafeArea: true,
    showDragHandle: true,
    builder: (context) => const _CalendarSheet(),
  );
}

class _CalendarSheet extends ConsumerStatefulWidget {
  const _CalendarSheet();

  @override
  ConsumerState<_CalendarSheet> createState() => _CalendarSheetState();
}

class _CalendarSheetState extends ConsumerState<_CalendarSheet> {
  late DateTime _month;

  @override
  void initState() {
    super.initState();
    final selected = DateKeys.toDateTime(ref.read(selectedDateKeyProvider));
    _month = DateTime(selected.year, selected.month);
  }

  void _shiftMonth(int months) {
    setState(() => _month = DateTime(_month.year, _month.month + months));
  }

  void _pick(int dateKey) {
    ref.read(selectedDateKeyProvider.notifier).setKey(dateKey);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final tones = context.tones;
    final selected = ref.watch(selectedDateKeyProvider);
    final today = DateKeys.today();

    final daysInMonth = DateTime(_month.year, _month.month + 1, 0).day;
    final firstWeekday = DateTime(_month.year, _month.month, 1).weekday;
    final leading = firstWeekday - 1;
    final from = DateKeys.fromDateTime(DateTime(_month.year, _month.month, 1));
    final to = DateKeys.fromDateTime(
      DateTime(_month.year, _month.month, daysInMonth),
    );
    final logged =
        ref.watch(loggedDaysProvider((from, to))).value ?? const <int>{};
    final canGoForward = DateTime(_month.year, _month.month).isBefore(
      DateTime(DateTime.now().year, DateTime.now().month),
    );

    return Padding(
      padding: EdgeInsets.fromLTRB(
        16,
        0,
        16,
        16 + MediaQuery.paddingOf(context).bottom,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              KalorieTapTarget(
                onTap: () => _shiftMonth(-1),
                tooltip: l10n.previousDay,
                child: StrokeIcon(
                  StrokeShape.chevronLeft,
                  color: theme.textTheme.bodySmall?.color,
                ),
              ),
              Expanded(
                child: Text(
                  toBeginningOfSentenceCase(
                    DateFormat('MMMM y', 'nl').format(_month),
                  ),
                  textAlign: TextAlign.center,
                  style: theme.textTheme.titleMedium,
                ),
              ),
              KalorieTapTarget(
                onTap: () => _shiftMonth(1),
                enabled: canGoForward,
                tooltip: l10n.nextDay,
                child: StrokeIcon(
                  StrokeShape.chevronRight,
                  color: theme.textTheme.bodySmall?.color,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              for (var i = 0; i < 7; i++)
                Expanded(
                  child: Text(
                    _weekdayLabel(i),
                    textAlign: TextAlign.center,
                    style: theme.textTheme.labelSmall?.copyWith(
                      letterSpacing: 0.6,
                      color: tones.hint,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 8),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: EdgeInsets.zero,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7,
              mainAxisSpacing: 2,
              crossAxisSpacing: 2,
              mainAxisExtent: 46,
            ),
            itemCount: leading + daysInMonth,
            itemBuilder: (context, index) {
              if (index < leading) return const SizedBox.shrink();
              final day = index - leading + 1;
              final key = DateKeys.fromDateTime(
                DateTime(_month.year, _month.month, day),
              );
              return _Cell(
                day: day,
                isSelected: key == selected,
                isToday: key == today,
                isFuture: key > today,
                hasEntries: logged.contains(key),
                onTap: key > today ? null : () => _pick(key),
              );
            },
          ),
          const SizedBox(height: 14),
          SizedBox(
            height: 48,
            child: OutlinedButton(
              onPressed: () => _pick(today),
              style: OutlinedButton.styleFrom(
                foregroundColor: theme.colorScheme.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              child: Text(l10n.toToday),
            ),
          ),
        ],
      ),
    );
  }

  static String _weekdayLabel(int index) {
    // 1 januari 2024 was een maandag.
    final date = DateTime(2024, 1, 1).add(Duration(days: index));
    return DateFormat('E', 'nl').format(date).substring(0, 2);
  }
}

class _Cell extends StatelessWidget {
  const _Cell({
    required this.day,
    required this.isSelected,
    required this.isToday,
    required this.isFuture,
    required this.hasEntries,
    required this.onTap,
  });

  final int day;
  final bool isSelected;
  final bool isToday;
  final bool isFuture;
  final bool hasEntries;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final tones = context.tones;
    final background = isSelected
        ? theme.colorScheme.primary
        : isToday
            ? tones.tint
            : Colors.transparent;
    final foreground = isSelected
        ? theme.colorScheme.onPrimary
        : isFuture
            ? tones.dashed
            : theme.colorScheme.onSurface;
    final dot = isSelected
        ? theme.colorScheme.onPrimary.withValues(alpha: 0.7)
        : hasEntries
            ? tones.sageSoft
            : Colors.transparent;

    return Material(
      color: background,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '$day',
              style: TextStyle(
                fontSize: 15,
                height: 1,
                color: foreground,
                fontWeight: isSelected || isToday
                    ? FontWeight.w600
                    : FontWeight.w400,
                fontFeatures: const [FontFeature.tabularFigures()],
              ),
            ),
            const SizedBox(height: 4),
            Container(
              width: 4,
              height: 4,
              decoration: BoxDecoration(
                color: dot,
                borderRadius: BorderRadius.circular(99),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
