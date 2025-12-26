import 'package:freezed_annotation/freezed_annotation.dart';

part 'pagination.freezed.dart';
part 'pagination.g.dart';

/// Pagination Model for API responses
@freezed
class PaginationModel with _$PaginationModel {
  const factory PaginationModel({
    @Default(1) int currentPage,
    @Default(1) int totalPages,
    @Default(0) int totalItems,
    @Default(20) int perPage,
    @Default(false) bool hasNextPage,
    @Default(false) bool hasPreviousPage,
  }) = _PaginationModel;

  factory PaginationModel.fromJson(Map<String, dynamic> json) =>
      _$PaginationModelFromJson(json);
}

/// Paginated Response wrapper
@freezed
class PaginatedResponse<T> with _$PaginatedResponse<T> {
  const factory PaginatedResponse({
    required List<T> items,
    required PaginationModel pagination,
  }) = _PaginatedResponse<T>;

  const PaginatedResponse._();

  /// Check if there are more items to load
  bool get hasMore => pagination.hasNextPage;

  /// Get next page number
  int get nextPage => pagination.currentPage + 1;

  /// Check if this is the first page
  bool get isFirstPage => pagination.currentPage == 1;

  /// Check if this is the last page
  bool get isLastPage => !pagination.hasNextPage;
}

/// Product filter parameters
@freezed
class ProductFilters with _$ProductFilters {
  const factory ProductFilters({
    String? categoryId,
    String? query,
    double? minPrice,
    double? maxPrice,
    @Default([]) List<String> brands,
    @Default([]) List<String> tags,
    double? minRating,
    @Default(false) bool onSale,
    @Default(false) bool inStock,
    @Default(false) bool featured,
    @Default(SortOption.newest) SortOption sortBy,
    @Default(1) int page,
    @Default(20) int perPage,
  }) = _ProductFilters;

  const ProductFilters._();

  /// Convert to query parameters
  Map<String, dynamic> toQueryParams() {
    final params = <String, dynamic>{'page': page, 'perPage': perPage};

    if (categoryId != null) params['categoryId'] = categoryId;
    if (query != null && query!.isNotEmpty) params['q'] = query;
    if (minPrice != null) params['minPrice'] = minPrice;
    if (maxPrice != null) params['maxPrice'] = maxPrice;
    if (brands.isNotEmpty) params['brands'] = brands.join(',');
    if (tags.isNotEmpty) params['tags'] = tags.join(',');
    if (minRating != null) params['minRating'] = minRating;
    if (onSale) params['onSale'] = true;
    if (inStock) params['inStock'] = true;
    if (featured) params['featured'] = true;
    params['sortBy'] = sortBy.value;

    return params;
  }

  /// Create cache key from filters
  String toCacheKey() {
    final parts = <String>[];
    if (categoryId != null) parts.add('cat_$categoryId');
    if (query != null) parts.add('q_$query');
    if (minPrice != null) parts.add('minP_$minPrice');
    if (maxPrice != null) parts.add('maxP_$maxPrice');
    if (brands.isNotEmpty) parts.add('brands_${brands.join('_')}');
    if (onSale) parts.add('sale');
    if (inStock) parts.add('stock');
    if (featured) parts.add('feat');
    parts.add('sort_${sortBy.value}');
    parts.add('p_$page');
    return parts.isEmpty ? 'all' : parts.join('_');
  }

  factory ProductFilters.fromJson(Map<String, dynamic> json) =>
      _$ProductFiltersFromJson(json);
}

/// Sort options for products
enum SortOption {
  newest('newest', 'Newest First'),
  oldest('oldest', 'Oldest First'),
  priceLowToHigh('price_asc', 'Price: Low to High'),
  priceHighToLow('price_desc', 'Price: High to Low'),
  rating('rating', 'Top Rated'),
  popularity('popular', 'Most Popular'),
  name('name', 'Name: A to Z');

  final String value;
  final String displayName;

  const SortOption(this.value, this.displayName);
}
