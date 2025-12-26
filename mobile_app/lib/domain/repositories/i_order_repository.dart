/// Order Repository Interface - Domain Layer
/// Defines all order-related operations

import '../../core/utils/either.dart';
import '../../data/models/order/order_model.dart';
import '../../data/models/common/pagination.dart';

abstract class IOrderRepository {
  /// Get user's orders with pagination
  Future<Result<PaginatedResponse<OrderModel>>> getOrders({
    int page = 1,
    int perPage = 20,
    OrderStatus? status,
  });

  /// Get single order by ID
  Future<Result<OrderModel>> getOrderById(String id);

  /// Create new order from cart
  Future<Result<OrderModel>> createOrder({
    required String paymentMethodId,
    required String shippingAddressId,
    String? billingAddressId,
    String? notes,
  });

  /// Cancel an order
  Future<Result<OrderModel>> cancelOrder({
    required String orderId,
    String? reason,
  });

  /// Track order shipment
  Future<Result<OrderTrackingInfo>> trackOrder(String orderId);

  /// Reorder from previous order
  Future<Result<void>> reorder(String orderId);

  /// Get order invoice
  Future<Result<String>> getInvoice(String orderId);

  /// Request return/refund
  Future<Result<ReturnRequest>> requestReturn({
    required String orderId,
    required List<String> itemIds,
    required String reason,
    String? description,
  });

  /// Get return request status
  Future<Result<ReturnRequest>> getReturnStatus(String returnId);

  /// Rate delivered order
  Future<Result<void>> rateOrder({
    required String orderId,
    required int rating,
    String? feedback,
  });

  /// Refresh orders cache
  Future<void> refreshCache();

  /// Clear orders cache
  Future<void> clearCache();
}

/// Order tracking information
class OrderTrackingInfo {
  final String orderId;
  final String currentStatus;
  final List<TrackingEvent> events;
  final String? trackingNumber;
  final String? carrier;
  final String? trackingUrl;
  final DateTime? estimatedDelivery;

  OrderTrackingInfo({
    required this.orderId,
    required this.currentStatus,
    required this.events,
    this.trackingNumber,
    this.carrier,
    this.trackingUrl,
    this.estimatedDelivery,
  });
}

/// Tracking event
class TrackingEvent {
  final String status;
  final String description;
  final DateTime timestamp;
  final String? location;

  TrackingEvent({
    required this.status,
    required this.description,
    required this.timestamp,
    this.location,
  });
}

/// Return request
class ReturnRequest {
  final String id;
  final String orderId;
  final List<String> itemIds;
  final String reason;
  final String? description;
  final ReturnStatus status;
  final DateTime createdAt;
  final DateTime? resolvedAt;
  final double? refundAmount;

  ReturnRequest({
    required this.id,
    required this.orderId,
    required this.itemIds,
    required this.reason,
    this.description,
    required this.status,
    required this.createdAt,
    this.resolvedAt,
    this.refundAmount,
  });
}

enum ReturnStatus { pending, approved, rejected, processing, completed }
