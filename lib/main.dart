import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app/app.dart';
import 'app/bootstrap.dart';
import 'data/local/collections/app_settings.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final isar = await KalorieBootstrap.init();
  final settings = await isar.settings.get(1);
  runApp(
    ProviderScope(
      child: KalorieApp(onboardingDone: settings?.onboardingDone ?? false),
    ),
  );
}
