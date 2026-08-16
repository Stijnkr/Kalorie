import 'package:flutter_test/flutter_test.dart';
import 'package:kalorie/core/energy.dart';

void main() {
  const man = EnergyProfile(
    sex: BiologicalSex.male,
    ageYears: 30,
    heightCm: 175,
    weightKg: 70,
    activity: ActivityLevel.sedentary,
    goal: WeightGoal.maintain,
  );

  test('Mifflin-St Jeor voor een man in rust', () {
    final estimate = EnergyEstimate.of(man);
    // 10*70 + 6.25*175 - 5*30 + 5 = 1648.75
    expect(estimate.bmr, 1649);
    expect(estimate.maintain, 1979);
    expect(estimate.target, 1979);
  });

  test('vrouw heeft een lagere BMR', () {
    final woman = EnergyEstimate.of(
      EnergyProfile(
        sex: BiologicalSex.female,
        ageYears: 30,
        heightCm: 165,
        weightKg: 65,
        activity: ActivityLevel.sedentary,
        goal: WeightGoal.maintain,
      ),
    );
    expect(woman.bmr, lessThan(EnergyEstimate.of(man).bmr));
  });

  test('sport verhoogt onderhoud', () {
    final sport = EnergyEstimate.of(
      EnergyProfile(
        sex: BiologicalSex.male,
        ageYears: 30,
        heightCm: 175,
        weightKg: 70,
        activity: ActivityLevel.high,
        goal: WeightGoal.maintain,
      ),
    );
    expect(sport.maintain, greaterThan(EnergyEstimate.of(man).maintain));
  });

  test('afvallen gaat onder onderhoud, niet onder de vloer', () {
    final lose = EnergyEstimate.of(
      EnergyProfile(
        sex: BiologicalSex.male,
        ageYears: 30,
        heightCm: 175,
        weightKg: 70,
        activity: ActivityLevel.sedentary,
        goal: WeightGoal.lose,
        pace: GoalPace.normal,
      ),
    );
    expect(lose.target, lessThan(lose.maintain));
    expect(lose.target, greaterThanOrEqualTo(1500));
  });

  test('ongeldige invoer wordt herkend', () {
    expect(
      const EnergyProfile(
        sex: BiologicalSex.female,
        ageYears: 8,
        heightCm: 175,
        weightKg: 70,
        activity: ActivityLevel.light,
        goal: WeightGoal.maintain,
      ).isValid,
      isFalse,
    );
  });
}
