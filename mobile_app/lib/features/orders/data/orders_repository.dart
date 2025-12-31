import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import '../../../core/network/dio_client.dart';

/// Order model for mobile app
class Order {
  final String id;
  final String orderNumber;
  final String status;
  final String paymentStatus;
  final String paymentMethod;
  final double subtotal;
  final double shippingCost;
  final double total;
  final List<OrderItem> items;
  final Address? shippingAddress;
  final DateTime? createdAt;

  Order({
    required this.id,
    required this.orderNumber,
    required this.status,
    required this.paymentStatus,
    required this.paymentMethod,
    required this.subtotal,
    required this.shippingCost,
    required this.total,
    required this.items,
    this.shippingAddress,
    this.createdAt,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'] ?? '',
      orderNumber: json['orderNumber'] ?? '',
      status: json['status'] ?? 'pending',
      paymentStatus: json['paymentStatus'] ?? 'pending',
      paymentMethod: json['paymentMethod'] ?? 'cod',
      subtotal: (json['subtotal'] ?? 0).toDouble(),
      shippingCost: (json['shippingCost'] ?? 0).toDouble(),
      total: (json['total'] ?? 0).toDouble(),
      items:
          (json['items'] as List<dynamic>?)
              ?.map((item) => OrderItem.fromJson(item))
              .toList() ??
          [],
      shippingAddress: json['shippingAddress'] != null
          ? Address.fromJson(json['shippingAddress'])
          : null,
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'])
          : null,
    );
  }

  /// Get formatted date string
  String get formattedDate {
    if (createdAt == null) return '';
    final months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return '${months[createdAt!.month - 1]} ${createdAt!.day}, ${createdAt!.year}';
  }

  /// Get first product image from items
  List<String> get thumbnails {
    return items
        .where((item) => item.image != null && item.image!.isNotEmpty)
        .take(2)
        .map((item) => item.image!)
        .toList();
  }

  /// Get item count
  int get itemCount => items.length;
}

class OrderItem {
  final String id;
  final String name;
  final double price;
  final int quantity;
  final String? image;
  final String? size;
  final String? color;

  OrderItem({
    required this.id,
    required this.name,
    required this.price,
    required this.quantity,
    this.image,
    this.size,
    this.color,
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      price: (json['price'] ?? 0).toDouble(),
      quantity: json['quantity'] ?? 1,
      image: json['image'],
      size: json['size'],
      color: json['color'],
    );
  }
}

class Address {
  final String? name;
  final String? phone;
  final String? street;
  final String? city;
  final String? state;
  final String? postalCode;
  final String? country;

  Address({
    this.name,
    this.phone,
    this.street,
    this.city,
    this.state,
    this.postalCode,
    this.country,
  });

  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      name: json['name'],
      phone: json['phone'],
      street: json['street'],
      city: json['city'],
      state: json['state'],
      postalCode: json['postalCode'],
      country: json['country'],
    );
  }
}

/// Orders Repository - fetches orders from API
class OrdersRepository {
  final DioClient _client;

  OrdersRepository({required DioClient client}) : _client = client;

  /// Fetch user's orders from API
  Future<List<Order>> getOrders() async {
    try {
      final response = await _client.get('/api/user/orders');

      if (response.isSuccess && response.data != null) {
        final data = response.data as Map<String, dynamic>;
        final ordersJson = data['orders'] as List<dynamic>? ?? [];
        return ordersJson
            .map((json) => Order.fromJson(json as Map<String, dynamic>))
            .toList();
      }
      return [];
    } catch (e) {
      // If unauthorized or error, return empty list
      return [];
    }
  }

  /// Fetch a single order by ID
  Future<Order?> getOrderById(String orderId) async {
    try {
      // First try to get from the single order endpoint
      final response = await _client.get('/api/user/orders/$orderId');

      if (response.isSuccess && response.data != null) {
        final data = response.data as Map<String, dynamic>;
        // Handle both direct order response and nested 'order' key
        final orderData = data['order'] ?? data;
        return Order.fromJson(orderData as Map<String, dynamic>);
      }
      return null;
    } catch (e) {
      // Fallback: search in the orders list
      try {
        final orders = await getOrders();
        return orders.firstWhere(
          (o) => o.id == orderId || o.orderNumber == orderId,
        );
      } catch (_) {
        return null;
      }
    }
  }
}

/// Orders state
class OrdersState {
  final List<Order> orders;
  final bool isLoading;
  final String? error;

  OrdersState({this.orders = const [], this.isLoading = false, this.error});

  OrdersState copyWith({List<Order>? orders, bool? isLoading, String? error}) {
    return OrdersState(
      orders: orders ?? this.orders,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

/// Orders notifier - manages orders state
class OrdersNotifier extends StateNotifier<OrdersState> {
  final OrdersRepository _repository;

  OrdersNotifier(this._repository) : super(OrdersState()) {
    loadOrders();
  }

  Future<void> loadOrders() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final orders = await _repository.getOrders();
      state = state.copyWith(orders: orders, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> refresh() => loadOrders();
}

/// Repository provider
final ordersRepositoryProvider = Provider<OrdersRepository>((ref) {
  final client = ref.watch(dioClientProvider);
  return OrdersRepository(client: client);
});

/// Orders provider
final ordersProvider = StateNotifierProvider<OrdersNotifier, OrdersState>((
  ref,
) {
  final repository = ref.watch(ordersRepositoryProvider);
  return OrdersNotifier(repository);
});

/// Single order detail provider - uses FutureProvider.family for ID-based fetching
final orderDetailProvider = FutureProvider.family<Order?, String>((
  ref,
  orderId,
) {
  final repository = ref.watch(ordersRepositoryProvider);
  return repository.getOrderById(orderId);
});
