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

enum _AmountUnit { g, ml }

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
  bool _busy = false;
  late double _grams;
  late MealType _meal;
  _AmountUnit _unit = _AmountUnit.g;
  late final TextEditingController _input;

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
          liquid: _isLiquid(food),
        );
      }
      _unit = (_isLiquid(food) ||
              ServingMath.looksLiquid(
                name: entry?.foodName,
                servingLabel: entry?.servingLabel,
              ))
          ? _AmountUnit.ml
          : _AmountUnit.g;
      _syncInput();
    });
  }

  bool _isLiquid(Food? food) => ServingMath.looksLiquid(
        name: food?.name,
        servingLabel: food?.servingLabel,
      );

  void _syncInput() {
    _input.text = '${_grams.round()}';
  }

  void _setGrams(double value, {bool syncInput = true}) {
    setState(() => _grams = value.clamp(1, 5000));
    if (syncInput) _syncInput();
  }

  void _nudge(double delta) {
    HapticFeedback.selectionClick();
    _setGrams(_grams + delta);
  }

  double get _step => _unit == _AmountUnit.ml ? 25 : 10;

  List<HouseholdPortion> get _chips {
    final food = _food;
    if (food != null) {
      return ServingMath.suggestionsFor(
        name: food.name,
        servingG: food.servingG,
        servingLabel: food.servingLabel,
      );
    }
    final entry = _entry;
    if (entry == null) return const [];
    return ServingMath.suggestionsFor(
      name: entry.foodName,
      servingG: null,
      servingLabel: entry.servingLabel,
    );
  }

  double _per100(double total) {
    final grams = _entry?.amountG ?? 0;
    if (grams <= 0) return 0;
    return total * 100 / grams;
  }

  Future<void> _save() async {
    if (_busy) return;
    final food = _food;
    final entry = _entry;
    if (food == null && entry == null) return;
    setState(() => _busy = true);
    try {
      final diary = ref.read(diaryRepositoryProvider);
      if (entry != null && food == null) {
        await diary.updateRaw(entry: entry, amountG: _grams, meal: _meal);
      } else if (entry != null && food != null) {
        await diary.update(
          entry: entry,
          food: food,
          amountG: _grams,
          meal: _meal,
        );
      } else if (food != null) {
        await diary.add(
          food: food,
          amountG: _grams,
          meal: _meal,
          dateKey: ref.read(selectedDateKeyProvider),
        );
      }
      if (!mounted) return;
      HapticFeedback.mediumImpact();
      context.go('/today');
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _editFood() async {
    await context.push('/food/${widget.foodId}/edit');
    await _load();
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
    final entry = _entry;
    if (food == null && entry == null) {
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

    final name = food?.name ?? entry!.foodName;
    final brand = food?.brand ?? entry?.brand;
    final kcal100g = food?.kcal100g ?? _per100(entry!.kcal);
    final servingG = food?.servingG;
    final servingLabel = food?.servingLabel ?? entry?.servingLabel;
    final kcal = NutrientMath.scale(kcal100g, _grams);
    final per100 = '${displayKcal(kcal100g)} kcal / 100 g';
    final subtitle =
        brand != null && brand.isNotEmpty ? '$brand · $per100' : per100;
    final unitLabel = _unit == _AmountUnit.ml ? 'ml' : 'g';
    final amountHint = ServingMath.describe(
      grams: _grams,
      servingG: servingG,
      servingLabel: servingLabel,
      liquid: _unit == _AmountUnit.ml,
    );

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
                    keyboardDismissBehavior:
                        ScrollViewKeyboardDismissBehavior.onDrag,
                    padding: const EdgeInsets.fromLTRB(20, 6, 20, 120),
                    children: [
                      Text(name, style: theme.textTheme.headlineMedium),
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
                                textInputAction: TextInputAction.done,
                                onTapOutside: (_) => FocusManager
                                    .instance.primaryFocus
                                    ?.unfocus(),
                                onSubmitted: (_) => FocusManager
                                    .instance.primaryFocus
                                    ?.unfocus(),
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
                                  _setGrams(n, syncInput: false);
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
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          KaloriePill(
                            label: 'g',
                            selected: _unit == _AmountUnit.g,
                            onTap: () {
                              setState(() => _unit = _AmountUnit.g);
                            },
                          ),
                          const SizedBox(width: 8),
                          KaloriePill(
                            label: 'ml',
                            selected: _unit == _AmountUnit.ml,
                            onTap: () {
                              setState(() => _unit = _AmountUnit.ml);
                            },
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
                          for (final portion in _chips)
                            KaloriePill(
                              label: portion.chipLabel,
                              selected: (_grams - portion.grams).abs() < 1,
                              onTap: () {
                                setState(() {
                                  _unit = portion.liquid
                                      ? _AmountUnit.ml
                                      : _AmountUnit.g;
                                });
                                _setGrams(portion.grams);
                              },
                            ),
                          KaloriePill(
                            label: '100 $unitLabel',
                            selected: _grams.round() == 100 &&
                                !_chips.any((p) => (p.grams - 100).abs() < 1),
                            onTap: () => _setGrams(100),
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
                        per100g: food?.protein100g ?? _per100(entry!.protein),
                        grams: _grams,
                      ),
                      _NutrientRow(
                        label: l10n.carbs,
                        per100g: food?.carbs100g ?? _per100(entry!.carbs),
                        grams: _grams,
                      ),
                      _NutrientRow(
                        label: l10n.sugarsLower,
                        per100g: food?.sugars100g ??
                            (entry?.sugars == null
                                ? null
                                : _per100(entry!.sugars!)),
                        grams: _grams,
                      ),
                      _NutrientRow(
                        label: l10n.fat,
                        per100g: food?.fat100g ?? _per100(entry!.fat),
                        grams: _grams,
                      ),
                      _NutrientRow(
                        label: l10n.satFatLower,
                        per100g: food?.satFat100g ??
                            (entry?.satFat == null
                                ? null
                                : _per100(entry!.satFat!)),
                        grams: _grams,
                      ),
                      _NutrientRow(
                        label: l10n.fiber,
                        per100g: food?.fiber100g ??
                            (entry?.fiber == null
                                ? null
                                : _per100(entry!.fiber!)),
                        grams: _grams,
                      ),
                      _NutrientRow(
                        label: l10n.salt,
                        per100g: food?.salt100g ??
                            (entry?.salt == null
                                ? null
                                : _per100(entry!.salt!)),
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
                      if (food != null) ...[
                        const SizedBox(height: 28),
                        KaloriePanelList(
                          children: [
                            KaloriePanelTile(
                              title: l10n.fixFood,
                              subtitle: l10n.fixFoodHint,
                              chevron: true,
                              onTap: _editFood,
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: 0,
                    child: KalorieFooterAction(
                      child: FilledButton(
                        onPressed: _busy ? null : _save,
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
