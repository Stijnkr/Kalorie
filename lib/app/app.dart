import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../core/l10n/generated/app_localizations.dart';
import '../data/local/collections/enums.dart';
import '../data/providers.dart';
import '../data/remote/off_mapper.dart';
import '../features/security/app_lock.dart';
import 'router.dart';
import 'theme.dart';

class KalorieApp extends ConsumerStatefulWidget {
  const KalorieApp({super.key, required this.onboardingDone});

  final bool onboardingDone;

  @override
  ConsumerState<KalorieApp> createState() => _KalorieAppState();
}

class _RouterRefresh extends ChangeNotifier {
  void ping() => notifyListeners();
}

class _KalorieAppState extends ConsumerState<KalorieApp>
    with WidgetsBindingObserver {
  final _refresh = _RouterRefresh();
  late final GoRouter router;
  bool _started = false;
  StreamSubscription<AuthState>? _authSub;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    router = createRouter(
      refresh: _refresh,
      signedIn: () => ref.read(isSignedInProvider),
      onboardingDone: () =>
          ref.read(settingsProvider).value?.onboardingDone ??
          widget.onboardingDone,
    );
  }

  @override
  void dispose() {
    _authSub?.cancel();
    WidgetsBinding.instance.removeObserver(this);
    router.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state != AppLifecycleState.resumed) return;
    _refreshStaleOff();
    if (ref.read(isSignedInProvider)) {
      ref.read(syncEngineProvider).run();
    }
    // Meldingen opnieuw plannen: wat vandaag al gelogd is, slaan we over.
    ref.read(reminderSchedulerProvider).sync();
  }

  void _listenForPasswordRecovery() {
    final auth = ref.read(authRepositoryProvider);
    if (!auth.isAvailable) return;
    _authSub?.cancel();
    _authSub = auth.changes.listen((state) {
      if (state.event != AuthChangeEvent.passwordRecovery) return;
      if (!mounted) return;
      if (router.routeInformationProvider.value.uri.path == '/auth/recover') {
        return;
      }
      router.push('/auth/recover');
    });
  }

  Future<void> _refreshStaleOff() async {
    try {
      final foods = await ref.read(foodRepositoryProvider).staleOffRecents(
            maxAge: const Duration(days: 7),
          );
      final remote = ref.read(offRemoteProvider);
      for (final food in foods) {
        final barcode = food.barcode;
        if (barcode == null || barcode.isEmpty) continue;
        final product = await remote.getByBarcode(barcode);
        if (product == null) continue;
        final mapped = mapOffProduct(product);
        if (mapped != null) {
          await ref.read(foodRepositoryProvider).cacheOffProduct(mapped);
        }
      }
    } catch (_) {
      // Offline of rate-limited: negeren. Lokale data blijft staan.
    }
  }

  /// Eén keer per start: synchroniseren en de meldingen bijwerken. Gebeurt
  /// vanuit `builder` zodat de vertalingen beschikbaar zijn.
  void _startBackgroundWork(BuildContext context) {
    if (_started) return;
    _started = true;
    final l10n = AppLocalizations.of(context);
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!mounted) return;
      final scheduler = ref.read(reminderSchedulerProvider)
        ..localizations = l10n;
      ref.read(diaryRepositoryProvider).afterWrite = scheduler.sync;
      ref.read(weightRepositoryProvider).afterWrite = scheduler.sync;
      _listenForPasswordRecovery();
      if (ref.read(isSignedInProvider)) {
        await ref.read(syncEngineProvider).run();
      }
      await scheduler.sync();
    });
  }

  @override
  Widget build(BuildContext context) {
    final settings = ref.watch(settingsProvider).value;
    final themeMode = switch (settings?.theme) {
      ThemeModeSetting.light => ThemeMode.light,
      ThemeModeSetting.dark => ThemeMode.dark,
      _ => ThemeMode.system,
    };

    ref.listen(isSignedInProvider, (previous, next) => _refresh.ping());
    ref.listen(settingsProvider, (previous, next) => _refresh.ping());

    return MaterialApp.router(
      title: 'Kalorie',
      debugShowCheckedModeBanner: false,
      theme: kalorieTheme(brightness: Brightness.light),
      darkTheme: kalorieTheme(brightness: Brightness.dark),
      themeMode: themeMode,
      routerConfig: router,
      locale: const Locale('nl'),
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      builder: (context, child) {
        _startBackgroundWork(context);
        return AppLockGate(child: child ?? const SizedBox.shrink());
      },
    );
  }
}
