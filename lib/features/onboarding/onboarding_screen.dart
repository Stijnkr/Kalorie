import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/l10n/generated/app_localizations.dart';
import '../../data/providers.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final _kcal = TextEditingController(text: '2200');
  final _protein = TextEditingController(text: '120');
  final _carbs = TextEditingController(text: '250');
  final _fat = TextEditingController(text: '70');
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _kcal.dispose();
    _protein.dispose();
    _carbs.dispose();
    _fat.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    await ref.read(settingsRepositoryProvider).completeOnboarding(
          kcal: int.parse(_kcal.text),
          protein: double.parse(_protein.text.replaceAll(',', '.')),
          carbs: double.parse(_carbs.text.replaceAll(',', '.')),
          fat: double.parse(_fat.text.replaceAll(',', '.')),
        );
    if (!mounted) return;
    HapticFeedback.mediumImpact();
    context.go('/today');
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    return Scaffold(
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.fromLTRB(24, 48, 24, 32),
            children: [
              Text('Kalorie', style: theme.textTheme.labelSmall),
              const SizedBox(height: 12),
              Text(l10n.onboardingTitle, style: theme.textTheme.headlineMedium),
              const SizedBox(height: 10),
              Text(l10n.onboardingSubtitle),
              const SizedBox(height: 36),
              _GoalField(
                controller: _kcal,
                label: l10n.kcalGoal,
                suffix: l10n.kcal,
              ),
              const SizedBox(height: 16),
              _GoalField(
                controller: _protein,
                label: l10n.protein,
                suffix: l10n.gram,
              ),
              const SizedBox(height: 16),
              _GoalField(
                controller: _carbs,
                label: l10n.carbs,
                suffix: l10n.gram,
              ),
              const SizedBox(height: 16),
              _GoalField(
                controller: _fat,
                label: l10n.fat,
                suffix: l10n.gram,
              ),
              const SizedBox(height: 40),
              FilledButton(onPressed: _submit, child: Text(l10n.start)),
            ],
          ),
        ),
      ),
    );
  }
}

class _GoalField extends StatelessWidget {
  const _GoalField({
    required this.controller,
    required this.label,
    required this.suffix,
  });

  final TextEditingController controller;
  final String label;
  final String suffix;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      decoration: InputDecoration(labelText: label, suffixText: suffix),
      validator: (value) {
        final n = num.tryParse((value ?? '').replaceAll(',', '.'));
        if (n == null || n <= 0) return '…';
        return null;
      },
    );
  }
}
