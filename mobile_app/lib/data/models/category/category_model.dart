import 'package:freezed_annotation/freezed_annotation.dart';

part 'category_model.freezed.dart';
part 'category_model.g.dart';

/// Category Model - Product category with hierarchy support
@freezed
class CategoryModel with _$CategoryModel {
  const factory CategoryModel({
    required String id,
    required String name,
    String? slug,
    String? description,
    String? image,
    String? icon,
    String? parentId,
    @Default([]) List<CategoryModel> children,
    @Default(0) int productCount,
    @Default(0) int sortOrder,
    @Default(true) bool isActive,
    @Default(false) bool isFeatured,
    String? color, // For UI display
    DateTime? createdAt,
  }) = _CategoryModel;

  const CategoryModel._();

  factory CategoryModel.fromJson(Map<String, dynamic> json) =>
      _$CategoryModelFromJson(json);

  /// Check if this is a root category
  bool get isRoot => parentId == null;

  /// Check if has children
  bool get hasChildren => children.isNotEmpty;

  /// Get depth level (0 for root)
  int get level {
    // This would need parent reference to calculate
    return parentId == null ? 0 : 1;
  }
}
