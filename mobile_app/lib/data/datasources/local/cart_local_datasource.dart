/// Cart Local Data Source - Hive caching for cart (offline support)
import '../../../core/cache/cache_service.dart';
import '../../models/cart/cart_model.dart';

abstract class ICartLocalDataSource {
  Future<CartModel?> getCachedCart();
  Future<void> cacheCart(CartModel cart);
  Future<void> clearCache();
}

class CartLocalDataSource implements ICartLocalDataSource {
  final CacheService _cacheService;

  CartLocalDataSource({required CacheService cacheService})
    : _cacheService = cacheService;

  @override
  Future<CartModel?> getCachedCart() async {
    return _cacheService.get<CartModel>(
      key: CacheKeys.cart,
      boxName: CacheBoxes.cart,
      fromJson: CartModel.fromJson,
    );
  }

  @override
  Future<void> cacheCart(CartModel cart) async {
    await _cacheService.set<CartModel>(
      key: CacheKeys.cart,
      boxName: CacheBoxes.cart,
      data: cart,
      toJson: (c) => c.toJson(),
      ttl: CacheConfig.cartTTL,
    );
  }

  @override
  Future<void> clearCache() async {
    await _cacheService.delete(key: CacheKeys.cart, boxName: CacheBoxes.cart);
  }
}
