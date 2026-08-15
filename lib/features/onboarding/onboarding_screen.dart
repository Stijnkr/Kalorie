import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/theme.dart';
import '../../core/l10n/generated/app_localizations.dart';
import '../../core/macro_goals.dart';
import '../../core/widgets/kalorie_ui.dart';
import '../../data/providers.dart';

enum _Direction { lose, maintain, gain }

enum _Pace { calm, normal, fast }

/// Onboarding in drie stappen: richting, tempo, en het dagdoel dat daaruit
/// volgt. De laatste stap laat het cijfer zien zodat je het meteen kunt
/// bijstellen.
class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  static const _steps = 3;
  static const _minKcal = 1200;
  static const _maxKcal = 6000;

  int _step = 0;
  _Direction _direction = _Direction.lose;
  _Pace _pace = _Pace.normal;
  int? _kcal;

  /// 1 kg vet ≈ 7700 kcal, dus 0,5 kg/week ≈ 550 kcal/dag.
  int get _suggestedKcal {
    const base = MacroGoals.defaultKcal;
    if (_direction == _Direction.maintain) return base;
    final perDay = switch (_pace) {
      _Pace.calm => 275,
      _Pace.normal => 550,
      _Pace.fast => 825,
    };
    final delta = _direction == _Direction.lose ? -perDay : perDay;
    return (base + delta).clamp(_minKcal, _maxKcal);
  }

  int get _goal => _kcal ?? _suggestedKcal;

  void _next() {
    if (_step < _steps - 1) {
      setState(() {
        if (_step == 0 && _direction == _Direction.maintain) {
          // Zonder richting is er geen tempo te kiezen.
          _step = 2;
        } else {
          _step++;
        }
        _kcal = null;
      });
      return;
    }
    _finish();
  }

  Future<void> _finish() async {
    final macros = MacroGoals.forKcal(_goal);
    await ref.read(settingsRepositoryProvider).completeOnboarding(
          kcal: _goal,
          protein: macros.protein,
          carbs: macros.carbs,
          fat: macros.fat,
        );
    if (!mounted) return;
    HapticFeedback.mediumImpact();
    if (context.canPop()) {
      context.pop();
    } else {
      context.go('/today');
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final tones = context.tones;

    final title = switch (_step) {
      0 => l10n.obGoalTitle,
      1 => l10n.obPaceTitle,
      _ => l10n.obDoneTitle,
    };
    final body = switch (_step) {
      0 => l10n.obGoalBody,
      1 => l10n.obPaceBody,
      _ => l10n.obDoneBody,
    };

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            if (_step > 0)
              Align(
                alignment: Alignment.centerLeft,
                child: KalorieTapTarget(
                  onTap: () => setState(() => _step -= 1),
                  child: Icon(
                    Icons.chevron_left,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
              )
            else
              const SizedBox(height: 44),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 40),
                    Text(
                      l10n.stepOf(_step + 1, _steps).toUpperCase(),
                      style: theme.textTheme.labelSmall,
                    ),
                    const SizedBox(height: 14),
                    Text(title, style: theme.textTheme.headlineLarge),
                    const SizedBox(height: 14),
                    Text(body, style: theme.textTheme.bodyLarge),
                    const SizedBox(height: 28),
                    if (_step == 0)
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          _chip(l10n.obLose, _Direction.lose),
                          _chip(l10n.obMaintain, _Direction.maintain),
                          _chip(l10n.obGain, _Direction.gain),
                        ],
                      )
                    else if (_step == 1)
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          _paceChip(l10n.obPaceCalm, _Pace.calm),
                          _paceChip(l10n.obPaceNormal, _Pace.normal),
                          _paceChip(l10n.obPaceFast, _Pace.fast),
                        ],
                      )
                    else
                      Row(
                        children: [
                          KalorieStepButton(
                            plus: false,
                            size: 48,
                            filled: false,
                            enabled: _goal > _minKcal,
                            onTap: () => setState(
                              () => _kcal = (_goal - 50).clamp(_minKcal, _maxKcal),
                            ),
                          ),
                          Expanded(
                            child: Column(
                              children: [
                                Text(
                                  '$_goal',
                                  style: theme.textTheme.displaySmall,
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  l10n.kcalPerDay,
                                  style: theme.textTheme.bodySmall
                                      ?.copyWith(color: tones.hint),
                                ),
                              ],
                            ),
                          ),
                          KalorieStepButton(
                            plus: true,
                            size: 48,
                            filled: false,
                            enabled: _goal < _maxKcal,
                            onTap: () => setState(
                              () => _kcal = (_goal + 50).clamp(_minKcal, _maxKcal),
                            ),
                          ),
                        ],
                      ),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(32, 0, 32, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  FilledButton(
                    onPressed: _next,
                    child: Text(_step < _steps - 1 ? l10n.next : l10n.begin),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    l10n.obFootnote,
                    textAlign: TextAlign.center,
                    style: theme.textTheme.labelMedium
                        ?.copyWith(color: tones.hint),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _chip(String label, _Direction value) => KaloriePill(
        label: label,
        large: true,
        selected: _direction == value,
        onTap: () => setState(() => _direction = value),
      );

  Widget _paceChip(String label, _Pace value) => KaloriePill(
        label: label,
        large: true,
        selected: _pace == value,
        onTap: () => setState(() => _pace = value),
      );
}
