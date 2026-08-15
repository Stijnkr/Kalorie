import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../features/add_food/add_food_screen.dart';
import '../features/add_food/amount_screen.dart';
import '../features/food_edit/food_edit_screen.dart';
import '../features/goals/goals_screen.dart';
import '../features/history/history_screen.dart';
import '../features/more/more_screen.dart';
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
