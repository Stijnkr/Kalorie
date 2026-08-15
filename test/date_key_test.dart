import 'package:flutter_test/flutter_test.dart';
import 'package:kalorie/core/constants.dart';

void main() {
  test('dateKey uses local calendar date', () {
    expect(DateKeys.fromDateTime(DateTime(2026, 8, 15, 23, 59)), 20260815);
  });

  test('addDays crosses year boundary', () {
    expect(DateKeys.addDays(20260101, -1), 20251231);
  });
}
