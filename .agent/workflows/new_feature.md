---
description: নতুন feature develop করার workflow
---

# New Feature Development Workflow

## Steps:

### 1. Requirements Analysis

- Feature requirements clearly বোঝো
- API endpoints identify করো
- UI/UX design review করো

### 2. Data Layer

Create these files:

- `lib/data/models/{feature}_model.dart`
- `lib/features/{feature}/data/{feature}_repository.dart`

### 3. Feature Layer

- Provider/Controller create করো
- State class define করো (with Freezed)

### 4. Presentation Layer

- Screen create করো: `lib/presentation/{feature}/{feature}_screen.dart`
- Widgets create করো

### 5. Integration

- Route add করো: `lib/navigation/app_router.dart`

### 6. Code Generation

// turbo

```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

### 7. Testing

- Unit tests লেখো
- Widget tests লেখো
