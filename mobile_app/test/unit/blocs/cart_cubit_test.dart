import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../lib/core/network/api_response.dart';
import '../../../lib/data/models/models.dart';
import '../../../lib/features/cart/bloc/cart_cubit.dart';
import '../../../lib/features/cart/bloc/cart_state.dart';
import '../../mocks/mock_factories.dart';
import '../../mocks/mock_repositories.dart';

void main() {
  group('CartCubit', () {
    late MockCartRepository mockCartRepository;

    setUp(() {
      mockCartRepository = MockCartRepository();

      // Register fallback values
      registerFallbackValue(CartFactory.createCart());
    });

    CartCubit createCubit() => CartCubit();

    group('addToCart', () {
      const testProductId = 'product_1';
      const testQuantity = 2;

      blocTest<CartCubit, CartState>(
        'emits updated cart with new item when adding product',
        setUp: () {
          final updatedCart = CartFactory.createCart(
            items: [
              CartFactory.createItem(
                productId: testProductId,
                quantity: testQuantity,
              ),
            ],
          );
          when(
            () => mockCartRepository.addToCart(testProductId, testQuantity),
          ).thenAnswer((_) async => ApiResponse.success(updatedCart));
        },
        build: createCubit,
        act: (cubit) => cubit.addToCart(
          productId: testProductId,
          productName: 'Test Product',
          price: 1000.0,
          image: 'https://example.com/image.jpg',
        ),
        verify: (cubit) {
          expect(cubit.state.items, isNotEmpty);
          expect(cubit.state.itemCount, greaterThan(0));
        },
      );

      blocTest<CartCubit, CartState>(
        'increases quantity when adding existing product',
        seed: () => CartState(
          items: [
            CartFactory.createItem(productId: testProductId, quantity: 1),
          ],
        ),
        build: createCubit,
        act: (cubit) => cubit.addToCart(
          productId: testProductId,
          productName: 'Test Product',
          price: 1000.0,
          image: 'https://example.com/image.jpg',
        ),
        verify: (cubit) {
          final item = cubit.state.items.firstWhere(
            (item) => item.productId == testProductId,
          );
          expect(item.quantity, equals(2));
        },
      );

      blocTest<CartCubit, CartState>(
        'updates totals correctly after adding item',
        build: createCubit,
        act: (cubit) => cubit.addToCart(
          productId: testProductId,
          productName: 'Test Product',
          price: 1000.0,
          image: 'https://example.com/image.jpg',
        ),
        verify: (cubit) {
          expect(cubit.state.subtotal, equals(1000.0));
          expect(cubit.state.total, greaterThanOrEqualTo(1000.0));
        },
      );
    });

    group('removeFromCart', () {
      const testItemId = 'cart_item_1';

      blocTest<CartCubit, CartState>(
        'removes item from cart',
        seed: () => CartState(
          items: [
            CartFactory.createItem(id: testItemId),
            CartFactory.createItem(id: 'cart_item_2'),
          ],
        ),
        build: createCubit,
        act: (cubit) => cubit.removeFromCart(testItemId),
        verify: (cubit) {
          expect(cubit.state.items.length, equals(1));
          expect(
            cubit.state.items.any((item) => item.id == testItemId),
            isFalse,
          );
        },
      );

      blocTest<CartCubit, CartState>(
        'cart becomes empty when removing last item',
        seed: () => CartState(items: [CartFactory.createItem(id: testItemId)]),
        build: createCubit,
        act: (cubit) => cubit.removeFromCart(testItemId),
        verify: (cubit) {
          expect(cubit.state.items, isEmpty);
          expect(cubit.state.isEmpty, isTrue);
        },
      );
    });

    group('updateQuantity', () {
      const testItemId = 'cart_item_1';

      blocTest<CartCubit, CartState>(
        'updates item quantity',
        seed: () => CartState(
          items: [CartFactory.createItem(id: testItemId, quantity: 1)],
        ),
        build: createCubit,
        act: (cubit) => cubit.updateQuantity(testItemId, 5),
        verify: (cubit) {
          final item = cubit.state.items.firstWhere((i) => i.id == testItemId);
          expect(item.quantity, equals(5));
        },
      );

      blocTest<CartCubit, CartState>(
        'removes item when quantity is 0',
        seed: () => CartState(
          items: [CartFactory.createItem(id: testItemId, quantity: 1)],
        ),
        build: createCubit,
        act: (cubit) => cubit.updateQuantity(testItemId, 0),
        verify: (cubit) {
          expect(cubit.state.items, isEmpty);
        },
      );

      blocTest<CartCubit, CartState>(
        'recalculates totals after quantity update',
        seed: () => CartState(
          items: [
            CartFactory.createItem(id: testItemId, price: 1000.0, quantity: 1),
          ],
        ),
        build: createCubit,
        act: (cubit) => cubit.updateQuantity(testItemId, 3),
        verify: (cubit) {
          expect(cubit.state.subtotal, equals(3000.0));
        },
      );
    });

    group('applyCoupon', () {
      const testCouponCode = 'SAVE10';

      blocTest<CartCubit, CartState>(
        'applies coupon and updates discount',
        seed: () => CartState(
          items: [CartFactory.createItem(price: 1000.0, quantity: 2)],
        ),
        setUp: () {
          when(() => mockCartRepository.applyCoupon(testCouponCode)).thenAnswer(
            (_) async => ApiResponse.success(
              CartFactory.createCart(
                coupon: CartFactory.createCoupon(
                  code: testCouponCode,
                  discountPercent: 10,
                ),
              ),
            ),
          );
        },
        build: createCubit,
        act: (cubit) => cubit.applyCoupon(testCouponCode),
        verify: (cubit) {
          expect(cubit.state.appliedCoupon, isNotNull);
          expect(cubit.state.appliedCoupon?.code, equals(testCouponCode));
        },
      );

      blocTest<CartCubit, CartState>(
        'removes coupon when removeCoupon is called',
        seed: () => CartState(
          items: [CartFactory.createItem()],
          appliedCoupon: CartFactory.createCoupon(),
        ),
        build: createCubit,
        act: (cubit) => cubit.removeCoupon(),
        verify: (cubit) {
          expect(cubit.state.appliedCoupon, isNull);
          expect(cubit.state.discount, equals(0.0));
        },
      );
    });

    group('clearCart', () {
      blocTest<CartCubit, CartState>(
        'clears all items and resets state',
        seed: () => CartState(
          items: CartFactory.createCart().items,
          appliedCoupon: CartFactory.createCoupon(),
        ),
        build: createCubit,
        act: (cubit) => cubit.clearCart(),
        verify: (cubit) {
          expect(cubit.state.items, isEmpty);
          expect(cubit.state.appliedCoupon, isNull);
          expect(cubit.state.subtotal, equals(0.0));
          expect(cubit.state.total, equals(0.0));
        },
      );
    });

    group('Cart calculations', () {
      test('calculates subtotal correctly', () {
        final cubit = createCubit();
        cubit.addToCart(
          productId: 'p1',
          productName: 'Product 1',
          price: 500.0,
          image: '',
        );
        cubit.addToCart(
          productId: 'p2',
          productName: 'Product 2',
          price: 700.0,
          image: '',
        );

        expect(cubit.state.subtotal, equals(1200.0));
      });

      test('calculates discount with percentage coupon', () {
        final cubit = createCubit();
        cubit.addToCart(
          productId: 'p1',
          productName: 'Product 1',
          price: 1000.0,
          image: '',
        );
        cubit.applyCoupon('SAVE10'); // 10% discount

        // Discount should be 10% of 1000 = 100
        expect(cubit.state.discount, equals(100.0));
      });

      test('calculates shipping correctly', () {
        final cubit = createCubit();
        cubit.addToCart(
          productId: 'p1',
          productName: 'Product 1',
          price: 500.0, // Below free shipping threshold
          image: '',
        );

        expect(cubit.state.shipping, greaterThan(0));
      });

      test('free shipping above threshold', () {
        final cubit = createCubit();
        // Add items totaling more than free shipping threshold (5000)
        for (int i = 0; i < 6; i++) {
          cubit.addToCart(
            productId: 'p$i',
            productName: 'Product $i',
            price: 1000.0,
            image: '',
          );
        }

        expect(cubit.state.shipping, equals(0.0));
      });
    });
  });
}
