/// Cart Repository Interface - Domain Layer
/// Defines all shopping cart operations with optimistic updates

import '../../core/utils/either.dart';
import '../../data/models/cart/cart_model.dart';

abstract class ICartRepository {
  /// Get current cart
  Future<Result<CartModel>> getCart();

  /// Add item to cart
  Future<Result<CartModel>> addToCart({
    required String productId,
    required int quantity,
    String? variantId,
    Map<String, String>? attributes,
  });

  /// Update cart item quantity
  Future<Result<CartModel>> updateCartItem({
    required String cartItemId,
    required int quantity,
  });

  /// Remove item from cart
  Future<Result<CartModel>> removeFromCart(String cartItemId);

  /// Clear entire cart
  Future<Result<void>> clearCart();

  /// Apply coupon code
  Future<Result<CartModel>> applyCoupon(String couponCode);

  /// Remove applied coupon
  Future<Result<CartModel>> removeCoupon();

  /// Get cart item count
  Future<Result<int>> getCartItemCount();

  /// Validate cart before checkout
  Future<Result<CartValidationResult>> validateCart();

  /// Sync local cart with remote (after login)
  Future<Result<CartModel>> syncCart();

  /// Update shipping address for cart
  Future<Result<CartModel>> updateShippingAddress(String addressId);

  /// Get estimated shipping costs
  Future<Result<List<ShippingOption>>> getShippingOptions();

  /// Select shipping option
  Future<Result<CartModel>> selectShippingOption(String shippingOptionId);
}

/// Cart validation result
class CartValidationResult {
  final bool isValid;
  final List<CartValidationError> errors;
  final List<CartItemModel> unavailableItems;

  CartValidationResult({
    required this.isValid,
    this.errors = const [],
    this.unavailableItems = const [],
  });
}

/// Cart validation error
class CartValidationError {
  final String itemId;
  final String message;
  final CartValidationErrorType type;

  CartValidationError({
    required this.itemId,
    required this.message,
    required this.type,
  });
}

enum CartValidationErrorType {
  outOfStock,
  insufficientStock,
  priceChanged,
  itemUnavailable,
  minimumQuantity,
  maximumQuantity,
}

/// Shipping option
class ShippingOption {
  final String id;
  final String name;
  final String description;
  final double price;
  final String estimatedDelivery;
  final bool isFree;

  ShippingOption({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.estimatedDelivery,
    this.isFree = false,
  });
}
