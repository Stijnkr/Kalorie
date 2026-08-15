import 'package:isar_community/isar.dart';

import '../local/collections/weight_entry.dart';

class WeightRepository {
  WeightRepository(this._isar);

  final Isar _isar;

  void Function()? afterWrite;

  void _notify() => afterWrite?.call();

  Stream<List<WeightEntry>> watchAll() {
    return _isar.weightEntries
        .filter()
        .deletedEqualTo(false)
        .sortByDateKey()
        .watch(fireImmediately: true);
  }

  Future<WeightEntry?> latest() {
    return _isar.weightEntries
        .filter()
        .deletedEqualTo(false)
        .sortByDateKeyDesc()
        .findFirst();
  }

  /// Eén meting per dag: opnieuw wegen overschrijft die van vandaag.
  Future<void> upsert(int dateKey, double kg) async {
    await _isar.writeTxn(() async {
      final existing =
          await _isar.weightEntries.filter().dateKeyEqualTo(dateKey).findFirst();
      final entry = existing ?? WeightEntry();
      entry
        ..dateKey = dateKey
        ..kg = kg
        ..deleted = false
        ..dirty = true
        ..updatedAt = DateTime.now();
      await _isar.weightEntries.put(entry);
    });
    _notify();
  }

  Future<void> delete(int id) async {
    await _isar.writeTxn(() async {
      final entry = await _isar.weightEntries.get(id);
      if (entry == null) return;
      entry
        ..deleted = true
        ..dirty = true
        ..updatedAt = DateTime.now();
      await _isar.weightEntries.put(entry);
    });
    _notify();
  }

  Future<bool> hasEntryFor(int dateKey) async {
    final count = await _isar.weightEntries
        .filter()
        .dateKeyEqualTo(dateKey)
        .and()
        .deletedEqualTo(false)
        .count();
    return count > 0;
  }
}
