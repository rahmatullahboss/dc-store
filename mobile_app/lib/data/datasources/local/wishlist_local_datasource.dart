/// Wishlist Local Data Source - Hive caching for wishlist
import '../../../core/cache/cache_service.dart';
import '../../models/wishlist/wishlist_model.dart';

abstract class IWishlistLocalDataSource {
  Future<WishlistModel?> getCachedWishlist();
  Future<void> cacheWishlist(WishlistModel wishlist);
  Future<void> clearCache();
}

class WishlistLocalDataSource implements IWishlistLocalDataSource {
  final CacheService _cacheService;

  WishlistLocalDataSource({required CacheService cacheService})
    : _cacheService = cacheService;

  @override
  Future<WishlistModel?> getCachedWishlist() async {
    return _cacheService.get<WishlistModel>(
      key: CacheKeys.wishlist,
      boxName: CacheBoxes.cart, // Reusing cart box for wishlist
      fromJson: WishlistModel.fromJson,
    );
  }

  @override
  Future<void> cacheWishlist(WishlistModel wishlist) async {
    await _cacheService.set<WishlistModel>(
      key: CacheKeys.wishlist,
      boxName: CacheBoxes.cart,
      data: wishlist,
      toJson: (w) => w.toJson(),
      ttl: CacheConfig.wishlistTTL,
    );
  }

  @override
  Future<void> clearCache() async {
    await _cacheService.delete(
      key: CacheKeys.wishlist,
      boxName: CacheBoxes.cart,
    );
  }
}
