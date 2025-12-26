/// Category Repository Implementation
library;

import '../../core/utils/either.dart';
import '../../core/errors/failures.dart';
import '../../core/errors/exceptions.dart';
import '../../core/network/network_info.dart';
import '../../domain/repositories/i_category_repository.dart';
import '../datasources/remote/category_remote_datasource.dart';
import '../datasources/local/category_local_datasource.dart';
import '../models/category/category_model.dart';

class CategoryRepository implements ICategoryRepository {
  final ICategoryRemoteDataSource _remoteDataSource;
  final ICategoryLocalDataSource _localDataSource;
  final NetworkInfo _networkInfo;

  CategoryRepository({
    required ICategoryRemoteDataSource remoteDataSource,
    required ICategoryLocalDataSource localDataSource,
    required NetworkInfo networkInfo,
  }) : _remoteDataSource = remoteDataSource,
       _localDataSource = localDataSource,
       _networkInfo = networkInfo;

  @override
  Future<Result<List<CategoryModel>>> getCategories() async {
    return tryCatch(() async {
      final cached = await _localDataSource.getCachedCategories();

      if (await _networkInfo.isConnected) {
        final categories = await _remoteDataSource.getCategories();
        await _localDataSource.cacheCategories(categories);
        return categories;
      } else if (cached != null) {
        return cached;
      } else {
        throw NetworkException.noConnection();
      }
    }, onError: _handleError);
  }

  @override
  Future<Result<CategoryModel>> getCategoryById(String id) async {
    return tryCatch(() async {
      final cached = await _localDataSource.getCachedCategory(id);

      if (await _networkInfo.isConnected) {
        final category = await _remoteDataSource.getCategoryById(id);
        await _localDataSource.cacheCategory(category);
        return category;
      } else if (cached != null) {
        return cached;
      } else {
        throw NetworkException.noConnection();
      }
    }, onError: _handleError);
  }

  @override
  Future<Result<List<CategoryModel>>> getSubcategories(String parentId) async {
    return tryCatch(() async {
      if (!await _networkInfo.isConnected) {
        // Try to get from cached categories
        final cached = await _localDataSource.getCachedCategories();
        if (cached != null) {
          return cached.where((c) => c.parentId == parentId).toList();
        }
        throw NetworkException.noConnection();
      }
      return _remoteDataSource.getSubcategories(parentId);
    }, onError: _handleError);
  }

  @override
  Future<Result<List<CategoryModel>>> getFeaturedCategories({
    int limit = 6,
  }) async {
    return tryCatch(() async {
      final cached = await _localDataSource.getCachedFeaturedCategories();

      if (await _networkInfo.isConnected) {
        final categories = await _remoteDataSource.getFeaturedCategories(limit);
        await _localDataSource.cacheFeaturedCategories(categories);
        return categories;
      } else if (cached != null) {
        return cached;
      } else {
        throw NetworkException.noConnection();
      }
    }, onError: _handleError);
  }

  @override
  Future<Result<List<CategoryModel>>> getCategoryTree() async {
    return tryCatch(() async {
      final categories = await getCategories();
      return categories.fold(
        ifLeft: (failure) => throw failure,
        ifRight: (cats) => _buildTree(cats),
      );
    }, onError: _handleError);
  }

  List<CategoryModel> _buildTree(List<CategoryModel> categories) {
    final rootCategories = categories.where((c) => c.isRoot).toList();

    List<CategoryModel> addChildren(CategoryModel parent) {
      final children = categories
          .where((c) => c.parentId == parent.id)
          .toList();
      if (children.isEmpty) return [parent];

      return [
        parent.copyWith(
          children: children.map((child) => addChildren(child).first).toList(),
        ),
      ];
    }

    return rootCategories.map((root) => addChildren(root).first).toList();
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
