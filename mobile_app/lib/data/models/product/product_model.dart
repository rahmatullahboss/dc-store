import 'package:freezed_annotation/freezed_annotation.dart';

part 'product_model.freezed.dart';
part 'product_model.g.dart';

/// Product Model - Complete product representation
@freezed
class ProductModel with _$ProductModel {
  const factory ProductModel({
    required String id,
    required String name,
    String? slug,
    String? description,
    String? shortDescription,
    required double price,
    double? compareAtPrice,
    double? salePrice,
    int? discountPercent,
    @Default(0) int stock,
    String? sku,
    String? barcode,
    @Default([]) List<ProductImageModel> images,
    String? featuredImage,
    String? categoryId,
    String? categoryName,
    String? brandId,
    String? brandName,
    @Default([]) List<ProductVariantModel> variants,
    @Default([]) List<ProductAttributeModel> attributes,
    @Default([]) List<ProductSpecificationModel> specifications,
    @Default([]) List<String> tags,
    @Default(0.0) double rating,
    @Default(0) int reviewCount,
    @Default(true) bool isActive,
    @Default(false) bool isFeatured,
    @Default(0) int soldCount,
    String? weight,
    String? dimensions,
    Map<String, dynamic>? meta,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _ProductModel;

  const ProductModel._();

  factory ProductModel.fromJson(Map<String, dynamic> json) =>
      _$ProductModelFromJson(json);

  /// Check if product is on sale
  bool get isOnSale =>
      (salePrice != null && salePrice! < price) ||
      (compareAtPrice != null && compareAtPrice! > price);

  /// Get effective price
  double get effectivePrice => salePrice ?? price;

  /// Get discount amount
  double get discountAmount =>
      compareAtPrice != null ? compareAtPrice! - price : 0;

  /// Check if in stock
  bool get inStock => stock > 0;

  /// Check if low stock (less than 5)
  bool get isLowStock => stock > 0 && stock < 5;
}

/// Product Image Model
@freezed
class ProductImageModel with _$ProductImageModel {
  const factory ProductImageModel({
    required String id,
    required String url,
    String? thumbnail,
    String? alt,
    @Default(false) bool isDefault,
    @Default(0) int sortOrder,
  }) = _ProductImageModel;

  factory ProductImageModel.fromJson(Map<String, dynamic> json) =>
      _$ProductImageModelFromJson(json);
}

/// Product Variant Model
@freezed
class ProductVariantModel with _$ProductVariantModel {
  const factory ProductVariantModel({
    required String id,
    required String name,
    required double price,
    double? compareAtPrice,
    required int stock,
    String? sku,
    String? image,
    @Default({})
    Map<String, String> attributes, // e.g., {"color": "Red", "size": "XL"}
    @Default(true) bool isActive,
  }) = _ProductVariantModel;

  factory ProductVariantModel.fromJson(Map<String, dynamic> json) =>
      _$ProductVariantModelFromJson(json);
}

/// Product Attribute Model (e.g., Color, Size options)
@freezed
class ProductAttributeModel with _$ProductAttributeModel {
  const factory ProductAttributeModel({
    required String name,
    required List<String> values,
    String? displayType, // dropdown, swatch, button
  }) = _ProductAttributeModel;

  factory ProductAttributeModel.fromJson(Map<String, dynamic> json) =>
      _$ProductAttributeModelFromJson(json);
}

/// Product Specification Model
@freezed
class ProductSpecificationModel with _$ProductSpecificationModel {
  const factory ProductSpecificationModel({
    required String name,
    required String value,
    String? group, // e.g., "General", "Display", "Battery"
  }) = _ProductSpecificationModel;

  factory ProductSpecificationModel.fromJson(Map<String, dynamic> json) =>
      _$ProductSpecificationModelFromJson(json);
}
