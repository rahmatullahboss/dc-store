---
description: API endpoint integrate করার workflow
---

# API Integration Workflow

## Steps:

### 1. API Analysis

- Endpoint URL ও method confirm করো
- Request/Response structure বোঝো

### 2. Model Creation

Create Freezed model:

```dart
@freezed
class {Name} with _${Name} {
  const factory {Name}({
    required String id,
    // Add fields
  }) = _{Name};

  factory {Name}.fromJson(Map<String, dynamic> json) =>
      _${Name}FromJson(json);
}
```

### 3. Repository Method

Add to repository:

```dart
Future<{ReturnType}> {methodName}() async {
  try {
    final response = await _client.get('/api/{endpoint}');
    return {ReturnType}.fromJson(response.data['data']);
  } on DioException catch (e) {
    throw _handleError(e);
  }
}
```

### 4. Provider Creation

```dart
final {name}Provider = FutureProvider.autoDispose<{ReturnType}>((ref) async {
  final repository = ref.watch({feature}RepositoryProvider);
  return repository.{methodName}();
});
```

### 5. Code Generation

// turbo

```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

### 6. UI Integration

Use `.when()` pattern for async data.
