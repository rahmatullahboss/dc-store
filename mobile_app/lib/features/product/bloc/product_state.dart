part of 'product_bloc.dart';

/// Product loading status
enum ProductStatus { initial, loading, loadingMore, loaded, error }

/// Product sort options
enum ProductSortBy {
  newest,
  priceLowToHigh,
  priceHighToLow,
  rating,
  popularity;

  String get displayName {
    switch (this) {
      case ProductSortBy.newest:
        return 'Newest';
      case ProductSortBy.priceLowToHigh:
        return 'Price: Low to High';
      case ProductSortBy.priceHighToLow:
        return 'Price: High to Low';
      case ProductSortBy.rating:
        return 'Rating';
      case ProductSortBy.popularity:
        return 'Popularity';
    }
  }
}

/// Product filters
class ProductFilters extends Equatable {
  final double? minPrice;
  final double? maxPrice;
  final List<String>? categoryIds;
  final List<String>? brandIds;
  final double? minRating;
  final bool? inStockOnly;
  final bool? onSaleOnly;

  const ProductFilters({
    this.minPrice,
    this.maxPrice,
    this.categoryIds,
    this.brandIds,
    this.minRating,
    this.inStockOnly,
    this.onSaleOnly,
  });

  ProductFilters copyWith({
    double? minPrice,
    double? maxPrice,
    List<String>? categoryIds,
    List<String>? brandIds,
    double? minRating,
    bool? inStockOnly,
    bool? onSaleOnly,
  }) {
    return ProductFilters(
      minPrice: minPrice ?? this.minPrice,
      maxPrice: maxPrice ?? this.maxPrice,
      categoryIds: categoryIds ?? this.categoryIds,
      brandIds: brandIds ?? this.brandIds,
      minRating: minRating ?? this.minRating,
      inStockOnly: inStockOnly ?? this.inStockOnly,
      onSaleOnly: onSaleOnly ?? this.onSaleOnly,
    );
  }

  bool get hasFilters =>
      minPrice != null ||
      maxPrice != null ||
      (categoryIds?.isNotEmpty ?? false) ||
      (brandIds?.isNotEmpty ?? false) ||
      minRating != null ||
      (inStockOnly ?? false) ||
      (onSaleOnly ?? false);

  @override
  List<Object?> get props => [
    minPrice,
    maxPrice,
    categoryIds,
    brandIds,
    minRating,
    inStockOnly,
    onSaleOnly,
  ];
}

/// Product State
class ProductState extends Equatable {
  final ProductStatus status;
  final ProductStatus detailStatus;
  final List<ProductModel> products;
  final ProductModel? selectedProduct;
  final List<CategoryModel> categories;
  final String? selectedCategoryId;
  final ProductFilters filters;
  final ProductSortBy sortBy;
  final String? searchQuery;
  final int currentPage;
  final bool hasReachedMax;
  final String? errorMessage;

  const ProductState({
    this.status = ProductStatus.initial,
    this.detailStatus = ProductStatus.initial,
    this.products = const [],
    this.selectedProduct,
    this.categories = const [],
    this.selectedCategoryId,
    this.filters = const ProductFilters(),
    this.sortBy = ProductSortBy.newest,
    this.searchQuery,
    this.currentPage = 1,
    this.hasReachedMax = false,
    this.errorMessage,
  });

  ProductState copyWith({
    ProductStatus? status,
    ProductStatus? detailStatus,
    List<ProductModel>? products,
    ProductModel? selectedProduct,
    List<CategoryModel>? categories,
    String? selectedCategoryId,
    ProductFilters? filters,
    ProductSortBy? sortBy,
    String? searchQuery,
    int? currentPage,
    bool? hasReachedMax,
    String? errorMessage,
  }) {
    return ProductState(
      status: status ?? this.status,
      detailStatus: detailStatus ?? this.detailStatus,
      products: products ?? this.products,
      selectedProduct: selectedProduct ?? this.selectedProduct,
      categories: categories ?? this.categories,
      selectedCategoryId: selectedCategoryId ?? this.selectedCategoryId,
      filters: filters ?? this.filters,
      sortBy: sortBy ?? this.sortBy,
      searchQuery: searchQuery ?? this.searchQuery,
      currentPage: currentPage ?? this.currentPage,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
    status,
    detailStatus,
    products,
    selectedProduct,
    categories,
    selectedCategoryId,
    filters,
    sortBy,
    searchQuery,
    currentPage,
    hasReachedMax,
    errorMessage,
  ];
}
