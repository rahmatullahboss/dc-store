import 'package:flutter/foundation.dart';

/// AnalyticsService - Handles analytics and event tracking
/// Firebase Analytics placeholder - add firebase_analytics package when ready
class AnalyticsService {
  static AnalyticsService? _instance;

  AnalyticsService._();

  static AnalyticsService get instance {
    _instance ??= AnalyticsService._();
    return _instance!;
  }

  /// Initialize analytics
  Future<void> initialize() async {
    // TODO: Initialize Firebase Analytics
    // await FirebaseAnalytics.instance.setAnalyticsCollectionEnabled(true);
    debugPrint('AnalyticsService initialized');
  }

  // ═══════════════════════════════════════════════════════════════
  // SCREEN TRACKING
  // ═══════════════════════════════════════════════════════════════

  /// Log screen view
  Future<void> logScreenView({
    required String screenName,
    String? screenClass,
  }) async {
    debugPrint('Screen View: $screenName');
    // TODO: Implement with Firebase Analytics
    // await FirebaseAnalytics.instance.logScreenView(
    //   screenName: screenName,
    //   screenClass: screenClass,
    // );
  }

  // ═══════════════════════════════════════════════════════════════
  // EVENT TRACKING
  // ═══════════════════════════════════════════════════════════════

  /// Log custom event
  Future<void> logEvent({
    required String name,
    Map<String, Object>? parameters,
  }) async {
    debugPrint('Event: $name, params: $parameters');
    // TODO: Implement with Firebase Analytics
    // await FirebaseAnalytics.instance.logEvent(
    //   name: name,
    //   parameters: parameters,
    // );
  }

  /// Log product view
  Future<void> logViewProduct({
    required String productId,
    required String productName,
    required double price,
    String? category,
    String? brand,
  }) async {
    await logEvent(
      name: 'view_item',
      parameters: {
        'item_id': productId,
        'item_name': productName,
        'price': price,
        if (category != null) 'category': category,
        if (brand != null) 'brand': brand,
      },
    );
  }

  /// Log add to cart
  Future<void> logAddToCart({
    required String productId,
    required String productName,
    required double price,
    required int quantity,
  }) async {
    await logEvent(
      name: 'add_to_cart',
      parameters: {
        'item_id': productId,
        'item_name': productName,
        'price': price,
        'quantity': quantity,
        'value': price * quantity,
      },
    );
  }

  /// Log remove from cart
  Future<void> logRemoveFromCart({
    required String productId,
    required String productName,
    required double price,
    required int quantity,
  }) async {
    await logEvent(
      name: 'remove_from_cart',
      parameters: {
        'item_id': productId,
        'item_name': productName,
        'price': price,
        'quantity': quantity,
      },
    );
  }

  /// Log begin checkout
  Future<void> logBeginCheckout({
    required double value,
    required int itemCount,
    String? couponCode,
  }) async {
    await logEvent(
      name: 'begin_checkout',
      parameters: {
        'value': value,
        'items': itemCount,
        if (couponCode != null) 'coupon': couponCode,
      },
    );
  }

  /// Log purchase
  Future<void> logPurchase({
    required String orderId,
    required double value,
    required int itemCount,
    String? couponCode,
    double? shipping,
  }) async {
    await logEvent(
      name: 'purchase',
      parameters: {
        'transaction_id': orderId,
        'value': value,
        'items': itemCount,
        'currency': 'BDT',
        if (couponCode != null) 'coupon': couponCode,
        if (shipping != null) 'shipping': shipping,
      },
    );
  }

  /// Log search
  Future<void> logSearch(String searchTerm) async {
    await logEvent(name: 'search', parameters: {'search_term': searchTerm});
  }

  /// Log view category
  Future<void> logViewCategory({
    required String categoryId,
    required String categoryName,
  }) async {
    await logEvent(
      name: 'view_item_list',
      parameters: {'item_list_id': categoryId, 'item_list_name': categoryName},
    );
  }

  /// Log add to wishlist
  Future<void> logAddToWishlist({
    required String productId,
    required String productName,
    required double price,
  }) async {
    await logEvent(
      name: 'add_to_wishlist',
      parameters: {
        'item_id': productId,
        'item_name': productName,
        'price': price,
      },
    );
  }

  /// Log share
  Future<void> logShare({
    required String contentType,
    required String itemId,
    required String method,
  }) async {
    await logEvent(
      name: 'share',
      parameters: {
        'content_type': contentType,
        'item_id': itemId,
        'method': method,
      },
    );
  }

  // ═══════════════════════════════════════════════════════════════
  // USER PROPERTIES
  // ═══════════════════════════════════════════════════════════════

  /// Set user ID
  Future<void> setUserId(String? userId) async {
    debugPrint('Set User ID: $userId');
    // TODO: Implement with Firebase Analytics
    // await FirebaseAnalytics.instance.setUserId(id: userId);
  }

  /// Set user property
  Future<void> setUserProperty({
    required String name,
    required String? value,
  }) async {
    debugPrint('Set User Property: $name = $value');
    // TODO: Implement with Firebase Analytics
    // await FirebaseAnalytics.instance.setUserProperty(
    //   name: name,
    //   value: value,
    // );
  }

  /// Set user subscription status
  Future<void> setSubscriptionStatus(String status) async {
    await setUserProperty(name: 'subscription_status', value: status);
  }

  /// Set user tier
  Future<void> setUserTier(String tier) async {
    await setUserProperty(name: 'user_tier', value: tier);
  }

  // ═══════════════════════════════════════════════════════════════
  // CONVERSION TRACKING
  // ═══════════════════════════════════════════════════════════════

  /// Log signup
  Future<void> logSignUp(String method) async {
    await logEvent(name: 'sign_up', parameters: {'method': method});
  }

  /// Log login
  Future<void> logLogin(String method) async {
    await logEvent(name: 'login', parameters: {'method': method});
  }

  /// Log complete registration
  Future<void> logCompleteRegistration() async {
    await logEvent(name: 'complete_registration');
  }

  /// Log first purchase
  Future<void> logFirstPurchase({
    required String orderId,
    required double value,
  }) async {
    await logEvent(
      name: 'first_purchase',
      parameters: {'transaction_id': orderId, 'value': value},
    );
  }

  /// Reset analytics data
  Future<void> resetAnalyticsData() async {
    // TODO: Implement with Firebase Analytics
    // await FirebaseAnalytics.instance.resetAnalyticsData();
    debugPrint('Analytics data reset');
  }
}
