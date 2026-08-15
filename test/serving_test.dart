import 'package:flutter_test/flutter_test.dart';
import 'package:kalorie/core/serving.dart';

void main() {
  test('converts portions to grams', () {
    expect(ServingMath.gramsFromPortions(2, 35), 70);
    expect(ServingMath.gramsFromPortions(1.5, 40), 60);
  });

  test('describes snapped portions', () {
    expect(
      ServingMath.describe(grams: 70, servingG: 35, servingLabel: '1 snee'),
      '2 × 1 snee (70 g)',
    );
    expect(
      ServingMath.describe(grams: 17.5, servingG: 35, servingLabel: '1 snee'),
      '0,5 × 1 snee (18 g)',
    );
  });

  test('falls back to grams when not a clean portion', () {
    expect(
      ServingMath.describe(grams: 40, servingG: 35, servingLabel: '1 snee'),
      '40 g',
    );
  });

  test('describeShort toont compacte portie', () {
    expect(
      ServingMath.describeShort(
        grams: 40,
        servingG: 40,
        servingLabel: '1 portie',
      ),
      '1 portie',
    );
    expect(
      ServingMath.describeShort(
        grams: 80,
        servingG: 40,
        servingLabel: '1 portie',
      ),
      '2 × 1 portie',
    );
    expect(
      ServingMath.describeShort(grams: 90, servingG: 40, servingLabel: '1 portie'),
      '90 g',
    );
  });

  test('defaultGrams gebruikt laatste hoeveelheid', () {
    expect(ServingMath.defaultGrams(lastAmountG: 125, servingG: 40), 125);
    expect(ServingMath.defaultGrams(servingG: 40), 40);
    expect(ServingMath.defaultGrams(), 100);
  });
}
