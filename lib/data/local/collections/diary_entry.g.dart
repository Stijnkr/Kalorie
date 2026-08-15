// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'diary_entry.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetDiaryEntryCollection on Isar {
  IsarCollection<DiaryEntry> get diaryEntries => this.collection();
}

const DiaryEntrySchema = CollectionSchema(
  name: r'DiaryEntry',
  id: -1043886744285152801,
  properties: {
    r'amountG': PropertySchema(id: 0, name: r'amountG', type: IsarType.double),
    r'brand': PropertySchema(id: 1, name: r'brand', type: IsarType.string),
    r'carbs': PropertySchema(id: 2, name: r'carbs', type: IsarType.double),
    r'clientId': PropertySchema(
      id: 3,
      name: r'clientId',
      type: IsarType.string,
    ),
    r'createdAt': PropertySchema(
      id: 4,
      name: r'createdAt',
      type: IsarType.dateTime,
    ),
    r'dateKey': PropertySchema(id: 5, name: r'dateKey', type: IsarType.long),
    r'deleted': PropertySchema(id: 6, name: r'deleted', type: IsarType.bool),
    r'dirty': PropertySchema(id: 7, name: r'dirty', type: IsarType.bool),
    r'fat': PropertySchema(id: 8, name: r'fat', type: IsarType.double),
    r'fiber': PropertySchema(id: 9, name: r'fiber', type: IsarType.double),
    r'foodId': PropertySchema(id: 10, name: r'foodId', type: IsarType.long),
    r'foodName': PropertySchema(
      id: 11,
      name: r'foodName',
      type: IsarType.string,
    ),
    r'kcal': PropertySchema(id: 12, name: r'kcal', type: IsarType.double),
    r'meal': PropertySchema(
      id: 13,
      name: r'meal',
      type: IsarType.byte,
      enumMap: _DiaryEntrymealEnumValueMap,
    ),
    r'protein': PropertySchema(id: 14, name: r'protein', type: IsarType.double),
    r'salt': PropertySchema(id: 15, name: r'salt', type: IsarType.double),
    r'satFat': PropertySchema(id: 16, name: r'satFat', type: IsarType.double),
    r'servingLabel': PropertySchema(
      id: 17,
      name: r'servingLabel',
      type: IsarType.string,
    ),
    r'source': PropertySchema(
      id: 18,
      name: r'source',
      type: IsarType.byte,
      enumMap: _DiaryEntrysourceEnumValueMap,
    ),
    r'sugars': PropertySchema(id: 19, name: r'sugars', type: IsarType.double),
    r'updatedAt': PropertySchema(
      id: 20,
      name: r'updatedAt',
      type: IsarType.dateTime,
    ),
  },

  estimateSize: _diaryEntryEstimateSize,
  serialize: _diaryEntrySerialize,
  deserialize: _diaryEntryDeserialize,
  deserializeProp: _diaryEntryDeserializeProp,
  idName: r'id',
  indexes: {
    r'dateKey': IndexSchema(
      id: 7975223786082927131,
      name: r'dateKey',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'dateKey',
          type: IndexType.value,
          caseSensitive: false,
        ),
      ],
    ),
    r'clientId': IndexSchema(
      id: 2639372232964765565,
      name: r'clientId',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'clientId',
          type: IndexType.hash,
          caseSensitive: true,
        ),
      ],
    ),
    r'dirty': IndexSchema(
      id: 624608328996418504,
      name: r'dirty',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'dirty',
          type: IndexType.value,
          caseSensitive: false,
        ),
      ],
    ),
    r'deleted': IndexSchema(
      id: 2416515181749931262,
      name: r'deleted',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'deleted',
          type: IndexType.value,
          caseSensitive: false,
        ),
      ],
    ),
  },
  links: {},
  embeddedSchemas: {},

  getId: _diaryEntryGetId,
  getLinks: _diaryEntryGetLinks,
  attach: _diaryEntryAttach,
  version: '3.3.2',
);

int _diaryEntryEstimateSize(
  DiaryEntry object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final value = object.brand;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.clientId.length * 3;
  bytesCount += 3 + object.foodName.length * 3;
  {
    final value = object.servingLabel;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  return bytesCount;
}

void _diaryEntrySerialize(
  DiaryEntry object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeDouble(offsets[0], object.amountG);
  writer.writeString(offsets[1], object.brand);
  writer.writeDouble(offsets[2], object.carbs);
  writer.writeString(offsets[3], object.clientId);
  writer.writeDateTime(offsets[4], object.createdAt);
  writer.writeLong(offsets[5], object.dateKey);
  writer.writeBool(offsets[6], object.deleted);
  writer.writeBool(offsets[7], object.dirty);
  writer.writeDouble(offsets[8], object.fat);
  writer.writeDouble(offsets[9], object.fiber);
  writer.writeLong(offsets[10], object.foodId);
  writer.writeString(offsets[11], object.foodName);
  writer.writeDouble(offsets[12], object.kcal);
  writer.writeByte(offsets[13], object.meal.index);
  writer.writeDouble(offsets[14], object.protein);
  writer.writeDouble(offsets[15], object.salt);
  writer.writeDouble(offsets[16], object.satFat);
  writer.writeString(offsets[17], object.servingLabel);
  writer.writeByte(offsets[18], object.source.index);
  writer.writeDouble(offsets[19], object.sugars);
  writer.writeDateTime(offsets[20], object.updatedAt);
}

DiaryEntry _diaryEntryDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = DiaryEntry();
  object.amountG = reader.readDouble(offsets[0]);
  object.brand = reader.readStringOrNull(offsets[1]);
  object.carbs = reader.readDouble(offsets[2]);
  object.clientId = reader.readString(offsets[3]);
  object.createdAt = reader.readDateTime(offsets[4]);
  object.dateKey = reader.readLong(offsets[5]);
  object.deleted = reader.readBool(offsets[6]);
  object.dirty = reader.readBool(offsets[7]);
  object.fat = reader.readDouble(offsets[8]);
  object.fiber = reader.readDoubleOrNull(offsets[9]);
  object.foodId = reader.readLong(offsets[10]);
  object.foodName = reader.readString(offsets[11]);
  object.id = id;
  object.kcal = reader.readDouble(offsets[12]);
  object.meal =
      _DiaryEntrymealValueEnumMap[reader.readByteOrNull(offsets[13])] ??
      MealType.breakfast;
  object.protein = reader.readDouble(offsets[14]);
  object.salt = reader.readDoubleOrNull(offsets[15]);
  object.satFat = reader.readDoubleOrNull(offsets[16]);
  object.servingLabel = reader.readStringOrNull(offsets[17]);
  object.source =
      _DiaryEntrysourceValueEnumMap[reader.readByteOrNull(offsets[18])] ??
      FoodSource.off;
  object.sugars = reader.readDoubleOrNull(offsets[19]);
  object.updatedAt = reader.readDateTime(offsets[20]);
  return object;
}

P _diaryEntryDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readDouble(offset)) as P;
    case 1:
      return (reader.readStringOrNull(offset)) as P;
    case 2:
      return (reader.readDouble(offset)) as P;
    case 3:
      return (reader.readString(offset)) as P;
    case 4:
      return (reader.readDateTime(offset)) as P;
    case 5:
      return (reader.readLong(offset)) as P;
    case 6:
      return (reader.readBool(offset)) as P;
    case 7:
      return (reader.readBool(offset)) as P;
    case 8:
      return (reader.readDouble(offset)) as P;
    case 9:
      return (reader.readDoubleOrNull(offset)) as P;
    case 10:
      return (reader.readLong(offset)) as P;
    case 11:
      return (reader.readString(offset)) as P;
    case 12:
      return (reader.readDouble(offset)) as P;
    case 13:
      return (_DiaryEntrymealValueEnumMap[reader.readByteOrNull(offset)] ??
              MealType.breakfast)
          as P;
    case 14:
      return (reader.readDouble(offset)) as P;
    case 15:
      return (reader.readDoubleOrNull(offset)) as P;
    case 16:
      return (reader.readDoubleOrNull(offset)) as P;
    case 17:
      return (reader.readStringOrNull(offset)) as P;
    case 18:
      return (_DiaryEntrysourceValueEnumMap[reader.readByteOrNull(offset)] ??
              FoodSource.off)
          as P;
    case 19:
      return (reader.readDoubleOrNull(offset)) as P;
    case 20:
      return (reader.readDateTime(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

const _DiaryEntrymealEnumValueMap = {
  'breakfast': 0,
  'lunch': 1,
  'dinner': 2,
  'snack': 3,
};
const _DiaryEntrymealValueEnumMap = {
  0: MealType.breakfast,
  1: MealType.lunch,
  2: MealType.dinner,
  3: MealType.snack,
};
const _DiaryEntrysourceEnumValueMap = {'off': 0, 'nevo': 1, 'custom': 2};
const _DiaryEntrysourceValueEnumMap = {
  0: FoodSource.off,
  1: FoodSource.nevo,
  2: FoodSource.custom,
};

Id _diaryEntryGetId(DiaryEntry object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _diaryEntryGetLinks(DiaryEntry object) {
  return [];
}

void _diaryEntryAttach(IsarCollection<dynamic> col, Id id, DiaryEntry object) {
  object.id = id;
}

extension DiaryEntryQueryWhereSort
    on QueryBuilder<DiaryEntry, DiaryEntry, QWhere> {
  QueryBuilder<DiaryEntry, DiaryEntry, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }

  QueryBuilder<DiaryEntry, DiaryEntry, QAfterWhere> anyDateKey() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'dateKey'),
      );
    });
  }

  QueryBuilder<DiaryEntry, DiaryEntry, QAfterWhere> anyDirty() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'dirty'),
      );
    });
  }

  QueryBuilder<DiaryEntry, DiaryEntry, QAfterWhere> anyDeleted() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'deleted'),
      );
    });
  }
}

extension DiaryEntryQueryWhere
    on QueryBuilder<DiaryEntry, DiaryEntry, QWhereClause> {
  QueryBuilder<DiaryEntry, DiaryEntry, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(lower: id, upper: id));
    });
  }

  QueryBuilder<DiaryEntry, DiaryEntry, QAfterWhereClause> idNotEqualTo(Id id) {
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

  QueryBuilder<DiaryEntry, DiaryEntry, QAfterWhereClause> idGreaterThan(
    Id id, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<DiaryEntry, DiaryEntry, QAfterWhereClause> idLessThan(
    Id id, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<DiaryEntry, DiaryEntry, QAfterWhereClause> idBetween(
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

  QueryBuilder<DiaryEntry, DiaryEntry, QAfterWhereClause> dateKeyEqualTo(
    int dateKey,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.equalTo(indexName: r'dateKey', value: [dateKey]),
      );
    });
  }

  QueryBuilder<DiaryEntry, DiaryEntry, QAfterWhereClause> dateKeyNotEqualTo(
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

  QueryBuilder<DiaryEntry, DiaryEntry, QAfterWhereClause> dateKeyGreaterThan(
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

  QueryBuilder<DiaryEntry, DiaryEntry, QAfterWhereClause> dateKeyLessThan(
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

  QueryBuilder<DiaryEntry, DiaryEntry, QAfterWhereClause> dateKeyBetween(
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

  QueryBuilder<DiaryEntry, DiaryEntry, QAfterWhereClause> clientIdEqualTo(
    String clientId,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.equalTo(indexName: r'clientId', value: [clientId]),
      );
    });
  }

  QueryBuilder<DiaryEntry, DiaryEntry, QAfterWhereClause> clientIdNotEqualTo(
    String clientId,
  ) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'clientId',
                lower: [],
                upper: [clientId],
                includeUpper: false,
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'clientId',
                lower: [clientId],
                includeLower: false,
                upper: [],
              ),
            );
      } else {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'clientId',
                lower: [clientId],
                includeLower: false,
                upper: [],
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'clientId',
                lower: [],
                upper: [clientId],
                includeUpper: false,
              ),
            );
      }
    });
  }

  QueryBuilder<DiaryEntry, DiaryEntry, QAfterWhereClause> dirtyEqualTo(
    bool dirty,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.equalTo(indexName: r'dirty', value: [dirty]),
      );
    });
  }

  QueryBuilder<DiaryEntry, DiaryEntry, QAfterWhereClause> dirtyNotEqualTo(
    bool dirty,
  ) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'dirty',
                lower: [],
                upper: [dirty],
                includeUpper: false,
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'dirty',
                lower: [dirty],
                includeLower: false,
                upper: [],
              ),
            );
      } else {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'dirty',
                lower: [dirty],
                includeLower: false,
                upper: [],
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'dirty',
                lower: [],
                upper: [dirty],
                includeUpper: false,
              ),
            );
      }
    });
  }

  QueryBuilder<DiaryEntry, DiaryEntry, QAfterWhereClause> deletedEqualTo(
    bool deleted,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.equalTo(indexName: r'deleted', value: [deleted]),
      );
    });
  }

  QueryBuilder<DiaryEntry, DiaryEntry, QAfterWhereClause> deletedNotEqualTo(
    bool deleted,
  ) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'deleted',
                lower: [],
                upper: [deleted],
                includeUpper: false,
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'deleted',
                lower: [deleted],
                includeLower: false,
                upper: [],
              ),
            );
      } else {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'deleted',
                lower: [deleted],
                includeLower: false,
                upper: [],
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'deleted',
                lower: [],
                upper: [deleted],
                includeUpper: false,
              ),
            );
      }
    });
  }
}

extension DiaryEntryQueryFilter
    on QueryBuilder<DiaryEntry, DiaryEntry, QFilterCondition> {
  QueryBuilder<DiaryEntry, DiaryEntry, QAfterFilterCondition> amountGEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'amountG',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<DiaryEntry, DiaryEntry, QAfterFilterCondition>
  amountGGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'amountG',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<DiaryEntry, DiaryEntry, QAfterFilterCondition> amountGLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'amountG',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<DiaryEntry, DiaryEntry, QAfterFilterCondition> amountGBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'amountG',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<DiaryEntry, DiaryEntry, QAfterFilterCondition> brandIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'brand'),
      );
    });
  }

  QueryBuilder<DiaryEntry, DiaryEntry, QAfterFilterCondition> brandIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'brand'),
      );
    });
  }

  QueryBuilder<DiaryEntry, DiaryEntry, QAfterFilterCondition> brandEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'brand',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DiaryEntry, DiaryEntry, QAfterFilterCondition> brandGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'brand',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DiaryEntry, DiaryEntry, QAfterFilterCondition> brandLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'brand',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DiaryEntry, DiaryEntry, QAfterFilterCondition> brandBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'brand',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DiaryEntry, DiaryEntry, QAfterFilterCondition> brandStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'brand',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DiaryEntry, DiaryEntry, QAfterFilterCondition> brandEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'brand',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DiaryEntry, DiaryEntry, QAfterFilterCondition> brandContains(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'brand',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DiaryEntry, DiaryEntry, QAfterFilterCondition> brandMatches(
    String pattern, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'brand',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DiaryEntry, DiaryEntry, QAfterFilterCondition> brandIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'brand', value: ''),
      );
    });
  }

  QueryBuilder<DiaryEntry, DiaryEntry, QAfterFilterCondition>
  brandIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'brand', value: ''),
      );
    });
  }

  QueryBuilder<DiaryEntry, DiaryEntry, QAfterFilterCondition> carbsEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'carbs',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<DiaryEntry, DiaryEntry, QAfterFilterCondition> carbsGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'carbs',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<DiaryEntry, DiaryEntry, QAfterFilterCondition> carbsLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'carbs',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<DiaryEntry, DiaryEntry, QAfterFilterCondition> carbsBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'carbs',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<DiaryEntry, DiaryEntry, QAfterFilterCondition> clientIdEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'clientId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DiaryEntry, DiaryEntry, QAfterFilterCondition>
  clientIdGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'clientId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DiaryEntry, DiaryEntry, QAfterFilterCondition> clientIdLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'clientId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DiaryEntry, DiaryEntry, QAfterFilterCondition> clientIdBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'clientId',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DiaryEntry, DiaryEntry, QAfterFilterCondition>
  clientIdStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'clientId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DiaryEntry, DiaryEntry, QAfterFilterCondition> clientIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'clientId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DiaryEntry, DiaryEntry, QAfterFilterCondition> clientIdContains(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'clientId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DiaryEntry, DiaryEntry, QAfterFilterCondition> clientIdMatches(
    String pattern, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'clientId',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DiaryEntry, DiaryEntry, QAfterFilterCondition>
  clientIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'clientId', value: ''),
      );
    });
  }

  QueryBuilder<DiaryEntry, DiaryEntry, QAfterFilterCondition>
  clientIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'clientId', value: ''),
      );
    });
  }

  QueryBuilder<DiaryEntry, DiaryEntry, QAfterFilterCondition> createdAtEqualTo(
    DateTime value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'createdAt', value: value),
      );
    });
  }

  QueryBuilder<DiaryEntry, DiaryEntry, QAfterFilterCondition>
  createdAtGreaterThan(DateTime value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'createdAt',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<DiaryEntry, DiaryEntry, QAfterFilterCondition> createdAtLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'createdAt',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<DiaryEntry, DiaryEntry, QAfterFilterCondition> createdAtBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'createdAt',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<DiaryEntry, DiaryEntry, QAfterFilterCondition> dateKeyEqualTo(
    int value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'dateKey', value: value),
      );
    });
  }

  QueryBuilder<DiaryEntry, DiaryEntry, QAfterFilterCondition>
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

  QueryBuilder<DiaryEntry, DiaryEntry, QAfterFilterCondition> dateKeyLessThan(
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

  QueryBuilder<DiaryEntry, DiaryEntry, QAfterFilterCondition> dateKeyBetween(
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

  QueryBuilder<DiaryEntry, DiaryEntry, QAfterFilterCondition> deletedEqualTo(
    bool value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'deleted', value: value),
      );
    });
  }

  QueryBuilder<DiaryEntry, DiaryEntry, QAfterFilterCondition> dirtyEqualTo(
    bool value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'dirty', value: value),
      );
    });
  }

  QueryBuilder<DiaryEntry, DiaryEntry, QAfterFilterCondition> fatEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'fat',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<DiaryEntry, DiaryEntry, QAfterFilterCondition> fatGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'fat',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<DiaryEntry, DiaryEntry, QAfterFilterCondition> fatLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'fat',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<DiaryEntry, DiaryEntry, QAfterFilterCondition> fatBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'fat',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<DiaryEntry, DiaryEntry, QAfterFilterCondition> fiberIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'fiber'),
      );
    });
  }

  QueryBuilder<DiaryEntry, DiaryEntry, QAfterFilterCondition> fiberIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'fiber'),
      );
    });
  }

  QueryBuilder<DiaryEntry, DiaryEntry, QAfterFilterCondition> fiberEqualTo(
    double? value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'fiber',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<DiaryEntry, DiaryEntry, QAfterFilterCondition> fiberGreaterThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'fiber',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<DiaryEntry, DiaryEntry, QAfterFilterCondition> fiberLessThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'fiber',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<DiaryEntry, DiaryEntry, QAfterFilterCondition> fiberBetween(
    double? lower,
    double? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'fiber',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<DiaryEntry, DiaryEntry, QAfterFilterCondition> foodIdEqualTo(
    int value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'foodId', value: value),
      );
    });
  }

  QueryBuilder<DiaryEntry, DiaryEntry, QAfterFilterCondition> foodIdGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'foodId',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<DiaryEntry, DiaryEntry, QAfterFilterCondition> foodIdLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'foodId',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<DiaryEntry, DiaryEntry, QAfterFilterCondition> foodIdBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'foodId',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<DiaryEntry, DiaryEntry, QAfterFilterCondition> foodNameEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'foodName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DiaryEntry, DiaryEntry, QAfterFilterCondition>
  foodNameGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'foodName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DiaryEntry, DiaryEntry, QAfterFilterCondition> foodNameLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'foodName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DiaryEntry, DiaryEntry, QAfterFilterCondition> foodNameBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'foodName',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DiaryEntry, DiaryEntry, QAfterFilterCondition>
  foodNameStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'foodName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DiaryEntry, DiaryEntry, QAfterFilterCondition> foodNameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'foodName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DiaryEntry, DiaryEntry, QAfterFilterCondition> foodNameContains(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'foodName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DiaryEntry, DiaryEntry, QAfterFilterCondition> foodNameMatches(
    String pattern, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'foodName',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DiaryEntry, DiaryEntry, QAfterFilterCondition>
  foodNameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'foodName', value: ''),
      );
    });
  }

  QueryBuilder<DiaryEntry, DiaryEntry, QAfterFilterCondition>
  foodNameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'foodName', value: ''),
      );
    });
  }

  QueryBuilder<DiaryEntry, DiaryEntry, QAfterFilterCondition> idEqualTo(
    Id value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'id', value: value),
      );
    });
  }

  QueryBuilder<DiaryEntry, DiaryEntry, QAfterFilterCondition> idGreaterThan(
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

  QueryBuilder<DiaryEntry, DiaryEntry, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<DiaryEntry, DiaryEntry, QAfterFilterCondition> idBetween(
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

  QueryBuilder<DiaryEntry, DiaryEntry, QAfterFilterCondition> kcalEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'kcal',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<DiaryEntry, DiaryEntry, QAfterFilterCondition> kcalGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'kcal',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<DiaryEntry, DiaryEntry, QAfterFilterCondition> kcalLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'kcal',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<DiaryEntry, DiaryEntry, QAfterFilterCondition> kcalBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'kcal',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<DiaryEntry, DiaryEntry, QAfterFilterCondition> mealEqualTo(
    MealType value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'meal', value: value),
      );
    });
  }

  QueryBuilder<DiaryEntry, DiaryEntry, QAfterFilterCondition> mealGreaterThan(
    MealType value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'meal',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<DiaryEntry, DiaryEntry, QAfterFilterCondition> mealLessThan(
    MealType value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'meal',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<DiaryEntry, DiaryEntry, QAfterFilterCondition> mealBetween(
    MealType lower,
    MealType upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'meal',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<DiaryEntry, DiaryEntry, QAfterFilterCondition> proteinEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'protein',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<DiaryEntry, DiaryEntry, QAfterFilterCondition>
  proteinGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'protein',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<DiaryEntry, DiaryEntry, QAfterFilterCondition> proteinLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'protein',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<DiaryEntry, DiaryEntry, QAfterFilterCondition> proteinBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'protein',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<DiaryEntry, DiaryEntry, QAfterFilterCondition> saltIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'salt'),
      );
    });
  }

  QueryBuilder<DiaryEntry, DiaryEntry, QAfterFilterCondition> saltIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'salt'),
      );
    });
  }

  QueryBuilder<DiaryEntry, DiaryEntry, QAfterFilterCondition> saltEqualTo(
    double? value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'salt',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<DiaryEntry, DiaryEntry, QAfterFilterCondition> saltGreaterThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'salt',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<DiaryEntry, DiaryEntry, QAfterFilterCondition> saltLessThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'salt',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<DiaryEntry, DiaryEntry, QAfterFilterCondition> saltBetween(
    double? lower,
    double? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'salt',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<DiaryEntry, DiaryEntry, QAfterFilterCondition> satFatIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'satFat'),
      );
    });
  }

  QueryBuilder<DiaryEntry, DiaryEntry, QAfterFilterCondition>
  satFatIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'satFat'),
      );
    });
  }

  QueryBuilder<DiaryEntry, DiaryEntry, QAfterFilterCondition> satFatEqualTo(
    double? value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'satFat',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<DiaryEntry, DiaryEntry, QAfterFilterCondition> satFatGreaterThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'satFat',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<DiaryEntry, DiaryEntry, QAfterFilterCondition> satFatLessThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'satFat',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<DiaryEntry, DiaryEntry, QAfterFilterCondition> satFatBetween(
    double? lower,
    double? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'satFat',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<DiaryEntry, DiaryEntry, QAfterFilterCondition>
  servingLabelIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'servingLabel'),
      );
    });
  }

  QueryBuilder<DiaryEntry, DiaryEntry, QAfterFilterCondition>
  servingLabelIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'servingLabel'),
      );
    });
  }

  QueryBuilder<DiaryEntry, DiaryEntry, QAfterFilterCondition>
  servingLabelEqualTo(String? value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'servingLabel',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DiaryEntry, DiaryEntry, QAfterFilterCondition>
  servingLabelGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'servingLabel',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DiaryEntry, DiaryEntry, QAfterFilterCondition>
  servingLabelLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'servingLabel',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DiaryEntry, DiaryEntry, QAfterFilterCondition>
  servingLabelBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'servingLabel',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DiaryEntry, DiaryEntry, QAfterFilterCondition>
  servingLabelStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'servingLabel',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DiaryEntry, DiaryEntry, QAfterFilterCondition>
  servingLabelEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'servingLabel',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DiaryEntry, DiaryEntry, QAfterFilterCondition>
  servingLabelContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'servingLabel',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DiaryEntry, DiaryEntry, QAfterFilterCondition>
  servingLabelMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'servingLabel',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DiaryEntry, DiaryEntry, QAfterFilterCondition>
  servingLabelIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'servingLabel', value: ''),
      );
    });
  }

  QueryBuilder<DiaryEntry, DiaryEntry, QAfterFilterCondition>
  servingLabelIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'servingLabel', value: ''),
      );
    });
  }

  QueryBuilder<DiaryEntry, DiaryEntry, QAfterFilterCondition> sourceEqualTo(
    FoodSource value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'source', value: value),
      );
    });
  }

  QueryBuilder<DiaryEntry, DiaryEntry, QAfterFilterCondition> sourceGreaterThan(
    FoodSource value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'source',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<DiaryEntry, DiaryEntry, QAfterFilterCondition> sourceLessThan(
    FoodSource value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'source',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<DiaryEntry, DiaryEntry, QAfterFilterCondition> sourceBetween(
    FoodSource lower,
    FoodSource upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'source',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<DiaryEntry, DiaryEntry, QAfterFilterCondition> sugarsIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'sugars'),
      );
    });
  }

  QueryBuilder<DiaryEntry, DiaryEntry, QAfterFilterCondition>
  sugarsIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'sugars'),
      );
    });
  }

  QueryBuilder<DiaryEntry, DiaryEntry, QAfterFilterCondition> sugarsEqualTo(
    double? value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'sugars',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<DiaryEntry, DiaryEntry, QAfterFilterCondition> sugarsGreaterThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'sugars',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<DiaryEntry, DiaryEntry, QAfterFilterCondition> sugarsLessThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'sugars',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<DiaryEntry, DiaryEntry, QAfterFilterCondition> sugarsBetween(
    double? lower,
    double? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'sugars',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<DiaryEntry, DiaryEntry, QAfterFilterCondition> updatedAtEqualTo(
    DateTime value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'updatedAt', value: value),
      );
    });
  }

  QueryBuilder<DiaryEntry, DiaryEntry, QAfterFilterCondition>
  updatedAtGreaterThan(DateTime value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'updatedAt',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<DiaryEntry, DiaryEntry, QAfterFilterCondition> updatedAtLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'updatedAt',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<DiaryEntry, DiaryEntry, QAfterFilterCondition> updatedAtBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'updatedAt',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }
}

extension DiaryEntryQueryObject
    on QueryBuilder<DiaryEntry, DiaryEntry, QFilterCondition> {}

extension DiaryEntryQueryLinks
    on QueryBuilder<DiaryEntry, DiaryEntry, QFilterCondition> {}

extension DiaryEntryQuerySortBy
    on QueryBuilder<DiaryEntry, DiaryEntry, QSortBy> {
  QueryBuilder<DiaryEntry, DiaryEntry, QAfterSortBy> sortByAmountG() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'amountG', Sort.asc);
    });
  }

  QueryBuilder<DiaryEntry, DiaryEntry, QAfterSortBy> sortByAmountGDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'amountG', Sort.desc);
    });
  }

  QueryBuilder<DiaryEntry, DiaryEntry, QAfterSortBy> sortByBrand() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'brand', Sort.asc);
    });
  }

  QueryBuilder<DiaryEntry, DiaryEntry, QAfterSortBy> sortByBrandDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'brand', Sort.desc);
    });
  }

  QueryBuilder<DiaryEntry, DiaryEntry, QAfterSortBy> sortByCarbs() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'carbs', Sort.asc);
    });
  }

  QueryBuilder<DiaryEntry, DiaryEntry, QAfterSortBy> sortByCarbsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'carbs', Sort.desc);
    });
  }

  QueryBuilder<DiaryEntry, DiaryEntry, QAfterSortBy> sortByClientId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'clientId', Sort.asc);
    });
  }

  QueryBuilder<DiaryEntry, DiaryEntry, QAfterSortBy> sortByClientIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'clientId', Sort.desc);
    });
  }

  QueryBuilder<DiaryEntry, DiaryEntry, QAfterSortBy> sortByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<DiaryEntry, DiaryEntry, QAfterSortBy> sortByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<DiaryEntry, DiaryEntry, QAfterSortBy> sortByDateKey() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dateKey', Sort.asc);
    });
  }

  QueryBuilder<DiaryEntry, DiaryEntry, QAfterSortBy> sortByDateKeyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dateKey', Sort.desc);
    });
  }

  QueryBuilder<DiaryEntry, DiaryEntry, QAfterSortBy> sortByDeleted() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'deleted', Sort.asc);
    });
  }

  QueryBuilder<DiaryEntry, DiaryEntry, QAfterSortBy> sortByDeletedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'deleted', Sort.desc);
    });
  }

  QueryBuilder<DiaryEntry, DiaryEntry, QAfterSortBy> sortByDirty() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dirty', Sort.asc);
    });
  }

  QueryBuilder<DiaryEntry, DiaryEntry, QAfterSortBy> sortByDirtyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dirty', Sort.desc);
    });
  }

  QueryBuilder<DiaryEntry, DiaryEntry, QAfterSortBy> sortByFat() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fat', Sort.asc);
    });
  }

  QueryBuilder<DiaryEntry, DiaryEntry, QAfterSortBy> sortByFatDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fat', Sort.desc);
    });
  }

  QueryBuilder<DiaryEntry, DiaryEntry, QAfterSortBy> sortByFiber() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fiber', Sort.asc);
    });
  }

  QueryBuilder<DiaryEntry, DiaryEntry, QAfterSortBy> sortByFiberDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fiber', Sort.desc);
    });
  }

  QueryBuilder<DiaryEntry, DiaryEntry, QAfterSortBy> sortByFoodId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'foodId', Sort.asc);
    });
  }

  QueryBuilder<DiaryEntry, DiaryEntry, QAfterSortBy> sortByFoodIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'foodId', Sort.desc);
    });
  }

  QueryBuilder<DiaryEntry, DiaryEntry, QAfterSortBy> sortByFoodName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'foodName', Sort.asc);
    });
  }

  QueryBuilder<DiaryEntry, DiaryEntry, QAfterSortBy> sortByFoodNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'foodName', Sort.desc);
    });
  }

  QueryBuilder<DiaryEntry, DiaryEntry, QAfterSortBy> sortByKcal() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'kcal', Sort.asc);
    });
  }

  QueryBuilder<DiaryEntry, DiaryEntry, QAfterSortBy> sortByKcalDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'kcal', Sort.desc);
    });
  }

  QueryBuilder<DiaryEntry, DiaryEntry, QAfterSortBy> sortByMeal() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'meal', Sort.asc);
    });
  }

  QueryBuilder<DiaryEntry, DiaryEntry, QAfterSortBy> sortByMealDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'meal', Sort.desc);
    });
  }

  QueryBuilder<DiaryEntry, DiaryEntry, QAfterSortBy> sortByProtein() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'protein', Sort.asc);
    });
  }

  QueryBuilder<DiaryEntry, DiaryEntry, QAfterSortBy> sortByProteinDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'protein', Sort.desc);
    });
  }

  QueryBuilder<DiaryEntry, DiaryEntry, QAfterSortBy> sortBySalt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'salt', Sort.asc);
    });
  }

  QueryBuilder<DiaryEntry, DiaryEntry, QAfterSortBy> sortBySaltDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'salt', Sort.desc);
    });
  }

  QueryBuilder<DiaryEntry, DiaryEntry, QAfterSortBy> sortBySatFat() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'satFat', Sort.asc);
    });
  }

  QueryBuilder<DiaryEntry, DiaryEntry, QAfterSortBy> sortBySatFatDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'satFat', Sort.desc);
    });
  }

  QueryBuilder<DiaryEntry, DiaryEntry, QAfterSortBy> sortByServingLabel() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'servingLabel', Sort.asc);
    });
  }

  QueryBuilder<DiaryEntry, DiaryEntry, QAfterSortBy> sortByServingLabelDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'servingLabel', Sort.desc);
    });
  }

  QueryBuilder<DiaryEntry, DiaryEntry, QAfterSortBy> sortBySource() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'source', Sort.asc);
    });
  }

  QueryBuilder<DiaryEntry, DiaryEntry, QAfterSortBy> sortBySourceDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'source', Sort.desc);
    });
  }

  QueryBuilder<DiaryEntry, DiaryEntry, QAfterSortBy> sortBySugars() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sugars', Sort.asc);
    });
  }

  QueryBuilder<DiaryEntry, DiaryEntry, QAfterSortBy> sortBySugarsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sugars', Sort.desc);
    });
  }

  QueryBuilder<DiaryEntry, DiaryEntry, QAfterSortBy> sortByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<DiaryEntry, DiaryEntry, QAfterSortBy> sortByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }
}

extension DiaryEntryQuerySortThenBy
    on QueryBuilder<DiaryEntry, DiaryEntry, QSortThenBy> {
  QueryBuilder<DiaryEntry, DiaryEntry, QAfterSortBy> thenByAmountG() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'amountG', Sort.asc);
    });
  }

  QueryBuilder<DiaryEntry, DiaryEntry, QAfterSortBy> thenByAmountGDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'amountG', Sort.desc);
    });
  }

  QueryBuilder<DiaryEntry, DiaryEntry, QAfterSortBy> thenByBrand() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'brand', Sort.asc);
    });
  }

  QueryBuilder<DiaryEntry, DiaryEntry, QAfterSortBy> thenByBrandDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'brand', Sort.desc);
    });
  }

  QueryBuilder<DiaryEntry, DiaryEntry, QAfterSortBy> thenByCarbs() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'carbs', Sort.asc);
    });
  }

  QueryBuilder<DiaryEntry, DiaryEntry, QAfterSortBy> thenByCarbsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'carbs', Sort.desc);
    });
  }

  QueryBuilder<DiaryEntry, DiaryEntry, QAfterSortBy> thenByClientId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'clientId', Sort.asc);
    });
  }

  QueryBuilder<DiaryEntry, DiaryEntry, QAfterSortBy> thenByClientIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'clientId', Sort.desc);
    });
  }

  QueryBuilder<DiaryEntry, DiaryEntry, QAfterSortBy> thenByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<DiaryEntry, DiaryEntry, QAfterSortBy> thenByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<DiaryEntry, DiaryEntry, QAfterSortBy> thenByDateKey() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dateKey', Sort.asc);
    });
  }

  QueryBuilder<DiaryEntry, DiaryEntry, QAfterSortBy> thenByDateKeyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dateKey', Sort.desc);
    });
  }

  QueryBuilder<DiaryEntry, DiaryEntry, QAfterSortBy> thenByDeleted() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'deleted', Sort.asc);
    });
  }

  QueryBuilder<DiaryEntry, DiaryEntry, QAfterSortBy> thenByDeletedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'deleted', Sort.desc);
    });
  }

  QueryBuilder<DiaryEntry, DiaryEntry, QAfterSortBy> thenByDirty() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dirty', Sort.asc);
    });
  }

  QueryBuilder<DiaryEntry, DiaryEntry, QAfterSortBy> thenByDirtyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dirty', Sort.desc);
    });
  }

  QueryBuilder<DiaryEntry, DiaryEntry, QAfterSortBy> thenByFat() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fat', Sort.asc);
    });
  }

  QueryBuilder<DiaryEntry, DiaryEntry, QAfterSortBy> thenByFatDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fat', Sort.desc);
    });
  }

  QueryBuilder<DiaryEntry, DiaryEntry, QAfterSortBy> thenByFiber() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fiber', Sort.asc);
    });
  }

  QueryBuilder<DiaryEntry, DiaryEntry, QAfterSortBy> thenByFiberDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fiber', Sort.desc);
    });
  }

  QueryBuilder<DiaryEntry, DiaryEntry, QAfterSortBy> thenByFoodId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'foodId', Sort.asc);
    });
  }

  QueryBuilder<DiaryEntry, DiaryEntry, QAfterSortBy> thenByFoodIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'foodId', Sort.desc);
    });
  }

  QueryBuilder<DiaryEntry, DiaryEntry, QAfterSortBy> thenByFoodName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'foodName', Sort.asc);
    });
  }

  QueryBuilder<DiaryEntry, DiaryEntry, QAfterSortBy> thenByFoodNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'foodName', Sort.desc);
    });
  }

  QueryBuilder<DiaryEntry, DiaryEntry, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<DiaryEntry, DiaryEntry, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<DiaryEntry, DiaryEntry, QAfterSortBy> thenByKcal() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'kcal', Sort.asc);
    });
  }

  QueryBuilder<DiaryEntry, DiaryEntry, QAfterSortBy> thenByKcalDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'kcal', Sort.desc);
    });
  }

  QueryBuilder<DiaryEntry, DiaryEntry, QAfterSortBy> thenByMeal() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'meal', Sort.asc);
    });
  }

  QueryBuilder<DiaryEntry, DiaryEntry, QAfterSortBy> thenByMealDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'meal', Sort.desc);
    });
  }

  QueryBuilder<DiaryEntry, DiaryEntry, QAfterSortBy> thenByProtein() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'protein', Sort.asc);
    });
  }

  QueryBuilder<DiaryEntry, DiaryEntry, QAfterSortBy> thenByProteinDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'protein', Sort.desc);
    });
  }

  QueryBuilder<DiaryEntry, DiaryEntry, QAfterSortBy> thenBySalt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'salt', Sort.asc);
    });
  }

  QueryBuilder<DiaryEntry, DiaryEntry, QAfterSortBy> thenBySaltDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'salt', Sort.desc);
    });
  }

  QueryBuilder<DiaryEntry, DiaryEntry, QAfterSortBy> thenBySatFat() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'satFat', Sort.asc);
    });
  }

  QueryBuilder<DiaryEntry, DiaryEntry, QAfterSortBy> thenBySatFatDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'satFat', Sort.desc);
    });
  }

  QueryBuilder<DiaryEntry, DiaryEntry, QAfterSortBy> thenByServingLabel() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'servingLabel', Sort.asc);
    });
  }

  QueryBuilder<DiaryEntry, DiaryEntry, QAfterSortBy> thenByServingLabelDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'servingLabel', Sort.desc);
    });
  }

  QueryBuilder<DiaryEntry, DiaryEntry, QAfterSortBy> thenBySource() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'source', Sort.asc);
    });
  }

  QueryBuilder<DiaryEntry, DiaryEntry, QAfterSortBy> thenBySourceDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'source', Sort.desc);
    });
  }

  QueryBuilder<DiaryEntry, DiaryEntry, QAfterSortBy> thenBySugars() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sugars', Sort.asc);
    });
  }

  QueryBuilder<DiaryEntry, DiaryEntry, QAfterSortBy> thenBySugarsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sugars', Sort.desc);
    });
  }

  QueryBuilder<DiaryEntry, DiaryEntry, QAfterSortBy> thenByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<DiaryEntry, DiaryEntry, QAfterSortBy> thenByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }
}

extension DiaryEntryQueryWhereDistinct
    on QueryBuilder<DiaryEntry, DiaryEntry, QDistinct> {
  QueryBuilder<DiaryEntry, DiaryEntry, QDistinct> distinctByAmountG() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'amountG');
    });
  }

  QueryBuilder<DiaryEntry, DiaryEntry, QDistinct> distinctByBrand({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'brand', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<DiaryEntry, DiaryEntry, QDistinct> distinctByCarbs() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'carbs');
    });
  }

  QueryBuilder<DiaryEntry, DiaryEntry, QDistinct> distinctByClientId({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'clientId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<DiaryEntry, DiaryEntry, QDistinct> distinctByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'createdAt');
    });
  }

  QueryBuilder<DiaryEntry, DiaryEntry, QDistinct> distinctByDateKey() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'dateKey');
    });
  }

  QueryBuilder<DiaryEntry, DiaryEntry, QDistinct> distinctByDeleted() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'deleted');
    });
  }

  QueryBuilder<DiaryEntry, DiaryEntry, QDistinct> distinctByDirty() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'dirty');
    });
  }

  QueryBuilder<DiaryEntry, DiaryEntry, QDistinct> distinctByFat() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'fat');
    });
  }

  QueryBuilder<DiaryEntry, DiaryEntry, QDistinct> distinctByFiber() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'fiber');
    });
  }

  QueryBuilder<DiaryEntry, DiaryEntry, QDistinct> distinctByFoodId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'foodId');
    });
  }

  QueryBuilder<DiaryEntry, DiaryEntry, QDistinct> distinctByFoodName({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'foodName', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<DiaryEntry, DiaryEntry, QDistinct> distinctByKcal() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'kcal');
    });
  }

  QueryBuilder<DiaryEntry, DiaryEntry, QDistinct> distinctByMeal() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'meal');
    });
  }

  QueryBuilder<DiaryEntry, DiaryEntry, QDistinct> distinctByProtein() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'protein');
    });
  }

  QueryBuilder<DiaryEntry, DiaryEntry, QDistinct> distinctBySalt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'salt');
    });
  }

  QueryBuilder<DiaryEntry, DiaryEntry, QDistinct> distinctBySatFat() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'satFat');
    });
  }

  QueryBuilder<DiaryEntry, DiaryEntry, QDistinct> distinctByServingLabel({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'servingLabel', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<DiaryEntry, DiaryEntry, QDistinct> distinctBySource() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'source');
    });
  }

  QueryBuilder<DiaryEntry, DiaryEntry, QDistinct> distinctBySugars() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'sugars');
    });
  }

  QueryBuilder<DiaryEntry, DiaryEntry, QDistinct> distinctByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'updatedAt');
    });
  }
}

extension DiaryEntryQueryProperty
    on QueryBuilder<DiaryEntry, DiaryEntry, QQueryProperty> {
  QueryBuilder<DiaryEntry, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<DiaryEntry, double, QQueryOperations> amountGProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'amountG');
    });
  }

  QueryBuilder<DiaryEntry, String?, QQueryOperations> brandProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'brand');
    });
  }

  QueryBuilder<DiaryEntry, double, QQueryOperations> carbsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'carbs');
    });
  }

  QueryBuilder<DiaryEntry, String, QQueryOperations> clientIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'clientId');
    });
  }

  QueryBuilder<DiaryEntry, DateTime, QQueryOperations> createdAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'createdAt');
    });
  }

  QueryBuilder<DiaryEntry, int, QQueryOperations> dateKeyProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'dateKey');
    });
  }

  QueryBuilder<DiaryEntry, bool, QQueryOperations> deletedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'deleted');
    });
  }

  QueryBuilder<DiaryEntry, bool, QQueryOperations> dirtyProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'dirty');
    });
  }

  QueryBuilder<DiaryEntry, double, QQueryOperations> fatProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'fat');
    });
  }

  QueryBuilder<DiaryEntry, double?, QQueryOperations> fiberProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'fiber');
    });
  }

  QueryBuilder<DiaryEntry, int, QQueryOperations> foodIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'foodId');
    });
  }

  QueryBuilder<DiaryEntry, String, QQueryOperations> foodNameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'foodName');
    });
  }

  QueryBuilder<DiaryEntry, double, QQueryOperations> kcalProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'kcal');
    });
  }

  QueryBuilder<DiaryEntry, MealType, QQueryOperations> mealProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'meal');
    });
  }

  QueryBuilder<DiaryEntry, double, QQueryOperations> proteinProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'protein');
    });
  }

  QueryBuilder<DiaryEntry, double?, QQueryOperations> saltProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'salt');
    });
  }

  QueryBuilder<DiaryEntry, double?, QQueryOperations> satFatProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'satFat');
    });
  }

  QueryBuilder<DiaryEntry, String?, QQueryOperations> servingLabelProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'servingLabel');
    });
  }

  QueryBuilder<DiaryEntry, FoodSource, QQueryOperations> sourceProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'source');
    });
  }

  QueryBuilder<DiaryEntry, double?, QQueryOperations> sugarsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'sugars');
    });
  }

  QueryBuilder<DiaryEntry, DateTime, QQueryOperations> updatedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'updatedAt');
    });
  }
}
