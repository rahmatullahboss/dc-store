/// Cart Repository Implementation
/// Optimistic updates with offline support

import '../../core/utils/either.dart';
import '../../core/errors/failures.dart';
import '../../core/errors/exceptions.dart';
import '../../core/network/network_info.dart';
import '../../domain/repositories/i_cart_repository.dart';
import '../datasources/remote/cart_remote_datasource.dart';
import '../datasources/local/cart_local_datasource.dart';
import '../models/cart/cart_model.dart';

class CartRepository implements ICartRepository {
  final ICartRemoteDataSource _remoteDataSource;
  final ICartLocalDataSource _localDataSource;
  final NetworkInfo _networkInfo;

  CartRepository({
    required ICartRemoteDataSource remoteDataSource,
    required ICartLocalDataSource localDataSource,
    required NetworkInfo networkInfo,
  }) : _remoteDataSource = remoteDataSource,
       _localDataSource = localDataSource,
       _networkInfo = networkInfo;

  @override
  Future<Result<CartModel>> getCart() async {
    return tryCatch(() async {
      // Always try remote first for cart (needs to be fresh)
      if (await _networkInfo.isConnected) {
        final cart = await _remoteDataSource.getCart();
        await _localDataSource.cacheCart(cart);
        return cart;
      }

      // Offline: return cached
      final cached = await _localDataSource.getCachedCart();
      if (cached != null) return cached;

      // No cached cart, return empty
      return const CartModel(id: 'local');
    }, onError: _handleError);
  }

  @override
  Future<Result<CartModel>> addToCart({
    required String productId,
    required int quantity,
    String? variantId,
    Map<String, String>? attributes,
  }) async {
    return tryCatch(() async {
      if (!await _networkInfo.isConnected) {
        // Optimistic update for offline
        final cached = await _localDataSource.getCachedCart();
        if (cached != null) {
          // Add item locally (simplified)
          final newItem = CartItemModel(
            id: 'local_${DateTime.now().millisecondsSinceEpoch}',
            productId: productId,
            productName: 'Product',
            productImage: '',
            price: 0,
            quantity: quantity,
            variantId: variantId,
            selectedAttributes: attributes ?? {},
          );
          final updatedCart = cached.copyWith(
            items: [...cached.items, newItem],
          );
          await _localDataSource.cacheCart(updatedCart);
          return updatedCart;
        }
        throw NetworkException.noConnection();
      }

      final cart = await _remoteDataSource.addToCart(
        productId: productId,
        quantity: quantity,
        variantId: variantId,
        attributes: attributes,
      );
      await _localDataSource.cacheCart(cart);
      return cart;
    }, onError: _handleError);
  }

  @override
  Future<Result<CartModel>> updateCartItem({
    required String cartItemId,
    required int quantity,
  }) async {
    return tryCatch(() async {
      // Optimistic update
      final cached = await _localDataSource.getCachedCart();
      if (cached != null) {
        final updatedItems = cached.items.map((item) {
          if (item.id == cartItemId) {
            return item.copyWith(quantity: quantity);
          }
          return item;
        }).toList();
        final optimisticCart = cached.copyWith(items: updatedItems);
        await _localDataSource.cacheCart(optimisticCart);
      }

      if (!await _networkInfo.isConnected) {
        return cached ?? const CartModel(id: 'local');
      }

      final cart = await _remoteDataSource.updateCartItem(cartItemId, quantity);
      await _localDataSource.cacheCart(cart);
      return cart;
    }, onError: _handleError);
  }

  @override
  Future<Result<CartModel>> removeFromCart(String cartItemId) async {
    return tryCatch(() async {
      // Optimistic update
      final cached = await _localDataSource.getCachedCart();
      if (cached != null) {
        final updatedItems = cached.items
            .where((item) => item.id != cartItemId)
            .toList();
        final optimisticCart = cached.copyWith(items: updatedItems);
        await _localDataSource.cacheCart(optimisticCart);
      }

      if (!await _networkInfo.isConnected) {
        return cached ?? const CartModel(id: 'local');
      }

      final cart = await _remoteDataSource.removeFromCart(cartItemId);
      await _localDataSource.cacheCart(cart);
      return cart;
    }, onError: _handleError);
  }

  @override
  Future<Result<void>> clearCart() async {
    return tryCatch(() async {
      await _localDataSource.clearCache();

      if (await _networkInfo.isConnected) {
        await _remoteDataSource.clearCart();
      }
    }, onError: _handleError);
  }

  @override
  Future<Result<CartModel>> applyCoupon(String couponCode) async {
    return tryCatch(() async {
      if (!await _networkInfo.isConnected) {
        throw NetworkException.noConnection();
      }

      final cart = await _remoteDataSource.applyCoupon(couponCode);
      await _localDataSource.cacheCart(cart);
      return cart;
    }, onError: _handleError);
  }

  @override
  Future<Result<CartModel>> removeCoupon() async {
    return tryCatch(() async {
      if (!await _networkInfo.isConnected) {
        throw NetworkException.noConnection();
      }

      final cart = await _remoteDataSource.removeCoupon();
      await _localDataSource.cacheCart(cart);
      return cart;
    }, onError: _handleError);
  }

  @override
  Future<Result<int>> getCartItemCount() async {
    return tryCatch(() async {
      final cartResult = await getCart();
      return cartResult.fold(
        ifLeft: (_) => 0,
        ifRight: (cart) => cart.itemCount,
      );
    }, onError: _handleError);
  }

  @override
  Future<Result<CartValidationResult>> validateCart() async {
    return tryCatch(() async {
      if (!await _networkInfo.isConnected) {
        throw NetworkException.noConnection();
      }

      // Get fresh cart and validate each item
      final cart = await _remoteDataSource.getCart();
      final errors = <CartValidationError>[];
      final unavailableItems = <CartItemModel>[];

      for (final item in cart.items) {
        // Check if item quantity exceeds available stock
        if (item.maxQuantity > 0 && item.quantity > item.maxQuantity) {
          errors.add(
            CartValidationError(
              itemId: item.id,
              message:
                  'Only ${item.maxQuantity} available for ${item.productName}',
              type: CartValidationErrorType.insufficientStock,
            ),
          );
        } else if (item.maxQuantity == 0) {
          unavailableItems.add(item);
          errors.add(
            CartValidationError(
              itemId: item.id,
              message: '${item.productName} is out of stock',
              type: CartValidationErrorType.outOfStock,
            ),
          );
        }
      }

      return CartValidationResult(
        isValid: errors.isEmpty,
        errors: errors,
        unavailableItems: unavailableItems,
      );
    }, onError: _handleError);
  }

  @override
  Future<Result<CartModel>> syncCart() async {
    return tryCatch(() async {
      if (!await _networkInfo.isConnected) {
        throw NetworkException.noConnection();
      }

      final cart = await _remoteDataSource.getCart();
      await _localDataSource.cacheCart(cart);
      return cart;
    }, onError: _handleError);
  }

  @override
  Future<Result<CartModel>> updateShippingAddress(String addressId) async {
    return tryCatch(() async {
      if (!await _networkInfo.isConnected) {
        throw NetworkException.noConnection();
      }

      final cart = await _remoteDataSource.updateShippingAddress(addressId);
      await _localDataSource.cacheCart(cart);
      return cart;
    }, onError: _handleError);
  }

  @override
  Future<Result<List<ShippingOption>>> getShippingOptions() async {
    return tryCatch(() async {
      if (!await _networkInfo.isConnected) {
        throw NetworkException.noConnection();
      }

      // This would need a separate API call
      return <ShippingOption>[
        ShippingOption(
          id: 'standard',
          name: 'Standard Delivery',
          description: '3-5 business days',
          price: 60.0,
          estimatedDelivery: '3-5 days',
        ),
        ShippingOption(
          id: 'express',
          name: 'Express Delivery',
          description: '1-2 business days',
          price: 120.0,
          estimatedDelivery: '1-2 days',
        ),
      ];
    }, onError: _handleError);
  }

  @override
  Future<Result<CartModel>> selectShippingOption(
    String shippingOptionId,
  ) async {
    return tryCatch(() async {
      // Shipping option selection would be handled by the API
      // For now, return the current cart
      if (!await _networkInfo.isConnected) {
        throw NetworkException.noConnection();
      }
      return _remoteDataSource.getCart();
    }, onError: _handleError);
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
