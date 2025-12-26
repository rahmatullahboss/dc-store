import 'package:flutter/foundation.dart';

/// PaymentService - Handles payment processing
/// Supports multiple payment gateways (SSLCommerz, bKash, Nagad, etc.)
class PaymentService {
  static PaymentService? _instance;

  PaymentService._();

  static PaymentService get instance {
    _instance ??= PaymentService._();
    return _instance!;
  }

  /// Initialize payment service
  Future<void> initialize() async {
    // TODO: Initialize payment gateway SDKs
    debugPrint('PaymentService initialized');
  }

  // ═══════════════════════════════════════════════════════════════
  // PAYMENT METHODS
  // ═══════════════════════════════════════════════════════════════

  /// Get available payment methods
  List<PaymentMethod> getAvailablePaymentMethods() {
    return [
      const PaymentMethod(
        id: 'cod',
        name: 'Cash on Delivery',
        icon: 'assets/icons/cod.svg',
        type: PaymentType.cod,
      ),
      const PaymentMethod(
        id: 'bkash',
        name: 'bKash',
        icon: 'assets/icons/bkash.svg',
        type: PaymentType.mobileBanking,
      ),
      const PaymentMethod(
        id: 'nagad',
        name: 'Nagad',
        icon: 'assets/icons/nagad.svg',
        type: PaymentType.mobileBanking,
      ),
      const PaymentMethod(
        id: 'rocket',
        name: 'Rocket',
        icon: 'assets/icons/rocket.svg',
        type: PaymentType.mobileBanking,
      ),
      const PaymentMethod(
        id: 'card',
        name: 'Credit/Debit Card',
        icon: 'assets/icons/card.svg',
        type: PaymentType.card,
      ),
      const PaymentMethod(
        id: 'sslcommerz',
        name: 'SSLCommerz',
        icon: 'assets/icons/sslcommerz.svg',
        type: PaymentType.gateway,
      ),
    ];
  }

  // ═══════════════════════════════════════════════════════════════
  // PAYMENT PROCESSING
  // ═══════════════════════════════════════════════════════════════

  /// Process payment
  Future<PaymentResult> processPayment({
    required String orderId,
    required double amount,
    required String paymentMethodId,
    Map<String, dynamic>? metadata,
  }) async {
    debugPrint('Processing payment: $paymentMethodId for ৳$amount');

    try {
      switch (paymentMethodId) {
        case 'cod':
          return _processCOD(orderId, amount);
        case 'bkash':
          return _processBkash(orderId, amount);
        case 'nagad':
          return _processNagad(orderId, amount);
        case 'card':
        case 'sslcommerz':
          return _processSSLCommerz(orderId, amount);
        default:
          return PaymentResult.failure(message: 'Unsupported payment method');
      }
    } catch (e) {
      return PaymentResult.failure(message: e.toString());
    }
  }

  /// Process COD
  Future<PaymentResult> _processCOD(String orderId, double amount) async {
    // COD doesn't need actual payment processing
    return PaymentResult.success(
      transactionId: 'COD_$orderId',
      message: 'Cash on Delivery selected',
    );
  }

  /// Process bKash payment
  Future<PaymentResult> _processBkash(String orderId, double amount) async {
    // TODO: Implement bKash payment SDK
    await Future.delayed(const Duration(seconds: 2));
    return PaymentResult.success(
      transactionId: 'BK_${DateTime.now().millisecondsSinceEpoch}',
      message: 'bKash payment successful',
    );
  }

  /// Process Nagad payment
  Future<PaymentResult> _processNagad(String orderId, double amount) async {
    // TODO: Implement Nagad payment SDK
    await Future.delayed(const Duration(seconds: 2));
    return PaymentResult.success(
      transactionId: 'NG_${DateTime.now().millisecondsSinceEpoch}',
      message: 'Nagad payment successful',
    );
  }

  /// Process SSLCommerz payment
  Future<PaymentResult> _processSSLCommerz(
    String orderId,
    double amount,
  ) async {
    // TODO: Implement SSLCommerz SDK
    await Future.delayed(const Duration(seconds: 2));
    return PaymentResult.success(
      transactionId: 'SSL_${DateTime.now().millisecondsSinceEpoch}',
      message: 'SSLCommerz payment successful',
    );
  }

  // ═══════════════════════════════════════════════════════════════
  // CARD TOKENIZATION
  // ═══════════════════════════════════════════════════════════════

  /// Tokenize card for future use
  Future<CardToken?> tokenizeCard({
    required String cardNumber,
    required String expiryMonth,
    required String expiryYear,
    required String cvv,
    required String cardHolderName,
  }) async {
    // TODO: Implement card tokenization with payment gateway
    debugPrint(
      'Tokenizing card ending in ${cardNumber.substring(cardNumber.length - 4)}',
    );
    return null;
  }

  /// Get saved cards
  Future<List<SavedCard>> getSavedCards(String userId) async {
    // TODO: Fetch saved cards from API
    return [];
  }

  /// Delete saved card
  Future<bool> deleteSavedCard(String cardTokenId) async {
    // TODO: Delete card token from payment gateway
    return true;
  }

  // ═══════════════════════════════════════════════════════════════
  // REFUNDS
  // ═══════════════════════════════════════════════════════════════

  /// Request refund
  Future<RefundResult> requestRefund({
    required String transactionId,
    required double amount,
    String? reason,
  }) async {
    // TODO: Implement refund through payment gateway
    debugPrint('Refund requested for transaction: $transactionId');

    return RefundResult(
      success: true,
      refundId: 'REF_${DateTime.now().millisecondsSinceEpoch}',
      message: 'Refund initiated successfully',
    );
  }

  /// Get refund status
  Future<RefundStatus> getRefundStatus(String refundId) async {
    // TODO: Check refund status with payment gateway
    return RefundStatus.pending;
  }

  // ═══════════════════════════════════════════════════════════════
  // VERIFICATION
  // ═══════════════════════════════════════════════════════════════

  /// Verify payment
  Future<bool> verifyPayment(String transactionId) async {
    // TODO: Verify payment with payment gateway
    return true;
  }
}

// ═══════════════════════════════════════════════════════════════
// DATA CLASSES
// ═══════════════════════════════════════════════════════════════

enum PaymentType { cod, card, mobileBanking, gateway, wallet }

enum RefundStatus { pending, processing, completed, failed }

class PaymentMethod {
  final String id;
  final String name;
  final String icon;
  final PaymentType type;
  final bool isEnabled;

  const PaymentMethod({
    required this.id,
    required this.name,
    required this.icon,
    required this.type,
    this.isEnabled = true,
  });
}

class PaymentResult {
  final bool success;
  final String? transactionId;
  final String? message;
  final String? error;
  final Map<String, dynamic>? data;

  const PaymentResult({
    required this.success,
    this.transactionId,
    this.message,
    this.error,
    this.data,
  });

  factory PaymentResult.success({
    required String transactionId,
    String? message,
    Map<String, dynamic>? data,
  }) {
    return PaymentResult(
      success: true,
      transactionId: transactionId,
      message: message,
      data: data,
    );
  }

  factory PaymentResult.failure({required String message, String? error}) {
    return PaymentResult(success: false, message: message, error: error);
  }
}

class CardToken {
  final String tokenId;
  final String lastFourDigits;
  final String cardType;
  final String expiryMonth;
  final String expiryYear;

  const CardToken({
    required this.tokenId,
    required this.lastFourDigits,
    required this.cardType,
    required this.expiryMonth,
    required this.expiryYear,
  });
}

class SavedCard {
  final String id;
  final String tokenId;
  final String lastFourDigits;
  final String cardType;
  final String cardHolderName;
  final String expiryMonth;
  final String expiryYear;
  final bool isDefault;

  const SavedCard({
    required this.id,
    required this.tokenId,
    required this.lastFourDigits,
    required this.cardType,
    required this.cardHolderName,
    required this.expiryMonth,
    required this.expiryYear,
    this.isDefault = false,
  });
}

class RefundResult {
  final bool success;
  final String? refundId;
  final String? message;
  final String? error;

  const RefundResult({
    required this.success,
    this.refundId,
    this.message,
    this.error,
  });
}
