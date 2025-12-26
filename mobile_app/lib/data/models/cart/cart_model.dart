import 'package:freezed_annotation/freezed_annotation.dart';
import '../product/product_model.dart';

part 'cart_model.freezed.dart';
part 'cart_model.g.dart';

/// Cart Model - Shopping cart with items and totals
@freezed
class CartModel with _$CartModel {
  const factory CartModel({
    String? id,
    @Default([]) List<CartItemModel> items,
    @Default(0.0) double subtotal,
    @Default(0.0) double discount,
    @Default(0.0) double shipping,
    @Default(0.0) double tax,
    @Default(0.0) double total,
    CouponModel? coupon,
    String? notes,
    DateTime? updatedAt,
  }) = _CartModel;

  const CartModel._();

  factory CartModel.fromJson(Map<String, dynamic> json) =>
      _$CartModelFromJson(json);

  /// Total item count
  int get itemCount => items.fold(0, (sum, item) => sum + item.quantity);

  /// Total unique products
  int get uniqueItemCount => items.length;

  /// Check if cart is empty
  bool get isEmpty => items.isEmpty;

  /// Check if cart is not empty
  bool get isNotEmpty => items.isNotEmpty;

  /// Check if coupon is applied
  bool get hasCoupon => coupon != null;

  /// Calculate savings
  double get savings => discount;
}

/// Cart Item Model
@freezed
class CartItemModel with _$CartItemModel {
  const factory CartItemModel({
    required String id,
    required String productId,
    required String productName,
    String? productImage,
    String? variantId,
    String? variantName,
    Map<String, String>?
    selectedAttributes, // e.g., {"color": "Red", "size": "XL"}
    required int quantity,
    required double price,
    double? compareAtPrice,
    @Default(0.0) double itemTotal,
    @Default(0) int maxQuantity, // Available stock
    DateTime? addedAt,
  }) = _CartItemModel;

  const CartItemModel._();

  factory CartItemModel.fromJson(Map<String, dynamic> json) =>
      _$CartItemModelFromJson(json);

  /// Calculate line total
  double get lineTotal => price * quantity;

  /// Check if has discount
  bool get hasDiscount => compareAtPrice != null && compareAtPrice! > price;

  /// Get discount per item
  double get discountPerItem => hasDiscount ? compareAtPrice! - price : 0;

  /// Get total discount
  double get totalDiscount => discountPerItem * quantity;
}

/// Coupon Model
@freezed
class CouponModel with _$CouponModel {
  const factory CouponModel({
    required String code,
    required String type, // percentage, fixed, freeShipping
    required double value,
    double? minOrderAmount,
    double? maxDiscount,
    String? description,
    DateTime? expiresAt,
    @Default(true) bool isValid,
  }) = _CouponModel;

  const CouponModel._();

  factory CouponModel.fromJson(Map<String, dynamic> json) =>
      _$CouponModelFromJson(json);

  /// Calculate discount for given subtotal
  double calculateDiscount(double subtotal) {
    if (!isValid) return 0;
    if (minOrderAmount != null && subtotal < minOrderAmount!) return 0;

    double discount;
    if (type == 'percentage') {
      discount = subtotal * (value / 100);
    } else if (type == 'fixed') {
      discount = value;
    } else {
      discount = 0;
    }

    if (maxDiscount != null && discount > maxDiscount!) {
      discount = maxDiscount!;
    }

    return discount;
  }

  /// Display value
  String get displayValue {
    if (type == 'percentage') return '${value.toInt()}%';
    if (type == 'freeShipping') return 'Free Shipping';
    return '৳${value.toStringAsFixed(0)}';
  }
}
