import 'package:freezed_annotation/freezed_annotation.dart';
import '../user/user_model.dart';

part 'order_model.freezed.dart';
part 'order_model.g.dart';

/// Order Status Enum
enum OrderStatus {
  pending,
  confirmed,
  processing,
  shipped,
  outForDelivery,
  delivered,
  cancelled,
  returned,
  refunded;

  String get displayName {
    switch (this) {
      case OrderStatus.pending:
        return 'Pending';
      case OrderStatus.confirmed:
        return 'Confirmed';
      case OrderStatus.processing:
        return 'Processing';
      case OrderStatus.shipped:
        return 'Shipped';
      case OrderStatus.outForDelivery:
        return 'Out for Delivery';
      case OrderStatus.delivered:
        return 'Delivered';
      case OrderStatus.cancelled:
        return 'Cancelled';
      case OrderStatus.returned:
        return 'Returned';
      case OrderStatus.refunded:
        return 'Refunded';
    }
  }

  bool get isActive =>
      this != OrderStatus.cancelled &&
      this != OrderStatus.returned &&
      this != OrderStatus.refunded;
}

/// Payment Status Enum
enum PaymentStatus {
  pending,
  paid,
  failed,
  refunded,
  partiallyRefunded;

  String get displayName {
    switch (this) {
      case PaymentStatus.pending:
        return 'Pending';
      case PaymentStatus.paid:
        return 'Paid';
      case PaymentStatus.failed:
        return 'Failed';
      case PaymentStatus.refunded:
        return 'Refunded';
      case PaymentStatus.partiallyRefunded:
        return 'Partially Refunded';
    }
  }
}

/// Order Model - Complete order representation
@freezed
class OrderModel with _$OrderModel {
  const factory OrderModel({
    required String id,
    required String orderNumber,
    required List<OrderItemModel> items,
    @Default(OrderStatus.pending) OrderStatus status,
    @Default(PaymentStatus.pending) PaymentStatus paymentStatus,
    String? paymentMethod,
    String? transactionId,
    required AddressModel shippingAddress,
    AddressModel? billingAddress,
    OrderTrackingModel? tracking,
    @Default([]) List<OrderTimelineModel> timeline,
    required OrderTotalsModel totals,
    String? couponCode,
    double? couponDiscount,
    String? notes,
    String? customerNotes,
    DateTime? estimatedDelivery,
    required DateTime createdAt,
    DateTime? updatedAt,
    DateTime? deliveredAt,
  }) = _OrderModel;

  const OrderModel._();

  factory OrderModel.fromJson(Map<String, dynamic> json) =>
      _$OrderModelFromJson(json);

  /// Total items in order
  int get itemCount => items.fold(0, (sum, item) => sum + item.quantity);

  /// Check if can be cancelled
  bool get canCancel =>
      status == OrderStatus.pending || status == OrderStatus.confirmed;

  /// Check if can be returned
  bool get canReturn =>
      status == OrderStatus.delivered &&
      deliveredAt != null &&
      DateTime.now().difference(deliveredAt!).inDays <= 7;
}

/// Order Item Model
@freezed
class OrderItemModel with _$OrderItemModel {
  const factory OrderItemModel({
    required String id,
    required String productId,
    required String productName,
    String? productImage,
    String? variantId,
    String? variantName,
    Map<String, String>? attributes,
    required int quantity,
    required double price,
    double? compareAtPrice,
    required double total,
    String? sku,
  }) = _OrderItemModel;

  factory OrderItemModel.fromJson(Map<String, dynamic> json) =>
      _$OrderItemModelFromJson(json);
}

/// Order Totals Model
@freezed
class OrderTotalsModel with _$OrderTotalsModel {
  const factory OrderTotalsModel({
    required double subtotal,
    @Default(0.0) double discount,
    @Default(0.0) double shipping,
    @Default(0.0) double tax,
    required double total,
  }) = _OrderTotalsModel;

  factory OrderTotalsModel.fromJson(Map<String, dynamic> json) =>
      _$OrderTotalsModelFromJson(json);
}

/// Order Tracking Model
@freezed
class OrderTrackingModel with _$OrderTrackingModel {
  const factory OrderTrackingModel({
    String? trackingNumber,
    String? carrier,
    String? trackingUrl,
    String? currentLocation,
    DateTime? lastUpdate,
  }) = _OrderTrackingModel;

  factory OrderTrackingModel.fromJson(Map<String, dynamic> json) =>
      _$OrderTrackingModelFromJson(json);
}

/// Order Timeline Model
@freezed
class OrderTimelineModel with _$OrderTimelineModel {
  const factory OrderTimelineModel({
    required String status,
    required String title,
    String? description,
    required DateTime timestamp,
    String? icon,
    @Default(false) bool isCompleted,
  }) = _OrderTimelineModel;

  factory OrderTimelineModel.fromJson(Map<String, dynamic> json) =>
      _$OrderTimelineModelFromJson(json);
}
