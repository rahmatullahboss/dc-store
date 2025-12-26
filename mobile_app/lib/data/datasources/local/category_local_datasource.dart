/// Category Local Data Source - Hive caching for categories
library;
import '../../../core/cache/cache_service.dart';
import '../../models/category/category_model.dart';

abstract class ICategoryLocalDataSource {
  Future<List<CategoryModel>?> getCachedCategories();
  Future<CategoryModel?> getCachedCategory(String id);
  Future<List<CategoryModel>?> getCachedFeaturedCategories();
  Future<void> cacheCategories(List<CategoryModel> categories);
  Future<void> cacheCategory(CategoryModel category);
  Future<void> cacheFeaturedCategories(List<CategoryModel> categories);
  Future<void> clearCache();
}

class CategoryLocalDataSource implements ICategoryLocalDataSource {
  final CacheService _cacheService;

  CategoryLocalDataSource({required CacheService cacheService})
    : _cacheService = cacheService;

  @override
  Future<List<CategoryModel>?> getCachedCategories() async {
    return _cacheService.getList<CategoryModel>(
      key: CacheKeys.categories,
      boxName: CacheBoxes.categories,
      fromJson: CategoryModel.fromJson,
    );
  }

  @override
  Future<CategoryModel?> getCachedCategory(String id) async {
    final categories = await getCachedCategories();
    if (categories == null) return null;
    return categories.where((c) => c.id == id).firstOrNull;
  }

  @override
  Future<List<CategoryModel>?> getCachedFeaturedCategories() async {
    return _cacheService.getList<CategoryModel>(
      key: '${CacheKeys.categories}_featured',
      boxName: CacheBoxes.categories,
      fromJson: CategoryModel.fromJson,
    );
  }

  @override
  Future<void> cacheCategories(List<CategoryModel> categories) async {
    await _cacheService.setList<CategoryModel>(
      key: CacheKeys.categories,
      boxName: CacheBoxes.categories,
      data: categories,
      toJson: (c) => c.toJson(),
      ttl: CacheConfig.categoryTTL,
    );
  }

  @override
  Future<void> cacheCategory(CategoryModel category) async {
    // Individual category caching - update the list
    final existing = await getCachedCategories();
    if (existing != null) {
      final updated = existing
          .map((c) => c.id == category.id ? category : c)
          .toList();
      await cacheCategories(updated);
    }
  }

  @override
  Future<void> cacheFeaturedCategories(List<CategoryModel> categories) async {
    await _cacheService.setList<CategoryModel>(
      key: '${CacheKeys.categories}_featured',
      boxName: CacheBoxes.categories,
      data: categories,
      toJson: (c) => c.toJson(),
      ttl: CacheConfig.categoryTTL,
    );
  }

  @override
  Future<void> clearCache() async {
    await _cacheService.clearBox(CacheBoxes.categories);
  }
}
