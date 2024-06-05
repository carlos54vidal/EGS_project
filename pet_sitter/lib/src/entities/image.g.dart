// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'image.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetImageEntityCollection on Isar {
  IsarCollection<ImageEntity> get imageEntitys => this.collection();
}

const ImageEntitySchema = CollectionSchema(
  name: r'ImageEntity',
  id: -4984262976942117902,
  properties: {
    r'imagebytes': PropertySchema(
      id: 0,
      name: r'imagebytes',
      type: IsarType.byteList,
    )
  },
  estimateSize: _imageEntityEstimateSize,
  serialize: _imageEntitySerialize,
  deserialize: _imageEntityDeserialize,
  deserializeProp: _imageEntityDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {
    r'petsitter': LinkSchema(
      id: -3858400535315969123,
      name: r'petsitter',
      target: r'Petsitter',
      single: true,
      linkName: r'images',
    )
  },
  embeddedSchemas: {},
  getId: _imageEntityGetId,
  getLinks: _imageEntityGetLinks,
  attach: _imageEntityAttach,
  version: '3.1.0',
);

int _imageEntityEstimateSize(
  ImageEntity object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.imagebytes.length;
  return bytesCount;
}

void _imageEntitySerialize(
  ImageEntity object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeByteList(offsets[0], object.imagebytes);
}

ImageEntity _imageEntityDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = ImageEntity();
  object.id = id;
  object.imagebytes = reader.readByteList(offsets[0]) ?? [];
  return object;
}

P _imageEntityDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readByteList(offset) ?? []) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _imageEntityGetId(ImageEntity object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _imageEntityGetLinks(ImageEntity object) {
  return [object.petsitter];
}

void _imageEntityAttach(
    IsarCollection<dynamic> col, Id id, ImageEntity object) {
  object.id = id;
  object.petsitter
      .attach(col, col.isar.collection<Petsitter>(), r'petsitter', id);
}

extension ImageEntityQueryWhereSort
    on QueryBuilder<ImageEntity, ImageEntity, QWhere> {
  QueryBuilder<ImageEntity, ImageEntity, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension ImageEntityQueryWhere
    on QueryBuilder<ImageEntity, ImageEntity, QWhereClause> {
  QueryBuilder<ImageEntity, ImageEntity, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<ImageEntity, ImageEntity, QAfterWhereClause> idNotEqualTo(
      Id id) {
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

  QueryBuilder<ImageEntity, ImageEntity, QAfterWhereClause> idGreaterThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<ImageEntity, ImageEntity, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<ImageEntity, ImageEntity, QAfterWhereClause> idBetween(
    Id lowerId,
    Id upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: lowerId,
        includeLower: includeLower,
        upper: upperId,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension ImageEntityQueryFilter
    on QueryBuilder<ImageEntity, ImageEntity, QFilterCondition> {
  QueryBuilder<ImageEntity, ImageEntity, QAfterFilterCondition> idEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<ImageEntity, ImageEntity, QAfterFilterCondition> idGreaterThan(
    Id value, {
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

  QueryBuilder<ImageEntity, ImageEntity, QAfterFilterCondition> idLessThan(
    Id value, {
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

  QueryBuilder<ImageEntity, ImageEntity, QAfterFilterCondition> idBetween(
    Id lower,
    Id upper, {
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

  QueryBuilder<ImageEntity, ImageEntity, QAfterFilterCondition>
      imagebytesElementEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'imagebytes',
        value: value,
      ));
    });
  }

  QueryBuilder<ImageEntity, ImageEntity, QAfterFilterCondition>
      imagebytesElementGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'imagebytes',
        value: value,
      ));
    });
  }

  QueryBuilder<ImageEntity, ImageEntity, QAfterFilterCondition>
      imagebytesElementLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'imagebytes',
        value: value,
      ));
    });
  }

  QueryBuilder<ImageEntity, ImageEntity, QAfterFilterCondition>
      imagebytesElementBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'imagebytes',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<ImageEntity, ImageEntity, QAfterFilterCondition>
      imagebytesLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'imagebytes',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<ImageEntity, ImageEntity, QAfterFilterCondition>
      imagebytesIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'imagebytes',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<ImageEntity, ImageEntity, QAfterFilterCondition>
      imagebytesIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'imagebytes',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<ImageEntity, ImageEntity, QAfterFilterCondition>
      imagebytesLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'imagebytes',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<ImageEntity, ImageEntity, QAfterFilterCondition>
      imagebytesLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'imagebytes',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<ImageEntity, ImageEntity, QAfterFilterCondition>
      imagebytesLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'imagebytes',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }
}

extension ImageEntityQueryObject
    on QueryBuilder<ImageEntity, ImageEntity, QFilterCondition> {}

extension ImageEntityQueryLinks
    on QueryBuilder<ImageEntity, ImageEntity, QFilterCondition> {
  QueryBuilder<ImageEntity, ImageEntity, QAfterFilterCondition> petsitter(
      FilterQuery<Petsitter> q) {
    return QueryBuilder.apply(this, (query) {
      return query.link(q, r'petsitter');
    });
  }

  QueryBuilder<ImageEntity, ImageEntity, QAfterFilterCondition>
      petsitterIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'petsitter', 0, true, 0, true);
    });
  }
}

extension ImageEntityQuerySortBy
    on QueryBuilder<ImageEntity, ImageEntity, QSortBy> {}

extension ImageEntityQuerySortThenBy
    on QueryBuilder<ImageEntity, ImageEntity, QSortThenBy> {
  QueryBuilder<ImageEntity, ImageEntity, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<ImageEntity, ImageEntity, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }
}

extension ImageEntityQueryWhereDistinct
    on QueryBuilder<ImageEntity, ImageEntity, QDistinct> {
  QueryBuilder<ImageEntity, ImageEntity, QDistinct> distinctByImagebytes() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'imagebytes');
    });
  }
}

extension ImageEntityQueryProperty
    on QueryBuilder<ImageEntity, ImageEntity, QQueryProperty> {
  QueryBuilder<ImageEntity, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<ImageEntity, List<int>, QQueryOperations> imagebytesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'imagebytes');
    });
  }
}
