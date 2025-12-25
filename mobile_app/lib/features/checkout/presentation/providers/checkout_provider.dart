import 'package:flutter_riverpod/flutter_riverpod.dart';

class CheckoutState {
  final bool isLoading;
  final String? error;

  CheckoutState({this.isLoading = false, this.error});

  CheckoutState copyWith({bool? isLoading, String? error}) {
    return CheckoutState(isLoading: isLoading ?? this.isLoading, error: error);
  }
}

class CheckoutController extends Notifier<CheckoutState> {
  @override
  CheckoutState build() {
    return CheckoutState();
  }

  Future<bool> placeOrder(Map<String, dynamic> orderData) async {
    state = CheckoutState(isLoading: true);
    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 2));

      // Success
      state = CheckoutState(isLoading: false);
      return true;
    } catch (e) {
      state = CheckoutState(isLoading: false, error: e.toString());
      return false;
    }
  }
}

final checkoutControllerProvider =
    NotifierProvider<CheckoutController, CheckoutState>(CheckoutController.new);
