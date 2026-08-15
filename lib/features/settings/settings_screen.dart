import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_plus/share_plus.dart';

import '../../core/l10n/generated/app_localizations.dart';
import '../../data/local/collections/enums.dart';
import '../../data/providers.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final settings = ref.watch(settingsProvider).value;
    final theme = settings?.theme ?? ThemeModeSetting.system;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.settings)),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(8, 8, 8, 32),
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Text(
              l10n.appearance,
              style: Theme.of(context).textTheme.labelSmall,
            ),
          ),
          RadioGroup<ThemeModeSetting>(
            groupValue: theme,
            onChanged: (value) {
              if (value != null) {
                ref.read(settingsRepositoryProvider).setTheme(value);
              }
            },
            child: Column(
              children: [
                RadioListTile<ThemeModeSetting>(
                  title: Text(l10n.themeSystem),
                  value: ThemeModeSetting.system,
                ),
                RadioListTile<ThemeModeSetting>(
                  title: Text(l10n.themeLight),
                  value: ThemeModeSetting.light,
                ),
                RadioListTile<ThemeModeSetting>(
                  title: Text(l10n.themeDark),
                  value: ThemeModeSetting.dark,
                ),
              ],
            ),
          ),
          const Divider(),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Text(
              l10n.privacyTitle,
              style: Theme.of(context).textTheme.labelSmall,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(l10n.privacyBody),
          ),
          ListTile(
            title: Text(l10n.exportData),
            leading: const Icon(Icons.ios_share),
            onTap: () async {
              final json = await ref.read(dataExporterProvider).exportJson();
              await Share.share(json, subject: l10n.exportData);
            },
          ),
          const Divider(),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Text(
              l10n.sources,
              style: Theme.of(context).textTheme.labelSmall,
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
            child: Text(l10n.nevoAttribution),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
            child: Text(l10n.offAttribution),
          ),
          ListTile(title: Text(l10n.version('0.1.0'))),
        ],
      ),
    );
  }
}
