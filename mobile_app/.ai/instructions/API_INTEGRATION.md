# 🔗 API Integration Guidelines

## Backend: Next.js with Better Auth

এই Flutter app Next.js backend এর সাথে integrate করে যা Cloudflare Workers এ deploy করা আছে।

## API Response Format

### Success Response

```json
{
  "success": true,
  "data": {},
  "message": "Success message",
  "pagination": {
    "page": 1,
    "limit": 10,
    "total": 100,
    "totalPages": 10
  }
}
```

### Error Response

```json
{
  "success": false,
  "error": {
    "code": "ERROR_CODE",
    "message": "Error description"
  }
}
```

## API Endpoints

### Authentication (Better Auth)

```
POST   /api/auth/sign-in/email     # Email/password login
POST   /api/auth/sign-up/email     # Register with email
POST   /api/auth/sign-in/social    # Social login (Google)
POST   /api/auth/sign-out          # Logout
GET    /api/auth/session           # Get current session
POST   /api/auth/refresh           # Refresh token
```

### Products

```
GET    /api/products               # List products
GET    /api/products/:id           # Get product detail
GET    /api/categories             # List categories
GET    /api/products/search        # Search products
```

### Cart & Orders

```
GET    /api/cart                   # Get user cart
POST   /api/cart                   # Add to cart
PUT    /api/cart/:itemId           # Update cart item
DELETE /api/cart/:itemId           # Remove from cart
POST   /api/orders                 # Create order
GET    /api/user/orders            # Get user orders
```

### User

```
GET    /api/user/profile           # Get profile
PUT    /api/user/profile           # Update profile
GET    /api/user/wishlist          # Get wishlist
POST   /api/user/wishlist          # Add to wishlist
DELETE /api/user/wishlist/:id      # Remove from wishlist
```

## DioClient Setup

```dart
// lib/core/network/dio_client.dart

@riverpod
DioClient dioClient(Ref ref) {
  final storage = ref.watch(storageServiceProvider);
  return DioClient(storage);
}

class DioClient {
  late final Dio _dio;
  final StorageService _storage;

  DioClient(this._storage) {
    _dio = Dio(BaseOptions(
      baseUrl: AppConfig.baseUrl,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ));

    _dio.interceptors.addAll([
      AuthInterceptor(_storage),
      LoggingInterceptor(),
    ]);
  }

  Future<Response<T>> get<T>(String path, {Map<String, dynamic>? params}) {
    return _dio.get(path, queryParameters: params);
  }

  Future<Response<T>> post<T>(String path, {dynamic data}) {
    return _dio.post(path, data: data);
  }

  Future<Response<T>> put<T>(String path, {dynamic data}) {
    return _dio.put(path, data: data);
  }

  Future<Response<T>> delete<T>(String path) {
    return _dio.delete(path);
  }
}
```

## Auth Interceptor

```dart
class AuthInterceptor extends Interceptor {
  final StorageService _storage;

  AuthInterceptor(this._storage);

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    final token = await _storage.getAuthToken();
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401) {
      // Token expired - try refresh
      final refreshed = await _refreshToken();
      if (refreshed) {
        // Retry original request
        final response = await _retry(err.requestOptions);
        handler.resolve(response);
        return;
      }
    }
    handler.next(err);
  }
}
```

## Repository Pattern

```dart
// lib/features/product/data/product_repository.dart

final productRepositoryProvider = Provider<ProductRepository>((ref) {
  final dioClient = ref.watch(dioClientProvider);
  return ProductRepository(dioClient);
});

class ProductRepository {
  final DioClient _client;

  ProductRepository(this._client);

  Future<Result<List<Product>>> getProducts({
    int page = 1,
    int limit = 10,
    String? category,
  }) async {
    try {
      final response = await _client.get('/api/products', params: {
        'page': page,
        'limit': limit,
        if (category != null) 'category': category,
      });

      final data = response.data['data'] as List;
      final products = data.map((json) => Product.fromJson(json)).toList();
      return Right(products);
    } on DioException catch (e) {
      return Left(_handleError(e));
    }
  }

  Failure _handleError(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionError:
        return const NetworkFailure('ইন্টারনেট সংযোগ নেই');
      case DioExceptionType.receiveTimeout:
        return const ServerFailure('সার্ভার সাড়া দিচ্ছে না');
      default:
        final message = e.response?.data?['error']?['message'] ?? 'Unknown error';
        return ServerFailure(message);
    }
  }
}
```

## Provider Pattern for API Data

```dart
// FutureProvider for one-time fetch
final productsProvider = FutureProvider.autoDispose<List<Product>>((ref) async {
  final repository = ref.watch(productRepositoryProvider);
  final result = await repository.getProducts();
  return result.fold(
    (failure) => throw failure,
    (products) => products,
  );
});

// Family provider for parameterized fetch
final productDetailProvider = FutureProvider.autoDispose.family<Product, String>((ref, id) async {
  final repository = ref.watch(productRepositoryProvider);
  final result = await repository.getProduct(id);
  return result.fold(
    (failure) => throw failure,
    (product) => product,
  );
});
```

## Error Handling in UI

```dart
class ProductsScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productsAsync = ref.watch(productsProvider);

    return productsAsync.when(
      data: (products) => ProductGrid(products: products),
      loading: () => const ProductGridSkeleton(),
      error: (error, stack) => ErrorWidget(
        message: error is Failure ? error.message : 'Something went wrong',
        onRetry: () => ref.invalidate(productsProvider),
      ),
    );
  }
}
```
