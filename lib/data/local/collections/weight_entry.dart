import 'package:isar_community/isar.dart';

part 'weight_entry.g.dart';

@Collection(accessor: 'weightEntries')
class WeightEntry {
  Id id = Isar.autoIncrement;

  @Index(unique: true, replace: true)
  late int dateKey;

  late double kg;
}
