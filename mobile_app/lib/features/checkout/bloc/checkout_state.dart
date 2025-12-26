part of 'checkout_bloc.dart';

/// Checkout step/status
enum CheckoutStatus {
  initial,
  addressSelection,
  shippingSelection,
  paymentSelection,
  review,
  processing,
  success,
  failed;

  bool get isProcessing => this == CheckoutStatus.processing;
  bool get isComplete => this == CheckoutStatus.success;
  bool get isFailed => this == CheckoutStatus.failed;
}

/// Checkout State
class CheckoutState extends Equatable {
  final CheckoutStatus status;
  final List<CartItemModel> cartItems;
  final AddressModel? selectedAddress;
  final AddressModel? billingAddress;
  final bool useSameForBilling;
  final String? shippingMethod;
  final String? paymentMethod;
  final double subtotal;
  final double discount;
  final double shipping;
  final double total;
  final String? couponCode;
  final String? notes;
  final OrderModel? createdOrder;
  final String? error;

  const CheckoutState({
    this.status = CheckoutStatus.initial,
    this.cartItems = const [],
    this.selectedAddress,
    this.billingAddress,
    this.useSameForBilling = true,
    this.shippingMethod,
    this.paymentMethod,
    this.subtotal = 0,
    this.discount = 0,
    this.shipping = 0,
    this.total = 0,
    this.couponCode,
    this.notes,
    this.createdOrder,
    this.error,
  });

  /// Check if can proceed to next step
  bool get canProceedFromAddress => selectedAddress != null;
  bool get canProceedFromShipping => shippingMethod != null;
  bool get canProceedFromPayment => paymentMethod != null;

  /// Check if can submit order
  bool get canSubmit =>
      selectedAddress != null && paymentMethod != null && cartItems.isNotEmpty;

  /// Current step index (for stepper)
  int get currentStepIndex {
    switch (status) {
      case CheckoutStatus.initial:
      case CheckoutStatus.addressSelection:
        return 0;
      case CheckoutStatus.shippingSelection:
        return 1;
      case CheckoutStatus.paymentSelection:
        return 2;
      case CheckoutStatus.review:
      case CheckoutStatus.processing:
      case CheckoutStatus.success:
      case CheckoutStatus.failed:
        return 3;
    }
  }

  CheckoutState copyWith({
    CheckoutStatus? status,
    List<CartItemModel>? cartItems,
    AddressModel? selectedAddress,
    AddressModel? billingAddress,
    bool? useSameForBilling,
    String? shippingMethod,
    String? paymentMethod,
    double? subtotal,
    double? discount,
    double? shipping,
    double? total,
    String? couponCode,
    String? notes,
    OrderModel? createdOrder,
    String? error,
  }) {
    return CheckoutState(
      status: status ?? this.status,
      cartItems: cartItems ?? this.cartItems,
      selectedAddress: selectedAddress ?? this.selectedAddress,
      billingAddress: billingAddress ?? this.billingAddress,
      useSameForBilling: useSameForBilling ?? this.useSameForBilling,
      shippingMethod: shippingMethod ?? this.shippingMethod,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      subtotal: subtotal ?? this.subtotal,
      discount: discount ?? this.discount,
      shipping: shipping ?? this.shipping,
      total: total ?? this.total,
      couponCode: couponCode ?? this.couponCode,
      notes: notes ?? this.notes,
      createdOrder: createdOrder ?? this.createdOrder,
      error: error ?? this.error,
    );
  }

  @override
  List<Object?> get props => [
    status,
    cartItems,
    selectedAddress,
    billingAddress,
    useSameForBilling,
    shippingMethod,
    paymentMethod,
    subtotal,
    discount,
    shipping,
    total,
    couponCode,
    notes,
    createdOrder,
    error,
  ];
}
