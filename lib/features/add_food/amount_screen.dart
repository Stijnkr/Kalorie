import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/theme.dart';
import '../../core/constants.dart';
import '../../core/day_summary.dart';
import '../../core/l10n/generated/app_localizations.dart';
import '../../core/serving.dart';
import '../../core/widgets/kalorie_ui.dart';
import '../../core/widgets/panel.dart';
import '../../data/local/collections/diary_entry.dart';
import '../../data/local/collections/enums.dart';
import '../../data/local/collections/food.dart';
import '../../data/providers.dart';
import '../today/today_screen.dart' show mealLabel;

enum _Unit { portions, grams }

class AmountScreen extends ConsumerStatefulWidget {
  const AmountScreen({
    super.key,
    required this.foodId,
    this.initialMeal,
    this.entryId,
  });

  final int foodId;
  final String? initialMeal;
  final int? entryId;

  @override
  ConsumerState<AmountScreen> createState() => _AmountScreenState();
}

class _AmountScreenState extends ConsumerState<AmountScreen> {
  Food? _food;
  DiaryEntry? _entry;
  bool _loaded = false;
  late double _grams;
  late MealType _meal;
  _Unit _unit = _Unit.grams;
  late final TextEditingController _input;

  bool get _hasServing =>
      _food?.servingG != null &&
      _food!.servingG! > 0 &&
      (_food?.servingLabel?.isNotEmpty ?? false);

  @override
  void initState() {
    super.initState();
    _meal = widget.initialMeal == null
        ? mealForNow()
        : MealType.values.firstWhere(
            (m) => m.name == widget.initialMeal,
            orElse: mealForNow,
          );
    _grams = 100;
    _input = TextEditingController(text: '100');
    _load();
  }

  Future<void> _load() async {
    final food = await ref.read(foodRepositoryProvider).getById(widget.foodId);
    DiaryEntry? entry;
    if (widget.entryId != null) {
      entry = await ref.read(diaryRepositoryProvider).getEntry(widget.entryId!);
    }
    if (!mounted) return;
    setState(() {
      _food = food;
      _entry = entry;
      _loaded = true;
      if (entry != null) {
        _grams = entry.amountG;
        _meal = entry.meal;
      } else {
        _grams = ServingMath.defaultGrams(
          lastAmountG: food?.lastAmountG,
          servingG: food?.servingG,
        );
      }
      _unit = (food?.servingG != null && food!.servingG! > 0)
          ? _Unit.portions
          : _Unit.grams;
      _syncInput();
    });
  }

  void _syncInput() {
    final food = _food;
    if (_unit == _Unit.portions && food?.servingG != null) {
      _input.text = ServingMath.formatCount(
        ServingMath.portionsFromGrams(_grams, food!.servingG!),
      );
    } else {
      _input.text = '${_grams.round()}';
    }
  }

  void _setGrams(double value, {bool syncInput = true}) {
    setState(() => _grams = value.clamp(1, 5000));
    if (syncInput) _syncInput();
  }

  void _nudge(double delta) {
    HapticFeedback.selectionClick();
    _setGrams(_grams + delta);
  }

  double get _step {
    final servingG = _food?.servingG;
    if (_unit == _Unit.portions && servingG != null && servingG > 0) {
      return servingG * 0.5;
    }
    return 10;
  }

  Future<void> _save() async {
    final food = _food;
    if (food == null) return;
    final entry = _entry;
    if (entry != null) {
      await ref.read(diaryRepositoryProvider).update(
            entry: entry,
            food: food,
            amountG: _grams,
            meal: _meal,
          );
    } else {
      await ref.read(diaryRepositoryProvider).add(
            food: food,
            amountG: _grams,
            meal: _meal,
            dateKey: ref.read(selectedDateKeyProvider),
          );
    }
    if (!mounted) return;
    HapticFeedback.mediumImpact();
    context.go('/today');
  }

  Future<void> _editFood() async {
    await context.push('/food/${widget.foodId}/edit');
    await _load();
  }

  Future<void> _editServing() async {
    final food = _food;
    if (food == null) return;
    final saved = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      showDragHandle: true,
      builder: (context) => _ServingSheet(food: food),
    );
    if (saved == true) await _load();
  }

  @override
  void dispose() {
    _input.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final tones = context.tones;

    if (!_loaded) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    final food = _food;
    if (food == null) {
      return Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              KalorieOverlayHeader(
                title: l10n.productNotFound,
                onBack: () => context.pop(),
              ),
              const Spacer(),
              Text(l10n.productNotFoundHint),
              const Spacer(),
            ],
          ),
        ),
      );
    }

    final servingG = food.servingG;
    final kcal = NutrientMath.scale(food.kcal100g, _grams);
    final brand = food.brand;
    final per100 = '${displayKcal(food.kcal100g)} kcal / 100 g';
    final subtitle =
        brand != null && brand.isNotEmpty ? '$brand · $per100' : per100;
    final amountHint = _unit == _Unit.portions && _hasServing
        ? l10n.portionTotal(
            food.servingLabel!,
            servingG!.round(),
            _grams.round(),
          )
        : l10n.gramsUnit;

    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            KalorieOverlayHeader(
              title: _entry == null ? l10n.add : l10n.editPortion,
              onBack: () => context.pop(),
            ),
            Expanded(
              child: Stack(
                children: [
                  ListView(
                    padding: const EdgeInsets.fromLTRB(20, 6, 20, 120),
                    children: [
                      Text(food.name, style: theme.textTheme.headlineMedium),
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: theme.textTheme.bodySmall
                            ?.copyWith(color: tones.hint, height: 1.4),
                      ),
                      const SizedBox(height: 22),
                      Row(
                        children: [
                          KalorieStepButton(
                            plus: false,
                            onTap: () => _nudge(-_step),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: SizedBox(
                              height: 52,
                              child: TextField(
                                controller: _input,
                                textAlign: TextAlign.center,
                                keyboardType:
                                    const TextInputType.numberWithOptions(
                                  decimal: true,
                                ),
                                style: theme.textTheme.headlineSmall,
                                decoration: InputDecoration(
                                  contentPadding: EdgeInsets.zero,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(14),
                                    borderSide: BorderSide(
                                      color: theme.colorScheme.outline,
                                      width: 0.5,
                                    ),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(14),
                                    borderSide: BorderSide(
                                      color: theme.colorScheme.outline,
                                      width: 0.5,
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(14),
                                    borderSide: BorderSide(
                                      color: theme.colorScheme.primary,
                                      width: 1.2,
                                    ),
                                  ),
                                ),
                                onChanged: (v) {
                                  final n =
                                      double.tryParse(v.replaceAll(',', '.'));
                                  if (n == null || n <= 0) return;
                                  if (_unit == _Unit.portions &&
                                      servingG != null) {
                                    _setGrams(
                                      ServingMath.gramsFromPortions(
                                        n,
                                        servingG,
                                      ),
                                      syncInput: false,
                                    );
                                  } else {
                                    _setGrams(n, syncInput: false);
                                  }
                                },
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          KalorieStepButton(
                            plus: true,
                            onTap: () => _nudge(_step),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        amountHint,
                        textAlign: TextAlign.center,
                        style: theme.textTheme.bodySmall
                            ?.copyWith(color: tones.hint, height: 1.4),
                      ),
                      const SizedBox(height: 16),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          if (_hasServing && servingG != null)
                            ...[0.5, 1.0, 1.5, 2.0].map((p) {
                              final selected = _unit == _Unit.portions &&
                                  (ServingMath.portionsFromGrams(
                                            _grams,
                                            servingG,
                                          ) -
                                          p)
                                          .abs() <
                                      0.05;
                              return KaloriePill(
                                label:
                                    '${ServingMath.formatCount(p)} × ${food.servingLabel}',
                                selected: selected,
                                onTap: () {
                                  setState(() => _unit = _Unit.portions);
                                  _setGrams(
                                    ServingMath.gramsFromPortions(p, servingG),
                                  );
                                },
                              );
                            }),
                          if (_hasServing)
                            KaloriePill(
                              label: l10n.inGrams,
                              selected: _unit == _Unit.grams,
                              onTap: () {
                                setState(() => _unit = _Unit.grams);
                                _syncInput();
                              },
                            )
                          else
                            ...[50, 100, 150, 200].map(
                              (g) => KaloriePill(
                                label: '$g g',
                                selected: _grams.round() == g,
                                onTap: () => _setGrams(g.toDouble()),
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      const KalorieHairline(),
                      const SizedBox(height: 20),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            '${displayKcal(kcal)}',
                            style: theme.textTheme.displayMedium,
                          ),
                          const SizedBox(width: 10),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 6),
                            child: Text(
                              l10n.kcal,
                              style: theme.textTheme.bodySmall,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      _NutrientRow(
                        label: l10n.protein,
                        per100g: food.protein100g,
                        grams: _grams,
                      ),
                      _NutrientRow(
                        label: l10n.carbs,
                        per100g: food.carbs100g,
                        grams: _grams,
                      ),
                      _NutrientRow(
                        label: l10n.sugarsLower,
                        per100g: food.sugars100g,
                        grams: _grams,
                      ),
                      _NutrientRow(
                        label: l10n.fat,
                        per100g: food.fat100g,
                        grams: _grams,
                      ),
                      _NutrientRow(
                        label: l10n.satFatLower,
                        per100g: food.satFat100g,
                        grams: _grams,
                      ),
                      _NutrientRow(
                        label: l10n.fiber,
                        per100g: food.fiber100g,
                        grams: _grams,
                      ),
                      _NutrientRow(
                        label: l10n.salt,
                        per100g: food.salt100g,
                        grams: _grams,
                      ),
                      const SizedBox(height: 28),
                      KalorieSectionLabel(l10n.meal),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: MealType.values
                            .map(
                              (meal) => KaloriePill(
                                label: mealLabel(l10n, meal),
                                selected: _meal == meal,
                                onTap: () => setState(() => _meal = meal),
                              ),
                            )
                            .toList(),
                      ),
                      const SizedBox(height: 28),
                      KaloriePanelList(
                        children: [
                          KaloriePanelTile(
                            title: _hasServing
                                ? l10n.editServing
                                : l10n.defineServing,
                            subtitle: l10n.servingSheetHint,
                            chevron: true,
                            onTap: _editServing,
                          ),
                          KaloriePanelTile(
                            title: l10n.fixFood,
                            subtitle: l10n.fixFoodHint,
                            chevron: true,
                            onTap: _editFood,
                          ),
                        ],
                      ),
                    ],
                  ),
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: 0,
                    child: KalorieFooterAction(
                      child: FilledButton(
                        onPressed: _save,
                        child: Text(
                          _entry == null
                              ? l10n.logInMeal(
                                  mealLabel(l10n, _meal).toLowerCase(),
                                )
                              : l10n.save,
                        ),
                      ),
                    ),
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

/// Eén voedingswaarderij: naam, waarde per 100 g, en de waarde voor deze portie.
class _NutrientRow extends StatelessWidget {
  const _NutrientRow({
    required this.label,
    required this.per100g,
    required this.grams,
  });

  final String label;
  final double? per100g;
  final double grams;

  @override
  Widget build(BuildContext context) {
    if (per100g == null) return const SizedBox.shrink();
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final tones = context.tones;
    final value = NutrientMath.scale(per100g!, grams);

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.baseline,
        textBaseline: TextBaseline.alphabetic,
        children: [
          Expanded(
            child: Text(
              label,
              style: theme.textTheme.bodySmall?.copyWith(fontSize: 14),
            ),
          ),
          Text(
            l10n.per100Short(displayMacro(per100g!)),
            style: theme.textTheme.bodySmall
                ?.copyWith(fontSize: 12, color: tones.hint),
          ),
          const SizedBox(width: 10),
          SizedBox(
            width: 58,
            child: Text(
              '${displayMacro(value)} g',
              textAlign: TextAlign.right,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                fontFeatures: const [FontFeature.tabularFigures()],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ServingSheet extends ConsumerStatefulWidget {
  const _ServingSheet({required this.food});

  final Food food;

  @override
  ConsumerState<_ServingSheet> createState() => _ServingSheetState();
}

class _ServingSheetState extends ConsumerState<_ServingSheet> {
  late final TextEditingController _label;
  late final TextEditingController _grams;

  @override
  void initState() {
    super.initState();
    _label = TextEditingController(
      text: widget.food.servingLabel ?? '1 portie',
    );
    _grams = TextEditingController(
      text: widget.food.servingG == null
          ? '100'
          : '${widget.food.servingG!.round()}',
    );
  }

  @override
  void dispose() {
    _label.dispose();
    _grams.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final g = double.tryParse(_grams.text.replaceAll(',', '.'));
    if (g == null || g <= 0) return;
    final food = widget.food
      ..servingG = g
      ..servingLabel =
          _label.text.trim().isEmpty ? '1 portie' : _label.text.trim();
    await ref.read(foodRepositoryProvider).upsert(food);
    if (mounted) Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    return SingleChildScrollView(
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
          Text(l10n.defineServing, style: theme.textTheme.titleMedium),
          const SizedBox(height: 8),
          Text(l10n.servingSheetHint, style: theme.textTheme.bodySmall),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: servingPresets
                .map(
                  (preset) => KaloriePill(
                    label: '${preset.label} (${preset.grams.round()} g)',
                    selected: _label.text.trim() == preset.label,
                    onTap: () {
                      _label.text = preset.label;
                      _grams.text = '${preset.grams.round()}';
                      setState(() {});
                    },
                  ),
                )
                .toList(),
          ),
          const SizedBox(height: 20),
          KalorieSectionLabel(l10n.servingName),
          TextField(
            controller: _label,
            textCapitalization: TextCapitalization.sentences,
            onChanged: (_) => setState(() {}),
          ),
          const SizedBox(height: 16),
          KalorieSectionLabel(l10n.servingGrams),
          TextField(
            controller: _grams,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: InputDecoration(suffixText: l10n.gram),
          ),
          const SizedBox(height: 24),
          FilledButton(onPressed: _save, child: Text(l10n.save)),
        ],
      ),
    );
  }
}
