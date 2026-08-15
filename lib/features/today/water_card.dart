import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/theme.dart';
import '../../core/l10n/generated/app_localizations.dart';
import '../../core/widgets/panel.dart';
import '../../data/local/collections/water_entry.dart';
import '../../data/providers.dart';

/// Acht glazen van 250 ml. Tik het glas dat je net leeg hebt; nogmaals tikken
/// haalt het weer weg.
class WaterCard extends ConsumerWidget {
  const WaterCard({super.key, required this.dateKey});

  final int dateKey;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final tones = context.tones;
    final glasses = ref.watch(waterDayProvider(dateKey)).value ?? 0;
    final done = glasses >= WaterEntry.goalGlasses;

    String litres(int count) =>
        (count * WaterEntry.glassMl / 1000).toStringAsFixed(2).replaceAll('.', ',');

    return KaloriePanel(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Expanded(
                child: Text(l10n.water, style: theme.textTheme.titleMedium),
              ),
              Text(
                l10n.waterProgress(litres(glasses), litres(WaterEntry.goalGlasses)),
                style: theme.textTheme.bodySmall,
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              for (var i = 0; i < WaterEntry.goalGlasses; i++) ...[
                if (i != 0) const SizedBox(width: 6),
                Expanded(
                  child: _Glass(
                    filled: i < glasses,
                    onTap: () {
                      HapticFeedback.selectionClick();
                      ref.read(waterRepositoryProvider).setGlasses(
                            dateKey,
                            glasses == i + 1 ? i : i + 1,
                          );
                    },
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: 10),
          Text(
            done ? l10n.waterDone : l10n.waterHint,
            style: theme.textTheme.labelMedium?.copyWith(color: tones.hint),
          ),
        ],
      ),
    );
  }
}

class _Glass extends StatelessWidget {
  const _Glass({required this.filled, required this.onTap});

  final bool filled;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final tones = context.tones;
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 160),
        height: 40,
        decoration: BoxDecoration(
          color: filled ? tones.sageSoft : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: filled ? tones.sageSoft : theme.colorScheme.outline,
          ),
        ),
      ),
    );
  }
}
