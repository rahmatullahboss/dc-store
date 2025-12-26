part of 'cart_cubit.dart';

/// Coupon application status
enum CouponStatus { initial, loading, applied, invalid, error }

/// Cart sync status
enum CartSyncStatus { initial, syncing, synced, error }

/// Cart State
class CartState extends Equatable {
  final List<CartItemModel> items;
  final double subtotal;
  final double discount;
  final double shipping;
  final double tax;
  final double total;
  final CouponModel? coupon;
  final CouponStatus couponStatus;
  final String? couponError;
  final CartSyncStatus syncStatus;
  final String? notes;

  const CartState({
    this.items = const [],
    this.subtotal = 0,
    this.discount = 0,
    this.shipping = 0,
    this.tax = 0,
    this.total = 0,
    this.coupon,
    this.couponStatus = CouponStatus.initial,
    this.couponError,
    this.syncStatus = CartSyncStatus.initial,
    this.notes,
  });

  /// Total number of items
  int get itemCount => items.fold(0, (sum, item) => sum + item.quantity);

  /// Number of unique products
  int get uniqueItemCount => items.length;

  /// Check if cart is empty
  bool get isEmpty => items.isEmpty;

  /// Check if cart is not empty
  bool get isNotEmpty => items.isNotEmpty;

  /// Check if coupon is applied
  bool get hasCoupon => coupon != null && couponStatus == CouponStatus.applied;

  /// Get total savings (discount amount)
  double get savings => discount;

  CartState copyWith({
    List<CartItemModel>? items,
    double? subtotal,
    double? discount,
    double? shipping,
    double? tax,
    double? total,
    CouponModel? coupon,
    CouponStatus? couponStatus,
    String? couponError,
    CartSyncStatus? syncStatus,
    String? notes,
  }) {
    return CartState(
      items: items ?? this.items,
      subtotal: subtotal ?? this.subtotal,
      discount: discount ?? this.discount,
      shipping: shipping ?? this.shipping,
      tax: tax ?? this.tax,
      total: total ?? this.total,
      coupon: coupon ?? this.coupon,
      couponStatus: couponStatus ?? this.couponStatus,
      couponError: couponError ?? this.couponError,
      syncStatus: syncStatus ?? this.syncStatus,
      notes: notes ?? this.notes,
    );
  }

  @override
  List<Object?> get props => [
    items,
    subtotal,
    discount,
    shipping,
    tax,
    total,
    coupon,
    couponStatus,
    couponError,
    syncStatus,
    notes,
  ];
}
