import '../data/food/match_key.dart';
import '../data/local/collections/enums.dart';

abstract final class OffConfig {
  static const userAgent = 'Kalorie/0.1.0 (kalorie@stijnkroot.dev)';
  static const appName = 'Kalorie';
  static const appVersion = '0.1.0';
}

abstract final class CatalogConfig {
  /// Public catalog only (anon). Override with `--dart-define`.
  static const supabaseUrl = String.fromEnvironment(
    'KALORIE_SUPABASE_URL',
    defaultValue: 'https://ugtxzaitggkhqsqbzgaz.supabase.co',
  );
  static const supabaseAnonKey = String.fromEnvironment(
    'KALORIE_SUPABASE_ANON_KEY',
    defaultValue:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InVndHh6YWl0Z2draHFzcWJ6Z2F6Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3ODY3OTU4ODcsImV4cCI6MjEwMjM3MTg4N30.KXEuuk0antxivyrqc_vCshp7QOIYrq95XCAj4_uWhbI',
  );

  static bool get isConfigured =>
      supabaseUrl.isNotEmpty && supabaseAnonKey.isNotEmpty;
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
