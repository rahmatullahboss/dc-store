---
description: Bug fix করার workflow
---

# Bug Fix Workflow

## Steps:

### 1. Bug Analysis

- Error message পড়ো
- Reproduction steps বোঝো
- Expected vs actual behavior বোঝো

### 2. Reproduce

// turbo

```bash
flutter run --debug
```

### 3. Root Cause Analysis

**Network Issues:**

- [ ] API endpoint correct?
- [ ] Authorization header?

**State Issues:**

- [ ] Provider properly defined?
- [ ] ref.watch vs ref.read correct?

**UI Issues:**

- [ ] Overflow?
- [ ] Null check?

### 4. Fix Implementation

- Minimal change এ fix করো
- Side effects consider করো

### 5. Testing

// turbo

```bash
flutter analyze && flutter test
```

### 6. Documentation

- Root cause document করো
- Test case লেখো
