import 'package:isar_community/isar.dart';

import '../local/collections/water_entry.dart';

class WaterRepository {
  WaterRepository(this._isar);

  final Isar _isar;

  Stream<int> watchDay(int dateKey) {
    return _isar.waterEntries
        .filter()
        .dateKeyEqualTo(dateKey)
        .and()
        .deletedEqualTo(false)
        .watch(fireImmediately: true)
        .map((rows) => rows.isEmpty ? 0 : rows.first.glasses);
  }

  Future<void> setGlasses(int dateKey, int glasses) {
    final clamped = glasses.clamp(0, 24);
    return _isar.writeTxn(() async {
      final existing =
          await _isar.waterEntries.filter().dateKeyEqualTo(dateKey).findFirst();
      final entry = existing ?? WaterEntry();
      entry
        ..dateKey = dateKey
        ..glasses = clamped
        ..deleted = false
        ..dirty = true
        ..updatedAt = DateTime.now();
      await _isar.waterEntries.put(entry);
    });
  }
}
