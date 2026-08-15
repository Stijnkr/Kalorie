import 'package:flutter_test/flutter_test.dart';
import 'package:kalorie/core/serving.dart';

void main() {
  test('converts portions to grams', () {
    expect(ServingMath.gramsFromPortions(2, 35), 70);
    expect(ServingMath.gramsFromPortions(1.5, 40), 60);
  });

  test('describes Dutch portions without 2 × 1 snee', () {
    expect(
      ServingMath.describe(grams: 70, servingG: 35, servingLabel: '1 snee'),
      '2 snee (70 g)',
    );
    expect(
      ServingMath.describe(grams: 35, servingG: 35, servingLabel: 'snee'),
      '1 snee (35 g)',
    );
    expect(
      ServingMath.describe(grams: 200, liquid: true),
      '1 glas (200 ml)',
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
      '2 portie',
    );
    expect(
      ServingMath.describeShort(grams: 90, servingG: 40, servingLabel: '1 portie'),
      '90 g',
    );
  });

  test('defaultGrams gebruikt laatste hoeveelheid of glas bij drank', () {
    expect(ServingMath.defaultGrams(lastAmountG: 125, servingG: 40), 125);
    expect(ServingMath.defaultGrams(servingG: 40), 40);
    expect(ServingMath.defaultGrams(), 100);
    expect(ServingMath.defaultGrams(liquid: true), 200);
  });

  test('herkent melk als vloeibaar', () {
    expect(ServingMath.looksLiquid(name: 'Melk halfvolle'), isTrue);
    expect(ServingMath.looksLiquid(name: 'Tarwebrood volkoren'), isFalse);
  });

  test('suggereert glas bij melk', () {
    final chips = ServingMath.suggestionsFor(name: 'Melk halfvolle');
    expect(chips.map((c) => c.label), contains('glas'));
  });
}
