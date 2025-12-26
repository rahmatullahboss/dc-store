import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../data/models/user/user_model.dart';
import '../../../data/models/cart/cart_model.dart';
import '../../../data/models/order/order_model.dart';

part 'checkout_event.dart';
part 'checkout_state.dart';

/// CheckoutBloc - Manages multi-step checkout process
class CheckoutBloc extends Bloc<CheckoutEvent, CheckoutState> {
  CheckoutBloc() : super(const CheckoutState()) {
    on<CheckoutStarted>(_onStarted);
    on<CheckoutAddressSelected>(_onAddressSelected);
    on<CheckoutShippingMethodSelected>(_onShippingMethodSelected);
    on<CheckoutPaymentMethodSelected>(_onPaymentMethodSelected);
    on<CheckoutNotesUpdated>(_onNotesUpdated);
    on<CheckoutStepChanged>(_onStepChanged);
    on<CheckoutSubmitted>(_onSubmitted);
    on<CheckoutReset>(_onReset);
  }

  /// Initialize checkout with cart
  void _onStarted(CheckoutStarted event, Emitter<CheckoutState> emit) {
    emit(
      state.copyWith(
        status: CheckoutStatus.addressSelection,
        cartItems: event.cartItems,
        subtotal: event.subtotal,
        discount: event.discount,
        couponCode: event.couponCode,
      ),
    );
  }

  /// Address selected
  void _onAddressSelected(
    CheckoutAddressSelected event,
    Emitter<CheckoutState> emit,
  ) {
    emit(
      state.copyWith(
        selectedAddress: event.address,
        useSameForBilling: event.useSameForBilling,
        billingAddress: event.useSameForBilling
            ? event.address
            : state.billingAddress,
      ),
    );

    // Calculate shipping based on address
    final shipping = _calculateShipping(event.address);
    final total = state.subtotal - state.discount + shipping;

    emit(state.copyWith(shipping: shipping, total: total));
  }

  /// Shipping method selected
  void _onShippingMethodSelected(
    CheckoutShippingMethodSelected event,
    Emitter<CheckoutState> emit,
  ) {
    emit(
      state.copyWith(
        shippingMethod: event.method,
        shipping: event.cost,
        total: state.subtotal - state.discount + event.cost,
      ),
    );
  }

  /// Payment method selected
  void _onPaymentMethodSelected(
    CheckoutPaymentMethodSelected event,
    Emitter<CheckoutState> emit,
  ) {
    emit(state.copyWith(paymentMethod: event.method));
  }

  /// Notes updated
  void _onNotesUpdated(
    CheckoutNotesUpdated event,
    Emitter<CheckoutState> emit,
  ) {
    emit(state.copyWith(notes: event.notes));
  }

  /// Step changed
  void _onStepChanged(CheckoutStepChanged event, Emitter<CheckoutState> emit) {
    emit(state.copyWith(status: event.step));
  }

  /// Submit order
  Future<void> _onSubmitted(
    CheckoutSubmitted event,
    Emitter<CheckoutState> emit,
  ) async {
    if (!state.canSubmit) {
      emit(state.copyWith(error: 'Please complete all required steps'));
      return;
    }

    emit(state.copyWith(status: CheckoutStatus.processing));

    try {
      // TODO: Create order via API
      await Future.delayed(const Duration(seconds: 2));

      // Mock order creation
      final order = OrderModel(
        id: 'order_${DateTime.now().millisecondsSinceEpoch}',
        orderNumber: 'ORD-${DateTime.now().millisecondsSinceEpoch % 10000}',
        items: state.cartItems
            .map(
              (item) => OrderItemModel(
                id: item.id,
                productId: item.productId,
                productName: item.productName,
                productImage: item.productImage,
                variantId: item.variantId,
                variantName: item.variantName,
                quantity: item.quantity,
                price: item.price,
                total: item.lineTotal,
              ),
            )
            .toList(),
        status: OrderStatus.pending,
        paymentStatus: state.paymentMethod == 'cod'
            ? PaymentStatus.pending
            : PaymentStatus.paid,
        paymentMethod: state.paymentMethod,
        shippingAddress: state.selectedAddress!,
        billingAddress: state.billingAddress,
        totals: OrderTotalsModel(
          subtotal: state.subtotal,
          discount: state.discount,
          shipping: state.shipping,
          total: state.total,
        ),
        couponCode: state.couponCode,
        notes: state.notes,
        createdAt: DateTime.now(),
      );

      emit(state.copyWith(status: CheckoutStatus.success, createdOrder: order));
    } catch (e) {
      emit(state.copyWith(status: CheckoutStatus.failed, error: e.toString()));
    }
  }

  /// Reset checkout
  void _onReset(CheckoutReset event, Emitter<CheckoutState> emit) {
    emit(const CheckoutState());
  }

  /// Calculate shipping based on address
  double _calculateShipping(AddressModel address) {
    // Dhaka divisions get lower shipping
    if (address.state.toLowerCase().contains('dhaka')) {
      return 80.0;
    }
    return 150.0;
  }
}
