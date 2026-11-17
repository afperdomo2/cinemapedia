// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'movie_local.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetMovieLocalCollection on Isar {
  IsarCollection<MovieLocal> get movieLocals => this.collection();
}

const MovieLocalSchema = CollectionSchema(
  name: r'MovieLocal',
  id: 650616376805318326,
  properties: {
    r'adult': PropertySchema(
      id: 0,
      name: r'adult',
      type: IsarType.bool,
    ),
    r'backdropPath': PropertySchema(
      id: 1,
      name: r'backdropPath',
      type: IsarType.string,
    ),
    r'genreIds': PropertySchema(
      id: 2,
      name: r'genreIds',
      type: IsarType.stringList,
    ),
    r'id': PropertySchema(
      id: 3,
      name: r'id',
      type: IsarType.long,
    ),
    r'inWatchlist': PropertySchema(
      id: 4,
      name: r'inWatchlist',
      type: IsarType.bool,
    ),
    r'isFavorite': PropertySchema(
      id: 5,
      name: r'isFavorite',
      type: IsarType.bool,
    ),
    r'originalLanguage': PropertySchema(
      id: 6,
      name: r'originalLanguage',
      type: IsarType.string,
    ),
    r'originalTitle': PropertySchema(
      id: 7,
      name: r'originalTitle',
      type: IsarType.string,
    ),
    r'overview': PropertySchema(
      id: 8,
      name: r'overview',
      type: IsarType.string,
    ),
    r'popularity': PropertySchema(
      id: 9,
      name: r'popularity',
      type: IsarType.double,
    ),
    r'posterPath': PropertySchema(
      id: 10,
      name: r'posterPath',
      type: IsarType.string,
    ),
    r'releaseDate': PropertySchema(
      id: 11,
      name: r'releaseDate',
      type: IsarType.dateTime,
    ),
    r'title': PropertySchema(
      id: 12,
      name: r'title',
      type: IsarType.string,
    ),
    r'video': PropertySchema(
      id: 13,
      name: r'video',
      type: IsarType.bool,
    ),
    r'voteAverage': PropertySchema(
      id: 14,
      name: r'voteAverage',
      type: IsarType.double,
    ),
    r'voteCount': PropertySchema(
      id: 15,
      name: r'voteCount',
      type: IsarType.long,
    )
  },
  estimateSize: _movieLocalEstimateSize,
  serialize: _movieLocalSerialize,
  deserialize: _movieLocalDeserialize,
  deserializeProp: _movieLocalDeserializeProp,
  idName: r'isarId',
  indexes: {
    r'id': IndexSchema(
      id: -3268401673993471357,
      name: r'id',
      unique: true,
      replace: true,
      properties: [
        IndexPropertySchema(
          name: r'id',
          type: IndexType.value,
          caseSensitive: false,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _movieLocalGetId,
  getLinks: _movieLocalGetLinks,
  attach: _movieLocalAttach,
  version: '3.1.0+1',
);

int _movieLocalEstimateSize(
  MovieLocal object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.backdropPath.length * 3;
  bytesCount += 3 + object.genreIds.length * 3;
  {
    for (var i = 0; i < object.genreIds.length; i++) {
      final value = object.genreIds[i];
      bytesCount += value.length * 3;
    }
  }
  bytesCount += 3 + object.originalLanguage.length * 3;
  bytesCount += 3 + object.originalTitle.length * 3;
  bytesCount += 3 + object.overview.length * 3;
  bytesCount += 3 + object.posterPath.length * 3;
  bytesCount += 3 + object.title.length * 3;
  return bytesCount;
}

void _movieLocalSerialize(
  MovieLocal object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeBool(offsets[0], object.adult);
  writer.writeString(offsets[1], object.backdropPath);
  writer.writeStringList(offsets[2], object.genreIds);
  writer.writeLong(offsets[3], object.id);
  writer.writeBool(offsets[4], object.inWatchlist);
  writer.writeBool(offsets[5], object.isFavorite);
  writer.writeString(offsets[6], object.originalLanguage);
  writer.writeString(offsets[7], object.originalTitle);
  writer.writeString(offsets[8], object.overview);
  writer.writeDouble(offsets[9], object.popularity);
  writer.writeString(offsets[10], object.posterPath);
  writer.writeDateTime(offsets[11], object.releaseDate);
  writer.writeString(offsets[12], object.title);
  writer.writeBool(offsets[13], object.video);
  writer.writeDouble(offsets[14], object.voteAverage);
  writer.writeLong(offsets[15], object.voteCount);
}

MovieLocal _movieLocalDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = MovieLocal(
    adult: reader.readBool(offsets[0]),
    backdropPath: reader.readString(offsets[1]),
    genreIds: reader.readStringList(offsets[2]) ?? [],
    id: reader.readLong(offsets[3]),
    inWatchlist: reader.readBoolOrNull(offsets[4]) ?? false,
    isFavorite: reader.readBoolOrNull(offsets[5]) ?? false,
    originalLanguage: reader.readString(offsets[6]),
    originalTitle: reader.readString(offsets[7]),
    overview: reader.readString(offsets[8]),
    popularity: reader.readDouble(offsets[9]),
    posterPath: reader.readString(offsets[10]),
    releaseDate: reader.readDateTimeOrNull(offsets[11]),
    title: reader.readString(offsets[12]),
    video: reader.readBool(offsets[13]),
    voteAverage: reader.readDouble(offsets[14]),
    voteCount: reader.readLong(offsets[15]),
  );
  object.isarId = id;
  return object;
}

P _movieLocalDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readBool(offset)) as P;
    case 1:
      return (reader.readString(offset)) as P;
    case 2:
      return (reader.readStringList(offset) ?? []) as P;
    case 3:
      return (reader.readLong(offset)) as P;
    case 4:
      return (reader.readBoolOrNull(offset) ?? false) as P;
    case 5:
      return (reader.readBoolOrNull(offset) ?? false) as P;
    case 6:
      return (reader.readString(offset)) as P;
    case 7:
      return (reader.readString(offset)) as P;
    case 8:
      return (reader.readString(offset)) as P;
    case 9:
      return (reader.readDouble(offset)) as P;
    case 10:
      return (reader.readString(offset)) as P;
    case 11:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 12:
      return (reader.readString(offset)) as P;
    case 13:
      return (reader.readBool(offset)) as P;
    case 14:
      return (reader.readDouble(offset)) as P;
    case 15:
      return (reader.readLong(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _movieLocalGetId(MovieLocal object) {
  return object.isarId;
}

List<IsarLinkBase<dynamic>> _movieLocalGetLinks(MovieLocal object) {
  return [];
}

void _movieLocalAttach(IsarCollection<dynamic> col, Id id, MovieLocal object) {
  object.isarId = id;
}

extension MovieLocalByIndex on IsarCollection<MovieLocal> {
  Future<MovieLocal?> getById(int id) {
    return getByIndex(r'id', [id]);
  }

  MovieLocal? getByIdSync(int id) {
    return getByIndexSync(r'id', [id]);
  }

  Future<bool> deleteById(int id) {
    return deleteByIndex(r'id', [id]);
  }

  bool deleteByIdSync(int id) {
    return deleteByIndexSync(r'id', [id]);
  }

  Future<List<MovieLocal?>> getAllById(List<int> idValues) {
    final values = idValues.map((e) => [e]).toList();
    return getAllByIndex(r'id', values);
  }

  List<MovieLocal?> getAllByIdSync(List<int> idValues) {
    final values = idValues.map((e) => [e]).toList();
    return getAllByIndexSync(r'id', values);
  }

  Future<int> deleteAllById(List<int> idValues) {
    final values = idValues.map((e) => [e]).toList();
    return deleteAllByIndex(r'id', values);
  }

  int deleteAllByIdSync(List<int> idValues) {
    final values = idValues.map((e) => [e]).toList();
    return deleteAllByIndexSync(r'id', values);
  }

  Future<Id> putById(MovieLocal object) {
    return putByIndex(r'id', object);
  }

  Id putByIdSync(MovieLocal object, {bool saveLinks = true}) {
    return putByIndexSync(r'id', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllById(List<MovieLocal> objects) {
    return putAllByIndex(r'id', objects);
  }

  List<Id> putAllByIdSync(List<MovieLocal> objects, {bool saveLinks = true}) {
    return putAllByIndexSync(r'id', objects, saveLinks: saveLinks);
  }
}

extension MovieLocalQueryWhereSort
    on QueryBuilder<MovieLocal, MovieLocal, QWhere> {
  QueryBuilder<MovieLocal, MovieLocal, QAfterWhere> anyIsarId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }

  QueryBuilder<MovieLocal, MovieLocal, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'id'),
      );
    });
  }
}

extension MovieLocalQueryWhere
    on QueryBuilder<MovieLocal, MovieLocal, QWhereClause> {
  QueryBuilder<MovieLocal, MovieLocal, QAfterWhereClause> isarIdEqualTo(
      Id isarId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: isarId,
        upper: isarId,
      ));
    });
  }

  QueryBuilder<MovieLocal, MovieLocal, QAfterWhereClause> isarIdNotEqualTo(
      Id isarId) {
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

  QueryBuilder<MovieLocal, MovieLocal, QAfterWhereClause> isarIdGreaterThan(
      Id isarId,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: isarId, includeLower: include),
      );
    });
  }

  QueryBuilder<MovieLocal, MovieLocal, QAfterWhereClause> isarIdLessThan(
      Id isarId,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: isarId, includeUpper: include),
      );
    });
  }

  QueryBuilder<MovieLocal, MovieLocal, QAfterWhereClause> isarIdBetween(
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

  QueryBuilder<MovieLocal, MovieLocal, QAfterWhereClause> idEqualTo(int id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'id',
        value: [id],
      ));
    });
  }

  QueryBuilder<MovieLocal, MovieLocal, QAfterWhereClause> idNotEqualTo(int id) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'id',
              lower: [],
              upper: [id],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'id',
              lower: [id],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'id',
              lower: [id],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'id',
              lower: [],
              upper: [id],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<MovieLocal, MovieLocal, QAfterWhereClause> idGreaterThan(
    int id, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'id',
        lower: [id],
        includeLower: include,
        upper: [],
      ));
    });
  }

  QueryBuilder<MovieLocal, MovieLocal, QAfterWhereClause> idLessThan(
    int id, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'id',
        lower: [],
        upper: [id],
        includeUpper: include,
      ));
    });
  }

  QueryBuilder<MovieLocal, MovieLocal, QAfterWhereClause> idBetween(
    int lowerId,
    int upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'id',
        lower: [lowerId],
        includeLower: includeLower,
        upper: [upperId],
        includeUpper: includeUpper,
      ));
    });
  }
}

extension MovieLocalQueryFilter
    on QueryBuilder<MovieLocal, MovieLocal, QFilterCondition> {
  QueryBuilder<MovieLocal, MovieLocal, QAfterFilterCondition> adultEqualTo(
      bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'adult',
        value: value,
      ));
    });
  }

  QueryBuilder<MovieLocal, MovieLocal, QAfterFilterCondition>
      backdropPathEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'backdropPath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MovieLocal, MovieLocal, QAfterFilterCondition>
      backdropPathGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'backdropPath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MovieLocal, MovieLocal, QAfterFilterCondition>
      backdropPathLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'backdropPath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MovieLocal, MovieLocal, QAfterFilterCondition>
      backdropPathBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'backdropPath',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MovieLocal, MovieLocal, QAfterFilterCondition>
      backdropPathStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'backdropPath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MovieLocal, MovieLocal, QAfterFilterCondition>
      backdropPathEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'backdropPath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MovieLocal, MovieLocal, QAfterFilterCondition>
      backdropPathContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'backdropPath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MovieLocal, MovieLocal, QAfterFilterCondition>
      backdropPathMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'backdropPath',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MovieLocal, MovieLocal, QAfterFilterCondition>
      backdropPathIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'backdropPath',
        value: '',
      ));
    });
  }

  QueryBuilder<MovieLocal, MovieLocal, QAfterFilterCondition>
      backdropPathIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'backdropPath',
        value: '',
      ));
    });
  }

  QueryBuilder<MovieLocal, MovieLocal, QAfterFilterCondition>
      genreIdsElementEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'genreIds',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MovieLocal, MovieLocal, QAfterFilterCondition>
      genreIdsElementGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'genreIds',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MovieLocal, MovieLocal, QAfterFilterCondition>
      genreIdsElementLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'genreIds',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MovieLocal, MovieLocal, QAfterFilterCondition>
      genreIdsElementBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'genreIds',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MovieLocal, MovieLocal, QAfterFilterCondition>
      genreIdsElementStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'genreIds',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MovieLocal, MovieLocal, QAfterFilterCondition>
      genreIdsElementEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'genreIds',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MovieLocal, MovieLocal, QAfterFilterCondition>
      genreIdsElementContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'genreIds',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MovieLocal, MovieLocal, QAfterFilterCondition>
      genreIdsElementMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'genreIds',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MovieLocal, MovieLocal, QAfterFilterCondition>
      genreIdsElementIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'genreIds',
        value: '',
      ));
    });
  }

  QueryBuilder<MovieLocal, MovieLocal, QAfterFilterCondition>
      genreIdsElementIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'genreIds',
        value: '',
      ));
    });
  }

  QueryBuilder<MovieLocal, MovieLocal, QAfterFilterCondition>
      genreIdsLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'genreIds',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<MovieLocal, MovieLocal, QAfterFilterCondition>
      genreIdsIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'genreIds',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<MovieLocal, MovieLocal, QAfterFilterCondition>
      genreIdsIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'genreIds',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<MovieLocal, MovieLocal, QAfterFilterCondition>
      genreIdsLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'genreIds',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<MovieLocal, MovieLocal, QAfterFilterCondition>
      genreIdsLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'genreIds',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<MovieLocal, MovieLocal, QAfterFilterCondition>
      genreIdsLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'genreIds',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<MovieLocal, MovieLocal, QAfterFilterCondition> idEqualTo(
      int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<MovieLocal, MovieLocal, QAfterFilterCondition> idGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<MovieLocal, MovieLocal, QAfterFilterCondition> idLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<MovieLocal, MovieLocal, QAfterFilterCondition> idBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'id',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<MovieLocal, MovieLocal, QAfterFilterCondition>
      inWatchlistEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'inWatchlist',
        value: value,
      ));
    });
  }

  QueryBuilder<MovieLocal, MovieLocal, QAfterFilterCondition> isFavoriteEqualTo(
      bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isFavorite',
        value: value,
      ));
    });
  }

  QueryBuilder<MovieLocal, MovieLocal, QAfterFilterCondition> isarIdEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isarId',
        value: value,
      ));
    });
  }

  QueryBuilder<MovieLocal, MovieLocal, QAfterFilterCondition> isarIdGreaterThan(
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

  QueryBuilder<MovieLocal, MovieLocal, QAfterFilterCondition> isarIdLessThan(
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

  QueryBuilder<MovieLocal, MovieLocal, QAfterFilterCondition> isarIdBetween(
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

  QueryBuilder<MovieLocal, MovieLocal, QAfterFilterCondition>
      originalLanguageEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'originalLanguage',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MovieLocal, MovieLocal, QAfterFilterCondition>
      originalLanguageGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'originalLanguage',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MovieLocal, MovieLocal, QAfterFilterCondition>
      originalLanguageLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'originalLanguage',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MovieLocal, MovieLocal, QAfterFilterCondition>
      originalLanguageBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'originalLanguage',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MovieLocal, MovieLocal, QAfterFilterCondition>
      originalLanguageStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'originalLanguage',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MovieLocal, MovieLocal, QAfterFilterCondition>
      originalLanguageEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'originalLanguage',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MovieLocal, MovieLocal, QAfterFilterCondition>
      originalLanguageContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'originalLanguage',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MovieLocal, MovieLocal, QAfterFilterCondition>
      originalLanguageMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'originalLanguage',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MovieLocal, MovieLocal, QAfterFilterCondition>
      originalLanguageIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'originalLanguage',
        value: '',
      ));
    });
  }

  QueryBuilder<MovieLocal, MovieLocal, QAfterFilterCondition>
      originalLanguageIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'originalLanguage',
        value: '',
      ));
    });
  }

  QueryBuilder<MovieLocal, MovieLocal, QAfterFilterCondition>
      originalTitleEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'originalTitle',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MovieLocal, MovieLocal, QAfterFilterCondition>
      originalTitleGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'originalTitle',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MovieLocal, MovieLocal, QAfterFilterCondition>
      originalTitleLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'originalTitle',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MovieLocal, MovieLocal, QAfterFilterCondition>
      originalTitleBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'originalTitle',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MovieLocal, MovieLocal, QAfterFilterCondition>
      originalTitleStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'originalTitle',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MovieLocal, MovieLocal, QAfterFilterCondition>
      originalTitleEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'originalTitle',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MovieLocal, MovieLocal, QAfterFilterCondition>
      originalTitleContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'originalTitle',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MovieLocal, MovieLocal, QAfterFilterCondition>
      originalTitleMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'originalTitle',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MovieLocal, MovieLocal, QAfterFilterCondition>
      originalTitleIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'originalTitle',
        value: '',
      ));
    });
  }

  QueryBuilder<MovieLocal, MovieLocal, QAfterFilterCondition>
      originalTitleIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'originalTitle',
        value: '',
      ));
    });
  }

  QueryBuilder<MovieLocal, MovieLocal, QAfterFilterCondition> overviewEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'overview',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MovieLocal, MovieLocal, QAfterFilterCondition>
      overviewGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'overview',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MovieLocal, MovieLocal, QAfterFilterCondition> overviewLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'overview',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MovieLocal, MovieLocal, QAfterFilterCondition> overviewBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'overview',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MovieLocal, MovieLocal, QAfterFilterCondition>
      overviewStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'overview',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MovieLocal, MovieLocal, QAfterFilterCondition> overviewEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'overview',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MovieLocal, MovieLocal, QAfterFilterCondition> overviewContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'overview',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MovieLocal, MovieLocal, QAfterFilterCondition> overviewMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'overview',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MovieLocal, MovieLocal, QAfterFilterCondition>
      overviewIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'overview',
        value: '',
      ));
    });
  }

  QueryBuilder<MovieLocal, MovieLocal, QAfterFilterCondition>
      overviewIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'overview',
        value: '',
      ));
    });
  }

  QueryBuilder<MovieLocal, MovieLocal, QAfterFilterCondition> popularityEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'popularity',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<MovieLocal, MovieLocal, QAfterFilterCondition>
      popularityGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'popularity',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<MovieLocal, MovieLocal, QAfterFilterCondition>
      popularityLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'popularity',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<MovieLocal, MovieLocal, QAfterFilterCondition> popularityBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'popularity',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<MovieLocal, MovieLocal, QAfterFilterCondition> posterPathEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'posterPath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MovieLocal, MovieLocal, QAfterFilterCondition>
      posterPathGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'posterPath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MovieLocal, MovieLocal, QAfterFilterCondition>
      posterPathLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'posterPath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MovieLocal, MovieLocal, QAfterFilterCondition> posterPathBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'posterPath',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MovieLocal, MovieLocal, QAfterFilterCondition>
      posterPathStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'posterPath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MovieLocal, MovieLocal, QAfterFilterCondition>
      posterPathEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'posterPath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MovieLocal, MovieLocal, QAfterFilterCondition>
      posterPathContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'posterPath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MovieLocal, MovieLocal, QAfterFilterCondition> posterPathMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'posterPath',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MovieLocal, MovieLocal, QAfterFilterCondition>
      posterPathIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'posterPath',
        value: '',
      ));
    });
  }

  QueryBuilder<MovieLocal, MovieLocal, QAfterFilterCondition>
      posterPathIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'posterPath',
        value: '',
      ));
    });
  }

  QueryBuilder<MovieLocal, MovieLocal, QAfterFilterCondition>
      releaseDateIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'releaseDate',
      ));
    });
  }

  QueryBuilder<MovieLocal, MovieLocal, QAfterFilterCondition>
      releaseDateIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'releaseDate',
      ));
    });
  }

  QueryBuilder<MovieLocal, MovieLocal, QAfterFilterCondition>
      releaseDateEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'releaseDate',
        value: value,
      ));
    });
  }

  QueryBuilder<MovieLocal, MovieLocal, QAfterFilterCondition>
      releaseDateGreaterThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'releaseDate',
        value: value,
      ));
    });
  }

  QueryBuilder<MovieLocal, MovieLocal, QAfterFilterCondition>
      releaseDateLessThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'releaseDate',
        value: value,
      ));
    });
  }

  QueryBuilder<MovieLocal, MovieLocal, QAfterFilterCondition>
      releaseDateBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'releaseDate',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<MovieLocal, MovieLocal, QAfterFilterCondition> titleEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MovieLocal, MovieLocal, QAfterFilterCondition> titleGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MovieLocal, MovieLocal, QAfterFilterCondition> titleLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MovieLocal, MovieLocal, QAfterFilterCondition> titleBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'title',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MovieLocal, MovieLocal, QAfterFilterCondition> titleStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MovieLocal, MovieLocal, QAfterFilterCondition> titleEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MovieLocal, MovieLocal, QAfterFilterCondition> titleContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MovieLocal, MovieLocal, QAfterFilterCondition> titleMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'title',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MovieLocal, MovieLocal, QAfterFilterCondition> titleIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'title',
        value: '',
      ));
    });
  }

  QueryBuilder<MovieLocal, MovieLocal, QAfterFilterCondition>
      titleIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'title',
        value: '',
      ));
    });
  }

  QueryBuilder<MovieLocal, MovieLocal, QAfterFilterCondition> videoEqualTo(
      bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'video',
        value: value,
      ));
    });
  }

  QueryBuilder<MovieLocal, MovieLocal, QAfterFilterCondition>
      voteAverageEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'voteAverage',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<MovieLocal, MovieLocal, QAfterFilterCondition>
      voteAverageGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'voteAverage',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<MovieLocal, MovieLocal, QAfterFilterCondition>
      voteAverageLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'voteAverage',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<MovieLocal, MovieLocal, QAfterFilterCondition>
      voteAverageBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'voteAverage',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<MovieLocal, MovieLocal, QAfterFilterCondition> voteCountEqualTo(
      int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'voteCount',
        value: value,
      ));
    });
  }

  QueryBuilder<MovieLocal, MovieLocal, QAfterFilterCondition>
      voteCountGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'voteCount',
        value: value,
      ));
    });
  }

  QueryBuilder<MovieLocal, MovieLocal, QAfterFilterCondition> voteCountLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'voteCount',
        value: value,
      ));
    });
  }

  QueryBuilder<MovieLocal, MovieLocal, QAfterFilterCondition> voteCountBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'voteCount',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension MovieLocalQueryObject
    on QueryBuilder<MovieLocal, MovieLocal, QFilterCondition> {}

extension MovieLocalQueryLinks
    on QueryBuilder<MovieLocal, MovieLocal, QFilterCondition> {}

extension MovieLocalQuerySortBy
    on QueryBuilder<MovieLocal, MovieLocal, QSortBy> {
  QueryBuilder<MovieLocal, MovieLocal, QAfterSortBy> sortByAdult() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'adult', Sort.asc);
    });
  }

  QueryBuilder<MovieLocal, MovieLocal, QAfterSortBy> sortByAdultDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'adult', Sort.desc);
    });
  }

  QueryBuilder<MovieLocal, MovieLocal, QAfterSortBy> sortByBackdropPath() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'backdropPath', Sort.asc);
    });
  }

  QueryBuilder<MovieLocal, MovieLocal, QAfterSortBy> sortByBackdropPathDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'backdropPath', Sort.desc);
    });
  }

  QueryBuilder<MovieLocal, MovieLocal, QAfterSortBy> sortById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<MovieLocal, MovieLocal, QAfterSortBy> sortByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<MovieLocal, MovieLocal, QAfterSortBy> sortByInWatchlist() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'inWatchlist', Sort.asc);
    });
  }

  QueryBuilder<MovieLocal, MovieLocal, QAfterSortBy> sortByInWatchlistDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'inWatchlist', Sort.desc);
    });
  }

  QueryBuilder<MovieLocal, MovieLocal, QAfterSortBy> sortByIsFavorite() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isFavorite', Sort.asc);
    });
  }

  QueryBuilder<MovieLocal, MovieLocal, QAfterSortBy> sortByIsFavoriteDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isFavorite', Sort.desc);
    });
  }

  QueryBuilder<MovieLocal, MovieLocal, QAfterSortBy> sortByOriginalLanguage() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'originalLanguage', Sort.asc);
    });
  }

  QueryBuilder<MovieLocal, MovieLocal, QAfterSortBy>
      sortByOriginalLanguageDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'originalLanguage', Sort.desc);
    });
  }

  QueryBuilder<MovieLocal, MovieLocal, QAfterSortBy> sortByOriginalTitle() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'originalTitle', Sort.asc);
    });
  }

  QueryBuilder<MovieLocal, MovieLocal, QAfterSortBy> sortByOriginalTitleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'originalTitle', Sort.desc);
    });
  }

  QueryBuilder<MovieLocal, MovieLocal, QAfterSortBy> sortByOverview() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'overview', Sort.asc);
    });
  }

  QueryBuilder<MovieLocal, MovieLocal, QAfterSortBy> sortByOverviewDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'overview', Sort.desc);
    });
  }

  QueryBuilder<MovieLocal, MovieLocal, QAfterSortBy> sortByPopularity() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'popularity', Sort.asc);
    });
  }

  QueryBuilder<MovieLocal, MovieLocal, QAfterSortBy> sortByPopularityDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'popularity', Sort.desc);
    });
  }

  QueryBuilder<MovieLocal, MovieLocal, QAfterSortBy> sortByPosterPath() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'posterPath', Sort.asc);
    });
  }

  QueryBuilder<MovieLocal, MovieLocal, QAfterSortBy> sortByPosterPathDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'posterPath', Sort.desc);
    });
  }

  QueryBuilder<MovieLocal, MovieLocal, QAfterSortBy> sortByReleaseDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'releaseDate', Sort.asc);
    });
  }

  QueryBuilder<MovieLocal, MovieLocal, QAfterSortBy> sortByReleaseDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'releaseDate', Sort.desc);
    });
  }

  QueryBuilder<MovieLocal, MovieLocal, QAfterSortBy> sortByTitle() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.asc);
    });
  }

  QueryBuilder<MovieLocal, MovieLocal, QAfterSortBy> sortByTitleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.desc);
    });
  }

  QueryBuilder<MovieLocal, MovieLocal, QAfterSortBy> sortByVideo() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'video', Sort.asc);
    });
  }

  QueryBuilder<MovieLocal, MovieLocal, QAfterSortBy> sortByVideoDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'video', Sort.desc);
    });
  }

  QueryBuilder<MovieLocal, MovieLocal, QAfterSortBy> sortByVoteAverage() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'voteAverage', Sort.asc);
    });
  }

  QueryBuilder<MovieLocal, MovieLocal, QAfterSortBy> sortByVoteAverageDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'voteAverage', Sort.desc);
    });
  }

  QueryBuilder<MovieLocal, MovieLocal, QAfterSortBy> sortByVoteCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'voteCount', Sort.asc);
    });
  }

  QueryBuilder<MovieLocal, MovieLocal, QAfterSortBy> sortByVoteCountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'voteCount', Sort.desc);
    });
  }
}

extension MovieLocalQuerySortThenBy
    on QueryBuilder<MovieLocal, MovieLocal, QSortThenBy> {
  QueryBuilder<MovieLocal, MovieLocal, QAfterSortBy> thenByAdult() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'adult', Sort.asc);
    });
  }

  QueryBuilder<MovieLocal, MovieLocal, QAfterSortBy> thenByAdultDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'adult', Sort.desc);
    });
  }

  QueryBuilder<MovieLocal, MovieLocal, QAfterSortBy> thenByBackdropPath() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'backdropPath', Sort.asc);
    });
  }

  QueryBuilder<MovieLocal, MovieLocal, QAfterSortBy> thenByBackdropPathDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'backdropPath', Sort.desc);
    });
  }

  QueryBuilder<MovieLocal, MovieLocal, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<MovieLocal, MovieLocal, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<MovieLocal, MovieLocal, QAfterSortBy> thenByInWatchlist() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'inWatchlist', Sort.asc);
    });
  }

  QueryBuilder<MovieLocal, MovieLocal, QAfterSortBy> thenByInWatchlistDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'inWatchlist', Sort.desc);
    });
  }

  QueryBuilder<MovieLocal, MovieLocal, QAfterSortBy> thenByIsFavorite() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isFavorite', Sort.asc);
    });
  }

  QueryBuilder<MovieLocal, MovieLocal, QAfterSortBy> thenByIsFavoriteDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isFavorite', Sort.desc);
    });
  }

  QueryBuilder<MovieLocal, MovieLocal, QAfterSortBy> thenByIsarId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isarId', Sort.asc);
    });
  }

  QueryBuilder<MovieLocal, MovieLocal, QAfterSortBy> thenByIsarIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isarId', Sort.desc);
    });
  }

  QueryBuilder<MovieLocal, MovieLocal, QAfterSortBy> thenByOriginalLanguage() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'originalLanguage', Sort.asc);
    });
  }

  QueryBuilder<MovieLocal, MovieLocal, QAfterSortBy>
      thenByOriginalLanguageDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'originalLanguage', Sort.desc);
    });
  }

  QueryBuilder<MovieLocal, MovieLocal, QAfterSortBy> thenByOriginalTitle() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'originalTitle', Sort.asc);
    });
  }

  QueryBuilder<MovieLocal, MovieLocal, QAfterSortBy> thenByOriginalTitleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'originalTitle', Sort.desc);
    });
  }

  QueryBuilder<MovieLocal, MovieLocal, QAfterSortBy> thenByOverview() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'overview', Sort.asc);
    });
  }

  QueryBuilder<MovieLocal, MovieLocal, QAfterSortBy> thenByOverviewDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'overview', Sort.desc);
    });
  }

  QueryBuilder<MovieLocal, MovieLocal, QAfterSortBy> thenByPopularity() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'popularity', Sort.asc);
    });
  }

  QueryBuilder<MovieLocal, MovieLocal, QAfterSortBy> thenByPopularityDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'popularity', Sort.desc);
    });
  }

  QueryBuilder<MovieLocal, MovieLocal, QAfterSortBy> thenByPosterPath() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'posterPath', Sort.asc);
    });
  }

  QueryBuilder<MovieLocal, MovieLocal, QAfterSortBy> thenByPosterPathDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'posterPath', Sort.desc);
    });
  }

  QueryBuilder<MovieLocal, MovieLocal, QAfterSortBy> thenByReleaseDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'releaseDate', Sort.asc);
    });
  }

  QueryBuilder<MovieLocal, MovieLocal, QAfterSortBy> thenByReleaseDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'releaseDate', Sort.desc);
    });
  }

  QueryBuilder<MovieLocal, MovieLocal, QAfterSortBy> thenByTitle() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.asc);
    });
  }

  QueryBuilder<MovieLocal, MovieLocal, QAfterSortBy> thenByTitleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.desc);
    });
  }

  QueryBuilder<MovieLocal, MovieLocal, QAfterSortBy> thenByVideo() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'video', Sort.asc);
    });
  }

  QueryBuilder<MovieLocal, MovieLocal, QAfterSortBy> thenByVideoDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'video', Sort.desc);
    });
  }

  QueryBuilder<MovieLocal, MovieLocal, QAfterSortBy> thenByVoteAverage() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'voteAverage', Sort.asc);
    });
  }

  QueryBuilder<MovieLocal, MovieLocal, QAfterSortBy> thenByVoteAverageDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'voteAverage', Sort.desc);
    });
  }

  QueryBuilder<MovieLocal, MovieLocal, QAfterSortBy> thenByVoteCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'voteCount', Sort.asc);
    });
  }

  QueryBuilder<MovieLocal, MovieLocal, QAfterSortBy> thenByVoteCountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'voteCount', Sort.desc);
    });
  }
}

extension MovieLocalQueryWhereDistinct
    on QueryBuilder<MovieLocal, MovieLocal, QDistinct> {
  QueryBuilder<MovieLocal, MovieLocal, QDistinct> distinctByAdult() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'adult');
    });
  }

  QueryBuilder<MovieLocal, MovieLocal, QDistinct> distinctByBackdropPath(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'backdropPath', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<MovieLocal, MovieLocal, QDistinct> distinctByGenreIds() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'genreIds');
    });
  }

  QueryBuilder<MovieLocal, MovieLocal, QDistinct> distinctById() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'id');
    });
  }

  QueryBuilder<MovieLocal, MovieLocal, QDistinct> distinctByInWatchlist() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'inWatchlist');
    });
  }

  QueryBuilder<MovieLocal, MovieLocal, QDistinct> distinctByIsFavorite() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isFavorite');
    });
  }

  QueryBuilder<MovieLocal, MovieLocal, QDistinct> distinctByOriginalLanguage(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'originalLanguage',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<MovieLocal, MovieLocal, QDistinct> distinctByOriginalTitle(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'originalTitle',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<MovieLocal, MovieLocal, QDistinct> distinctByOverview(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'overview', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<MovieLocal, MovieLocal, QDistinct> distinctByPopularity() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'popularity');
    });
  }

  QueryBuilder<MovieLocal, MovieLocal, QDistinct> distinctByPosterPath(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'posterPath', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<MovieLocal, MovieLocal, QDistinct> distinctByReleaseDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'releaseDate');
    });
  }

  QueryBuilder<MovieLocal, MovieLocal, QDistinct> distinctByTitle(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'title', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<MovieLocal, MovieLocal, QDistinct> distinctByVideo() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'video');
    });
  }

  QueryBuilder<MovieLocal, MovieLocal, QDistinct> distinctByVoteAverage() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'voteAverage');
    });
  }

  QueryBuilder<MovieLocal, MovieLocal, QDistinct> distinctByVoteCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'voteCount');
    });
  }
}

extension MovieLocalQueryProperty
    on QueryBuilder<MovieLocal, MovieLocal, QQueryProperty> {
  QueryBuilder<MovieLocal, int, QQueryOperations> isarIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isarId');
    });
  }

  QueryBuilder<MovieLocal, bool, QQueryOperations> adultProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'adult');
    });
  }

  QueryBuilder<MovieLocal, String, QQueryOperations> backdropPathProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'backdropPath');
    });
  }

  QueryBuilder<MovieLocal, List<String>, QQueryOperations> genreIdsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'genreIds');
    });
  }

  QueryBuilder<MovieLocal, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<MovieLocal, bool, QQueryOperations> inWatchlistProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'inWatchlist');
    });
  }

  QueryBuilder<MovieLocal, bool, QQueryOperations> isFavoriteProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isFavorite');
    });
  }

  QueryBuilder<MovieLocal, String, QQueryOperations>
      originalLanguageProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'originalLanguage');
    });
  }

  QueryBuilder<MovieLocal, String, QQueryOperations> originalTitleProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'originalTitle');
    });
  }

  QueryBuilder<MovieLocal, String, QQueryOperations> overviewProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'overview');
    });
  }

  QueryBuilder<MovieLocal, double, QQueryOperations> popularityProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'popularity');
    });
  }

  QueryBuilder<MovieLocal, String, QQueryOperations> posterPathProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'posterPath');
    });
  }

  QueryBuilder<MovieLocal, DateTime?, QQueryOperations> releaseDateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'releaseDate');
    });
  }

  QueryBuilder<MovieLocal, String, QQueryOperations> titleProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'title');
    });
  }

  QueryBuilder<MovieLocal, bool, QQueryOperations> videoProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'video');
    });
  }

  QueryBuilder<MovieLocal, double, QQueryOperations> voteAverageProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'voteAverage');
    });
  }

  QueryBuilder<MovieLocal, int, QQueryOperations> voteCountProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'voteCount');
    });
  }
}
