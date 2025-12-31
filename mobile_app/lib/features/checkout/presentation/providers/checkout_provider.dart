import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Checkout state for payment selection
class CheckoutState {
  final String? paymentMethod; // 'cod' or 'stripe'
  final bool isLoading;
  final String? error;

  const CheckoutState({this.paymentMethod, this.isLoading = false, this.error});

  CheckoutState copyWith({
    String? paymentMethod,
    bool? isLoading,
    String? error,
    bool clearPaymentMethod = false,
    bool clearError = false,
  }) {
    return CheckoutState(
      paymentMethod: clearPaymentMethod
          ? null
          : (paymentMethod ?? this.paymentMethod),
      isLoading: isLoading ?? this.isLoading,
      error: clearError ? null : (error ?? this.error),
    );
  }
}

/// Checkout notifier for managing payment state
class CheckoutNotifier extends Notifier<CheckoutState> {
  @override
  CheckoutState build() {
    return const CheckoutState();
  }

  void setPaymentMethod(String method) {
    state = state.copyWith(paymentMethod: method, clearError: true);
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
