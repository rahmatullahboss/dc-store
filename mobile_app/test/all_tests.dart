// Test entry point for running all tests
// Usage: flutter test test/all_tests.dart

// Unit Tests
import 'unit/models/models_test.dart' as model_tests;

// Widget Tests
import 'widgets/screens/cart_screen_test.dart' as cart_screen_tests;

void main() {
  // Run all unit tests
  model_tests.main();

  // Run all widget tests
  cart_screen_tests.main();
}
