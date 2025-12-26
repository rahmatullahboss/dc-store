/// Category Repository Interface - Domain Layer
/// Defines all category-related operations

import '../../core/utils/either.dart';
import '../../data/models/category/category_model.dart';

abstract class ICategoryRepository {
  /// Get all categories
  Future<Result<List<CategoryModel>>> getCategories();

  /// Get category by ID
  Future<Result<CategoryModel>> getCategoryById(String id);

  /// Get subcategories of a category
  Future<Result<List<CategoryModel>>> getSubcategories(String parentId);

  /// Get featured categories
  Future<Result<List<CategoryModel>>> getFeaturedCategories({int limit = 6});

  /// Get category tree (hierarchical)
  Future<Result<List<CategoryModel>>> getCategoryTree();

  /// Refresh category cache
  Future<void> refreshCache();

  /// Clear category cache
  Future<void> clearCache();
}
