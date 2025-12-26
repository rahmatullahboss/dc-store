/// Wishlist Remote Data Source - API calls for wishlist
library;
import '../../../core/network/dio_client.dart';
import '../../../core/constants/api_constants.dart';
import '../../../core/errors/exceptions.dart';
import '../../models/wishlist/wishlist_model.dart';

abstract class IWishlistRemoteDataSource {
  Future<WishlistModel> getWishlist();
  Future<WishlistModel> addToWishlist(String productId);
  Future<WishlistModel> removeFromWishlist(String productId);
  Future<void> clearWishlist();
}

class WishlistRemoteDataSource implements IWishlistRemoteDataSource {
  final DioClient _client;

  WishlistRemoteDataSource({required DioClient client}) : _client = client;

  @override
  Future<WishlistModel> getWishlist() async {
    final response = await _client.get<Map<String, dynamic>>(
      ApiConstants.wishlist,
    );

    if (!response.isSuccess || response.data == null) {
      throw ServerException(
        message: response.message ?? 'Failed to fetch wishlist',
        statusCode: response.error?.statusCode,
      );
    }

    final data = response.data!;
    return WishlistModel.fromJson(
      data['wishlist'] as Map<String, dynamic>? ?? data,
    );
  }

  @override
  Future<WishlistModel> addToWishlist(String productId) async {
    final response = await _client.post<Map<String, dynamic>>(
      '${ApiConstants.wishlist}/items',
      data: {'productId': productId},
    );

    if (!response.isSuccess || response.data == null) {
      throw ServerException(
        message: response.message ?? 'Failed to add to wishlist',
        statusCode: response.error?.statusCode,
      );
    }

    final data = response.data!;
    return WishlistModel.fromJson(
      data['wishlist'] as Map<String, dynamic>? ?? data,
    );
  }

  @override
  Future<WishlistModel> removeFromWishlist(String productId) async {
    final response = await _client.delete<Map<String, dynamic>>(
      '${ApiConstants.wishlist}/items/$productId',
    );

    if (!response.isSuccess || response.data == null) {
      throw ServerException(
        message: response.message ?? 'Failed to remove from wishlist',
        statusCode: response.error?.statusCode,
      );
    }

    final data = response.data!;
    return WishlistModel.fromJson(
      data['wishlist'] as Map<String, dynamic>? ?? data,
    );
  }

  @override
  Future<void> clearWishlist() async {
    final response = await _client.delete<Map<String, dynamic>>(
      ApiConstants.wishlist,
    );

    if (!response.isSuccess) {
      throw ServerException(
        message: response.message ?? 'Failed to clear wishlist',
        statusCode: response.error?.statusCode,
      );
    }
  }
}
