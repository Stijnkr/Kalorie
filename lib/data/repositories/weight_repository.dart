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

  Future<void> upsert(int dateKey, double kg) {
    final entry = WeightEntry()
      ..dateKey = dateKey
      ..kg = kg;
    return _isar.writeTxn(() => _isar.weightEntries.put(entry));
  }

  Future<void> delete(int id) {
    return _isar.writeTxn(() => _isar.weightEntries.delete(id));
  }
}
