import 'package:isar_community/isar.dart';

import '../local/collections/weight_entry.dart';

class WeightRepository {
  WeightRepository(this._isar);

  final Isar _isar;

  Stream<List<WeightEntry>> watchAll() {
    return _isar.weightEntries
        .where()
        .sortByDateKey()
        .watch(fireImmediately: true);
  }

  Future<WeightEntry?> latest() {
    return _isar.weightEntries.where().sortByDateKeyDesc().findFirst();
  }

  /// Eén meting per dag: opnieuw wegen overschrijft die van vandaag.
  Future<void> upsert(int dateKey, double kg) {
    return _isar.writeTxn(() async {
      final existing =
          await _isar.weightEntries.filter().dateKeyEqualTo(dateKey).findFirst();
      final entry = existing ?? WeightEntry();
      entry
        ..dateKey = dateKey
        ..kg = kg;
      await _isar.weightEntries.put(entry);
    });
  }

  Future<void> delete(int id) {
    return _isar.writeTxn(() => _isar.weightEntries.delete(id));
  }
}
