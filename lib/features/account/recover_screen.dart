import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/theme.dart';
import '../../core/l10n/generated/app_localizations.dart';
import '../../core/password.dart';
import '../../core/widgets/kalorie_ui.dart';
import '../../data/providers.dart';
import '../../data/repositories/auth_repository.dart';
import 'auth_form.dart';

/// Wordt geopend vanuit de herstelmail. Zonder dit scherm blijft de sessie
/// hangen in recovery en verandert het wachtwoord nooit.
class RecoverScreen extends ConsumerStatefulWidget {
  const RecoverScreen({super.key});

  @override
  ConsumerState<RecoverScreen> createState() => _RecoverScreenState();
}

class _RecoverScreenState extends ConsumerState<RecoverScreen> {
  final _password = TextEditingController();
  final _confirm = TextEditingController();
  bool _busy = false;
  String? _error;

  @override
  void dispose() {
    _password.dispose();
    _confirm.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final l10n = AppLocalizations.of(context);
    if (!PasswordRules.isStrong(_password.text)) {
      setState(() => _error = l10n.errWeakPassword);
      return;
    }
    if (_password.text != _confirm.text) {
      setState(() => _error = l10n.errPasswordMismatch);
      return;
    }
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      await ref.read(authRepositoryProvider).updatePassword(_password.text);
      await ref.read(syncEngineProvider).run();
      if (!mounted) return;
      HapticFeedback.mediumImpact();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.passwordUpdated)),
      );
      if (context.canPop()) {
        context.pop();
      } else {
        context.go('/today');
      }
    } on KalorieAuthException catch (e) {
      if (mounted) setState(() => _error = authFailureText(l10n, e.failure));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final tones = context.tones;

    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            KalorieOverlayHeader(
              title: l10n.recoverTitle,
              closeIcon: true,
              onBack: () => context.canPop() ? context.pop() : context.go('/today'),
            ),
            Expanded(
              child: ListView(
                keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,
                padding: const EdgeInsets.fromLTRB(24, 6, 24, 40),
                children: [
                  Text(l10n.recoverTitle, style: theme.textTheme.headlineMedium),
                  const SizedBox(height: 10),
                  Text(l10n.recoverBody, style: theme.textTheme.bodyLarge),
                  const SizedBox(height: 22),
                  KalorieSectionLabel(
                    l10n.newPassword,
                    padding: const EdgeInsets.only(bottom: 6),
                  ),
                  TextField(
                    controller: _password,
                    obscureText: true,
                    autocorrect: false,
                    enableSuggestions: false,
                    autofillHints: const [AutofillHints.newPassword],
                    textInputAction: TextInputAction.next,
                    onTapOutside: (_) =>
                        FocusManager.instance.primaryFocus?.unfocus(),
                    decoration: InputDecoration(hintText: l10n.passwordPlaceholder),
                    onChanged: (_) => setState(() {}),
                  ),
                  const SizedBox(height: 10),
                  KalorieSectionLabel(
                    l10n.confirmPassword,
                    padding: const EdgeInsets.only(bottom: 6),
                  ),
                  TextField(
                    controller: _confirm,
                    obscureText: true,
                    autocorrect: false,
                    enableSuggestions: false,
                    autofillHints: const [AutofillHints.newPassword],
                    textInputAction: TextInputAction.done,
                    onTapOutside: (_) =>
                        FocusManager.instance.primaryFocus?.unfocus(),
                    decoration: InputDecoration(hintText: l10n.passwordPlaceholder),
                    onSubmitted: (_) => _save(),
                  ),
                  if (_error != null) ...[
                    const SizedBox(height: 10),
                    Text(
                      _error!,
                      style: theme.textTheme.labelMedium
                          ?.copyWith(color: tones.danger),
                    ),
                  ],
                  const SizedBox(height: 20),
                  FilledButton(
                    onPressed: _busy ? null : _save,
                    child: _busy
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : Text(l10n.savePassword),
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
