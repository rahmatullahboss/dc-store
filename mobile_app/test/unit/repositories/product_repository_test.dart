import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:dc_store/core/utils/either.dart';
import 'package:dc_store/core/errors/failures.dart';
import 'package:dc_store/core/errors/exceptions.dart';
import 'package:dc_store/core/network/network_info.dart';
import 'package:dc_store/data/repositories/product_repository.dart';
import 'package:dc_store/data/datasources/remote/product_remote_datasource.dart';
import 'package:dc_store/data/datasources/local/product_local_datasource.dart';
import 'package:dc_store/data/models/common/pagination.dart';
import '../../mocks/mock_factories.dart';

// ═══════════════════════════════════════════════════════════════
// MOCKS
// ═══════════════════════════════════════════════════════════════

class MockProductRemoteDataSource extends Mock
    implements IProductRemoteDataSource {}

class MockProductLocalDataSource extends Mock
    implements IProductLocalDataSource {}

class MockNetworkInfo extends Mock implements NetworkInfo {}

void main() {
  late ProductRepository repository;
  late MockProductRemoteDataSource mockRemoteDataSource;
  late MockProductLocalDataSource mockLocalDataSource;
  late MockNetworkInfo mockNetworkInfo;

  // Register fallback values for mocktail
  setUpAll(() {
    registerFallbackValue(ProductFactory.create());
    registerFallbackValue(ProductFactory.createList(1));
  });

  setUp(() {
    mockRemoteDataSource = MockProductRemoteDataSource();
    mockLocalDataSource = MockProductLocalDataSource();
    mockNetworkInfo = MockNetworkInfo();

    repository = ProductRepository(
      remoteDataSource: mockRemoteDataSource,
      localDataSource: mockLocalDataSource,
      networkInfo: mockNetworkInfo,
    );
  });

  // ═══════════════════════════════════════════════════════════════
  // getProducts
  // ═══════════════════════════════════════════════════════════════

  group('getProducts', () {
    final testProducts = ProductFactory.createList(3);
    final testPagination = PaginationModel(
      currentPage: 1,
      totalItems: 3,
      perPage: 20,
      totalPages: 1,
    );

    test('should return products from remote when online', () async {
      // Arrange
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(
        () => mockLocalDataSource.getCachedProducts(any()),
      ).thenAnswer((_) async => null);
      when(
        () => mockRemoteDataSource.getProducts(any()),
      ).thenAnswer((_) async => (testProducts, testPagination));
      when(
        () => mockLocalDataSource.cacheProducts(any(), any()),
      ).thenAnswer((_) async {});

      // Act
      final result = await repository.getProducts();

      // Assert
      expect(result.isSuccess, true);
      expect(result.getOrNull()?.items.length, 3);
      verify(() => mockRemoteDataSource.getProducts(any())).called(1);
      verify(() => mockLocalDataSource.cacheProducts(any(), any())).called(1);
    });

    test('should return cached products when offline with cache', () async {
      // Arrange
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => false);
      when(
        () => mockLocalDataSource.getCachedProducts(any()),
      ).thenAnswer((_) async => testProducts);

      // Act
      final result = await repository.getProducts();

      // Assert
      expect(result.isSuccess, true);
      expect(result.getOrNull()?.items.length, 3);
      verifyNever(() => mockRemoteDataSource.getProducts(any()));
    });

    test('should return NetworkFailure when offline without cache', () async {
      // Arrange
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => false);
      when(
        () => mockLocalDataSource.getCachedProducts(any()),
      ).thenAnswer((_) async => null);

      // Act
      final result = await repository.getProducts();

      // Assert
      expect(result.isFailure, true);
      expect(result.failureOrNull, isA<NetworkFailure>());
    });

    test('should cache products after successful remote fetch', () async {
      // Arrange
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(
        () => mockLocalDataSource.getCachedProducts(any()),
      ).thenAnswer((_) async => null);
      when(
        () => mockRemoteDataSource.getProducts(any()),
      ).thenAnswer((_) async => (testProducts, testPagination));
      when(
        () => mockLocalDataSource.cacheProducts(any(), any()),
      ).thenAnswer((_) async {});

      // Act
      await repository.getProducts();

      // Assert
      verify(
        () => mockLocalDataSource.cacheProducts('all', testProducts),
      ).called(1);
    });
  });

  // ═══════════════════════════════════════════════════════════════
  // getProductById
  // ═══════════════════════════════════════════════════════════════

  group('getProductById', () {
    final testProduct = ProductFactory.create(id: 'test_product_1');
    const testId = 'test_product_1';

    test('should return product from remote when online', () async {
      // Arrange
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(
        () => mockLocalDataSource.getCachedProduct(testId),
      ).thenAnswer((_) async => null);
      when(
        () => mockRemoteDataSource.getProductById(testId),
      ).thenAnswer((_) async => testProduct);
      when(
        () => mockLocalDataSource.cacheProduct(any()),
      ).thenAnswer((_) async {});

      // Act
      final result = await repository.getProductById(testId);

      // Assert
      expect(result.isSuccess, true);
      expect(result.getOrNull()?.id, testId);
      verify(() => mockRemoteDataSource.getProductById(testId)).called(1);
    });

    test('should return cached product when offline with cache', () async {
      // Arrange
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => false);
      when(
        () => mockLocalDataSource.getCachedProduct(testId),
      ).thenAnswer((_) async => testProduct);

      // Act
      final result = await repository.getProductById(testId);

      // Assert
      expect(result.isSuccess, true);
      expect(result.getOrNull()?.id, testId);
      verifyNever(() => mockRemoteDataSource.getProductById(any()));
    });

    test('should return NetworkFailure when offline without cache', () async {
      // Arrange
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => false);
      when(
        () => mockLocalDataSource.getCachedProduct(testId),
      ).thenAnswer((_) async => null);

      // Act
      final result = await repository.getProductById(testId);

      // Assert
      expect(result.isFailure, true);
      expect(result.failureOrNull, isA<NetworkFailure>());
    });

    test('should cache product after successful fetch', () async {
      // Arrange
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(
        () => mockLocalDataSource.getCachedProduct(testId),
      ).thenAnswer((_) async => null);
      when(
        () => mockRemoteDataSource.getProductById(testId),
      ).thenAnswer((_) async => testProduct);
      when(
        () => mockLocalDataSource.cacheProduct(any()),
      ).thenAnswer((_) async {});

      // Act
      await repository.getProductById(testId);

      // Assert
      verify(() => mockLocalDataSource.cacheProduct(testProduct)).called(1);
    });
  });

  // ═══════════════════════════════════════════════════════════════
  // searchProducts
  // ═══════════════════════════════════════════════════════════════

  group('searchProducts', () {
    final testProducts = ProductFactory.createList(2);
    final testPagination = PaginationModel(currentPage: 1, totalItems: 2);

    test('should return search results when online', () async {
      // Arrange
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(
        () => mockRemoteDataSource.searchProducts(any(), any(), any()),
      ).thenAnswer((_) async => (testProducts, testPagination));

      // Act
      final result = await repository.searchProducts(query: 'test');

      // Assert
      expect(result.isSuccess, true);
      expect(result.getOrNull()?.items.length, 2);
    });

    test('should return NetworkFailure when offline', () async {
      // Arrange
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => false);

      // Act
      final result = await repository.searchProducts(query: 'test');

      // Assert
      expect(result.isFailure, true);
      expect(result.failureOrNull, isA<NetworkFailure>());
    });
  });

  // ═══════════════════════════════════════════════════════════════
  // getFeaturedProducts
  // ═══════════════════════════════════════════════════════════════

  group('getFeaturedProducts', () {
    final testProducts = ProductFactory.createList(5);

    test('should return featured products from remote when online', () async {
      // Arrange
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(
        () => mockLocalDataSource.getCachedProducts(any()),
      ).thenAnswer((_) async => null);
      when(
        () => mockRemoteDataSource.getFeaturedProducts(any()),
      ).thenAnswer((_) async => testProducts);
      when(
        () => mockLocalDataSource.cacheProducts(any(), any()),
      ).thenAnswer((_) async {});

      // Act
      final result = await repository.getFeaturedProducts();

      // Assert
      expect(result.isSuccess, true);
      expect(result.getOrNull()?.length, 5);
    });

    test('should return cached featured products when offline', () async {
      // Arrange
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => false);
      when(
        () => mockLocalDataSource.getCachedProducts('featured'),
      ).thenAnswer((_) async => testProducts);

      // Act
      final result = await repository.getFeaturedProducts();

      // Assert
      expect(result.isSuccess, true);
      expect(result.getOrNull()?.length, 5);
    });
  });

  // ═══════════════════════════════════════════════════════════════
  // Error Handling
  // ═══════════════════════════════════════════════════════════════

  group('Error Handling', () {
    test('should return ServerFailure on server exception', () async {
      // Arrange
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(
        () => mockLocalDataSource.getCachedProducts(any()),
      ).thenAnswer((_) async => null);
      when(
        () => mockRemoteDataSource.getProducts(any()),
      ).thenThrow(ServerException(message: 'Server error'));

      // Act
      final result = await repository.getProducts();

      // Assert
      expect(result.isFailure, true);
      expect(result.failureOrNull, isA<ServerFailure>());
    });

    test('should return CacheFailure on cache exception', () async {
      // Arrange
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(
        () => mockLocalDataSource.getCachedProducts(any()),
      ).thenThrow(CacheException(message: 'Cache error'));

      // Act
      final result = await repository.getProducts();

      // Assert
      expect(result.isFailure, true);
      expect(result.failureOrNull, isA<CacheFailure>());
    });
  });
}
