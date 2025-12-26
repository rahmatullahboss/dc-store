import 'package:mocktail/mocktail.dart';
import 'package:dio/dio.dart';
import 'package:mobile_app/core/network/dio_client.dart';
import 'package:mobile_app/core/network/api_response.dart';
import 'package:mobile_app/services/storage_service.dart';
import 'package:mobile_app/services/auth_service.dart';
import 'package:mobile_app/data/models/models.dart';

// ═══════════════════════════════════════════════════════════════
// NETWORK MOCKS
// ═══════════════════════════════════════════════════════════════

class MockDioClient extends Mock implements DioClient {}

class MockDio extends Mock implements Dio {}

class MockResponse<T> extends Mock implements Response<T> {}

// ═══════════════════════════════════════════════════════════════
// SERVICE MOCKS
// ═══════════════════════════════════════════════════════════════

class MockStorageService extends Mock implements StorageService {}

class MockAuthService extends Mock implements AuthService {}

// ═══════════════════════════════════════════════════════════════
// REPOSITORY MOCKS
// ═══════════════════════════════════════════════════════════════

// Mock for IAuthRepository
abstract class IAuthRepository {
  Future<ApiResponse<AuthResponseModel>> login(String email, String password);
  Future<ApiResponse<AuthResponseModel>> register(
    String name,
    String email,
    String password,
  );
  Future<void> logout();
  Future<ApiResponse<void>> forgotPassword(String email);
  bool get isAuthenticated;
}

class MockAuthRepository extends Mock implements IAuthRepository {}

// Mock for IProductRepository
abstract class IProductRepository {
  Future<ApiResponse<List<ProductModel>>> getProducts({
    int page,
    int limit,
    String? categoryId,
  });
  Future<ApiResponse<ProductModel>> getProductById(String id);
  Future<ApiResponse<List<ProductModel>>> searchProducts(String query);
}

class MockProductRepository extends Mock implements IProductRepository {}

// Mock for ICartRepository
abstract class ICartRepository {
  Future<ApiResponse<CartModel>> getCart();
  Future<ApiResponse<CartModel>> addToCart(String productId, int quantity);
  Future<ApiResponse<CartModel>> updateCartItem(String itemId, int quantity);
  Future<ApiResponse<CartModel>> removeFromCart(String itemId);
  Future<ApiResponse<CartModel>> applyCoupon(String code);
  Future<ApiResponse<void>> clearCart();
}

class MockCartRepository extends Mock implements ICartRepository {}

// Mock for IOrderRepository
abstract class IOrderRepository {
  Future<ApiResponse<List<OrderModel>>> getOrders({int page, int limit});
  Future<ApiResponse<OrderModel>> getOrderById(String id);
  Future<ApiResponse<OrderModel>> createOrder(Map<String, dynamic> orderData);
  Future<ApiResponse<OrderModel>> cancelOrder(String id);
}

class MockOrderRepository extends Mock implements IOrderRepository {}

// Mock for IWishlistRepository
abstract class IWishlistRepository {
  Future<ApiResponse<List<WishlistItemModel>>> getWishlist();
  Future<ApiResponse<void>> addToWishlist(String productId);
  Future<ApiResponse<void>> removeFromWishlist(String productId);
  bool isInWishlist(String productId);
}

class MockWishlistRepository extends Mock implements IWishlistRepository {}

// ═══════════════════════════════════════════════════════════════
// CALLBACK MOCKS
// ═══════════════════════════════════════════════════════════════

class MockCallback<T> extends Mock {
  void call(T value);
}

class MockVoidCallback extends Mock {
  void call();
}
