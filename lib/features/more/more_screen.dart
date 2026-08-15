import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/theme.dart';
import '../../core/l10n/generated/app_localizations.dart';
import '../../core/widgets/kalorie_ui.dart';
import '../../core/widgets/panel.dart';
import '../../data/providers.dart';
import '../account/account_screen.dart';
import '../updates/release_notes.dart';

class MoreScreen extends ConsumerWidget {
  const MoreScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final kcalGoal = ref.watch(kcalGoalProvider);
    final weights = ref.watch(weightLogProvider).value ?? const [];
    final customFoods = ref.watch(customFoodCountProvider);
    final recipes = ref.watch(recipesProvider).value ?? const [];
    final enabledReminders = ref.watch(enabledRemindersProvider);
    final user = ref.watch(currentUserProvider);
    final settings = ref.watch(settingsProvider).value;

    final latestWeight = weights.isEmpty ? null : weights.last.kg;
    final signedIn = user != null;
    final name = settings?.displayName?.trim();
    final email = user?.email ?? '';
    final returning = settings?.cloudUserId != null;
    final unseenUpdates = hasUnseenReleaseNotes(settings?.seenReleaseNotes);

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
                  KaloriePanel(
                    child: InkWell(
                      onTap: () => context.push(
                        signedIn
                            ? '/account'
                            : returning
                                ? '/auth?mode=signin'
                                : '/auth',
                      ),
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(16, 18, 16, 18),
                        child: Row(
                          children: [
                            AccountAvatar(
                              name: name,
                              email: email,
                              signedIn: signedIn,
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    signedIn
                                        ? (name?.isNotEmpty == true
                                            ? name!
                                            : email)
                                        : l10n.accountSignedOut,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: theme.textTheme.titleMedium,
                                  ),
                                  Text(
                                    signedIn
                                        ? email
                                        : l10n.accountSignedOutSub,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: theme.textTheme.bodySmall
                                        ?.copyWith(color: context.tones.hint),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 12),
                            const _Chevron(),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  KalorieSectionLabel(
                    l10n.moreSectionDay,
                    padding: const EdgeInsets.fromLTRB(4, 0, 4, 10),
                  ),
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
                        title: l10n.reminders,
                        subtitle: l10n.remindersSub,
                        value: l10n.remindersEnabledCount(enabledReminders),
                        chevron: true,
                        minHeight: 64,
                        onTap: () => context.push('/reminders'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  KalorieSectionLabel(
                    l10n.moreSectionFood,
                    padding: const EdgeInsets.fromLTRB(4, 0, 4, 10),
                  ),
                  KaloriePanelList(
                    children: [
                      KaloriePanelTile(
                        title: l10n.recipes,
                        subtitle: l10n.recipesSub,
                        value: '${recipes.length}',
                        chevron: true,
                        minHeight: 64,
                        onTap: () => context.push('/recipes'),
                      ),
                      KaloriePanelTile(
                        title: l10n.ownProducts,
                        subtitle: l10n.ownProductsSub,
                        value: '$customFoods',
                        chevron: true,
                        minHeight: 64,
                        onTap: () => context.push('/custom-foods'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  KalorieSectionLabel(
                    l10n.moreSectionApp,
                    padding: const EdgeInsets.fromLTRB(4, 0, 4, 10),
                  ),
                  KaloriePanelList(
                    children: [
                      KaloriePanelTile(
                        title: l10n.updates,
                        subtitle: l10n.updatesSub,
                        value: unseenUpdates ? l10n.newBadge : '',
                        chevron: true,
                        minHeight: 64,
                        onTap: () => context.push('/updates'),
                      ),
                      KaloriePanelTile(
                        title: l10n.feedback,
                        subtitle: l10n.feedbackSub,
                        chevron: true,
                        minHeight: 64,
                        onTap: () => context.push('/feedback'),
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
                        onTap: () => context.push('/onboarding?restart=1'),
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

class _Chevron extends StatelessWidget {
  const _Chevron();

  @override
  Widget build(BuildContext context) {
    return Icon(Icons.chevron_right, size: 18, color: context.tones.faint);
  }
}
