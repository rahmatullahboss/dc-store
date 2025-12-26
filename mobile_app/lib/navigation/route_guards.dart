import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../services/storage_service.dart';
import '../core/constants/storage_keys.dart';
import 'app_routes.dart';

/// Route Guards for protecting routes
class RouteGuards {
  final StorageService _storageService;

  RouteGuards(this._storageService);

  /// Check if user is authenticated
  bool get isAuthenticated {
    final token = _storageService.getString(StorageKeys.authToken);
    return token != null && token.isNotEmpty;
  }

  /// Check if onboarding is completed
  bool get isOnboardingCompleted {
    return _storageService.getBool(StorageKeys.onboardingComplete) ?? false;
  }

  /// Get user role
  String? get userRole {
    return _storageService.getString(StorageKeys.userId); // Could be a role key
  }

  /// Auth Guard - Redirects to login if not authenticated
  String? authGuard(GoRouterState state) {
    if (!isAuthenticated) {
      debugPrint('Auth Guard: Not authenticated, redirecting to login');
      // Store the intended destination for redirect after login
      final from = state.uri.toString();
      return '${AppRoutes.loginPath}?from=$from';
    }
    return null; // Allow navigation
  }

  /// Guest Guard - Redirects to home if already authenticated
  String? guestGuard(GoRouterState state) {
    if (isAuthenticated) {
      debugPrint('Guest Guard: Already authenticated, redirecting to home');
      return AppRoutes.homePath;
    }
    return null; // Allow navigation
  }

  /// Onboarding Guard - Redirects based on onboarding status
  String? onboardingGuard(GoRouterState state) {
    if (!isOnboardingCompleted) {
      debugPrint('Onboarding Guard: Onboarding not completed');
      return AppRoutes.onboardingPath;
    }
    return null;
  }

  /// Role-based Guard
  String? roleGuard(GoRouterState state, List<String> allowedRoles) {
    if (!isAuthenticated) {
      return AppRoutes.loginPath;
    }

    final role = userRole;
    if (role == null || !allowedRoles.contains(role)) {
      debugPrint('Role Guard: Access denied for role: $role');
      return AppRoutes.homePath; // Redirect to home if role not allowed
    }
    return null;
  }

  /// Admin Guard - Only allows admin users
  String? adminGuard(GoRouterState state) {
    return roleGuard(state, ['admin', 'super_admin']);
  }

  /// Combined redirect logic for the app
  String? redirect(BuildContext context, GoRouterState state) {
    final path = state.uri.path;
    debugPrint('Router redirect check: $path');

    // Splash screen handling
    if (path == AppRoutes.splashPath) {
      return null; // Allow splash
    }

    // Auth routes - apply guest guard
    if (_isAuthRoute(path)) {
      return guestGuard(state);
    }

    // Protected routes - apply auth guard
    if (_isProtectedRoute(path)) {
      return authGuard(state);
    }

    // Check onboarding for first-time users
    if (path == AppRoutes.homePath && !isOnboardingCompleted) {
      // Only redirect to onboarding if coming from splash
      final fromSplash =
          state.extra is Map && (state.extra as Map)['fromSplash'] == true;
      if (fromSplash) {
        return AppRoutes.onboardingPath;
      }
    }

    return null;
  }

  bool _isAuthRoute(String path) {
    return path == AppRoutes.loginPath ||
        path == AppRoutes.registerPath ||
        path == AppRoutes.forgotPasswordPath ||
        path == AppRoutes.resetPasswordPath;
  }

  bool _isProtectedRoute(String path) {
    // Routes that require authentication
    return path.startsWith('/checkout') ||
        path.startsWith('/orders') ||
        path == AppRoutes.wishlistPath ||
        path.startsWith('/profile/edit') ||
        path.startsWith('/profile/addresses') ||
        path.startsWith('/profile/change-password');
  }
}
