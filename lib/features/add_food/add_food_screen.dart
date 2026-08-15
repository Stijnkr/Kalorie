import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../core/l10n/generated/app_localizations.dart';
import '../../core/widgets/empty_state.dart';
import '../../core/widgets/food_tile.dart';
import '../../data/local/collections/food.dart';
import '../../data/providers.dart';
import '../../data/remote/off_mapper.dart';
import '../../data/remote/rate_limiter.dart';

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
}

@riverpod
class FoodSearch extends _$FoodSearch {
  Timer? _debounce;

  @override
  FoodSearchState build() {
    ref.onDispose(() => _debounce?.cancel());
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
    state = state.copyWith(filter: filter, remote: const []);
    reload();
  }

  void setQuery(String query) {
    state = state.copyWith(query: query, remote: const [], clearError: true);
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 100), reload);
  }

  void reset() {
    _debounce?.cancel();
    state = const FoodSearchState();
    reload();
  }

  Future<void> searchOnline() async {
    final q = state.query.trim();
    if (q.length < 3) return;
    final connectivity = await Connectivity().checkConnectivity();
    if (connectivity.contains(ConnectivityResult.none) ||
        connectivity.isEmpty) {
      state = state.copyWith(error: 'offline');
      return;
    }
    state = state.copyWith(onlineLoading: true, clearError: true);
    try {
      final products = await ref.read(offRemoteProvider).search(q);
      final mapped = <Food>[];
      for (final product in products) {
        final food = mapOffProduct(product);
        if (food == null) continue;
        mapped.add(await ref.read(foodRepositoryProvider).cacheOffProduct(food));
      }
      state = state.copyWith(remote: mapped, onlineLoading: false);
    } on RateLimitedException {
      state = state.copyWith(onlineLoading: false, error: 'rate');
    } catch (_) {
      state = state.copyWith(onlineLoading: false, error: 'network');
    }
  }
}

class AddFoodScreen extends ConsumerWidget {
  const AddFoodScreen({super.key, this.initialMeal});

  final String? initialMeal;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final search = ref.watch(foodSearchProvider);
    final mealQuery =
        initialMeal == null ? '' : '?meal=$initialMeal';

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.add),
        actions: [
          IconButton(
            tooltip: l10n.scanBarcode,
            onPressed: () => context.push('/add/scan$mealQuery'),
            icon: const Icon(Icons.qr_code_scanner),
          ),
          IconButton(
            tooltip: l10n.newProduct,
            onPressed: () => context.push('/add/custom'),
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 8),
            child: TextField(
              autofocus: true,
              decoration: InputDecoration(
                hintText: l10n.searchHint,
                prefixIcon: const Icon(Icons.search),
              ),
              onChanged: (v) =>
                  ref.read(foodSearchProvider.notifier).setQuery(v),
            ),
          ),
          if (search.query.isEmpty)
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 8),
              child: Wrap(
                spacing: 8,
                children: [
                  ChoiceChip(
                    label: Text(l10n.recents),
                    selected: search.filter == FoodFilter.recents,
                    onSelected: (_) => ref
                        .read(foodSearchProvider.notifier)
                        .setFilter(FoodFilter.recents),
                  ),
                  ChoiceChip(
                    label: Text(l10n.favorites),
                    selected: search.filter == FoodFilter.favorites,
                    onSelected: (_) => ref
                        .read(foodSearchProvider.notifier)
                        .setFilter(FoodFilter.favorites),
                  ),
                ],
              ),
            ),
          Expanded(
            child: _Results(
              search: search,
              mealQuery: mealQuery,
            ),
          ),
        ],
      ),
    );
  }
}

class _Results extends ConsumerWidget {
  const _Results({required this.search, required this.mealQuery});

  final FoodSearchState search;
  final String mealQuery;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final items = [
      ...search.local,
      ...search.remote.where(
        (r) => search.local.every((l) => l.id != r.id),
      ),
    ];

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 32),
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
          ...items.map(
            (food) => FoodTile(
              food: food,
              onTap: () => context.push('/add/amount/${food.id}$mealQuery'),
              trailing: IconButton(
                icon: Icon(
                  food.isFavorite ? Icons.star : Icons.star_border,
                  size: 20,
                ),
                onPressed: () async {
                  await ref.read(foodRepositoryProvider).toggleFavorite(food.id);
                  await ref.read(foodSearchProvider.notifier).reload();
                },
              ),
            ),
          ),
        if (search.query.trim().length >= 3) ...[
          const SizedBox(height: 12),
          if (search.onlineLoading)
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
        if (search.error == 'offline')
          Padding(
            padding: const EdgeInsets.all(12),
            child: Text(l10n.offline),
          ),
        if (search.error == 'rate')
          Padding(
            padding: const EdgeInsets.all(12),
            child: Text(l10n.rateLimited),
          ),
        if (search.error == 'network')
          Padding(
            padding: const EdgeInsets.all(12),
            child: Text(l10n.networkError),
          ),
      ],
    );
  }
}
