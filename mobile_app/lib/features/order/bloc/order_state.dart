part of 'order_bloc.dart';

/// Order list status
enum OrderListStatus { initial, loading, loadingMore, loaded, error }

/// Order detail status
enum OrderDetailStatus { initial, loading, loaded, error }

/// Order create status
enum OrderCreateStatus { initial, creating, created, error }

/// Order tracking status
enum OrderTrackingStatus { initial, loading, loaded, error }

/// Order State
class OrderState extends Equatable {
  final OrderListStatus status;
  final OrderDetailStatus detailStatus;
  final OrderCreateStatus createStatus;
  final OrderTrackingStatus trackingStatus;
  final List<OrderModel> orders;
  final OrderModel? selectedOrder;
  final OrderTrackingModel? currentTracking;
  final OrderStatus? filterStatus;
  final int currentPage;
  final bool hasReachedMax;
  final String? errorMessage;

  const OrderState({
    this.status = OrderListStatus.initial,
    this.detailStatus = OrderDetailStatus.initial,
    this.createStatus = OrderCreateStatus.initial,
    this.trackingStatus = OrderTrackingStatus.initial,
    this.orders = const [],
    this.selectedOrder,
    this.currentTracking,
    this.filterStatus,
    this.currentPage = 1,
    this.hasReachedMax = false,
    this.errorMessage,
  });

  /// Filter orders by status
  List<OrderModel> get filteredOrders {
    if (filterStatus == null) return orders;
    return orders.where((o) => o.status == filterStatus).toList();
  }

  /// Count of pending orders
  int get pendingCount =>
      orders.where((o) => o.status == OrderStatus.pending).length;

  /// Count of active orders (not delivered/cancelled)
  int get activeCount => orders.where((o) => o.status.isActive).length;

  OrderState copyWith({
    OrderListStatus? status,
    OrderDetailStatus? detailStatus,
    OrderCreateStatus? createStatus,
    OrderTrackingStatus? trackingStatus,
    List<OrderModel>? orders,
    OrderModel? selectedOrder,
    OrderTrackingModel? currentTracking,
    OrderStatus? filterStatus,
    int? currentPage,
    bool? hasReachedMax,
    String? errorMessage,
  }) {
    return OrderState(
      status: status ?? this.status,
      detailStatus: detailStatus ?? this.detailStatus,
      createStatus: createStatus ?? this.createStatus,
      trackingStatus: trackingStatus ?? this.trackingStatus,
      orders: orders ?? this.orders,
      selectedOrder: selectedOrder ?? this.selectedOrder,
      currentTracking: currentTracking ?? this.currentTracking,
      filterStatus: filterStatus ?? this.filterStatus,
      currentPage: currentPage ?? this.currentPage,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
    status,
    detailStatus,
    createStatus,
    trackingStatus,
    orders,
    selectedOrder,
    currentTracking,
    filterStatus,
    currentPage,
    hasReachedMax,
    errorMessage,
  ];
}
