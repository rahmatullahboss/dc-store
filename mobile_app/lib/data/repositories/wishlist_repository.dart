/// Wishlist Repository Implementation
library;
import '../../core/utils/either.dart';
import '../../core/errors/failures.dart';
import '../../core/errors/exceptions.dart';
import '../../core/network/network_info.dart';
import '../../domain/repositories/i_wishlist_repository.dart';
import '../datasources/remote/wishlist_remote_datasource.dart';
import '../datasources/local/wishlist_local_datasource.dart';
import '../models/wishlist/wishlist_model.dart';
import '../models/product/product_model.dart';

class WishlistRepository implements IWishlistRepository {
  final IWishlistRemoteDataSource _remoteDataSource;
  final IWishlistLocalDataSource _localDataSource;
  final NetworkInfo _networkInfo;

  WishlistRepository({
    required IWishlistRemoteDataSource remoteDataSource,
    required IWishlistLocalDataSource localDataSource,
    required NetworkInfo networkInfo,
  }) : _remoteDataSource = remoteDataSource,
       _localDataSource = localDataSource,
       _networkInfo = networkInfo;

  @override
  Future<Result<WishlistModel>> getWishlist() async {
    return tryCatch(() async {
      final cached = await _localDataSource.getCachedWishlist();

      if (await _networkInfo.isConnected) {
        final wishlist = await _remoteDataSource.getWishlist();
        await _localDataSource.cacheWishlist(wishlist);
        return wishlist;
      } else if (cached != null) {
        return cached;
      }

      return const WishlistModel(id: 'local');
    }, onError: _handleError);
  }

  @override
  Future<Result<List<ProductModel>>> getWishlistProducts() async {
    return tryCatch(() async {
      // This would need a separate API call to get full product details
      throw UnimplementedError('Get wishlist products not implemented');
    }, onError: _handleError);
  }

  @override
  Future<Result<WishlistModel>> addToWishlist(String productId) async {
    return tryCatch(() async {
      // Optimistic update
      final cached = await _localDataSource.getCachedWishlist();
      if (cached != null) {
        final newItem = WishlistItemModel(
          id: 'local_${DateTime.now().millisecondsSinceEpoch}',
          productId: productId,
          addedAt: DateTime.now(),
        );
        final optimistic = cached.copyWith(items: [...cached.items, newItem]);
        await _localDataSource.cacheWishlist(optimistic);
      }

      if (!await _networkInfo.isConnected) {
        return cached ?? const WishlistModel(id: 'local');
      }

      final wishlist = await _remoteDataSource.addToWishlist(productId);
      await _localDataSource.cacheWishlist(wishlist);
      return wishlist;
    }, onError: _handleError);
  }

  @override
  Future<Result<WishlistModel>> removeFromWishlist(String productId) async {
    return tryCatch(() async {
      // Optimistic update
      final cached = await _localDataSource.getCachedWishlist();
      if (cached != null) {
        final optimistic = cached.copyWith(
          items: cached.items.where((i) => i.productId != productId).toList(),
        );
        await _localDataSource.cacheWishlist(optimistic);
      }

      if (!await _networkInfo.isConnected) {
        return cached ?? const WishlistModel(id: 'local');
      }

      final wishlist = await _remoteDataSource.removeFromWishlist(productId);
      await _localDataSource.cacheWishlist(wishlist);
      return wishlist;
    }, onError: _handleError);
  }

  @override
  Future<Result<void>> clearWishlist() async {
    return tryCatch(() async {
      await _localDataSource.clearCache();

      if (await _networkInfo.isConnected) {
        await _remoteDataSource.clearWishlist();
      }
    }, onError: _handleError);
  }

  @override
  Future<Result<bool>> isInWishlist(String productId) async {
    return tryCatch(() async {
      final wishlistResult = await getWishlist();
      return wishlistResult.fold(
        ifLeft: (_) => false,
        ifRight: (wishlist) => wishlist.containsProduct(productId),
      );
    }, onError: _handleError);
  }

  @override
  Future<Result<int>> getWishlistCount() async {
    return tryCatch(() async {
      final wishlistResult = await getWishlist();
      return wishlistResult.fold(
        ifLeft: (_) => 0,
        ifRight: (wishlist) => wishlist.itemCount,
      );
    }, onError: _handleError);
  }

  @override
  Future<Result<void>> moveToCart({
    required String productId,
    int quantity = 1,
    String? variantId,
  }) async {
    return tryCatch(() async {
      throw UnimplementedError('Move to cart not implemented');
    }, onError: _handleError);
  }

  @override
  Future<Result<WishlistModel>> syncWishlist() async {
    return tryCatch(() async {
      if (!await _networkInfo.isConnected) {
        throw NetworkException.noConnection();
      }

      final wishlist = await _remoteDataSource.getWishlist();
      await _localDataSource.cacheWishlist(wishlist);
      return wishlist;
    }, onError: _handleError);
  }

  @override
  Future<void> refreshCache() async {
    await _localDataSource.clearCache();
  }

  @override
  Future<void> clearCache() async {
    await _localDataSource.clearCache();
  }

  Failure _handleError(Object error, StackTrace stack) {
    if (error is NetworkException) {
      return NetworkFailure(error.message);
    } else if (error is ServerException) {
      return ServerFailure(error.message);
    }
    return ServerFailure(error.toString());
  }
}
