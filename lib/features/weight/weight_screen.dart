import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../app/theme.dart';
import '../../core/constants.dart';
import '../../core/l10n/generated/app_localizations.dart';
import '../../core/widgets/kalorie_ui.dart';
import '../../core/widgets/panel.dart';
import '../../data/local/collections/weight_entry.dart';
import '../../data/providers.dart';

class WeightScreen extends ConsumerStatefulWidget {
  const WeightScreen({super.key});

  @override
  ConsumerState<WeightScreen> createState() => _WeightScreenState();
}

class _WeightScreenState extends ConsumerState<WeightScreen> {
  /// Wat er in de teller staat. Start op de laatste meting.
  double? _draft;

  double _startValue(List<WeightEntry> entries) =>
      _draft ?? (entries.isEmpty ? 75 : entries.last.kg);

  void _nudge(double delta, List<WeightEntry> entries) {
    HapticFeedback.selectionClick();
    final next = (_startValue(entries) + delta).clamp(20.0, 400.0);
    setState(() => _draft = (next * 10).roundToDouble() / 10);
  }

  Future<void> _log(List<WeightEntry> entries) async {
    final kg = _startValue(entries);
    await ref.read(weightRepositoryProvider).upsert(DateKeys.today(), kg);
    HapticFeedback.mediumImpact();
    if (mounted) setState(() => _draft = null);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final tones = context.tones;
    final entries = ref.watch(weightLogProvider).value ?? const <WeightEntry>[];
    final current = _startValue(entries);
    final delta = _deltaOver30Days(entries);

    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            KalorieOverlayHeader(
              title: l10n.weight,
              onBack: () => context.pop(),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 40),
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        _kg(current),
                        style: theme.textTheme.displayLarge,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 9),
                          child: Text(
                            delta == null
                                ? l10n.kg
                                : l10n.weightDeltaIn30(_signed(delta)),
                            style: theme.textTheme.bodySmall,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  if (entries.length >= 2)
                    KaloriePanel(
                      padding: const EdgeInsets.fromLTRB(16, 20, 16, 12),
                      child: _WeightChart(entries: entries),
                    )
                  else
                    KaloriePanel(
                      padding: const EdgeInsets.all(20),
                      child: Text(
                        l10n.noWeight,
                        style: theme.textTheme.bodySmall
                            ?.copyWith(color: tones.hint),
                      ),
                    ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      KalorieStepButton(
                        plus: false,
                        size: 48,
                        filled: false,
                        onTap: () => _nudge(-0.1, entries),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: SizedBox(
                          height: 48,
                          child: FilledButton(
                            style: FilledButton.styleFrom(
                              minimumSize: const Size.fromHeight(48),
                              textStyle: theme.textTheme.titleSmall,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                            ),
                            onPressed: () => _log(entries),
                            child: Text(l10n.logWeightToday(_kg(current))),
                          ),
                        ),
                      ),
                      const SizedBox(width: 14),
                      KalorieStepButton(
                        plus: true,
                        size: 48,
                        filled: false,
                        onTap: () => _nudge(0.1, entries),
                      ),
                    ],
                  ),
                  if (entries.isNotEmpty) ...[
                    const SizedBox(height: 28),
                    KalorieSectionLabel(l10n.measurements),
                    KaloriePanelList(
                      children: [
                        for (final entry in entries.reversed.take(12))
                          KaloriePanelTile(
                            title: toBeginningOfSentenceCase(
                              DateFormat('EEEE d MMMM', 'nl')
                                  .format(DateKeys.toDateTime(entry.dateKey)),
                            ),
                            trailing: Text(
                              '${_kg(entry.kg)} ${l10n.kg}',
                              style: theme.textTheme.titleMedium,
                            ),
                            onTap: () => _confirmDelete(entry),
                          ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _confirmDelete(WeightEntry entry) async {
    final l10n = AppLocalizations.of(context);
    final ok = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.deleteEntryTitle),
        content: Text('${_kg(entry.kg)} ${l10n.kg}'),
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
    if (ok == true) {
      await ref.read(weightRepositoryProvider).delete(entry.id);
    }
  }

  static String _kg(double value) =>
      value.toStringAsFixed(1).replaceAll('.', ',');

  static String _signed(double value) {
    final text = _kg(value.abs());
    if (value > 0) return '+$text kg';
    if (value < 0) return '−$text kg';
    return '±0 kg';
  }

  /// Verschil tussen de laatste meting en de eerste meting binnen 30 dagen.
  static double? _deltaOver30Days(List<WeightEntry> entries) {
    if (entries.length < 2) return null;
    final cutoff = DateKeys.addDays(DateKeys.today(), -30);
    final window = entries.where((e) => e.dateKey >= cutoff).toList();
    if (window.length < 2) return null;
    return window.last.kg - window.first.kg;
  }
}

/// Staafjes voor de laatste acht metingen, geschaald op het bereik zelf zodat
/// een verschil van een kilo ook zichtbaar is.
class _WeightChart extends StatelessWidget {
  const _WeightChart({required this.entries});

  final List<WeightEntry> entries;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final tones = context.tones;
    final recent = entries.length <= 8
        ? entries
        : entries.sublist(entries.length - 8);
    final values = recent.map((e) => e.kg).toList();
    final min = values.reduce((a, b) => a < b ? a : b);
    final max = values.reduce((a, b) => a > b ? a : b);
    final span = (max - min) < 1 ? 1.0 : (max - min) * 1.25;
    final base = min - (span - (max - min)) / 2;

    return Column(
      children: [
        SizedBox(
          height: 96,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              for (var i = 0; i < recent.length; i++) ...[
                if (i != 0) const SizedBox(width: 6),
                Expanded(
                  child: Container(
                    height: (((values[i] - base) / span) * 90).clamp(6.0, 96.0),
                    decoration: BoxDecoration(
                      color: tones.sageSoft,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            for (var i = 0; i < recent.length; i++) ...[
              if (i != 0) const SizedBox(width: 6),
              Expanded(
                child: Text(
                  DateFormat('d/M', 'nl')
                      .format(DateKeys.toDateTime(recent[i].dateKey)),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.clip,
                  style: theme.textTheme.labelSmall
                      ?.copyWith(fontSize: 10, letterSpacing: 0, color: tones.hint),
                ),
              ),
            ],
          ],
        ),
      ],
    );
  }
}
