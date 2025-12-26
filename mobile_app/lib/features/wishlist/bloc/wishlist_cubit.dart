import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../data/models/common/common_models.dart';

part 'wishlist_state.dart';

/// WishlistCubit - Manages wishlist state
class WishlistCubit extends Cubit<WishlistState> {
  WishlistCubit() : super(const WishlistState());

  /// Fetch wishlist items
  Future<void> fetchWishlist() async {
    emit(state.copyWith(status: WishlistStatus.loading));

    try {
      // TODO: Fetch from API
      await Future.delayed(const Duration(milliseconds: 500));

      emit(state.copyWith(status: WishlistStatus.loaded, items: []));
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
      // Remove from wishlist
      await removeFromWishlist(productId);
    } else {
      // Add to wishlist
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
      // TODO: Sync with API
      await Future.delayed(const Duration(milliseconds: 300));
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
      // TODO: Sync with API
      await Future.delayed(const Duration(milliseconds: 300));
    } catch (e) {
      // Revert on error
      emit(state.copyWith(items: [...state.items, itemToRemove]));
    }
  }

  /// Move item to cart
  Future<void> moveToCart(String productId) async {
    // This should be handled by coordinating with CartCubit
    // Here we just remove from wishlist
    await removeFromWishlist(productId);
  }

  /// Move all items to cart
  Future<void> moveAllToCart() async {
    // This should be handled by coordinating with CartCubit
    emit(state.copyWith(items: []));
  }

  /// Clear wishlist
  void clearWishlist() {
    emit(const WishlistState());
  }
}
