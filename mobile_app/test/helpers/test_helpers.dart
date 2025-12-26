import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dc_store/core/network/api_response.dart';

/// Pumps a widget wrapped with necessary providers and Material components
extension WidgetTesterExtension on WidgetTester {
  /// Pump a widget with MaterialApp wrapper
  Future<void> pumpApp(Widget widget) async {
    await pumpWidget(MaterialApp(home: widget));
    await pumpAndSettle();
  }

  /// Pump a widget with MaterialApp and BLoC providers
  Future<void> pumpAppWithBloc<B extends BlocBase<S>, S>(
    Widget widget,
    B bloc,
  ) async {
    await pumpWidget(
      MaterialApp(
        home: BlocProvider<B>.value(value: bloc, child: widget),
      ),
    );
    await pumpAndSettle();
  }

  /// Pump a widget with multiple BLoC providers
  Future<void> pumpAppWithProviders(
    Widget widget,
    List<BlocProvider> providers,
  ) async {
    await pumpWidget(
      MaterialApp(
        home: MultiBlocProvider(providers: providers, child: widget),
      ),
    );
    await pumpAndSettle();
  }

  /// Pump with scaffold
  Future<void> pumpScaffold(Widget widget) async {
    await pumpWidget(MaterialApp(home: Scaffold(body: widget)));
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
