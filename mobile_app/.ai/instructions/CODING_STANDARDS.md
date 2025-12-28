# 📝 Coding Standards

## File Organization

### Naming Conventions

| Type      | Convention        | Example                   |
| --------- | ----------------- | ------------------------- |
| Files     | snake_case        | `product_repository.dart` |
| Classes   | PascalCase        | `ProductRepository`       |
| Variables | camelCase         | `productList`             |
| Constants | kCamelCase        | `kPrimaryColor`           |
| Providers | camelCaseProvider | `productsProvider`        |
| Private   | \_prefixed        | `_privateMethod()`        |

### Import Order

```dart
// 1. Dart imports
import 'dart:async';
import 'dart:convert';

// 2. Flutter imports
import 'package:flutter/material.dart';

// 3. Package imports
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';

// 4. Project imports
import 'package:dc_store/core/network/dio_client.dart';
import 'package:dc_store/data/models/product_model.dart';
```

## Riverpod Patterns

### Provider Types

```dart
// 1. Simple Provider - for computed values
final formattedPriceProvider = Provider<String>((ref) {
  final price = ref.watch(priceProvider);
  return '৳$price';
});

// 2. StateProvider - for simple mutable state
final counterProvider = StateProvider<int>((ref) => 0);

// 3. StateNotifierProvider - for complex state logic
final cartProvider = StateNotifierProvider<CartNotifier, CartState>((ref) {
  return CartNotifier(ref);
});

// 4. FutureProvider - for async data
final productsProvider = FutureProvider<List<Product>>((ref) async {
  final repository = ref.watch(productRepositoryProvider);
  return repository.getProducts();
});

// 5. AsyncNotifierProvider - for async state with mutations
final authProvider = AsyncNotifierProvider<AuthNotifier, AuthState>(() {
  return AuthNotifier();
});
```

### State Classes with Freezed

```dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'auth_state.freezed.dart';

@freezed
class AuthState with _$AuthState {
  const factory AuthState.initial() = AuthInitial;
  const factory AuthState.loading() = AuthLoading;
  const factory AuthState.authenticated(User user) = AuthAuthenticated;
  const factory AuthState.unauthenticated() = AuthUnauthenticated;
  const factory AuthState.error(String message) = AuthError;
}
```

### Controller Pattern

```dart
class AuthController extends StateNotifier<AuthState> {
  final Ref _ref;

  AuthController(this._ref) : super(const AuthState.initial());

  Future<void> login(String email, String password) async {
    state = const AuthState.loading();
    try {
      final user = await _ref.read(authRepositoryProvider).login(email, password);
      state = AuthState.authenticated(user);
    } catch (e) {
      state = AuthState.error(e.toString());
    }
  }
}

final authControllerProvider = StateNotifierProvider<AuthController, AuthState>((ref) {
  return AuthController(ref);
});
```

## Widget Structure

### StatelessWidget with Riverpod

```dart
class ProductCard extends ConsumerWidget {
  final Product product;

  const ProductCard({super.key, required this.product});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cartState = ref.watch(cartProvider);

    return GestureDetector(
      onTap: () => _navigateToDetail(context),
      child: Container(
        // Widget content
      ),
    );
  }
}
```

### StatefulWidget with Riverpod

```dart
class CheckoutScreen extends ConsumerStatefulWidget {
  const CheckoutScreen({super.key});

  @override
  ConsumerState<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends ConsumerState<CheckoutScreen> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final cartState = ref.watch(cartProvider);

    return Scaffold(
      // Screen content
    );
  }
}
```

## Error Handling

### Result Pattern

```dart
import 'package:dart_either/dart_either.dart';

typedef Result<T> = Either<Failure, T>;

abstract class Failure {
  final String message;
  const Failure(this.message);
}

class ServerFailure extends Failure {
  const ServerFailure([String message = 'Server error']) : super(message);
}

class NetworkFailure extends Failure {
  const NetworkFailure([String message = 'No internet connection']) : super(message);
}
```

### Usage in Repository

```dart
Future<Result<List<Product>>> getProducts() async {
  try {
    final response = await _dioClient.get('/api/products');
    final products = (response.data as List)
        .map((json) => Product.fromJson(json))
        .toList();
    return Right(products);
  } on DioException catch (e) {
    return Left(ServerFailure(e.message ?? 'Unknown error'));
  } catch (e) {
    return Left(ServerFailure(e.toString()));
  }
}
```

## Documentation

### Class Documentation

````dart
/// Repository for managing product data.
///
/// Handles fetching products from the API and caching them locally.
///
/// Example:
/// ```dart
/// final products = await productRepository.getProducts();
/// ```
class ProductRepository {
  // ...
}
````

### Method Documentation

```dart
/// Fetches products from the API with optional filtering.
///
/// [category] - Optional category filter
/// [page] - Page number for pagination (default: 1)
/// [limit] - Number of items per page (default: 10)
///
/// Returns [Either<Failure, List<Product>>]
/// - [Right] with list of products on success
/// - [Left] with [Failure] on error
Future<Result<List<Product>>> getProducts({
  String? category,
  int page = 1,
  int limit = 10,
}) async {
  // Implementation
}
```

## Testing Standards

### Unit Test Structure

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockProductRepository extends Mock implements ProductRepository {}

void main() {
  late ProductRepository mockRepository;

  setUp(() {
    mockRepository = MockProductRepository();
  });

  group('ProductProvider', () {
    test('should return products on success', () async {
      // Arrange
      when(() => mockRepository.getProducts())
          .thenAnswer((_) async => Right(testProducts));

      // Act
      final result = await mockRepository.getProducts();

      // Assert
      expect(result.isRight, true);
    });
  });
}
```
