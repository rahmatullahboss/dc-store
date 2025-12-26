/// Product Repository Interface - Domain Layer
/// Defines all product-related operations

import '../../core/utils/either.dart';
import '../../data/models/product/product_model.dart';
import '../../data/models/common/pagination.dart';

abstract class IProductRepository {
  /// Get products with filters and pagination
  Future<Result<PaginatedResponse<ProductModel>>> getProducts({
    ProductFilters? filters,
  });

  /// Get single product by ID
  Future<Result<ProductModel>> getProductById(String id);

  /// Search products by query
  Future<Result<PaginatedResponse<ProductModel>>> searchProducts({
    required String query,
    int page = 1,
    int perPage = 20,
  });

  /// Get products by category
  Future<Result<PaginatedResponse<ProductModel>>> getProductsByCategory({
    required String categoryId,
    int page = 1,
    int perPage = 20,
    SortOption sortBy = SortOption.newest,
  });

  /// Get related products for a product
  Future<Result<List<ProductModel>>> getRelatedProducts({
    required String productId,
    int limit = 10,
  });

  /// Get featured products
  Future<Result<List<ProductModel>>> getFeaturedProducts({int limit = 10});

  /// Get new arrival products
  Future<Result<List<ProductModel>>> getNewArrivals({int limit = 10});

  /// Get best selling products
  Future<Result<List<ProductModel>>> getBestSellers({int limit = 10});

  /// Get products on sale
  Future<Result<List<ProductModel>>> getOnSaleProducts({int limit = 10});

  /// Get product stock status
  Future<Result<int>> getStockStatus(String productId);

  /// Refresh product cache
  Future<void> refreshCache();

  /// Clear product cache
  Future<void> clearCache();
}
