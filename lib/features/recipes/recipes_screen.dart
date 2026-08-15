import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/theme.dart';
import '../../core/constants.dart';
import '../../core/day_summary.dart';
import '../../core/l10n/generated/app_localizations.dart';
import '../../core/widgets/kalorie_ui.dart';
import '../../core/widgets/panel.dart';
import '../../core/widgets/stroke_icon.dart';
import '../../data/local/collections/diary_entry.dart';
import '../../data/local/collections/enums.dart';
import '../../data/local/collections/recipe.dart';
import '../../data/providers.dart';

class RecipesScreen extends ConsumerStatefulWidget {
  const RecipesScreen({super.key, this.initialMeal});

  final String? initialMeal;

  @override
  ConsumerState<RecipesScreen> createState() => _RecipesScreenState();
}

class _RecipesScreenState extends ConsumerState<RecipesScreen> {
  bool _busy = false;

  MealType get _meal => widget.initialMeal == null
      ? mealForNow()
      : MealType.values.firstWhere(
          (m) => m.name == widget.initialMeal,
          orElse: mealForNow,
        );

  /// Boekt één portie van het recept als losse regel in de dag.
  Future<void> _logPortion(Recipe recipe) async {
    if (_busy) return;
    setState(() => _busy = true);
    final l10n = AppLocalizations.of(context);
    final messenger = ScaffoldMessenger.of(context);
    final diary = ref.read(diaryRepositoryProvider);
    final items = recipe.items;
    final divisor = recipe.portions <= 0 ? 1 : recipe.portions;

    double share(double Function(RecipeItem) pick) =>
        items.fold<double>(0, (sum, i) => sum + pick(i)) / divisor;

    double? shareOrNull(double? Function(RecipeItem) pick) {
      double? total;
      for (final item in items) {
        final value = pick(item);
        if (value == null) continue;
        total = (total ?? 0) + value;
      }
      return total == null ? null : total / divisor;
    }

    try {
      final entry = DiaryEntry()
        ..dateKey = ref.read(selectedDateKeyProvider)
        ..meal = _meal
        ..foodId = 0
        ..foodName = recipe.name
        ..brand = null
        ..source = FoodSource.custom
        ..amountG = recipe.gramsPerPortion
        ..servingLabel = '1 portie (${recipe.gramsPerPortion.round()} g)'
        ..kcal = share((i) => i.kcal)
        ..protein = share((i) => i.protein)
        ..carbs = share((i) => i.carbs)
        ..fat = share((i) => i.fat)
        ..fiber = shareOrNull((i) => i.fiber)
        ..sugars = shareOrNull((i) => i.sugars)
        ..satFat = shareOrNull((i) => i.satFat)
        ..salt = shareOrNull((i) => i.salt);
      final id = await diary.addRaw(entry);
      await HapticFeedback.mediumImpact();
      if (!mounted) return;
      messenger
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            duration: const Duration(seconds: 5),
            content: Text(l10n.loggedSnack(recipe.name, '1 portie')),
            action: SnackBarAction(
              label: l10n.undo,
              onPressed: () => diary.delete(id),
            ),
          ),
        );
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final tones = context.tones;
    final recipes = ref.watch(recipesProvider).value ?? const <Recipe>[];

    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            KalorieOverlayHeader(
              title: l10n.recipes,
              onBack: () => context.pop(),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(16, 6, 16, 40),
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(4, 0, 4, 14),
                    child: Text(
                      l10n.recipesIntro,
                      style: theme.textTheme.bodySmall?.copyWith(height: 1.5),
                    ),
                  ),
                  if (recipes.isNotEmpty)
                    KaloriePanel(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          for (var i = 0; i < recipes.length; i++) ...[
                            if (i != 0) const KalorieHairline(),
                            _RecipeRow(
                              recipe: recipes[i],
                              enabled: !_busy,
                              onOpen: () =>
                                  context.push('/recipes/${recipes[i].id}'),
                              onLog: () => _logPortion(recipes[i]),
                            ),
                          ],
                        ],
                      ),
                    )
                  else
                    Padding(
                      padding: const EdgeInsets.fromLTRB(4, 20, 4, 8),
                      child: Text(
                        l10n.recipeListEmpty,
                        style: theme.textTheme.bodySmall
                            ?.copyWith(color: tones.hint),
                      ),
                    ),
                  const SizedBox(height: 14),
                  SizedBox(
                    height: KalorieSpace.buttonHeight,
                    child: OutlinedButton.icon(
                      onPressed: () => context.push('/recipes/new'),
                      style: OutlinedButton.styleFrom(
                        backgroundColor: theme.colorScheme.surface,
                        foregroundColor: theme.colorScheme.primary,
                      ),
                      icon: StrokeIcon(
                        StrokeShape.plus,
                        size: 14,
                        color: theme.colorScheme.primary,
                      ),
                      label: Text(l10n.newRecipe),
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

class _RecipeRow extends StatelessWidget {
  const _RecipeRow({
    required this.recipe,
    required this.enabled,
    required this.onOpen,
    required this.onLog,
  });

  final Recipe recipe;
  final bool enabled;
  final VoidCallback onOpen;
  final VoidCallback onLog;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final tones = context.tones;

    return ConstrainedBox(
      constraints: const BoxConstraints(minHeight: 68),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 10, 12, 10),
        child: Row(
          children: [
            Expanded(
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: enabled ? onOpen : null,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      recipe.name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.bodyMedium,
                    ),
                    Text(
                      l10n.recipePerPortion(
                        displayKcal(recipe.kcalPerPortion),
                        recipe.gramsPerPortion.round(),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style:
                          theme.textTheme.bodySmall?.copyWith(color: tones.hint),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 12),
            Text(
              '${displayKcal(recipe.kcalPerPortion)}',
              style: theme.textTheme.titleMedium,
            ),
            const SizedBox(width: 12),
            KalorieQuickAdd(
              onTap: onLog,
              enabled: enabled,
              tooltip: l10n.addToMeal(recipe.name),
            ),
          ],
        ),
      ),
    );
  }
}
