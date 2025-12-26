import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:dc_store/core/utils/either.dart';
import 'package:dc_store/core/errors/failures.dart';
import 'package:dc_store/core/errors/exceptions.dart';
import 'package:dc_store/core/network/network_info.dart';
import 'package:dc_store/data/repositories/wishlist_repository.dart';
import 'package:dc_store/data/datasources/remote/wishlist_remote_datasource.dart';
import 'package:dc_store/data/datasources/local/wishlist_local_datasource.dart';
import 'package:dc_store/data/models/wishlist/wishlist_model.dart';

// ═══════════════════════════════════════════════════════════════
// MOCKS
// ═══════════════════════════════════════════════════════════════

class MockWishlistRemoteDataSource extends Mock
    implements IWishlistRemoteDataSource {}

class MockWishlistLocalDataSource extends Mock
    implements IWishlistLocalDataSource {}

class MockNetworkInfo extends Mock implements NetworkInfo {}

// ═══════════════════════════════════════════════════════════════
// FACTORIES
// ═══════════════════════════════════════════════════════════════

class WishlistFactory {
  static WishlistModel create({String? id, List<WishlistItemModel>? items}) {
    return WishlistModel(
      id: id ?? 'wishlist_1',
      items:
          items ??
          [
            WishlistItemModel(
              id: 'item_1',
              productId: 'product_1',
              addedAt: DateTime.now(),
            ),
            WishlistItemModel(
              id: 'item_2',
              productId: 'product_2',
              addedAt: DateTime.now(),
            ),
          ],
    );
  }

  static WishlistItemModel createItem({String? id, String? productId}) {
    return WishlistItemModel(
      id: id ?? 'item_${DateTime.now().millisecondsSinceEpoch}',
      productId: productId ?? 'product_1',
      addedAt: DateTime.now(),
    );
  }
}

void main() {
  late WishlistRepository repository;
  late MockWishlistRemoteDataSource mockRemoteDataSource;
  late MockWishlistLocalDataSource mockLocalDataSource;
  late MockNetworkInfo mockNetworkInfo;

  setUp(() {
    mockRemoteDataSource = MockWishlistRemoteDataSource();
    mockLocalDataSource = MockWishlistLocalDataSource();
    mockNetworkInfo = MockNetworkInfo();

    repository = WishlistRepository(
      remoteDataSource: mockRemoteDataSource,
      localDataSource: mockLocalDataSource,
      networkInfo: mockNetworkInfo,
    );
  });

  // ═══════════════════════════════════════════════════════════════
  // getWishlist
  // ═══════════════════════════════════════════════════════════════

  group('getWishlist', () {
    final testWishlist = WishlistFactory.create();

    test('should return wishlist from remote when online', () async {
      // Arrange
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(
        () => mockLocalDataSource.getCachedWishlist(),
      ).thenAnswer((_) async => null);
      when(
        () => mockRemoteDataSource.getWishlist(),
      ).thenAnswer((_) async => testWishlist);
      when(
        () => mockLocalDataSource.cacheWishlist(any()),
      ).thenAnswer((_) async {});

      // Act
      final result = await repository.getWishlist();

      // Assert
      expect(result.isSuccess, true);
      expect(result.getOrNull()?.items.length, 2);
      verify(() => mockRemoteDataSource.getWishlist()).called(1);
    });

    test('should return cached wishlist when offline', () async {
      // Arrange
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => false);
      when(
        () => mockLocalDataSource.getCachedWishlist(),
      ).thenAnswer((_) async => testWishlist);

      // Act
      final result = await repository.getWishlist();

      // Assert
      expect(result.isSuccess, true);
      expect(result.getOrNull()?.items.length, 2);
      verifyNever(() => mockRemoteDataSource.getWishlist());
    });

    test('should return empty wishlist when offline without cache', () async {
      // Arrange
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => false);
      when(
        () => mockLocalDataSource.getCachedWishlist(),
      ).thenAnswer((_) async => null);

      // Act
      final result = await repository.getWishlist();

      // Assert
      expect(result.isSuccess, true);
      expect(result.getOrNull()?.id, 'local');
    });
  });

  // ═══════════════════════════════════════════════════════════════
  // addToWishlist
  // ═══════════════════════════════════════════════════════════════

  group('addToWishlist', () {
    const testProductId = 'product_new';
    final testWishlist = WishlistFactory.create();
    final newWishlist = WishlistFactory.create(
      items: [
        ...testWishlist.items,
        WishlistFactory.createItem(productId: testProductId),
      ],
    );

    test('should add product to wishlist when online', () async {
      // Arrange
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(
        () => mockLocalDataSource.getCachedWishlist(),
      ).thenAnswer((_) async => testWishlist);
      when(
        () => mockLocalDataSource.cacheWishlist(any()),
      ).thenAnswer((_) async {});
      when(
        () => mockRemoteDataSource.addToWishlist(testProductId),
      ).thenAnswer((_) async => newWishlist);

      // Act
      final result = await repository.addToWishlist(testProductId);

      // Assert
      expect(result.isSuccess, true);
      verify(() => mockRemoteDataSource.addToWishlist(testProductId)).called(1);
    });

    test('should perform optimistic update when adding', () async {
      // Arrange
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(
        () => mockLocalDataSource.getCachedWishlist(),
      ).thenAnswer((_) async => testWishlist);
      when(
        () => mockLocalDataSource.cacheWishlist(any()),
      ).thenAnswer((_) async {});
      when(
        () => mockRemoteDataSource.addToWishlist(testProductId),
      ).thenAnswer((_) async => newWishlist);

      // Act
      await repository.addToWishlist(testProductId);

      // Assert - Should cache twice: optimistic + final
      verify(() => mockLocalDataSource.cacheWishlist(any())).called(2);
    });

    test('should keep optimistic update when offline', () async {
      // Arrange
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => false);
      when(
        () => mockLocalDataSource.getCachedWishlist(),
      ).thenAnswer((_) async => testWishlist);
      when(
        () => mockLocalDataSource.cacheWishlist(any()),
      ).thenAnswer((_) async {});

      // Act
      final result = await repository.addToWishlist(testProductId);

      // Assert
      expect(result.isSuccess, true);
      verifyNever(() => mockRemoteDataSource.addToWishlist(any()));
    });
  });

  // ═══════════════════════════════════════════════════════════════
  // removeFromWishlist
  // ═══════════════════════════════════════════════════════════════

  group('removeFromWishlist', () {
    const testProductId = 'product_1';
    final testWishlist = WishlistFactory.create();
    final updatedWishlist = WishlistFactory.create(
      items: testWishlist.items
          .where((i) => i.productId != testProductId)
          .toList(),
    );

    test('should remove product from wishlist when online', () async {
      // Arrange
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(
        () => mockLocalDataSource.getCachedWishlist(),
      ).thenAnswer((_) async => testWishlist);
      when(
        () => mockLocalDataSource.cacheWishlist(any()),
      ).thenAnswer((_) async {});
      when(
        () => mockRemoteDataSource.removeFromWishlist(testProductId),
      ).thenAnswer((_) async => updatedWishlist);

      // Act
      final result = await repository.removeFromWishlist(testProductId);

      // Assert
      expect(result.isSuccess, true);
      verify(
        () => mockRemoteDataSource.removeFromWishlist(testProductId),
      ).called(1);
    });

    test('should perform optimistic update when removing', () async {
      // Arrange
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(
        () => mockLocalDataSource.getCachedWishlist(),
      ).thenAnswer((_) async => testWishlist);
      when(
        () => mockLocalDataSource.cacheWishlist(any()),
      ).thenAnswer((_) async {});
      when(
        () => mockRemoteDataSource.removeFromWishlist(testProductId),
      ).thenAnswer((_) async => updatedWishlist);

      // Act
      await repository.removeFromWishlist(testProductId);

      // Assert - Should cache twice: optimistic + final
      verify(() => mockLocalDataSource.cacheWishlist(any())).called(2);
    });
  });

  // ═══════════════════════════════════════════════════════════════
  // isInWishlist
  // ═══════════════════════════════════════════════════════════════

  group('isInWishlist', () {
    test('should return true when product is in wishlist', () async {
      // Arrange
      final testWishlist = WishlistFactory.create();
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => false);
      when(
        () => mockLocalDataSource.getCachedWishlist(),
      ).thenAnswer((_) async => testWishlist);

      // Act
      final result = await repository.isInWishlist('product_1');

      // Assert
      expect(result.isSuccess, true);
      expect(result.getOrNull(), true);
    });

    test('should return false when product is not in wishlist', () async {
      // Arrange
      final testWishlist = WishlistFactory.create();
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => false);
      when(
        () => mockLocalDataSource.getCachedWishlist(),
      ).thenAnswer((_) async => testWishlist);

      // Act
      final result = await repository.isInWishlist('product_not_exists');

      // Assert
      expect(result.isSuccess, true);
      expect(result.getOrNull(), false);
    });
  });

  // ═══════════════════════════════════════════════════════════════
  // getWishlistCount
  // ═══════════════════════════════════════════════════════════════

  group('getWishlistCount', () {
    test('should return correct count', () async {
      // Arrange
      final testWishlist = WishlistFactory.create();
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => false);
      when(
        () => mockLocalDataSource.getCachedWishlist(),
      ).thenAnswer((_) async => testWishlist);

      // Act
      final result = await repository.getWishlistCount();

      // Assert
      expect(result.isSuccess, true);
      expect(result.getOrNull(), 2);
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
        () => mockLocalDataSource.getCachedWishlist(),
      ).thenAnswer((_) async => null);
      when(
        () => mockRemoteDataSource.getWishlist(),
      ).thenThrow(ServerException(message: 'Server error'));

      // Act
      final result = await repository.getWishlist();

      // Assert
      expect(result.isFailure, true);
      expect(result.failureOrNull, isA<ServerFailure>());
    });

    test('should return NetworkFailure when sync fails offline', () async {
      // Arrange
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => false);

      // Act
      final result = await repository.syncWishlist();

      // Assert
      expect(result.isFailure, true);
      expect(result.failureOrNull, isA<NetworkFailure>());
    });
  });
}
