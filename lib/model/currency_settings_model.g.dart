// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'currency_settings_model.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetCurrencySettingsModelCollection on Isar {
  IsarCollection<CurrencySettingsModel> get currencySettingsModels =>
      this.collection();
}

const CurrencySettingsModelSchema = CollectionSchema(
  name: r'CurrencySettingsModel',
  id: 6894614232661551693,
  properties: {
    r'baseCurrencyCode': PropertySchema(
      id: 0,
      name: r'baseCurrencyCode',
      type: IsarType.string,
    ),
    r'secondaryCurrencyCode': PropertySchema(
      id: 1,
      name: r'secondaryCurrencyCode',
      type: IsarType.string,
    ),
    r'secondaryExchangeRate': PropertySchema(
      id: 2,
      name: r'secondaryExchangeRate',
      type: IsarType.double,
    ),
  },

  estimateSize: _currencySettingsModelEstimateSize,
  serialize: _currencySettingsModelSerialize,
  deserialize: _currencySettingsModelDeserialize,
  deserializeProp: _currencySettingsModelDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {},

  getId: _currencySettingsModelGetId,
  getLinks: _currencySettingsModelGetLinks,
  attach: _currencySettingsModelAttach,
  version: '3.3.2',
);

int _currencySettingsModelEstimateSize(
  CurrencySettingsModel object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.baseCurrencyCode.length * 3;
  bytesCount += 3 + object.secondaryCurrencyCode.length * 3;
  return bytesCount;
}

void _currencySettingsModelSerialize(
  CurrencySettingsModel object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.baseCurrencyCode);
  writer.writeString(offsets[1], object.secondaryCurrencyCode);
  writer.writeDouble(offsets[2], object.secondaryExchangeRate);
}

CurrencySettingsModel _currencySettingsModelDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = CurrencySettingsModel();
  object.baseCurrencyCode = reader.readString(offsets[0]);
  object.id = id;
  object.secondaryCurrencyCode = reader.readString(offsets[1]);
  object.secondaryExchangeRate = reader.readDouble(offsets[2]);
  return object;
}

P _currencySettingsModelDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readString(offset)) as P;
    case 1:
      return (reader.readString(offset)) as P;
    case 2:
      return (reader.readDouble(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _currencySettingsModelGetId(CurrencySettingsModel object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _currencySettingsModelGetLinks(
  CurrencySettingsModel object,
) {
  return [];
}

void _currencySettingsModelAttach(
  IsarCollection<dynamic> col,
  Id id,
  CurrencySettingsModel object,
) {
  object.id = id;
}

extension CurrencySettingsModelQueryWhereSort
    on QueryBuilder<CurrencySettingsModel, CurrencySettingsModel, QWhere> {
  QueryBuilder<CurrencySettingsModel, CurrencySettingsModel, QAfterWhere>
  anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension CurrencySettingsModelQueryWhere
    on
        QueryBuilder<
          CurrencySettingsModel,
          CurrencySettingsModel,
          QWhereClause
        > {
  QueryBuilder<CurrencySettingsModel, CurrencySettingsModel, QAfterWhereClause>
  idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(lower: id, upper: id));
    });
  }

  QueryBuilder<CurrencySettingsModel, CurrencySettingsModel, QAfterWhereClause>
  idNotEqualTo(Id id) {
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

  QueryBuilder<CurrencySettingsModel, CurrencySettingsModel, QAfterWhereClause>
  idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<CurrencySettingsModel, CurrencySettingsModel, QAfterWhereClause>
  idLessThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<CurrencySettingsModel, CurrencySettingsModel, QAfterWhereClause>
  idBetween(
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
}

extension CurrencySettingsModelQueryFilter
    on
        QueryBuilder<
          CurrencySettingsModel,
          CurrencySettingsModel,
          QFilterCondition
        > {
  QueryBuilder<
    CurrencySettingsModel,
    CurrencySettingsModel,
    QAfterFilterCondition
  >
  baseCurrencyCodeEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'baseCurrencyCode',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    CurrencySettingsModel,
    CurrencySettingsModel,
    QAfterFilterCondition
  >
  baseCurrencyCodeGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'baseCurrencyCode',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    CurrencySettingsModel,
    CurrencySettingsModel,
    QAfterFilterCondition
  >
  baseCurrencyCodeLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'baseCurrencyCode',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    CurrencySettingsModel,
    CurrencySettingsModel,
    QAfterFilterCondition
  >
  baseCurrencyCodeBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'baseCurrencyCode',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    CurrencySettingsModel,
    CurrencySettingsModel,
    QAfterFilterCondition
  >
  baseCurrencyCodeStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'baseCurrencyCode',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    CurrencySettingsModel,
    CurrencySettingsModel,
    QAfterFilterCondition
  >
  baseCurrencyCodeEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'baseCurrencyCode',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    CurrencySettingsModel,
    CurrencySettingsModel,
    QAfterFilterCondition
  >
  baseCurrencyCodeContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'baseCurrencyCode',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    CurrencySettingsModel,
    CurrencySettingsModel,
    QAfterFilterCondition
  >
  baseCurrencyCodeMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'baseCurrencyCode',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    CurrencySettingsModel,
    CurrencySettingsModel,
    QAfterFilterCondition
  >
  baseCurrencyCodeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'baseCurrencyCode', value: ''),
      );
    });
  }

  QueryBuilder<
    CurrencySettingsModel,
    CurrencySettingsModel,
    QAfterFilterCondition
  >
  baseCurrencyCodeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'baseCurrencyCode', value: ''),
      );
    });
  }

  QueryBuilder<
    CurrencySettingsModel,
    CurrencySettingsModel,
    QAfterFilterCondition
  >
  idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'id', value: value),
      );
    });
  }

  QueryBuilder<
    CurrencySettingsModel,
    CurrencySettingsModel,
    QAfterFilterCondition
  >
  idGreaterThan(Id value, {bool include = false}) {
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

  QueryBuilder<
    CurrencySettingsModel,
    CurrencySettingsModel,
    QAfterFilterCondition
  >
  idLessThan(Id value, {bool include = false}) {
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

  QueryBuilder<
    CurrencySettingsModel,
    CurrencySettingsModel,
    QAfterFilterCondition
  >
  idBetween(
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

  QueryBuilder<
    CurrencySettingsModel,
    CurrencySettingsModel,
    QAfterFilterCondition
  >
  secondaryCurrencyCodeEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'secondaryCurrencyCode',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    CurrencySettingsModel,
    CurrencySettingsModel,
    QAfterFilterCondition
  >
  secondaryCurrencyCodeGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'secondaryCurrencyCode',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    CurrencySettingsModel,
    CurrencySettingsModel,
    QAfterFilterCondition
  >
  secondaryCurrencyCodeLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'secondaryCurrencyCode',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    CurrencySettingsModel,
    CurrencySettingsModel,
    QAfterFilterCondition
  >
  secondaryCurrencyCodeBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'secondaryCurrencyCode',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    CurrencySettingsModel,
    CurrencySettingsModel,
    QAfterFilterCondition
  >
  secondaryCurrencyCodeStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'secondaryCurrencyCode',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    CurrencySettingsModel,
    CurrencySettingsModel,
    QAfterFilterCondition
  >
  secondaryCurrencyCodeEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'secondaryCurrencyCode',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    CurrencySettingsModel,
    CurrencySettingsModel,
    QAfterFilterCondition
  >
  secondaryCurrencyCodeContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'secondaryCurrencyCode',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    CurrencySettingsModel,
    CurrencySettingsModel,
    QAfterFilterCondition
  >
  secondaryCurrencyCodeMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'secondaryCurrencyCode',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    CurrencySettingsModel,
    CurrencySettingsModel,
    QAfterFilterCondition
  >
  secondaryCurrencyCodeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'secondaryCurrencyCode', value: ''),
      );
    });
  }

  QueryBuilder<
    CurrencySettingsModel,
    CurrencySettingsModel,
    QAfterFilterCondition
  >
  secondaryCurrencyCodeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          property: r'secondaryCurrencyCode',
          value: '',
        ),
      );
    });
  }

  QueryBuilder<
    CurrencySettingsModel,
    CurrencySettingsModel,
    QAfterFilterCondition
  >
  secondaryExchangeRateEqualTo(double value, {double epsilon = Query.epsilon}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'secondaryExchangeRate',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<
    CurrencySettingsModel,
    CurrencySettingsModel,
    QAfterFilterCondition
  >
  secondaryExchangeRateGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'secondaryExchangeRate',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<
    CurrencySettingsModel,
    CurrencySettingsModel,
    QAfterFilterCondition
  >
  secondaryExchangeRateLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'secondaryExchangeRate',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<
    CurrencySettingsModel,
    CurrencySettingsModel,
    QAfterFilterCondition
  >
  secondaryExchangeRateBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'secondaryExchangeRate',
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

extension CurrencySettingsModelQueryObject
    on
        QueryBuilder<
          CurrencySettingsModel,
          CurrencySettingsModel,
          QFilterCondition
        > {}

extension CurrencySettingsModelQueryLinks
    on
        QueryBuilder<
          CurrencySettingsModel,
          CurrencySettingsModel,
          QFilterCondition
        > {}

extension CurrencySettingsModelQuerySortBy
    on QueryBuilder<CurrencySettingsModel, CurrencySettingsModel, QSortBy> {
  QueryBuilder<CurrencySettingsModel, CurrencySettingsModel, QAfterSortBy>
  sortByBaseCurrencyCode() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'baseCurrencyCode', Sort.asc);
    });
  }

  QueryBuilder<CurrencySettingsModel, CurrencySettingsModel, QAfterSortBy>
  sortByBaseCurrencyCodeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'baseCurrencyCode', Sort.desc);
    });
  }

  QueryBuilder<CurrencySettingsModel, CurrencySettingsModel, QAfterSortBy>
  sortBySecondaryCurrencyCode() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'secondaryCurrencyCode', Sort.asc);
    });
  }

  QueryBuilder<CurrencySettingsModel, CurrencySettingsModel, QAfterSortBy>
  sortBySecondaryCurrencyCodeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'secondaryCurrencyCode', Sort.desc);
    });
  }

  QueryBuilder<CurrencySettingsModel, CurrencySettingsModel, QAfterSortBy>
  sortBySecondaryExchangeRate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'secondaryExchangeRate', Sort.asc);
    });
  }

  QueryBuilder<CurrencySettingsModel, CurrencySettingsModel, QAfterSortBy>
  sortBySecondaryExchangeRateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'secondaryExchangeRate', Sort.desc);
    });
  }
}

extension CurrencySettingsModelQuerySortThenBy
    on QueryBuilder<CurrencySettingsModel, CurrencySettingsModel, QSortThenBy> {
  QueryBuilder<CurrencySettingsModel, CurrencySettingsModel, QAfterSortBy>
  thenByBaseCurrencyCode() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'baseCurrencyCode', Sort.asc);
    });
  }

  QueryBuilder<CurrencySettingsModel, CurrencySettingsModel, QAfterSortBy>
  thenByBaseCurrencyCodeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'baseCurrencyCode', Sort.desc);
    });
  }

  QueryBuilder<CurrencySettingsModel, CurrencySettingsModel, QAfterSortBy>
  thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<CurrencySettingsModel, CurrencySettingsModel, QAfterSortBy>
  thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<CurrencySettingsModel, CurrencySettingsModel, QAfterSortBy>
  thenBySecondaryCurrencyCode() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'secondaryCurrencyCode', Sort.asc);
    });
  }

  QueryBuilder<CurrencySettingsModel, CurrencySettingsModel, QAfterSortBy>
  thenBySecondaryCurrencyCodeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'secondaryCurrencyCode', Sort.desc);
    });
  }

  QueryBuilder<CurrencySettingsModel, CurrencySettingsModel, QAfterSortBy>
  thenBySecondaryExchangeRate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'secondaryExchangeRate', Sort.asc);
    });
  }

  QueryBuilder<CurrencySettingsModel, CurrencySettingsModel, QAfterSortBy>
  thenBySecondaryExchangeRateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'secondaryExchangeRate', Sort.desc);
    });
  }
}

extension CurrencySettingsModelQueryWhereDistinct
    on QueryBuilder<CurrencySettingsModel, CurrencySettingsModel, QDistinct> {
  QueryBuilder<CurrencySettingsModel, CurrencySettingsModel, QDistinct>
  distinctByBaseCurrencyCode({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(
        r'baseCurrencyCode',
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<CurrencySettingsModel, CurrencySettingsModel, QDistinct>
  distinctBySecondaryCurrencyCode({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(
        r'secondaryCurrencyCode',
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<CurrencySettingsModel, CurrencySettingsModel, QDistinct>
  distinctBySecondaryExchangeRate() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'secondaryExchangeRate');
    });
  }
}

extension CurrencySettingsModelQueryProperty
    on
        QueryBuilder<
          CurrencySettingsModel,
          CurrencySettingsModel,
          QQueryProperty
        > {
  QueryBuilder<CurrencySettingsModel, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<CurrencySettingsModel, String, QQueryOperations>
  baseCurrencyCodeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'baseCurrencyCode');
    });
  }

  QueryBuilder<CurrencySettingsModel, String, QQueryOperations>
  secondaryCurrencyCodeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'secondaryCurrencyCode');
    });
  }

  QueryBuilder<CurrencySettingsModel, double, QQueryOperations>
  secondaryExchangeRateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'secondaryExchangeRate');
    });
  }
}
