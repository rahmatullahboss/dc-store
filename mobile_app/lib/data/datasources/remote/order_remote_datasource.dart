/// Order Remote Data Source - API calls for orders
library;
import '../../../core/network/dio_client.dart';
import '../../../core/constants/api_constants.dart';
import '../../../core/errors/exceptions.dart';
import '../../models/order/order_model.dart';
import '../../models/common/pagination.dart';

abstract class IOrderRemoteDataSource {
  Future<(List<OrderModel>, PaginationModel)> getOrders({
    int page = 1,
    int perPage = 20,
    OrderStatus? status,
  });
  Future<OrderModel> getOrderById(String id);
  Future<OrderModel> createOrder({
    required String paymentMethodId,
    required String shippingAddressId,
    String? billingAddressId,
    String? notes,
  });
  Future<OrderModel> cancelOrder(String orderId, String? reason);
  Future<Map<String, dynamic>> trackOrder(String orderId);
  Future<void> reorder(String orderId);
  Future<String> getInvoice(String orderId);
}

class OrderRemoteDataSource implements IOrderRemoteDataSource {
  final DioClient _client;

  OrderRemoteDataSource({required DioClient client}) : _client = client;

  @override
  Future<(List<OrderModel>, PaginationModel)> getOrders({
    int page = 1,
    int perPage = 20,
    OrderStatus? status,
  }) async {
    final response = await _client.get<Map<String, dynamic>>(
      ApiConstants.orders,
      queryParameters: {
        'page': page,
        'perPage': perPage,
        if (status != null) 'status': status.name,
      },
    );

    if (!response.isSuccess || response.data == null) {
      throw ServerException(
        message: response.message ?? 'Failed to fetch orders',
        statusCode: response.error?.statusCode,
      );
    }

    final data = response.data!;
    final items = (data['orders'] as List? ?? data['data'] as List? ?? [])
        .map((item) => OrderModel.fromJson(item as Map<String, dynamic>))
        .toList();

    final pagination = data['pagination'] != null
        ? PaginationModel.fromJson(data['pagination'] as Map<String, dynamic>)
        : PaginationModel(currentPage: page, totalItems: items.length);

    return (items, pagination);
  }

  @override
  Future<OrderModel> getOrderById(String id) async {
    final response = await _client.get<Map<String, dynamic>>(
      '${ApiConstants.orders}/$id',
    );

    if (!response.isSuccess || response.data == null) {
      throw ServerException(
        message: response.message ?? 'Order not found',
        statusCode: response.error?.statusCode,
      );
    }

    final data = response.data!;
    return OrderModel.fromJson(data['order'] as Map<String, dynamic>? ?? data);
  }

  @override
  Future<OrderModel> createOrder({
    required String paymentMethodId,
    required String shippingAddressId,
    String? billingAddressId,
    String? notes,
  }) async {
    final response = await _client.post<Map<String, dynamic>>(
      ApiConstants.orders,
      data: {
        'paymentMethodId': paymentMethodId,
        'shippingAddressId': shippingAddressId,
        if (billingAddressId != null) 'billingAddressId': billingAddressId,
        if (notes != null) 'notes': notes,
      },
    );

    if (!response.isSuccess || response.data == null) {
      throw ServerException(
        message: response.message ?? 'Failed to create order',
        statusCode: response.error?.statusCode,
      );
    }

    final data = response.data!;
    return OrderModel.fromJson(data['order'] as Map<String, dynamic>? ?? data);
  }

  @override
  Future<OrderModel> cancelOrder(String orderId, String? reason) async {
    final response = await _client.post<Map<String, dynamic>>(
      '${ApiConstants.orders}/$orderId/cancel',
      data: {if (reason != null) 'reason': reason},
    );

    if (!response.isSuccess || response.data == null) {
      throw ServerException(
        message: response.message ?? 'Failed to cancel order',
        statusCode: response.error?.statusCode,
      );
    }

    final data = response.data!;
    return OrderModel.fromJson(data['order'] as Map<String, dynamic>? ?? data);
  }

  @override
  Future<Map<String, dynamic>> trackOrder(String orderId) async {
    final response = await _client.get<Map<String, dynamic>>(
      '${ApiConstants.orders}/$orderId/track',
    );

    if (!response.isSuccess || response.data == null) {
      throw ServerException(
        message: response.message ?? 'Failed to get tracking info',
        statusCode: response.error?.statusCode,
      );
    }

    return response.data!;
  }

  @override
  Future<void> reorder(String orderId) async {
    final response = await _client.post<Map<String, dynamic>>(
      '${ApiConstants.orders}/$orderId/reorder',
    );

    if (!response.isSuccess) {
      throw ServerException(
        message: response.message ?? 'Failed to reorder',
        statusCode: response.error?.statusCode,
      );
    }
  }

  @override
  Future<String> getInvoice(String orderId) async {
    final response = await _client.get<Map<String, dynamic>>(
      '${ApiConstants.orders}/$orderId/invoice',
    );

    if (!response.isSuccess || response.data == null) {
      throw ServerException(
        message: response.message ?? 'Failed to get invoice',
        statusCode: response.error?.statusCode,
      );
    }

    return response.data!['invoiceUrl'] as String;
  }
}
