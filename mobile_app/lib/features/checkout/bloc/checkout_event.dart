part of 'checkout_bloc.dart';

/// Checkout Events
sealed class CheckoutEvent {
  const CheckoutEvent();
}

/// Start checkout process
final class CheckoutStarted extends CheckoutEvent {
  final List<CartItemModel> cartItems;
  final double subtotal;
  final double discount;
  final String? couponCode;

  const CheckoutStarted({
    required this.cartItems,
    required this.subtotal,
    this.discount = 0,
    this.couponCode,
  });
}

/// Address selected
final class CheckoutAddressSelected extends CheckoutEvent {
  final AddressModel address;
  final bool useSameForBilling;

  const CheckoutAddressSelected({
    required this.address,
    this.useSameForBilling = true,
  });
}

/// Shipping method selected
final class CheckoutShippingMethodSelected extends CheckoutEvent {
  final String method;
  final double cost;

  const CheckoutShippingMethodSelected({
    required this.method,
    required this.cost,
  });
}

/// Payment method selected
final class CheckoutPaymentMethodSelected extends CheckoutEvent {
  final String method;

  const CheckoutPaymentMethodSelected(this.method);
}

/// Order notes updated
final class CheckoutNotesUpdated extends CheckoutEvent {
  final String notes;

  const CheckoutNotesUpdated(this.notes);
}

/// Step changed
final class CheckoutStepChanged extends CheckoutEvent {
  final CheckoutStatus step;

  const CheckoutStepChanged(this.step);
}

/// Submit order
final class CheckoutSubmitted extends CheckoutEvent {
  const CheckoutSubmitted();
}

/// Reset checkout
final class CheckoutReset extends CheckoutEvent {
  const CheckoutReset();
}
