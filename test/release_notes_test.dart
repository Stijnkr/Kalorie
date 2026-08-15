import 'package:flutter_test/flutter_test.dart';
import 'package:kalorie/features/updates/release_notes.dart';

void main() {
  test('vergelijkt semver op volgorde', () {
    expect(compareAppVersions('1.0.0', '1.0.0'), 0);
    expect(compareAppVersions('1.0.1', '1.0.0'), greaterThan(0));
    expect(compareAppVersions('1.0.0', '1.1.0'), lessThan(0));
    expect(compareAppVersions('2.0.0', '1.9.9'), greaterThan(0));
  });

  test('ongezien is alles als er nog niets is gemarkeerd', () {
    expect(unseenReleaseNotes(null), isNotEmpty);
    expect(hasUnseenReleaseNotes(null), isTrue);
  });

  test('huidige versie telt als gezien', () {
    final latest = kReleaseNotes.first.version;
    expect(unseenReleaseNotes(latest), isEmpty);
    expect(hasUnseenReleaseNotes(latest), isFalse);
  });
}
