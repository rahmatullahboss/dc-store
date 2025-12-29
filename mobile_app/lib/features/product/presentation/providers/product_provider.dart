import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/product_repository.dart';
import '../../domain/product_model.dart';

final productRepositoryProvider = Provider((ref) => ProductRepository());

final productsProvider = FutureProvider<List<Product>>((ref) async {
  final repository = ref.watch(productRepositoryProvider);
  return repository.getProducts();
});

final productDetailsProvider = FutureProvider.family<Product?, String>((
  ref,
  id,
) async {
  final repository = ref.watch(productRepositoryProvider);
  return repository.getProductById(id);
});

/// Search query - managed via a simple Notifier
class SearchQueryNotifier extends Notifier<String> {
  @override
  String build() => '';

  void setQuery(String query) => state = query;
}

/// Provider for search query
final searchQueryProvider = NotifierProvider<SearchQueryNotifier, String>(
  SearchQueryNotifier.new,
);

/// Search results provider - watches query and fetches results
final searchResultsProvider = FutureProvider<List<Product>>((ref) async {
  final query = ref.watch(searchQueryProvider);
  if (query.trim().isEmpty) {
    return [];
  }

  final repository = ref.watch(productRepositoryProvider);
  return repository.searchProducts(query);
});

/// Loading state for search
final isSearchingProvider = Provider<bool>((ref) {
  return ref.watch(searchResultsProvider).isLoading;
});

final productsByCategoryProvider = FutureProvider.family<List<Product>, String>(
  (ref, categoryId) async {
    final repository = ref.watch(productRepositoryProvider);
    return repository.getProductsByCategory(categoryId);
  },
);

/// Related products provider - fetches products from same category, excluding current product
final relatedProductsProvider =
    FutureProvider.family<
      List<Product>,
      ({String productId, String? categoryId})
    >((ref, params) async {
      if (params.categoryId == null) return [];

      final repository = ref.watch(productRepositoryProvider);
      final products = await repository.getProductsByCategory(
        params.categoryId!,
      );

      // Filter out the current product and limit to 6
      return products.where((p) => p.id != params.productId).take(6).toList();
    });
