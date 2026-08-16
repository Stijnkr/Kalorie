import 'macro_goals.dart';

enum BiologicalSex { female, male }

/// Hoeveel iemand beweegt, als PAL-factor op de BMR.
enum ActivityLevel {
  sedentary(1.2),
  light(1.375),
  moderate(1.55),
  high(1.725);

  const ActivityLevel(this.pal);
  final double pal;
}

enum WeightGoal { lose, maintain, gain }

enum GoalPace { calm, normal, fast }

/// Invoer voor de schatting. Alles blijft handmatig overschrijfbaar.
class EnergyProfile {
  const EnergyProfile({
    required this.sex,
    required this.ageYears,
    required this.heightCm,
    required this.weightKg,
    required this.activity,
    required this.goal,
    this.pace = GoalPace.normal,
  });

  final BiologicalSex sex;
  final int ageYears;
  final double heightCm;
  final double weightKg;
  final ActivityLevel activity;
  final WeightGoal goal;
  final GoalPace pace;

  bool get isValid =>
      ageYears >= 14 &&
      ageYears <= 100 &&
      heightCm >= 120 &&
      heightCm <= 230 &&
      weightKg >= 35 &&
      weightKg <= 250;
}

class EnergyEstimate {
  const EnergyEstimate({
    required this.bmr,
    required this.maintain,
    required this.target,
    required this.macros,
  });

  /// Basale stofwisseling, Mifflin-St Jeor.
  final int bmr;

  /// Onderhoud (TDEE).
  final int maintain;

  /// Dagdoel na richting en tempo.
  final int target;

  final MacroGoals macros;

  static const minKcal = 1200;
  static const maxKcal = 6000;

  /// 1 kg lichaamsvet ≈ 7700 kcal.
  static const kcalPerKg = 7700.0;

  static EnergyEstimate of(EnergyProfile profile) {
    final bmr = _bmr(profile);
    final maintain = (bmr * profile.activity.pal).round();
    final target = _target(
      profile: profile,
      bmr: bmr,
      maintain: maintain,
    );
    return EnergyEstimate(
      bmr: bmr.round(),
      maintain: maintain,
      target: target,
      macros: _macros(profile, target),
    );
  }

  /// Mifflin-St Jeor: 10·kg + 6,25·cm − 5·jaar + s.
  static double _bmr(EnergyProfile profile) {
    final s = profile.sex == BiologicalSex.male ? 5.0 : -161.0;
    return 10 * profile.weightKg + 6.25 * profile.heightCm - 5 * profile.ageYears + s;
  }

  static int _deltaFor(GoalPace pace) {
    final kgPerWeek = switch (pace) {
      GoalPace.calm => 0.25,
      GoalPace.normal => 0.5,
      GoalPace.fast => 0.75,
    };
    return (kgPerWeek * kcalPerKg / 7).round();
  }

  static int _floor(EnergyProfile profile, double bmr) {
    final bySex = profile.sex == BiologicalSex.male ? 1500 : 1200;
    final byBmr = (bmr * 1.05).round();
    return [bySex, byBmr, minKcal].reduce((a, b) => a > b ? a : b);
  }

  static int _target({
    required EnergyProfile profile,
    required double bmr,
    required int maintain,
  }) {
    if (profile.goal == WeightGoal.maintain) {
      return maintain.clamp(minKcal, maxKcal);
    }
    final delta = _deltaFor(profile.pace);
    final raw = profile.goal == WeightGoal.lose
        ? maintain - delta
        : maintain + delta;
    if (profile.goal == WeightGoal.lose) {
      return raw.clamp(_floor(profile, bmr), maxKcal);
    }
    return raw.clamp(minKcal, maxKcal);
  }

  /// Eiwit naar lichaamsgewicht, vet ~0,8 g/kg, rest koolhydraten.
  static MacroGoals _macros(EnergyProfile profile, int target) {
    final proteinPerKg = switch (profile.goal) {
      WeightGoal.lose => 1.8,
      WeightGoal.maintain => 1.6,
      WeightGoal.gain => 1.8,
    };
    final protein = (profile.weightKg * proteinPerKg).clamp(80.0, 220.0);
    final fat = (profile.weightKg * 0.8).clamp(40.0, 140.0);
    final leftover =
        target - protein * MacroGoals.kcalPerGramProtein - fat * MacroGoals.kcalPerGramFat;
    final carbs = (leftover / MacroGoals.kcalPerGramCarbs).clamp(80.0, 700.0);
    return MacroGoals(
      protein: MacroGoals.roundGrams(protein),
      carbs: MacroGoals.roundGrams(carbs),
      fat: MacroGoals.roundGrams(fat),
    );
  }
}
