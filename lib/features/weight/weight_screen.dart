import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../core/constants.dart';
import '../../core/l10n/generated/app_localizations.dart';
import '../../core/widgets/empty_state.dart';
import '../../data/providers.dart';

class WeightScreen extends ConsumerStatefulWidget {
  const WeightScreen({super.key});

  @override
  ConsumerState<WeightScreen> createState() => _WeightScreenState();
}

class _WeightScreenState extends ConsumerState<WeightScreen> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _add() async {
    final l10n = AppLocalizations.of(context);
    _controller.clear();
    final ok = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.fromLTRB(
            24,
            24,
            24,
            24 + MediaQuery.viewInsetsOf(context).bottom,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(l10n.addWeight, style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 16),
              TextField(
                controller: _controller,
                autofocus: true,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                decoration: InputDecoration(
                  labelText: l10n.weight,
                  suffixText: l10n.kg,
                ),
              ),
              const SizedBox(height: 20),
              FilledButton(
                onPressed: () => Navigator.pop(context, true),
                child: Text(l10n.save),
              ),
            ],
          ),
        );
      },
    );
    if (ok != true) return;
    final kg = double.tryParse(_controller.text.replaceAll(',', '.'));
    if (kg == null || kg <= 0) return;
    await ref.read(weightRepositoryProvider).upsert(DateKeys.today(), kg);
    HapticFeedback.lightImpact();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final async = ref.watch(weightLogProvider);
    final entries = async.value ?? const [];

    return Scaffold(
      appBar: AppBar(title: Text(l10n.weight)),
      floatingActionButton: FloatingActionButton(
        onPressed: _add,
        child: const Icon(Icons.add),
      ),
      body: entries.isEmpty
          ? Padding(
              padding: const EdgeInsets.all(24),
              child: EmptyState(
                title: l10n.noWeight,
                subtitle: l10n.weightSubtitle,
              ),
            )
          : ListView(
              padding: const EdgeInsets.fromLTRB(24, 8, 24, 96),
              children: [
                if (entries.length >= 2)
                  SizedBox(
                    height: 180,
                    child: LineChart(
                      LineChartData(
                        gridData: const FlGridData(show: false),
                        borderData: FlBorderData(show: false),
                        titlesData: const FlTitlesData(show: false),
                        lineBarsData: [
                          LineChartBarData(
                            isCurved: true,
                            color: Theme.of(context).colorScheme.primary,
                            barWidth: 2.4,
                            dotData: const FlDotData(show: false),
                            spots: [
                              for (var i = 0; i < entries.length; i++)
                                FlSpot(i.toDouble(), entries[i].kg),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                const SizedBox(height: 16),
                ...entries.reversed.map(
                  (e) => ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(
                      DateFormat('d MMMM y', 'nl')
                          .format(DateKeys.toDateTime(e.dateKey)),
                    ),
                    trailing: Text(
                      '${e.kg.toStringAsFixed(1)} ${l10n.kg}',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    onLongPress: () =>
                        ref.read(weightRepositoryProvider).delete(e.id),
                  ),
                ),
              ],
            ),
    );
  }
}
