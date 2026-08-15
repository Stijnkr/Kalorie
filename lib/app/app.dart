import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import '../core/l10n/generated/app_localizations.dart';
import '../data/local/collections/enums.dart';
import '../data/providers.dart';
import '../data/remote/off_mapper.dart';
import 'router.dart';
import 'theme.dart';

class KalorieApp extends ConsumerStatefulWidget {
  const KalorieApp({super.key, required this.onboardingDone});

  final bool onboardingDone;

  @override
  ConsumerState<KalorieApp> createState() => _KalorieAppState();
}

class _KalorieAppState extends ConsumerState<KalorieApp>
    with WidgetsBindingObserver {
  late final router = createRouter(onboardingDone: widget.onboardingDone);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    router.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _refreshStaleOff();
    }
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
      // Offline or rate-limited: ignore. Local data stays.
    }
  }

  @override
  Widget build(BuildContext context) {
    final settings = ref.watch(settingsProvider).value;
    final themeMode = switch (settings?.theme) {
      ThemeModeSetting.light => ThemeMode.light,
      ThemeModeSetting.dark => ThemeMode.dark,
      _ => ThemeMode.system,
    };

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
    );
  }
}
