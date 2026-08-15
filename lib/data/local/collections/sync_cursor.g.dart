// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sync_cursor.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetSyncCursorCollection on Isar {
  IsarCollection<SyncCursor> get syncCursors => this.collection();
}

const SyncCursorSchema = CollectionSchema(
  name: r'SyncCursor',
  id: 355982195539933157,
  properties: {
    r'pulledUpTo': PropertySchema(
      id: 0,
      name: r'pulledUpTo',
      type: IsarType.dateTime,
    ),
    r'table': PropertySchema(id: 1, name: r'table', type: IsarType.string),
    r'userId': PropertySchema(id: 2, name: r'userId', type: IsarType.string),
  },

  estimateSize: _syncCursorEstimateSize,
  serialize: _syncCursorSerialize,
  deserialize: _syncCursorDeserialize,
  deserializeProp: _syncCursorDeserializeProp,
  idName: r'id',
  indexes: {
    r'table': IndexSchema(
      id: 8918027309824820424,
      name: r'table',
      unique: true,
      replace: true,
      properties: [
        IndexPropertySchema(
          name: r'table',
          type: IndexType.hash,
          caseSensitive: true,
        ),
      ],
    ),
  },
  links: {},
  embeddedSchemas: {},

  getId: _syncCursorGetId,
  getLinks: _syncCursorGetLinks,
  attach: _syncCursorAttach,
  version: '3.3.2',
);

int _syncCursorEstimateSize(
  SyncCursor object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.table.length * 3;
  bytesCount += 3 + object.userId.length * 3;
  return bytesCount;
}

void _syncCursorSerialize(
  SyncCursor object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeDateTime(offsets[0], object.pulledUpTo);
  writer.writeString(offsets[1], object.table);
  writer.writeString(offsets[2], object.userId);
}

SyncCursor _syncCursorDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = SyncCursor();
  object.id = id;
  object.pulledUpTo = reader.readDateTimeOrNull(offsets[0]);
  object.table = reader.readString(offsets[1]);
  object.userId = reader.readString(offsets[2]);
  return object;
}

P _syncCursorDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 1:
      return (reader.readString(offset)) as P;
    case 2:
      return (reader.readString(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _syncCursorGetId(SyncCursor object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _syncCursorGetLinks(SyncCursor object) {
  return [];
}

void _syncCursorAttach(IsarCollection<dynamic> col, Id id, SyncCursor object) {
  object.id = id;
}

extension SyncCursorByIndex on IsarCollection<SyncCursor> {
  Future<SyncCursor?> getByTable(String table) {
    return getByIndex(r'table', [table]);
  }

  SyncCursor? getByTableSync(String table) {
    return getByIndexSync(r'table', [table]);
  }

  Future<bool> deleteByTable(String table) {
    return deleteByIndex(r'table', [table]);
  }

  bool deleteByTableSync(String table) {
    return deleteByIndexSync(r'table', [table]);
  }

  Future<List<SyncCursor?>> getAllByTable(List<String> tableValues) {
    final values = tableValues.map((e) => [e]).toList();
    return getAllByIndex(r'table', values);
  }

  List<SyncCursor?> getAllByTableSync(List<String> tableValues) {
    final values = tableValues.map((e) => [e]).toList();
    return getAllByIndexSync(r'table', values);
  }

  Future<int> deleteAllByTable(List<String> tableValues) {
    final values = tableValues.map((e) => [e]).toList();
    return deleteAllByIndex(r'table', values);
  }

  int deleteAllByTableSync(List<String> tableValues) {
    final values = tableValues.map((e) => [e]).toList();
    return deleteAllByIndexSync(r'table', values);
  }

  Future<Id> putByTable(SyncCursor object) {
    return putByIndex(r'table', object);
  }

  Id putByTableSync(SyncCursor object, {bool saveLinks = true}) {
    return putByIndexSync(r'table', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByTable(List<SyncCursor> objects) {
    return putAllByIndex(r'table', objects);
  }

  List<Id> putAllByTableSync(
    List<SyncCursor> objects, {
    bool saveLinks = true,
  }) {
    return putAllByIndexSync(r'table', objects, saveLinks: saveLinks);
  }
}

extension SyncCursorQueryWhereSort
    on QueryBuilder<SyncCursor, SyncCursor, QWhere> {
  QueryBuilder<SyncCursor, SyncCursor, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension SyncCursorQueryWhere
    on QueryBuilder<SyncCursor, SyncCursor, QWhereClause> {
  QueryBuilder<SyncCursor, SyncCursor, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(lower: id, upper: id));
    });
  }

  QueryBuilder<SyncCursor, SyncCursor, QAfterWhereClause> idNotEqualTo(Id id) {
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

  QueryBuilder<SyncCursor, SyncCursor, QAfterWhereClause> idGreaterThan(
    Id id, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<SyncCursor, SyncCursor, QAfterWhereClause> idLessThan(
    Id id, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<SyncCursor, SyncCursor, QAfterWhereClause> idBetween(
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

  QueryBuilder<SyncCursor, SyncCursor, QAfterWhereClause> tableEqualTo(
    String table,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.equalTo(indexName: r'table', value: [table]),
      );
    });
  }

  QueryBuilder<SyncCursor, SyncCursor, QAfterWhereClause> tableNotEqualTo(
    String table,
  ) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'table',
                lower: [],
                upper: [table],
                includeUpper: false,
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'table',
                lower: [table],
                includeLower: false,
                upper: [],
              ),
            );
      } else {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'table',
                lower: [table],
                includeLower: false,
                upper: [],
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'table',
                lower: [],
                upper: [table],
                includeUpper: false,
              ),
            );
      }
    });
  }
}

extension SyncCursorQueryFilter
    on QueryBuilder<SyncCursor, SyncCursor, QFilterCondition> {
  QueryBuilder<SyncCursor, SyncCursor, QAfterFilterCondition> idEqualTo(
    Id value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'id', value: value),
      );
    });
  }

  QueryBuilder<SyncCursor, SyncCursor, QAfterFilterCondition> idGreaterThan(
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

  QueryBuilder<SyncCursor, SyncCursor, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<SyncCursor, SyncCursor, QAfterFilterCondition> idBetween(
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

  QueryBuilder<SyncCursor, SyncCursor, QAfterFilterCondition>
  pulledUpToIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'pulledUpTo'),
      );
    });
  }

  QueryBuilder<SyncCursor, SyncCursor, QAfterFilterCondition>
  pulledUpToIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'pulledUpTo'),
      );
    });
  }

  QueryBuilder<SyncCursor, SyncCursor, QAfterFilterCondition> pulledUpToEqualTo(
    DateTime? value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'pulledUpTo', value: value),
      );
    });
  }

  QueryBuilder<SyncCursor, SyncCursor, QAfterFilterCondition>
  pulledUpToGreaterThan(DateTime? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'pulledUpTo',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<SyncCursor, SyncCursor, QAfterFilterCondition>
  pulledUpToLessThan(DateTime? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'pulledUpTo',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<SyncCursor, SyncCursor, QAfterFilterCondition> pulledUpToBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'pulledUpTo',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<SyncCursor, SyncCursor, QAfterFilterCondition> tableEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'table',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SyncCursor, SyncCursor, QAfterFilterCondition> tableGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'table',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SyncCursor, SyncCursor, QAfterFilterCondition> tableLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'table',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SyncCursor, SyncCursor, QAfterFilterCondition> tableBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'table',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SyncCursor, SyncCursor, QAfterFilterCondition> tableStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'table',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SyncCursor, SyncCursor, QAfterFilterCondition> tableEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'table',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SyncCursor, SyncCursor, QAfterFilterCondition> tableContains(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'table',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SyncCursor, SyncCursor, QAfterFilterCondition> tableMatches(
    String pattern, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'table',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SyncCursor, SyncCursor, QAfterFilterCondition> tableIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'table', value: ''),
      );
    });
  }

  QueryBuilder<SyncCursor, SyncCursor, QAfterFilterCondition>
  tableIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'table', value: ''),
      );
    });
  }

  QueryBuilder<SyncCursor, SyncCursor, QAfterFilterCondition> userIdEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'userId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SyncCursor, SyncCursor, QAfterFilterCondition> userIdGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'userId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SyncCursor, SyncCursor, QAfterFilterCondition> userIdLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'userId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SyncCursor, SyncCursor, QAfterFilterCondition> userIdBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'userId',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SyncCursor, SyncCursor, QAfterFilterCondition> userIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'userId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SyncCursor, SyncCursor, QAfterFilterCondition> userIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'userId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SyncCursor, SyncCursor, QAfterFilterCondition> userIdContains(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'userId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SyncCursor, SyncCursor, QAfterFilterCondition> userIdMatches(
    String pattern, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'userId',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SyncCursor, SyncCursor, QAfterFilterCondition> userIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'userId', value: ''),
      );
    });
  }

  QueryBuilder<SyncCursor, SyncCursor, QAfterFilterCondition>
  userIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'userId', value: ''),
      );
    });
  }
}

extension SyncCursorQueryObject
    on QueryBuilder<SyncCursor, SyncCursor, QFilterCondition> {}

extension SyncCursorQueryLinks
    on QueryBuilder<SyncCursor, SyncCursor, QFilterCondition> {}

extension SyncCursorQuerySortBy
    on QueryBuilder<SyncCursor, SyncCursor, QSortBy> {
  QueryBuilder<SyncCursor, SyncCursor, QAfterSortBy> sortByPulledUpTo() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pulledUpTo', Sort.asc);
    });
  }

  QueryBuilder<SyncCursor, SyncCursor, QAfterSortBy> sortByPulledUpToDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pulledUpTo', Sort.desc);
    });
  }

  QueryBuilder<SyncCursor, SyncCursor, QAfterSortBy> sortByTable() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'table', Sort.asc);
    });
  }

  QueryBuilder<SyncCursor, SyncCursor, QAfterSortBy> sortByTableDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'table', Sort.desc);
    });
  }

  QueryBuilder<SyncCursor, SyncCursor, QAfterSortBy> sortByUserId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'userId', Sort.asc);
    });
  }

  QueryBuilder<SyncCursor, SyncCursor, QAfterSortBy> sortByUserIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'userId', Sort.desc);
    });
  }
}

extension SyncCursorQuerySortThenBy
    on QueryBuilder<SyncCursor, SyncCursor, QSortThenBy> {
  QueryBuilder<SyncCursor, SyncCursor, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<SyncCursor, SyncCursor, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<SyncCursor, SyncCursor, QAfterSortBy> thenByPulledUpTo() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pulledUpTo', Sort.asc);
    });
  }

  QueryBuilder<SyncCursor, SyncCursor, QAfterSortBy> thenByPulledUpToDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pulledUpTo', Sort.desc);
    });
  }

  QueryBuilder<SyncCursor, SyncCursor, QAfterSortBy> thenByTable() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'table', Sort.asc);
    });
  }

  QueryBuilder<SyncCursor, SyncCursor, QAfterSortBy> thenByTableDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'table', Sort.desc);
    });
  }

  QueryBuilder<SyncCursor, SyncCursor, QAfterSortBy> thenByUserId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'userId', Sort.asc);
    });
  }

  QueryBuilder<SyncCursor, SyncCursor, QAfterSortBy> thenByUserIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'userId', Sort.desc);
    });
  }
}

extension SyncCursorQueryWhereDistinct
    on QueryBuilder<SyncCursor, SyncCursor, QDistinct> {
  QueryBuilder<SyncCursor, SyncCursor, QDistinct> distinctByPulledUpTo() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'pulledUpTo');
    });
  }

  QueryBuilder<SyncCursor, SyncCursor, QDistinct> distinctByTable({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'table', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<SyncCursor, SyncCursor, QDistinct> distinctByUserId({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'userId', caseSensitive: caseSensitive);
    });
  }
}

extension SyncCursorQueryProperty
    on QueryBuilder<SyncCursor, SyncCursor, QQueryProperty> {
  QueryBuilder<SyncCursor, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<SyncCursor, DateTime?, QQueryOperations> pulledUpToProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'pulledUpTo');
    });
  }

  QueryBuilder<SyncCursor, String, QQueryOperations> tableProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'table');
    });
  }

  QueryBuilder<SyncCursor, String, QQueryOperations> userIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'userId');
    });
  }
}
