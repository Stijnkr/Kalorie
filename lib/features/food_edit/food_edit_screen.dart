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
import '../../core/widgets/stroke_icon.dart';
import '../../data/local/collections/enums.dart';
import '../../data/local/collections/food.dart';
import '../../data/providers.dart';
import '../add_food/quick_log.dart';

class FoodEditScreen extends ConsumerStatefulWidget {
  const FoodEditScreen({
    super.key,
    this.foodId,
    this.barcode,
    this.stayOnSave = false,
    this.logOnSave = false,
    this.initialMeal,
  });

  final int? foodId;
  final String? barcode;
  final bool stayOnSave;
  final bool logOnSave;
  final String? initialMeal;

  @override
  ConsumerState<FoodEditScreen> createState() => _FoodEditScreenState();
}

class _FoodEditScreenState extends ConsumerState<FoodEditScreen> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _brand = TextEditingController();
  final _barcode = TextEditingController();
  final _kcal = TextEditingController();
  final _protein = TextEditingController();
  final _carbs = TextEditingController();
  final _sugars = TextEditingController();
  final _fat = TextEditingController();
  final _satFat = TextEditingController();
  final _fiber = TextEditingController();
  final _salt = TextEditingController();
  final _serving = TextEditingController();
  final _servingLabel = TextEditingController();
  Food? _existing;
  bool _loading = true;
  bool _busy = false;

  @override
  void initState() {
    super.initState();
    _barcode.text = widget.barcode ?? '';
    _servingLabel.text = '1 portie';
    _load();
  }

  Future<void> _load() async {
    if (widget.foodId != null) {
      final food =
          await ref.read(foodRepositoryProvider).getById(widget.foodId!);
      if (food != null) {
        _existing = food;
        _name.text = food.name;
        _brand.text = food.brand ?? '';
        _barcode.text = food.barcode ?? '';
        _kcal.text = _n(food.kcal100g);
        _protein.text = _n(food.protein100g);
        _carbs.text = _n(food.carbs100g);
        _sugars.text = _nOrEmpty(food.sugars100g);
        _fat.text = _n(food.fat100g);
        _satFat.text = _nOrEmpty(food.satFat100g);
        _fiber.text = _nOrEmpty(food.fiber100g);
        _salt.text = _nOrEmpty(food.salt100g);
        _serving.text = food.servingG == null ? '' : _n(food.servingG!);
        _servingLabel.text = food.servingLabel ?? '1 portie';
      }
    }
    if (mounted) setState(() => _loading = false);
  }

  String _n(double v) => v == v.roundToDouble() ? '${v.round()}' : '$v';

  String _nOrEmpty(double? v) => v == null ? '' : _n(v);

  double _parse(String raw) => double.parse(raw.trim().replaceAll(',', '.'));

  double? _parseOrNull(String raw) {
    final text = raw.trim();
    if (text.isEmpty) return null;
    return double.tryParse(text.replaceAll(',', '.'));
  }

  Future<void> _save() async {
    if (_busy || !_formKey.currentState!.validate()) return;
    setState(() => _busy = true);
    try {
      final food = _existing ??
          (Food()
            ..source = FoodSource.custom
            ..kind = FoodKind.generic
            ..isFavorite = false
            ..userOverridden = false);
      if (_existing != null) food.userOverridden = true;

      final servingRaw = _serving.text.trim();
      final brand = _brand.text.trim();
      final barcode = _barcode.text.trim();
      food
        ..name = _name.text.trim()
        ..nameNormalized = normalizeName(_name.text)
        ..brand = brand.isEmpty ? null : brand
        ..barcode = barcode.isEmpty ? null : barcode
        ..kind = (brand.isNotEmpty || barcode.isNotEmpty)
            ? FoodKind.branded
            : FoodKind.generic
        ..kcal100g = _parse(_kcal.text)
        ..protein100g = _parse(_protein.text)
        ..carbs100g = _parse(_carbs.text)
        ..fat100g = _parse(_fat.text)
        ..sugars100g = _parseOrNull(_sugars.text)
        ..satFat100g = _parseOrNull(_satFat.text)
        ..fiber100g = _parseOrNull(_fiber.text)
        ..salt100g = _parseOrNull(_salt.text)
        ..servingG = servingRaw.isEmpty ? null : _parse(servingRaw)
        ..servingLabel = servingRaw.isEmpty
            ? null
            : (_servingLabel.text.trim().isEmpty
                ? '1 portie'
                : _servingLabel.text.trim());

      final id = await ref.read(foodRepositoryProvider).upsert(food);
      food.id = id;
      ref.invalidate(customFoodsProvider);
      if (!mounted) return;
      if (widget.logOnSave && _existing == null) {
        final meal = widget.initialMeal == null
            ? mealForNow()
            : MealType.values.firstWhere(
                (m) => m.name == widget.initialMeal,
                orElse: mealForNow,
              );
        await quickLogFood(context, ref, food: food, meal: meal);
        if (!mounted) return;
        context.go('/today');
        return;
      }
      HapticFeedback.lightImpact();
      if (_existing == null && !widget.stayOnSave) {
        final meal = widget.initialMeal;
        final query = meal == null || meal.isEmpty ? '' : '?meal=$meal';
        context.pushReplacement('/add/amount/$id$query');
      } else {
        context.pop();
      }
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _delete() async {
    final food = _existing;
    if (_busy || food == null || food.source != FoodSource.custom) return;
    final l10n = AppLocalizations.of(context);
    final ok = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.deleteProduct),
        content: Text(l10n.deleteProductConfirm(food.name)),
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
    if (ok != true) return;
    setState(() => _busy = true);
    try {
      await ref.read(foodRepositoryProvider).deleteCustom(food.id);
      ref.invalidate(customFoodsProvider);
      if (mounted) context.pop();
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  void dispose() {
    for (final controller in [
      _name,
      _brand,
      _barcode,
      _kcal,
      _protein,
      _carbs,
      _sugars,
      _fat,
      _satFat,
      _fiber,
      _salt,
      _serving,
      _servingLabel,
    ]) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final tones = context.tones;
    final editing = _existing != null;
    final kcal = _parseOrNull(_kcal.text);
    final name = _name.text.trim();
    final preview = name.isEmpty || kcal == null
        ? l10n.per100gHint
        : '$name · ${displayKcal(kcal)} ${l10n.kcal} ${l10n.per100g}';

    return Scaffold(
      body: SafeArea(
        child: _loading
            ? const Center(child: CircularProgressIndicator())
            : Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  KalorieOverlayHeader(
                    title: editing ? l10n.fixFood : l10n.newProduct,
                    closeIcon: !editing,
                    onBack: () => context.pop(),
                    action: editing &&
                            _existing?.source == FoodSource.custom
                        ? KalorieTapTarget(
                            tooltip: l10n.deleteProduct,
                            enabled: !_busy,
                            onTap: _delete,
                            child: StrokeIcon(
                              StrokeShape.trash,
                              size: 14,
                              color: tones.danger,
                            ),
                          )
                        : null,
                  ),
                  Expanded(
                    child: Form(
                      key: _formKey,
                      onChanged: () => setState(() {}),
                      child: Stack(
                        children: [
                          ListView(
                            keyboardDismissBehavior:
                                ScrollViewKeyboardDismissBehavior.onDrag,
                            padding: const EdgeInsets.fromLTRB(20, 6, 20, 140),
                            children: [
                              Text(
                                editing
                                    ? l10n.editDoesNotRewrite
                                    : l10n.per100gHint,
                                style: theme.textTheme.bodySmall
                                    ?.copyWith(height: 1.5),
                              ),
                              const SizedBox(height: 18),
                              _Field(
                                label: l10n.name,
                                controller: _name,
                                hint: l10n.foodNameHint,
                                capitalize: true,
                                required: true,
                              ),
                              _Field(label: l10n.brand, controller: _brand),
                              _Field(
                                label: l10n.barcode,
                                controller: _barcode,
                                keyboard: TextInputType.number,
                              ),
                              const SizedBox(height: 10),
                              KalorieSectionLabel(l10n.per100g),
                              _Field(
                                label: l10n.kcal,
                                controller: _kcal,
                                unit: l10n.kcal,
                                number: true,
                                required: true,
                              ),
                              _Field(
                                label: l10n.protein,
                                controller: _protein,
                                unit: l10n.gram,
                                number: true,
                                required: true,
                              ),
                              _Field(
                                label: l10n.carbs,
                                controller: _carbs,
                                unit: l10n.gram,
                                number: true,
                                required: true,
                              ),
                              _Field(
                                label: l10n.sugarsLower,
                                controller: _sugars,
                                unit: l10n.gram,
                                number: true,
                              ),
                              _Field(
                                label: l10n.fat,
                                controller: _fat,
                                unit: l10n.gram,
                                number: true,
                                required: true,
                              ),
                              _Field(
                                label: l10n.satFatLower,
                                controller: _satFat,
                                unit: l10n.gram,
                                number: true,
                              ),
                              _Field(
                                label: l10n.fiber,
                                controller: _fiber,
                                unit: l10n.gram,
                                number: true,
                              ),
                              _Field(
                                label: l10n.salt,
                                controller: _salt,
                                unit: l10n.gram,
                                number: true,
                              ),
                              const SizedBox(height: 10),
                              KalorieSectionLabel(l10n.serving),
                              Text(
                                l10n.servingSheetHint,
                                style: theme.textTheme.bodySmall
                                    ?.copyWith(color: tones.hint),
                              ),
                              const SizedBox(height: 12),
                              Wrap(
                                spacing: 8,
                                runSpacing: 8,
                                children: servingPresets
                                    .map(
                                      (preset) => KaloriePill(
                                        label: preset.label,
                                        selected: _servingLabel.text.trim() ==
                                                preset.label &&
                                            _serving.text.trim() ==
                                                '${preset.grams.round()}',
                                        onTap: () {
                                          _servingLabel.text = preset.label;
                                          _serving.text =
                                              '${preset.grams.round()}';
                                          setState(() {});
                                        },
                                      ),
                                    )
                                    .toList(),
                              ),
                              const SizedBox(height: 16),
                              _Field(
                                label: l10n.servingName,
                                controller: _servingLabel,
                                capitalize: true,
                              ),
                              _Field(
                                label: l10n.servingGrams,
                                controller: _serving,
                                unit: l10n.gram,
                                number: true,
                              ),
                            ],
                          ),
                          Positioned(
                            left: 0,
                            right: 0,
                            bottom: 0,
                            child: KalorieFooterAction(
                              note: preview,
                              child: FilledButton(
                                onPressed: _busy ? null : _save,
                                child: Text(
                                  editing ? l10n.save : l10n.saveProduct,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}

/// Label in kapitalen boven een veld, met de eenheid rechts in het veld.
class _Field extends StatelessWidget {
  const _Field({
    required this.label,
    required this.controller,
    this.hint,
    this.unit,
    this.number = false,
    this.required = false,
    this.capitalize = false,
    this.keyboard,
  });

  final String label;
  final TextEditingController controller;
  final String? hint;
  final String? unit;
  final bool number;
  final bool required;
  final bool capitalize;
  final TextInputType? keyboard;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          KalorieSectionLabel(label, padding: const EdgeInsets.only(bottom: 6)),
          TextFormField(
            controller: controller,
            textCapitalization: capitalize
                ? TextCapitalization.sentences
                : TextCapitalization.none,
            keyboardType: number
                ? const TextInputType.numberWithOptions(decimal: true)
                : keyboard,
            textInputAction: TextInputAction.done,
            onTapOutside: (_) =>
                FocusManager.instance.primaryFocus?.unfocus(),
            onFieldSubmitted: (_) =>
                FocusManager.instance.primaryFocus?.unfocus(),
            decoration: InputDecoration(hintText: hint, suffixText: unit),
            validator: (value) {
              final text = (value ?? '').trim();
              if (!required && text.isEmpty) return null;
              if (text.isEmpty) return '…';
              if (!number) return null;
              final n = num.tryParse(text.replaceAll(',', '.'));
              if (n == null || n < 0) return '…';
              return null;
            },
          ),
        ],
      ),
    );
  }
}
