import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:http/http.dart' as http;
import '../core/config/app_config.dart';

/// PaymentService - Handles payment processing with Stripe
/// Supports multiple payment methods including cards, mobile banking (bKash, Nagad)
class PaymentService {
  static PaymentService? _instance;
  static bool _stripeInitialized = false;

  PaymentService._();

  static PaymentService get instance {
    _instance ??= PaymentService._();
    return _instance!;
  }

  /// Initialize payment service with Stripe
  Future<void> initialize({required String stripePublishableKey}) async {
    if (!_stripeInitialized) {
      Stripe.publishableKey = stripePublishableKey;
      await Stripe.instance.applySettings();
      _stripeInitialized = true;
      debugPrint('PaymentService initialized with Stripe');
    }
  }

  // ═══════════════════════════════════════════════════════════════
  // PAYMENT METHODS
  // ═══════════════════════════════════════════════════════════════

  /// Get available payment methods
  List<PaymentMethod> getAvailablePaymentMethods() {
    return [
      const PaymentMethod(
        id: 'stripe',
        name: 'Credit/Debit Card',
        icon: 'assets/icons/card.svg',
        type: PaymentType.card,
      ),
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
    ];
  }

  // ═══════════════════════════════════════════════════════════════
  // STRIPE PAYMENT
  // ═══════════════════════════════════════════════════════════════

  /// Create payment intent on server
  Future<Map<String, dynamic>?> _createPaymentIntent({
    required double amount,
    required String currency,
    String? customerId,
    Map<String, dynamic>? metadata,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('${AppConfig.baseUrl}/api/payments/create-intent'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'amount': (amount * 100).toInt(), // Convert to smallest currency unit
          'currency': currency.toLowerCase(),
          'customerId': customerId,
          'metadata': metadata,
        }),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body) as Map<String, dynamic>;
      }
      debugPrint('Failed to create payment intent: ${response.statusCode}');
      return null;
    } catch (e) {
      debugPrint('Error creating payment intent: $e');
      return null;
    }
  }

  /// Process Stripe payment using Payment Sheet
  Future<PaymentResult> processStripePayment({
    required String orderId,
    required double amount,
    String currency = 'BDT',
    String? customerId,
    String? customerEmail,
  }) async {
    try {
      // 1. Create payment intent on server
      final intentData = await _createPaymentIntent(
        amount: amount,
        currency: currency,
        customerId: customerId,
        metadata: {'orderId': orderId},
      );

      if (intentData == null) {
        return PaymentResult.failure(
          message: 'Failed to create payment intent',
        );
      }

      final clientSecret = intentData['clientSecret'] as String?;
      final ephemeralKey = intentData['ephemeralKey'] as String?;
      final stripeCustomerId = intentData['customerId'] as String?;

      if (clientSecret == null) {
        return PaymentResult.failure(
          message: 'Invalid payment intent response',
        );
      }

      // 2. Initialize payment sheet
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: clientSecret,
          merchantDisplayName: 'DC Store',
          customerEphemeralKeySecret: ephemeralKey,
          customerId: stripeCustomerId,
          style: ThemeMode.system,
          billingDetails: BillingDetails(email: customerEmail),
        ),
      );

      // 3. Present payment sheet
      await Stripe.instance.presentPaymentSheet();

      // 4. Payment successful
      return PaymentResult.success(
        transactionId:
            intentData['paymentIntentId'] as String? ??
            'STRIPE_${DateTime.now().millisecondsSinceEpoch}',
        message: 'Payment successful',
      );
    } on StripeException catch (e) {
      debugPrint('Stripe error: ${e.error.localizedMessage}');
      if (e.error.code == FailureCode.Canceled) {
        return PaymentResult.failure(message: 'Payment cancelled');
      }
      return PaymentResult.failure(
        message: e.error.localizedMessage ?? 'Payment failed',
      );
    } catch (e) {
      debugPrint('Payment error: $e');
      return PaymentResult.failure(message: 'Payment processing error');
    }
  }

  // ═══════════════════════════════════════════════════════════════
  // PAYMENT PROCESSING
  // ═══════════════════════════════════════════════════════════════

  /// Process payment based on method
  Future<PaymentResult> processPayment({
    required String orderId,
    required double amount,
    required String paymentMethodId,
    String? customerEmail,
    Map<String, dynamic>? metadata,
  }) async {
    debugPrint('Processing payment: $paymentMethodId for ৳$amount');

    try {
      switch (paymentMethodId) {
        case 'stripe':
        case 'card':
          return processStripePayment(
            orderId: orderId,
            amount: amount,
            customerEmail: customerEmail,
          );
        case 'cod':
          return _processCOD(orderId, amount);
        case 'bkash':
          return _processBkash(orderId, amount);
        case 'nagad':
          return _processNagad(orderId, amount);
        default:
          return PaymentResult.failure(message: 'Unsupported payment method');
      }
    } catch (e) {
      return PaymentResult.failure(message: e.toString());
    }
  }

  /// Process COD
  Future<PaymentResult> _processCOD(String orderId, double amount) async {
    return PaymentResult.success(
      transactionId: 'COD_$orderId',
      message: 'Cash on Delivery selected',
    );
  }

  /// Process bKash payment
  Future<PaymentResult> _processBkash(String orderId, double amount) async {
    // bKash SDK integration would go here
    // For now, we'll redirect to a webview-based flow
    await Future.delayed(const Duration(seconds: 1));
    return PaymentResult.pending(
      message: 'bKash payment initiated - complete on bKash app',
    );
  }

  /// Process Nagad payment
  Future<PaymentResult> _processNagad(String orderId, double amount) async {
    // Nagad SDK integration would go here
    await Future.delayed(const Duration(seconds: 1));
    return PaymentResult.pending(
      message: 'Nagad payment initiated - complete on Nagad app',
    );
  }

  // ═══════════════════════════════════════════════════════════════
  // REFUNDS
  // ═══════════════════════════════════════════════════════════════

  /// Request refund
  Future<PaymentResult> requestRefund({
    required String transactionId,
    required double amount,
    String? reason,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('${AppConfig.baseUrl}/api/payments/refund'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'transactionId': transactionId,
          'amount': (amount * 100).toInt(),
          'reason': reason,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return PaymentResult.success(
          transactionId: data['refundId'] ?? transactionId,
          message: 'Refund processed successfully',
        );
      }
      return PaymentResult.failure(message: 'Refund failed');
    } catch (e) {
      return PaymentResult.failure(message: e.toString());
    }
  }

  // ═══════════════════════════════════════════════════════════════
  // PAYMENT VERIFICATION
  // ═══════════════════════════════════════════════════════════════

  /// Verify payment status
  Future<PaymentStatus> verifyPayment(String transactionId) async {
    try {
      final response = await http.get(
        Uri.parse('${AppConfig.baseUrl}/api/payments/verify/$transactionId'),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final status = data['status'] as String?;
        switch (status) {
          case 'succeeded':
            return PaymentStatus.completed;
          case 'pending':
          case 'processing':
            return PaymentStatus.pending;
          case 'failed':
            return PaymentStatus.failed;
          case 'refunded':
            return PaymentStatus.refunded;
          default:
            return PaymentStatus.unknown;
        }
      }
      return PaymentStatus.unknown;
    } catch (e) {
      debugPrint('Error verifying payment: $e');
      return PaymentStatus.unknown;
    }
  }
}

// ═══════════════════════════════════════════════════════════════
// DATA CLASSES
// ═══════════════════════════════════════════════════════════════

enum PaymentType { cod, card, mobileBanking, gateway }

enum PaymentStatus { pending, processing, completed, failed, refunded, unknown }

class PaymentMethod {
  final String id;
  final String name;
  final String icon;
  final PaymentType type;
  final String? description;
  final bool isEnabled;

  const PaymentMethod({
    required this.id,
    required this.name,
    required this.icon,
    required this.type,
    this.description,
    this.isEnabled = true,
  });
}

class PaymentResult {
  final bool success;
  final bool pending;
  final String? transactionId;
  final String? message;
  final Map<String, dynamic>? data;

  const PaymentResult._({
    required this.success,
    this.pending = false,
    this.transactionId,
    this.message,
    this.data,
  });

  factory PaymentResult.success({
    required String transactionId,
    String? message,
    Map<String, dynamic>? data,
  }) => PaymentResult._(
    success: true,
    transactionId: transactionId,
    message: message,
    data: data,
  );

  factory PaymentResult.failure({
    String? message,
    Map<String, dynamic>? data,
  }) => PaymentResult._(success: false, message: message, data: data);

  factory PaymentResult.pending({
    String? message,
    Map<String, dynamic>? data,
  }) => PaymentResult._(
    success: false,
    pending: true,
    message: message,
    data: data,
  );
}
