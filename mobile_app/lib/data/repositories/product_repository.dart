/// Product Repository Implementation
/// Cache-first strategy with offline support

import '../../core/utils/either.dart';
import '../../core/errors/failures.dart';
import '../../core/errors/exceptions.dart';
import '../../core/network/network_info.dart';
import '../../domain/repositories/i_product_repository.dart';
import '../datasources/remote/product_remote_datasource.dart';
import '../datasources/local/product_local_datasource.dart';
import '../models/product/product_model.dart';
import '../models/common/pagination.dart';

class ProductRepository implements IProductRepository {
  final IProductRemoteDataSource _remoteDataSource;
  final IProductLocalDataSource _localDataSource;
  final NetworkInfo _networkInfo;

  ProductRepository({
    required IProductRemoteDataSource remoteDataSource,
    required IProductLocalDataSource localDataSource,
    required NetworkInfo networkInfo,
  }) : _remoteDataSource = remoteDataSource,
       _localDataSource = localDataSource,
       _networkInfo = networkInfo;

  @override
  Future<Result<PaginatedResponse<ProductModel>>> getProducts({
    ProductFilters? filters,
  }) async {
    final cacheKey = filters?.toCacheKey() ?? 'all';

    return tryCatch(() async {
      // Check cache first
      final cached = await _localDataSource.getCachedProducts(cacheKey);

      if (await _networkInfo.isConnected) {
        // Online: fetch from API and cache
        final queryParams =
            filters?.toQueryParams() ?? {'page': 1, 'perPage': 20};
        final (products, pagination) = await _remoteDataSource.getProducts(
          queryParams,
        );

        // Cache the products
        await _localDataSource.cacheProducts(cacheKey, products);

        return PaginatedResponse(items: products, pagination: pagination);
      } else if (cached != null) {
        // Offline: return cached data
        return PaginatedResponse(
          items: cached,
          pagination: PaginationModel(totalItems: cached.length),
        );
      } else {
        throw NetworkException.noConnection();
      }
    }, onError: _handleError);
  }

  @override
  Future<Result<ProductModel>> getProductById(String id) async {
    return tryCatch(() async {
      // Check cache first
      final cached = await _localDataSource.getCachedProduct(id);

      if (await _networkInfo.isConnected) {
        // Online: fetch from API
        final product = await _remoteDataSource.getProductById(id);
        await _localDataSource.cacheProduct(product);
        return product;
      } else if (cached != null) {
        // Offline: return cached
        return cached;
      } else {
        throw NetworkException.noConnection();
      }
    }, onError: _handleError);
  }

  @override
  Future<Result<PaginatedResponse<ProductModel>>> searchProducts({
    required String query,
    int page = 1,
    int perPage = 20,
  }) async {
    return tryCatch(() async {
      if (!await _networkInfo.isConnected) {
        throw NetworkException.noConnection();
      }

      final (products, pagination) = await _remoteDataSource.searchProducts(
        query,
        page,
        perPage,
      );

      return PaginatedResponse(items: products, pagination: pagination);
    }, onError: _handleError);
  }

  @override
  Future<Result<PaginatedResponse<ProductModel>>> getProductsByCategory({
    required String categoryId,
    int page = 1,
    int perPage = 20,
    SortOption sortBy = SortOption.newest,
  }) async {
    final cacheKey = 'cat_${categoryId}_${sortBy.value}_p$page';

    return tryCatch(() async {
      final cached = await _localDataSource.getCachedProducts(cacheKey);

      if (await _networkInfo.isConnected) {
        final (products, pagination) = await _remoteDataSource.getProducts({
          'categoryId': categoryId,
          'page': page,
          'perPage': perPage,
          'sortBy': sortBy.value,
        });

        await _localDataSource.cacheProducts(cacheKey, products);
        return PaginatedResponse(items: products, pagination: pagination);
      } else if (cached != null) {
        return PaginatedResponse(
          items: cached,
          pagination: PaginationModel(totalItems: cached.length),
        );
      } else {
        throw NetworkException.noConnection();
      }
    }, onError: _handleError);
  }

  @override
  Future<Result<List<ProductModel>>> getRelatedProducts({
    required String productId,
    int limit = 10,
  }) async {
    return tryCatch(() async {
      if (!await _networkInfo.isConnected) {
        return <ProductModel>[];
      }
      return _remoteDataSource.getRelatedProducts(productId, limit);
    }, onError: _handleError);
  }

  @override
  Future<Result<List<ProductModel>>> getFeaturedProducts({
    int limit = 10,
  }) async {
    const cacheKey = 'featured';

    return tryCatch(() async {
      final cached = await _localDataSource.getCachedProducts(cacheKey);

      if (await _networkInfo.isConnected) {
        final products = await _remoteDataSource.getFeaturedProducts(limit);
        await _localDataSource.cacheProducts(cacheKey, products);
        return products;
      } else if (cached != null) {
        return cached;
      } else {
        throw NetworkException.noConnection();
      }
    }, onError: _handleError);
  }

  @override
  Future<Result<List<ProductModel>>> getNewArrivals({int limit = 10}) async {
    const cacheKey = 'new_arrivals';

    return tryCatch(() async {
      final cached = await _localDataSource.getCachedProducts(cacheKey);

      if (await _networkInfo.isConnected) {
        final products = await _remoteDataSource.getNewArrivals(limit);
        await _localDataSource.cacheProducts(cacheKey, products);
        return products;
      } else if (cached != null) {
        return cached;
      } else {
        throw NetworkException.noConnection();
      }
    }, onError: _handleError);
  }

  @override
  Future<Result<List<ProductModel>>> getBestSellers({int limit = 10}) async {
    const cacheKey = 'best_sellers';

    return tryCatch(() async {
      final cached = await _localDataSource.getCachedProducts(cacheKey);

      if (await _networkInfo.isConnected) {
        final products = await _remoteDataSource.getBestSellers(limit);
        await _localDataSource.cacheProducts(cacheKey, products);
        return products;
      } else if (cached != null) {
        return cached;
      } else {
        throw NetworkException.noConnection();
      }
    }, onError: _handleError);
  }

  @override
  Future<Result<List<ProductModel>>> getOnSaleProducts({int limit = 10}) async {
    return tryCatch(() async {
      if (!await _networkInfo.isConnected) {
        throw NetworkException.noConnection();
      }

      final (products, _) = await _remoteDataSource.getProducts({
        'onSale': true,
        'limit': limit,
      });
      return products;
    }, onError: _handleError);
  }

  @override
  Future<Result<int>> getStockStatus(String productId) async {
    return tryCatch(() async {
      if (!await _networkInfo.isConnected) {
        final cached = await _localDataSource.getCachedProduct(productId);
        return cached?.stock ?? 0;
      }
      return _remoteDataSource.getStockStatus(productId);
    }, onError: _handleError);
  }

  @override
  Future<void> refreshCache() async {
    await _localDataSource.clearCache();
  }

  @override
  Future<void> clearCache() async {
    await _localDataSource.clearCache();
  }

  Failure _handleError(Object error, StackTrace stack) {
    if (error is NetworkException) {
      return NetworkFailure(error.message);
    } else if (error is ServerException) {
      return ServerFailure(error.message);
    } else if (error is CacheException) {
      return CacheFailure(error.message);
    }
    return ServerFailure(error.toString());
  }
}
