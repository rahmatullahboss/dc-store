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
    // Web API returns: { items: [{ id, productId, createdAt, product: {...} }], count: number }
    return WishlistModel(
      id: 'user-wishlist',
      items: (data['items'] as List<dynamic>? ?? []).map((item) {
        final itemMap = item as Map<String, dynamic>;
        final product = itemMap['product'] as Map<String, dynamic>?;
        return WishlistItemModel(
          id: itemMap['id'] as String? ?? '',
          productId: itemMap['productId'] as String? ?? '',
          productName: product?['name'] as String?,
          productImage: product?['featuredImage'] as String?,
          price: (product?['price'] as num?)?.toDouble(),
          compareAtPrice: (product?['compareAtPrice'] as num?)?.toDouble(),
          isAvailable: product?['isActive'] as bool? ?? true,
          inStock: product?['inStock'] as bool? ?? true,
          addedAt: itemMap['createdAt'] != null
              ? DateTime.tryParse(itemMap['createdAt'] as String)
              : null,
        );
      }).toList(),
      updatedAt: DateTime.now(),
    );
  }

  @override
  Future<WishlistModel> addToWishlist(String productId) async {
    final response = await _client.post<Map<String, dynamic>>(
      ApiConstants.wishlist,
      data: {'productId': productId},
    );

    if (!response.isSuccess) {
      throw ServerException(
        message: response.message ?? 'Failed to add to wishlist',
        statusCode: response.error?.statusCode,
      );
    }

    // After adding, fetch the updated wishlist
    return getWishlist();
  }

  @override
  Future<WishlistModel> removeFromWishlist(String productId) async {
    final response = await _client.delete<Map<String, dynamic>>(
      '${ApiConstants.wishlist}/$productId',
    );

    if (!response.isSuccess) {
      throw ServerException(
        message: response.message ?? 'Failed to remove from wishlist',
        statusCode: response.error?.statusCode,
      );
    }

    // After removing, fetch the updated wishlist
    return getWishlist();
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
