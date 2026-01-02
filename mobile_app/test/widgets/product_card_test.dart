import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:network_image_mock/network_image_mock.dart';

import 'package:dc_store/presentation/common/widgets/product_card.dart';

// ═══════════════════════════════════════════════════════════════
// ProductCard Widget Tests
// These are smoke tests to ensure the widget builds without errors
// ═══════════════════════════════════════════════════════════════

/// Helper to wrap widget with ProviderScope and MaterialApp
Widget wrapWithProviders(Widget child) {
  return ProviderScope(
    child: MaterialApp(
      home: Scaffold(body: SizedBox(height: 450, width: 250, child: child)),
    ),
  );
}

void main() {
  group('ProductCard', () {
    testWidgets('renders product name correctly', (tester) async {
      await mockNetworkImagesFor(() async {
        await tester.pumpWidget(
          wrapWithProviders(
            ProductCard(
              id: 'test_product',
              name: 'Test Product Name',
              price: 1500.0,
            ),
          ),
        );
        await tester.pump();

        expect(find.text('Test Product Name'), findsOneWidget);
      });
    });

    testWidgets('renders without errors', (tester) async {
      await mockNetworkImagesFor(() async {
        await tester.pumpWidget(
          wrapWithProviders(
            ProductCard(
              id: 'test_product',
              name: 'Test Product',
              price: 1500.0,
            ),
          ),
        );
        await tester.pump();

        expect(find.byType(ProductCard), findsOneWidget);
      });
    });

    testWidgets('renders with compare price', (tester) async {
      await mockNetworkImagesFor(() async {
        await tester.pumpWidget(
          wrapWithProviders(
            ProductCard(
              id: 'test_product',
              name: 'Test Product',
              price: 1200.0,
              compareAtPrice: 1500.0,
            ),
          ),
        );
        await tester.pump();

        expect(find.byType(ProductCard), findsOneWidget);
      });
    });

    testWidgets('renders with discount', (tester) async {
      await mockNetworkImagesFor(() async {
        await tester.pumpWidget(
          wrapWithProviders(
            ProductCard(
              id: 'test_product',
              name: 'Test Product',
              price: 800.0,
              compareAtPrice: 1000.0,
            ),
          ),
        );
        await tester.pump();

        expect(find.byType(ProductCard), findsOneWidget);
      });
    });

    testWidgets('renders with featured flag', (tester) async {
      await mockNetworkImagesFor(() async {
        await tester.pumpWidget(
          wrapWithProviders(
            ProductCard(
              id: 'test_product',
              name: 'Test Product',
              price: 1000.0,
              isFeatured: true,
            ),
          ),
        );
        await tester.pump();

        expect(find.byType(ProductCard), findsOneWidget);
      });
    });

    testWidgets('renders with category', (tester) async {
      await mockNetworkImagesFor(() async {
        await tester.pumpWidget(
          wrapWithProviders(
            ProductCard(
              id: 'test_product',
              name: 'Test Product',
              price: 1000.0,
              category: 'Electronics',
            ),
          ),
        );
        await tester.pump();

        expect(find.byType(ProductCard), findsOneWidget);
      });
    });

    testWidgets('renders with wishlisted state', (tester) async {
      await mockNetworkImagesFor(() async {
        await tester.pumpWidget(
          wrapWithProviders(
            ProductCard(
              id: 'test_product',
              name: 'Test Product',
              price: 1000.0,
              isWishlisted: true,
            ),
          ),
        );
        await tester.pump();

        expect(find.byType(ProductCard), findsOneWidget);
      });
    });

    testWidgets('renders with callbacks', (tester) async {
      await mockNetworkImagesFor(() async {
        await tester.pumpWidget(
          wrapWithProviders(
            ProductCard(
              id: 'test_product',
              name: 'Test Product',
              price: 1000.0,
              onWishlistToggle: () {},
              onAddToCart: () {},
              onOrderNow: () {},
            ),
          ),
        );
        await tester.pump();

        expect(find.byType(ProductCard), findsOneWidget);
      });
    });
  });
}
