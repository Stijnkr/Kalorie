import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/l10n/generated/app_localizations.dart';
import '../../core/serving.dart';
import '../../data/local/collections/enums.dart';
import '../../data/local/collections/food.dart';
import '../../data/providers.dart';

/// Boekt een product met de laatst gebruikte portie en toont een toast met
/// "Ongedaan". Gebruikt door het logvel en het zoekscherm.
Future<void> quickLogFood(
  BuildContext context,
  WidgetRef ref, {
  required Food food,
  required MealType meal,
}) async {
  final l10n = AppLocalizations.of(context);
  final messenger = ScaffoldMessenger.of(context);
  final diary = ref.read(diaryRepositoryProvider);
  final grams = ServingMath.defaultGrams(
    lastAmountG: food.lastAmountG,
    servingG: food.servingG,
  );
  final amount = ServingMath.describeShort(
    grams: grams,
    servingG: food.servingG,
    servingLabel: food.servingLabel,
  );

  final id = await diary.add(
    food: food,
    amountG: grams,
    meal: meal,
    dateKey: ref.read(selectedDateKeyProvider),
  );
  await HapticFeedback.mediumImpact();

  messenger
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 5),
        content: Text(l10n.loggedSnack(food.name, amount)),
        action: SnackBarAction(
          label: l10n.undo,
          onPressed: () => diary.delete(id),
        ),
      ),
    );
}
