import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../data/models/address/address_model.dart';

/// Checkout state for payment and address selection
class CheckoutState {
  final String? paymentMethod; // 'cod' or 'stripe'
  final AddressModel? selectedAddress; // Selected shipping address
  final bool isLoading;
  final String? error;

  const CheckoutState({
    this.paymentMethod,
    this.selectedAddress,
    this.isLoading = false,
    this.error,
  });

  CheckoutState copyWith({
    String? paymentMethod,
    AddressModel? selectedAddress,
    bool? isLoading,
    String? error,
    bool clearPaymentMethod = false,
    bool clearSelectedAddress = false,
    bool clearError = false,
  }) {
    return CheckoutState(
      paymentMethod: clearPaymentMethod
          ? null
          : (paymentMethod ?? this.paymentMethod),
      selectedAddress: clearSelectedAddress
          ? null
          : (selectedAddress ?? this.selectedAddress),
      isLoading: isLoading ?? this.isLoading,
      error: clearError ? null : (error ?? this.error),
    );
  }
}

/// Checkout notifier for managing payment and address state
class CheckoutNotifier extends Notifier<CheckoutState> {
  @override
  CheckoutState build() {
    return const CheckoutState();
  }

  void setPaymentMethod(String method) {
    state = state.copyWith(paymentMethod: method, clearError: true);
  }

  void setSelectedAddress(AddressModel address) {
    state = state.copyWith(selectedAddress: address, clearError: true);
  }

  void setLoading(bool value) {
    state = state.copyWith(isLoading: value);
  }

  void setError(String? error) {
    state = state.copyWith(error: error, isLoading: false);
  }

  void reset() {
    state = const CheckoutState();
  }
}

final checkoutProvider = NotifierProvider<CheckoutNotifier, CheckoutState>(
  CheckoutNotifier.new,
);

// Legacy provider for backward compatibility
final checkoutControllerProvider = checkoutProvider;
