/// Order Repository Implementation
library;
import '../../core/utils/either.dart';
import '../../core/errors/failures.dart';
import '../../core/errors/exceptions.dart';
import '../../core/network/network_info.dart';
import '../../domain/repositories/i_order_repository.dart';
import '../datasources/remote/order_remote_datasource.dart';
import '../models/order/order_model.dart';
import '../models/common/pagination.dart';

class OrderRepository implements IOrderRepository {
  final IOrderRemoteDataSource _remoteDataSource;
  final NetworkInfo _networkInfo;

  OrderRepository({
    required IOrderRemoteDataSource remoteDataSource,
    required NetworkInfo networkInfo,
  }) : _remoteDataSource = remoteDataSource,
       _networkInfo = networkInfo;

  @override
  Future<Result<PaginatedResponse<OrderModel>>> getOrders({
    int page = 1,
    int perPage = 20,
    OrderStatus? status,
  }) async {
    return tryCatch(() async {
      if (!await _networkInfo.isConnected) {
        throw NetworkException.noConnection();
      }

      final (orders, pagination) = await _remoteDataSource.getOrders(
        page: page,
        perPage: perPage,
        status: status,
      );

      return PaginatedResponse(items: orders, pagination: pagination);
    }, onError: _handleError);
  }

  @override
  Future<Result<OrderModel>> getOrderById(String id) async {
    return tryCatch(() async {
      if (!await _networkInfo.isConnected) {
        throw NetworkException.noConnection();
      }
      return _remoteDataSource.getOrderById(id);
    }, onError: _handleError);
  }

  @override
  Future<Result<OrderModel>> createOrder({
    required String paymentMethodId,
    required String shippingAddressId,
    String? billingAddressId,
    String? notes,
  }) async {
    return tryCatch(() async {
      if (!await _networkInfo.isConnected) {
        throw NetworkException.noConnection();
      }

      return _remoteDataSource.createOrder(
        paymentMethodId: paymentMethodId,
        shippingAddressId: shippingAddressId,
        billingAddressId: billingAddressId,
        notes: notes,
      );
    }, onError: _handleError);
  }

  @override
  Future<Result<OrderModel>> cancelOrder({
    required String orderId,
    String? reason,
  }) async {
    return tryCatch(() async {
      if (!await _networkInfo.isConnected) {
        throw NetworkException.noConnection();
      }
      return _remoteDataSource.cancelOrder(orderId, reason);
    }, onError: _handleError);
  }

  @override
  Future<Result<OrderTrackingInfo>> trackOrder(String orderId) async {
    return tryCatch(() async {
      if (!await _networkInfo.isConnected) {
        throw NetworkException.noConnection();
      }

      final data = await _remoteDataSource.trackOrder(orderId);

      return OrderTrackingInfo(
        orderId: orderId,
        currentStatus: data['status'] as String? ?? 'unknown',
        events: (data['events'] as List? ?? []).map((e) {
          final event = e as Map<String, dynamic>;
          return TrackingEvent(
            status: event['status'] as String,
            description: event['description'] as String,
            timestamp: DateTime.parse(event['timestamp'] as String),
            location: event['location'] as String?,
          );
        }).toList(),
        trackingNumber: data['trackingNumber'] as String?,
        carrier: data['carrier'] as String?,
        trackingUrl: data['trackingUrl'] as String?,
        estimatedDelivery: data['estimatedDelivery'] != null
            ? DateTime.parse(data['estimatedDelivery'] as String)
            : null,
      );
    }, onError: _handleError);
  }

  @override
  Future<Result<void>> reorder(String orderId) async {
    return tryCatch(() async {
      if (!await _networkInfo.isConnected) {
        throw NetworkException.noConnection();
      }
      await _remoteDataSource.reorder(orderId);
    }, onError: _handleError);
  }

  @override
  Future<Result<String>> getInvoice(String orderId) async {
    return tryCatch(() async {
      if (!await _networkInfo.isConnected) {
        throw NetworkException.noConnection();
      }
      return _remoteDataSource.getInvoice(orderId);
    }, onError: _handleError);
  }

  @override
  Future<Result<ReturnRequest>> requestReturn({
    required String orderId,
    required List<String> itemIds,
    required String reason,
    String? description,
  }) async {
    return tryCatch(() async {
      throw UnimplementedError('Return request not implemented');
    }, onError: _handleError);
  }

  @override
  Future<Result<ReturnRequest>> getReturnStatus(String returnId) async {
    return tryCatch(() async {
      throw UnimplementedError('Return status not implemented');
    }, onError: _handleError);
  }

  @override
  Future<Result<void>> rateOrder({
    required String orderId,
    required int rating,
    String? feedback,
  }) async {
    return tryCatch(() async {
      throw UnimplementedError('Order rating not implemented');
    }, onError: _handleError);
  }

  @override
  Future<void> refreshCache() async {}

  @override
  Future<void> clearCache() async {}

  Failure _handleError(Object error, StackTrace stack) {
    if (error is NetworkException) {
      return NetworkFailure(error.message);
    } else if (error is ServerException) {
      return ServerFailure(error.message);
    }
    return ServerFailure(error.toString());
  }
}
