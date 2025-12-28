---
description: App release করার workflow
---

# Release Workflow

## Pre-Release Checklist

- [ ] flutter analyze passes
- [ ] flutter test passes
- [ ] সব features working
- [ ] Critical flows tested

## Steps:

### 1. Version Bump

Update `pubspec.yaml`:

```yaml
version: X.Y.Z+BUILD
```

### 2. Code Quality Check

// turbo

```bash
flutter clean && flutter pub get
```

// turbo

```bash
flutter analyze
```

// turbo

```bash
flutter test
```

### 3. Android Build

```bash
flutter build appbundle --release
flutter build apk --release --split-per-abi
```

### 4. iOS Build

```bash
flutter build ios --release
```

Then open Xcode and archive.

### 5. Testing

- Install release build on device
- Test critical flows

### 6. Store Submission

**Play Store:**

- Upload AAB
- Fill release notes

**App Store:**

- Upload via App Store Connect
- Fill release notes

### 7. Post-Release

- Create git tag
- Create GitHub release
