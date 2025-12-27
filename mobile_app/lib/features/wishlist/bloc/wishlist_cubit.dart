import 'dart:convert';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import '../../../core/config/app_config.dart';
import '../../../data/models/common/common_models.dart';

part 'wishlist_state.dart';

/// WishlistCubit - Manages wishlist state with real API integration
class WishlistCubit extends Cubit<WishlistState> {
  WishlistCubit() : super(const WishlistState());

  /// Fetch wishlist items from API
  Future<void> fetchWishlist() async {
    emit(state.copyWith(status: WishlistStatus.loading));

    try {
      final url = Uri.parse('${AppConfig.baseUrl}/api/user/wishlist');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        final items =
            (data['items'] as List<dynamic>?)?.map((item) {
              final product = item['product'] as Map<String, dynamic>?;
              return WishlistItemModel(
                id: (item['id'] as String?) ?? '',
                productId: (item['productId'] as String?) ?? '',
                productName: (product?['name'] as String?) ?? 'Unknown Product',
                productImage: product?['featuredImage'] as String?,
                price: (product?['price'] as num?)?.toDouble() ?? 0.0,
                compareAtPrice: (product?['compareAtPrice'] as num?)
                    ?.toDouble(),
                inStock: product?['inStock'] as bool? ?? true,
                addedAt: item['createdAt'] != null
                    ? DateTime.tryParse(item['createdAt'] as String)
                    : null,
              );
            }).toList() ??
            [];

        emit(state.copyWith(status: WishlistStatus.loaded, items: items));
      } else if (response.statusCode == 401) {
        // User not logged in, show empty wishlist
        emit(state.copyWith(status: WishlistStatus.loaded, items: []));
      } else {
        emit(
          state.copyWith(
            status: WishlistStatus.error,
            errorMessage: 'Failed to load wishlist',
          ),
        );
      }
    } catch (e) {
      emit(
        state.copyWith(
          status: WishlistStatus.error,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  /// Toggle wishlist (add/remove)
  Future<void> toggleWishlist({
    required String productId,
    required String productName,
    String? productImage,
    required double price,
    double? compareAtPrice,
    bool inStock = true,
  }) async {
    final isInWishlist = state.isInWishlist(productId);

    if (isInWishlist) {
      await removeFromWishlist(productId);
    } else {
      await addToWishlist(
        productId: productId,
        productName: productName,
        productImage: productImage,
        price: price,
        compareAtPrice: compareAtPrice,
        inStock: inStock,
      );
    }
  }

  /// Add item to wishlist
  Future<void> addToWishlist({
    required String productId,
    required String productName,
    String? productImage,
    required double price,
    double? compareAtPrice,
    bool inStock = true,
  }) async {
    // Optimistic update
    final newItem = WishlistItemModel(
      id: 'wishlist_${DateTime.now().millisecondsSinceEpoch}',
      productId: productId,
      productName: productName,
      productImage: productImage,
      price: price,
      compareAtPrice: compareAtPrice,
      inStock: inStock,
      addedAt: DateTime.now(),
    );

    emit(state.copyWith(items: [...state.items, newItem]));

    try {
      final url = Uri.parse('${AppConfig.baseUrl}/api/user/wishlist');
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'productId': productId}),
      );

      if (response.statusCode != 200 && response.statusCode != 201) {
        // Revert on error
        emit(
          state.copyWith(
            items: state.items.where((i) => i.productId != productId).toList(),
          ),
        );
      }
    } catch (e) {
      // Revert on error
      emit(
        state.copyWith(
          items: state.items.where((i) => i.productId != productId).toList(),
        ),
      );
    }
  }

  /// Remove item from wishlist
  Future<void> removeFromWishlist(String productId) async {
    final itemToRemove = state.items.firstWhere(
      (i) => i.productId == productId,
      orElse: () => throw Exception('Item not found'),
    );

    // Optimistic update
    emit(
      state.copyWith(
        items: state.items.where((i) => i.productId != productId).toList(),
      ),
    );

    try {
      final url = Uri.parse(
        '${AppConfig.baseUrl}/api/user/wishlist/$productId',
      );
      final response = await http.delete(url);

      if (response.statusCode != 200) {
        // Revert on error
        emit(state.copyWith(items: [...state.items, itemToRemove]));
      }
    } catch (e) {
      // Revert on error
      emit(state.copyWith(items: [...state.items, itemToRemove]));
    }
  }

  /// Move item to cart
  Future<void> moveToCart(String productId) async {
    await removeFromWishlist(productId);
  }

  /// Move all items to cart
  Future<void> moveAllToCart() async {
    emit(state.copyWith(items: []));
  }

  /// Clear wishlist
  void clearWishlist() {
    emit(const WishlistState());
  }
}
