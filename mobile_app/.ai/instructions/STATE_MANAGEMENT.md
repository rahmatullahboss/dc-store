# 🔄 State Management Guidelines (Riverpod)

## Overview

DC Store uses **Riverpod 3.0** for state management. This guide covers patterns used in the project.

## Provider Types

### 1. Provider (Read-only)

```dart
// Computed values, services, repositories
final formattedPriceProvider = Provider<String>((ref) {
  final price = ref.watch(productPriceProvider);
  return '৳${price.toStringAsFixed(2)}';
});

final productRepositoryProvider = Provider<ProductRepository>((ref) {
  final dioClient = ref.watch(dioClientProvider);
  return ProductRepository(dioClient);
});
```

### 2. StateProvider (Simple State)

```dart
// Simple mutable state
final selectedCategoryProvider = StateProvider<String?>((ref) => null);
final searchQueryProvider = StateProvider<String>((ref) => '');
final isDarkModeProvider = StateProvider<bool>((ref) => false);

// Usage
ref.read(selectedCategoryProvider.notifier).state = 'electronics';
```

### 3. StateNotifierProvider (Complex State)

```dart
// Complex state with business logic
final cartProvider = StateNotifierProvider<CartNotifier, CartState>((ref) {
  final repository = ref.watch(cartRepositoryProvider);
  return CartNotifier(ref, repository);
});

class CartNotifier extends StateNotifier<CartState> {
  final Ref _ref;
  final CartRepository _repository;

  CartNotifier(this._ref, this._repository) : super(const CartState()) {
    _loadCart();
  }

  Future<void> addItem(Product product, int quantity) async {
    state = state.copyWith(isLoading: true);
    try {
      await _repository.addToCart(product.id, quantity);
      await _loadCart();
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }
}
```

### 4. FutureProvider (Async Data)

```dart
// One-time async fetch
final productsProvider = FutureProvider.autoDispose<List<Product>>((ref) async {
  final repository = ref.watch(productRepositoryProvider);
  return repository.getProducts();
});

// With parameters (family modifier)
final productProvider = FutureProvider.autoDispose.family<Product, String>(
  (ref, productId) async {
    final repository = ref.watch(productRepositoryProvider);
    return repository.getProduct(productId);
  },
);
```

### 5. AsyncNotifierProvider (Complex Async State)

```dart
final authProvider = AsyncNotifierProvider<AuthNotifier, AuthState>(() {
  return AuthNotifier();
});

class AuthNotifier extends AsyncNotifier<AuthState> {
  @override
  Future<AuthState> build() async {
    final token = await ref.read(storageServiceProvider).getAuthToken();
    if (token != null) {
      return AuthState.authenticated(await _fetchUser());
    }
    return const AuthState.unauthenticated();
  }

  Future<void> login(String email, String password) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final user = await ref.read(authRepositoryProvider).login(email, password);
      return AuthState.authenticated(user);
    });
  }
}
```

## State Classes with Freezed

```dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'cart_state.freezed.dart';

@freezed
class CartState with _$CartState {
  const factory CartState({
    @Default([]) List<CartItem> items,
    @Default(false) bool isLoading,
    String? error,
  }) = _CartState;

  const CartState._();

  int get totalItems => items.fold(0, (sum, item) => sum + item.quantity);
  double get totalPrice => items.fold(0.0, (sum, item) => sum + item.totalPrice);
}
```

## Consuming State in Widgets

### Using ConsumerWidget

```dart
class CartScreen extends ConsumerWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cartState = ref.watch(cartProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('Cart (${cartState.totalItems})'),
      ),
      body: cartState.isLoading
          ? const CartSkeleton()
          : CartItemList(items: cartState.items),
    );
  }
}
```

### Using Consumer

```dart
// For specific parts of the widget tree
Consumer(
  builder: (context, ref, child) {
    final count = ref.watch(cartProvider.select((s) => s.totalItems));
    return Badge(label: Text('$count'), child: child!);
  },
  child: const Icon(Icons.shopping_cart),
)
```

### Using ref.listen

```dart
class CheckoutScreen extends ConsumerStatefulWidget {
  @override
  ConsumerState<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends ConsumerState<CheckoutScreen> {
  @override
  void initState() {
    super.initState();
    // Listen for side effects
    ref.listenManual(orderProvider, (prev, next) {
      next.whenOrNull(
        data: (order) => context.go('/order-success/${order.id}'),
        error: (e, _) => ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        ),
      );
    });
  }
}
```

## Provider Modifiers

### autoDispose

```dart
// Auto cleanup when no longer used
final searchResultsProvider = FutureProvider.autoDispose<List<Product>>((ref) async {
  final query = ref.watch(searchQueryProvider);
  if (query.isEmpty) return [];
  return ref.watch(productRepositoryProvider).search(query);
});
```

### family

```dart
// Pass parameters
final productProvider = FutureProvider.autoDispose.family<Product, String>(
  (ref, id) => ref.watch(productRepositoryProvider).getProduct(id),
);

// Usage
final product = ref.watch(productProvider('product-123'));
```

## Best Practices

### ✅ DO

- Use `autoDispose` for screen-specific providers
- Use `select` to optimize rebuilds
- Keep providers small and focused
- Use `family` for parameterized data

### ❌ DON'T

- Don't use `ref.read` in build method (use `ref.watch`)
- Don't create providers inside widgets
- Don't store BuildContext in providers
- Don't make providers too large (split them)
