import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/l10n/generated/app_localizations.dart';
import '../../core/widgets/kalorie_ui.dart';
import '../legal/legal_screen.dart';
import 'auth_form.dart';

/// Los inlogscherm, bereikbaar vanuit Meer wanneer je nog geen account hebt.
class AuthScreen extends ConsumerStatefulWidget {
  const AuthScreen({super.key, this.initialMode = AuthMode.signUp});

  final AuthMode initialMode;

  @override
  ConsumerState<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends ConsumerState<AuthScreen> {
  final _formKey = GlobalKey<AuthFormState>();
  late AuthMode _mode = widget.initialMode;
  bool _busy = false;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final signUp = _mode == AuthMode.signUp;

    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            KalorieOverlayHeader(
              title: signUp ? l10n.signUp : l10n.signIn,
              closeIcon: true,
              onBack: () => context.pop(),
            ),
            Expanded(
              child: ListView(
                keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,
                padding: const EdgeInsets.fromLTRB(24, 6, 24, 40),
                children: [
                  Text(
                    signUp ? l10n.authCreateAccount : l10n.authWelcomeBack,
                    style: theme.textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    signUp ? l10n.authSignUpBody : l10n.authSignInBody,
                    style: theme.textTheme.bodyLarge,
                  ),
                  const SizedBox(height: 22),
                  AuthForm(
                    key: _formKey,
                    mode: _mode,
                    onModeChanged: (mode) => setState(() => _mode = mode),
                    onBusyChanged: (busy) => setState(() => _busy = busy),
                    onDone: () {
                      if (context.canPop()) context.pop();
                    },
                  ),
                  const SizedBox(height: 20),
                  FilledButton(
                    onPressed: _busy ? null : () => _formKey.currentState?.submit(),
                    child: _busy
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : Text(signUp ? l10n.signUp : l10n.signIn),
                  ),
                  const SizedBox(height: 20),
                  const AuthLegalFooter(align: TextAlign.left),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
