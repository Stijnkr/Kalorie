import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:local_auth/local_auth.dart';

import '../../app/theme.dart';
import '../../core/l10n/generated/app_localizations.dart';
import '../../data/local/collections/app_settings.dart';
import '../../data/providers.dart';

/// Vraagt Face ID / toegangscode. `false` als het toestel dat niet kan.
Future<bool> authenticateAppLock(String reason) async {
  final auth = LocalAuthentication();
  try {
    final supported = await auth.isDeviceSupported();
    if (!supported) return false;
    return await auth.authenticate(
      localizedReason: reason,
      options: const AuthenticationOptions(
        stickyAuth: true,
        biometricOnly: false,
        useErrorDialogs: true,
      ),
    );
  } on PlatformException {
    return false;
  }
}

/// Deksel over de app: bij starten en na een paar seconden op de achtergrond.
class AppLockGate extends ConsumerStatefulWidget {
  const AppLockGate({super.key, required this.child});

  final Widget child;

  @override
  ConsumerState<AppLockGate> createState() => _AppLockGateState();
}

class _AppLockGateState extends ConsumerState<AppLockGate>
    with WidgetsBindingObserver {
  static const _grace = Duration(seconds: 8);

  bool _locked = false;
  bool _prompting = false;
  DateTime? _leftAt;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) => _considerLock());
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  bool get _shouldLock {
    final settings = ref.read(settingsProvider).value;
    if (settings == null) return false;
    return settings.onboardingDone && settings.lockEnabled;
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.inactive ||
        state == AppLifecycleState.hidden ||
        state == AppLifecycleState.paused) {
      _leftAt = DateTime.now();
    }
    if (state == AppLifecycleState.resumed) {
      final away = _leftAt == null
          ? Duration.zero
          : DateTime.now().difference(_leftAt!);
      if (away >= _grace) _considerLock();
    }
  }

  Future<void> _considerLock() async {
    if (!_shouldLock) {
      if (_locked && mounted) setState(() => _locked = false);
      return;
    }
    if (_locked || _prompting) return;
    setState(() => _locked = true);
    await _unlock();
  }

  Future<void> _unlock() async {
    if (_prompting || !mounted) return;
    final l10n = AppLocalizations.of(context);
    setState(() => _prompting = true);
    final ok = await authenticateAppLock(l10n.appLockReason);
    if (!mounted) return;
    setState(() {
      _prompting = false;
      if (ok) _locked = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(settingsProvider, (previous, next) {
      final enabled = next.value?.lockEnabled ?? true;
      final done = next.value?.onboardingDone ?? false;
      if (!enabled || !done) {
        if (_locked) setState(() => _locked = false);
      } else if (previous?.value?.lockEnabled == false && enabled) {
        _considerLock();
      }
    });

    return Stack(
      fit: StackFit.expand,
      children: [
        widget.child,
        if (_locked) _LockCover(busy: _prompting, onUnlock: _unlock),
      ],
    );
  }
}

class _LockCover extends StatelessWidget {
  const _LockCover({required this.busy, required this.onUnlock});

  final bool busy;
  final VoidCallback onUnlock;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    return ColoredBox(
      color: theme.scaffoldBackgroundColor,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(32, 48, 32, 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Spacer(),
              Text('Kalorie', style: theme.textTheme.headlineLarge),
              const SizedBox(height: 10),
              Text(
                l10n.appLockBody,
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: context.tones.hint,
                  height: 1.45,
                ),
              ),
              const Spacer(),
              FilledButton(
                onPressed: busy ? null : onUnlock,
                child: busy
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : Text(l10n.appLockUnlock),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
