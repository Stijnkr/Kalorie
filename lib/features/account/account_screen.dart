import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';

import '../../app/theme.dart';
import '../../core/l10n/generated/app_localizations.dart';
import '../../core/widgets/kalorie_ui.dart';
import '../../core/widgets/panel.dart';
import '../../data/providers.dart';
import '../../data/repositories/auth_repository.dart';
import '../../data/sync/sync_engine.dart';
import 'auth_form.dart';

class AccountScreen extends ConsumerStatefulWidget {
  const AccountScreen({super.key});

  @override
  ConsumerState<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends ConsumerState<AccountScreen> {
  late final TextEditingController _name;
  bool _busy = false;

  @override
  void initState() {
    super.initState();
    _name = TextEditingController();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _name.text = ref.read(settingsProvider).value?.displayName ?? '';
    });
  }

  @override
  void dispose() {
    _name.dispose();
    super.dispose();
  }

  Future<void> _changePassword(String email) async {
    final l10n = AppLocalizations.of(context);
    final messenger = ScaffoldMessenger.of(context);
    setState(() => _busy = true);
    try {
      await ref.read(authRepositoryProvider).sendPasswordReset(email);
      if (!mounted) return;
      messenger.showSnackBar(SnackBar(content: Text(l10n.resetSent)));
    } on KalorieAuthException catch (e) {
      if (!mounted) return;
      messenger.showSnackBar(
        SnackBar(content: Text(authFailureText(l10n, e.failure))),
      );
    } catch (_) {
      if (!mounted) return;
      messenger.showSnackBar(SnackBar(content: Text(l10n.errNetwork)));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _saveName() async {
    await ref.read(settingsRepositoryProvider).setDisplayName(_name.text);
    await ref.read(authRepositoryProvider).updateDisplayName(_name.text);
  }

  Future<void> _signOut() async {
    setState(() => _busy = true);
    try {
      await ref.read(syncEngineProvider).run();
      await ref.read(authRepositoryProvider).signOut();
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _deleteAccount() async {
    final l10n = AppLocalizations.of(context);
    final ok = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.deleteAccount),
        content: Text(l10n.deleteAccountConfirm),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(l10n.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(l10n.delete),
          ),
        ],
      ),
    );
    if (ok != true) return;
    setState(() => _busy = true);
    try {
      await ref.read(authRepositoryProvider).deleteAccount();
      await ref.read(syncEngineProvider).releaseCloudOwner();
    } on KalorieAuthException catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(authFailureText(l10n, e.failure))),
      );
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.errNetwork)),
      );
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final tones = context.tones;
    final user = ref.watch(currentUserProvider);
    final settings = ref.watch(settingsProvider).value;
    final sync = ref.watch(syncStatusProvider).value ??
        ref.watch(syncEngineProvider).status;

    if (user == null) {
      // Uitgelogd terwijl dit scherm openstond.
      return Scaffold(
        body: SafeArea(
          child: KalorieOverlayHeader(
            title: l10n.account,
            onBack: () => context.pop(),
          ),
        ),
      );
    }

    final name = settings?.displayName?.trim();
    final email = user.email ?? '';
    final since = DateFormat('MMMM y', 'nl').format(
      DateTime.tryParse(user.createdAt) ?? DateTime.now(),
    );

    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            KalorieOverlayHeader(
              title: l10n.account,
              onBack: () => context.pop(),
            ),
            Expanded(
              child: ListView(
                keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,
                padding: const EdgeInsets.fromLTRB(16, 6, 16, 40),
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(4, 8, 4, 20),
                    child: Row(
                      children: [
                        _Avatar(
                          initials: _initials(name, email),
                          size: 64,
                          fontSize: 22,
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                name?.isNotEmpty == true ? name! : email,
                                style: theme.textTheme.headlineSmall,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 2),
                              Text(
                                l10n.accountSince(email, since),
                                style: theme.textTheme.bodySmall
                                    ?.copyWith(color: tones.hint),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  KaloriePanel(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          KalorieSectionLabel(
                            l10n.displayName,
                            padding: const EdgeInsets.only(bottom: 6),
                          ),
                          TextField(
                            controller: _name,
                            textCapitalization: TextCapitalization.words,
                            decoration: const InputDecoration(
                              isDense: true,
                              filled: false,
                              border: InputBorder.none,
                              enabledBorder: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              contentPadding: EdgeInsets.zero,
                            ),
                            onSubmitted: (_) => _saveName(),
                            onTapOutside: (_) => _saveName(),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  KalorieSectionLabel(
                    l10n.syncSection,
                    padding: const EdgeInsets.fromLTRB(4, 0, 4, 10),
                  ),
                  KaloriePanelList(
                    children: [
                      KaloriePanelTile(
                        title: l10n.syncDiary,
                        subtitle: l10n.syncDiarySub,
                        minHeight: 60,
                        trailing: KalorieToggle(
                          value: settings?.syncDiary ?? true,
                          onChanged: (value) => ref
                              .read(settingsRepositoryProvider)
                              .setSyncPreferences(diary: value),
                        ),
                      ),
                      KaloriePanelTile(
                        title: l10n.syncWeight,
                        subtitle: l10n.syncWeightSub,
                        minHeight: 60,
                        trailing: KalorieToggle(
                          value: settings?.syncWeight ?? true,
                          onChanged: (value) => ref
                              .read(settingsRepositoryProvider)
                              .setSyncPreferences(weight: value),
                        ),
                      ),
                      KaloriePanelTile(
                        title: l10n.syncNow,
                        subtitle: _syncSubtitle(l10n, sync),
                        minHeight: 60,
                        chevron: !sync.busy,
                        trailing: sync.busy
                            ? const SizedBox(
                                width: 18,
                                height: 18,
                                child:
                                    CircularProgressIndicator(strokeWidth: 2),
                              )
                            : null,
                        onTap: sync.busy
                            ? null
                            : () => ref.read(syncEngineProvider).run(),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  KalorieSectionLabel(
                    l10n.securitySection,
                    padding: const EdgeInsets.fromLTRB(4, 0, 4, 10),
                  ),
                  KaloriePanelList(
                    children: [
                      KaloriePanelTile(
                        title: l10n.changePassword,
                        subtitle: l10n.changePasswordSub,
                        chevron: !_busy,
                        minHeight: 56,
                        onTap: _busy ? null : () => _changePassword(email),
                      ),
                      KaloriePanelTile(
                        title: l10n.exportData,
                        subtitle: l10n.exportDataSub,
                        chevron: true,
                        minHeight: 56,
                        onTap: () async {
                          final json =
                              await ref.read(dataExporterProvider).exportJson();
                          await Share.share(json, subject: l10n.exportData);
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  OutlinedButton(
                    onPressed: _busy ? null : _signOut,
                    child: Text(l10n.signOut),
                  ),
                  const SizedBox(height: 10),
                  TextButton(
                    onPressed: _busy ? null : _deleteAccount,
                    style: TextButton.styleFrom(
                      foregroundColor: tones.danger,
                      minimumSize: const Size.fromHeight(52),
                    ),
                    child: Text(l10n.deleteAccount),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(4, 14, 4, 0),
                    child: Text(
                      l10n.deleteAccountBody,
                      style: theme.textTheme.labelMedium
                          ?.copyWith(color: tones.hint, height: 1.6),
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

  static String _syncSubtitle(AppLocalizations l10n, SyncStatus status) {
    return switch (status.phase) {
      SyncPhase.running => l10n.syncRunning,
      SyncPhase.offline => l10n.syncOffline,
      SyncPhase.failed => l10n.syncFailed,
      _ => status.lastSuccess == null
          ? l10n.syncNever
          : l10n.syncDone(DateFormat('HH:mm').format(status.lastSuccess!)),
    };
  }

  static String _initials(String? name, String email) {
    final source = (name?.trim().isNotEmpty ?? false) ? name!.trim() : email;
    if (source.isEmpty) return '?';
    final parts = source.split(RegExp(r'[\s@._-]+')).where((p) => p.isNotEmpty);
    if (parts.isEmpty) return source.characters.first.toUpperCase();
    if (parts.length == 1) {
      return parts.first.characters.take(2).toString().toUpperCase();
    }
    return (parts.first.characters.first + parts.elementAt(1).characters.first)
        .toUpperCase();
  }
}

/// Rond vlak met initialen, zoals bovenaan Meer en op het accountscherm.
class _Avatar extends StatelessWidget {
  const _Avatar({
    required this.initials,
    this.size = 46,
    this.fontSize = 17,
  });

  final String initials;
  final double size;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: theme.colorScheme.primary,
        shape: BoxShape.circle,
      ),
      child: Text(
        initials,
        style: TextStyle(
          color: theme.colorScheme.onPrimary,
          fontSize: fontSize,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

/// Herbruikbaar voor de rij bovenaan Meer.
class AccountAvatar extends StatelessWidget {
  const AccountAvatar({
    super.key,
    required this.name,
    required this.email,
    this.signedIn = true,
  });

  final String? name;
  final String email;
  final bool signedIn;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    if (!signedIn) {
      return Container(
        width: 46,
        height: 46,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: context.tones.tint,
          shape: BoxShape.circle,
        ),
        child: Text(
          '?',
          style: TextStyle(
            color: theme.colorScheme.primary,
            fontSize: 17,
            fontWeight: FontWeight.w600,
          ),
        ),
      );
    }
    return _Avatar(initials: _AccountScreenState._initials(name, email));
  }
}
