/// Payment Repository Implementation
library;
import '../../core/utils/either.dart';
import '../../core/errors/failures.dart';
import '../../core/errors/exceptions.dart';
import '../../core/network/network_info.dart';
import '../../domain/repositories/i_payment_repository.dart';
import '../datasources/remote/payment_remote_datasource.dart';
import '../models/payment/payment_model.dart';

class PaymentRepository implements IPaymentRepository {
  final IPaymentRemoteDataSource _remoteDataSource;
  final NetworkInfo _networkInfo;

  PaymentRepository({
    required IPaymentRemoteDataSource remoteDataSource,
    required NetworkInfo networkInfo,
  }) : _remoteDataSource = remoteDataSource,
       _networkInfo = networkInfo;

  @override
  Future<Result<List<PaymentMethodModel>>> getPaymentMethods() async {
    return tryCatch(() async {
      if (!await _networkInfo.isConnected) {
        throw NetworkException.noConnection();
      }
      return _remoteDataSource.getPaymentMethods();
    }, onError: _handleError);
  }

  @override
  Future<Result<PaymentMethodModel>> getPaymentMethodById(String id) async {
    return tryCatch(() async {
      final methods = await getPaymentMethods();
      return methods.fold(
        ifLeft: (failure) => throw failure,
        ifRight: (list) {
          final method = list.where((m) => m.id == id).firstOrNull;
          if (method == null) {
            throw ServerException.notFound();
          }
          return method;
        },
      );
    }, onError: _handleError);
  }

  @override
  Future<Result<PaymentMethodModel>> addPaymentMethod({
    required PaymentMethodType type,
    required Map<String, dynamic> details,
    bool setAsDefault = false,
  }) async {
    return tryCatch(() async {
      if (!await _networkInfo.isConnected) {
        throw NetworkException.noConnection();
      }
      return _remoteDataSource.addPaymentMethod(
        type: type,
        details: details,
        setAsDefault: setAsDefault,
      );
    }, onError: _handleError);
  }

  @override
  Future<Result<PaymentMethodModel>> updatePaymentMethod({
    required String id,
    Map<String, dynamic>? details,
    bool? isDefault,
  }) async {
    return tryCatch(() async {
      throw UnimplementedError('Update payment method not implemented');
    }, onError: _handleError);
  }

  @override
  Future<Result<void>> deletePaymentMethod(String id) async {
    return tryCatch(() async {
      if (!await _networkInfo.isConnected) {
        throw NetworkException.noConnection();
      }
      await _remoteDataSource.deletePaymentMethod(id);
    }, onError: _handleError);
  }

  @override
  Future<Result<void>> setDefaultPaymentMethod(String id) async {
    return tryCatch(() async {
      if (!await _networkInfo.isConnected) {
        throw NetworkException.noConnection();
      }
      await _remoteDataSource.setDefaultPaymentMethod(id);
    }, onError: _handleError);
  }

  @override
  Future<Result<PaymentResult>> processPayment({
    required String orderId,
    required String paymentMethodId,
    required double amount,
    String? currency,
  }) async {
    return tryCatch(() async {
      if (!await _networkInfo.isConnected) {
        throw NetworkException.noConnection();
      }

      final data = await _remoteDataSource.processPayment(
        orderId: orderId,
        paymentMethodId: paymentMethodId,
        amount: amount,
        currency: currency,
      );

      return PaymentResult(
        paymentId: data['paymentId'] as String,
        orderId: orderId,
        status: PaymentStatus.values.firstWhere(
          (s) => s.name == data['status'],
          orElse: () => PaymentStatus.pending,
        ),
        amount: amount,
        transactionId: data['transactionId'] as String?,
        processedAt: data['processedAt'] != null
            ? DateTime.parse(data['processedAt'] as String)
            : DateTime.now(),
        receiptUrl: data['receiptUrl'] as String?,
        errorMessage: data['errorMessage'] as String?,
      );
    }, onError: _handleError);
  }

  @override
  Future<Result<PaymentStatus>> verifyPayment(String paymentId) async {
    return tryCatch(() async {
      throw UnimplementedError('Verify payment not implemented');
    }, onError: _handleError);
  }

  @override
  Future<Result<List<PaymentHistoryItem>>> getPaymentHistory({
    int page = 1,
    int perPage = 20,
  }) async {
    return tryCatch(() async {
      throw UnimplementedError('Payment history not implemented');
    }, onError: _handleError);
  }

  @override
  Future<Result<RefundResult>> requestRefund({
    required String paymentId,
    required double amount,
    String? reason,
  }) async {
    return tryCatch(() async {
      throw UnimplementedError('Refund request not implemented');
    }, onError: _handleError);
  }

  @override
  Future<Result<List<PaymentOption>>> getAvailablePaymentOptions({
    required double amount,
    String? currency,
  }) async {
    return tryCatch(() async {
      if (!await _networkInfo.isConnected) {
        throw NetworkException.noConnection();
      }
      return _remoteDataSource.getAvailablePaymentOptions(
        amount: amount,
        currency: currency,
      );
    }, onError: _handleError);
  }

  @override
  Future<Result<MobileWalletPayment>> initializeMobileWallet({
    required String provider,
    required double amount,
    required String orderId,
  }) async {
    return tryCatch(() async {
      if (!await _networkInfo.isConnected) {
        throw NetworkException.noConnection();
      }

      final data = await _remoteDataSource.initializeMobileWallet(
        provider: provider,
        amount: amount,
        orderId: orderId,
      );

      return MobileWalletPayment(
        paymentId: data['paymentId'] as String,
        provider: provider,
        amount: amount,
        redirectUrl: data['redirectUrl'] as String?,
        qrCode: data['qrCode'] as String?,
        expiresAt: DateTime.parse(data['expiresAt'] as String),
      );
    }, onError: _handleError);
  }

  @override
  Future<Result<PaymentResult>> completeMobileWalletPayment({
    required String paymentId,
    required String otp,
  }) async {
    return tryCatch(() async {
      throw UnimplementedError(
        'Complete mobile wallet payment not implemented',
      );
    }, onError: _handleError);
  }

  Failure _handleError(Object error, StackTrace stack) {
    if (error is NetworkException) {
      return NetworkFailure(error.message);
    } else if (error is ServerException) {
      return ServerFailure(error.message);
    }
    return ServerFailure(error.toString());
  }
}
