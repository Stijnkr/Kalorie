import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/theme.dart';
import '../../core/day_summary.dart';
import '../../core/l10n/generated/app_localizations.dart';
import '../../core/widgets/kalorie_ui.dart';
import '../../core/widgets/panel.dart';
import '../../core/widgets/stroke_icon.dart';
import '../../data/local/collections/food.dart';
import '../../data/local/collections/recipe.dart';
import '../../data/providers.dart';

class RecipeEditScreen extends ConsumerStatefulWidget {
  const RecipeEditScreen({super.key, this.recipeId});

  final int? recipeId;

  @override
  ConsumerState<RecipeEditScreen> createState() => _RecipeEditScreenState();
}

class _RecipeEditScreenState extends ConsumerState<RecipeEditScreen> {
  final _name = TextEditingController();
  final _search = TextEditingController();

  Recipe? _recipe;
  List<RecipeItem> _items = [];
  int _portions = 1;
  bool _loaded = false;
  bool _busy = false;
  List<Food> _picker = const [];

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    _name.dispose();
    _search.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    final repo = ref.read(recipeRepositoryProvider);
    final recipe = widget.recipeId == null
        ? repo.draft()
        : await repo.getById(widget.recipeId!) ?? repo.draft();
    final picker = await ref.read(foodRepositoryProvider).recents(limit: 8);
    if (!mounted) return;
    setState(() {
      _recipe = recipe;
      _name.text = recipe.name;
      _portions = recipe.portions;
      _items = List.of(recipe.items);
      _picker = picker.isEmpty ? const [] : picker;
      _loaded = true;
    });
  }

  Future<void> _searchFoods(String query) async {
    final repo = ref.read(foodRepositoryProvider);
    final results = query.trim().isEmpty
        ? await repo.recents(limit: 8)
        : await repo.searchLocal(query, limit: 12);
    if (mounted) setState(() => _picker = results);
  }

  void _addFood(Food food) {
    HapticFeedback.selectionClick();
    setState(() {
      _items = [
        ..._items,
        RecipeItem(
          foodId: food.id,
          name: food.name,
          grams: food.servingG ?? 100,
          kcal100g: food.kcal100g,
          protein100g: food.protein100g,
          carbs100g: food.carbs100g,
          fat100g: food.fat100g,
          fiber100g: food.fiber100g,
          sugars100g: food.sugars100g,
          satFat100g: food.satFat100g,
          salt100g: food.salt100g,
        ),
      ];
    });
  }

  void _nudge(int index, double delta) {
    HapticFeedback.selectionClick();
    setState(() {
      final next = (_items[index].grams + delta).clamp(5.0, 5000.0);
      _items = [
        for (var i = 0; i < _items.length; i++)
          i == index ? _items[i].copyWith(grams: next) : _items[i],
      ];
    });
  }

  void _remove(int index) {
    setState(() {
      _items = [
        for (var i = 0; i < _items.length; i++)
          if (i != index) _items[i],
      ];
    });
  }

  Future<void> _save() async {
    final recipe = _recipe;
    if (_busy ||
        recipe == null ||
        _name.text.trim().isEmpty ||
        _items.isEmpty) {
      return;
    }
    setState(() => _busy = true);
    try {
      recipe
        ..name = _name.text.trim()
        ..portions = _portions
        ..items = _items;
      await ref.read(recipeRepositoryProvider).save(recipe);
      if (!mounted) return;
      HapticFeedback.mediumImpact();
      context.pop();
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _delete() async {
    final recipe = _recipe;
    if (_busy || recipe == null || widget.recipeId == null) return;
    final l10n = AppLocalizations.of(context);
    final ok = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.deleteRecipe),
        content: Text(l10n.deleteRecipeConfirm),
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
      await ref.read(recipeRepositoryProvider).delete(recipe.id);
      if (mounted) context.pop();
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  double get _totalKcal =>
      _items.fold<double>(0, (sum, i) => sum + i.kcal);

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final tones = context.tones;

    if (!_loaded) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final canSave = _name.text.trim().isNotEmpty && _items.isNotEmpty;
    final perPortion = _portions <= 0 ? _totalKcal : _totalKcal / _portions;

    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            KalorieOverlayHeader(
              title: widget.recipeId == null ? l10n.newRecipe : l10n.editRecipe,
              onBack: () => context.pop(),
              action: widget.recipeId == null
                  ? null
                  : KalorieTapTarget(
                      tooltip: l10n.deleteRecipe,
                      enabled: !_busy,
                      onTap: _delete,
                      child: StrokeIcon(
                        StrokeShape.trash,
                        size: 14,
                        color: tones.danger,
                      ),
                    ),
            ),
            Expanded(
              child: Stack(
                children: [
                  ListView(
                    keyboardDismissBehavior:
                        ScrollViewKeyboardDismissBehavior.onDrag,
                    padding: const EdgeInsets.fromLTRB(20, 6, 20, 150),
                    children: [
                      KalorieSectionLabel(
                        l10n.recipeName,
                        padding: const EdgeInsets.only(bottom: 6),
                      ),
                      TextField(
                        controller: _name,
                        textCapitalization: TextCapitalization.sentences,
                        textInputAction: TextInputAction.done,
                        onTapOutside: (_) =>
                            FocusManager.instance.primaryFocus?.unfocus(),
                        decoration:
                            InputDecoration(hintText: l10n.recipeNameHint),
                        onChanged: (_) => setState(() {}),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  l10n.recipePortions,
                                  style: theme.textTheme.bodyMedium,
                                ),
                                Text(
                                  l10n.recipePortionsSub,
                                  style: theme.textTheme.bodySmall
                                      ?.copyWith(color: tones.hint),
                                ),
                              ],
                            ),
                          ),
                          KalorieStepButton(
                            plus: false,
                            size: 44,
                            radius: 12,
                            enabled: _portions > 1,
                            onTap: () => setState(() => _portions -= 1),
                          ),
                          SizedBox(
                            width: 44,
                            child: Text(
                              '$_portions',
                              textAlign: TextAlign.center,
                              style: theme.textTheme.headlineSmall,
                            ),
                          ),
                          KalorieStepButton(
                            plus: true,
                            size: 44,
                            radius: 12,
                            enabled: _portions < 99,
                            onTap: () => setState(() => _portions += 1),
                          ),
                        ],
                      ),
                      const SizedBox(height: 22),
                      KalorieSectionLabel(l10n.ingredients),
                      KaloriePanel(
                        child: _items.isEmpty
                            ? Padding(
                                padding: const EdgeInsets.fromLTRB(16, 22, 16, 22),
                                child: Text(
                                  l10n.recipeEmpty,
                                  style: theme.textTheme.bodySmall
                                      ?.copyWith(color: tones.hint, height: 1.5),
                                ),
                              )
                            : Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  for (var i = 0; i < _items.length; i++) ...[
                                    if (i != 0) const KalorieHairline(),
                                    _ItemRow(
                                      item: _items[i],
                                      onMinus: () => _nudge(i, -10),
                                      onPlus: () => _nudge(i, 10),
                                      onDelete: () => _remove(i),
                                    ),
                                  ],
                                ],
                              ),
                      ),
                      const SizedBox(height: 22),
                      KalorieSectionLabel(l10n.addIngredient),
                      TextField(
                        controller: _search,
                        textInputAction: TextInputAction.search,
                        onTapOutside: (_) =>
                            FocusManager.instance.primaryFocus?.unfocus(),
                        decoration: InputDecoration(hintText: l10n.searchHint),
                        onChanged: _searchFoods,
                      ),
                      const SizedBox(height: 10),
                      if (_picker.isNotEmpty)
                        KaloriePanel(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              for (var i = 0; i < _picker.length; i++) ...[
                                if (i != 0) const KalorieHairline(),
                                InkWell(
                                  onTap: () => _addFood(_picker[i]),
                                  child: ConstrainedBox(
                                    constraints:
                                        const BoxConstraints(minHeight: 54),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 16,
                                        vertical: 12,
                                      ),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: Text(
                                              _picker[i].name,
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: theme.textTheme.bodyMedium,
                                            ),
                                          ),
                                          const SizedBox(width: 12),
                                          Text(
                                            '${displayKcal(_picker[i].kcal100g)} ${l10n.kcal}',
                                            style: theme.textTheme.bodySmall
                                                ?.copyWith(color: tones.hint),
                                          ),
                                          const SizedBox(width: 12),
                                          StrokeIcon(
                                            StrokeShape.plus,
                                            size: 13,
                                            color: theme.colorScheme.primary,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                    ],
                  ),
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: 0,
                    child: KalorieFooterAction(
                      note: l10n.recipeTotal(
                        displayKcal(_totalKcal),
                        displayKcal(perPortion),
                      ),
                      child: FilledButton(
                        onPressed: canSave && !_busy ? _save : null,
                        child: Text(l10n.saveRecipe),
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

class _ItemRow extends StatelessWidget {
  const _ItemRow({
    required this.item,
    required this.onMinus,
    required this.onPlus,
    required this.onDelete,
  });

  final RecipeItem item;
  final VoidCallback onMinus;
  final VoidCallback onPlus;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final tones = context.tones;

    return ConstrainedBox(
      constraints: const BoxConstraints(minHeight: 60),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 10, 10, 10),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    item.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodyMedium,
                  ),
                  Text(
                    '${displayKcal(item.kcal)} ${l10n.kcal}',
                    style:
                        theme.textTheme.bodySmall?.copyWith(color: tones.hint),
                  ),
                ],
              ),
            ),
            KalorieStepButton(
              plus: false,
              size: 36,
              radius: 10,
              filled: false,
              onTap: onMinus,
            ),
            SizedBox(
              width: 56,
              child: Text(
                '${item.grams.round()} g',
                textAlign: TextAlign.center,
                style: theme.textTheme.titleSmall,
              ),
            ),
            KalorieStepButton(
              plus: true,
              size: 36,
              radius: 10,
              filled: false,
              onTap: onPlus,
            ),
            KalorieTapTarget(
              size: 30,
              onTap: onDelete,
              child: StrokeIcon(
                StrokeShape.close,
                size: 11,
                color: tones.faint,
                strokeWidth: 1.6,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
