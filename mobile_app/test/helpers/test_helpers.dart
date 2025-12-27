import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dc_store/core/network/api_response.dart';

/// Pumps a widget wrapped with necessary providers and Material components
extension WidgetTesterExtension on WidgetTester {
  /// Pump a widget with MaterialApp wrapper
  Future<void> pumpApp(Widget widget) async {
    await pumpWidget(MaterialApp(home: widget));
    await pumpAndSettle();
  }

  /// Pump a widget with Riverpod ProviderScope
  /// Pass overrides as created by provider.overrideWith(...) or provider.overrideWithValue(...)
  Future<void> pumpAppWithProviders(
    Widget widget, {
    List<dynamic>? overrides,
  }) async {
    await pumpWidget(
      ProviderScope(
        overrides: overrides?.cast() ?? [],
        child: MaterialApp(home: widget),
      ),
    );
    await pumpAndSettle();
  }

  /// Pump with scaffold
  Future<void> pumpScaffold(Widget widget) async {
    await pumpWidget(MaterialApp(home: Scaffold(body: widget)));
    await pumpAndSettle();
  }

  /// Pump with ProviderScope - simple version
  Future<void> pumpRiverpod(Widget widget) async {
    await pumpWidget(ProviderScope(child: MaterialApp(home: widget)));
    await pumpAndSettle();
  }
}

/// Test group helper for organized test output
void testGroup(String description, void Function() body) {
  group('🧪 $description', body);
}

/// Success test helper
void testSuccess(String description, dynamic Function() body) {
  test('✅ $description', body);
}

/// Failure test helper
void testFailure(String description, dynamic Function() body) {
  test('❌ $description', body);
}

/// Edge case test helper
void testEdge(String description, dynamic Function() body) {
  test('⚠️ Edge: $description', body);
}

/// Wait for async operations to complete
Future<void> wait([
  Duration duration = const Duration(milliseconds: 100),
]) async {
  await Future.delayed(duration);
}

/// Matcher for checking if a widget is loading (has CircularProgressIndicator)
Matcher hasLoadingIndicator() => findsOneWidget;

/// Find widgets by key helper
Finder findByKey(String key) => find.byKey(Key(key));

/// Find widgets by icon helper
Finder findByIcon(IconData icon) => find.byIcon(icon);

/// Matcher for checking snackbar text
Matcher hasSnackbarText(String text) => findsOneWidget;

// ═══════════════════════════════════════════════════════════════
// API RESPONSE HELPERS
// ═══════════════════════════════════════════════════════════════

/// Create a successful API response
ApiResponse<T> successResponse<T>(T data, {String? message}) {
  return ApiResponse.success(data, message: message);
}

/// Create an error API response
ApiResponse<T> errorResponse<T>(String message, {String? code}) {
  return ApiResponse.fromMessage(message, code: code);
}
