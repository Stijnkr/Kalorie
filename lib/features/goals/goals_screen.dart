import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/l10n/generated/app_localizations.dart';
import '../../data/providers.dart';

class GoalsScreen extends ConsumerStatefulWidget {
  const GoalsScreen({super.key});

  @override
  ConsumerState<GoalsScreen> createState() => _GoalsScreenState();
}

class _GoalsScreenState extends ConsumerState<GoalsScreen> {
  late final TextEditingController _kcal;
  late final TextEditingController _protein;
  late final TextEditingController _carbs;
  late final TextEditingController _fat;
  bool _ready = false;

  @override
  void initState() {
    super.initState();
    _kcal = TextEditingController();
    _protein = TextEditingController();
    _carbs = TextEditingController();
    _fat = TextEditingController();
    _load();
  }

  Future<void> _load() async {
    final s = await ref.read(settingsRepositoryProvider).get();
    _kcal.text = '${s.kcalGoal}';
    _protein.text = _trim(s.proteinGoal);
    _carbs.text = _trim(s.carbsGoal);
    _fat.text = _trim(s.fatGoal);
    setState(() => _ready = true);
  }

  String _trim(double v) =>
      v == v.roundToDouble() ? '${v.round()}' : v.toString();

  @override
  void dispose() {
    _kcal.dispose();
    _protein.dispose();
    _carbs.dispose();
    _fat.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    await ref.read(settingsRepositoryProvider).setGoals(
          kcal: int.parse(_kcal.text),
          protein: double.parse(_protein.text.replaceAll(',', '.')),
          carbs: double.parse(_carbs.text.replaceAll(',', '.')),
          fat: double.parse(_fat.text.replaceAll(',', '.')),
        );
    if (!mounted) return;
    HapticFeedback.lightImpact();
    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.goals)),
      body: !_ready
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
              children: [
                Text(l10n.goalsSubtitle),
                const SizedBox(height: 24),
                TextField(
                  controller: _kcal,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: l10n.kcalGoal,
                    suffixText: l10n.kcal,
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _protein,
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  decoration: InputDecoration(
                    labelText: l10n.protein,
                    suffixText: l10n.gram,
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _carbs,
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  decoration: InputDecoration(
                    labelText: l10n.carbs,
                    suffixText: l10n.gram,
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _fat,
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  decoration: InputDecoration(
                    labelText: l10n.fat,
                    suffixText: l10n.gram,
                  ),
                ),
                const SizedBox(height: 32),
                FilledButton(onPressed: _save, child: Text(l10n.save)),
              ],
            ),
    );
  }
}
