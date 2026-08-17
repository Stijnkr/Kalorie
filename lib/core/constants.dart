import '../data/food/match_key.dart';
import '../data/local/collections/enums.dart';

abstract final class AppInfo {
  static const name = 'Kalorie';
  static const version = '1.0.1';
  static const supportEmail = 'kalorie@stijnkroot.dev';
}

abstract final class OffConfig {
  static const userAgent = '${AppInfo.name}/${AppInfo.version} (${AppInfo.supportEmail})';
  static const appName = AppInfo.name;
  static const appVersion = AppInfo.version;
}

/// Verbinding met een Supabase-project, voor de productcatalogus en voor
/// account en synchronisatie.
///
/// Bewust zonder standaardwaarden: wie deze repo kloont en `flutter run` doet,
/// praat met niemand. De app start dan gewoon op en werkt volledig lokaal.
/// Geef je eigen project mee met `--dart-define-from-file=kalorie.env.json`
/// of met losse `--dart-define`-vlaggen. Zie de README.
abstract final class CatalogConfig {
  static const supabaseUrl = String.fromEnvironment('KALORIE_SUPABASE_URL');

  /// Legacy anon-sleutel, gebruikt door de catalogus-HTTP.
  static const supabaseAnonKey =
      String.fromEnvironment('KALORIE_SUPABASE_ANON_KEY');

  /// Publiceerbare sleutel voor de Supabase-client (auth en synchronisatie).
  static const supabasePublishableKey =
      String.fromEnvironment('KALORIE_SUPABASE_PUBLISHABLE_KEY');

  /// Kan de app de online productcatalogus bevragen?
  static bool get isConfigured =>
      supabaseUrl.isNotEmpty && supabaseAnonKey.isNotEmpty;

  /// Kan de app een account gebruiken en synchroniseren?
  static bool get isCloudConfigured =>
      supabaseUrl.isNotEmpty && supabasePublishableKey.isNotEmpty;
}

abstract final class DateKeys {
  static int fromDateTime(DateTime dateTime) {
    final local = DateTime(dateTime.year, dateTime.month, dateTime.day);
    return local.year * 10000 + local.month * 100 + local.day;
  }

  static int today() => fromDateTime(DateTime.now());

  static DateTime toDateTime(int dateKey) {
    final year = dateKey ~/ 10000;
    final month = (dateKey ~/ 100) % 100;
    final day = dateKey % 100;
    return DateTime(year, month, day);
  }

  static int addDays(int dateKey, int days) {
    return fromDateTime(toDateTime(dateKey).add(Duration(days: days)));
  }

  static List<int> weekContaining(int dateKey) {
    final date = toDateTime(dateKey);
    final monday = date.subtract(Duration(days: date.weekday - 1));
    return List.generate(7, (i) => fromDateTime(monday.add(Duration(days: i))));
  }
}

abstract final class NutrientMath {
  static double scale(double per100g, double grams) => per100g * grams / 100;

  static double? scaleOrNull(double? per100g, double grams) =>
      per100g == null ? null : scale(per100g, grams);

  /// Schaal een vastgelegde waarde van de ene hoeveelheid naar de andere.
  static double rescale(double value, double fromGrams, double toGrams) {
    if (fromGrams <= 0) return value;
    return value * toGrams / fromGrams;
  }

  static double? rescaleOrNull(
    double? value,
    double fromGrams,
    double toGrams,
  ) {
    if (value == null) return null;
    return rescale(value, fromGrams, toGrams);
  }

  static int roundKcal(double kcal) => kcal.round();

  static double roundMacro(double grams) =>
      (grams * 10).roundToDouble() / 10;
}

MealType mealForNow([DateTime? now]) {
  final hour = (now ?? DateTime.now()).hour;
  if (hour >= 5 && hour < 11) return MealType.breakfast;
  if (hour >= 11 && hour < 14) return MealType.lunch;
  if (hour >= 17 && hour < 22) return MealType.dinner;
  return MealType.snack;
}

String normalizeName(String name) => MatchKey.normalizeSearch(name);
