part of 'product_bloc.dart';

/// Product Events
sealed class ProductEvent {
  const ProductEvent();
}

/// Fetch initial products
final class ProductsFetchRequested extends ProductEvent {
  const ProductsFetchRequested();
}

/// Load more products (pagination)
final class ProductsLoadMoreRequested extends ProductEvent {
  const ProductsLoadMoreRequested();
}

/// Search products
final class ProductSearchRequested extends ProductEvent {
  final String query;

  const ProductSearchRequested(this.query);
}

/// Update filters
final class ProductFilterChanged extends ProductEvent {
  final ProductFilters filters;

  const ProductFilterChanged(this.filters);
}

/// Update sort option
final class ProductSortChanged extends ProductEvent {
  final ProductSortBy sortBy;

  const ProductSortChanged(this.sortBy);
}

/// Fetch product details
final class ProductDetailFetchRequested extends ProductEvent {
  final String productId;

  const ProductDetailFetchRequested(this.productId);
}

/// Change category
final class ProductsCategoryChanged extends ProductEvent {
  final String? categoryId;

  const ProductsCategoryChanged(this.categoryId);
}

/// Refresh products list
final class ProductsRefreshRequested extends ProductEvent {
  const ProductsRefreshRequested();
}
