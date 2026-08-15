import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../app/theme.dart';
import '../../core/constants.dart';
import '../../core/l10n/generated/app_localizations.dart';
import '../../core/widgets/kalorie_ui.dart';
import '../../core/widgets/panel.dart';
import '../../data/providers.dart';
import 'release_notes.dart';

class UpdatesScreen extends ConsumerStatefulWidget {
  const UpdatesScreen({super.key});

  @override
  ConsumerState<UpdatesScreen> createState() => _UpdatesScreenState();
}

class _UpdatesScreenState extends ConsumerState<UpdatesScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .read(settingsRepositoryProvider)
          .markReleaseNotesSeen(AppInfo.version);
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final tones = context.tones;
    final dateFormat = DateFormat('d MMMM y', 'nl');

    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            KalorieOverlayHeader(
              title: l10n.updates,
              onBack: () => context.pop(),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(16, 6, 16, 40),
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(4, 0, 4, 14),
                    child: Text(
                      l10n.updatesIntro,
                      style: theme.textTheme.bodySmall?.copyWith(height: 1.5),
                    ),
                  ),
                  for (final note in kReleaseNotes) ...[
                    KalorieSectionLabel(
                      l10n.whatsNewVersion(note.version),
                      padding: const EdgeInsets.fromLTRB(4, 8, 4, 8),
                    ),
                    KaloriePanel(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              dateFormat.format(note.date),
                              style: theme.textTheme.labelMedium
                                  ?.copyWith(color: tones.hint),
                            ),
                            const SizedBox(height: 10),
                            for (final item in note.items)
                              Padding(
                                padding: const EdgeInsets.only(bottom: 8),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '·  ',
                                      style: theme.textTheme.bodyMedium
                                          ?.copyWith(
                                        color: theme.colorScheme.primary,
                                      ),
                                    ),
                                    Expanded(
                                      child: Text(
                                        item,
                                        style: theme.textTheme.bodyMedium
                                            ?.copyWith(height: 1.4),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Future<void> showWhatsNewSheet(BuildContext context) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    showDragHandle: true,
    builder: (context) => const _WhatsNewSheet(),
  );
}

class _WhatsNewSheet extends ConsumerWidget {
  const _WhatsNewSheet();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final seen = ref.watch(settingsProvider).value?.seenReleaseNotes;
    final notes = unseenReleaseNotes(seen);
    final latest = notes.isEmpty ? kReleaseNotes.first : notes.first;

    return Padding(
      padding: EdgeInsets.fromLTRB(
        20,
        6,
        20,
        20 + MediaQuery.paddingOf(context).bottom,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            l10n.whatsNewVersion(latest.version),
            style: theme.textTheme.titleMedium,
          ),
          const SizedBox(height: 6),
          Text(
            l10n.whatsNewIntro,
            style: theme.textTheme.bodySmall?.copyWith(height: 1.5),
          ),
          const SizedBox(height: 16),
          for (final note in notes.isEmpty ? [latest] : notes) ...[
            if (note.version != latest.version)
              Padding(
                padding: const EdgeInsets.only(top: 8, bottom: 6),
                child: Text(
                  l10n.whatsNewVersion(note.version),
                  style: theme.textTheme.titleSmall,
                ),
              ),
            for (final item in note.items)
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '·  ',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.primary,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        item,
                        style: theme.textTheme.bodyMedium?.copyWith(height: 1.4),
                      ),
                    ),
                  ],
                ),
              ),
          ],
          const SizedBox(height: 18),
          FilledButton(
            onPressed: () {
              ref
                  .read(settingsRepositoryProvider)
                  .markReleaseNotesSeen(AppInfo.version);
              Navigator.of(context).pop();
            },
            child: Text(l10n.whatsNewOk),
          ),
          TextButton(
            onPressed: () {
              ref
                  .read(settingsRepositoryProvider)
                  .markReleaseNotesSeen(AppInfo.version);
              Navigator.of(context).pop();
              context.push('/updates');
            },
            child: Text(l10n.updatesAll),
          ),
        ],
      ),
    );
  }
}
