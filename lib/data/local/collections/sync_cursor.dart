import 'package:isar_community/isar.dart';

part 'sync_cursor.g.dart';

/// Onthoudt per tabel tot welk moment we al opgehaald hebben, en voor welke
/// gebruiker. Wisselt de gebruiker, dan zijn de cursors niets waard.
@Collection(accessor: 'syncCursors')
class SyncCursor {
  Id id = Isar.autoIncrement;

  @Index(unique: true, replace: true)
  late String table;

  late String userId;

  DateTime? pulledUpTo;
}
