part of 'order_bloc.dart';

/// Order Events
sealed class OrderEvent {
  const OrderEvent();
}

/// Fetch order history
final class OrdersFetchRequested extends OrderEvent {
  final OrderStatus? filterStatus;

  const OrdersFetchRequested({this.filterStatus});
}

/// Load more orders
final class OrdersLoadMoreRequested extends OrderEvent {
  const OrdersLoadMoreRequested();
}

/// Fetch order details
final class OrderDetailFetchRequested extends OrderEvent {
  final String orderId;

  const OrderDetailFetchRequested(this.orderId);
}

/// Create new order
final class OrderCreateRequested extends OrderEvent {
  final List<OrderItemModel> items;
  final AddressModel shippingAddress;
  final AddressModel? billingAddress;
  final String paymentMethod;
  final OrderTotalsModel totals;
  final String? couponCode;
  final String? notes;

  const OrderCreateRequested({
    required this.items,
    required this.shippingAddress,
    this.billingAddress,
    required this.paymentMethod,
    required this.totals,
    this.couponCode,
    this.notes,
  });
}

/// Cancel order
final class OrderCancelRequested extends OrderEvent {
  final String orderId;
  final String? reason;

  const OrderCancelRequested({required this.orderId, this.reason});
}

/// Request return
final class OrderReturnRequested extends OrderEvent {
  final String orderId;
  final String reason;
  final List<String>? itemIds;

  const OrderReturnRequested({
    required this.orderId,
    required this.reason,
    this.itemIds,
  });
}

/// Track order
final class OrderTrackRequested extends OrderEvent {
  final String orderId;

  const OrderTrackRequested(this.orderId);
}
