/// Category Remote Data Source - API calls for categories
library;
import '../../../core/network/dio_client.dart';
import '../../../core/constants/api_constants.dart';
import '../../../core/errors/exceptions.dart';
import '../../models/category/category_model.dart';

abstract class ICategoryRemoteDataSource {
  Future<List<CategoryModel>> getCategories();
  Future<CategoryModel> getCategoryById(String id);
  Future<List<CategoryModel>> getSubcategories(String parentId);
  Future<List<CategoryModel>> getFeaturedCategories(int limit);
}

class CategoryRemoteDataSource implements ICategoryRemoteDataSource {
  final DioClient _client;

  CategoryRemoteDataSource({required DioClient client}) : _client = client;

  @override
  Future<List<CategoryModel>> getCategories() async {
    final response = await _client.get<Map<String, dynamic>>(
      ApiConstants.categories,
    );

    if (!response.isSuccess || response.data == null) {
      throw ServerException(
        message: response.message ?? 'Failed to fetch categories',
        statusCode: response.error?.statusCode,
      );
    }

    final data = response.data!;
    return (data['categories'] as List? ?? data['data'] as List? ?? [])
        .map((item) => CategoryModel.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<CategoryModel> getCategoryById(String id) async {
    final response = await _client.get<Map<String, dynamic>>(
      '${ApiConstants.categories}/$id',
    );

    if (!response.isSuccess || response.data == null) {
      throw ServerException(
        message: response.message ?? 'Category not found',
        statusCode: response.error?.statusCode,
      );
    }

    final data = response.data!;
    return CategoryModel.fromJson(
      data['category'] as Map<String, dynamic>? ?? data,
    );
  }

  @override
  Future<List<CategoryModel>> getSubcategories(String parentId) async {
    final response = await _client.get<Map<String, dynamic>>(
      '${ApiConstants.categories}/$parentId/children',
    );

    if (!response.isSuccess || response.data == null) {
      return [];
    }

    final data = response.data!;
    return (data['categories'] as List? ?? data['data'] as List? ?? [])
        .map((item) => CategoryModel.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<List<CategoryModel>> getFeaturedCategories(int limit) async {
    final response = await _client.get<Map<String, dynamic>>(
      ApiConstants.categories,
      queryParameters: {'featured': true, 'limit': limit},
    );

    if (!response.isSuccess || response.data == null) {
      throw ServerException(
        message: response.message ?? 'Failed to fetch featured categories',
        statusCode: response.error?.statusCode,
      );
    }

    final data = response.data!;
    return (data['categories'] as List? ?? data['data'] as List? ?? [])
        .map((item) => CategoryModel.fromJson(item as Map<String, dynamic>))
        .toList();
  }
}
