import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/theme.dart';
import '../../core/constants.dart';
import '../../core/day_summary.dart';
import '../../core/l10n/generated/app_localizations.dart';
import '../../core/serving.dart';
import '../../core/widgets/empty_state.dart';
import '../../data/local/collections/enums.dart';
import '../../data/local/collections/food.dart';
import '../../data/providers.dart';
import '../scanner/scanner_screen.dart';
import 'add_food_screen.dart';

Future<void> showLogSheet(
  BuildContext context, {
  MealType? meal,
}) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    backgroundColor: Theme.of(context).scaffoldBackgroundColor,
    barrierColor: Colors.black.withValues(alpha: 0.28),
    sheetAnimationStyle: const AnimationStyle(
      duration: Duration(milliseconds: 280),
      curve: Curves.easeOut,
    ),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(KalorieSpace.radiusSheet),
      ),
    ),
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
  Food? _selected;
  late double _grams;
  bool _busy = false;
  late final TextEditingController _search;

  bool get _hasServing {
    final food = _selected;
    return food?.servingG != null &&
        food!.servingG! > 0 &&
        (food.servingLabel?.isNotEmpty ?? false);
  }

  MealType get _meal => widget.meal ?? mealForNow();

  @override
  void initState() {
    super.initState();
    _grams = 100;
    _search = TextEditingController();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      ref.read(foodSearchProvider.notifier).reset();
    });
  }

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  void _openPortion(Food food) {
    setState(() {
      _selected = food;
      _grams = ServingMath.defaultGrams(
        lastAmountG: food.lastAmountG,
        servingG: food.servingG,
      );
    });
  }

  void _backToList() {
    setState(() => _selected = null);
  }

  Future<void> _log(
    Food food,
    double grams, {
    required bool repeat,
  }) async {
    if (_busy || grams <= 0) return;
    setState(() => _busy = true);
    final l10n = AppLocalizations.of(context);
    final messenger = ScaffoldMessenger.of(context);
    final diary = ref.read(diaryRepositoryProvider);
    final dateKey = ref.read(selectedDateKeyProvider);
    final amount = ServingMath.describeShort(
      grams: grams,
      servingG: food.servingG,
      servingLabel: food.servingLabel,
    );
    try {
      final id = await diary.add(
            food: food,
            amountG: grams,
            meal: _meal,
            dateKey: dateKey,
          );
      if (repeat) {
        HapticFeedback.lightImpact();
      } else {
        HapticFeedback.mediumImpact();
      }
      if (!mounted) return;
      Navigator.of(context).pop();
      messenger.showSnackBar(
        SnackBar(
          duration: const Duration(seconds: 5),
          content: Text(l10n.loggedSnack(food.name, amount)),
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

  Future<void> _scan() async {
    final food = await Navigator.of(context, rootNavigator: true).push<Food>(
      MaterialPageRoute(
        builder: (_) => const ScannerScreen(popWithFood: true),
      ),
    );
    if (!mounted || food == null) return;
    _openPortion(food);
  }

  @override
  Widget build(BuildContext context) {
    ref.watch(foodSearchProvider);
    final bottomInset = MediaQuery.viewInsetsOf(context).bottom;
    return Padding(
      padding: EdgeInsets.only(bottom: bottomInset),
      child: DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.92,
        minChildSize: 0.55,
        maxChildSize: 0.96,
        builder: (context, scrollController) {
          return Column(
            children: [
              Expanded(
                child: _selected == null
                    ? _SearchStep(
                        scrollController: scrollController,
                        search: _search,
                        busy: _busy,
                        onScan: _scan,
                        onRepeat: (food) => _log(
                          food,
                          ServingMath.defaultGrams(
                            lastAmountG: food.lastAmountG,
                            servingG: food.servingG,
                          ),
                          repeat: true,
                        ),
                        onAdjust: _openPortion,
                        onSearchSelect: _openPortion,
                      )
                    : _PortionStep(
                        scrollController: scrollController,
                        food: _selected!,
                        grams: _grams,
                        hasServing: _hasServing,
                        busy: _busy,
                        onBack: _backToList,
                        onGrams: (g) => setState(() => _grams = g),
                        onLog: () => _log(_selected!, _grams, repeat: false),
                      ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _SearchStep extends ConsumerWidget {
  const _SearchStep({
    required this.scrollController,
    required this.search,
    required this.busy,
    required this.onScan,
    required this.onRepeat,
    required this.onAdjust,
    required this.onSearchSelect,
  });

  final ScrollController scrollController;
  final TextEditingController search;
  final bool busy;
  final VoidCallback onScan;
  final ValueChanged<Food> onRepeat;
  final ValueChanged<Food> onAdjust;
  final ValueChanged<Food> onSearchSelect;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final state = ref.watch(foodSearchProvider);
    final querying = state.query.trim().isNotEmpty;
    final items = [
      ...state.local,
      ...state.remote.where((r) => state.local.every((l) => l.id != r.id)),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 4, 12, 8),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: search,
                  textInputAction: TextInputAction.search,
                  decoration: InputDecoration(
                    hintText: l10n.searchHint,
                    prefixIcon: const Icon(Icons.search),
                  ),
                  onChanged: (v) =>
                      ref.read(foodSearchProvider.notifier).setQuery(v),
                ),
              ),
              IconButton(
                tooltip: l10n.scanBarcode,
                onPressed: onScan,
                icon: const Icon(Icons.qr_code_scanner),
              ),
            ],
          ),
        ),
        if (!querying)
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 0, 24, 8),
            child: Row(
              children: [
                _FilterChip(
                  label: l10n.recents,
                  selected: state.filter == FoodFilter.recents,
                  onTap: () => ref
                      .read(foodSearchProvider.notifier)
                      .setFilter(FoodFilter.recents),
                ),
                const SizedBox(width: 8),
                _FilterChip(
                  label: l10n.favorites,
                  selected: state.filter == FoodFilter.favorites,
                  onTap: () => ref
                      .read(foodSearchProvider.notifier)
                      .setFilter(FoodFilter.favorites),
                ),
              ],
            ),
          ),
        Expanded(
          child: ListView(
            controller: scrollController,
            padding: const EdgeInsets.fromLTRB(8, 0, 8, 24),
            children: [
              if (items.isEmpty)
                EmptyState(
                  title: l10n.noResults,
                  subtitle: l10n.noResultsHint,
                  action: TextButton(
                    onPressed: () => context.push('/add/custom'),
                    child: Text(l10n.newProduct),
                  ),
                )
              else
                ...items.map((food) {
                  final instant = !querying;
                  return _FoodRow(
                    food: food,
                    showAdjust: instant,
                    enabled: !busy,
                    onTap: () => instant
                        ? onRepeat(food)
                        : onSearchSelect(food),
                    onAdjust: () => onAdjust(food),
                  );
                }),
              if (state.query.trim().length >= 3) ...[
                const SizedBox(height: 8),
                if (state.onlineLoading)
                  const Padding(
                    padding: EdgeInsets.all(16),
                    child: Center(child: CircularProgressIndicator()),
                  )
                else
                  TextButton(
                    onPressed: () =>
                        ref.read(foodSearchProvider.notifier).searchOnline(),
                    child: Text(l10n.searchOnline),
                  ),
              ],
              if (state.error == 'offline')
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: Text(l10n.offline),
                ),
              if (state.error == 'rate')
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: Text(l10n.rateLimited),
                ),
              if (state.error == 'network')
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: Text(l10n.networkError),
                ),
              Align(
                alignment: Alignment.centerLeft,
                child: TextButton(
                  onPressed: () => context.push('/add/custom'),
                  child: Text(l10n.newProduct),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _FilterChip extends StatelessWidget {
  const _FilterChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ChoiceChip(
      label: Text(label),
      selected: selected,
      onSelected: (_) => onTap(),
      side: BorderSide(
        color: selected
            ? Colors.transparent
            : theme.colorScheme.outline,
      ),
    );
  }
}

class _FoodRow extends StatelessWidget {
  const _FoodRow({
    required this.food,
    required this.showAdjust,
    required this.enabled,
    required this.onTap,
    required this.onAdjust,
  });

  final Food food;
  final bool showAdjust;
  final bool enabled;
  final VoidCallback onTap;
  final VoidCallback onAdjust;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final amount = ServingMath.describeShort(
      grams: ServingMath.defaultGrams(
        lastAmountG: food.lastAmountG,
        servingG: food.servingG,
      ),
      servingG: food.servingG,
      servingLabel: food.servingLabel,
    );

    return SizedBox(
      height: 56,
      child: InkWell(
        onTap: enabled ? onTap : null,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      food.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.bodyMedium,
                    ),
                    Text(
                      amount,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
              if (showAdjust)
                IconButton(
                  tooltip: l10n.adjust,
                  visualDensity: VisualDensity.compact,
                  onPressed: enabled ? onAdjust : null,
                  icon: const Icon(Icons.more_horiz, size: 20),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PortionStep extends StatelessWidget {
  const _PortionStep({
    required this.scrollController,
    required this.food,
    required this.grams,
    required this.hasServing,
    required this.busy,
    required this.onBack,
    required this.onGrams,
    required this.onLog,
  });

  final ScrollController scrollController;
  final Food food;
  final double grams;
  final bool hasServing;
  final bool busy;
  final VoidCallback onBack;
  final ValueChanged<double> onGrams;
  final VoidCallback onLog;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final servingG = food.servingG;
    final kcal = NutrientMath.scale(food.kcal100g, grams);
    final chips = hasServing
        ? const [0.5, 1.0, 1.5, 2.0]
        : const [50.0, 100.0, 150.0];

    return ListView(
      controller: scrollController,
      padding: const EdgeInsets.fromLTRB(16, 0, 24, 24),
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: IconButton(
            onPressed: onBack,
            icon: const Icon(Icons.chevron_left),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 8),
          child: Text(food.name, style: theme.textTheme.titleMedium),
        ),
        if (hasServing && servingG != null) ...[
          const SizedBox(height: 4),
          Padding(
            padding: const EdgeInsets.only(left: 8),
            child: Text(
              '${food.servingLabel} = ${servingG.round()} g',
              style: theme.textTheme.bodySmall,
            ),
          ),
        ],
        const SizedBox(height: 20),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            if (hasServing && servingG != null)
              ...chips.map((p) {
                final selected =
                    (ServingMath.portionsFromGrams(grams, servingG) - p)
                            .abs() <
                        0.05;
                return ChoiceChip(
                  label: Text(
                    p == 0.5
                        ? '½'
                        : p == 1.5
                            ? '1½'
                            : ServingMath.formatCount(p),
                  ),
                  selected: selected,
                  onSelected: (_) =>
                      onGrams(ServingMath.gramsFromPortions(p, servingG)),
                );
              })
            else
              ...chips.map((g) {
                return ChoiceChip(
                  label: Text('${g.round()} g'),
                  selected: grams.round() == g.round(),
                  onSelected: (_) => onGrams(g),
                );
              }),
          ],
        ),
        const SizedBox(height: 28),
        FilledButton(
          onPressed: busy ? null : onLog,
          child: Text(l10n.logKcal(displayKcal(kcal))),
        ),
      ],
    );
  }
}
