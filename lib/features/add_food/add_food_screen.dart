import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../app/theme.dart';
import '../../core/constants.dart';
import '../../core/day_summary.dart';
import '../../core/food_search_rank.dart';
import '../../core/l10n/generated/app_localizations.dart';
import '../../core/widgets/kalorie_ui.dart';
import '../../core/widgets/panel.dart';
import '../../core/widgets/stroke_icon.dart';
import '../../data/local/collections/enums.dart';
import '../../data/local/collections/food.dart';
import '../../data/providers.dart';
import '../../data/remote/off_mapper.dart';
import '../../data/remote/rate_limiter.dart';
import 'quick_log.dart';

part 'add_food_screen.g.dart';

enum FoodFilter { recents, favorites, all }

class FoodSearchState {
  const FoodSearchState({
    this.query = '',
    this.filter = FoodFilter.recents,
    this.local = const [],
    this.remote = const [],
    this.onlineLoading = false,
    this.error,
  });

  final String query;
  final FoodFilter filter;
  final List<Food> local;
  final List<Food> remote;
  final bool onlineLoading;
  final String? error;

  FoodSearchState copyWith({
    String? query,
    FoodFilter? filter,
    List<Food>? local,
    List<Food>? remote,
    bool? onlineLoading,
    String? error,
    bool clearError = false,
  }) {
    return FoodSearchState(
      query: query ?? this.query,
      filter: filter ?? this.filter,
      local: local ?? this.local,
      remote: remote ?? this.remote,
      onlineLoading: onlineLoading ?? this.onlineLoading,
      error: clearError ? null : (error ?? this.error),
    );
  }

  /// Eén lijst: recente/NEVO eerst, daarna extra hits uit de catalogus en OFF.
  List<Food> get results {
    if (query.trim().isEmpty) return local;
    final merged = <Food>[...local];
    for (final food in remote) {
      if (merged.any((existing) => _sameFood(existing, food))) continue;
      merged.add(food);
    }
    merged.sort((a, b) => compareFoodSearch(a, b, query));
    return merged;
  }
}

bool _sameFood(Food a, Food b) {
  if (a.id != 0 && a.id == b.id) return true;
  if (a.barcode != null &&
      a.barcode!.isNotEmpty &&
      a.barcode == b.barcode) {
    return true;
  }
  if (a.catalogId != null &&
      a.catalogId!.isNotEmpty &&
      a.catalogId == b.catalogId) {
    return true;
  }
  if (a.offId != null && a.offId!.isNotEmpty && a.offId == b.offId) {
    return true;
  }
  return a.nameNormalized == b.nameNormalized &&
      (a.brand ?? '') == (b.brand ?? '');
}

@riverpod
class FoodSearch extends _$FoodSearch {
  Timer? _debounce;
  Timer? _remoteDebounce;
  int _remoteToken = 0;

  @override
  FoodSearchState build() {
    ref.onDispose(() {
      _debounce?.cancel();
      _remoteDebounce?.cancel();
    });
    Future.microtask(reload);
    return const FoodSearchState();
  }

  Future<void> reload() async {
    final repo = ref.read(foodRepositoryProvider);
    final q = state.query.trim();
    late final List<Food> local;
    if (q.isNotEmpty) {
      local = await repo.searchLocal(q);
    } else if (state.filter == FoodFilter.favorites) {
      local = await repo.favorites();
    } else {
      final recent = await repo.recents();
      local = recent.isEmpty ? await repo.browse() : recent;
    }
    state = state.copyWith(local: local, clearError: true);
  }

  void setFilter(FoodFilter filter) {
    _remoteDebounce?.cancel();
    state = state.copyWith(filter: filter, remote: const []);
    reload();
  }

  void setQuery(String query) {
    state = state.copyWith(query: query, remote: const [], clearError: true);
    _debounce?.cancel();
    _remoteDebounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 100), reload);
    if (query.trim().length >= 2) {
      _remoteDebounce =
          Timer(const Duration(milliseconds: 450), _enrichFromNetwork);
    }
  }

  void reset() {
    _debounce?.cancel();
    _remoteDebounce?.cancel();
    _remoteToken++;
    state = const FoodSearchState();
    reload();
  }

  Future<void> _enrichFromNetwork() async {
    final q = state.query.trim();
    if (q.length < 2) return;
    final connectivity = await Connectivity().checkConnectivity();
    if (connectivity.contains(ConnectivityResult.none) ||
        connectivity.isEmpty) {
      return;
    }
    final token = ++_remoteToken;
    state = state.copyWith(onlineLoading: true, clearError: true);
    try {
      final catalogHits =
          await ref.read(catalogRepositoryProvider).searchRemote(q);
      final extra = <Food>[...catalogHits];
      try {
        final products = await ref.read(offRemoteProvider).search(q);
        for (final product in products) {
          final food = mapOffProduct(product);
          if (food == null) continue;
          extra.add(
            await ref.read(foodRepositoryProvider).cacheOffProduct(food),
          );
        }
      } on RateLimitedException {
        // Catalogushits blijven staan.
      }
      if (token != _remoteToken || state.query.trim() != q) return;
      state = state.copyWith(remote: extra, onlineLoading: false);
    } on RateLimitedException {
      if (token != _remoteToken) return;
      state = state.copyWith(onlineLoading: false, error: 'rate');
    } catch (_) {
      if (token != _remoteToken) return;
      state = state.copyWith(onlineLoading: false);
    }
  }
}

class AddFoodScreen extends ConsumerStatefulWidget {
  const AddFoodScreen({super.key, this.initialMeal});

  final String? initialMeal;

  @override
  ConsumerState<AddFoodScreen> createState() => _AddFoodScreenState();
}

class _AddFoodScreenState extends ConsumerState<AddFoodScreen> {
  late final TextEditingController _query;
  bool _busy = false;

  MealType get _meal => widget.initialMeal == null
      ? mealForNow()
      : MealType.values.firstWhere(
          (m) => m.name == widget.initialMeal,
          orElse: mealForNow,
        );

  String get _mealQuery => '?meal=${_meal.name}';

  @override
  void initState() {
    super.initState();
    _query = TextEditingController();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) ref.read(foodSearchProvider.notifier).reset();
    });
  }

  @override
  void dispose() {
    _query.dispose();
    super.dispose();
  }

  Future<void> _quickAdd(Food food) async {
    if (_busy) return;
    setState(() => _busy = true);
    try {
      await quickLogFood(context, ref, food: food, meal: _meal);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final search = ref.watch(foodSearchProvider);
    final querying = search.query.trim().isNotEmpty;
    final items = search.results;

    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            KalorieOverlayHeader(
              title: l10n.add,
              onBack: () => context.pop(),
              action: KalorieTapTarget(
                tooltip: l10n.scanBarcode,
                onTap: () => context.push('/add/scan$_mealQuery'),
                child: StrokeIcon(
                  StrokeShape.barcode,
                  size: 16,
                  color: theme.colorScheme.primary,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 10),
              child: TextField(
                controller: _query,
                autofocus: true,
                textInputAction: TextInputAction.search,
                onTapOutside: (_) =>
                    FocusManager.instance.primaryFocus?.unfocus(),
                decoration: InputDecoration(hintText: l10n.searchHint),
                onChanged: (v) =>
                    ref.read(foodSearchProvider.notifier).setQuery(v),
              ),
            ),
            if (search.onlineLoading)
              const Padding(
                padding: EdgeInsets.fromLTRB(20, 0, 20, 8),
                child: LinearProgressIndicator(minHeight: 2),
              ),
            if (!querying)
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 10),
                child: Row(
                  children: [
                    KaloriePill(
                      label: l10n.recents,
                      selected: search.filter == FoodFilter.recents,
                      onTap: () => ref
                          .read(foodSearchProvider.notifier)
                          .setFilter(FoodFilter.recents),
                    ),
                    const SizedBox(width: 8),
                    KaloriePill(
                      label: l10n.favorites,
                      selected: search.filter == FoodFilter.favorites,
                      onTap: () => ref
                          .read(foodSearchProvider.notifier)
                          .setFilter(FoodFilter.favorites),
                    ),
                  ],
                ),
              ),
            Expanded(
              child: ListView(
                keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 32),
                children: [
                  if (items.isEmpty)
                    Padding(
                      padding: const EdgeInsets.fromLTRB(8, 34, 8, 12),
                      child: Column(
                        children: [
                          Text(
                            l10n.nothingFound,
                            style: theme.textTheme.titleSmall,
                          ),
                          const SizedBox(height: 6),
                          Text(
                            l10n.nothingFoundHint,
                            textAlign: TextAlign.center,
                            style: theme.textTheme.bodySmall
                                ?.copyWith(color: context.tones.hint),
                          ),
                        ],
                      ),
                    )
                  else
                    KaloriePanel(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          for (var i = 0; i < items.length; i++) ...[
                            if (i != 0) const KalorieHairline(),
                            _ResultRow(
                              food: items[i],
                              enabled: !_busy,
                              onOpen: () => context
                                  .push('/add/amount/${items[i].id}$_mealQuery'),
                              onQuickAdd: () => _quickAdd(items[i]),
                              onFavorite: () async {
                                await ref
                                    .read(foodRepositoryProvider)
                                    .toggleFavorite(items[i].id);
                                await ref
                                    .read(foodSearchProvider.notifier)
                                    .reload();
                              },
                            ),
                          ],
                        ],
                      ),
                    ),
                  if (search.error == 'rate')
                    Padding(
                      padding: const EdgeInsets.fromLTRB(4, 12, 4, 0),
                      child: Text(
                        l10n.rateLimited,
                        style: theme.textTheme.bodySmall,
                      ),
                    ),
                  const SizedBox(height: 4),
                  TextButton(
                    onPressed: () => context.push('/add/custom$_mealQuery'),
                    child: Text(l10n.createNewProduct),
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

class _ResultRow extends StatelessWidget {
  const _ResultRow({
    required this.food,
    required this.enabled,
    required this.onOpen,
    required this.onQuickAdd,
    required this.onFavorite,
  });

  final Food food;
  final bool enabled;
  final VoidCallback onOpen;
  final VoidCallback onQuickAdd;
  final VoidCallback onFavorite;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final tones = context.tones;
    final brand = food.brand;
    final per100 = '${displayKcal(food.kcal100g)} kcal / 100 g';
    final subtitle =
        brand != null && brand.isNotEmpty ? '$brand · $per100' : per100;

    return ConstrainedBox(
      constraints: const BoxConstraints(minHeight: 62),
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
            KalorieTapTarget(
              size: 36,
              tooltip: l10n.favorite,
              onTap: onFavorite,
              child: _FavoriteDiamond(on: food.isFavorite),
            ),
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

/// Ruitje in plaats van een ster: past bij de rustige vormentaal.
class _FavoriteDiamond extends StatelessWidget {
  const _FavoriteDiamond({required this.on});

  final bool on;

  @override
  Widget build(BuildContext context) {
    final color = context.tones.sageSoft;
    return Transform.rotate(
      angle: 0.7853981633974483,
      child: Container(
        width: 11,
        height: 11,
        decoration: BoxDecoration(
          color: on ? color : Colors.transparent,
          borderRadius: BorderRadius.circular(2),
          border: Border.all(color: color, width: 1.4),
        ),
      ),
    );
  }
}
