// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'water_entry.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetWaterEntryCollection on Isar {
  IsarCollection<WaterEntry> get waterEntries => this.collection();
}

const WaterEntrySchema = CollectionSchema(
  name: r'WaterEntry',
  id: 7610063248208069204,
  properties: {
    r'dateKey': PropertySchema(id: 0, name: r'dateKey', type: IsarType.long),
    r'glasses': PropertySchema(id: 1, name: r'glasses', type: IsarType.long),
  },

  estimateSize: _waterEntryEstimateSize,
  serialize: _waterEntrySerialize,
  deserialize: _waterEntryDeserialize,
  deserializeProp: _waterEntryDeserializeProp,
  idName: r'id',
  indexes: {
    r'dateKey': IndexSchema(
      id: 7975223786082927131,
      name: r'dateKey',
      unique: true,
      replace: true,
      properties: [
        IndexPropertySchema(
          name: r'dateKey',
          type: IndexType.value,
          caseSensitive: false,
        ),
      ],
    ),
  },
  links: {},
  embeddedSchemas: {},

  getId: _waterEntryGetId,
  getLinks: _waterEntryGetLinks,
  attach: _waterEntryAttach,
  version: '3.3.2',
);

int _waterEntryEstimateSize(
  WaterEntry object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  return bytesCount;
}

void _waterEntrySerialize(
  WaterEntry object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeLong(offsets[0], object.dateKey);
  writer.writeLong(offsets[1], object.glasses);
}

WaterEntry _waterEntryDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = WaterEntry();
  object.dateKey = reader.readLong(offsets[0]);
  object.glasses = reader.readLong(offsets[1]);
  object.id = id;
  return object;
}

P _waterEntryDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readLong(offset)) as P;
    case 1:
      return (reader.readLong(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _waterEntryGetId(WaterEntry object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _waterEntryGetLinks(WaterEntry object) {
  return [];
}

void _waterEntryAttach(IsarCollection<dynamic> col, Id id, WaterEntry object) {
  object.id = id;
}

extension WaterEntryByIndex on IsarCollection<WaterEntry> {
  Future<WaterEntry?> getByDateKey(int dateKey) {
    return getByIndex(r'dateKey', [dateKey]);
  }

  WaterEntry? getByDateKeySync(int dateKey) {
    return getByIndexSync(r'dateKey', [dateKey]);
  }

  Future<bool> deleteByDateKey(int dateKey) {
    return deleteByIndex(r'dateKey', [dateKey]);
  }

  bool deleteByDateKeySync(int dateKey) {
    return deleteByIndexSync(r'dateKey', [dateKey]);
  }

  Future<List<WaterEntry?>> getAllByDateKey(List<int> dateKeyValues) {
    final values = dateKeyValues.map((e) => [e]).toList();
    return getAllByIndex(r'dateKey', values);
  }

  List<WaterEntry?> getAllByDateKeySync(List<int> dateKeyValues) {
    final values = dateKeyValues.map((e) => [e]).toList();
    return getAllByIndexSync(r'dateKey', values);
  }

  Future<int> deleteAllByDateKey(List<int> dateKeyValues) {
    final values = dateKeyValues.map((e) => [e]).toList();
    return deleteAllByIndex(r'dateKey', values);
  }

  int deleteAllByDateKeySync(List<int> dateKeyValues) {
    final values = dateKeyValues.map((e) => [e]).toList();
    return deleteAllByIndexSync(r'dateKey', values);
  }

  Future<Id> putByDateKey(WaterEntry object) {
    return putByIndex(r'dateKey', object);
  }

  Id putByDateKeySync(WaterEntry object, {bool saveLinks = true}) {
    return putByIndexSync(r'dateKey', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByDateKey(List<WaterEntry> objects) {
    return putAllByIndex(r'dateKey', objects);
  }

  List<Id> putAllByDateKeySync(
    List<WaterEntry> objects, {
    bool saveLinks = true,
  }) {
    return putAllByIndexSync(r'dateKey', objects, saveLinks: saveLinks);
  }
}

extension WaterEntryQueryWhereSort
    on QueryBuilder<WaterEntry, WaterEntry, QWhere> {
  QueryBuilder<WaterEntry, WaterEntry, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }

  QueryBuilder<WaterEntry, WaterEntry, QAfterWhere> anyDateKey() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'dateKey'),
      );
    });
  }
}

extension WaterEntryQueryWhere
    on QueryBuilder<WaterEntry, WaterEntry, QWhereClause> {
  QueryBuilder<WaterEntry, WaterEntry, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(lower: id, upper: id));
    });
  }

  QueryBuilder<WaterEntry, WaterEntry, QAfterWhereClause> idNotEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<WaterEntry, WaterEntry, QAfterWhereClause> idGreaterThan(
    Id id, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<WaterEntry, WaterEntry, QAfterWhereClause> idLessThan(
    Id id, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<WaterEntry, WaterEntry, QAfterWhereClause> idBetween(
    Id lowerId,
    Id upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.between(
          lower: lowerId,
          includeLower: includeLower,
          upper: upperId,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<WaterEntry, WaterEntry, QAfterWhereClause> dateKeyEqualTo(
    int dateKey,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.equalTo(indexName: r'dateKey', value: [dateKey]),
      );
    });
  }

  QueryBuilder<WaterEntry, WaterEntry, QAfterWhereClause> dateKeyNotEqualTo(
    int dateKey,
  ) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'dateKey',
                lower: [],
                upper: [dateKey],
                includeUpper: false,
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'dateKey',
                lower: [dateKey],
                includeLower: false,
                upper: [],
              ),
            );
      } else {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'dateKey',
                lower: [dateKey],
                includeLower: false,
                upper: [],
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'dateKey',
                lower: [],
                upper: [dateKey],
                includeUpper: false,
              ),
            );
      }
    });
  }

  QueryBuilder<WaterEntry, WaterEntry, QAfterWhereClause> dateKeyGreaterThan(
    int dateKey, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.between(
          indexName: r'dateKey',
          lower: [dateKey],
          includeLower: include,
          upper: [],
        ),
      );
    });
  }

  QueryBuilder<WaterEntry, WaterEntry, QAfterWhereClause> dateKeyLessThan(
    int dateKey, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.between(
          indexName: r'dateKey',
          lower: [],
          upper: [dateKey],
          includeUpper: include,
        ),
      );
    });
  }

  QueryBuilder<WaterEntry, WaterEntry, QAfterWhereClause> dateKeyBetween(
    int lowerDateKey,
    int upperDateKey, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.between(
          indexName: r'dateKey',
          lower: [lowerDateKey],
          includeLower: includeLower,
          upper: [upperDateKey],
          includeUpper: includeUpper,
        ),
      );
    });
  }
}

extension WaterEntryQueryFilter
    on QueryBuilder<WaterEntry, WaterEntry, QFilterCondition> {
  QueryBuilder<WaterEntry, WaterEntry, QAfterFilterCondition> dateKeyEqualTo(
    int value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'dateKey', value: value),
      );
    });
  }

  QueryBuilder<WaterEntry, WaterEntry, QAfterFilterCondition>
  dateKeyGreaterThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'dateKey',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<WaterEntry, WaterEntry, QAfterFilterCondition> dateKeyLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'dateKey',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<WaterEntry, WaterEntry, QAfterFilterCondition> dateKeyBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'dateKey',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<WaterEntry, WaterEntry, QAfterFilterCondition> glassesEqualTo(
    int value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'glasses', value: value),
      );
    });
  }

  QueryBuilder<WaterEntry, WaterEntry, QAfterFilterCondition>
  glassesGreaterThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'glasses',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<WaterEntry, WaterEntry, QAfterFilterCondition> glassesLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'glasses',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<WaterEntry, WaterEntry, QAfterFilterCondition> glassesBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'glasses',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<WaterEntry, WaterEntry, QAfterFilterCondition> idEqualTo(
    Id value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'id', value: value),
      );
    });
  }

  QueryBuilder<WaterEntry, WaterEntry, QAfterFilterCondition> idGreaterThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'id',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<WaterEntry, WaterEntry, QAfterFilterCondition> idLessThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'id',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<WaterEntry, WaterEntry, QAfterFilterCondition> idBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'id',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }
}

extension WaterEntryQueryObject
    on QueryBuilder<WaterEntry, WaterEntry, QFilterCondition> {}

extension WaterEntryQueryLinks
    on QueryBuilder<WaterEntry, WaterEntry, QFilterCondition> {}

extension WaterEntryQuerySortBy
    on QueryBuilder<WaterEntry, WaterEntry, QSortBy> {
  QueryBuilder<WaterEntry, WaterEntry, QAfterSortBy> sortByDateKey() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dateKey', Sort.asc);
    });
  }

  QueryBuilder<WaterEntry, WaterEntry, QAfterSortBy> sortByDateKeyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dateKey', Sort.desc);
    });
  }

  QueryBuilder<WaterEntry, WaterEntry, QAfterSortBy> sortByGlasses() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'glasses', Sort.asc);
    });
  }

  QueryBuilder<WaterEntry, WaterEntry, QAfterSortBy> sortByGlassesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'glasses', Sort.desc);
    });
  }
}

extension WaterEntryQuerySortThenBy
    on QueryBuilder<WaterEntry, WaterEntry, QSortThenBy> {
  QueryBuilder<WaterEntry, WaterEntry, QAfterSortBy> thenByDateKey() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dateKey', Sort.asc);
    });
  }

  QueryBuilder<WaterEntry, WaterEntry, QAfterSortBy> thenByDateKeyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dateKey', Sort.desc);
    });
  }

  QueryBuilder<WaterEntry, WaterEntry, QAfterSortBy> thenByGlasses() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'glasses', Sort.asc);
    });
  }

  QueryBuilder<WaterEntry, WaterEntry, QAfterSortBy> thenByGlassesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'glasses', Sort.desc);
    });
  }

  QueryBuilder<WaterEntry, WaterEntry, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<WaterEntry, WaterEntry, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }
}

extension WaterEntryQueryWhereDistinct
    on QueryBuilder<WaterEntry, WaterEntry, QDistinct> {
  QueryBuilder<WaterEntry, WaterEntry, QDistinct> distinctByDateKey() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'dateKey');
    });
  }

  QueryBuilder<WaterEntry, WaterEntry, QDistinct> distinctByGlasses() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'glasses');
    });
  }
}

extension WaterEntryQueryProperty
    on QueryBuilder<WaterEntry, WaterEntry, QQueryProperty> {
  QueryBuilder<WaterEntry, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<WaterEntry, int, QQueryOperations> dateKeyProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'dateKey');
    });
  }

  QueryBuilder<WaterEntry, int, QQueryOperations> glassesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'glasses');
    });
  }
}
