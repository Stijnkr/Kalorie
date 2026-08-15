import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/theme.dart';
import '../../core/day_summary.dart';
import '../../core/l10n/generated/app_localizations.dart';
import '../../core/widgets/kalorie_ui.dart';
import '../../core/widgets/panel.dart';
import '../../data/providers.dart';

class GoalsScreen extends ConsumerWidget {
  const GoalsScreen({super.key});

  static const _minKcal = 1200;
  static const _maxKcal = 6000;
  static const _step = 50;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final tones = context.tones;
    final kcalGoal = ref.watch(kcalGoalProvider);
    final macros = ref.watch(macroGoalsProvider);
    final repo = ref.read(settingsRepositoryProvider);

    void shift(int delta) {
      final next = (kcalGoal + delta).clamp(_minKcal, _maxKcal);
      if (next != kcalGoal) repo.setKcalGoal(next);
    }

    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            KalorieOverlayHeader(
              title: l10n.goals,
              onBack: () => context.pop(),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 40),
                children: [
                  Text(
                    l10n.goalsIntro,
                    style: theme.textTheme.bodySmall?.copyWith(height: 1.5),
                  ),
                  const SizedBox(height: 16),
                  KaloriePanel(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        KalorieSectionLabel(
                          l10n.dayGoal,
                          padding: EdgeInsets.zero,
                        ),
                        const SizedBox(height: 14),
                        Row(
                          children: [
                            KalorieStepButton(
                              plus: false,
                              size: 48,
                              filled: false,
                              enabled: kcalGoal > _minKcal,
                              onTap: () => shift(-_step),
                            ),
                            Expanded(
                              child: Text(
                                '$kcalGoal',
                                textAlign: TextAlign.center,
                                style: theme.textTheme.displaySmall,
                              ),
                            ),
                            KalorieStepButton(
                              plus: true,
                              size: 48,
                              filled: false,
                              enabled: kcalGoal < _maxKcal,
                              onTap: () => shift(_step),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          l10n.kcalPerDay,
                          textAlign: TextAlign.center,
                          style: theme.textTheme.bodySmall
                              ?.copyWith(color: tones.hint),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  KaloriePanelList(
                    children: [
                      _MacroRow(
                        label: l10n.protein,
                        grams: macros.protein,
                        pct: macros.proteinPct(kcalGoal),
                        onEdit: (value) =>
                            repo.setMacroGoals(macros.copyWith(protein: value)),
                      ),
                      _MacroRow(
                        label: l10n.carbs,
                        grams: macros.carbs,
                        pct: macros.carbsPct(kcalGoal),
                        onEdit: (value) =>
                            repo.setMacroGoals(macros.copyWith(carbs: value)),
                      ),
                      _MacroRow(
                        label: l10n.fat,
                        grams: macros.fat,
                        pct: macros.fatPct(kcalGoal),
                        onEdit: (value) =>
                            repo.setMacroGoals(macros.copyWith(fat: value)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Macrorij: percentage van het dagdoel links, grammen rechts. Tikken opent
/// een klein invulvel zodat je een macro los kunt bijstellen.
class _MacroRow extends StatelessWidget {
  const _MacroRow({
    required this.label,
    required this.grams,
    required this.pct,
    required this.onEdit,
  });

  final String label;
  final double grams;
  final int pct;
  final ValueChanged<double> onEdit;

  Future<void> _edit(BuildContext context) async {
    final controller = TextEditingController(text: displayMacro(grams));
    final result = await showModalBottomSheet<double>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      showDragHandle: true,
      builder: (context) {
        final l10n = AppLocalizations.of(context);
        return Padding(
          padding: EdgeInsets.fromLTRB(
            24,
            4,
            24,
            24 + MediaQuery.viewInsetsOf(context).bottom,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              KalorieSectionLabel(label),
              TextField(
                controller: controller,
                autofocus: true,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                decoration: InputDecoration(suffixText: l10n.gram),
              ),
              const SizedBox(height: 20),
              FilledButton(
                onPressed: () {
                  final value = double.tryParse(
                    controller.text.replaceAll(',', '.'),
                  );
                  Navigator.pop(context, value);
                },
                child: Text(l10n.save),
              ),
            ],
          ),
        );
      },
    );
    controller.dispose();
    if (result != null && result > 0) onEdit(result);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final tones = context.tones;
    return InkWell(
      onTap: () => _edit(context),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Expanded(child: Text(label, style: theme.textTheme.bodyMedium)),
            Text(
              '$pct%',
              style: theme.textTheme.bodySmall?.copyWith(color: tones.hint),
            ),
            const SizedBox(width: 12),
            SizedBox(
              width: 62,
              child: Text(
                '${displayMacro(grams)} g',
                textAlign: TextAlign.right,
                style: theme.textTheme.titleMedium,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
