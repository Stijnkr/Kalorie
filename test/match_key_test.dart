import 'package:flutter_test/flutter_test.dart';
import 'package:kalorie/data/food/match_key.dart';

void main() {
  test('unaccent en leestekens', () {
    expect(MatchKey.normalizeSearch('Crème brûlée!'), 'creme brulee');
  });

  test('match_key stript inhoudsmaat en stopwoorden', () {
    expect(
      MatchKey.matchKey('Campina', 'Halfvolle melk 1L'),
      'campina|halfvolle melk',
    );
  });

  test('barcode UPC naar EAN-13', () {
    expect(MatchKey.normalizeBarcode('123456789012'), '0123456789012');
  });
}
