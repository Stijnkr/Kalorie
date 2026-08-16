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
      '2 sneetjes (70 g)',
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
      '2 porties',
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

  test('defaultGrams kiest 1 ei als het product geen portie heeft', () {
    expect(ServingMath.defaultGrams(name: 'Ei kippen- gekookt gem'), 50);
  });

  test('herkent melk als vloeibaar', () {
    expect(ServingMath.looksLiquid(name: 'Melk halfvolle'), isTrue);
    expect(ServingMath.looksLiquid(name: 'Tarwebrood volkoren'), isFalse);
  });

  test('suggereert glas bij melk', () {
    final chips = ServingMath.suggestionsFor(name: 'Melk halfvolle');
    expect(chips.map((c) => c.label), contains('glas'));
  });

  test('ei krijgt 1/2/3 eieren, geen snee of glas', () {
    final chips = ServingMath.suggestionsFor(
      name: 'Ei kippen- gekookt gem',
      servingG: 50,
      servingLabel: '1 ei',
    );
    expect(chips.map((c) => c.chipLabel).toList(), ['1 ei', '2 eieren', '3 eieren']);
    expect(chips.map((c) => c.grams.round()).toList(), [50, 100, 150]);
    expect(chips.any((c) => c.label == 'snee' || c.label == 'glas'), isFalse);
  });

  test('ei zonder catalogusportie wordt alsnog als ei behandeld', () {
    final chips = ServingMath.suggestionsFor(name: 'Scharreleieren klasse M');
    expect(chips.map((c) => c.chipLabel).toList(), ['1 ei', '2 eieren', '3 eieren']);
    expect(chips.first.grams, 50);
  });

  test('bami met ei is geen eierportie', () {
    final chips = ServingMath.suggestionsFor(
      name: 'Bami goreng z ei',
      servingG: 250,
      servingLabel: '1 portie',
    );
    expect(chips.map((c) => c.label), isNot(contains('ei')));
  });

  test('eiwitreep is geen ei', () {
    final chips = ServingMath.suggestionsFor(
      name: 'Eiwitreep m pinda',
      servingG: 30,
      servingLabel: '1 reep',
    );
    expect(chips.map((c) => c.label), isNot(contains('ei')));
    expect(chips.first.label, 'reep');
  });

  test('oude omelet-portie van 250 g biedt nog steeds 1 ei', () {
    final chips = ServingMath.suggestionsFor(
      name: 'Omelet/roerei',
      servingG: 250,
      servingLabel: '1 portie',
    );
    expect(chips.map((c) => c.chipLabel), containsAll(['1 omelet', '1 ei']));
    expect(chips.firstWhere((c) => c.label == 'ei').grams, 50);
  });

  test('omelet krijgt omelet-maten, geen keukenla', () {
    final chips = ServingMath.suggestionsFor(
      name: 'Omelet/roerei',
      servingG: 120,
      servingLabel: '1 omelet',
    );
    expect(
      chips.map((c) => c.chipLabel),
      containsAll(['1 omelet', '½ omelet', '1 ei', '2 eieren']),
    );
    expect(chips.any((c) => c.label == 'snee' || c.label == 'glas'), isFalse);
  });

  test('kaas krijgt plakken', () {
    final chips = ServingMath.suggestionsFor(
      name: 'Kaas 30+ jong',
      servingG: 20,
      servingLabel: '1 plak',
    );
    expect(chips.map((c) => c.chipLabel).take(3).toList(), [
      '1 plak',
      '2 plakken',
      '3 plakken',
    ]);
  });

  test('brood krijgt sneetjes', () {
    final chips = ServingMath.suggestionsFor(
      name: 'Tarwebrood volkoren',
      servingG: 35,
      servingLabel: '1 snee',
    );
    expect(chips.map((c) => c.chipLabel).take(2).toList(), [
      '1 snee',
      '2 sneetjes',
    ]);
  });

  test('onbekend product dumpt geen snee/glas/kom', () {
    final chips = ServingMath.suggestionsFor(
      name: 'Iets onbekends',
      servingG: 100,
      servingLabel: '1 portie',
    );
    expect(chips.map((c) => c.chipLabel).toList(), ['1 portie', '½ portie']);
  });

  test('halve paprika wordt ½ stuk en 1 stuk', () {
    final chips = ServingMath.suggestionsFor(
      name: 'Paprika rauw',
      servingG: 75,
      servingLabel: '1/2 stuk',
    );
    expect(chips.map((c) => c.chipLabel).take(2).toList(), ['½ stuk', '1 stuk']);
    expect(chips[0].grams, 75);
    expect(chips[1].grams, 150);
  });

  test('beschrijft 2 eieren met meervoud', () {
    expect(
      ServingMath.describe(grams: 100, servingG: 50, servingLabel: '1 ei'),
      '2 eieren (100 g)',
    );
  });

  test('theelepel is geen drank', () {
    expect(ServingMath.looksLiquid(servingLabel: '1 theelepel'), isFalse);
    expect(ServingMath.looksLiquid(name: 'Peper zwart', servingLabel: '1 theelepel'), isFalse);
    final chips = ServingMath.suggestionsFor(
      name: 'Peper zwart',
      servingG: 2,
      servingLabel: '1 theelepel',
    );
    expect(chips.any((c) => c.label == 'glas'), isFalse);
  });

  test('soep is een kom, geen glas', () {
    expect(ServingMath.looksLiquid(name: 'Tomatensoep'), isFalse);
    final chips = ServingMath.suggestionsFor(
      name: 'Tomatensoep',
      servingG: 250,
      servingLabel: '1 kom',
    );
    expect(chips.first.chipLabel, '1 kom');
    expect(chips.any((c) => c.label == 'glas'), isFalse);
  });

  test('watermeloen is geen water', () {
    expect(ServingMath.looksLiquid(name: 'Watermeloen'), isFalse);
  });

  test('eipoeder en Eier worden als ei herkend', () {
    final powder = ServingMath.suggestionsFor(name: 'Eipoeder kippen-');
    expect(powder.first.label, 'eetlepel');
    expect(powder.first.grams, 10);
    final german = ServingMath.suggestionsFor(name: 'Eier');
    expect(german.map((c) => c.chipLabel).toList(), ['1 ei', '2 eieren', '3 eieren']);
    final cooked = ServingMath.suggestionsFor(name: 'gebakken ei');
    expect(cooked.first.chipLabel, '1 ei');
  });

  test('eidooier en eiwit krijgen stukjes van de catalogus', () {
    final yolk = ServingMath.suggestionsFor(
      name: 'Eidooier kippen- rauw',
      servingG: 17,
      servingLabel: '1 stuk',
    );
    expect(yolk.map((c) => c.chipLabel).take(3).toList(), [
      '1 dooier',
      '2 dooiers',
      '3 dooiers',
    ]);
    final white = ServingMath.suggestionsFor(
      name: 'Eiwit kippenei rauw',
      servingG: 33,
      servingLabel: '1 stuk',
    );
    expect(white.first.chipLabel, '1 eiwit');
    expect(white.first.grams, 33);
  });

  test('eiersalade is geen ei', () {
    final chips = ServingMath.suggestionsFor(
      name: 'Salade ei- lunch/borrel',
      servingG: 20,
      servingLabel: '1 eetlepel',
    );
    expect(chips.map((c) => c.label), isNot(contains('ei')));
    expect(chips.first.label, 'eetlepel');
  });

  test('eiwitreep met pinda is een reep, geen handje noten', () {
    final chips = ServingMath.suggestionsFor(
      name: 'Eiwitreep m pinda',
      servingG: 30,
      servingLabel: '1 reep',
    );
    expect(chips.map((c) => c.label).toSet(), {'reep'});
  });

  test('kip van 70 g wordt geen 2 sneetjes', () {
    expect(
      ServingMath.describe(
        grams: 70,
        servingG: 100,
        servingLabel: '1 portie',
        name: 'Kipfilet bereid',
      ),
      '70 g',
    );
  });

  test('halve paprika wordt in het dagboek ½ stuk', () {
    expect(
      ServingMath.describe(
        grams: 75,
        servingG: 75,
        servingLabel: '1/2 stuk',
        name: 'Paprika rauw',
      ),
      '½ stuk (75 g)',
    );
    expect(
      ServingMath.describe(
        grams: 150,
        servingG: 75,
        servingLabel: '1/2 stuk',
        name: 'Paprika rauw',
      ),
      '1 stuk (150 g)',
    );
  });

  test('verouderde omelet van 250 g valt terug op 120 g', () {
    expect(
      ServingMath.defaultGrams(
        name: 'Omelet/roerei',
        servingG: 250,
        servingLabel: '1 portie',
      ),
      120,
    );
    final chips = ServingMath.suggestionsFor(
      name: 'Omelet/roerei',
      servingG: 250,
      servingLabel: '1 portie',
    );
    expect(chips.first.chipLabel, '1 omelet');
    expect(chips.first.grams, 120);
    expect(
      ServingMath.describe(
        grams: 50,
        servingG: 250,
        servingLabel: '1 portie',
        name: 'Omelet/roerei',
      ),
      '1 ei (50 g)',
    );
  });
}
