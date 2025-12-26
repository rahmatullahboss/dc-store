/// Payment Remote Data Source - API calls for payments
library;
import '../../../core/network/dio_client.dart';
import '../../../core/constants/api_constants.dart';
import '../../../core/errors/exceptions.dart';
import '../../models/payment/payment_model.dart';
import '../../../domain/repositories/i_payment_repository.dart';

abstract class IPaymentRemoteDataSource {
  Future<List<PaymentMethodModel>> getPaymentMethods();
  Future<PaymentMethodModel> addPaymentMethod({
    required PaymentMethodType type,
    required Map<String, dynamic> details,
    bool setAsDefault = false,
  });
  Future<void> deletePaymentMethod(String id);
  Future<void> setDefaultPaymentMethod(String id);
  Future<Map<String, dynamic>> processPayment({
    required String orderId,
    required String paymentMethodId,
    required double amount,
    String? currency,
  });
  Future<Map<String, dynamic>> initializeMobileWallet({
    required String provider,
    required double amount,
    required String orderId,
  });
  Future<List<PaymentOption>> getAvailablePaymentOptions({
    required double amount,
    String? currency,
  });
}

class PaymentRemoteDataSource implements IPaymentRemoteDataSource {
  final DioClient _client;

  PaymentRemoteDataSource({required DioClient client}) : _client = client;

  @override
  Future<List<PaymentMethodModel>> getPaymentMethods() async {
    final response = await _client.get<Map<String, dynamic>>(
      ApiConstants.paymentMethods,
    );

    if (!response.isSuccess || response.data == null) {
      throw ServerException(
        message: response.message ?? 'Failed to fetch payment methods',
        statusCode: response.error?.statusCode,
      );
    }

    final data = response.data!;
    return (data['paymentMethods'] as List? ?? data['data'] as List? ?? [])
        .map(
          (item) => PaymentMethodModel.fromJson(item as Map<String, dynamic>),
        )
        .toList();
  }

  @override
  Future<PaymentMethodModel> addPaymentMethod({
    required PaymentMethodType type,
    required Map<String, dynamic> details,
    bool setAsDefault = false,
  }) async {
    final response = await _client.post<Map<String, dynamic>>(
      ApiConstants.paymentMethods,
      data: {'type': type.name, 'details': details, 'isDefault': setAsDefault},
    );

    if (!response.isSuccess || response.data == null) {
      throw ServerException(
        message: response.message ?? 'Failed to add payment method',
        statusCode: response.error?.statusCode,
      );
    }

    final data = response.data!;
    return PaymentMethodModel.fromJson(
      data['paymentMethod'] as Map<String, dynamic>? ?? data,
    );
  }

  @override
  Future<void> deletePaymentMethod(String id) async {
    final response = await _client.delete<Map<String, dynamic>>(
      '${ApiConstants.paymentMethods}/$id',
    );

    if (!response.isSuccess) {
      throw ServerException(
        message: response.message ?? 'Failed to delete payment method',
        statusCode: response.error?.statusCode,
      );
    }
  }

  @override
  Future<void> setDefaultPaymentMethod(String id) async {
    final response = await _client.patch<Map<String, dynamic>>(
      '${ApiConstants.paymentMethods}/$id/default',
    );

    if (!response.isSuccess) {
      throw ServerException(
        message: response.message ?? 'Failed to set default payment method',
        statusCode: response.error?.statusCode,
      );
    }
  }

  @override
  Future<Map<String, dynamic>> processPayment({
    required String orderId,
    required String paymentMethodId,
    required double amount,
    String? currency,
  }) async {
    final response = await _client.post<Map<String, dynamic>>(
      ApiConstants.payments,
      data: {
        'orderId': orderId,
        'paymentMethodId': paymentMethodId,
        'amount': amount,
        'currency': currency ?? 'BDT',
      },
    );

    if (!response.isSuccess || response.data == null) {
      throw ServerException(
        message: response.message ?? 'Payment failed',
        statusCode: response.error?.statusCode,
      );
    }

    return response.data!;
  }

  @override
  Future<Map<String, dynamic>> initializeMobileWallet({
    required String provider,
    required double amount,
    required String orderId,
  }) async {
    final response = await _client.post<Map<String, dynamic>>(
      '${ApiConstants.payments}/mobile-wallet/init',
      data: {'provider': provider, 'amount': amount, 'orderId': orderId},
    );

    if (!response.isSuccess || response.data == null) {
      throw ServerException(
        message: response.message ?? 'Failed to initialize mobile wallet',
        statusCode: response.error?.statusCode,
      );
    }

    return response.data!;
  }

  @override
  Future<List<PaymentOption>> getAvailablePaymentOptions({
    required double amount,
    String? currency,
  }) async {
    final response = await _client.get<Map<String, dynamic>>(
      '${ApiConstants.payments}/options',
      queryParameters: {'amount': amount, 'currency': currency ?? 'BDT'},
    );

    if (!response.isSuccess || response.data == null) {
      throw ServerException(
        message: response.message ?? 'Failed to fetch payment options',
        statusCode: response.error?.statusCode,
      );
    }

    final data = response.data!;
    return (data['options'] as List? ?? []).map((item) {
      final option = item as Map<String, dynamic>;
      return PaymentOption(
        type: PaymentMethodType.values.firstWhere(
          (t) => t.name == option['type'],
          orElse: () => PaymentMethodType.cashOnDelivery,
        ),
        name: option['name'] as String,
        icon: option['icon'] as String?,
        isAvailable: option['isAvailable'] as bool? ?? true,
        unavailableReason: option['unavailableReason'] as String?,
        fee: (option['fee'] as num?)?.toDouble(),
        minAmount: (option['minAmount'] as num?)?.toDouble(),
        maxAmount: (option['maxAmount'] as num?)?.toDouble(),
      );
    }).toList();
  }
}
