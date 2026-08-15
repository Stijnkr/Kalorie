import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants.dart';
import '../../core/day_summary.dart';
import '../../core/l10n/generated/app_localizations.dart';
import '../../core/serving.dart';
import '../../core/widgets/amount_stepper.dart';
import '../../data/local/collections/diary_entry.dart';
import '../../data/local/collections/enums.dart';
import '../../data/local/collections/food.dart';
import '../../data/providers.dart';

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
            orElse: () => mealForNow(),
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
        _grams = food?.lastAmountG ?? food?.servingG ?? 100;
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
      final p = ServingMath.portionsFromGrams(_grams, food!.servingG!);
      _input.text = ServingMath.formatCount(p);
    } else {
      _input.text = '${_grams.round()}';
    }
  }

  void _setGrams(double value, {bool syncInput = true}) {
    setState(() => _grams = value.clamp(1, 5000));
    if (syncInput) _syncInput();
  }

  void _nudge(double deltaGrams) => _setGrams(_grams + deltaGrams);

  Future<void> _save() async {
    final food = _food;
    if (food == null) return;
    final dateKey = ref.read(selectedDateKeyProvider);
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
            dateKey: dateKey,
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
    if (!_loaded) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    final food = _food;
    if (food == null) {
      return Scaffold(
        appBar: AppBar(),
        body: Center(child: Text(l10n.productNotFound)),
      );
    }

    final kcal = NutrientMath.scale(food.kcal100g, _grams);
    final protein = NutrientMath.scale(food.protein100g, _grams);
    final carbs = NutrientMath.scale(food.carbs100g, _grams);
    final fat = NutrientMath.scale(food.fat100g, _grams);
    final theme = Theme.of(context);
    final servingG = food.servingG;
    final portions = servingG == null
        ? 0.0
        : ServingMath.portionsFromGrams(_grams, servingG);
    final stepperLabel = _unit == _Unit.portions && _hasServing
        ? ServingMath.formatCount(portions)
        : '${_grams.round()} g';

    return Scaffold(
      appBar: AppBar(
        title: Text(_entry == null ? food.name : l10n.editAmount),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(24, 8, 24, 32),
        children: [
          if (_entry != null)
            Text(food.name, style: theme.textTheme.titleMedium),
          if (food.brand != null) Text(food.brand!),
          const SizedBox(height: 8),
          Text(
            '${displayKcal(food.kcal100g)} kcal / 100 g',
            style: theme.textTheme.bodySmall,
          ),
          const SizedBox(height: 20),
          SegmentedButton<_Unit>(
            segments: [
              ButtonSegment(
                value: _Unit.portions,
                label: Text(l10n.unitPortion),
                enabled: _hasServing,
              ),
              ButtonSegment(
                value: _Unit.grams,
                label: Text(l10n.unitGrams),
              ),
            ],
            selected: {_unit},
            onSelectionChanged: (next) {
              setState(() {
                _unit = next.first;
                _syncInput();
              });
            },
          ),
          const SizedBox(height: 20),
          AmountStepper(
            label: stepperLabel,
            onMinus: () {
              if (_unit == _Unit.portions && servingG != null) {
                _nudge(-servingG * 0.5);
              } else {
                _nudge(-10);
              }
            },
            onPlus: () {
              if (_unit == _Unit.portions && servingG != null) {
                _nudge(servingG * 0.5);
              } else {
                _nudge(10);
              }
            },
          ),
          if (_unit == _Unit.portions && _hasServing) ...[
            const SizedBox(height: 6),
            Text(
              '${food.servingLabel} = ${servingG!.round()} g  ·  ${_grams.round()} g totaal',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodySmall,
            ),
          ],
          const SizedBox(height: 16),
          TextField(
            controller: _input,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: InputDecoration(
              labelText: _unit == _Unit.portions ? l10n.portions : l10n.amount,
              suffixText: _unit == _Unit.portions
                  ? food.servingLabel
                  : l10n.gram,
            ),
            onChanged: (v) {
              final n = double.tryParse(v.replaceAll(',', '.'));
              if (n == null || n <= 0) return;
              if (_unit == _Unit.portions && servingG != null) {
                _setGrams(
                  ServingMath.gramsFromPortions(n, servingG),
                  syncInput: false,
                );
              } else {
                _setGrams(n, syncInput: false);
              }
            },
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              if (_hasServing)
                ...[0.5, 1.0, 1.5, 2.0, 3.0].map((p) {
                  final selected = servingG != null &&
                      (ServingMath.portionsFromGrams(_grams, servingG) - p)
                              .abs() <
                          0.05;
                  return ChoiceChip(
                    label: Text('${ServingMath.formatCount(p)}×'),
                    selected: selected,
                    onSelected: (_) =>
                        _setGrams(ServingMath.gramsFromPortions(p, servingG!)),
                  );
                })
              else
                ...[50, 100, 150, 200].map((g) {
                  return ChoiceChip(
                    label: Text('$g g'),
                    selected: _grams.round() == g,
                    onSelected: (_) => _setGrams(g.toDouble()),
                  );
                }),
            ],
          ),
          const SizedBox(height: 8),
          Align(
            alignment: Alignment.centerLeft,
            child: TextButton(
              onPressed: _editServing,
              child: Text(
                _hasServing ? l10n.editServing : l10n.defineServing,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            '${displayKcal(kcal)} kcal',
            style: theme.textTheme.headlineMedium,
          ),
          const SizedBox(height: 8),
          Text(
            '${l10n.protein} ${displayMacro(protein)} g · ${l10n.carbs} ${displayMacro(carbs)} g · ${l10n.fat} ${displayMacro(fat)} g',
          ),
          const SizedBox(height: 28),
          Text(l10n.meal, style: theme.textTheme.labelSmall),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: MealType.values.map((meal) {
              final label = switch (meal) {
                MealType.breakfast => l10n.breakfast,
                MealType.lunch => l10n.lunch,
                MealType.dinner => l10n.dinner,
                MealType.snack => l10n.snack,
              };
              return ChoiceChip(
                label: Text(label),
                selected: _meal == meal,
                onSelected: (_) => setState(() => _meal = meal),
              );
            }).toList(),
          ),
          const SizedBox(height: 20),
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: const Icon(Icons.tune),
            title: Text(l10n.fixFood),
            subtitle: Text(l10n.fixFoodHint),
            onTap: _editFood,
          ),
          const SizedBox(height: 16),
          FilledButton(
            onPressed: _save,
            child: Text(_entry == null ? l10n.log : l10n.save),
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
      ..servingLabel = _label.text.trim().isEmpty
          ? '1 portie'
          : _label.text.trim();
    await ref.read(foodRepositoryProvider).upsert(food);
    if (mounted) Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
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
          Text(l10n.defineServing, style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          Text(l10n.servingSheetHint, style: Theme.of(context).textTheme.bodySmall),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: servingPresets.map((preset) {
              return ActionChip(
                label: Text('${preset.label} (${preset.grams.round()} g)'),
                onPressed: () {
                  _label.text = preset.label;
                  _grams.text = '${preset.grams.round()}';
                  setState(() {});
                },
              );
            }).toList(),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _label,
            textCapitalization: TextCapitalization.sentences,
            decoration: InputDecoration(labelText: l10n.servingName),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _grams,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: InputDecoration(
              labelText: l10n.servingGrams,
              suffixText: l10n.gram,
            ),
          ),
          const SizedBox(height: 20),
          FilledButton(onPressed: _save, child: Text(l10n.save)),
        ],
      ),
    );
  }
}
