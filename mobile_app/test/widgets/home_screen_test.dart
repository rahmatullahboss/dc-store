import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:network_image_mock/network_image_mock.dart';

import 'package:dc_store/presentation/home/home_screen.dart';

// ═══════════════════════════════════════════════════════════════
// HomeScreen Widget Tests
// ═══════════════════════════════════════════════════════════════

void main() {
  group('HomeScreen', () {
    testWidgets('renders correctly', (tester) async {
      await mockNetworkImagesFor(() async {
        await tester.pumpWidget(
          const ProviderScope(child: MaterialApp(home: HomeScreen())),
        );

        // Should render HomeScreen
        expect(find.byType(HomeScreen), findsOneWidget);
      });
    });

    testWidgets('contains app bar with search', (tester) async {
      await mockNetworkImagesFor(() async {
        await tester.pumpWidget(
          const ProviderScope(child: MaterialApp(home: HomeScreen())),
        );
        await tester.pumpAndSettle(const Duration(milliseconds: 500));

        // Should have at least one search-related widget
        expect(find.byType(TextField), findsWidgets);
      });
    });

    testWidgets('contains scrollable content', (tester) async {
      await mockNetworkImagesFor(() async {
        await tester.pumpWidget(
          const ProviderScope(child: MaterialApp(home: HomeScreen())),
        );
        await tester.pumpAndSettle(const Duration(milliseconds: 500));

        // Should have scrollable content
        expect(find.byType(SingleChildScrollView), findsWidgets);
      });
    });

    testWidgets('renders in dark mode', (tester) async {
      await mockNetworkImagesFor(() async {
        await tester.pumpWidget(
          ProviderScope(
            child: MaterialApp(
              theme: ThemeData.dark(),
              home: const HomeScreen(),
            ),
          ),
        );
        await tester.pump();

        // Should render without errors in dark mode
        expect(find.byType(HomeScreen), findsOneWidget);
      });
    });

    testWidgets('handles nested scroll view', (tester) async {
      await mockNetworkImagesFor(() async {
        await tester.pumpWidget(
          const ProviderScope(child: MaterialApp(home: HomeScreen())),
        );
        await tester.pumpAndSettle(const Duration(milliseconds: 500));

        // Should have nested scroll view for complex layout
        expect(find.byType(CustomScrollView), findsWidgets);
      });
    });
  });
}
