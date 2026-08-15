import 'package:flutter_test/flutter_test.dart';
import 'package:kalorie/core/password.dart';

void main() {
  test('wijst te korte en platte wachtwoorden af', () {
    expect(PasswordRules.isStrong('kort'), isFalse);
    expect(PasswordRules.isStrong('aaaaaaaaaa'), isFalse);
    expect(
      PasswordRules.isStrong('jij@voorbeeld.nl', email: 'jij@voorbeeld.nl'),
      isFalse,
    );
  });

  test('accepteert een gewoon lang wachtwoord', () {
    expect(PasswordRules.isStrong('havermout42'), isTrue);
    expect(PasswordRules.isStrong('dit is een zin'), isTrue);
  });
}
