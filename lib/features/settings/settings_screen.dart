import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:share_plus/share_plus.dart';

import '../../app/theme.dart';
import '../../core/l10n/generated/app_localizations.dart';
import '../../core/widgets/kalorie_ui.dart';
import '../../core/widgets/panel.dart';
import '../../data/local/collections/enums.dart';
import '../../data/providers.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final tones = context.tones;
    final selected =
        ref.watch(settingsProvider).value?.theme ?? ThemeModeSetting.system;

    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            KalorieOverlayHeader(
              title: l10n.settings,
              onBack: () => context.pop(),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 40),
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(4, 8, 4, 10),
                    child: KalorieSectionLabel(
                      l10n.displaySection,
                      padding: EdgeInsets.zero,
                    ),
                  ),
                  KaloriePanelList(
                    children: [
                      for (final mode in ThemeModeSetting.values)
                        KaloriePanelTile(
                          title: switch (mode) {
                            ThemeModeSetting.system => l10n.themeSystem,
                            ThemeModeSetting.light => l10n.themeLight,
                            ThemeModeSetting.dark => l10n.themeDark,
                          },
                          minHeight: 56,
                          trailing: _Selected(on: mode == selected),
                          onTap: () => ref
                              .read(settingsRepositoryProvider)
                              .setTheme(mode),
                        ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(4, 24, 4, 10),
                    child: KalorieSectionLabel(
                      l10n.dataSection,
                      padding: EdgeInsets.zero,
                    ),
                  ),
                  KaloriePanelList(
                    children: [
                      KaloriePanelTile(
                        title: l10n.exportData,
                        subtitle: l10n.exportDataSub,
                        chevron: true,
                        minHeight: 60,
                        onTap: () async {
                          final json =
                              await ref.read(dataExporterProvider).exportJson();
                          await Share.share(json, subject: l10n.exportData);
                        },
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(4, 24, 4, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n.privacyBody,
                          style: theme.textTheme.labelMedium
                              ?.copyWith(color: tones.hint, height: 1.6),
                        ),
                        const SizedBox(height: 14),
                        Text(
                          l10n.nevoAttribution,
                          style: theme.textTheme.labelMedium
                              ?.copyWith(color: tones.hint, height: 1.6),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          l10n.offAttribution,
                          style: theme.textTheme.labelMedium
                              ?.copyWith(color: tones.hint, height: 1.6),
                        ),
                        const SizedBox(height: 14),
                        Text(
                          l10n.version('0.1.0'),
                          style: theme.textTheme.labelMedium
                              ?.copyWith(color: tones.hint),
                        ),
                      ],
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

/// Sage stip als markering van de gekozen optie.
class _Selected extends StatelessWidget {
  const _Selected({required this.on});

  final bool on;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      width: 18,
      height: 18,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: on ? theme.colorScheme.primary : Colors.transparent,
        border: Border.all(
          color: on ? theme.colorScheme.primary : theme.colorScheme.outline,
        ),
      ),
      child: on
          ? Center(
              child: Container(
                width: 6,
                height: 6,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: theme.colorScheme.onPrimary,
                ),
              ),
            )
          : null,
    );
  }
}
