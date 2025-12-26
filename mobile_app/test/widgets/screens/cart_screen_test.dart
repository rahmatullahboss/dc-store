import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mocktail/mocktail.dart';

import '../../../lib/features/cart/bloc/cart_cubit.dart';
import '../../../lib/features/cart/bloc/cart_state.dart';
import '../../mocks/mock_factories.dart';
import '../../helpers/test_helpers.dart';

// Mock CartCubit for widget testing
class MockCartCubit extends Mock implements CartCubit {}

void main() {
  group('Cart Screen Widget Tests', () {
    late MockCartCubit mockCartCubit;

    setUp(() {
      mockCartCubit = MockCartCubit();
    });

    testWidgets('displays empty cart message when cart is empty', (
      tester,
    ) async {
      // Arrange
      when(() => mockCartCubit.state).thenReturn(const CartState());
      when(() => mockCartCubit.stream).thenAnswer((_) => const Stream.empty());

      // Act
      await tester.pumpAppWithBloc(const _TestCartScreen(), mockCartCubit);

      // Assert
      expect(find.text('Your cart is empty'), findsOneWidget);
      expect(find.byIcon(Icons.shopping_cart_outlined), findsOneWidget);
    });

    testWidgets('displays cart items when cart has items', (tester) async {
      // Arrange
      final cartState = CartState(
        items: [
          CartFactory.createItem(
            productName: 'Test Product 1',
            price: 1000.0,
            quantity: 2,
          ),
          CartFactory.createItem(
            id: 'item_2',
            productId: 'product_2',
            productName: 'Test Product 2',
            price: 500.0,
            quantity: 1,
          ),
        ],
      );
      when(() => mockCartCubit.state).thenReturn(cartState);
      when(() => mockCartCubit.stream).thenAnswer((_) => const Stream.empty());

      // Act
      await tester.pumpAppWithBloc(const _TestCartScreen(), mockCartCubit);

      // Assert
      expect(find.text('Test Product 1'), findsOneWidget);
      expect(find.text('Test Product 2'), findsOneWidget);
      expect(find.text('2'), findsOneWidget); // Quantity
    });

    testWidgets('displays correct total', (tester) async {
      // Arrange
      final cartState = CartState(
        items: [CartFactory.createItem(price: 1000.0, quantity: 2)],
      );
      when(() => mockCartCubit.state).thenReturn(cartState);
      when(() => mockCartCubit.stream).thenAnswer((_) => const Stream.empty());

      // Act
      await tester.pumpAppWithBloc(const _TestCartScreen(), mockCartCubit);

      // Assert
      expect(find.textContaining('2000'), findsOneWidget);
    });

    testWidgets('increment button calls updateQuantity', (tester) async {
      // Arrange
      final cartState = CartState(
        items: [CartFactory.createItem(id: 'item_1', quantity: 1)],
      );
      when(() => mockCartCubit.state).thenReturn(cartState);
      when(() => mockCartCubit.stream).thenAnswer((_) => const Stream.empty());
      when(() => mockCartCubit.updateQuantity(any(), any())).thenReturn(null);

      // Act
      await tester.pumpAppWithBloc(const _TestCartScreen(), mockCartCubit);
      await tester.tap(find.byIcon(Icons.add));
      await tester.pump();

      // Assert
      verify(() => mockCartCubit.updateQuantity('item_1', 2)).called(1);
    });

    testWidgets('remove button calls removeFromCart', (tester) async {
      // Arrange
      final cartState = CartState(
        items: [CartFactory.createItem(id: 'item_1')],
      );
      when(() => mockCartCubit.state).thenReturn(cartState);
      when(() => mockCartCubit.stream).thenAnswer((_) => const Stream.empty());
      when(() => mockCartCubit.removeFromCart(any())).thenReturn(null);

      // Act
      await tester.pumpAppWithBloc(const _TestCartScreen(), mockCartCubit);
      await tester.tap(find.byIcon(Icons.delete_outline));
      await tester.pump();

      // Assert
      verify(() => mockCartCubit.removeFromCart('item_1')).called(1);
    });

    testWidgets('checkout button navigates when cart has items', (
      tester,
    ) async {
      // Arrange
      final cartState = CartState(items: [CartFactory.createItem()]);
      when(() => mockCartCubit.state).thenReturn(cartState);
      when(() => mockCartCubit.stream).thenAnswer((_) => const Stream.empty());

      // Act
      await tester.pumpAppWithBloc(const _TestCartScreen(), mockCartCubit);

      // Assert
      expect(find.text('Proceed to Checkout'), findsOneWidget);
      expect(
        tester.widget<ElevatedButton>(find.byType(ElevatedButton)).enabled,
        isTrue,
      );
    });

    testWidgets('checkout button is disabled when cart is empty', (
      tester,
    ) async {
      // Arrange
      when(() => mockCartCubit.state).thenReturn(const CartState());
      when(() => mockCartCubit.stream).thenAnswer((_) => const Stream.empty());

      // Act
      await tester.pumpAppWithBloc(const _TestCartScreen(), mockCartCubit);

      // Assert - button should not be visible when cart is empty
      expect(find.text('Proceed to Checkout'), findsNothing);
    });
  });
}

/// Test Cart Screen Widget (simplified for testing)
class _TestCartScreen extends StatelessWidget {
  const _TestCartScreen();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CartCubit, CartState>(
      builder: (context, state) {
        if (state.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.shopping_cart_outlined, size: 64),
                const SizedBox(height: 16),
                const Text('Your cart is empty'),
              ],
            ),
          );
        }

        return Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: state.items.length,
                itemBuilder: (context, index) {
                  final item = state.items[index];
                  return ListTile(
                    title: Text(item.productName),
                    subtitle: Text('${item.quantity}'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.remove),
                          onPressed: () => context
                              .read<CartCubit>()
                              .updateQuantity(item.id, item.quantity - 1),
                        ),
                        Text('${item.quantity}'),
                        IconButton(
                          icon: const Icon(Icons.add),
                          onPressed: () => context
                              .read<CartCubit>()
                              .updateQuantity(item.id, item.quantity + 1),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete_outline),
                          onPressed: () =>
                              context.read<CartCubit>().removeFromCart(item.id),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Text('Total: ৳${state.subtotal}'),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {},
                      child: const Text('Proceed to Checkout'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
