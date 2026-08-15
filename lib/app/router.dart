import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../core/l10n/generated/app_localizations.dart';
import '../core/widgets/panel.dart';
import '../features/add_food/add_food_screen.dart';
import '../features/add_food/amount_screen.dart';
import '../features/food_edit/food_edit_screen.dart';
import '../features/goals/goals_screen.dart';
import '../features/history/history_screen.dart';
import '../features/onboarding/onboarding_screen.dart';
import '../features/scanner/scanner_screen.dart';
import '../features/settings/settings_screen.dart';
import '../features/shell/app_shell.dart';
import '../features/today/today_screen.dart';
import '../features/weight/weight_screen.dart';

final _rootKey = GlobalKey<NavigatorState>();

GoRouter createRouter({required bool onboardingDone}) {
  return GoRouter(
    navigatorKey: _rootKey,
    initialLocation: onboardingDone ? '/today' : '/onboarding',
    routes: [
      GoRoute(
        path: '/onboarding',
        parentNavigatorKey: _rootKey,
        builder: (context, state) => const OnboardingScreen(),
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) =>
            AppShell(navigationShell: navigationShell),
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/today',
                builder: (context, state) => const TodayScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/history',
                builder: (context, state) => const HistoryScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/more',
                builder: (context, state) => const MoreScreen(),
              ),
            ],
          ),
        ],
      ),
      GoRoute(
        path: '/add',
        parentNavigatorKey: _rootKey,
        builder: (context, state) {
          final meal = state.uri.queryParameters['meal'];
          return AddFoodScreen(initialMeal: meal);
        },
      ),
      GoRoute(
        path: '/add/scan',
        parentNavigatorKey: _rootKey,
        builder: (context, state) => const ScannerScreen(),
      ),
      GoRoute(
        path: '/add/custom',
        parentNavigatorKey: _rootKey,
        builder: (context, state) {
          return FoodEditScreen(
            barcode: state.uri.queryParameters['barcode'],
          );
        },
      ),
      GoRoute(
        path: '/add/amount/:foodId',
        parentNavigatorKey: _rootKey,
        builder: (context, state) {
          final id = int.parse(state.pathParameters['foodId']!);
          final meal = state.uri.queryParameters['meal'];
          return AmountScreen(
            foodId: id,
            initialMeal: meal,
            entryId: int.tryParse(state.uri.queryParameters['entryId'] ?? ''),
          );
        },
      ),
      GoRoute(
        path: '/food/:id/edit',
        parentNavigatorKey: _rootKey,
        builder: (context, state) {
          final id = int.parse(state.pathParameters['id']!);
          return FoodEditScreen(foodId: id);
        },
      ),
      GoRoute(
        path: '/goals',
        parentNavigatorKey: _rootKey,
        builder: (context, state) => const GoalsScreen(),
      ),
      GoRoute(
        path: '/weight',
        parentNavigatorKey: _rootKey,
        builder: (context, state) => const WeightScreen(),
      ),
      GoRoute(
        path: '/settings',
        parentNavigatorKey: _rootKey,
        builder: (context, state) => const SettingsScreen(),
      ),
    ],
  );
}

class MoreScreen extends ConsumerWidget {
  const MoreScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.more)),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(4, 8, 4, 8),
            child: Text(
              l10n.moreSection,
              style: Theme.of(context).textTheme.labelSmall,
            ),
          ),
          KaloriePanel(
            child: Column(
              children: [
                ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                  leading: const Icon(Icons.flag_outlined),
                  title: Text(l10n.goals),
                  subtitle: Text(l10n.goalsSubtitle),
                  onTap: () => context.push('/goals'),
                ),
                const KalorieHairline(indent: 56),
                ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                  leading: const Icon(Icons.monitor_weight_outlined),
                  title: Text(l10n.weight),
                  subtitle: Text(l10n.weightSubtitle),
                  onTap: () => context.push('/weight'),
                ),
                const KalorieHairline(indent: 56),
                ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                  leading: const Icon(Icons.tune),
                  title: Text(l10n.settings),
                  onTap: () => context.push('/settings'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
