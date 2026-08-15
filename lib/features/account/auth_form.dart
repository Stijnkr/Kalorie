import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/theme.dart';
import '../../core/l10n/generated/app_localizations.dart';
import '../../core/password.dart';
import '../../core/widgets/kalorie_ui.dart';
import '../../data/providers.dart';
import '../../data/repositories/auth_repository.dart';
import '../../data/sync/sync_engine.dart';

enum AuthMode { signIn, signUp }

String authFailureText(AppLocalizations l10n, AuthFailure failure) {
  return switch (failure) {
    AuthFailure.invalidCredentials => l10n.errInvalidCredentials,
    AuthFailure.emailTaken => l10n.errEmailTaken,
    AuthFailure.weakPassword => l10n.errWeakPassword,
    AuthFailure.leakedPassword => l10n.errLeakedPassword,
    AuthFailure.invalidEmail => l10n.errInvalidEmail,
    AuthFailure.needsConfirmation => l10n.errNeedsConfirmation,
    AuthFailure.rateLimited => l10n.errRateLimited,
    AuthFailure.unavailable => l10n.errCloudUnavailable,
    AuthFailure.network => l10n.errNetwork,
    AuthFailure.unknown => l10n.errUnknown,
  };
}

/// Het inlogblok: keuze tussen inloggen en aanmaken, plus de velden. Wordt
/// zowel in de onboarding als op het losse inlogscherm gebruikt.
class AuthForm extends ConsumerStatefulWidget {
  const AuthForm({
    super.key,
    required this.mode,
    required this.onModeChanged,
    required this.onDone,
    this.onBusyChanged,
  });

  final AuthMode mode;
  final ValueChanged<AuthMode> onModeChanged;
  final VoidCallback onDone;
  final ValueChanged<bool>? onBusyChanged;

  @override
  ConsumerState<AuthForm> createState() => AuthFormState();
}

class AuthFormState extends ConsumerState<AuthForm> {
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();
  bool _busy = false;
  bool _awaitingConfirmation = false;
  String? _error;
  String? _notice;

  bool get busy => _busy;

  bool get isValid {
    final email = _email.text.trim();
    final hasEmail = email.contains('@') && email.contains('.');
    return hasEmail &&
        PasswordRules.isStrong(_password.text, email: email);
  }

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  /// Aangeroepen door het scherm eromheen, zodat de knop onderin kan zitten.
  Future<void> submit() async {
    if (_busy) return;
    final l10n = AppLocalizations.of(context);
    final email = _email.text.trim();
    final hasEmail = email.contains('@') && email.contains('.');
    if (!hasEmail) {
      setState(() => _error = l10n.errInvalidEmail);
      return;
    }
    if (!PasswordRules.isStrong(_password.text, email: email)) {
      setState(() => _error = l10n.errWeakPassword);
      return;
    }
    setState(() {
      _busy = true;
      _error = null;
      _notice = null;
      _awaitingConfirmation = false;
    });
    widget.onBusyChanged?.call(true);
    final auth = ref.read(authRepositoryProvider);
    try {
      if (widget.mode == AuthMode.signUp) {
        final signedIn = await auth.signUp(
          email: _email.text,
          password: _password.text,
          displayName: _name.text,
        );
        await ref.read(settingsRepositoryProvider).setDisplayName(_name.text);
        if (!signedIn) {
          if (!mounted) return;
          setState(() {
            _error = null;
            _notice = l10n.errNeedsConfirmation;
            _awaitingConfirmation = true;
          });
          return;
        }
      } else {
        await auth.signIn(email: _email.text, password: _password.text);
      }
      final adopted = await _adoptCloud();
      if (!adopted) return;
      if (!mounted) return;
      HapticFeedback.mediumImpact();
      widget.onDone();
    } on KalorieAuthException catch (e) {
      if (!mounted) return;
      if (e.failure == AuthFailure.needsConfirmation) {
        setState(() {
          _error = null;
          _notice = l10n.errNeedsConfirmation;
          _awaitingConfirmation = true;
        });
        return;
      }
      setState(() => _error = authFailureText(l10n, e.failure));
    } catch (_) {
      if (!mounted) return;
      setState(() => _error = l10n.errUnknown);
    } finally {
      if (mounted) {
        setState(() => _busy = false);
        widget.onBusyChanged?.call(false);
      }
    }
  }

  Future<bool> _adoptCloud() async {
    final sync = ref.read(syncEngineProvider);
    final first = await sync.adoptOrSync(switchConfirmed: false);
    if (first != CloudAdoptResult.needsSwitch) return true;
    if (!mounted) return false;
    final l10n = AppLocalizations.of(context);
    final ok = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.accountSwitchTitle),
        content: Text(l10n.accountSwitchBody),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(l10n.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(l10n.accountSwitchConfirm),
          ),
        ],
      ),
    );
    if (ok != true) {
      await ref.read(authRepositoryProvider).signOut();
      return false;
    }
    await sync.adoptOrSync(switchConfirmed: true);
    return true;
  }

  Future<void> _reset() async {
    final l10n = AppLocalizations.of(context);
    final email = _email.text.trim();
    if (!email.contains('@')) {
      setState(() => _error = l10n.errInvalidEmail);
      return;
    }
    try {
      await ref.read(authRepositoryProvider).sendPasswordReset(email);
      if (mounted) {
        setState(() {
          _error = null;
          _notice = l10n.resetSent;
          _awaitingConfirmation = false;
        });
      }
    } on KalorieAuthException catch (e) {
      if (mounted) setState(() => _error = authFailureText(l10n, e.failure));
    }
  }

  Future<void> _finishAfterConfirm() async {
    if (_busy) return;
    setState(() => _busy = true);
    widget.onBusyChanged?.call(true);
    try {
      final adopted = await _adoptCloud();
      if (!adopted || !mounted) return;
      HapticFeedback.mediumImpact();
      widget.onDone();
    } finally {
      if (mounted) {
        setState(() => _busy = false);
        widget.onBusyChanged?.call(false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<bool>(isSignedInProvider, (previous, next) {
      if (next && _awaitingConfirmation) {
        _finishAfterConfirm();
      }
    });
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final tones = context.tones;
    final signUp = widget.mode == AuthMode.signUp;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Expanded(
              child: _ModeButton(
                label: l10n.signIn,
                selected: !signUp,
                onTap: () => widget.onModeChanged(AuthMode.signIn),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _ModeButton(
                label: l10n.signUp,
                selected: signUp,
                onTap: () => widget.onModeChanged(AuthMode.signUp),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        AutofillGroup(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (signUp) ...[
                _LabelledField(
                  label: l10n.displayName,
                  controller: _name,
                  hint: l10n.namePlaceholder,
                  capitalize: true,
                  action: TextInputAction.next,
                  autofill: const [AutofillHints.name],
                ),
                const SizedBox(height: 10),
              ],
              _LabelledField(
                label: l10n.email,
                controller: _email,
                hint: l10n.emailPlaceholder,
                keyboard: TextInputType.emailAddress,
                action: TextInputAction.next,
                autofill: const [AutofillHints.email],
                onChanged: (_) => setState(() {}),
              ),
              const SizedBox(height: 10),
              _LabelledField(
                label: l10n.password,
                controller: _password,
                hint: l10n.passwordPlaceholder,
                obscure: true,
                action: TextInputAction.done,
                autofill: signUp
                    ? const [AutofillHints.newPassword]
                    : const [AutofillHints.password],
                onSubmitted: (_) => submit(),
                onChanged: (_) => setState(() {}),
              ),
            ],
          ),
        ),
        if (_error != null) ...[
          const SizedBox(height: 10),
          Text(
            _error!,
            style: theme.textTheme.labelMedium?.copyWith(color: tones.danger),
          ),
        ],
        if (_notice != null) ...[
          const SizedBox(height: 10),
          Text(
            _notice!,
            style: theme.textTheme.labelMedium
                ?.copyWith(color: theme.colorScheme.primary),
          ),
        ],
        if (!signUp) ...[
          const SizedBox(height: 6),
          Align(
            alignment: Alignment.centerLeft,
            child: TextButton(
              onPressed: _busy ? null : _reset,
              child: Text(l10n.forgotPassword),
            ),
          ),
        ],
      ],
    );
  }
}

class _ModeButton extends StatelessWidget {
  const _ModeButton({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Material(
      color: selected ? theme.colorScheme.primary : Colors.transparent,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          height: 44,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: selected
                  ? theme.colorScheme.primary
                  : theme.colorScheme.outline,
              width: 0.5,
            ),
          ),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 14,
              fontWeight: selected ? FontWeight.w500 : FontWeight.w400,
              color: selected
                  ? theme.colorScheme.onPrimary
                  : theme.colorScheme.onSurface,
            ),
          ),
        ),
      ),
    );
  }
}

class _LabelledField extends StatelessWidget {
  const _LabelledField({
    required this.label,
    required this.controller,
    this.hint,
    this.obscure = false,
    this.capitalize = false,
    this.keyboard,
    this.action,
    this.autofill,
    this.onChanged,
    this.onSubmitted,
  });

  final String label;
  final TextEditingController controller;
  final String? hint;
  final bool obscure;
  final bool capitalize;
  final TextInputType? keyboard;
  final TextInputAction? action;
  final Iterable<String>? autofill;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        KalorieSectionLabel(label, padding: const EdgeInsets.only(bottom: 6)),
        TextField(
          controller: controller,
          obscureText: obscure,
          keyboardType: keyboard,
          textInputAction: action,
          autofillHints: autofill,
          autocorrect: !obscure,
          enableSuggestions: !obscure,
          textCapitalization: capitalize
              ? TextCapitalization.words
              : TextCapitalization.none,
          decoration: InputDecoration(hintText: hint),
          onChanged: onChanged,
          onSubmitted: onSubmitted,
          onTapOutside: (_) =>
              FocusManager.instance.primaryFocus?.unfocus(),
        ),
      ],
    );
  }
}
