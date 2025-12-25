import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../product/domain/product_model.dart';
import '../../domain/cart_item_model.dart';

// State is List of CartItems
class CartNotifier extends Notifier<List<CartItem>> {
  @override
  List<CartItem> build() {
    return [];
  }

  void addToCart(Product product) {
    final existingIndex = state.indexWhere(
      (item) => item.product.id == product.id,
    );

    if (existingIndex >= 0) {
      // Increment
      final oldItem = state[existingIndex];
      final newItem = oldItem.copyWith(quantity: oldItem.quantity + 1);
      final newState = [...state];
      newState[existingIndex] = newItem;
      state = newState;
    } else {
      // Add new
      state = [...state, CartItem(product: product)];
    }
  }

  void removeFromCart(String productId) {
    state = state.where((item) => item.product.id != productId).toList();
  }

  void incrementQuantity(String productId) {
    final index = state.indexWhere((item) => item.product.id == productId);
    if (index >= 0) {
      final oldItem = state[index];
      final newItem = oldItem.copyWith(quantity: oldItem.quantity + 1);
      final newState = [...state];
      newState[index] = newItem;
      state = newState;
    }
  }

  void decrementQuantity(String productId) {
    final index = state.indexWhere((item) => item.product.id == productId);
    if (index >= 0) {
      final oldItem = state[index];
      if (oldItem.quantity > 1) {
        final newItem = oldItem.copyWith(quantity: oldItem.quantity - 1);
        final newState = [...state];
        newState[index] = newItem;
        state = newState;
      } else {
        // Remove if quantity becomes 0
        removeFromCart(productId);
      }
    }
  }

  void clearCart() {
    state = [];
  }
}

final cartProvider = NotifierProvider<CartNotifier, List<CartItem>>(
  CartNotifier.new,
);

final cartTotalProvider = Provider<double>((ref) {
  final cart = ref.watch(cartProvider);
  return cart.fold(0, (total, item) => total + item.totalPrice);
});

final cartItemCountProvider = Provider<int>((ref) {
  final cart = ref.watch(cartProvider);
  return cart.fold(0, (count, item) => count + item.quantity);
});
