// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'food.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetFoodCollection on Isar {
  IsarCollection<Food> get foods => this.collection();
}

const FoodSchema = CollectionSchema(
  name: r'Food',
  id: -1224223000086120450,
  properties: {
    r'alcohol100g': PropertySchema(
      id: 0,
      name: r'alcohol100g',
      type: IsarType.double,
    ),
    r'barcode': PropertySchema(id: 1, name: r'barcode', type: IsarType.string),
    r'brand': PropertySchema(id: 2, name: r'brand', type: IsarType.string),
    r'cachedAt': PropertySchema(
      id: 3,
      name: r'cachedAt',
      type: IsarType.dateTime,
    ),
    r'carbs100g': PropertySchema(
      id: 4,
      name: r'carbs100g',
      type: IsarType.double,
    ),
    r'catalogId': PropertySchema(
      id: 5,
      name: r'catalogId',
      type: IsarType.string,
    ),
    r'clientId': PropertySchema(
      id: 6,
      name: r'clientId',
      type: IsarType.string,
    ),
    r'dataVersion': PropertySchema(
      id: 7,
      name: r'dataVersion',
      type: IsarType.long,
    ),
    r'deleted': PropertySchema(id: 8, name: r'deleted', type: IsarType.bool),
    r'dirty': PropertySchema(id: 9, name: r'dirty', type: IsarType.bool),
    r'fat100g': PropertySchema(id: 10, name: r'fat100g', type: IsarType.double),
    r'fiber100g': PropertySchema(
      id: 11,
      name: r'fiber100g',
      type: IsarType.double,
    ),
    r'isFavorite': PropertySchema(
      id: 12,
      name: r'isFavorite',
      type: IsarType.bool,
    ),
    r'kcal100g': PropertySchema(
      id: 13,
      name: r'kcal100g',
      type: IsarType.double,
    ),
    r'kind': PropertySchema(
      id: 14,
      name: r'kind',
      type: IsarType.byte,
      enumMap: _FoodkindEnumValueMap,
    ),
    r'lastAmountG': PropertySchema(
      id: 15,
      name: r'lastAmountG',
      type: IsarType.double,
    ),
    r'lastUsedAt': PropertySchema(
      id: 16,
      name: r'lastUsedAt',
      type: IsarType.dateTime,
    ),
    r'name': PropertySchema(id: 17, name: r'name', type: IsarType.string),
    r'nameNormalized': PropertySchema(
      id: 18,
      name: r'nameNormalized',
      type: IsarType.string,
    ),
    r'nevoCode': PropertySchema(
      id: 19,
      name: r'nevoCode',
      type: IsarType.string,
    ),
    r'nlRelevance': PropertySchema(
      id: 20,
      name: r'nlRelevance',
      type: IsarType.long,
    ),
    r'nutrientsJson': PropertySchema(
      id: 21,
      name: r'nutrientsJson',
      type: IsarType.string,
    ),
    r'offId': PropertySchema(id: 22, name: r'offId', type: IsarType.string),
    r'popularity': PropertySchema(
      id: 23,
      name: r'popularity',
      type: IsarType.long,
    ),
    r'protein100g': PropertySchema(
      id: 24,
      name: r'protein100g',
      type: IsarType.double,
    ),
    r'qualityScore': PropertySchema(
      id: 25,
      name: r'qualityScore',
      type: IsarType.long,
    ),
    r'salt100g': PropertySchema(
      id: 26,
      name: r'salt100g',
      type: IsarType.double,
    ),
    r'satFat100g': PropertySchema(
      id: 27,
      name: r'satFat100g',
      type: IsarType.double,
    ),
    r'servingG': PropertySchema(
      id: 28,
      name: r'servingG',
      type: IsarType.double,
    ),
    r'servingLabel': PropertySchema(
      id: 29,
      name: r'servingLabel',
      type: IsarType.string,
    ),
    r'source': PropertySchema(
      id: 30,
      name: r'source',
      type: IsarType.byte,
      enumMap: _FoodsourceEnumValueMap,
    ),
    r'sugars100g': PropertySchema(
      id: 31,
      name: r'sugars100g',
      type: IsarType.double,
    ),
    r'updatedAt': PropertySchema(
      id: 32,
      name: r'updatedAt',
      type: IsarType.dateTime,
    ),
    r'userOverridden': PropertySchema(
      id: 33,
      name: r'userOverridden',
      type: IsarType.bool,
    ),
  },

  estimateSize: _foodEstimateSize,
  serialize: _foodSerialize,
  deserialize: _foodDeserialize,
  deserializeProp: _foodDeserializeProp,
  idName: r'id',
  indexes: {
    r'catalogId': IndexSchema(
      id: 4783826579792418641,
      name: r'catalogId',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'catalogId',
          type: IndexType.hash,
          caseSensitive: true,
        ),
      ],
    ),
    r'barcode': IndexSchema(
      id: 1156800733621869998,
      name: r'barcode',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'barcode',
          type: IndexType.hash,
          caseSensitive: true,
        ),
      ],
    ),
    r'nevoCode': IndexSchema(
      id: -2188635523916838472,
      name: r'nevoCode',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'nevoCode',
          type: IndexType.hash,
          caseSensitive: true,
        ),
      ],
    ),
    r'offId': IndexSchema(
      id: -8337359215929370163,
      name: r'offId',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'offId',
          type: IndexType.hash,
          caseSensitive: true,
        ),
      ],
    ),
    r'name': IndexSchema(
      id: 879695947855722453,
      name: r'name',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'name',
          type: IndexType.value,
          caseSensitive: false,
        ),
      ],
    ),
    r'nameNormalized': IndexSchema(
      id: 4734312256080033168,
      name: r'nameNormalized',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'nameNormalized',
          type: IndexType.value,
          caseSensitive: false,
        ),
      ],
    ),
    r'isFavorite': IndexSchema(
      id: 5742774614603939776,
      name: r'isFavorite',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'isFavorite',
          type: IndexType.value,
          caseSensitive: false,
        ),
      ],
    ),
    r'lastUsedAt': IndexSchema(
      id: 458483797936957613,
      name: r'lastUsedAt',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'lastUsedAt',
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

  getId: _foodGetId,
  getLinks: _foodGetLinks,
  attach: _foodAttach,
  version: '3.3.2',
);

int _foodEstimateSize(
  Food object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final value = object.barcode;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.brand;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.catalogId;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.clientId;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.name.length * 3;
  bytesCount += 3 + object.nameNormalized.length * 3;
  {
    final value = object.nevoCode;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.nutrientsJson;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.offId;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.servingLabel;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  return bytesCount;
}

void _foodSerialize(
  Food object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeDouble(offsets[0], object.alcohol100g);
  writer.writeString(offsets[1], object.barcode);
  writer.writeString(offsets[2], object.brand);
  writer.writeDateTime(offsets[3], object.cachedAt);
  writer.writeDouble(offsets[4], object.carbs100g);
  writer.writeString(offsets[5], object.catalogId);
  writer.writeString(offsets[6], object.clientId);
  writer.writeLong(offsets[7], object.dataVersion);
  writer.writeBool(offsets[8], object.deleted);
  writer.writeBool(offsets[9], object.dirty);
  writer.writeDouble(offsets[10], object.fat100g);
  writer.writeDouble(offsets[11], object.fiber100g);
  writer.writeBool(offsets[12], object.isFavorite);
  writer.writeDouble(offsets[13], object.kcal100g);
  writer.writeByte(offsets[14], object.kind.index);
  writer.writeDouble(offsets[15], object.lastAmountG);
  writer.writeDateTime(offsets[16], object.lastUsedAt);
  writer.writeString(offsets[17], object.name);
  writer.writeString(offsets[18], object.nameNormalized);
  writer.writeString(offsets[19], object.nevoCode);
  writer.writeLong(offsets[20], object.nlRelevance);
  writer.writeString(offsets[21], object.nutrientsJson);
  writer.writeString(offsets[22], object.offId);
  writer.writeLong(offsets[23], object.popularity);
  writer.writeDouble(offsets[24], object.protein100g);
  writer.writeLong(offsets[25], object.qualityScore);
  writer.writeDouble(offsets[26], object.salt100g);
  writer.writeDouble(offsets[27], object.satFat100g);
  writer.writeDouble(offsets[28], object.servingG);
  writer.writeString(offsets[29], object.servingLabel);
  writer.writeByte(offsets[30], object.source.index);
  writer.writeDouble(offsets[31], object.sugars100g);
  writer.writeDateTime(offsets[32], object.updatedAt);
  writer.writeBool(offsets[33], object.userOverridden);
}

Food _foodDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = Food();
  object.alcohol100g = reader.readDoubleOrNull(offsets[0]);
  object.barcode = reader.readStringOrNull(offsets[1]);
  object.brand = reader.readStringOrNull(offsets[2]);
  object.cachedAt = reader.readDateTimeOrNull(offsets[3]);
  object.carbs100g = reader.readDouble(offsets[4]);
  object.catalogId = reader.readStringOrNull(offsets[5]);
  object.clientId = reader.readStringOrNull(offsets[6]);
  object.dataVersion = reader.readLong(offsets[7]);
  object.deleted = reader.readBool(offsets[8]);
  object.dirty = reader.readBool(offsets[9]);
  object.fat100g = reader.readDouble(offsets[10]);
  object.fiber100g = reader.readDoubleOrNull(offsets[11]);
  object.id = id;
  object.isFavorite = reader.readBool(offsets[12]);
  object.kcal100g = reader.readDouble(offsets[13]);
  object.kind =
      _FoodkindValueEnumMap[reader.readByteOrNull(offsets[14])] ??
      FoodKind.generic;
  object.lastAmountG = reader.readDoubleOrNull(offsets[15]);
  object.lastUsedAt = reader.readDateTimeOrNull(offsets[16]);
  object.name = reader.readString(offsets[17]);
  object.nameNormalized = reader.readString(offsets[18]);
  object.nevoCode = reader.readStringOrNull(offsets[19]);
  object.nlRelevance = reader.readLong(offsets[20]);
  object.nutrientsJson = reader.readStringOrNull(offsets[21]);
  object.offId = reader.readStringOrNull(offsets[22]);
  object.popularity = reader.readLong(offsets[23]);
  object.protein100g = reader.readDouble(offsets[24]);
  object.qualityScore = reader.readLong(offsets[25]);
  object.salt100g = reader.readDoubleOrNull(offsets[26]);
  object.satFat100g = reader.readDoubleOrNull(offsets[27]);
  object.servingG = reader.readDoubleOrNull(offsets[28]);
  object.servingLabel = reader.readStringOrNull(offsets[29]);
  object.source =
      _FoodsourceValueEnumMap[reader.readByteOrNull(offsets[30])] ??
      FoodSource.off;
  object.sugars100g = reader.readDoubleOrNull(offsets[31]);
  object.updatedAt = reader.readDateTimeOrNull(offsets[32]);
  object.userOverridden = reader.readBool(offsets[33]);
  return object;
}

P _foodDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readDoubleOrNull(offset)) as P;
    case 1:
      return (reader.readStringOrNull(offset)) as P;
    case 2:
      return (reader.readStringOrNull(offset)) as P;
    case 3:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 4:
      return (reader.readDouble(offset)) as P;
    case 5:
      return (reader.readStringOrNull(offset)) as P;
    case 6:
      return (reader.readStringOrNull(offset)) as P;
    case 7:
      return (reader.readLong(offset)) as P;
    case 8:
      return (reader.readBool(offset)) as P;
    case 9:
      return (reader.readBool(offset)) as P;
    case 10:
      return (reader.readDouble(offset)) as P;
    case 11:
      return (reader.readDoubleOrNull(offset)) as P;
    case 12:
      return (reader.readBool(offset)) as P;
    case 13:
      return (reader.readDouble(offset)) as P;
    case 14:
      return (_FoodkindValueEnumMap[reader.readByteOrNull(offset)] ??
              FoodKind.generic)
          as P;
    case 15:
      return (reader.readDoubleOrNull(offset)) as P;
    case 16:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 17:
      return (reader.readString(offset)) as P;
    case 18:
      return (reader.readString(offset)) as P;
    case 19:
      return (reader.readStringOrNull(offset)) as P;
    case 20:
      return (reader.readLong(offset)) as P;
    case 21:
      return (reader.readStringOrNull(offset)) as P;
    case 22:
      return (reader.readStringOrNull(offset)) as P;
    case 23:
      return (reader.readLong(offset)) as P;
    case 24:
      return (reader.readDouble(offset)) as P;
    case 25:
      return (reader.readLong(offset)) as P;
    case 26:
      return (reader.readDoubleOrNull(offset)) as P;
    case 27:
      return (reader.readDoubleOrNull(offset)) as P;
    case 28:
      return (reader.readDoubleOrNull(offset)) as P;
    case 29:
      return (reader.readStringOrNull(offset)) as P;
    case 30:
      return (_FoodsourceValueEnumMap[reader.readByteOrNull(offset)] ??
              FoodSource.off)
          as P;
    case 31:
      return (reader.readDoubleOrNull(offset)) as P;
    case 32:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 33:
      return (reader.readBool(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

const _FoodkindEnumValueMap = {'generic': 0, 'branded': 1};
const _FoodkindValueEnumMap = {0: FoodKind.generic, 1: FoodKind.branded};
const _FoodsourceEnumValueMap = {'off': 0, 'nevo': 1, 'custom': 2};
const _FoodsourceValueEnumMap = {
  0: FoodSource.off,
  1: FoodSource.nevo,
  2: FoodSource.custom,
};

Id _foodGetId(Food object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _foodGetLinks(Food object) {
  return [];
}

void _foodAttach(IsarCollection<dynamic> col, Id id, Food object) {
  object.id = id;
}

extension FoodQueryWhereSort on QueryBuilder<Food, Food, QWhere> {
  QueryBuilder<Food, Food, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }

  QueryBuilder<Food, Food, QAfterWhere> anyName() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'name'),
      );
    });
  }

  QueryBuilder<Food, Food, QAfterWhere> anyNameNormalized() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'nameNormalized'),
      );
    });
  }

  QueryBuilder<Food, Food, QAfterWhere> anyIsFavorite() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'isFavorite'),
      );
    });
  }

  QueryBuilder<Food, Food, QAfterWhere> anyLastUsedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'lastUsedAt'),
      );
    });
  }

  QueryBuilder<Food, Food, QAfterWhere> anyDirty() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'dirty'),
      );
    });
  }

  QueryBuilder<Food, Food, QAfterWhere> anyDeleted() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'deleted'),
      );
    });
  }
}

extension FoodQueryWhere on QueryBuilder<Food, Food, QWhereClause> {
  QueryBuilder<Food, Food, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(lower: id, upper: id));
    });
  }

  QueryBuilder<Food, Food, QAfterWhereClause> idNotEqualTo(Id id) {
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

  QueryBuilder<Food, Food, QAfterWhereClause> idGreaterThan(
    Id id, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<Food, Food, QAfterWhereClause> idLessThan(
    Id id, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<Food, Food, QAfterWhereClause> idBetween(
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

  QueryBuilder<Food, Food, QAfterWhereClause> catalogIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.equalTo(indexName: r'catalogId', value: [null]),
      );
    });
  }

  QueryBuilder<Food, Food, QAfterWhereClause> catalogIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.between(
          indexName: r'catalogId',
          lower: [null],
          includeLower: false,
          upper: [],
        ),
      );
    });
  }

  QueryBuilder<Food, Food, QAfterWhereClause> catalogIdEqualTo(
    String? catalogId,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.equalTo(indexName: r'catalogId', value: [catalogId]),
      );
    });
  }

  QueryBuilder<Food, Food, QAfterWhereClause> catalogIdNotEqualTo(
    String? catalogId,
  ) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'catalogId',
                lower: [],
                upper: [catalogId],
                includeUpper: false,
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'catalogId',
                lower: [catalogId],
                includeLower: false,
                upper: [],
              ),
            );
      } else {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'catalogId',
                lower: [catalogId],
                includeLower: false,
                upper: [],
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'catalogId',
                lower: [],
                upper: [catalogId],
                includeUpper: false,
              ),
            );
      }
    });
  }

  QueryBuilder<Food, Food, QAfterWhereClause> barcodeIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.equalTo(indexName: r'barcode', value: [null]),
      );
    });
  }

  QueryBuilder<Food, Food, QAfterWhereClause> barcodeIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.between(
          indexName: r'barcode',
          lower: [null],
          includeLower: false,
          upper: [],
        ),
      );
    });
  }

  QueryBuilder<Food, Food, QAfterWhereClause> barcodeEqualTo(String? barcode) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.equalTo(indexName: r'barcode', value: [barcode]),
      );
    });
  }

  QueryBuilder<Food, Food, QAfterWhereClause> barcodeNotEqualTo(
    String? barcode,
  ) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'barcode',
                lower: [],
                upper: [barcode],
                includeUpper: false,
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'barcode',
                lower: [barcode],
                includeLower: false,
                upper: [],
              ),
            );
      } else {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'barcode',
                lower: [barcode],
                includeLower: false,
                upper: [],
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'barcode',
                lower: [],
                upper: [barcode],
                includeUpper: false,
              ),
            );
      }
    });
  }

  QueryBuilder<Food, Food, QAfterWhereClause> nevoCodeIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.equalTo(indexName: r'nevoCode', value: [null]),
      );
    });
  }

  QueryBuilder<Food, Food, QAfterWhereClause> nevoCodeIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.between(
          indexName: r'nevoCode',
          lower: [null],
          includeLower: false,
          upper: [],
        ),
      );
    });
  }

  QueryBuilder<Food, Food, QAfterWhereClause> nevoCodeEqualTo(
    String? nevoCode,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.equalTo(indexName: r'nevoCode', value: [nevoCode]),
      );
    });
  }

  QueryBuilder<Food, Food, QAfterWhereClause> nevoCodeNotEqualTo(
    String? nevoCode,
  ) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'nevoCode',
                lower: [],
                upper: [nevoCode],
                includeUpper: false,
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'nevoCode',
                lower: [nevoCode],
                includeLower: false,
                upper: [],
              ),
            );
      } else {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'nevoCode',
                lower: [nevoCode],
                includeLower: false,
                upper: [],
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'nevoCode',
                lower: [],
                upper: [nevoCode],
                includeUpper: false,
              ),
            );
      }
    });
  }

  QueryBuilder<Food, Food, QAfterWhereClause> offIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.equalTo(indexName: r'offId', value: [null]),
      );
    });
  }

  QueryBuilder<Food, Food, QAfterWhereClause> offIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.between(
          indexName: r'offId',
          lower: [null],
          includeLower: false,
          upper: [],
        ),
      );
    });
  }

  QueryBuilder<Food, Food, QAfterWhereClause> offIdEqualTo(String? offId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.equalTo(indexName: r'offId', value: [offId]),
      );
    });
  }

  QueryBuilder<Food, Food, QAfterWhereClause> offIdNotEqualTo(String? offId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'offId',
                lower: [],
                upper: [offId],
                includeUpper: false,
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'offId',
                lower: [offId],
                includeLower: false,
                upper: [],
              ),
            );
      } else {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'offId',
                lower: [offId],
                includeLower: false,
                upper: [],
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'offId',
                lower: [],
                upper: [offId],
                includeUpper: false,
              ),
            );
      }
    });
  }

  QueryBuilder<Food, Food, QAfterWhereClause> nameEqualTo(String name) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.equalTo(indexName: r'name', value: [name]),
      );
    });
  }

  QueryBuilder<Food, Food, QAfterWhereClause> nameNotEqualTo(String name) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'name',
                lower: [],
                upper: [name],
                includeUpper: false,
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'name',
                lower: [name],
                includeLower: false,
                upper: [],
              ),
            );
      } else {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'name',
                lower: [name],
                includeLower: false,
                upper: [],
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'name',
                lower: [],
                upper: [name],
                includeUpper: false,
              ),
            );
      }
    });
  }

  QueryBuilder<Food, Food, QAfterWhereClause> nameGreaterThan(
    String name, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.between(
          indexName: r'name',
          lower: [name],
          includeLower: include,
          upper: [],
        ),
      );
    });
  }

  QueryBuilder<Food, Food, QAfterWhereClause> nameLessThan(
    String name, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.between(
          indexName: r'name',
          lower: [],
          upper: [name],
          includeUpper: include,
        ),
      );
    });
  }

  QueryBuilder<Food, Food, QAfterWhereClause> nameBetween(
    String lowerName,
    String upperName, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.between(
          indexName: r'name',
          lower: [lowerName],
          includeLower: includeLower,
          upper: [upperName],
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<Food, Food, QAfterWhereClause> nameStartsWith(
    String NamePrefix,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.between(
          indexName: r'name',
          lower: [NamePrefix],
          upper: ['$NamePrefix\u{FFFFF}'],
        ),
      );
    });
  }

  QueryBuilder<Food, Food, QAfterWhereClause> nameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.equalTo(indexName: r'name', value: ['']),
      );
    });
  }

  QueryBuilder<Food, Food, QAfterWhereClause> nameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IndexWhereClause.lessThan(indexName: r'name', upper: ['']),
            )
            .addWhereClause(
              IndexWhereClause.greaterThan(indexName: r'name', lower: ['']),
            );
      } else {
        return query
            .addWhereClause(
              IndexWhereClause.greaterThan(indexName: r'name', lower: ['']),
            )
            .addWhereClause(
              IndexWhereClause.lessThan(indexName: r'name', upper: ['']),
            );
      }
    });
  }

  QueryBuilder<Food, Food, QAfterWhereClause> nameNormalizedEqualTo(
    String nameNormalized,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.equalTo(
          indexName: r'nameNormalized',
          value: [nameNormalized],
        ),
      );
    });
  }

  QueryBuilder<Food, Food, QAfterWhereClause> nameNormalizedNotEqualTo(
    String nameNormalized,
  ) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'nameNormalized',
                lower: [],
                upper: [nameNormalized],
                includeUpper: false,
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'nameNormalized',
                lower: [nameNormalized],
                includeLower: false,
                upper: [],
              ),
            );
      } else {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'nameNormalized',
                lower: [nameNormalized],
                includeLower: false,
                upper: [],
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'nameNormalized',
                lower: [],
                upper: [nameNormalized],
                includeUpper: false,
              ),
            );
      }
    });
  }

  QueryBuilder<Food, Food, QAfterWhereClause> nameNormalizedGreaterThan(
    String nameNormalized, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.between(
          indexName: r'nameNormalized',
          lower: [nameNormalized],
          includeLower: include,
          upper: [],
        ),
      );
    });
  }

  QueryBuilder<Food, Food, QAfterWhereClause> nameNormalizedLessThan(
    String nameNormalized, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.between(
          indexName: r'nameNormalized',
          lower: [],
          upper: [nameNormalized],
          includeUpper: include,
        ),
      );
    });
  }

  QueryBuilder<Food, Food, QAfterWhereClause> nameNormalizedBetween(
    String lowerNameNormalized,
    String upperNameNormalized, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.between(
          indexName: r'nameNormalized',
          lower: [lowerNameNormalized],
          includeLower: includeLower,
          upper: [upperNameNormalized],
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<Food, Food, QAfterWhereClause> nameNormalizedStartsWith(
    String NameNormalizedPrefix,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.between(
          indexName: r'nameNormalized',
          lower: [NameNormalizedPrefix],
          upper: ['$NameNormalizedPrefix\u{FFFFF}'],
        ),
      );
    });
  }

  QueryBuilder<Food, Food, QAfterWhereClause> nameNormalizedIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.equalTo(indexName: r'nameNormalized', value: ['']),
      );
    });
  }

  QueryBuilder<Food, Food, QAfterWhereClause> nameNormalizedIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IndexWhereClause.lessThan(
                indexName: r'nameNormalized',
                upper: [''],
              ),
            )
            .addWhereClause(
              IndexWhereClause.greaterThan(
                indexName: r'nameNormalized',
                lower: [''],
              ),
            );
      } else {
        return query
            .addWhereClause(
              IndexWhereClause.greaterThan(
                indexName: r'nameNormalized',
                lower: [''],
              ),
            )
            .addWhereClause(
              IndexWhereClause.lessThan(
                indexName: r'nameNormalized',
                upper: [''],
              ),
            );
      }
    });
  }

  QueryBuilder<Food, Food, QAfterWhereClause> isFavoriteEqualTo(
    bool isFavorite,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.equalTo(indexName: r'isFavorite', value: [isFavorite]),
      );
    });
  }

  QueryBuilder<Food, Food, QAfterWhereClause> isFavoriteNotEqualTo(
    bool isFavorite,
  ) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'isFavorite',
                lower: [],
                upper: [isFavorite],
                includeUpper: false,
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'isFavorite',
                lower: [isFavorite],
                includeLower: false,
                upper: [],
              ),
            );
      } else {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'isFavorite',
                lower: [isFavorite],
                includeLower: false,
                upper: [],
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'isFavorite',
                lower: [],
                upper: [isFavorite],
                includeUpper: false,
              ),
            );
      }
    });
  }

  QueryBuilder<Food, Food, QAfterWhereClause> lastUsedAtIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.equalTo(indexName: r'lastUsedAt', value: [null]),
      );
    });
  }

  QueryBuilder<Food, Food, QAfterWhereClause> lastUsedAtIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.between(
          indexName: r'lastUsedAt',
          lower: [null],
          includeLower: false,
          upper: [],
        ),
      );
    });
  }

  QueryBuilder<Food, Food, QAfterWhereClause> lastUsedAtEqualTo(
    DateTime? lastUsedAt,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.equalTo(indexName: r'lastUsedAt', value: [lastUsedAt]),
      );
    });
  }

  QueryBuilder<Food, Food, QAfterWhereClause> lastUsedAtNotEqualTo(
    DateTime? lastUsedAt,
  ) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'lastUsedAt',
                lower: [],
                upper: [lastUsedAt],
                includeUpper: false,
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'lastUsedAt',
                lower: [lastUsedAt],
                includeLower: false,
                upper: [],
              ),
            );
      } else {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'lastUsedAt',
                lower: [lastUsedAt],
                includeLower: false,
                upper: [],
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'lastUsedAt',
                lower: [],
                upper: [lastUsedAt],
                includeUpper: false,
              ),
            );
      }
    });
  }

  QueryBuilder<Food, Food, QAfterWhereClause> lastUsedAtGreaterThan(
    DateTime? lastUsedAt, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.between(
          indexName: r'lastUsedAt',
          lower: [lastUsedAt],
          includeLower: include,
          upper: [],
        ),
      );
    });
  }

  QueryBuilder<Food, Food, QAfterWhereClause> lastUsedAtLessThan(
    DateTime? lastUsedAt, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.between(
          indexName: r'lastUsedAt',
          lower: [],
          upper: [lastUsedAt],
          includeUpper: include,
        ),
      );
    });
  }

  QueryBuilder<Food, Food, QAfterWhereClause> lastUsedAtBetween(
    DateTime? lowerLastUsedAt,
    DateTime? upperLastUsedAt, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.between(
          indexName: r'lastUsedAt',
          lower: [lowerLastUsedAt],
          includeLower: includeLower,
          upper: [upperLastUsedAt],
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<Food, Food, QAfterWhereClause> clientIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.equalTo(indexName: r'clientId', value: [null]),
      );
    });
  }

  QueryBuilder<Food, Food, QAfterWhereClause> clientIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.between(
          indexName: r'clientId',
          lower: [null],
          includeLower: false,
          upper: [],
        ),
      );
    });
  }

  QueryBuilder<Food, Food, QAfterWhereClause> clientIdEqualTo(
    String? clientId,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.equalTo(indexName: r'clientId', value: [clientId]),
      );
    });
  }

  QueryBuilder<Food, Food, QAfterWhereClause> clientIdNotEqualTo(
    String? clientId,
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

  QueryBuilder<Food, Food, QAfterWhereClause> dirtyEqualTo(bool dirty) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.equalTo(indexName: r'dirty', value: [dirty]),
      );
    });
  }

  QueryBuilder<Food, Food, QAfterWhereClause> dirtyNotEqualTo(bool dirty) {
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

  QueryBuilder<Food, Food, QAfterWhereClause> deletedEqualTo(bool deleted) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.equalTo(indexName: r'deleted', value: [deleted]),
      );
    });
  }

  QueryBuilder<Food, Food, QAfterWhereClause> deletedNotEqualTo(bool deleted) {
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

extension FoodQueryFilter on QueryBuilder<Food, Food, QFilterCondition> {
  QueryBuilder<Food, Food, QAfterFilterCondition> alcohol100gIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'alcohol100g'),
      );
    });
  }

  QueryBuilder<Food, Food, QAfterFilterCondition> alcohol100gIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'alcohol100g'),
      );
    });
  }

  QueryBuilder<Food, Food, QAfterFilterCondition> alcohol100gEqualTo(
    double? value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'alcohol100g',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<Food, Food, QAfterFilterCondition> alcohol100gGreaterThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'alcohol100g',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<Food, Food, QAfterFilterCondition> alcohol100gLessThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'alcohol100g',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<Food, Food, QAfterFilterCondition> alcohol100gBetween(
    double? lower,
    double? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'alcohol100g',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<Food, Food, QAfterFilterCondition> barcodeIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'barcode'),
      );
    });
  }

  QueryBuilder<Food, Food, QAfterFilterCondition> barcodeIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'barcode'),
      );
    });
  }

  QueryBuilder<Food, Food, QAfterFilterCondition> barcodeEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'barcode',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Food, Food, QAfterFilterCondition> barcodeGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'barcode',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Food, Food, QAfterFilterCondition> barcodeLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'barcode',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Food, Food, QAfterFilterCondition> barcodeBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'barcode',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Food, Food, QAfterFilterCondition> barcodeStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'barcode',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Food, Food, QAfterFilterCondition> barcodeEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'barcode',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Food, Food, QAfterFilterCondition> barcodeContains(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'barcode',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Food, Food, QAfterFilterCondition> barcodeMatches(
    String pattern, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'barcode',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Food, Food, QAfterFilterCondition> barcodeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'barcode', value: ''),
      );
    });
  }

  QueryBuilder<Food, Food, QAfterFilterCondition> barcodeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'barcode', value: ''),
      );
    });
  }

  QueryBuilder<Food, Food, QAfterFilterCondition> brandIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'brand'),
      );
    });
  }

  QueryBuilder<Food, Food, QAfterFilterCondition> brandIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'brand'),
      );
    });
  }

  QueryBuilder<Food, Food, QAfterFilterCondition> brandEqualTo(
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

  QueryBuilder<Food, Food, QAfterFilterCondition> brandGreaterThan(
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

  QueryBuilder<Food, Food, QAfterFilterCondition> brandLessThan(
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

  QueryBuilder<Food, Food, QAfterFilterCondition> brandBetween(
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

  QueryBuilder<Food, Food, QAfterFilterCondition> brandStartsWith(
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

  QueryBuilder<Food, Food, QAfterFilterCondition> brandEndsWith(
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

  QueryBuilder<Food, Food, QAfterFilterCondition> brandContains(
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

  QueryBuilder<Food, Food, QAfterFilterCondition> brandMatches(
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

  QueryBuilder<Food, Food, QAfterFilterCondition> brandIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'brand', value: ''),
      );
    });
  }

  QueryBuilder<Food, Food, QAfterFilterCondition> brandIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'brand', value: ''),
      );
    });
  }

  QueryBuilder<Food, Food, QAfterFilterCondition> cachedAtIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'cachedAt'),
      );
    });
  }

  QueryBuilder<Food, Food, QAfterFilterCondition> cachedAtIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'cachedAt'),
      );
    });
  }

  QueryBuilder<Food, Food, QAfterFilterCondition> cachedAtEqualTo(
    DateTime? value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'cachedAt', value: value),
      );
    });
  }

  QueryBuilder<Food, Food, QAfterFilterCondition> cachedAtGreaterThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'cachedAt',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Food, Food, QAfterFilterCondition> cachedAtLessThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'cachedAt',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Food, Food, QAfterFilterCondition> cachedAtBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'cachedAt',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<Food, Food, QAfterFilterCondition> carbs100gEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'carbs100g',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<Food, Food, QAfterFilterCondition> carbs100gGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'carbs100g',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<Food, Food, QAfterFilterCondition> carbs100gLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'carbs100g',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<Food, Food, QAfterFilterCondition> carbs100gBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'carbs100g',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<Food, Food, QAfterFilterCondition> catalogIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'catalogId'),
      );
    });
  }

  QueryBuilder<Food, Food, QAfterFilterCondition> catalogIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'catalogId'),
      );
    });
  }

  QueryBuilder<Food, Food, QAfterFilterCondition> catalogIdEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'catalogId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Food, Food, QAfterFilterCondition> catalogIdGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'catalogId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Food, Food, QAfterFilterCondition> catalogIdLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'catalogId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Food, Food, QAfterFilterCondition> catalogIdBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'catalogId',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Food, Food, QAfterFilterCondition> catalogIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'catalogId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Food, Food, QAfterFilterCondition> catalogIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'catalogId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Food, Food, QAfterFilterCondition> catalogIdContains(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'catalogId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Food, Food, QAfterFilterCondition> catalogIdMatches(
    String pattern, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'catalogId',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Food, Food, QAfterFilterCondition> catalogIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'catalogId', value: ''),
      );
    });
  }

  QueryBuilder<Food, Food, QAfterFilterCondition> catalogIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'catalogId', value: ''),
      );
    });
  }

  QueryBuilder<Food, Food, QAfterFilterCondition> clientIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'clientId'),
      );
    });
  }

  QueryBuilder<Food, Food, QAfterFilterCondition> clientIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'clientId'),
      );
    });
  }

  QueryBuilder<Food, Food, QAfterFilterCondition> clientIdEqualTo(
    String? value, {
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

  QueryBuilder<Food, Food, QAfterFilterCondition> clientIdGreaterThan(
    String? value, {
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

  QueryBuilder<Food, Food, QAfterFilterCondition> clientIdLessThan(
    String? value, {
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

  QueryBuilder<Food, Food, QAfterFilterCondition> clientIdBetween(
    String? lower,
    String? upper, {
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

  QueryBuilder<Food, Food, QAfterFilterCondition> clientIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
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

  QueryBuilder<Food, Food, QAfterFilterCondition> clientIdEndsWith(
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

  QueryBuilder<Food, Food, QAfterFilterCondition> clientIdContains(
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

  QueryBuilder<Food, Food, QAfterFilterCondition> clientIdMatches(
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

  QueryBuilder<Food, Food, QAfterFilterCondition> clientIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'clientId', value: ''),
      );
    });
  }

  QueryBuilder<Food, Food, QAfterFilterCondition> clientIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'clientId', value: ''),
      );
    });
  }

  QueryBuilder<Food, Food, QAfterFilterCondition> dataVersionEqualTo(
    int value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'dataVersion', value: value),
      );
    });
  }

  QueryBuilder<Food, Food, QAfterFilterCondition> dataVersionGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'dataVersion',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Food, Food, QAfterFilterCondition> dataVersionLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'dataVersion',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Food, Food, QAfterFilterCondition> dataVersionBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'dataVersion',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<Food, Food, QAfterFilterCondition> deletedEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'deleted', value: value),
      );
    });
  }

  QueryBuilder<Food, Food, QAfterFilterCondition> dirtyEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'dirty', value: value),
      );
    });
  }

  QueryBuilder<Food, Food, QAfterFilterCondition> fat100gEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'fat100g',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<Food, Food, QAfterFilterCondition> fat100gGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'fat100g',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<Food, Food, QAfterFilterCondition> fat100gLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'fat100g',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<Food, Food, QAfterFilterCondition> fat100gBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'fat100g',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<Food, Food, QAfterFilterCondition> fiber100gIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'fiber100g'),
      );
    });
  }

  QueryBuilder<Food, Food, QAfterFilterCondition> fiber100gIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'fiber100g'),
      );
    });
  }

  QueryBuilder<Food, Food, QAfterFilterCondition> fiber100gEqualTo(
    double? value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'fiber100g',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<Food, Food, QAfterFilterCondition> fiber100gGreaterThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'fiber100g',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<Food, Food, QAfterFilterCondition> fiber100gLessThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'fiber100g',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<Food, Food, QAfterFilterCondition> fiber100gBetween(
    double? lower,
    double? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'fiber100g',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<Food, Food, QAfterFilterCondition> idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'id', value: value),
      );
    });
  }

  QueryBuilder<Food, Food, QAfterFilterCondition> idGreaterThan(
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

  QueryBuilder<Food, Food, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<Food, Food, QAfterFilterCondition> idBetween(
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

  QueryBuilder<Food, Food, QAfterFilterCondition> isFavoriteEqualTo(
    bool value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'isFavorite', value: value),
      );
    });
  }

  QueryBuilder<Food, Food, QAfterFilterCondition> kcal100gEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'kcal100g',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<Food, Food, QAfterFilterCondition> kcal100gGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'kcal100g',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<Food, Food, QAfterFilterCondition> kcal100gLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'kcal100g',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<Food, Food, QAfterFilterCondition> kcal100gBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'kcal100g',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<Food, Food, QAfterFilterCondition> kindEqualTo(FoodKind value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'kind', value: value),
      );
    });
  }

  QueryBuilder<Food, Food, QAfterFilterCondition> kindGreaterThan(
    FoodKind value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'kind',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Food, Food, QAfterFilterCondition> kindLessThan(
    FoodKind value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'kind',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Food, Food, QAfterFilterCondition> kindBetween(
    FoodKind lower,
    FoodKind upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'kind',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<Food, Food, QAfterFilterCondition> lastAmountGIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'lastAmountG'),
      );
    });
  }

  QueryBuilder<Food, Food, QAfterFilterCondition> lastAmountGIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'lastAmountG'),
      );
    });
  }

  QueryBuilder<Food, Food, QAfterFilterCondition> lastAmountGEqualTo(
    double? value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'lastAmountG',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<Food, Food, QAfterFilterCondition> lastAmountGGreaterThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'lastAmountG',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<Food, Food, QAfterFilterCondition> lastAmountGLessThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'lastAmountG',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<Food, Food, QAfterFilterCondition> lastAmountGBetween(
    double? lower,
    double? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'lastAmountG',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<Food, Food, QAfterFilterCondition> lastUsedAtIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'lastUsedAt'),
      );
    });
  }

  QueryBuilder<Food, Food, QAfterFilterCondition> lastUsedAtIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'lastUsedAt'),
      );
    });
  }

  QueryBuilder<Food, Food, QAfterFilterCondition> lastUsedAtEqualTo(
    DateTime? value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'lastUsedAt', value: value),
      );
    });
  }

  QueryBuilder<Food, Food, QAfterFilterCondition> lastUsedAtGreaterThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'lastUsedAt',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Food, Food, QAfterFilterCondition> lastUsedAtLessThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'lastUsedAt',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Food, Food, QAfterFilterCondition> lastUsedAtBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'lastUsedAt',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<Food, Food, QAfterFilterCondition> nameEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'name',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Food, Food, QAfterFilterCondition> nameGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'name',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Food, Food, QAfterFilterCondition> nameLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'name',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Food, Food, QAfterFilterCondition> nameBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'name',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Food, Food, QAfterFilterCondition> nameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'name',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Food, Food, QAfterFilterCondition> nameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'name',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Food, Food, QAfterFilterCondition> nameContains(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'name',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Food, Food, QAfterFilterCondition> nameMatches(
    String pattern, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'name',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Food, Food, QAfterFilterCondition> nameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'name', value: ''),
      );
    });
  }

  QueryBuilder<Food, Food, QAfterFilterCondition> nameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'name', value: ''),
      );
    });
  }

  QueryBuilder<Food, Food, QAfterFilterCondition> nameNormalizedEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'nameNormalized',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Food, Food, QAfterFilterCondition> nameNormalizedGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'nameNormalized',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Food, Food, QAfterFilterCondition> nameNormalizedLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'nameNormalized',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Food, Food, QAfterFilterCondition> nameNormalizedBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'nameNormalized',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Food, Food, QAfterFilterCondition> nameNormalizedStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'nameNormalized',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Food, Food, QAfterFilterCondition> nameNormalizedEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'nameNormalized',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Food, Food, QAfterFilterCondition> nameNormalizedContains(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'nameNormalized',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Food, Food, QAfterFilterCondition> nameNormalizedMatches(
    String pattern, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'nameNormalized',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Food, Food, QAfterFilterCondition> nameNormalizedIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'nameNormalized', value: ''),
      );
    });
  }

  QueryBuilder<Food, Food, QAfterFilterCondition> nameNormalizedIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'nameNormalized', value: ''),
      );
    });
  }

  QueryBuilder<Food, Food, QAfterFilterCondition> nevoCodeIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'nevoCode'),
      );
    });
  }

  QueryBuilder<Food, Food, QAfterFilterCondition> nevoCodeIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'nevoCode'),
      );
    });
  }

  QueryBuilder<Food, Food, QAfterFilterCondition> nevoCodeEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'nevoCode',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Food, Food, QAfterFilterCondition> nevoCodeGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'nevoCode',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Food, Food, QAfterFilterCondition> nevoCodeLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'nevoCode',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Food, Food, QAfterFilterCondition> nevoCodeBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'nevoCode',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Food, Food, QAfterFilterCondition> nevoCodeStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'nevoCode',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Food, Food, QAfterFilterCondition> nevoCodeEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'nevoCode',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Food, Food, QAfterFilterCondition> nevoCodeContains(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'nevoCode',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Food, Food, QAfterFilterCondition> nevoCodeMatches(
    String pattern, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'nevoCode',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Food, Food, QAfterFilterCondition> nevoCodeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'nevoCode', value: ''),
      );
    });
  }

  QueryBuilder<Food, Food, QAfterFilterCondition> nevoCodeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'nevoCode', value: ''),
      );
    });
  }

  QueryBuilder<Food, Food, QAfterFilterCondition> nlRelevanceEqualTo(
    int value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'nlRelevance', value: value),
      );
    });
  }

  QueryBuilder<Food, Food, QAfterFilterCondition> nlRelevanceGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'nlRelevance',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Food, Food, QAfterFilterCondition> nlRelevanceLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'nlRelevance',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Food, Food, QAfterFilterCondition> nlRelevanceBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'nlRelevance',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<Food, Food, QAfterFilterCondition> nutrientsJsonIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'nutrientsJson'),
      );
    });
  }

  QueryBuilder<Food, Food, QAfterFilterCondition> nutrientsJsonIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'nutrientsJson'),
      );
    });
  }

  QueryBuilder<Food, Food, QAfterFilterCondition> nutrientsJsonEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'nutrientsJson',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Food, Food, QAfterFilterCondition> nutrientsJsonGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'nutrientsJson',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Food, Food, QAfterFilterCondition> nutrientsJsonLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'nutrientsJson',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Food, Food, QAfterFilterCondition> nutrientsJsonBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'nutrientsJson',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Food, Food, QAfterFilterCondition> nutrientsJsonStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'nutrientsJson',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Food, Food, QAfterFilterCondition> nutrientsJsonEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'nutrientsJson',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Food, Food, QAfterFilterCondition> nutrientsJsonContains(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'nutrientsJson',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Food, Food, QAfterFilterCondition> nutrientsJsonMatches(
    String pattern, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'nutrientsJson',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Food, Food, QAfterFilterCondition> nutrientsJsonIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'nutrientsJson', value: ''),
      );
    });
  }

  QueryBuilder<Food, Food, QAfterFilterCondition> nutrientsJsonIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'nutrientsJson', value: ''),
      );
    });
  }

  QueryBuilder<Food, Food, QAfterFilterCondition> offIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'offId'),
      );
    });
  }

  QueryBuilder<Food, Food, QAfterFilterCondition> offIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'offId'),
      );
    });
  }

  QueryBuilder<Food, Food, QAfterFilterCondition> offIdEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'offId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Food, Food, QAfterFilterCondition> offIdGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'offId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Food, Food, QAfterFilterCondition> offIdLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'offId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Food, Food, QAfterFilterCondition> offIdBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'offId',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Food, Food, QAfterFilterCondition> offIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'offId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Food, Food, QAfterFilterCondition> offIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'offId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Food, Food, QAfterFilterCondition> offIdContains(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'offId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Food, Food, QAfterFilterCondition> offIdMatches(
    String pattern, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'offId',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Food, Food, QAfterFilterCondition> offIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'offId', value: ''),
      );
    });
  }

  QueryBuilder<Food, Food, QAfterFilterCondition> offIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'offId', value: ''),
      );
    });
  }

  QueryBuilder<Food, Food, QAfterFilterCondition> popularityEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'popularity', value: value),
      );
    });
  }

  QueryBuilder<Food, Food, QAfterFilterCondition> popularityGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'popularity',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Food, Food, QAfterFilterCondition> popularityLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'popularity',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Food, Food, QAfterFilterCondition> popularityBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'popularity',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<Food, Food, QAfterFilterCondition> protein100gEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'protein100g',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<Food, Food, QAfterFilterCondition> protein100gGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'protein100g',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<Food, Food, QAfterFilterCondition> protein100gLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'protein100g',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<Food, Food, QAfterFilterCondition> protein100gBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'protein100g',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<Food, Food, QAfterFilterCondition> qualityScoreEqualTo(
    int value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'qualityScore', value: value),
      );
    });
  }

  QueryBuilder<Food, Food, QAfterFilterCondition> qualityScoreGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'qualityScore',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Food, Food, QAfterFilterCondition> qualityScoreLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'qualityScore',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Food, Food, QAfterFilterCondition> qualityScoreBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'qualityScore',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<Food, Food, QAfterFilterCondition> salt100gIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'salt100g'),
      );
    });
  }

  QueryBuilder<Food, Food, QAfterFilterCondition> salt100gIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'salt100g'),
      );
    });
  }

  QueryBuilder<Food, Food, QAfterFilterCondition> salt100gEqualTo(
    double? value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'salt100g',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<Food, Food, QAfterFilterCondition> salt100gGreaterThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'salt100g',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<Food, Food, QAfterFilterCondition> salt100gLessThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'salt100g',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<Food, Food, QAfterFilterCondition> salt100gBetween(
    double? lower,
    double? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'salt100g',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<Food, Food, QAfterFilterCondition> satFat100gIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'satFat100g'),
      );
    });
  }

  QueryBuilder<Food, Food, QAfterFilterCondition> satFat100gIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'satFat100g'),
      );
    });
  }

  QueryBuilder<Food, Food, QAfterFilterCondition> satFat100gEqualTo(
    double? value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'satFat100g',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<Food, Food, QAfterFilterCondition> satFat100gGreaterThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'satFat100g',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<Food, Food, QAfterFilterCondition> satFat100gLessThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'satFat100g',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<Food, Food, QAfterFilterCondition> satFat100gBetween(
    double? lower,
    double? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'satFat100g',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<Food, Food, QAfterFilterCondition> servingGIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'servingG'),
      );
    });
  }

  QueryBuilder<Food, Food, QAfterFilterCondition> servingGIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'servingG'),
      );
    });
  }

  QueryBuilder<Food, Food, QAfterFilterCondition> servingGEqualTo(
    double? value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'servingG',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<Food, Food, QAfterFilterCondition> servingGGreaterThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'servingG',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<Food, Food, QAfterFilterCondition> servingGLessThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'servingG',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<Food, Food, QAfterFilterCondition> servingGBetween(
    double? lower,
    double? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'servingG',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<Food, Food, QAfterFilterCondition> servingLabelIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'servingLabel'),
      );
    });
  }

  QueryBuilder<Food, Food, QAfterFilterCondition> servingLabelIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'servingLabel'),
      );
    });
  }

  QueryBuilder<Food, Food, QAfterFilterCondition> servingLabelEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
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

  QueryBuilder<Food, Food, QAfterFilterCondition> servingLabelGreaterThan(
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

  QueryBuilder<Food, Food, QAfterFilterCondition> servingLabelLessThan(
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

  QueryBuilder<Food, Food, QAfterFilterCondition> servingLabelBetween(
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

  QueryBuilder<Food, Food, QAfterFilterCondition> servingLabelStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
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

  QueryBuilder<Food, Food, QAfterFilterCondition> servingLabelEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
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

  QueryBuilder<Food, Food, QAfterFilterCondition> servingLabelContains(
    String value, {
    bool caseSensitive = true,
  }) {
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

  QueryBuilder<Food, Food, QAfterFilterCondition> servingLabelMatches(
    String pattern, {
    bool caseSensitive = true,
  }) {
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

  QueryBuilder<Food, Food, QAfterFilterCondition> servingLabelIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'servingLabel', value: ''),
      );
    });
  }

  QueryBuilder<Food, Food, QAfterFilterCondition> servingLabelIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'servingLabel', value: ''),
      );
    });
  }

  QueryBuilder<Food, Food, QAfterFilterCondition> sourceEqualTo(
    FoodSource value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'source', value: value),
      );
    });
  }

  QueryBuilder<Food, Food, QAfterFilterCondition> sourceGreaterThan(
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

  QueryBuilder<Food, Food, QAfterFilterCondition> sourceLessThan(
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

  QueryBuilder<Food, Food, QAfterFilterCondition> sourceBetween(
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

  QueryBuilder<Food, Food, QAfterFilterCondition> sugars100gIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'sugars100g'),
      );
    });
  }

  QueryBuilder<Food, Food, QAfterFilterCondition> sugars100gIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'sugars100g'),
      );
    });
  }

  QueryBuilder<Food, Food, QAfterFilterCondition> sugars100gEqualTo(
    double? value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'sugars100g',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<Food, Food, QAfterFilterCondition> sugars100gGreaterThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'sugars100g',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<Food, Food, QAfterFilterCondition> sugars100gLessThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'sugars100g',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<Food, Food, QAfterFilterCondition> sugars100gBetween(
    double? lower,
    double? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'sugars100g',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<Food, Food, QAfterFilterCondition> updatedAtIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'updatedAt'),
      );
    });
  }

  QueryBuilder<Food, Food, QAfterFilterCondition> updatedAtIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'updatedAt'),
      );
    });
  }

  QueryBuilder<Food, Food, QAfterFilterCondition> updatedAtEqualTo(
    DateTime? value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'updatedAt', value: value),
      );
    });
  }

  QueryBuilder<Food, Food, QAfterFilterCondition> updatedAtGreaterThan(
    DateTime? value, {
    bool include = false,
  }) {
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

  QueryBuilder<Food, Food, QAfterFilterCondition> updatedAtLessThan(
    DateTime? value, {
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

  QueryBuilder<Food, Food, QAfterFilterCondition> updatedAtBetween(
    DateTime? lower,
    DateTime? upper, {
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

  QueryBuilder<Food, Food, QAfterFilterCondition> userOverriddenEqualTo(
    bool value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'userOverridden', value: value),
      );
    });
  }
}

extension FoodQueryObject on QueryBuilder<Food, Food, QFilterCondition> {}

extension FoodQueryLinks on QueryBuilder<Food, Food, QFilterCondition> {}

extension FoodQuerySortBy on QueryBuilder<Food, Food, QSortBy> {
  QueryBuilder<Food, Food, QAfterSortBy> sortByAlcohol100g() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'alcohol100g', Sort.asc);
    });
  }

  QueryBuilder<Food, Food, QAfterSortBy> sortByAlcohol100gDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'alcohol100g', Sort.desc);
    });
  }

  QueryBuilder<Food, Food, QAfterSortBy> sortByBarcode() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'barcode', Sort.asc);
    });
  }

  QueryBuilder<Food, Food, QAfterSortBy> sortByBarcodeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'barcode', Sort.desc);
    });
  }

  QueryBuilder<Food, Food, QAfterSortBy> sortByBrand() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'brand', Sort.asc);
    });
  }

  QueryBuilder<Food, Food, QAfterSortBy> sortByBrandDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'brand', Sort.desc);
    });
  }

  QueryBuilder<Food, Food, QAfterSortBy> sortByCachedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cachedAt', Sort.asc);
    });
  }

  QueryBuilder<Food, Food, QAfterSortBy> sortByCachedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cachedAt', Sort.desc);
    });
  }

  QueryBuilder<Food, Food, QAfterSortBy> sortByCarbs100g() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'carbs100g', Sort.asc);
    });
  }

  QueryBuilder<Food, Food, QAfterSortBy> sortByCarbs100gDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'carbs100g', Sort.desc);
    });
  }

  QueryBuilder<Food, Food, QAfterSortBy> sortByCatalogId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'catalogId', Sort.asc);
    });
  }

  QueryBuilder<Food, Food, QAfterSortBy> sortByCatalogIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'catalogId', Sort.desc);
    });
  }

  QueryBuilder<Food, Food, QAfterSortBy> sortByClientId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'clientId', Sort.asc);
    });
  }

  QueryBuilder<Food, Food, QAfterSortBy> sortByClientIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'clientId', Sort.desc);
    });
  }

  QueryBuilder<Food, Food, QAfterSortBy> sortByDataVersion() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dataVersion', Sort.asc);
    });
  }

  QueryBuilder<Food, Food, QAfterSortBy> sortByDataVersionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dataVersion', Sort.desc);
    });
  }

  QueryBuilder<Food, Food, QAfterSortBy> sortByDeleted() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'deleted', Sort.asc);
    });
  }

  QueryBuilder<Food, Food, QAfterSortBy> sortByDeletedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'deleted', Sort.desc);
    });
  }

  QueryBuilder<Food, Food, QAfterSortBy> sortByDirty() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dirty', Sort.asc);
    });
  }

  QueryBuilder<Food, Food, QAfterSortBy> sortByDirtyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dirty', Sort.desc);
    });
  }

  QueryBuilder<Food, Food, QAfterSortBy> sortByFat100g() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fat100g', Sort.asc);
    });
  }

  QueryBuilder<Food, Food, QAfterSortBy> sortByFat100gDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fat100g', Sort.desc);
    });
  }

  QueryBuilder<Food, Food, QAfterSortBy> sortByFiber100g() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fiber100g', Sort.asc);
    });
  }

  QueryBuilder<Food, Food, QAfterSortBy> sortByFiber100gDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fiber100g', Sort.desc);
    });
  }

  QueryBuilder<Food, Food, QAfterSortBy> sortByIsFavorite() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isFavorite', Sort.asc);
    });
  }

  QueryBuilder<Food, Food, QAfterSortBy> sortByIsFavoriteDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isFavorite', Sort.desc);
    });
  }

  QueryBuilder<Food, Food, QAfterSortBy> sortByKcal100g() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'kcal100g', Sort.asc);
    });
  }

  QueryBuilder<Food, Food, QAfterSortBy> sortByKcal100gDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'kcal100g', Sort.desc);
    });
  }

  QueryBuilder<Food, Food, QAfterSortBy> sortByKind() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'kind', Sort.asc);
    });
  }

  QueryBuilder<Food, Food, QAfterSortBy> sortByKindDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'kind', Sort.desc);
    });
  }

  QueryBuilder<Food, Food, QAfterSortBy> sortByLastAmountG() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastAmountG', Sort.asc);
    });
  }

  QueryBuilder<Food, Food, QAfterSortBy> sortByLastAmountGDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastAmountG', Sort.desc);
    });
  }

  QueryBuilder<Food, Food, QAfterSortBy> sortByLastUsedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastUsedAt', Sort.asc);
    });
  }

  QueryBuilder<Food, Food, QAfterSortBy> sortByLastUsedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastUsedAt', Sort.desc);
    });
  }

  QueryBuilder<Food, Food, QAfterSortBy> sortByName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.asc);
    });
  }

  QueryBuilder<Food, Food, QAfterSortBy> sortByNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.desc);
    });
  }

  QueryBuilder<Food, Food, QAfterSortBy> sortByNameNormalized() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'nameNormalized', Sort.asc);
    });
  }

  QueryBuilder<Food, Food, QAfterSortBy> sortByNameNormalizedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'nameNormalized', Sort.desc);
    });
  }

  QueryBuilder<Food, Food, QAfterSortBy> sortByNevoCode() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'nevoCode', Sort.asc);
    });
  }

  QueryBuilder<Food, Food, QAfterSortBy> sortByNevoCodeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'nevoCode', Sort.desc);
    });
  }

  QueryBuilder<Food, Food, QAfterSortBy> sortByNlRelevance() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'nlRelevance', Sort.asc);
    });
  }

  QueryBuilder<Food, Food, QAfterSortBy> sortByNlRelevanceDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'nlRelevance', Sort.desc);
    });
  }

  QueryBuilder<Food, Food, QAfterSortBy> sortByNutrientsJson() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'nutrientsJson', Sort.asc);
    });
  }

  QueryBuilder<Food, Food, QAfterSortBy> sortByNutrientsJsonDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'nutrientsJson', Sort.desc);
    });
  }

  QueryBuilder<Food, Food, QAfterSortBy> sortByOffId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'offId', Sort.asc);
    });
  }

  QueryBuilder<Food, Food, QAfterSortBy> sortByOffIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'offId', Sort.desc);
    });
  }

  QueryBuilder<Food, Food, QAfterSortBy> sortByPopularity() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'popularity', Sort.asc);
    });
  }

  QueryBuilder<Food, Food, QAfterSortBy> sortByPopularityDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'popularity', Sort.desc);
    });
  }

  QueryBuilder<Food, Food, QAfterSortBy> sortByProtein100g() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'protein100g', Sort.asc);
    });
  }

  QueryBuilder<Food, Food, QAfterSortBy> sortByProtein100gDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'protein100g', Sort.desc);
    });
  }

  QueryBuilder<Food, Food, QAfterSortBy> sortByQualityScore() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'qualityScore', Sort.asc);
    });
  }

  QueryBuilder<Food, Food, QAfterSortBy> sortByQualityScoreDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'qualityScore', Sort.desc);
    });
  }

  QueryBuilder<Food, Food, QAfterSortBy> sortBySalt100g() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'salt100g', Sort.asc);
    });
  }

  QueryBuilder<Food, Food, QAfterSortBy> sortBySalt100gDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'salt100g', Sort.desc);
    });
  }

  QueryBuilder<Food, Food, QAfterSortBy> sortBySatFat100g() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'satFat100g', Sort.asc);
    });
  }

  QueryBuilder<Food, Food, QAfterSortBy> sortBySatFat100gDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'satFat100g', Sort.desc);
    });
  }

  QueryBuilder<Food, Food, QAfterSortBy> sortByServingG() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'servingG', Sort.asc);
    });
  }

  QueryBuilder<Food, Food, QAfterSortBy> sortByServingGDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'servingG', Sort.desc);
    });
  }

  QueryBuilder<Food, Food, QAfterSortBy> sortByServingLabel() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'servingLabel', Sort.asc);
    });
  }

  QueryBuilder<Food, Food, QAfterSortBy> sortByServingLabelDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'servingLabel', Sort.desc);
    });
  }

  QueryBuilder<Food, Food, QAfterSortBy> sortBySource() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'source', Sort.asc);
    });
  }

  QueryBuilder<Food, Food, QAfterSortBy> sortBySourceDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'source', Sort.desc);
    });
  }

  QueryBuilder<Food, Food, QAfterSortBy> sortBySugars100g() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sugars100g', Sort.asc);
    });
  }

  QueryBuilder<Food, Food, QAfterSortBy> sortBySugars100gDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sugars100g', Sort.desc);
    });
  }

  QueryBuilder<Food, Food, QAfterSortBy> sortByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<Food, Food, QAfterSortBy> sortByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }

  QueryBuilder<Food, Food, QAfterSortBy> sortByUserOverridden() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'userOverridden', Sort.asc);
    });
  }

  QueryBuilder<Food, Food, QAfterSortBy> sortByUserOverriddenDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'userOverridden', Sort.desc);
    });
  }
}

extension FoodQuerySortThenBy on QueryBuilder<Food, Food, QSortThenBy> {
  QueryBuilder<Food, Food, QAfterSortBy> thenByAlcohol100g() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'alcohol100g', Sort.asc);
    });
  }

  QueryBuilder<Food, Food, QAfterSortBy> thenByAlcohol100gDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'alcohol100g', Sort.desc);
    });
  }

  QueryBuilder<Food, Food, QAfterSortBy> thenByBarcode() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'barcode', Sort.asc);
    });
  }

  QueryBuilder<Food, Food, QAfterSortBy> thenByBarcodeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'barcode', Sort.desc);
    });
  }

  QueryBuilder<Food, Food, QAfterSortBy> thenByBrand() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'brand', Sort.asc);
    });
  }

  QueryBuilder<Food, Food, QAfterSortBy> thenByBrandDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'brand', Sort.desc);
    });
  }

  QueryBuilder<Food, Food, QAfterSortBy> thenByCachedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cachedAt', Sort.asc);
    });
  }

  QueryBuilder<Food, Food, QAfterSortBy> thenByCachedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cachedAt', Sort.desc);
    });
  }

  QueryBuilder<Food, Food, QAfterSortBy> thenByCarbs100g() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'carbs100g', Sort.asc);
    });
  }

  QueryBuilder<Food, Food, QAfterSortBy> thenByCarbs100gDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'carbs100g', Sort.desc);
    });
  }

  QueryBuilder<Food, Food, QAfterSortBy> thenByCatalogId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'catalogId', Sort.asc);
    });
  }

  QueryBuilder<Food, Food, QAfterSortBy> thenByCatalogIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'catalogId', Sort.desc);
    });
  }

  QueryBuilder<Food, Food, QAfterSortBy> thenByClientId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'clientId', Sort.asc);
    });
  }

  QueryBuilder<Food, Food, QAfterSortBy> thenByClientIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'clientId', Sort.desc);
    });
  }

  QueryBuilder<Food, Food, QAfterSortBy> thenByDataVersion() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dataVersion', Sort.asc);
    });
  }

  QueryBuilder<Food, Food, QAfterSortBy> thenByDataVersionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dataVersion', Sort.desc);
    });
  }

  QueryBuilder<Food, Food, QAfterSortBy> thenByDeleted() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'deleted', Sort.asc);
    });
  }

  QueryBuilder<Food, Food, QAfterSortBy> thenByDeletedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'deleted', Sort.desc);
    });
  }

  QueryBuilder<Food, Food, QAfterSortBy> thenByDirty() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dirty', Sort.asc);
    });
  }

  QueryBuilder<Food, Food, QAfterSortBy> thenByDirtyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dirty', Sort.desc);
    });
  }

  QueryBuilder<Food, Food, QAfterSortBy> thenByFat100g() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fat100g', Sort.asc);
    });
  }

  QueryBuilder<Food, Food, QAfterSortBy> thenByFat100gDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fat100g', Sort.desc);
    });
  }

  QueryBuilder<Food, Food, QAfterSortBy> thenByFiber100g() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fiber100g', Sort.asc);
    });
  }

  QueryBuilder<Food, Food, QAfterSortBy> thenByFiber100gDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fiber100g', Sort.desc);
    });
  }

  QueryBuilder<Food, Food, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<Food, Food, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<Food, Food, QAfterSortBy> thenByIsFavorite() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isFavorite', Sort.asc);
    });
  }

  QueryBuilder<Food, Food, QAfterSortBy> thenByIsFavoriteDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isFavorite', Sort.desc);
    });
  }

  QueryBuilder<Food, Food, QAfterSortBy> thenByKcal100g() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'kcal100g', Sort.asc);
    });
  }

  QueryBuilder<Food, Food, QAfterSortBy> thenByKcal100gDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'kcal100g', Sort.desc);
    });
  }

  QueryBuilder<Food, Food, QAfterSortBy> thenByKind() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'kind', Sort.asc);
    });
  }

  QueryBuilder<Food, Food, QAfterSortBy> thenByKindDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'kind', Sort.desc);
    });
  }

  QueryBuilder<Food, Food, QAfterSortBy> thenByLastAmountG() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastAmountG', Sort.asc);
    });
  }

  QueryBuilder<Food, Food, QAfterSortBy> thenByLastAmountGDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastAmountG', Sort.desc);
    });
  }

  QueryBuilder<Food, Food, QAfterSortBy> thenByLastUsedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastUsedAt', Sort.asc);
    });
  }

  QueryBuilder<Food, Food, QAfterSortBy> thenByLastUsedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastUsedAt', Sort.desc);
    });
  }

  QueryBuilder<Food, Food, QAfterSortBy> thenByName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.asc);
    });
  }

  QueryBuilder<Food, Food, QAfterSortBy> thenByNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.desc);
    });
  }

  QueryBuilder<Food, Food, QAfterSortBy> thenByNameNormalized() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'nameNormalized', Sort.asc);
    });
  }

  QueryBuilder<Food, Food, QAfterSortBy> thenByNameNormalizedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'nameNormalized', Sort.desc);
    });
  }

  QueryBuilder<Food, Food, QAfterSortBy> thenByNevoCode() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'nevoCode', Sort.asc);
    });
  }

  QueryBuilder<Food, Food, QAfterSortBy> thenByNevoCodeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'nevoCode', Sort.desc);
    });
  }

  QueryBuilder<Food, Food, QAfterSortBy> thenByNlRelevance() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'nlRelevance', Sort.asc);
    });
  }

  QueryBuilder<Food, Food, QAfterSortBy> thenByNlRelevanceDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'nlRelevance', Sort.desc);
    });
  }

  QueryBuilder<Food, Food, QAfterSortBy> thenByNutrientsJson() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'nutrientsJson', Sort.asc);
    });
  }

  QueryBuilder<Food, Food, QAfterSortBy> thenByNutrientsJsonDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'nutrientsJson', Sort.desc);
    });
  }

  QueryBuilder<Food, Food, QAfterSortBy> thenByOffId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'offId', Sort.asc);
    });
  }

  QueryBuilder<Food, Food, QAfterSortBy> thenByOffIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'offId', Sort.desc);
    });
  }

  QueryBuilder<Food, Food, QAfterSortBy> thenByPopularity() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'popularity', Sort.asc);
    });
  }

  QueryBuilder<Food, Food, QAfterSortBy> thenByPopularityDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'popularity', Sort.desc);
    });
  }

  QueryBuilder<Food, Food, QAfterSortBy> thenByProtein100g() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'protein100g', Sort.asc);
    });
  }

  QueryBuilder<Food, Food, QAfterSortBy> thenByProtein100gDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'protein100g', Sort.desc);
    });
  }

  QueryBuilder<Food, Food, QAfterSortBy> thenByQualityScore() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'qualityScore', Sort.asc);
    });
  }

  QueryBuilder<Food, Food, QAfterSortBy> thenByQualityScoreDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'qualityScore', Sort.desc);
    });
  }

  QueryBuilder<Food, Food, QAfterSortBy> thenBySalt100g() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'salt100g', Sort.asc);
    });
  }

  QueryBuilder<Food, Food, QAfterSortBy> thenBySalt100gDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'salt100g', Sort.desc);
    });
  }

  QueryBuilder<Food, Food, QAfterSortBy> thenBySatFat100g() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'satFat100g', Sort.asc);
    });
  }

  QueryBuilder<Food, Food, QAfterSortBy> thenBySatFat100gDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'satFat100g', Sort.desc);
    });
  }

  QueryBuilder<Food, Food, QAfterSortBy> thenByServingG() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'servingG', Sort.asc);
    });
  }

  QueryBuilder<Food, Food, QAfterSortBy> thenByServingGDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'servingG', Sort.desc);
    });
  }

  QueryBuilder<Food, Food, QAfterSortBy> thenByServingLabel() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'servingLabel', Sort.asc);
    });
  }

  QueryBuilder<Food, Food, QAfterSortBy> thenByServingLabelDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'servingLabel', Sort.desc);
    });
  }

  QueryBuilder<Food, Food, QAfterSortBy> thenBySource() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'source', Sort.asc);
    });
  }

  QueryBuilder<Food, Food, QAfterSortBy> thenBySourceDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'source', Sort.desc);
    });
  }

  QueryBuilder<Food, Food, QAfterSortBy> thenBySugars100g() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sugars100g', Sort.asc);
    });
  }

  QueryBuilder<Food, Food, QAfterSortBy> thenBySugars100gDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sugars100g', Sort.desc);
    });
  }

  QueryBuilder<Food, Food, QAfterSortBy> thenByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<Food, Food, QAfterSortBy> thenByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }

  QueryBuilder<Food, Food, QAfterSortBy> thenByUserOverridden() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'userOverridden', Sort.asc);
    });
  }

  QueryBuilder<Food, Food, QAfterSortBy> thenByUserOverriddenDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'userOverridden', Sort.desc);
    });
  }
}

extension FoodQueryWhereDistinct on QueryBuilder<Food, Food, QDistinct> {
  QueryBuilder<Food, Food, QDistinct> distinctByAlcohol100g() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'alcohol100g');
    });
  }

  QueryBuilder<Food, Food, QDistinct> distinctByBarcode({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'barcode', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Food, Food, QDistinct> distinctByBrand({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'brand', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Food, Food, QDistinct> distinctByCachedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'cachedAt');
    });
  }

  QueryBuilder<Food, Food, QDistinct> distinctByCarbs100g() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'carbs100g');
    });
  }

  QueryBuilder<Food, Food, QDistinct> distinctByCatalogId({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'catalogId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Food, Food, QDistinct> distinctByClientId({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'clientId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Food, Food, QDistinct> distinctByDataVersion() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'dataVersion');
    });
  }

  QueryBuilder<Food, Food, QDistinct> distinctByDeleted() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'deleted');
    });
  }

  QueryBuilder<Food, Food, QDistinct> distinctByDirty() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'dirty');
    });
  }

  QueryBuilder<Food, Food, QDistinct> distinctByFat100g() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'fat100g');
    });
  }

  QueryBuilder<Food, Food, QDistinct> distinctByFiber100g() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'fiber100g');
    });
  }

  QueryBuilder<Food, Food, QDistinct> distinctByIsFavorite() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isFavorite');
    });
  }

  QueryBuilder<Food, Food, QDistinct> distinctByKcal100g() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'kcal100g');
    });
  }

  QueryBuilder<Food, Food, QDistinct> distinctByKind() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'kind');
    });
  }

  QueryBuilder<Food, Food, QDistinct> distinctByLastAmountG() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'lastAmountG');
    });
  }

  QueryBuilder<Food, Food, QDistinct> distinctByLastUsedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'lastUsedAt');
    });
  }

  QueryBuilder<Food, Food, QDistinct> distinctByName({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'name', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Food, Food, QDistinct> distinctByNameNormalized({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(
        r'nameNormalized',
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<Food, Food, QDistinct> distinctByNevoCode({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'nevoCode', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Food, Food, QDistinct> distinctByNlRelevance() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'nlRelevance');
    });
  }

  QueryBuilder<Food, Food, QDistinct> distinctByNutrientsJson({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(
        r'nutrientsJson',
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<Food, Food, QDistinct> distinctByOffId({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'offId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Food, Food, QDistinct> distinctByPopularity() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'popularity');
    });
  }

  QueryBuilder<Food, Food, QDistinct> distinctByProtein100g() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'protein100g');
    });
  }

  QueryBuilder<Food, Food, QDistinct> distinctByQualityScore() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'qualityScore');
    });
  }

  QueryBuilder<Food, Food, QDistinct> distinctBySalt100g() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'salt100g');
    });
  }

  QueryBuilder<Food, Food, QDistinct> distinctBySatFat100g() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'satFat100g');
    });
  }

  QueryBuilder<Food, Food, QDistinct> distinctByServingG() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'servingG');
    });
  }

  QueryBuilder<Food, Food, QDistinct> distinctByServingLabel({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'servingLabel', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Food, Food, QDistinct> distinctBySource() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'source');
    });
  }

  QueryBuilder<Food, Food, QDistinct> distinctBySugars100g() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'sugars100g');
    });
  }

  QueryBuilder<Food, Food, QDistinct> distinctByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'updatedAt');
    });
  }

  QueryBuilder<Food, Food, QDistinct> distinctByUserOverridden() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'userOverridden');
    });
  }
}

extension FoodQueryProperty on QueryBuilder<Food, Food, QQueryProperty> {
  QueryBuilder<Food, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<Food, double?, QQueryOperations> alcohol100gProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'alcohol100g');
    });
  }

  QueryBuilder<Food, String?, QQueryOperations> barcodeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'barcode');
    });
  }

  QueryBuilder<Food, String?, QQueryOperations> brandProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'brand');
    });
  }

  QueryBuilder<Food, DateTime?, QQueryOperations> cachedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'cachedAt');
    });
  }

  QueryBuilder<Food, double, QQueryOperations> carbs100gProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'carbs100g');
    });
  }

  QueryBuilder<Food, String?, QQueryOperations> catalogIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'catalogId');
    });
  }

  QueryBuilder<Food, String?, QQueryOperations> clientIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'clientId');
    });
  }

  QueryBuilder<Food, int, QQueryOperations> dataVersionProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'dataVersion');
    });
  }

  QueryBuilder<Food, bool, QQueryOperations> deletedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'deleted');
    });
  }

  QueryBuilder<Food, bool, QQueryOperations> dirtyProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'dirty');
    });
  }

  QueryBuilder<Food, double, QQueryOperations> fat100gProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'fat100g');
    });
  }

  QueryBuilder<Food, double?, QQueryOperations> fiber100gProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'fiber100g');
    });
  }

  QueryBuilder<Food, bool, QQueryOperations> isFavoriteProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isFavorite');
    });
  }

  QueryBuilder<Food, double, QQueryOperations> kcal100gProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'kcal100g');
    });
  }

  QueryBuilder<Food, FoodKind, QQueryOperations> kindProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'kind');
    });
  }

  QueryBuilder<Food, double?, QQueryOperations> lastAmountGProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'lastAmountG');
    });
  }

  QueryBuilder<Food, DateTime?, QQueryOperations> lastUsedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'lastUsedAt');
    });
  }

  QueryBuilder<Food, String, QQueryOperations> nameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'name');
    });
  }

  QueryBuilder<Food, String, QQueryOperations> nameNormalizedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'nameNormalized');
    });
  }

  QueryBuilder<Food, String?, QQueryOperations> nevoCodeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'nevoCode');
    });
  }

  QueryBuilder<Food, int, QQueryOperations> nlRelevanceProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'nlRelevance');
    });
  }

  QueryBuilder<Food, String?, QQueryOperations> nutrientsJsonProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'nutrientsJson');
    });
  }

  QueryBuilder<Food, String?, QQueryOperations> offIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'offId');
    });
  }

  QueryBuilder<Food, int, QQueryOperations> popularityProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'popularity');
    });
  }

  QueryBuilder<Food, double, QQueryOperations> protein100gProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'protein100g');
    });
  }

  QueryBuilder<Food, int, QQueryOperations> qualityScoreProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'qualityScore');
    });
  }

  QueryBuilder<Food, double?, QQueryOperations> salt100gProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'salt100g');
    });
  }

  QueryBuilder<Food, double?, QQueryOperations> satFat100gProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'satFat100g');
    });
  }

  QueryBuilder<Food, double?, QQueryOperations> servingGProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'servingG');
    });
  }

  QueryBuilder<Food, String?, QQueryOperations> servingLabelProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'servingLabel');
    });
  }

  QueryBuilder<Food, FoodSource, QQueryOperations> sourceProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'source');
    });
  }

  QueryBuilder<Food, double?, QQueryOperations> sugars100gProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'sugars100g');
    });
  }

  QueryBuilder<Food, DateTime?, QQueryOperations> updatedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'updatedAt');
    });
  }

  QueryBuilder<Food, bool, QQueryOperations> userOverriddenProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'userOverridden');
    });
  }
}
