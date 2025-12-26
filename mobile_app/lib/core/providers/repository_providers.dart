/// Repository Providers - Riverpod providers for all repositories
/// Central file for dependency injection
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../network/dio_client.dart';
import '../network/network_info.dart';
import '../cache/cache_service.dart';
import '../../services/storage_service.dart';

// Domain interfaces
import '../../domain/repositories/i_auth_repository.dart';
import '../../domain/repositories/i_product_repository.dart';
import '../../domain/repositories/i_category_repository.dart';
import '../../domain/repositories/i_cart_repository.dart';
import '../../domain/repositories/i_order_repository.dart';
import '../../domain/repositories/i_user_repository.dart';
import '../../domain/repositories/i_wishlist_repository.dart';
import '../../domain/repositories/i_review_repository.dart';
import '../../domain/repositories/i_payment_repository.dart';

// Data sources - Remote
import '../../data/datasources/remote/auth_remote_datasource.dart';
import '../../data/datasources/remote/product_remote_datasource.dart';
import '../../data/datasources/remote/category_remote_datasource.dart';
import '../../data/datasources/remote/cart_remote_datasource.dart';
import '../../data/datasources/remote/order_remote_datasource.dart';
import '../../data/datasources/remote/user_remote_datasource.dart';
import '../../data/datasources/remote/wishlist_remote_datasource.dart';
import '../../data/datasources/remote/review_remote_datasource.dart';
import '../../data/datasources/remote/payment_remote_datasource.dart';

// Data sources - Local
import '../../data/datasources/local/product_local_datasource.dart';
import '../../data/datasources/local/category_local_datasource.dart';
import '../../data/datasources/local/cart_local_datasource.dart';
import '../../data/datasources/local/user_local_datasource.dart';
import '../../data/datasources/local/wishlist_local_datasource.dart';

// Repository implementations
import '../../data/repositories/auth_repository.dart';
import '../../data/repositories/product_repository.dart';
import '../../data/repositories/category_repository.dart';
import '../../data/repositories/cart_repository.dart';
import '../../data/repositories/order_repository.dart';
import '../../data/repositories/user_repository.dart';
import '../../data/repositories/wishlist_repository.dart';
import '../../data/repositories/review_repository.dart';
import '../../data/repositories/payment_repository.dart';

// ═══════════════════════════════════════════════════════════════
// CORE SERVICE PROVIDERS
// ═══════════════════════════════════════════════════════════════

/// Storage service provider (initialized in main.dart)
final storageServiceProvider = Provider<StorageService>((ref) {
  throw UnimplementedError(
    'storageServiceProvider must be overridden in main.dart',
  );
});

// ═══════════════════════════════════════════════════════════════
// REMOTE DATA SOURCE PROVIDERS
// ═══════════════════════════════════════════════════════════════

final authRemoteDataSourceProvider = Provider<IAuthRemoteDataSource>((ref) {
  return AuthRemoteDataSource(client: ref.watch(dioClientProvider));
});

final productRemoteDataSourceProvider = Provider<IProductRemoteDataSource>((
  ref,
) {
  return ProductRemoteDataSource(client: ref.watch(dioClientProvider));
});

final categoryRemoteDataSourceProvider = Provider<ICategoryRemoteDataSource>((
  ref,
) {
  return CategoryRemoteDataSource(client: ref.watch(dioClientProvider));
});

final cartRemoteDataSourceProvider = Provider<ICartRemoteDataSource>((ref) {
  return CartRemoteDataSource(client: ref.watch(dioClientProvider));
});

final orderRemoteDataSourceProvider = Provider<IOrderRemoteDataSource>((ref) {
  return OrderRemoteDataSource(client: ref.watch(dioClientProvider));
});

final userRemoteDataSourceProvider = Provider<IUserRemoteDataSource>((ref) {
  return UserRemoteDataSource(client: ref.watch(dioClientProvider));
});

final wishlistRemoteDataSourceProvider = Provider<IWishlistRemoteDataSource>((
  ref,
) {
  return WishlistRemoteDataSource(client: ref.watch(dioClientProvider));
});

final reviewRemoteDataSourceProvider = Provider<IReviewRemoteDataSource>((ref) {
  return ReviewRemoteDataSource(client: ref.watch(dioClientProvider));
});

final paymentRemoteDataSourceProvider = Provider<IPaymentRemoteDataSource>((
  ref,
) {
  return PaymentRemoteDataSource(client: ref.watch(dioClientProvider));
});

// ═══════════════════════════════════════════════════════════════
// LOCAL DATA SOURCE PROVIDERS
// ═══════════════════════════════════════════════════════════════

final productLocalDataSourceProvider = Provider<IProductLocalDataSource>((ref) {
  return ProductLocalDataSource(cacheService: ref.watch(cacheServiceProvider));
});

final categoryLocalDataSourceProvider = Provider<ICategoryLocalDataSource>((
  ref,
) {
  return CategoryLocalDataSource(cacheService: ref.watch(cacheServiceProvider));
});

final cartLocalDataSourceProvider = Provider<ICartLocalDataSource>((ref) {
  return CartLocalDataSource(cacheService: ref.watch(cacheServiceProvider));
});

final userLocalDataSourceProvider = Provider<IUserLocalDataSource>((ref) {
  return UserLocalDataSource(cacheService: ref.watch(cacheServiceProvider));
});

final wishlistLocalDataSourceProvider = Provider<IWishlistLocalDataSource>((
  ref,
) {
  return WishlistLocalDataSource(cacheService: ref.watch(cacheServiceProvider));
});

// ═══════════════════════════════════════════════════════════════
// REPOSITORY PROVIDERS
// ═══════════════════════════════════════════════════════════════

final authRepositoryProvider = Provider<IAuthRepository>((ref) {
  return AuthRepository(
    remoteDataSource: ref.watch(authRemoteDataSourceProvider),
    storageService: ref.watch(storageServiceProvider),
  );
});

final productRepositoryProvider = Provider<IProductRepository>((ref) {
  return ProductRepository(
    remoteDataSource: ref.watch(productRemoteDataSourceProvider),
    localDataSource: ref.watch(productLocalDataSourceProvider),
    networkInfo: ref.watch(networkInfoProvider),
  );
});

final categoryRepositoryProvider = Provider<ICategoryRepository>((ref) {
  return CategoryRepository(
    remoteDataSource: ref.watch(categoryRemoteDataSourceProvider),
    localDataSource: ref.watch(categoryLocalDataSourceProvider),
    networkInfo: ref.watch(networkInfoProvider),
  );
});

final cartRepositoryProvider = Provider<ICartRepository>((ref) {
  return CartRepository(
    remoteDataSource: ref.watch(cartRemoteDataSourceProvider),
    localDataSource: ref.watch(cartLocalDataSourceProvider),
    networkInfo: ref.watch(networkInfoProvider),
  );
});

final orderRepositoryProvider = Provider<IOrderRepository>((ref) {
  return OrderRepository(
    remoteDataSource: ref.watch(orderRemoteDataSourceProvider),
    networkInfo: ref.watch(networkInfoProvider),
  );
});

final userRepositoryProvider = Provider<IUserRepository>((ref) {
  return UserRepository(
    remoteDataSource: ref.watch(userRemoteDataSourceProvider),
    localDataSource: ref.watch(userLocalDataSourceProvider),
    networkInfo: ref.watch(networkInfoProvider),
  );
});

final wishlistRepositoryProvider = Provider<IWishlistRepository>((ref) {
  return WishlistRepository(
    remoteDataSource: ref.watch(wishlistRemoteDataSourceProvider),
    localDataSource: ref.watch(wishlistLocalDataSourceProvider),
    networkInfo: ref.watch(networkInfoProvider),
  );
});

final reviewRepositoryProvider = Provider<IReviewRepository>((ref) {
  return ReviewRepository(
    remoteDataSource: ref.watch(reviewRemoteDataSourceProvider),
    networkInfo: ref.watch(networkInfoProvider),
  );
});

final paymentRepositoryProvider = Provider<IPaymentRepository>((ref) {
  return PaymentRepository(
    remoteDataSource: ref.watch(paymentRemoteDataSourceProvider),
    networkInfo: ref.watch(networkInfoProvider),
  );
});
