import 'package:freezed_annotation/freezed_annotation.dart';

part 'wishlist_model.freezed.dart';
part 'wishlist_model.g.dart';

/// Wishlist Model - User's saved products
@freezed
class WishlistModel with _$WishlistModel {
  const factory WishlistModel({
    required String id,
    String? userId,
    @Default([]) List<WishlistItemModel> items,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _WishlistModel;

  const WishlistModel._();

  factory WishlistModel.fromJson(Map<String, dynamic> json) =>
      _$WishlistModelFromJson(json);

  /// Get total item count
  int get itemCount => items.length;

  /// Check if wishlist is empty
  bool get isEmpty => items.isEmpty;

  /// Check if product is in wishlist
  bool containsProduct(String productId) =>
      items.any((item) => item.productId == productId);

  /// Get product IDs
  List<String> get productIds => items.map((e) => e.productId).toList();
}

/// Wishlist Item Model
@freezed
class WishlistItemModel with _$WishlistItemModel {
  const factory WishlistItemModel({
    required String id,
    required String productId,
    String? productName,
    String? productImage,
    double? price,
    double? compareAtPrice,
    @Default(true) bool isAvailable,
    @Default(true) bool inStock,
    DateTime? addedAt,
  }) = _WishlistItemModel;

  const WishlistItemModel._();

  factory WishlistItemModel.fromJson(Map<String, dynamic> json) =>
      _$WishlistItemModelFromJson(json);

  /// Check if product is on sale
  bool get isOnSale =>
      price != null && compareAtPrice != null && compareAtPrice! > price!;

  /// Get discount percentage
  int get discountPercent {
    if (!isOnSale) return 0;
    return (((compareAtPrice! - price!) / compareAtPrice!) * 100).round();
  }
}
