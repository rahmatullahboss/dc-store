/// Cart Remote Data Source - API calls for shopping cart
library;
import '../../../core/network/dio_client.dart';
import '../../../core/constants/api_constants.dart';
import '../../../core/errors/exceptions.dart';
import '../../models/cart/cart_model.dart';

abstract class ICartRemoteDataSource {
  Future<CartModel> getCart();
  Future<CartModel> addToCart({
    required String productId,
    required int quantity,
    String? variantId,
    Map<String, String>? attributes,
  });
  Future<CartModel> updateCartItem(String cartItemId, int quantity);
  Future<CartModel> removeFromCart(String cartItemId);
  Future<void> clearCart();
  Future<CartModel> applyCoupon(String couponCode);
  Future<CartModel> removeCoupon();
  Future<CartModel> updateShippingAddress(String addressId);
}

class CartRemoteDataSource implements ICartRemoteDataSource {
  final DioClient _client;

  CartRemoteDataSource({required DioClient client}) : _client = client;

  @override
  Future<CartModel> getCart() async {
    final response = await _client.get<Map<String, dynamic>>(ApiConstants.cart);

    if (!response.isSuccess || response.data == null) {
      throw ServerException(
        message: response.message ?? 'Failed to fetch cart',
        statusCode: response.error?.statusCode,
      );
    }

    final data = response.data!;
    return CartModel.fromJson(data['cart'] as Map<String, dynamic>? ?? data);
  }

  @override
  Future<CartModel> addToCart({
    required String productId,
    required int quantity,
    String? variantId,
    Map<String, String>? attributes,
  }) async {
    final response = await _client.post<Map<String, dynamic>>(
      '${ApiConstants.cart}/items',
      data: {
        'productId': productId,
        'quantity': quantity,
        if (variantId != null) 'variantId': variantId,
        if (attributes != null) 'attributes': attributes,
      },
    );

    if (!response.isSuccess || response.data == null) {
      throw ServerException(
        message: response.message ?? 'Failed to add item to cart',
        statusCode: response.error?.statusCode,
      );
    }

    final data = response.data!;
    return CartModel.fromJson(data['cart'] as Map<String, dynamic>? ?? data);
  }

  @override
  Future<CartModel> updateCartItem(String cartItemId, int quantity) async {
    final response = await _client.patch<Map<String, dynamic>>(
      '${ApiConstants.cart}/items/$cartItemId',
      data: {'quantity': quantity},
    );

    if (!response.isSuccess || response.data == null) {
      throw ServerException(
        message: response.message ?? 'Failed to update cart item',
        statusCode: response.error?.statusCode,
      );
    }

    final data = response.data!;
    return CartModel.fromJson(data['cart'] as Map<String, dynamic>? ?? data);
  }

  @override
  Future<CartModel> removeFromCart(String cartItemId) async {
    final response = await _client.delete<Map<String, dynamic>>(
      '${ApiConstants.cart}/items/$cartItemId',
    );

    if (!response.isSuccess || response.data == null) {
      throw ServerException(
        message: response.message ?? 'Failed to remove item from cart',
        statusCode: response.error?.statusCode,
      );
    }

    final data = response.data!;
    return CartModel.fromJson(data['cart'] as Map<String, dynamic>? ?? data);
  }

  @override
  Future<void> clearCart() async {
    final response = await _client.delete<Map<String, dynamic>>(
      ApiConstants.cart,
    );

    if (!response.isSuccess) {
      throw ServerException(
        message: response.message ?? 'Failed to clear cart',
        statusCode: response.error?.statusCode,
      );
    }
  }

  @override
  Future<CartModel> applyCoupon(String couponCode) async {
    final response = await _client.post<Map<String, dynamic>>(
      '${ApiConstants.cart}/coupon',
      data: {'code': couponCode},
    );

    if (!response.isSuccess || response.data == null) {
      throw ServerException(
        message: response.message ?? 'Invalid coupon code',
        statusCode: response.error?.statusCode,
      );
    }

    final data = response.data!;
    return CartModel.fromJson(data['cart'] as Map<String, dynamic>? ?? data);
  }

  @override
  Future<CartModel> removeCoupon() async {
    final response = await _client.delete<Map<String, dynamic>>(
      '${ApiConstants.cart}/coupon',
    );

    if (!response.isSuccess || response.data == null) {
      throw ServerException(
        message: response.message ?? 'Failed to remove coupon',
        statusCode: response.error?.statusCode,
      );
    }

    final data = response.data!;
    return CartModel.fromJson(data['cart'] as Map<String, dynamic>? ?? data);
  }

  @override
  Future<CartModel> updateShippingAddress(String addressId) async {
    final response = await _client.patch<Map<String, dynamic>>(
      '${ApiConstants.cart}/shipping',
      data: {'addressId': addressId},
    );

    if (!response.isSuccess || response.data == null) {
      throw ServerException(
        message: response.message ?? 'Failed to update shipping address',
        statusCode: response.error?.statusCode,
      );
    }

    final data = response.data!;
    return CartModel.fromJson(data['cart'] as Map<String, dynamic>? ?? data);
  }
}
