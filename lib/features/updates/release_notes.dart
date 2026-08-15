class ReleaseNote {
  const ReleaseNote({
    required this.version,
    required this.date,
    required this.items,
  });

  final String version;
  final DateTime date;

  /// Punten in het Nederlands. Nieuwe versies voeg je hier toe, bovenaan.
  final List<String> items;
}

/// Nieuwste eerst. De bovenste versie die nieuwer is dan
/// `seenReleaseNotes` triggert de melding in de app.
final kReleaseNotes = <ReleaseNote>[
  ReleaseNote(
    version: '1.0.1',
    date: DateTime(2026, 8, 15),
    items: [
      'Vergrendeling met Face ID of je toegangscode.',
      'Logboek is niet leesbaar in de appwisselaar.',
      'Sterker wachtwoord. Verwijderen van je account sluit alle sessies.',
    ],
  ),
  ReleaseNote(
    version: '1.0.0',
    date: DateTime(2026, 8, 15),
    items: [
      'Eerste versie: logboek, NEVO, scannen, recepten en herinneringen.',
      'Account bewaart je dag op al je toestellen.',
      'Stuur feedback vanuit Meer. Ik lees alles.',
    ],
  ),
];

int compareAppVersions(String a, String b) {
  List<int> parts(String raw) {
    return raw.split('.').map(int.tryParse).whereType<int>().toList();
  }

  final left = parts(a);
  final right = parts(b);
  final n = left.length > right.length ? left.length : right.length;
  for (var i = 0; i < n; i++) {
    final da = i < left.length ? left[i] : 0;
    final db = i < right.length ? right[i] : 0;
    if (da != db) return da.compareTo(db);
  }
  return 0;
}

List<ReleaseNote> unseenReleaseNotes(String? seen) {
  if (seen == null || seen.isEmpty) return List<ReleaseNote>.of(kReleaseNotes);
  return kReleaseNotes
      .where((note) => compareAppVersions(note.version, seen) > 0)
      .toList();
}

bool hasUnseenReleaseNotes(String? seen) => unseenReleaseNotes(seen).isNotEmpty;
