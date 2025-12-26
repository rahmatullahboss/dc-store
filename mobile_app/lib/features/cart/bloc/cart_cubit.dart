import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../data/models/cart/cart_model.dart';

part 'cart_state.dart';

/// CartCubit - Manages shopping cart state
/// Uses HydratedMixin for persistence
class CartCubit extends Cubit<CartState> {
  CartCubit() : super(const CartState());

  /// Add item to cart
  void addItem({
    required String productId,
    required String productName,
    String? productImage,
    String? variantId,
    String? variantName,
    Map<String, String>? selectedAttributes,
    required double price,
    double? compareAtPrice,
    int quantity = 1,
    int maxQuantity = 10,
  }) {
    final existingIndex = state.items.indexWhere(
      (item) => item.productId == productId && item.variantId == variantId,
    );

    List<CartItemModel> updatedItems;

    if (existingIndex >= 0) {
      // Item exists, update quantity
      final existingItem = state.items[existingIndex];
      final newQuantity = (existingItem.quantity + quantity).clamp(
        1,
        maxQuantity,
      );

      updatedItems = List.from(state.items);
      updatedItems[existingIndex] = existingItem.copyWith(
        quantity: newQuantity,
        itemTotal: price * newQuantity,
      );
    } else {
      // Add new item
      final newItem = CartItemModel(
        id: 'cart_${DateTime.now().millisecondsSinceEpoch}',
        productId: productId,
        productName: productName,
        productImage: productImage,
        variantId: variantId,
        variantName: variantName,
        selectedAttributes: selectedAttributes,
        quantity: quantity,
        price: price,
        compareAtPrice: compareAtPrice,
        itemTotal: price * quantity,
        maxQuantity: maxQuantity,
        addedAt: DateTime.now(),
      );
      updatedItems = [...state.items, newItem];
    }

    _updateCartState(updatedItems);
  }

  /// Remove item from cart
  void removeItem(String itemId) {
    final updatedItems = state.items
        .where((item) => item.id != itemId)
        .toList();
    _updateCartState(updatedItems);
  }

  /// Update item quantity
  void updateQuantity(String itemId, int quantity) {
    if (quantity <= 0) {
      removeItem(itemId);
      return;
    }

    final updatedItems = state.items.map((item) {
      if (item.id == itemId) {
        final newQuantity = quantity.clamp(1, item.maxQuantity);
        return item.copyWith(
          quantity: newQuantity,
          itemTotal: item.price * newQuantity,
        );
      }
      return item;
    }).toList();

    _updateCartState(updatedItems);
  }

  /// Increment item quantity
  void incrementQuantity(String itemId) {
    final item = state.items.firstWhere((i) => i.id == itemId);
    if (item.quantity < item.maxQuantity) {
      updateQuantity(itemId, item.quantity + 1);
    }
  }

  /// Decrement item quantity
  void decrementQuantity(String itemId) {
    final item = state.items.firstWhere((i) => i.id == itemId);
    if (item.quantity > 1) {
      updateQuantity(itemId, item.quantity - 1);
    }
  }

  /// Apply coupon code
  Future<void> applyCoupon(String code) async {
    emit(state.copyWith(couponStatus: CouponStatus.loading));

    try {
      // TODO: Validate coupon with API
      await Future.delayed(const Duration(milliseconds: 500));

      // Mock coupon
      const coupon = CouponModel(
        code: 'SAVE10',
        type: 'percentage',
        value: 10,
        minOrderAmount: 500,
        maxDiscount: 500,
        description: '10% off on orders above ৳500',
      );

      if (code.toUpperCase() == 'SAVE10' && state.subtotal >= 500) {
        final discount = coupon.calculateDiscount(state.subtotal);
        emit(
          state.copyWith(
            coupon: coupon,
            discount: discount,
            couponStatus: CouponStatus.applied,
            total: state.subtotal - discount + state.shipping + state.tax,
          ),
        );
      } else {
        emit(
          state.copyWith(
            couponStatus: CouponStatus.invalid,
            couponError: 'Invalid or expired coupon',
          ),
        );
      }
    } catch (e) {
      emit(
        state.copyWith(
          couponStatus: CouponStatus.error,
          couponError: e.toString(),
        ),
      );
    }
  }

  /// Remove coupon
  void removeCoupon() {
    emit(
      state.copyWith(
        coupon: null,
        discount: 0,
        couponStatus: CouponStatus.initial,
        couponError: null,
        total: state.subtotal + state.shipping + state.tax,
      ),
    );
  }

  /// Update shipping cost
  void updateShipping(double shipping) {
    emit(
      state.copyWith(
        shipping: shipping,
        total: state.subtotal - state.discount + shipping + state.tax,
      ),
    );
  }

  /// Clear entire cart
  void clearCart() {
    emit(const CartState());
  }

  /// Sync cart with server
  Future<void> syncWithServer() async {
    emit(state.copyWith(syncStatus: CartSyncStatus.syncing));

    try {
      // TODO: Sync cart with server
      await Future.delayed(const Duration(milliseconds: 500));
      emit(state.copyWith(syncStatus: CartSyncStatus.synced));
    } catch (e) {
      emit(state.copyWith(syncStatus: CartSyncStatus.error));
    }
  }

  /// Internal method to update cart state with recalculated totals
  void _updateCartState(List<CartItemModel> items) {
    final subtotal = items.fold<double>(
      0,
      (sum, item) => sum + (item.price * item.quantity),
    );

    double discount = 0;
    if (state.coupon != null) {
      discount = state.coupon!.calculateDiscount(subtotal);
    }

    final total = subtotal - discount + state.shipping + state.tax;

    emit(
      state.copyWith(
        items: items,
        subtotal: subtotal,
        discount: discount,
        total: total,
      ),
    );
  }
}
