/// Product Remote Data Source - API calls for products
import '../../../core/network/dio_client.dart';
import '../../../core/constants/api_constants.dart';
import '../../../core/errors/exceptions.dart';
import '../../models/product/product_model.dart';
import '../../models/common/pagination.dart';

abstract class IProductRemoteDataSource {
  Future<(List<ProductModel>, PaginationModel)> getProducts(
    Map<String, dynamic> queryParams,
  );
  Future<ProductModel> getProductById(String id);
  Future<(List<ProductModel>, PaginationModel)> searchProducts(
    String query,
    int page,
    int perPage,
  );
  Future<List<ProductModel>> getFeaturedProducts(int limit);
  Future<List<ProductModel>> getNewArrivals(int limit);
  Future<List<ProductModel>> getBestSellers(int limit);
  Future<List<ProductModel>> getRelatedProducts(String productId, int limit);
  Future<int> getStockStatus(String productId);
}

class ProductRemoteDataSource implements IProductRemoteDataSource {
  final DioClient _client;

  ProductRemoteDataSource({required DioClient client}) : _client = client;

  @override
  Future<(List<ProductModel>, PaginationModel)> getProducts(
    Map<String, dynamic> queryParams,
  ) async {
    final response = await _client.get<Map<String, dynamic>>(
      ApiConstants.products,
      queryParameters: queryParams,
    );

    if (!response.isSuccess || response.data == null) {
      throw ServerException(
        message: response.message ?? 'Failed to fetch products',
        statusCode: response.error?.statusCode,
      );
    }

    final data = response.data!;
    final items = (data['products'] as List? ?? data['data'] as List? ?? [])
        .map((item) => ProductModel.fromJson(item as Map<String, dynamic>))
        .toList();

    final pagination = data['pagination'] != null
        ? PaginationModel.fromJson(data['pagination'] as Map<String, dynamic>)
        : PaginationModel(
            currentPage: queryParams['page'] as int? ?? 1,
            totalItems: items.length,
          );

    return (items, pagination);
  }

  @override
  Future<ProductModel> getProductById(String id) async {
    final response = await _client.get<Map<String, dynamic>>(
      '${ApiConstants.products}/$id',
    );

    if (!response.isSuccess || response.data == null) {
      throw ServerException(
        message: response.message ?? 'Product not found',
        statusCode: response.error?.statusCode,
      );
    }

    final data = response.data!;
    return ProductModel.fromJson(
      data['product'] as Map<String, dynamic>? ?? data,
    );
  }

  @override
  Future<(List<ProductModel>, PaginationModel)> searchProducts(
    String query,
    int page,
    int perPage,
  ) async {
    final response = await _client.get<Map<String, dynamic>>(
      ApiConstants.products,
      queryParameters: {'q': query, 'page': page, 'perPage': perPage},
    );

    if (!response.isSuccess || response.data == null) {
      throw ServerException(
        message: response.message ?? 'Search failed',
        statusCode: response.error?.statusCode,
      );
    }

    final data = response.data!;
    final items = (data['products'] as List? ?? data['data'] as List? ?? [])
        .map((item) => ProductModel.fromJson(item as Map<String, dynamic>))
        .toList();

    final pagination = data['pagination'] != null
        ? PaginationModel.fromJson(data['pagination'] as Map<String, dynamic>)
        : PaginationModel(currentPage: page, totalItems: items.length);

    return (items, pagination);
  }

  @override
  Future<List<ProductModel>> getFeaturedProducts(int limit) async {
    final response = await _client.get<Map<String, dynamic>>(
      ApiConstants.products,
      queryParameters: {'featured': true, 'limit': limit},
    );

    if (!response.isSuccess || response.data == null) {
      throw ServerException(
        message: response.message ?? 'Failed to fetch featured products',
        statusCode: response.error?.statusCode,
      );
    }

    final data = response.data!;
    return (data['products'] as List? ?? data['data'] as List? ?? [])
        .map((item) => ProductModel.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<List<ProductModel>> getNewArrivals(int limit) async {
    final response = await _client.get<Map<String, dynamic>>(
      ApiConstants.products,
      queryParameters: {'sortBy': 'newest', 'limit': limit},
    );

    if (!response.isSuccess || response.data == null) {
      throw ServerException(
        message: response.message ?? 'Failed to fetch new arrivals',
        statusCode: response.error?.statusCode,
      );
    }

    final data = response.data!;
    return (data['products'] as List? ?? data['data'] as List? ?? [])
        .map((item) => ProductModel.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<List<ProductModel>> getBestSellers(int limit) async {
    final response = await _client.get<Map<String, dynamic>>(
      ApiConstants.products,
      queryParameters: {'sortBy': 'popular', 'limit': limit},
    );

    if (!response.isSuccess || response.data == null) {
      throw ServerException(
        message: response.message ?? 'Failed to fetch best sellers',
        statusCode: response.error?.statusCode,
      );
    }

    final data = response.data!;
    return (data['products'] as List? ?? data['data'] as List? ?? [])
        .map((item) => ProductModel.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<List<ProductModel>> getRelatedProducts(
    String productId,
    int limit,
  ) async {
    final response = await _client.get<Map<String, dynamic>>(
      '${ApiConstants.products}/$productId/related',
      queryParameters: {'limit': limit},
    );

    if (!response.isSuccess || response.data == null) {
      // For related products, return empty list on failure
      return [];
    }

    final data = response.data!;
    return (data['products'] as List? ?? data['data'] as List? ?? [])
        .map((item) => ProductModel.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<int> getStockStatus(String productId) async {
    final product = await getProductById(productId);
    return product.stock;
  }
}
