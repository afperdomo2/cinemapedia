// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cached_payload_local.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetCachedPayloadLocalCollection on Isar {
  IsarCollection<CachedPayloadLocal> get cachedPayloadLocals =>
      this.collection();
}

const CachedPayloadLocalSchema = CollectionSchema(
  name: r'CachedPayloadLocal',
  id: -7148391775918616787,
  properties: {
    r'fetchedAt': PropertySchema(
      id: 0,
      name: r'fetchedAt',
      type: IsarType.dateTime,
    ),
    r'key': PropertySchema(
      id: 1,
      name: r'key',
      type: IsarType.string,
    ),
    r'payload': PropertySchema(
      id: 2,
      name: r'payload',
      type: IsarType.string,
    )
  },
  estimateSize: _cachedPayloadLocalEstimateSize,
  serialize: _cachedPayloadLocalSerialize,
  deserialize: _cachedPayloadLocalDeserialize,
  deserializeProp: _cachedPayloadLocalDeserializeProp,
  idName: r'isarId',
  indexes: {
    r'key': IndexSchema(
      id: -4906094122524121629,
      name: r'key',
      unique: true,
      replace: true,
      properties: [
        IndexPropertySchema(
          name: r'key',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _cachedPayloadLocalGetId,
  getLinks: _cachedPayloadLocalGetLinks,
  attach: _cachedPayloadLocalAttach,
  version: '3.1.0+1',
);

int _cachedPayloadLocalEstimateSize(
  CachedPayloadLocal object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.key.length * 3;
  bytesCount += 3 + object.payload.length * 3;
  return bytesCount;
}

void _cachedPayloadLocalSerialize(
  CachedPayloadLocal object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeDateTime(offsets[0], object.fetchedAt);
  writer.writeString(offsets[1], object.key);
  writer.writeString(offsets[2], object.payload);
}

CachedPayloadLocal _cachedPayloadLocalDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = CachedPayloadLocal(
    fetchedAt: reader.readDateTime(offsets[0]),
    key: reader.readString(offsets[1]),
    payload: reader.readString(offsets[2]),
  );
  object.isarId = id;
  return object;
}

P _cachedPayloadLocalDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readDateTime(offset)) as P;
    case 1:
      return (reader.readString(offset)) as P;
    case 2:
      return (reader.readString(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _cachedPayloadLocalGetId(CachedPayloadLocal object) {
  return object.isarId;
}

List<IsarLinkBase<dynamic>> _cachedPayloadLocalGetLinks(
    CachedPayloadLocal object) {
  return [];
}

void _cachedPayloadLocalAttach(
    IsarCollection<dynamic> col, Id id, CachedPayloadLocal object) {
  object.isarId = id;
}

extension CachedPayloadLocalByIndex on IsarCollection<CachedPayloadLocal> {
  Future<CachedPayloadLocal?> getByKey(String key) {
    return getByIndex(r'key', [key]);
  }

  CachedPayloadLocal? getByKeySync(String key) {
    return getByIndexSync(r'key', [key]);
  }

  Future<bool> deleteByKey(String key) {
    return deleteByIndex(r'key', [key]);
  }

  bool deleteByKeySync(String key) {
    return deleteByIndexSync(r'key', [key]);
  }

  Future<List<CachedPayloadLocal?>> getAllByKey(List<String> keyValues) {
    final values = keyValues.map((e) => [e]).toList();
    return getAllByIndex(r'key', values);
  }

  List<CachedPayloadLocal?> getAllByKeySync(List<String> keyValues) {
    final values = keyValues.map((e) => [e]).toList();
    return getAllByIndexSync(r'key', values);
  }

  Future<int> deleteAllByKey(List<String> keyValues) {
    final values = keyValues.map((e) => [e]).toList();
    return deleteAllByIndex(r'key', values);
  }

  int deleteAllByKeySync(List<String> keyValues) {
    final values = keyValues.map((e) => [e]).toList();
    return deleteAllByIndexSync(r'key', values);
  }

  Future<Id> putByKey(CachedPayloadLocal object) {
    return putByIndex(r'key', object);
  }

  Id putByKeySync(CachedPayloadLocal object, {bool saveLinks = true}) {
    return putByIndexSync(r'key', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByKey(List<CachedPayloadLocal> objects) {
    return putAllByIndex(r'key', objects);
  }

  List<Id> putAllByKeySync(List<CachedPayloadLocal> objects,
      {bool saveLinks = true}) {
    return putAllByIndexSync(r'key', objects, saveLinks: saveLinks);
  }
}

extension CachedPayloadLocalQueryWhereSort
    on QueryBuilder<CachedPayloadLocal, CachedPayloadLocal, QWhere> {
  QueryBuilder<CachedPayloadLocal, CachedPayloadLocal, QAfterWhere>
      anyIsarId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension CachedPayloadLocalQueryWhere
    on QueryBuilder<CachedPayloadLocal, CachedPayloadLocal, QWhereClause> {
  QueryBuilder<CachedPayloadLocal, CachedPayloadLocal, QAfterWhereClause>
      isarIdEqualTo(Id isarId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: isarId,
        upper: isarId,
      ));
    });
  }

  QueryBuilder<CachedPayloadLocal, CachedPayloadLocal, QAfterWhereClause>
      isarIdNotEqualTo(Id isarId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: isarId, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: isarId, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: isarId, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: isarId, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<CachedPayloadLocal, CachedPayloadLocal, QAfterWhereClause>
      isarIdGreaterThan(Id isarId, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: isarId, includeLower: include),
      );
    });
  }

  QueryBuilder<CachedPayloadLocal, CachedPayloadLocal, QAfterWhereClause>
      isarIdLessThan(Id isarId, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: isarId, includeUpper: include),
      );
    });
  }

  QueryBuilder<CachedPayloadLocal, CachedPayloadLocal, QAfterWhereClause>
      isarIdBetween(
    Id lowerIsarId,
    Id upperIsarId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: lowerIsarId,
        includeLower: includeLower,
        upper: upperIsarId,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<CachedPayloadLocal, CachedPayloadLocal, QAfterWhereClause>
      keyEqualTo(String key) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'key',
        value: [key],
      ));
    });
  }

  QueryBuilder<CachedPayloadLocal, CachedPayloadLocal, QAfterWhereClause>
      keyNotEqualTo(String key) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'key',
              lower: [],
              upper: [key],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'key',
              lower: [key],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'key',
              lower: [key],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'key',
              lower: [],
              upper: [key],
              includeUpper: false,
            ));
      }
    });
  }
}

extension CachedPayloadLocalQueryFilter
    on QueryBuilder<CachedPayloadLocal, CachedPayloadLocal, QFilterCondition> {
  QueryBuilder<CachedPayloadLocal, CachedPayloadLocal, QAfterFilterCondition>
      fetchedAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'fetchedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<CachedPayloadLocal, CachedPayloadLocal, QAfterFilterCondition>
      fetchedAtGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'fetchedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<CachedPayloadLocal, CachedPayloadLocal, QAfterFilterCondition>
      fetchedAtLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'fetchedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<CachedPayloadLocal, CachedPayloadLocal, QAfterFilterCondition>
      fetchedAtBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'fetchedAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<CachedPayloadLocal, CachedPayloadLocal, QAfterFilterCondition>
      isarIdEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isarId',
        value: value,
      ));
    });
  }

  QueryBuilder<CachedPayloadLocal, CachedPayloadLocal, QAfterFilterCondition>
      isarIdGreaterThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'isarId',
        value: value,
      ));
    });
  }

  QueryBuilder<CachedPayloadLocal, CachedPayloadLocal, QAfterFilterCondition>
      isarIdLessThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'isarId',
        value: value,
      ));
    });
  }

  QueryBuilder<CachedPayloadLocal, CachedPayloadLocal, QAfterFilterCondition>
      isarIdBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'isarId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<CachedPayloadLocal, CachedPayloadLocal, QAfterFilterCondition>
      keyEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'key',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CachedPayloadLocal, CachedPayloadLocal, QAfterFilterCondition>
      keyGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'key',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CachedPayloadLocal, CachedPayloadLocal, QAfterFilterCondition>
      keyLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'key',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CachedPayloadLocal, CachedPayloadLocal, QAfterFilterCondition>
      keyBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'key',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CachedPayloadLocal, CachedPayloadLocal, QAfterFilterCondition>
      keyStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'key',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CachedPayloadLocal, CachedPayloadLocal, QAfterFilterCondition>
      keyEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'key',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CachedPayloadLocal, CachedPayloadLocal, QAfterFilterCondition>
      keyContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'key',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CachedPayloadLocal, CachedPayloadLocal, QAfterFilterCondition>
      keyMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'key',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CachedPayloadLocal, CachedPayloadLocal, QAfterFilterCondition>
      keyIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'key',
        value: '',
      ));
    });
  }

  QueryBuilder<CachedPayloadLocal, CachedPayloadLocal, QAfterFilterCondition>
      keyIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'key',
        value: '',
      ));
    });
  }

  QueryBuilder<CachedPayloadLocal, CachedPayloadLocal, QAfterFilterCondition>
      payloadEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'payload',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CachedPayloadLocal, CachedPayloadLocal, QAfterFilterCondition>
      payloadGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'payload',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CachedPayloadLocal, CachedPayloadLocal, QAfterFilterCondition>
      payloadLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'payload',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CachedPayloadLocal, CachedPayloadLocal, QAfterFilterCondition>
      payloadBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'payload',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CachedPayloadLocal, CachedPayloadLocal, QAfterFilterCondition>
      payloadStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'payload',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CachedPayloadLocal, CachedPayloadLocal, QAfterFilterCondition>
      payloadEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'payload',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CachedPayloadLocal, CachedPayloadLocal, QAfterFilterCondition>
      payloadContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'payload',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CachedPayloadLocal, CachedPayloadLocal, QAfterFilterCondition>
      payloadMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'payload',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CachedPayloadLocal, CachedPayloadLocal, QAfterFilterCondition>
      payloadIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'payload',
        value: '',
      ));
    });
  }

  QueryBuilder<CachedPayloadLocal, CachedPayloadLocal, QAfterFilterCondition>
      payloadIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'payload',
        value: '',
      ));
    });
  }
}

extension CachedPayloadLocalQueryObject
    on QueryBuilder<CachedPayloadLocal, CachedPayloadLocal, QFilterCondition> {}

extension CachedPayloadLocalQueryLinks
    on QueryBuilder<CachedPayloadLocal, CachedPayloadLocal, QFilterCondition> {}

extension CachedPayloadLocalQuerySortBy
    on QueryBuilder<CachedPayloadLocal, CachedPayloadLocal, QSortBy> {
  QueryBuilder<CachedPayloadLocal, CachedPayloadLocal, QAfterSortBy>
      sortByFetchedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fetchedAt', Sort.asc);
    });
  }

  QueryBuilder<CachedPayloadLocal, CachedPayloadLocal, QAfterSortBy>
      sortByFetchedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fetchedAt', Sort.desc);
    });
  }

  QueryBuilder<CachedPayloadLocal, CachedPayloadLocal, QAfterSortBy>
      sortByKey() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'key', Sort.asc);
    });
  }

  QueryBuilder<CachedPayloadLocal, CachedPayloadLocal, QAfterSortBy>
      sortByKeyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'key', Sort.desc);
    });
  }

  QueryBuilder<CachedPayloadLocal, CachedPayloadLocal, QAfterSortBy>
      sortByPayload() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'payload', Sort.asc);
    });
  }

  QueryBuilder<CachedPayloadLocal, CachedPayloadLocal, QAfterSortBy>
      sortByPayloadDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'payload', Sort.desc);
    });
  }
}

extension CachedPayloadLocalQuerySortThenBy
    on QueryBuilder<CachedPayloadLocal, CachedPayloadLocal, QSortThenBy> {
  QueryBuilder<CachedPayloadLocal, CachedPayloadLocal, QAfterSortBy>
      thenByFetchedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fetchedAt', Sort.asc);
    });
  }

  QueryBuilder<CachedPayloadLocal, CachedPayloadLocal, QAfterSortBy>
      thenByFetchedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fetchedAt', Sort.desc);
    });
  }

  QueryBuilder<CachedPayloadLocal, CachedPayloadLocal, QAfterSortBy>
      thenByIsarId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isarId', Sort.asc);
    });
  }

  QueryBuilder<CachedPayloadLocal, CachedPayloadLocal, QAfterSortBy>
      thenByIsarIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isarId', Sort.desc);
    });
  }

  QueryBuilder<CachedPayloadLocal, CachedPayloadLocal, QAfterSortBy>
      thenByKey() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'key', Sort.asc);
    });
  }

  QueryBuilder<CachedPayloadLocal, CachedPayloadLocal, QAfterSortBy>
      thenByKeyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'key', Sort.desc);
    });
  }

  QueryBuilder<CachedPayloadLocal, CachedPayloadLocal, QAfterSortBy>
      thenByPayload() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'payload', Sort.asc);
    });
  }

  QueryBuilder<CachedPayloadLocal, CachedPayloadLocal, QAfterSortBy>
      thenByPayloadDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'payload', Sort.desc);
    });
  }
}

extension CachedPayloadLocalQueryWhereDistinct
    on QueryBuilder<CachedPayloadLocal, CachedPayloadLocal, QDistinct> {
  QueryBuilder<CachedPayloadLocal, CachedPayloadLocal, QDistinct>
      distinctByFetchedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'fetchedAt');
    });
  }

  QueryBuilder<CachedPayloadLocal, CachedPayloadLocal, QDistinct> distinctByKey(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'key', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<CachedPayloadLocal, CachedPayloadLocal, QDistinct>
      distinctByPayload({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'payload', caseSensitive: caseSensitive);
    });
  }
}

extension CachedPayloadLocalQueryProperty
    on QueryBuilder<CachedPayloadLocal, CachedPayloadLocal, QQueryProperty> {
  QueryBuilder<CachedPayloadLocal, int, QQueryOperations> isarIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isarId');
    });
  }

  QueryBuilder<CachedPayloadLocal, DateTime, QQueryOperations>
      fetchedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'fetchedAt');
    });
  }

  QueryBuilder<CachedPayloadLocal, String, QQueryOperations> keyProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'key');
    });
  }

  QueryBuilder<CachedPayloadLocal, String, QQueryOperations> payloadProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'payload');
    });
  }
}
