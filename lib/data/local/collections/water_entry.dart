import 'package:isar_community/isar.dart';

part 'water_entry.g.dart';

/// Aantal glazen water per dag. Eén glas is [WaterEntry.glassMl].
@Collection(accessor: 'waterEntries')
class WaterEntry {
  static const glassMl = 250;
  static const goalGlasses = 8;

  Id id = Isar.autoIncrement;

  @Index(unique: true, replace: true)
  late int dateKey;

  late int glasses;
}
