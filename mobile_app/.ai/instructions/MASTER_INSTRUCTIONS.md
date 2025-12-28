# 🎯 DC Store Flutter App - Master AI Instructions

## 📌 Project Overview

এটি একটি production-grade Flutter e-commerce application যা Next.js backend থেকে data fetch করে।

## 🏗️ Architecture: Clean Architecture + Riverpod

### Layer বিভাজন:

```
┌─────────────────────────────────────────────────────┐
│                  PRESENTATION                        │
│  (Pages, Widgets, Controllers/Providers)            │
├─────────────────────────────────────────────────────┤
│                    FEATURES                          │
│  (Feature-based modules with data/domain layers)    │
├─────────────────────────────────────────────────────┤
│                    DOMAIN                            │
│  (Entities, Repository Interfaces)                  │
├─────────────────────────────────────────────────────┤
│                     DATA                             │
│  (Models, Repository Impl, Data Sources)            │
├─────────────────────────────────────────────────────┤
│                     CORE                             │
│  (Network, Theme, Utils, Constants, Providers)      │
└─────────────────────────────────────────────────────┘
```

## 🔐 Backend API Configuration

- Base URL: Configured in `lib/core/config/`
- Authentication: Better Auth (JWT Bearer Token)
- Content-Type: application/json

## ✅ Code Generation Rules

### 1. সব সময় যা করতে হবে:

- Null safety ব্যবহার করো
- Proper error handling implement করো
- Loading states handle করো
- Empty states handle করো
- Responsive design maintain করো
- Bengali & English both language support রাখো

### 2. কখনো যা করবে না:

- Hard-coded strings ব্যবহার করো না (constants ব্যবহার করো)
- Magic numbers ব্যবহার করো না
- print() statements রাখো না (Logger ব্যবহার করো)
- Business logic UI তে রাখো না

### 3. Naming Conventions:

- Files: snake_case (user_profile_page.dart)
- Classes: PascalCase (UserProfilePage)
- Variables/Functions: camelCase (getUserData)
- Constants: kCamelCase (kPrimaryColor)
- Providers: camelCaseProvider (authControllerProvider)
- States: PascalCase (AuthState)

## 📦 Current Packages (pubspec.yaml)

```yaml
dependencies:
  flutter_riverpod: ^3.0.3 # State Management
  dio: ^5.7.0 # Networking
  go_router: ^17.0.1 # Navigation
  freezed_annotation: ^2.4.1 # Immutable data classes
  json_annotation: ^4.9.0 # JSON serialization
  cached_network_image: ^3.4.1 # Image caching
  shimmer: ^3.0.0 # Loading skeleton
  flutter_secure_storage: ^10.0.0 # Secure storage
  flutter_screenutil: ^5.9.3 # Responsive design
  google_fonts: ^6.3.3 # Typography
  lucide_icons: ^0.257.0 # Icons

dev_dependencies:
  build_runner: ^2.4.13
  freezed: ^2.5.2
  json_serializable: ^6.8.0
  mocktail: ^1.0.4
```

## 📁 Project Structure

```
mobile_app/
├── lib/
│   ├── config/
│   │   └── white_label_config.dart
│   ├── core/
│   │   ├── cache/
│   │   ├── config/
│   │   ├── constants/
│   │   ├── errors/
│   │   ├── network/
│   │   │   ├── api_client.dart
│   │   │   ├── dio_client.dart
│   │   │   └── interceptors/
│   │   ├── providers/
│   │   ├── theme/
│   │   └── utils/
│   ├── data/
│   │   ├── models/
│   │   └── ... (data layer files)
│   ├── domain/
│   │   └── repositories/
│   ├── features/
│   │   ├── auth/
│   │   │   ├── controllers/
│   │   │   ├── data/
│   │   │   └── presentation/
│   │   ├── cart/
│   │   ├── checkout/
│   │   ├── orders/
│   │   └── product/
│   ├── l10n/
│   ├── navigation/
│   │   └── app_router.dart
│   ├── presentation/
│   │   ├── home/
│   │   ├── profile/
│   │   └── ... (screens)
│   ├── services/
│   └── main.dart
├── test/
├── integration_test/
└── pubspec.yaml
```

## 🚨 Critical Rules

### 1. ALWAYS Use Context7 for Documentation

```
❌ WRONG: Rely on training data (may be outdated)
✅ RIGHT: Always use Context7 MCP tools to fetch latest docs
```

**Before using any library:**

1. Call `resolve-library-id` to find the library
2. Call `get-library-docs` with relevant topic
3. Use the latest patterns and APIs from the docs

### 2. Search Web for Latest Best Practices

```
✅ Always search web for:
- "Flutter Riverpod 3.0 best practices 2024"
- "Dio interceptors Flutter"
- "Flutter Clean Architecture patterns"
```

## ✅ Pre-Commit Checklist

- [ ] `flutter analyze` passes without errors
- [ ] `flutter test` runs successfully
- [ ] Responsive on different screen sizes
- [ ] Error states handled gracefully
- [ ] Loading states implemented
