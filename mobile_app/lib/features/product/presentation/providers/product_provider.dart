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

/// Current search query - used for debounced search
final searchQueryProvider = StateProvider<String>((ref) => '');

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
