import '../data/local/collections/enums.dart';

abstract final class OffConfig {
  static const userAgent = 'Kalorie/0.1.0 (kalorie@stijnkroot.dev)';
  static const appName = 'Kalorie';
  static const appVersion = '0.1.0';
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

String normalizeName(String name) => name.trim().toLowerCase();
