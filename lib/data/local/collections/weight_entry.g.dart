// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'weight_entry.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetWeightEntryCollection on Isar {
  IsarCollection<WeightEntry> get weightEntries => this.collection();
}

const WeightEntrySchema = CollectionSchema(
  name: r'WeightEntry',
  id: -5509044357954421771,
  properties: {
    r'dateKey': PropertySchema(id: 0, name: r'dateKey', type: IsarType.long),
    r'kg': PropertySchema(id: 1, name: r'kg', type: IsarType.double),
  },

  estimateSize: _weightEntryEstimateSize,
  serialize: _weightEntrySerialize,
  deserialize: _weightEntryDeserialize,
  deserializeProp: _weightEntryDeserializeProp,
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

  getId: _weightEntryGetId,
  getLinks: _weightEntryGetLinks,
  attach: _weightEntryAttach,
  version: '3.3.2',
);

int _weightEntryEstimateSize(
  WeightEntry object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  return bytesCount;
}

void _weightEntrySerialize(
  WeightEntry object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeLong(offsets[0], object.dateKey);
  writer.writeDouble(offsets[1], object.kg);
}

WeightEntry _weightEntryDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = WeightEntry();
  object.dateKey = reader.readLong(offsets[0]);
  object.id = id;
  object.kg = reader.readDouble(offsets[1]);
  return object;
}

P _weightEntryDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readLong(offset)) as P;
    case 1:
      return (reader.readDouble(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _weightEntryGetId(WeightEntry object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _weightEntryGetLinks(WeightEntry object) {
  return [];
}

void _weightEntryAttach(
  IsarCollection<dynamic> col,
  Id id,
  WeightEntry object,
) {
  object.id = id;
}

extension WeightEntryByIndex on IsarCollection<WeightEntry> {
  Future<WeightEntry?> getByDateKey(int dateKey) {
    return getByIndex(r'dateKey', [dateKey]);
  }

  WeightEntry? getByDateKeySync(int dateKey) {
    return getByIndexSync(r'dateKey', [dateKey]);
  }

  Future<bool> deleteByDateKey(int dateKey) {
    return deleteByIndex(r'dateKey', [dateKey]);
  }

  bool deleteByDateKeySync(int dateKey) {
    return deleteByIndexSync(r'dateKey', [dateKey]);
  }

  Future<List<WeightEntry?>> getAllByDateKey(List<int> dateKeyValues) {
    final values = dateKeyValues.map((e) => [e]).toList();
    return getAllByIndex(r'dateKey', values);
  }

  List<WeightEntry?> getAllByDateKeySync(List<int> dateKeyValues) {
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

  Future<Id> putByDateKey(WeightEntry object) {
    return putByIndex(r'dateKey', object);
  }

  Id putByDateKeySync(WeightEntry object, {bool saveLinks = true}) {
    return putByIndexSync(r'dateKey', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByDateKey(List<WeightEntry> objects) {
    return putAllByIndex(r'dateKey', objects);
  }

  List<Id> putAllByDateKeySync(
    List<WeightEntry> objects, {
    bool saveLinks = true,
  }) {
    return putAllByIndexSync(r'dateKey', objects, saveLinks: saveLinks);
  }
}

extension WeightEntryQueryWhereSort
    on QueryBuilder<WeightEntry, WeightEntry, QWhere> {
  QueryBuilder<WeightEntry, WeightEntry, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }

  QueryBuilder<WeightEntry, WeightEntry, QAfterWhere> anyDateKey() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'dateKey'),
      );
    });
  }
}

extension WeightEntryQueryWhere
    on QueryBuilder<WeightEntry, WeightEntry, QWhereClause> {
  QueryBuilder<WeightEntry, WeightEntry, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(lower: id, upper: id));
    });
  }

  QueryBuilder<WeightEntry, WeightEntry, QAfterWhereClause> idNotEqualTo(
    Id id,
  ) {
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

  QueryBuilder<WeightEntry, WeightEntry, QAfterWhereClause> idGreaterThan(
    Id id, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<WeightEntry, WeightEntry, QAfterWhereClause> idLessThan(
    Id id, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<WeightEntry, WeightEntry, QAfterWhereClause> idBetween(
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

  QueryBuilder<WeightEntry, WeightEntry, QAfterWhereClause> dateKeyEqualTo(
    int dateKey,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.equalTo(indexName: r'dateKey', value: [dateKey]),
      );
    });
  }

  QueryBuilder<WeightEntry, WeightEntry, QAfterWhereClause> dateKeyNotEqualTo(
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

  QueryBuilder<WeightEntry, WeightEntry, QAfterWhereClause> dateKeyGreaterThan(
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

  QueryBuilder<WeightEntry, WeightEntry, QAfterWhereClause> dateKeyLessThan(
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

  QueryBuilder<WeightEntry, WeightEntry, QAfterWhereClause> dateKeyBetween(
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

extension WeightEntryQueryFilter
    on QueryBuilder<WeightEntry, WeightEntry, QFilterCondition> {
  QueryBuilder<WeightEntry, WeightEntry, QAfterFilterCondition> dateKeyEqualTo(
    int value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'dateKey', value: value),
      );
    });
  }

  QueryBuilder<WeightEntry, WeightEntry, QAfterFilterCondition>
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

  QueryBuilder<WeightEntry, WeightEntry, QAfterFilterCondition> dateKeyLessThan(
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

  QueryBuilder<WeightEntry, WeightEntry, QAfterFilterCondition> dateKeyBetween(
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

  QueryBuilder<WeightEntry, WeightEntry, QAfterFilterCondition> idEqualTo(
    Id value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'id', value: value),
      );
    });
  }

  QueryBuilder<WeightEntry, WeightEntry, QAfterFilterCondition> idGreaterThan(
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

  QueryBuilder<WeightEntry, WeightEntry, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<WeightEntry, WeightEntry, QAfterFilterCondition> idBetween(
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

  QueryBuilder<WeightEntry, WeightEntry, QAfterFilterCondition> kgEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'kg',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<WeightEntry, WeightEntry, QAfterFilterCondition> kgGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'kg',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<WeightEntry, WeightEntry, QAfterFilterCondition> kgLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'kg',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<WeightEntry, WeightEntry, QAfterFilterCondition> kgBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'kg',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,

          epsilon: epsilon,
        ),
      );
    });
  }
}

extension WeightEntryQueryObject
    on QueryBuilder<WeightEntry, WeightEntry, QFilterCondition> {}

extension WeightEntryQueryLinks
    on QueryBuilder<WeightEntry, WeightEntry, QFilterCondition> {}

extension WeightEntryQuerySortBy
    on QueryBuilder<WeightEntry, WeightEntry, QSortBy> {
  QueryBuilder<WeightEntry, WeightEntry, QAfterSortBy> sortByDateKey() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dateKey', Sort.asc);
    });
  }

  QueryBuilder<WeightEntry, WeightEntry, QAfterSortBy> sortByDateKeyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dateKey', Sort.desc);
    });
  }

  QueryBuilder<WeightEntry, WeightEntry, QAfterSortBy> sortByKg() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'kg', Sort.asc);
    });
  }

  QueryBuilder<WeightEntry, WeightEntry, QAfterSortBy> sortByKgDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'kg', Sort.desc);
    });
  }
}

extension WeightEntryQuerySortThenBy
    on QueryBuilder<WeightEntry, WeightEntry, QSortThenBy> {
  QueryBuilder<WeightEntry, WeightEntry, QAfterSortBy> thenByDateKey() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dateKey', Sort.asc);
    });
  }

  QueryBuilder<WeightEntry, WeightEntry, QAfterSortBy> thenByDateKeyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dateKey', Sort.desc);
    });
  }

  QueryBuilder<WeightEntry, WeightEntry, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<WeightEntry, WeightEntry, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<WeightEntry, WeightEntry, QAfterSortBy> thenByKg() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'kg', Sort.asc);
    });
  }

  QueryBuilder<WeightEntry, WeightEntry, QAfterSortBy> thenByKgDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'kg', Sort.desc);
    });
  }
}

extension WeightEntryQueryWhereDistinct
    on QueryBuilder<WeightEntry, WeightEntry, QDistinct> {
  QueryBuilder<WeightEntry, WeightEntry, QDistinct> distinctByDateKey() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'dateKey');
    });
  }

  QueryBuilder<WeightEntry, WeightEntry, QDistinct> distinctByKg() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'kg');
    });
  }
}

extension WeightEntryQueryProperty
    on QueryBuilder<WeightEntry, WeightEntry, QQueryProperty> {
  QueryBuilder<WeightEntry, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<WeightEntry, int, QQueryOperations> dateKeyProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'dateKey');
    });
  }

  QueryBuilder<WeightEntry, double, QQueryOperations> kgProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'kg');
    });
  }
}
