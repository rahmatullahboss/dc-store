import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../data/models/order/order_model.dart';
import '../../../data/models/user/user_model.dart';

part 'order_event.dart';
part 'order_state.dart';

/// OrderBloc - Manages order state
class OrderBloc extends Bloc<OrderEvent, OrderState> {
  OrderBloc() : super(const OrderState()) {
    on<OrdersFetchRequested>(_onFetchRequested);
    on<OrdersLoadMoreRequested>(_onLoadMoreRequested);
    on<OrderDetailFetchRequested>(_onDetailFetchRequested);
    on<OrderCreateRequested>(_onCreateRequested);
    on<OrderCancelRequested>(_onCancelRequested);
    on<OrderReturnRequested>(_onReturnRequested);
    on<OrderTrackRequested>(_onTrackRequested);
  }

  /// Fetch orders history
  Future<void> _onFetchRequested(
    OrdersFetchRequested event,
    Emitter<OrderState> emit,
  ) async {
    emit(state.copyWith(status: OrderListStatus.loading));

    try {
      await Future.delayed(const Duration(milliseconds: 500));

      // Mock orders
      final orders = List.generate(
        5,
        (i) => OrderModel(
          id: 'order_$i',
          orderNumber: 'ORD-${1000 + i}',
          items: [
            OrderItemModel(
              id: 'item_$i',
              productId: 'product_$i',
              productName: 'Product ${i + 1}',
              quantity: i + 1,
              price: (i + 1) * 500.0,
              total: (i + 1) * (i + 1) * 500.0,
            ),
          ],
          status: OrderStatus.values[i % OrderStatus.values.length],
          paymentStatus: PaymentStatus.paid,
          shippingAddress: const AddressModel(
            id: 'addr_1',
            fullName: 'John Doe',
            phone: '01712345678',
            street: '123 Main St',
            city: 'Dhaka',
            state: 'Dhaka',
            postalCode: '1000',
          ),
          totals: OrderTotalsModel(
            subtotal: (i + 1) * (i + 1) * 500.0,
            shipping: 120,
            total: (i + 1) * (i + 1) * 500.0 + 120,
          ),
          createdAt: DateTime.now().subtract(Duration(days: i * 3)),
        ),
      );

      emit(
        state.copyWith(
          status: OrderListStatus.loaded,
          orders: orders,
          hasReachedMax: true,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: OrderListStatus.error,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  /// Load more orders
  Future<void> _onLoadMoreRequested(
    OrdersLoadMoreRequested event,
    Emitter<OrderState> emit,
  ) async {
    if (state.hasReachedMax) return;

    emit(state.copyWith(status: OrderListStatus.loadingMore));

    // TODO: Load more orders
    await Future.delayed(const Duration(milliseconds: 500));
    emit(state.copyWith(status: OrderListStatus.loaded, hasReachedMax: true));
  }

  /// Fetch order details
  Future<void> _onDetailFetchRequested(
    OrderDetailFetchRequested event,
    Emitter<OrderState> emit,
  ) async {
    emit(state.copyWith(detailStatus: OrderDetailStatus.loading));

    try {
      await Future.delayed(const Duration(milliseconds: 300));

      final order = state.orders.firstWhere(
        (o) => o.id == event.orderId,
        orElse: () => throw Exception('Order not found'),
      );

      emit(
        state.copyWith(
          detailStatus: OrderDetailStatus.loaded,
          selectedOrder: order,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          detailStatus: OrderDetailStatus.error,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  /// Create new order
  Future<void> _onCreateRequested(
    OrderCreateRequested event,
    Emitter<OrderState> emit,
  ) async {
    emit(state.copyWith(createStatus: OrderCreateStatus.creating));

    try {
      await Future.delayed(const Duration(seconds: 1));

      // TODO: Create order via API
      final newOrder = OrderModel(
        id: 'order_${DateTime.now().millisecondsSinceEpoch}',
        orderNumber: 'ORD-${DateTime.now().millisecondsSinceEpoch % 10000}',
        items: event.items,
        status: OrderStatus.pending,
        paymentStatus: PaymentStatus.pending,
        paymentMethod: event.paymentMethod,
        shippingAddress: event.shippingAddress,
        totals: event.totals,
        createdAt: DateTime.now(),
      );

      emit(
        state.copyWith(
          createStatus: OrderCreateStatus.created,
          orders: [newOrder, ...state.orders],
          selectedOrder: newOrder,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          createStatus: OrderCreateStatus.error,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  /// Cancel order
  Future<void> _onCancelRequested(
    OrderCancelRequested event,
    Emitter<OrderState> emit,
  ) async {
    try {
      // TODO: Cancel order via API
      await Future.delayed(const Duration(milliseconds: 500));

      final updatedOrders = state.orders.map((order) {
        if (order.id == event.orderId) {
          return order.copyWith(status: OrderStatus.cancelled);
        }
        return order;
      }).toList();

      emit(state.copyWith(orders: updatedOrders));
    } catch (e) {
      emit(state.copyWith(errorMessage: e.toString()));
    }
  }

  /// Request return
  Future<void> _onReturnRequested(
    OrderReturnRequested event,
    Emitter<OrderState> emit,
  ) async {
    try {
      // TODO: Request return via API
      await Future.delayed(const Duration(milliseconds: 500));

      final updatedOrders = state.orders.map((order) {
        if (order.id == event.orderId) {
          return order.copyWith(status: OrderStatus.returned);
        }
        return order;
      }).toList();

      emit(state.copyWith(orders: updatedOrders));
    } catch (e) {
      emit(state.copyWith(errorMessage: e.toString()));
    }
  }

  /// Track order
  Future<void> _onTrackRequested(
    OrderTrackRequested event,
    Emitter<OrderState> emit,
  ) async {
    emit(state.copyWith(trackingStatus: OrderTrackingStatus.loading));

    try {
      await Future.delayed(const Duration(milliseconds: 500));

      // Mock tracking info
      final tracking = OrderTrackingModel(
        trackingNumber: 'TRK${event.orderId.substring(6)}',
        carrier: 'Pathao Courier',
        currentLocation: 'Dhaka Hub',
        lastUpdate: DateTime.now(),
      );

      emit(
        state.copyWith(
          trackingStatus: OrderTrackingStatus.loaded,
          currentTracking: tracking,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          trackingStatus: OrderTrackingStatus.error,
          errorMessage: e.toString(),
        ),
      );
    }
  }
}
