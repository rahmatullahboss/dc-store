import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/network/dio_client.dart';
import '../../../../core/constants/api_constants.dart';
import '../../../product/domain/product_model.dart';
import '../../domain/cart_item_model.dart';

/// Cart state that includes loading status
class CartState {
  final List<CartItem> items;
  final bool isLoading;
  final bool isSyncing;
  final String? error;

  const CartState({
    this.items = const [],
    this.isLoading = false,
    this.isSyncing = false,
    this.error,
  });

  CartState copyWith({
    List<CartItem>? items,
    bool? isLoading,
    bool? isSyncing,
    String? error,
    bool clearError = false,
  }) {
    return CartState(
      items: items ?? this.items,
      isLoading: isLoading ?? this.isLoading,
      isSyncing: isSyncing ?? this.isSyncing,
      error: clearError ? null : (error ?? this.error),
    );
  }

  double get totalPrice =>
      items.fold(0, (total, item) => total + item.totalPrice);

  int get itemCount => items.fold(0, (count, item) => count + item.quantity);
}

/// Cart Notifier with server sync
class CartNotifier extends Notifier<CartState> {
  @override
  CartState build() {
    // Fetch cart from server on initialization
    Future.microtask(() => fetchCart());
    return const CartState(isLoading: true);
  }

  DioClient get _client => ref.read(dioClientProvider);

  /// Fetch cart from server
  Future<void> fetchCart() async {
    state = state.copyWith(isLoading: true, clearError: true);

    try {
      final response = await _client.get<Map<String, dynamic>>(
        ApiConstants.cart,
      );

      if (response.isSuccess && response.data != null) {
        final cartData = response.data!['cart'] as Map<String, dynamic>?;
        final items = cartData?['items'] as List<dynamic>? ?? [];

        final cartItems = items.map((item) {
          final map = item as Map<String, dynamic>;
          return CartItem(
            product: Product(
              id: map['productId'] as String,
              name: map['productName'] as String? ?? '',
              slug:
                  map['productId'] as String, // Use productId as slug fallback
              price: (map['price'] as num).toDouble(),
              featuredImage: map['productImage'] as String?,
              description: '',
            ),
            quantity: map['quantity'] as int? ?? 1,
          );
        }).toList();

        state = state.copyWith(items: cartItems, isLoading: false);
      } else {
        // No cart data or error - set empty cart
        state = state.copyWith(items: [], isLoading: false);
      }
    } catch (e) {
      debugPrint('Fetch cart error: $e');
      state = state.copyWith(
        items: [],
        isLoading: false,
        error: 'Failed to load cart',
      );
    }
  }

  /// Add product to cart
  Future<void> addToCart(Product product) async {
    // Optimistic update
    final existingIndex = state.items.indexWhere(
      (item) => item.product.id == product.id,
    );

    List<CartItem> newItems;
    if (existingIndex >= 0) {
      final oldItem = state.items[existingIndex];
      final newItem = oldItem.copyWith(quantity: oldItem.quantity + 1);
      newItems = [...state.items];
      newItems[existingIndex] = newItem;
    } else {
      newItems = [...state.items, CartItem(product: product)];
    }
    state = state.copyWith(items: newItems);

    // Sync to server
    try {
      state = state.copyWith(isSyncing: true);
      await _client.post(
        ApiConstants.cart,
        data: {'productId': product.id, 'quantity': 1},
      );
      state = state.copyWith(isSyncing: false);
    } catch (e) {
      debugPrint('Add to cart error: $e');
      state = state.copyWith(isSyncing: false);
    }
  }

  /// Remove product from cart
  Future<void> removeFromCart(String productId) async {
    final newItems = state.items
        .where((item) => item.product.id != productId)
        .toList();
    state = state.copyWith(items: newItems);

    // Sync to server
    try {
      state = state.copyWith(isSyncing: true);
      await _client.patch(
        '${ApiConstants.cartItems}/$productId-default',
        data: {'quantity': 0},
      );
      state = state.copyWith(isSyncing: false);
    } catch (e) {
      debugPrint('Remove from cart error: $e');
      state = state.copyWith(isSyncing: false);
    }
  }

  /// Increment quantity
  Future<void> incrementQuantity(String productId) async {
    final index = state.items.indexWhere(
      (item) => item.product.id == productId,
    );
    if (index >= 0) {
      final oldItem = state.items[index];
      final newQuantity = oldItem.quantity + 1;
      final newItem = oldItem.copyWith(quantity: newQuantity);
      final newItems = [...state.items];
      newItems[index] = newItem;
      state = state.copyWith(items: newItems);

      // Sync to server
      try {
        await _client.patch(
          '${ApiConstants.cartItems}/$productId-default',
          data: {'quantity': newQuantity},
        );
      } catch (e) {
        debugPrint('Update quantity error: $e');
      }
    }
  }

  /// Decrement quantity
  Future<void> decrementQuantity(String productId) async {
    final index = state.items.indexWhere(
      (item) => item.product.id == productId,
    );
    if (index >= 0) {
      final oldItem = state.items[index];
      if (oldItem.quantity > 1) {
        final newQuantity = oldItem.quantity - 1;
        final newItem = oldItem.copyWith(quantity: newQuantity);
        final newItems = [...state.items];
        newItems[index] = newItem;
        state = state.copyWith(items: newItems);

        // Sync to server
        try {
          await _client.patch(
            '${ApiConstants.cartItems}/$productId-default',
            data: {'quantity': newQuantity},
          );
        } catch (e) {
          debugPrint('Update quantity error: $e');
        }
      } else {
        await removeFromCart(productId);
      }
    }
  }

  /// Clear cart
  Future<void> clearCart() async {
    state = state.copyWith(items: []);

    try {
      await _client.delete(ApiConstants.cart);
    } catch (e) {
      debugPrint('Clear cart error: $e');
    }
  }
}

final cartProvider = NotifierProvider<CartNotifier, CartState>(
  CartNotifier.new,
);

final cartTotalProvider = Provider<double>((ref) {
  final cart = ref.watch(cartProvider);
  return cart.totalPrice;
});

final cartItemCountProvider = Provider<int>((ref) {
  final cart = ref.watch(cartProvider);
  return cart.itemCount;
});
