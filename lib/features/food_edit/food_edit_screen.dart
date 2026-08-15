import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants.dart';
import '../../core/l10n/generated/app_localizations.dart';
import '../../core/serving.dart';
import '../../data/local/collections/enums.dart';
import '../../data/local/collections/food.dart';
import '../../data/providers.dart';

class FoodEditScreen extends ConsumerStatefulWidget {
  const FoodEditScreen({super.key, this.foodId, this.barcode});

  final int? foodId;
  final String? barcode;

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
  final _fat = TextEditingController();
  final _serving = TextEditingController();
  final _servingLabel = TextEditingController();
  Food? _existing;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _barcode.text = widget.barcode ?? '';
    _servingLabel.text = '1 portie';
    _load();
  }

  Future<void> _load() async {
    if (widget.foodId != null) {
      final food = await ref.read(foodRepositoryProvider).getById(widget.foodId!);
      if (food != null) {
        _existing = food;
        _name.text = food.name;
        _brand.text = food.brand ?? '';
        _barcode.text = food.barcode ?? '';
        _kcal.text = _n(food.kcal100g);
        _protein.text = _n(food.protein100g);
        _carbs.text = _n(food.carbs100g);
        _fat.text = _n(food.fat100g);
        _serving.text = food.servingG == null ? '' : _n(food.servingG!);
        _servingLabel.text = food.servingLabel ?? '1 portie';
      }
    }
    if (mounted) setState(() => _loading = false);
  }

  String _n(double v) =>
      v == v.roundToDouble() ? '${v.round()}' : v.toString();

  double _parse(String raw) => double.parse(raw.trim().replaceAll(',', '.'));

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    final food = _existing ??
        (Food()
          ..source = FoodSource.custom
          ..isFavorite = false
          ..userOverridden = false);
    if (_existing != null) {
      food.userOverridden = true;
    }
    final servingRaw = _serving.text.trim();
    food
      ..name = _name.text.trim()
      ..nameNormalized = normalizeName(_name.text)
      ..brand = _brand.text.trim().isEmpty ? null : _brand.text.trim()
      ..barcode = _barcode.text.trim().isEmpty ? null : _barcode.text.trim()
      ..kcal100g = _parse(_kcal.text)
      ..protein100g = _parse(_protein.text)
      ..carbs100g = _parse(_carbs.text)
      ..fat100g = _parse(_fat.text)
      ..servingG = servingRaw.isEmpty ? null : _parse(servingRaw)
      ..servingLabel = servingRaw.isEmpty
          ? null
          : (_servingLabel.text.trim().isEmpty
              ? '1 portie'
              : _servingLabel.text.trim());

    final id = await ref.read(foodRepositoryProvider).upsert(food);
    if (!mounted) return;
    HapticFeedback.lightImpact();
    if (_existing == null) {
      context.pushReplacement('/add/amount/$id');
    } else {
      context.pop();
    }
  }

  @override
  void dispose() {
    _name.dispose();
    _brand.dispose();
    _barcode.dispose();
    _kcal.dispose();
    _protein.dispose();
    _carbs.dispose();
    _fat.dispose();
    _serving.dispose();
    _servingLabel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(_existing == null ? l10n.customFood : l10n.fixFood),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : Form(
              key: _formKey,
              child: ListView(
                padding: const EdgeInsets.fromLTRB(24, 8, 24, 32),
                children: [
                  if (_existing != null) ...[
                    Text(l10n.fixFoodHint, style: theme.textTheme.bodyMedium),
                    const SizedBox(height: 8),
                    Text(l10n.editDoesNotRewrite, style: theme.textTheme.bodySmall),
                    const SizedBox(height: 20),
                  ],
                  TextFormField(
                    controller: _name,
                    textCapitalization: TextCapitalization.sentences,
                    decoration: InputDecoration(
                      labelText: l10n.name,
                      hintText: l10n.foodNameHint,
                    ),
                    validator: (v) =>
                        (v == null || v.trim().isEmpty) ? '…' : null,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _brand,
                    decoration: InputDecoration(labelText: l10n.brand),
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _barcode,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(labelText: l10n.barcode),
                  ),
                  const SizedBox(height: 28),
                  Text(l10n.serving, style: theme.textTheme.labelSmall),
                  const SizedBox(height: 8),
                  Text(l10n.servingSheetHint, style: theme.textTheme.bodySmall),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: servingPresets.map((preset) {
                      return ActionChip(
                        label: Text(preset.label),
                        onPressed: () {
                          _servingLabel.text = preset.label;
                          _serving.text = '${preset.grams.round()}';
                          setState(() {});
                        },
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _servingLabel,
                    textCapitalization: TextCapitalization.sentences,
                    decoration: InputDecoration(labelText: l10n.servingName),
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _serving,
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    decoration: InputDecoration(
                      labelText: l10n.servingGrams,
                      suffixText: l10n.gram,
                    ),
                  ),
                  const SizedBox(height: 28),
                  Text(l10n.per100g, style: theme.textTheme.labelSmall),
                  const SizedBox(height: 8),
                  Text(l10n.per100gHint, style: theme.textTheme.bodySmall),
                  const SizedBox(height: 12),
                  _NumField(controller: _kcal, label: l10n.kcal),
                  const SizedBox(height: 12),
                  _NumField(controller: _protein, label: l10n.protein),
                  const SizedBox(height: 12),
                  _NumField(controller: _carbs, label: l10n.carbs),
                  const SizedBox(height: 12),
                  _NumField(controller: _fat, label: l10n.fat),
                  const SizedBox(height: 32),
                  FilledButton(
                    onPressed: _save,
                    child: Text(l10n.saveProduct),
                  ),
                ],
              ),
            ),
    );
  }
}

class _NumField extends StatelessWidget {
  const _NumField({required this.controller, required this.label});

  final TextEditingController controller;
  final String label;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      decoration: InputDecoration(labelText: label),
      validator: (v) {
        final n = num.tryParse((v ?? '').replaceAll(',', '.'));
        if (n == null || n < 0) return '…';
        return null;
      },
    );
  }
}
