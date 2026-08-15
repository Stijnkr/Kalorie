import 'package:flutter/material.dart';

import '../day_summary.dart';
import '../l10n/generated/app_localizations.dart';

class KcalHero extends StatelessWidget {
  const KcalHero({
    super.key,
    required this.eaten,
    required this.goal,
  });

  final double eaten;
  final int goal;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);
    final remaining = goal - eaten;
    final over = remaining < 0;
    final ratio = goal == 0 ? 0.0 : (eaten / goal).clamp(0.0, 1.0);
    final muted = theme.textTheme.labelSmall?.color;
    final closeToGoal = !over && goal > 0 && remaining <= goal * 0.15;
    final remainingColor = over
        ? theme.colorScheme.error
        : closeToGoal
            ? theme.colorScheme.primary
            : theme.colorScheme.onSurface;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('${displayKcal(eaten)}', style: theme.textTheme.displayLarge),
        const SizedBox(height: 4),
        Text.rich(
          TextSpan(
            style: theme.textTheme.bodyMedium,
            children: [
              TextSpan(
                text: l10n.ofGoal(goal),
                style: TextStyle(color: muted),
              ),
              TextSpan(
                text: '  ·  ',
                style: TextStyle(color: muted),
              ),
              TextSpan(
                text: over
                    ? '+${displayKcal(remaining.abs())} ${l10n.overGoal}'
                    : '${displayKcal(remaining.abs())} ${l10n.remaining}',
                style: TextStyle(
                  color: remainingColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 18),
        ClipRRect(
          borderRadius: BorderRadius.circular(99),
          child: LinearProgressIndicator(
            value: ratio,
            minHeight: 6,
            backgroundColor: theme.colorScheme.outline.withValues(alpha: 0.7),
            color: theme.colorScheme.primary,
          ),
        ),
      ],
    );
  }
}

class MacroLine extends StatelessWidget {
  const MacroLine({
    super.key,
    required this.protein,
    required this.carbs,
    required this.fat,
  });

  final double protein;
  final double carbs;
  final double fat;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);
    final muted = theme.textTheme.labelSmall;
    final number = theme.textTheme.titleMedium?.copyWith(
      fontFeatures: const [FontFeature.tabularFigures()],
    );

    Widget item(String label, double value) {
      return Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('${value.round()}', style: number),
            const SizedBox(height: 2),
            Text(label, style: muted),
          ],
        ),
      );
    }

    Widget rule() {
      return Container(
        width: 0.5,
        height: 32,
        margin: const EdgeInsets.symmetric(horizontal: 12),
        color: theme.colorScheme.outline,
      );
    }

    return Row(
      children: [
        item(l10n.protein, protein),
        rule(),
        item(l10n.carbsMid, carbs),
        rule(),
        item(l10n.fat, fat),
      ],
    );
  }
}
