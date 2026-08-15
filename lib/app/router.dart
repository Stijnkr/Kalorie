import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../features/account/account_screen.dart';
import '../features/account/auth_form.dart';
import '../features/account/auth_screen.dart';
import '../features/account/recover_screen.dart';
import '../features/add_food/add_food_screen.dart';
import '../features/add_food/amount_screen.dart';
import '../features/feedback/feedback_screen.dart';
import '../features/food_edit/custom_foods_screen.dart';
import '../features/food_edit/food_edit_screen.dart';
import '../features/goals/goals_screen.dart';
import '../features/history/history_screen.dart';
import '../features/more/more_screen.dart';
import '../features/onboarding/onboarding_screen.dart';
import '../features/recipes/recipe_edit_screen.dart';
import '../features/recipes/recipes_screen.dart';
import '../features/reminders/reminders_screen.dart';
import '../features/legal/legal_screen.dart';
import '../features/updates/updates_screen.dart';
import '../features/scanner/scanner_screen.dart';
import '../features/settings/settings_screen.dart';
import '../features/shell/app_shell.dart';
import '../features/today/today_screen.dart';
import '../features/weight/weight_screen.dart';

final _rootKey = GlobalKey<NavigatorState>();

bool _isAuthRoute(String location) {
  return location == '/onboarding' ||
      location == '/auth' ||
      location == '/auth/recover' ||
      location.startsWith('/legal/');
}

GoRouter createRouter({
  required Listenable refresh,
  required bool Function() signedIn,
  required bool Function() onboardingDone,
}) {
  return GoRouter(
    navigatorKey: _rootKey,
    refreshListenable: refresh,
    initialLocation: onboardingDone() && signedIn() ? '/today' : '/onboarding',
    redirect: (context, state) {
      final loc = state.matchedLocation;
      final hasSession = signedIn();
      final done = onboardingDone();
      if (!hasSession) {
        return _isAuthRoute(loc) ? null : '/onboarding';
      }
      if (!done &&
          loc != '/onboarding' &&
          loc != '/auth/recover' &&
          !loc.startsWith('/legal/')) {
        return '/onboarding';
      }
      if (done && loc == '/onboarding') {
        return state.uri.queryParameters['restart'] == '1' ? null : '/today';
      }
      if (done && loc == '/auth') return '/account';
      return null;
    },
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
        builder: (context, state) => ScannerScreen(
          initialMeal: state.uri.queryParameters['meal'],
        ),
      ),
      GoRoute(
        path: '/add/custom',
        parentNavigatorKey: _rootKey,
        builder: (context, state) {
          return FoodEditScreen(
            barcode: state.uri.queryParameters['barcode'],
            stayOnSave: state.uri.queryParameters['stay'] == '1',
            logOnSave: state.uri.queryParameters['log'] == '1',
            initialMeal: state.uri.queryParameters['meal'],
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
      GoRoute(
        path: '/reminders',
        parentNavigatorKey: _rootKey,
        builder: (context, state) => const RemindersScreen(),
      ),
      GoRoute(
        path: '/recipes',
        parentNavigatorKey: _rootKey,
        builder: (context, state) => RecipesScreen(
          initialMeal: state.uri.queryParameters['meal'],
        ),
      ),
      GoRoute(
        path: '/recipes/new',
        parentNavigatorKey: _rootKey,
        builder: (context, state) => const RecipeEditScreen(),
      ),
      GoRoute(
        path: '/recipes/:id',
        parentNavigatorKey: _rootKey,
        builder: (context, state) => RecipeEditScreen(
          recipeId: int.tryParse(state.pathParameters['id'] ?? ''),
        ),
      ),
      GoRoute(
        path: '/account',
        parentNavigatorKey: _rootKey,
        builder: (context, state) => const AccountScreen(),
      ),
      GoRoute(
        path: '/auth',
        parentNavigatorKey: _rootKey,
        builder: (context, state) => AuthScreen(
          initialMode: state.uri.queryParameters['mode'] == 'signin'
              ? AuthMode.signIn
              : AuthMode.signUp,
        ),
      ),
      GoRoute(
        path: '/auth/recover',
        parentNavigatorKey: _rootKey,
        builder: (context, state) => const RecoverScreen(),
      ),
      GoRoute(
        path: '/custom-foods',
        parentNavigatorKey: _rootKey,
        builder: (context, state) => const CustomFoodsScreen(),
      ),
      GoRoute(
        path: '/feedback',
        parentNavigatorKey: _rootKey,
        builder: (context, state) => const FeedbackScreen(),
      ),
      GoRoute(
        path: '/updates',
        parentNavigatorKey: _rootKey,
        builder: (context, state) => const UpdatesScreen(),
      ),
      GoRoute(
        path: '/legal/privacy',
        parentNavigatorKey: _rootKey,
        builder: (context, state) => const LegalScreen(doc: LegalDoc.privacy),
      ),
      GoRoute(
        path: '/legal/terms',
        parentNavigatorKey: _rootKey,
        builder: (context, state) => const LegalScreen(doc: LegalDoc.terms),
      ),
    ],
  );
}
