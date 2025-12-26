// Test entry point for running all tests
// Usage: flutter test test/all_tests.dart

// Unit Tests
import 'unit/blocs/auth_bloc_test.dart' as auth_bloc_tests;
import 'unit/blocs/cart_cubit_test.dart' as cart_cubit_tests;
import 'unit/models/models_test.dart' as model_tests;

// Widget Tests
import 'widgets/screens/cart_screen_test.dart' as cart_screen_tests;

void main() {
  // Run all unit tests
  auth_bloc_tests.main();
  cart_cubit_tests.main();
  model_tests.main();

  // Run all widget tests
  cart_screen_tests.main();
}
