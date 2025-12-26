# Testing Guide for DC Store App

## Running Tests

### All Unit & Widget Tests

```bash
cd mobile_app
flutter test
```

### Specific Test File

```bash
flutter test test/unit/blocs/auth_bloc_test.dart
```

### With Coverage

```bash
flutter test --coverage

# Generate HTML report (requires lcov)
genhtml coverage/lcov.info -o coverage/html
open coverage/html/index.html
```

### Integration Tests

```bash
# On a device or emulator
flutter test integration_test/app_flows_test.dart

# On Chrome (for web)
flutter test integration_test --platform chrome
```

## Test Structure

```
test/
├── all_tests.dart           # Entry point for all tests
├── unit/
│   ├── blocs/               # BLoC/Cubit tests
│   ├── models/              # Model parsing tests
│   ├── repositories/        # Repository tests
│   ├── services/            # Service tests
│   └── utils/               # Utility tests
├── widgets/
│   ├── components/          # Individual widget tests
│   └── screens/             # Screen tests
├── integration/             # E2E flow tests
├── mocks/                   # Mock classes
├── fixtures/                # JSON fixtures
└── helpers/                 # Test utilities
```

## Writing Tests

### Unit Test (BLoC)

```dart
blocTest<AuthBloc, AuthState>(
  'emits [AuthLoading, AuthAuthenticated] on successful login',
  build: () => AuthBloc(),
  act: (bloc) => bloc.add(AuthLoginRequested(email: 'test@example.com', password: 'pass')),
  expect: () => [isA<AuthLoading>(), isA<AuthAuthenticated>()],
);
```

### Widget Test

```dart
testWidgets('displays product name', (tester) async {
  await tester.pumpApp(ProductCard(product: mockProduct));
  expect(find.text('Test Product'), findsOneWidget);
});
```

### Integration Test

```dart
testWidgets('complete checkout flow', (tester) async {
  app.main();
  await tester.pumpAndSettle();
  // Navigate and interact...
});
```

## Coverage Thresholds

Target: 80% minimum coverage for:

- BLoCs/Cubits
- Repository methods
- Utility functions
- Model parsing
