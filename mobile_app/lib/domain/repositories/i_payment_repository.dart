/// Payment Repository Interface - Domain Layer
/// Defines all payment method and processing operations

import '../../core/utils/either.dart';
import '../../data/models/payment/payment_model.dart';

abstract class IPaymentRepository {
  /// Get saved payment methods
  Future<Result<List<PaymentMethodModel>>> getPaymentMethods();

  /// Get payment method by ID
  Future<Result<PaymentMethodModel>> getPaymentMethodById(String id);

  /// Add new payment method
  Future<Result<PaymentMethodModel>> addPaymentMethod({
    required PaymentMethodType type,
    required Map<String, dynamic> details,
    bool setAsDefault = false,
  });

  /// Update payment method
  Future<Result<PaymentMethodModel>> updatePaymentMethod({
    required String id,
    Map<String, dynamic>? details,
    bool? isDefault,
  });

  /// Delete payment method
  Future<Result<void>> deletePaymentMethod(String id);

  /// Set default payment method
  Future<Result<void>> setDefaultPaymentMethod(String id);

  /// Process payment for order
  Future<Result<PaymentResult>> processPayment({
    required String orderId,
    required String paymentMethodId,
    required double amount,
    String? currency,
  });

  /// Verify payment status
  Future<Result<PaymentStatus>> verifyPayment(String paymentId);

  /// Get payment history
  Future<Result<List<PaymentHistoryItem>>> getPaymentHistory({
    int page = 1,
    int perPage = 20,
  });

  /// Request refund
  Future<Result<RefundResult>> requestRefund({
    required String paymentId,
    required double amount,
    String? reason,
  });

  /// Get available payment methods for checkout
  Future<Result<List<PaymentOption>>> getAvailablePaymentOptions({
    required double amount,
    String? currency,
  });

  /// Initialize mobile wallet payment (bKash, Nagad, etc.)
  Future<Result<MobileWalletPayment>> initializeMobileWallet({
    required String provider,
    required double amount,
    required String orderId,
  });

  /// Complete mobile wallet payment
  Future<Result<PaymentResult>> completeMobileWalletPayment({
    required String paymentId,
    required String otp,
  });
}

// PaymentMethodType is defined in payment_model.dart

/// Payment result
class PaymentResult {
  final String paymentId;
  final String orderId;
  final PaymentStatus status;
  final double amount;
  final String? transactionId;
  final DateTime processedAt;
  final String? receiptUrl;
  final String? errorMessage;

  PaymentResult({
    required this.paymentId,
    required this.orderId,
    required this.status,
    required this.amount,
    this.transactionId,
    required this.processedAt,
    this.receiptUrl,
    this.errorMessage,
  });

  bool get isSuccessful => status == PaymentStatus.completed;
}

/// Payment status
enum PaymentStatus {
  pending,
  processing,
  completed,
  failed,
  cancelled,
  refunded,
  partiallyRefunded,
}

/// Payment history item
class PaymentHistoryItem {
  final String id;
  final String orderId;
  final double amount;
  final String currency;
  final PaymentMethodType method;
  final PaymentStatus status;
  final DateTime createdAt;
  final String? transactionId;

  PaymentHistoryItem({
    required this.id,
    required this.orderId,
    required this.amount,
    required this.currency,
    required this.method,
    required this.status,
    required this.createdAt,
    this.transactionId,
  });
}

/// Refund result
class RefundResult {
  final String refundId;
  final String paymentId;
  final double amount;
  final RefundStatus status;
  final DateTime createdAt;
  final DateTime? completedAt;

  RefundResult({
    required this.refundId,
    required this.paymentId,
    required this.amount,
    required this.status,
    required this.createdAt,
    this.completedAt,
  });
}

enum RefundStatus { pending, processing, completed, failed }

/// Available payment option at checkout
class PaymentOption {
  final PaymentMethodType type;
  final String name;
  final String? icon;
  final bool isAvailable;
  final String? unavailableReason;
  final double? fee;
  final double? minAmount;
  final double? maxAmount;

  PaymentOption({
    required this.type,
    required this.name,
    this.icon,
    required this.isAvailable,
    this.unavailableReason,
    this.fee,
    this.minAmount,
    this.maxAmount,
  });
}

/// Mobile wallet payment initialization
class MobileWalletPayment {
  final String paymentId;
  final String provider;
  final double amount;
  final String? redirectUrl;
  final String? qrCode;
  final DateTime expiresAt;

  MobileWalletPayment({
    required this.paymentId,
    required this.provider,
    required this.amount,
    this.redirectUrl,
    this.qrCode,
    required this.expiresAt,
  });
}
