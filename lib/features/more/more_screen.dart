import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/theme.dart';
import '../../core/l10n/generated/app_localizations.dart';
import '../../core/widgets/kalorie_ui.dart';
import '../../core/widgets/panel.dart';
import '../../data/providers.dart';

class MoreScreen extends ConsumerWidget {
  const MoreScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final kcalGoal = ref.watch(kcalGoalProvider);
    final weights = ref.watch(weightLogProvider).value ?? const [];
    final customFoods = ref.watch(customFoodCountProvider).value;

    final latestWeight = weights.isEmpty ? null : weights.last.kg;

    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 14, 20, 4),
              child: Text(l10n.more, style: theme.textTheme.titleMedium),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                children: [
                  KaloriePanelList(
                    children: [
                      KaloriePanelTile(
                        title: l10n.goals,
                        subtitle: l10n.goalsMoreSub,
                        value: '$kcalGoal ${l10n.kcal}',
                        chevron: true,
                        minHeight: 64,
                        onTap: () => context.push('/goals'),
                      ),
                      KaloriePanelTile(
                        title: l10n.weight,
                        subtitle: l10n.weightMoreSub,
                        value: latestWeight == null
                            ? ''
                            : '${latestWeight.toStringAsFixed(1).replaceAll('.', ',')} ${l10n.kg}',
                        chevron: true,
                        minHeight: 64,
                        onTap: () => context.push('/weight'),
                      ),
                      KaloriePanelTile(
                        title: l10n.ownProducts,
                        subtitle: l10n.ownProductsSub,
                        value: customFoods == null ? '' : '$customFoods',
                        chevron: true,
                        minHeight: 64,
                        onTap: () => context.push('/add/custom'),
                      ),
                      KaloriePanelTile(
                        title: l10n.settings,
                        subtitle: l10n.settingsMoreSub,
                        chevron: true,
                        minHeight: 64,
                        onTap: () => context.push('/settings'),
                      ),
                      KaloriePanelTile(
                        title: l10n.restartOnboarding,
                        subtitle: l10n.restartOnboardingSub,
                        chevron: true,
                        minHeight: 64,
                        onTap: () => context.push('/onboarding'),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(4, 18, 4, 0),
                    child: Text(
                      l10n.moreFootnote,
                      style: theme.textTheme.labelMedium
                          ?.copyWith(color: context.tones.hint, height: 1.6),
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
