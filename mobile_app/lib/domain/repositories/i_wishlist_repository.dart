/// Wishlist Repository Interface - Domain Layer
/// Defines all wishlist operations

import '../../core/utils/either.dart';
import '../../data/models/wishlist/wishlist_model.dart';
import '../../data/models/product/product_model.dart';

abstract class IWishlistRepository {
  /// Get user's wishlist
  Future<Result<WishlistModel>> getWishlist();

  /// Get wishlist items with full product details
  Future<Result<List<ProductModel>>> getWishlistProducts();

  /// Add product to wishlist
  Future<Result<WishlistModel>> addToWishlist(String productId);

  /// Remove product from wishlist
  Future<Result<WishlistModel>> removeFromWishlist(String productId);

  /// Clear entire wishlist
  Future<Result<void>> clearWishlist();

  /// Check if product is in wishlist
  Future<Result<bool>> isInWishlist(String productId);

  /// Get wishlist item count
  Future<Result<int>> getWishlistCount();

  /// Move item from wishlist to cart
  Future<Result<void>> moveToCart({
    required String productId,
    int quantity = 1,
    String? variantId,
  });

  /// Sync local wishlist with remote (after login)
  Future<Result<WishlistModel>> syncWishlist();

  /// Refresh wishlist cache
  Future<void> refreshCache();

  /// Clear wishlist cache
  Future<void> clearCache();
}
