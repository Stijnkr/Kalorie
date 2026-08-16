import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/theme.dart';
import '../../core/energy.dart';
import '../../core/l10n/generated/app_localizations.dart';
import '../../core/widgets/kalorie_ui.dart';
import '../../data/providers.dart';
import '../account/auth_form.dart';
import '../legal/legal_screen.dart';

/// Onboarding: account, lichaam, beweging, doel, en een bijstelbaar dagdoel.
class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final _authKey = GlobalKey<AuthFormState>();
  final _age = TextEditingController(text: '30');
  final _height = TextEditingController(text: '175');
  final _weight = TextEditingController(text: '75');

  int _step = 0;
  AuthMode _authMode = AuthMode.signUp;
  bool _initialised = false;
  BiologicalSex _sex = BiologicalSex.female;
  ActivityLevel _activity = ActivityLevel.light;
  WeightGoal _goal = WeightGoal.lose;
  GoalPace _pace = GoalPace.normal;
  int? _kcalOverride;

  static const _steps = 5;

  EnergyProfile get _profile => EnergyProfile(
        sex: _sex,
        ageYears: int.tryParse(_age.text.trim()) ?? 0,
        heightCm: _parse(_height.text),
        weightKg: _parse(_weight.text),
        activity: _activity,
        goal: _goal,
        pace: _pace,
      );

  EnergyEstimate get _estimate => EnergyEstimate.of(_profile);

  int get _kcal =>
      (_kcalOverride ?? _estimate.target).clamp(
        EnergyEstimate.minKcal,
        EnergyEstimate.maxKcal,
      );

  double _parse(String raw) =>
      double.tryParse(raw.trim().replaceAll(',', '.')) ?? 0;

  @override
  void dispose() {
    _age.dispose();
    _height.dispose();
    _weight.dispose();
    super.dispose();
  }

  Future<void> _next() async {
    if (_step == 0) {
      await _authKey.currentState?.submit();
      return;
    }
    if (_step == 1 && !_profile.isValid) return;
    if (_step < 4) {
      setState(() {
        _step += 1;
        if (_step == 4) _kcalOverride = null;
      });
      return;
    }
    await _finish();
  }

  void _back() {
    if (_step == 0) return;
    setState(() => _step -= 1);
  }

  Future<void> _finish() async {
    if (!ref.read(isSignedInProvider)) {
      setState(() => _step = 0);
      return;
    }
    final macros = EnergyEstimate.of(_profile).macros;
    // Handmatig doel: macro's schalen mee vanaf de schatting.
    final scaled = macros.scaledTo(_estimate.target, _kcal);
    await ref.read(settingsRepositoryProvider).completeOnboarding(
          kcal: _kcal,
          protein: scaled.protein,
          carbs: scaled.carbs,
          fat: scaled.fat,
        );
    if (ref.read(isSignedInProvider)) {
      await ref.read(syncEngineProvider).run();
    }
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
    final signUp = _authMode == AuthMode.signUp;

    if (!_initialised) {
      _initialised = true;
      if (ref.read(isSignedInProvider)) {
        _step = 1;
      } else if (ref.read(settingsProvider).value?.cloudUserId != null) {
        _authMode = AuthMode.signIn;
      }
      final weights = ref.read(weightLogProvider).value;
      if (weights != null && weights.isNotEmpty) {
        _weight.text = weights.last.kg.toStringAsFixed(
          weights.last.kg == weights.last.kg.roundToDouble() ? 0 : 1,
        );
      }
    }

    final title = switch (_step) {
      0 => signUp ? l10n.obAccountTitleUp : l10n.obAccountTitleIn,
      1 => l10n.obBodyTitle,
      2 => l10n.obMoveTitle,
      3 => l10n.obGoalTitle,
      _ => l10n.obDoneTitle,
    };
    final body = switch (_step) {
      0 => signUp ? l10n.authSignUpBody : l10n.authSignInBody,
      1 => l10n.obBodyBody,
      2 => l10n.obMoveBody,
      3 => l10n.obGoalBody,
      _ => l10n.obDoneBody,
    };
    final cta = switch (_step) {
      0 => signUp ? l10n.signUp : l10n.signIn,
      4 => l10n.begin,
      _ => l10n.next,
    };
    final canNext = _step != 1 || _profile.isValid;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(
              height: 44,
              child: _step > 0
                  ? Align(
                      alignment: Alignment.centerLeft,
                      child: KalorieTapTarget(
                        onTap: _back,
                        child: Icon(
                          Icons.chevron_left,
                          color: theme.colorScheme.onSurface,
                        ),
                      ),
                    )
                  : null,
            ),
            Expanded(
              child: SingleChildScrollView(
                keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: _step == 0 ? 12 : 24),
                    Text(
                      l10n.stepOf(_step + 1, _steps).toUpperCase(),
                      style: theme.textTheme.labelSmall,
                    ),
                    const SizedBox(height: 14),
                    Text(title, style: theme.textTheme.headlineLarge),
                    const SizedBox(height: 14),
                    Text(body, style: theme.textTheme.bodyLarge),
                    const SizedBox(height: 24),
                    if (_step == 0)
                      AuthForm(
                        key: _authKey,
                        mode: _authMode,
                        onModeChanged: (mode) =>
                            setState(() => _authMode = mode),
                        onBusyChanged: (_) => setState(() {}),
                        onDone: () => setState(() => _step = 1),
                      )
                    else if (_step == 1)
                      _BodyStep(
                        sex: _sex,
                        age: _age,
                        height: _height,
                        weight: _weight,
                        onSex: (sex) => setState(() {
                          _sex = sex;
                          _kcalOverride = null;
                        }),
                        onChanged: () => setState(() => _kcalOverride = null),
                      )
                    else if (_step == 2)
                      _MoveStep(
                        activity: _activity,
                        onPick: (level) => setState(() {
                          _activity = level;
                          _kcalOverride = null;
                        }),
                      )
                    else if (_step == 3)
                      _GoalStep(
                        goal: _goal,
                        pace: _pace,
                        onGoal: (goal) => setState(() {
                          _goal = goal;
                          _kcalOverride = null;
                        }),
                        onPace: (pace) => setState(() {
                          _pace = pace;
                          _kcalOverride = null;
                        }),
                      )
                    else
                      _KcalStep(
                        kcal: _kcal,
                        estimate: _estimate,
                        onNudge: (delta) => setState(() {
                          _kcalOverride = (_kcal + delta).clamp(
                            EnergyEstimate.minKcal,
                            EnergyEstimate.maxKcal,
                          );
                        }),
                      ),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(32, 0, 32, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  FilledButton(
                    onPressed: (_step == 0 &&
                                (_authKey.currentState?.busy ?? false)) ||
                            !canNext
                        ? null
                        : _next,
                    child: Text(cta),
                  ),
                  const SizedBox(height: 8),
                  if (_step == 0)
                    const AuthLegalFooter()
                  else
                    Text(
                      _step == 4
                          ? l10n.obAdjustHint
                          : l10n.obFootnoteSignedIn,
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
}

class _BodyStep extends StatelessWidget {
  const _BodyStep({
    required this.sex,
    required this.age,
    required this.height,
    required this.weight,
    required this.onSex,
    required this.onChanged,
  });

  final BiologicalSex sex;
  final TextEditingController age;
  final TextEditingController height;
  final TextEditingController weight;
  final ValueChanged<BiologicalSex> onSex;
  final VoidCallback onChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            KaloriePill(
              label: l10n.obSexFemale,
              large: true,
              selected: sex == BiologicalSex.female,
              onTap: () => onSex(BiologicalSex.female),
            ),
            KaloriePill(
              label: l10n.obSexMale,
              large: true,
              selected: sex == BiologicalSex.male,
              onTap: () => onSex(BiologicalSex.male),
            ),
          ],
        ),
        const SizedBox(height: 18),
        _MeasureField(
          label: l10n.obAge,
          controller: age,
          unit: l10n.obYears,
          onChanged: (_) => onChanged(),
        ),
        _MeasureField(
          label: l10n.obHeight,
          controller: height,
          unit: l10n.cm,
          onChanged: (_) => onChanged(),
        ),
        _MeasureField(
          label: l10n.obWeight,
          controller: weight,
          unit: l10n.kg,
          decimal: true,
          onChanged: (_) => onChanged(),
        ),
      ],
    );
  }
}

class _MeasureField extends StatelessWidget {
  const _MeasureField({
    required this.label,
    required this.controller,
    required this.unit,
    required this.onChanged,
    this.decimal = false,
  });

  final String label;
  final TextEditingController controller;
  final String unit;
  final ValueChanged<String> onChanged;
  final bool decimal;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          KalorieSectionLabel(label, padding: const EdgeInsets.only(bottom: 6)),
          TextField(
            controller: controller,
            keyboardType: TextInputType.numberWithOptions(decimal: decimal),
            textInputAction: TextInputAction.next,
            onTapOutside: (_) => FocusManager.instance.primaryFocus?.unfocus(),
            decoration: InputDecoration(suffixText: unit),
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}

class _MoveStep extends StatelessWidget {
  const _MoveStep({required this.activity, required this.onPick});

  final ActivityLevel activity;
  final ValueChanged<ActivityLevel> onPick;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final items = <(ActivityLevel, String, String)>[
      (ActivityLevel.sedentary, l10n.obMoveNone, l10n.obMoveNoneSub),
      (ActivityLevel.light, l10n.obMoveLight, l10n.obMoveLightSub),
      (ActivityLevel.moderate, l10n.obMoveSport, l10n.obMoveSportSub),
      (ActivityLevel.high, l10n.obMoveMuch, l10n.obMoveMuchSub),
    ];
    return Column(
      children: [
        for (final item in items)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: _ChoiceRow(
              title: item.$2,
              subtitle: item.$3,
              selected: activity == item.$1,
              onTap: () => onPick(item.$1),
            ),
          ),
      ],
    );
  }
}

class _GoalStep extends StatelessWidget {
  const _GoalStep({
    required this.goal,
    required this.pace,
    required this.onGoal,
    required this.onPace,
  });

  final WeightGoal goal;
  final GoalPace pace;
  final ValueChanged<WeightGoal> onGoal;
  final ValueChanged<GoalPace> onPace;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            KaloriePill(
              label: l10n.obLose,
              large: true,
              selected: goal == WeightGoal.lose,
              onTap: () => onGoal(WeightGoal.lose),
            ),
            KaloriePill(
              label: l10n.obMaintain,
              large: true,
              selected: goal == WeightGoal.maintain,
              onTap: () => onGoal(WeightGoal.maintain),
            ),
            KaloriePill(
              label: l10n.obGain,
              large: true,
              selected: goal == WeightGoal.gain,
              onTap: () => onGoal(WeightGoal.gain),
            ),
          ],
        ),
        if (goal != WeightGoal.maintain) ...[
          const SizedBox(height: 22),
          KalorieSectionLabel(l10n.obPaceTitle),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              KaloriePill(
                label: l10n.obPaceCalm,
                large: true,
                selected: pace == GoalPace.calm,
                onTap: () => onPace(GoalPace.calm),
              ),
              KaloriePill(
                label: l10n.obPaceNormal,
                large: true,
                selected: pace == GoalPace.normal,
                onTap: () => onPace(GoalPace.normal),
              ),
              KaloriePill(
                label: l10n.obPaceFast,
                large: true,
                selected: pace == GoalPace.fast,
                onTap: () => onPace(GoalPace.fast),
              ),
            ],
          ),
        ],
      ],
    );
  }
}

class _KcalStep extends StatelessWidget {
  const _KcalStep({
    required this.kcal,
    required this.estimate,
    required this.onNudge,
  });

  final int kcal;
  final EnergyEstimate estimate;
  final ValueChanged<int> onNudge;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final tones = context.tones;
    return Column(
      children: [
        Row(
          children: [
            KalorieStepButton(
              plus: false,
              size: 48,
              filled: false,
              enabled: kcal > EnergyEstimate.minKcal,
              onTap: () => onNudge(-50),
            ),
            Expanded(
              child: Column(
                children: [
                  Text('$kcal', style: theme.textTheme.displaySmall),
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
              enabled: kcal < EnergyEstimate.maxKcal,
              onTap: () => onNudge(50),
            ),
          ],
        ),
        const SizedBox(height: 18),
        Text(
          l10n.obEstimateLine(estimate.target, estimate.maintain),
          textAlign: TextAlign.center,
          style: theme.textTheme.bodySmall?.copyWith(
            color: tones.hint,
            height: 1.45,
          ),
        ),
      ],
    );
  }
}

class _ChoiceRow extends StatelessWidget {
  const _ChoiceRow({
    required this.title,
    required this.subtitle,
    required this.selected,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final tones = context.tones;
    final sage = theme.colorScheme.primary;
    return Material(
      color: selected ? sage : Colors.transparent,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: selected ? sage : theme.colorScheme.outline,
              width: 0.5,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: theme.textTheme.titleSmall?.copyWith(
                  color: selected
                      ? theme.colorScheme.onPrimary
                      : theme.colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: selected
                      ? theme.colorScheme.onPrimary.withValues(alpha: 0.82)
                      : tones.hint,
                  height: 1.35,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
