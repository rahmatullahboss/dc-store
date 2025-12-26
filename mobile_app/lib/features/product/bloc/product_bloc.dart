import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../data/models/product/product_model.dart';
import '../../../data/models/category/category_model.dart';

part 'product_event.dart';
part 'product_state.dart';

/// ProductBloc - Handles product listing, search, and filtering
class ProductBloc extends Bloc<ProductEvent, ProductState> {
  ProductBloc() : super(const ProductState()) {
    on<ProductsFetchRequested>(_onFetchRequested);
    on<ProductsLoadMoreRequested>(_onLoadMoreRequested);
    on<ProductSearchRequested>(_onSearchRequested);
    on<ProductFilterChanged>(_onFilterChanged);
    on<ProductSortChanged>(_onSortChanged);
    on<ProductDetailFetchRequested>(_onDetailFetchRequested);
    on<ProductsCategoryChanged>(_onCategoryChanged);
    on<ProductsRefreshRequested>(_onRefreshRequested);
  }

  /// Fetch initial products
  Future<void> _onFetchRequested(
    ProductsFetchRequested event,
    Emitter<ProductState> emit,
  ) async {
    emit(state.copyWith(status: ProductStatus.loading));

    try {
      // TODO: Call product repository
      await Future.delayed(const Duration(milliseconds: 500));

      // Mock products
      final products = List.generate(
        20,
        (i) => ProductModel(
          id: 'product_$i',
          name: 'Product ${i + 1}',
          price: (i + 1) * 100.0,
          rating: 4.5,
          reviewCount: (i + 1) * 10,
          stock: 10,
        ),
      );

      emit(
        state.copyWith(
          status: ProductStatus.loaded,
          products: products,
          currentPage: 1,
          hasReachedMax: products.length < 20,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(status: ProductStatus.error, errorMessage: e.toString()),
      );
    }
  }

  /// Load more products (pagination)
  Future<void> _onLoadMoreRequested(
    ProductsLoadMoreRequested event,
    Emitter<ProductState> emit,
  ) async {
    if (state.hasReachedMax || state.status == ProductStatus.loadingMore) {
      return;
    }

    emit(state.copyWith(status: ProductStatus.loadingMore));

    try {
      await Future.delayed(const Duration(milliseconds: 500));

      final nextPage = state.currentPage + 1;
      final newProducts = List.generate(
        20,
        (i) => ProductModel(
          id: 'product_${state.products.length + i}',
          name: 'Product ${state.products.length + i + 1}',
          price: (state.products.length + i + 1) * 100.0,
          rating: 4.0,
          reviewCount: 5,
          stock: 10,
        ),
      );

      emit(
        state.copyWith(
          status: ProductStatus.loaded,
          products: [...state.products, ...newProducts],
          currentPage: nextPage,
          hasReachedMax: newProducts.length < 20,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(status: ProductStatus.error, errorMessage: e.toString()),
      );
    }
  }

  /// Search products
  Future<void> _onSearchRequested(
    ProductSearchRequested event,
    Emitter<ProductState> emit,
  ) async {
    emit(
      state.copyWith(status: ProductStatus.loading, searchQuery: event.query),
    );

    try {
      await Future.delayed(const Duration(milliseconds: 300));

      // TODO: Call search API
      final results = state.products
          .where(
            (p) => p.name.toLowerCase().contains(event.query.toLowerCase()),
          )
          .toList();

      emit(
        state.copyWith(
          status: ProductStatus.loaded,
          products: results,
          currentPage: 1,
          hasReachedMax: true,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(status: ProductStatus.error, errorMessage: e.toString()),
      );
    }
  }

  /// Update filters
  void _onFilterChanged(
    ProductFilterChanged event,
    Emitter<ProductState> emit,
  ) {
    emit(state.copyWith(filters: event.filters));
    add(const ProductsFetchRequested());
  }

  /// Update sort option
  void _onSortChanged(ProductSortChanged event, Emitter<ProductState> emit) {
    emit(state.copyWith(sortBy: event.sortBy));
    add(const ProductsFetchRequested());
  }

  /// Fetch product details
  Future<void> _onDetailFetchRequested(
    ProductDetailFetchRequested event,
    Emitter<ProductState> emit,
  ) async {
    emit(state.copyWith(detailStatus: ProductStatus.loading));

    try {
      await Future.delayed(const Duration(milliseconds: 300));

      // TODO: Call product detail API
      final product = ProductModel(
        id: event.productId,
        name: 'Product ${event.productId}',
        description: 'This is a detailed product description.',
        price: 1500.0,
        salePrice: 1200.0,
        rating: 4.8,
        reviewCount: 150,
        stock: 25,
        images: [
          const ProductImageModel(
            id: '1',
            url: 'https://placehold.co/500x500',
            isDefault: true,
          ),
        ],
      );

      emit(
        state.copyWith(
          detailStatus: ProductStatus.loaded,
          selectedProduct: product,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          detailStatus: ProductStatus.error,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  /// Change category filter
  void _onCategoryChanged(
    ProductsCategoryChanged event,
    Emitter<ProductState> emit,
  ) {
    emit(state.copyWith(selectedCategoryId: event.categoryId));
    add(const ProductsFetchRequested());
  }

  /// Refresh products
  Future<void> _onRefreshRequested(
    ProductsRefreshRequested event,
    Emitter<ProductState> emit,
  ) async {
    emit(state.copyWith(products: [], currentPage: 1, hasReachedMax: false));
    add(const ProductsFetchRequested());
  }
}
