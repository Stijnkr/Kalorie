import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/theme.dart';
import '../../core/constants.dart';
import '../../core/day_summary.dart';
import '../../core/l10n/generated/app_localizations.dart';
import '../../core/serving.dart';
import '../../core/widgets/kalorie_ui.dart';
import '../../core/widgets/panel.dart';
import '../../core/widgets/stroke_icon.dart';
import '../../data/local/collections/enums.dart';
import '../../data/local/collections/food.dart';
import '../../data/providers.dart';
import '../today/today_screen.dart' show mealLabel;
import 'quick_log.dart';

/// Het logvel: recente producten met de laatst gebruikte portie, plus de
/// langere routes (zoeken, scannen, zelf aanmaken) eronder.
Future<void> showLogSheet(BuildContext context, {MealType? meal}) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    showDragHandle: true,
    builder: (context) => LogSheet(meal: meal),
  );
}

class LogSheet extends ConsumerStatefulWidget {
  const LogSheet({super.key, this.meal});

  final MealType? meal;

  @override
  ConsumerState<LogSheet> createState() => _LogSheetState();
}

class _LogSheetState extends ConsumerState<LogSheet> {
  bool _busy = false;

  MealType get _meal => widget.meal ?? mealForNow();

  String get _mealQuery => '?meal=${_meal.name}';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) ref.invalidate(quickLogFoodsProvider);
    });
  }

  Future<void> _quickAdd(Food food) async {
    if (_busy) return;
    setState(() => _busy = true);
    final navigator = Navigator.of(context);
    try {
      await quickLogFood(context, ref, food: food, meal: _meal);
      if (mounted) navigator.pop();
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  void _go(String location) {
    Navigator.of(context).pop();
    context.push(location);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final foods = ref.watch(quickLogFoodsProvider).value ?? const <Food>[];

    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.72,
      minChildSize: 0.45,
      maxChildSize: 0.92,
      builder: (context, scrollController) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 6, 20, 12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  Expanded(
                    child: Text(
                      l10n.logInMeal(mealLabel(l10n, _meal).toLowerCase()),
                      style: theme.textTheme.titleMedium,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(l10n.quickAddHint, style: theme.textTheme.bodySmall),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                controller: scrollController,
                padding: EdgeInsets.fromLTRB(
                  16,
                  0,
                  16,
                  26 + MediaQuery.paddingOf(context).bottom,
                ),
                children: [
                  if (foods.isNotEmpty)
                    KaloriePanel(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          for (var i = 0; i < foods.length; i++) ...[
                            if (i != 0) const KalorieHairline(),
                            _QuickRow(
                              food: foods[i],
                              enabled: !_busy,
                              onQuickAdd: () => _quickAdd(foods[i]),
                              onOpen: () => _go(
                                '/add/amount/${foods[i].id}$_mealQuery',
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  const SizedBox(height: 12),
                  KaloriePanelList(
                    children: [
                      _ActionRow(
                        label: l10n.searchDatabase,
                        onTap: () => _go('/add$_mealQuery'),
                      ),
                      _ActionRow(
                        label: l10n.recipes,
                        onTap: () => _go('/recipes$_mealQuery'),
                      ),
                      _ActionRow(
                        label: l10n.scanBarcode,
                        onTap: () => _go('/add/scan$_mealQuery'),
                      ),
                      _ActionRow(
                        label: l10n.createNewProduct,
                        onTap: () => _go('/add/custom$_mealQuery'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}

class _QuickRow extends StatelessWidget {
  const _QuickRow({
    required this.food,
    required this.enabled,
    required this.onQuickAdd,
    required this.onOpen,
  });

  final Food food;
  final bool enabled;
  final VoidCallback onQuickAdd;
  final VoidCallback onOpen;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final tones = context.tones;
    final liquid = ServingMath.looksLiquid(
      name: food.name,
      servingLabel: food.servingLabel,
    );
    final grams = ServingMath.defaultGrams(
      lastAmountG: food.lastAmountG,
      servingG: food.servingG,
      liquid: liquid,
      name: food.name,
      servingLabel: food.servingLabel,
    );
    final amount = ServingMath.describeShort(
      grams: grams,
      servingG: food.servingG,
      servingLabel: food.servingLabel,
      name: food.name,
      liquid: liquid,
    );
    final brand = food.brand;
    final subtitle =
        brand != null && brand.isNotEmpty ? '$brand · $amount' : amount;

    return ConstrainedBox(
      constraints: const BoxConstraints(minHeight: 60),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 12, 8),
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
                      food.name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.bodyMedium,
                    ),
                    Text(
                      subtitle,
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
              '${displayKcal(NutrientMath.scale(food.kcal100g, grams))}',
              style: theme.textTheme.titleMedium,
            ),
            const SizedBox(width: 12),
            KalorieQuickAdd(
              onTap: onQuickAdd,
              enabled: enabled,
              tooltip: l10n.addToMeal(food.name),
            ),
          ],
        ),
      ),
    );
  }
}

class _ActionRow extends StatelessWidget {
  const _ActionRow({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: onTap,
      child: ConstrainedBox(
        constraints: const BoxConstraints(minHeight: 56),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  label,
                  style: theme.textTheme.titleSmall
                      ?.copyWith(color: theme.colorScheme.primary),
                ),
              ),
              StrokeIcon(
                StrokeShape.chevronRight,
                size: 14,
                color: context.tones.faint,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
