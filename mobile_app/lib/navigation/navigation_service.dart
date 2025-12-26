import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'app_routes.dart';

/// Navigation Service - Navigate without context
/// Provides methods for navigation operations
class NavigationService {
  static NavigationService? _instance;
  static GoRouter? _router;

  NavigationService._();

  static NavigationService get instance {
    _instance ??= NavigationService._();
    return _instance!;
  }

  /// Set the router instance
  static void setRouter(GoRouter router) {
    _router = router;
  }

  /// Get the router instance
  GoRouter get router {
    assert(_router != null, 'Router not set. Call setRouter first.');
    return _router!;
  }

  /// Get current location
  String get currentLocation =>
      router.routerDelegate.currentConfiguration.uri.toString();

  // ═══════════════════════════════════════════════════════════════
  // BASIC NAVIGATION
  // ═══════════════════════════════════════════════════════════════

  /// Navigate to a named route
  void go(String location, {Object? extra}) {
    router.go(location, extra: extra);
  }

  /// Navigate to a named route by name
  void goNamed(
    String name, {
    Map<String, String> pathParameters = const {},
    Map<String, dynamic> queryParameters = const {},
    Object? extra,
  }) {
    router.goNamed(
      name,
      pathParameters: pathParameters,
      queryParameters: queryParameters,
      extra: extra,
    );
  }

  /// Push a new route
  void push(String location, {Object? extra}) {
    router.push(location, extra: extra);
  }

  /// Push a named route
  void pushNamed(
    String name, {
    Map<String, String> pathParameters = const {},
    Map<String, dynamic> queryParameters = const {},
    Object? extra,
  }) {
    router.pushNamed(
      name,
      pathParameters: pathParameters,
      queryParameters: queryParameters,
      extra: extra,
    );
  }

  /// Push replacement
  void pushReplacement(String location, {Object? extra}) {
    router.pushReplacement(location, extra: extra);
  }

  /// Push replacement by name
  void pushReplacementNamed(
    String name, {
    Map<String, String> pathParameters = const {},
    Map<String, dynamic> queryParameters = const {},
    Object? extra,
  }) {
    router.pushReplacementNamed(
      name,
      pathParameters: pathParameters,
      queryParameters: queryParameters,
      extra: extra,
    );
  }

  /// Replace current route
  void replace(String location, {Object? extra}) {
    router.replace(location, extra: extra);
  }

  /// Replace current route by name
  void replaceNamed(
    String name, {
    Map<String, String> pathParameters = const {},
    Map<String, dynamic> queryParameters = const {},
    Object? extra,
  }) {
    router.replaceNamed(
      name,
      pathParameters: pathParameters,
      queryParameters: queryParameters,
      extra: extra,
    );
  }

  // ═══════════════════════════════════════════════════════════════
  // BACK NAVIGATION
  // ═══════════════════════════════════════════════════════════════

  /// Go back
  void pop<T extends Object?>([T? result]) {
    router.pop(result);
  }

  /// Check if can pop
  bool canPop() {
    return router.canPop();
  }

  /// Pop until a specific route
  void popUntil(String location) {
    while (canPop() && currentLocation != location) {
      pop();
    }
  }

  // ═══════════════════════════════════════════════════════════════
  // STACK MANAGEMENT
  // ═══════════════════════════════════════════════════════════════

  /// Clear stack and go to a route
  void clearStackAndGo(String location, {Object? extra}) {
    // Go to the route which replaces the entire stack
    router.go(location, extra: extra);
  }

  /// Clear stack and go to home
  void clearStackAndGoHome() {
    router.go(AppRoutes.homePath);
  }

  /// Clear stack and go to login
  void clearStackAndGoToLogin() {
    router.go(AppRoutes.loginPath);
  }

  // ═══════════════════════════════════════════════════════════════
  // CONVENIENCE METHODS
  // ═══════════════════════════════════════════════════════════════

  /// Navigate to home
  void goHome() => go(AppRoutes.homePath);

  /// Navigate to login
  void goLogin() => go(AppRoutes.loginPath);

  /// Navigate to product detail
  void goProductDetail(String productId) {
    goNamed(AppRoutes.productDetail, pathParameters: {'productId': productId});
  }

  /// Navigate to category products
  void goCategoryProducts(String categoryId, {String? categoryName}) {
    goNamed(
      AppRoutes.productsByCategory,
      pathParameters: {'categoryId': categoryId},
      extra: {'categoryName': categoryName},
    );
  }

  /// Navigate to order detail
  void goOrderDetail(String orderId) {
    goNamed(AppRoutes.orderDetail, pathParameters: {'orderId': orderId});
  }

  /// Navigate to track order
  void goTrackOrder(String orderId) {
    goNamed(AppRoutes.trackOrder, pathParameters: {'orderId': orderId});
  }

  /// Navigate to checkout
  void goCheckout() => go(AppRoutes.checkoutPath);

  /// Navigate to cart
  void goCart() => go(AppRoutes.cartPath);

  /// Navigate to wishlist
  void goWishlist() => go(AppRoutes.wishlistPath);

  /// Navigate to search
  void goSearch({String? query}) {
    if (query != null && query.isNotEmpty) {
      go('${AppRoutes.searchPath}?q=$query');
    } else {
      go(AppRoutes.searchPath);
    }
  }

  /// Navigate to order success
  void goOrderSuccess(String orderId) {
    goNamed(AppRoutes.orderSuccess, pathParameters: {'orderId': orderId});
  }

  // ═══════════════════════════════════════════════════════════════
  // DEEP LINK HANDLING
  // ═══════════════════════════════════════════════════════════════

  /// Handle deep link
  void handleDeepLink(String deepLink) {
    debugPrint('Handling deep link: $deepLink');

    final uri = Uri.tryParse(deepLink);
    if (uri == null) return;

    final path = uri.path;
    final segments = uri.pathSegments;

    if (segments.isEmpty) return;

    switch (segments[0]) {
      case 'p': // Product: /p/:productId
        if (segments.length > 1) {
          goProductDetail(segments[1]);
        }
        break;
      case 'c': // Category: /c/:categoryId
        if (segments.length > 1) {
          goCategoryProducts(segments[1]);
        }
        break;
      case 'track': // Track order: /track/:orderId
        if (segments.length > 1) {
          goTrackOrder(segments[1]);
        }
        break;
      case 'promo': // Promo: /promo/:code
        if (segments.length > 1) {
          goCart(); // Navigate to cart where promo can be applied
        }
        break;
      default:
        // Try to navigate directly if it's a valid path
        go(path);
    }
  }
}
