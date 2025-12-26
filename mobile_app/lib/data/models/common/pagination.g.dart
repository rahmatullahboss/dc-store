// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pagination.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PaginationModelImpl _$$PaginationModelImplFromJson(
        Map<String, dynamic> json) =>
    _$PaginationModelImpl(
      currentPage: (json['currentPage'] as num?)?.toInt() ?? 1,
      totalPages: (json['totalPages'] as num?)?.toInt() ?? 1,
      totalItems: (json['totalItems'] as num?)?.toInt() ?? 0,
      perPage: (json['perPage'] as num?)?.toInt() ?? 20,
      hasNextPage: json['hasNextPage'] as bool? ?? false,
      hasPreviousPage: json['hasPreviousPage'] as bool? ?? false,
    );

Map<String, dynamic> _$$PaginationModelImplToJson(
        _$PaginationModelImpl instance) =>
    <String, dynamic>{
      'currentPage': instance.currentPage,
      'totalPages': instance.totalPages,
      'totalItems': instance.totalItems,
      'perPage': instance.perPage,
      'hasNextPage': instance.hasNextPage,
      'hasPreviousPage': instance.hasPreviousPage,
    };

_$ProductFiltersImpl _$$ProductFiltersImplFromJson(Map<String, dynamic> json) =>
    _$ProductFiltersImpl(
      categoryId: json['categoryId'] as String?,
      query: json['query'] as String?,
      minPrice: (json['minPrice'] as num?)?.toDouble(),
      maxPrice: (json['maxPrice'] as num?)?.toDouble(),
      brands: (json['brands'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      tags:
          (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList() ??
              const [],
      minRating: (json['minRating'] as num?)?.toDouble(),
      onSale: json['onSale'] as bool? ?? false,
      inStock: json['inStock'] as bool? ?? false,
      featured: json['featured'] as bool? ?? false,
      sortBy: $enumDecodeNullable(_$SortOptionEnumMap, json['sortBy']) ??
          SortOption.newest,
      page: (json['page'] as num?)?.toInt() ?? 1,
      perPage: (json['perPage'] as num?)?.toInt() ?? 20,
    );

Map<String, dynamic> _$$ProductFiltersImplToJson(
        _$ProductFiltersImpl instance) =>
    <String, dynamic>{
      'categoryId': instance.categoryId,
      'query': instance.query,
      'minPrice': instance.minPrice,
      'maxPrice': instance.maxPrice,
      'brands': instance.brands,
      'tags': instance.tags,
      'minRating': instance.minRating,
      'onSale': instance.onSale,
      'inStock': instance.inStock,
      'featured': instance.featured,
      'sortBy': _$SortOptionEnumMap[instance.sortBy]!,
      'page': instance.page,
      'perPage': instance.perPage,
    };

const _$SortOptionEnumMap = {
  SortOption.newest: 'newest',
  SortOption.oldest: 'oldest',
  SortOption.priceLowToHigh: 'priceLowToHigh',
  SortOption.priceHighToLow: 'priceHighToLow',
  SortOption.rating: 'rating',
  SortOption.popularity: 'popularity',
  SortOption.name: 'name',
};
