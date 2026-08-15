import 'package:flutter/material.dart';

import '../../app/theme.dart';
import '../../core/day_summary.dart';
import '../../core/l10n/generated/app_localizations.dart';
import '../../core/macro_goals.dart';
import '../../core/widgets/kalorie_ui.dart';
import '../../core/widgets/panel.dart';

/// Dagkaart: "kcal over" voorop, macro's met eigen doel eronder en de volledige
/// voedingswaarden achter "Alles zien".
class DayCard extends StatefulWidget {
  const DayCard({
    super.key,
    required this.summary,
    required this.kcalGoal,
    required this.macroGoals,
  });

  final DaySummary summary;
  final int kcalGoal;
  final MacroGoals macroGoals;

  @override
  State<DayCard> createState() => _DayCardState();
}

class _DayCardState extends State<DayCard> {
  bool _open = false;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final tones = context.tones;
    final summary = widget.summary;
    final goal = widget.kcalGoal;
    final eaten = displayKcal(summary.kcal);
    final left = goal - eaten;
    final over = left < 0;
    final ratio = goal <= 0 ? 0.0 : summary.kcal / goal;

    return KaloriePanel(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                over ? '+${left.abs()}' : '$left',
                style: theme.textTheme.displayLarge?.copyWith(
                  color: over ? tones.danger : null,
                ),
              ),
              const SizedBox(width: 12),
              Padding(
                padding: const EdgeInsets.only(bottom: 9),
                child: Text(
                  over ? l10n.overGoal : l10n.kcalOver,
                  style: theme.textTheme.bodySmall,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            l10n.eatenOfGoal(eaten, goal),
            style: theme.textTheme.bodySmall,
          ),
          const SizedBox(height: 16),
          KalorieBar(value: ratio, color: over ? tones.danger : null),
          const SizedBox(height: 18),
          const KalorieHairline(),
          const SizedBox(height: 16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _Macro(
                label: l10n.protein,
                value: summary.protein,
                goal: widget.macroGoals.protein,
              ),
              const SizedBox(width: 14),
              _Macro(
                label: l10n.carbsMid,
                value: summary.carbs,
                goal: widget.macroGoals.carbs,
              ),
              const SizedBox(width: 14),
              _Macro(
                label: l10n.fat,
                value: summary.fat,
                goal: widget.macroGoals.fat,
              ),
            ],
          ),
          if (summary.hasExtras) ...[
            const SizedBox(height: 16),
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () => setState(() => _open = !_open),
              child: Text(
                _open ? l10n.showLess : l10n.showAll,
                style: theme.textTheme.titleSmall?.copyWith(
                  fontSize: 13,
                  color: theme.colorScheme.primary,
                ),
              ),
            ),
            if (_open) ...[
              const SizedBox(height: 14),
              _ExtraRow(label: l10n.fiber, grams: summary.fiber),
              _ExtraRow(label: l10n.sugars, grams: summary.sugars),
              _ExtraRow(label: l10n.satFat, grams: summary.satFat),
              _ExtraRow(label: l10n.salt, grams: summary.salt),
            ],
          ],
        ],
      ),
    );
  }
}

class _Macro extends StatelessWidget {
  const _Macro({
    required this.label,
    required this.value,
    required this.goal,
  });

  final String label;
  final double value;
  final double goal;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final tones = context.tones;
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Flexible(
                child: Text(
                  displayMacro(value),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.headlineSmall,
                ),
              ),
              const SizedBox(width: 4),
              Text(
                '/${displayMacro(goal)}g',
                style: theme.textTheme.bodySmall?.copyWith(
                  fontSize: 12,
                  height: 1,
                  color: tones.hint,
                ),
              ),
            ],
          ),
          const SizedBox(height: 7),
          KalorieBar(
            value: goal <= 0 ? 0 : value / goal,
            height: 3,
            color: tones.sageSoft,
          ),
          const SizedBox(height: 7),
          Text(label.toUpperCase(), style: theme.textTheme.labelSmall),
        ],
      ),
    );
  }
}

class _ExtraRow extends StatelessWidget {
  const _ExtraRow({required this.label, required this.grams});

  final String label;
  final double? grams;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 11),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.baseline,
        textBaseline: TextBaseline.alphabetic,
        children: [
          Expanded(child: Text(label, style: theme.textTheme.bodySmall)),
          Text(
            grams == null ? '—' : '${displayMacro(grams!)} g',
            style: theme.textTheme.bodySmall?.copyWith(
              color: grams == null
                  ? context.tones.faint
                  : theme.colorScheme.onSurface,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
