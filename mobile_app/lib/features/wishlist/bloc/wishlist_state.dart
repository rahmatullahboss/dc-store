part of 'wishlist_cubit.dart';

/// Wishlist loading status
enum WishlistStatus { initial, loading, loaded, error }

/// Wishlist State
class WishlistState extends Equatable {
  final WishlistStatus status;
  final List<WishlistItemModel> items;
  final String? errorMessage;

  const WishlistState({
    this.status = WishlistStatus.initial,
    this.items = const [],
    this.errorMessage,
  });

  /// Total items in wishlist
  int get itemCount => items.length;

  /// Check if wishlist is empty
  bool get isEmpty => items.isEmpty;

  /// Check if product is in wishlist
  bool isInWishlist(String productId) {
    return items.any((item) => item.productId == productId);
  }

  /// Get wishlist item by product ID
  WishlistItemModel? getItem(String productId) {
    try {
      return items.firstWhere((item) => item.productId == productId);
    } catch (_) {
      return null;
    }
  }

  WishlistState copyWith({
    WishlistStatus? status,
    List<WishlistItemModel>? items,
    String? errorMessage,
  }) {
    return WishlistState(
      status: status ?? this.status,
      items: items ?? this.items,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, items, errorMessage];
}
