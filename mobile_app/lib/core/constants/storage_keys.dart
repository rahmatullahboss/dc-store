/// Storage Key Constants
/// All keys used for SharedPreferences, Hive, and Secure Storage
class StorageKeys {
  StorageKeys._();

  // ═══════════════════════════════════════════════════════════════
  // SHARED PREFERENCES KEYS
  // ═══════════════════════════════════════════════════════════════

  // App State
  static const String isFirstLaunch = 'is_first_launch';
  static const String onboardingComplete = 'onboarding_complete';
  static const String lastAppVersion = 'last_app_version';
  static const String appOpenCount = 'app_open_count';

  // Theme & Locale
  static const String themeMode = 'theme_mode';
  static const String locale = 'locale';
  static const String languageCode = 'language_code';

  // User Preferences
  static const String userId = 'user_id';
  static const String userName = 'user_name';
  static const String userEmail = 'user_email';
  static const String userPhone = 'user_phone';
  static const String userAvatar = 'user_avatar';
  static const String isLoggedIn = 'is_logged_in';

  // Cart
  static const String cartItems = 'cart_items';
  static const String cartCount = 'cart_count';
  static const String appliedCoupon = 'applied_coupon';

  // Search
  static const String recentSearches = 'recent_searches';
  static const String searchHistory = 'search_history';

  // Filters
  static const String lastSelectedCategory = 'last_selected_category';
  static const String lastSortOption = 'last_sort_option';
  static const String savedFilters = 'saved_filters';

  // Notifications
  static const String notificationsEnabled = 'notifications_enabled';
  static const String fcmToken = 'fcm_token';
  static const String lastNotificationCheck = 'last_notification_check';

  // Cache
  static const String productsCache = 'products_cache';
  static const String categoriesCache = 'categories_cache';
  static const String bannersCache = 'banners_cache';
  static const String cacheTimestamp = 'cache_timestamp';

  // Address
  static const String defaultAddressId = 'default_address_id';
  static const String savedAddresses = 'saved_addresses';
  static const String lastDeliveryAddress = 'last_delivery_address';

  // Checkout
  static const String lastPaymentMethod = 'last_payment_method';
  static const String savedPaymentMethods = 'saved_payment_methods';

  // ═══════════════════════════════════════════════════════════════
  // SECURE STORAGE KEYS (for sensitive data)
  // ═══════════════════════════════════════════════════════════════

  static const String authToken = 'auth_token';
  static const String refreshToken = 'refresh_token';
  static const String sessionId = 'session_id';
  static const String apiKey = 'api_key';
  static const String userPassword = 'user_password'; // Only for biometric
  static const String biometricEnabled = 'biometric_enabled';
  static const String pinCode = 'pin_code';

  // ═══════════════════════════════════════════════════════════════
  // HIVE BOX NAMES
  // ═══════════════════════════════════════════════════════════════

  static const String userBox = 'user_box';
  static const String cartBox = 'cart_box';
  static const String wishlistBox = 'wishlist_box';
  static const String productsBox = 'products_box';
  static const String categoriesBox = 'categories_box';
  static const String ordersBox = 'orders_box';
  static const String notificationsBox = 'notifications_box';
  static const String settingsBox = 'settings_box';
  static const String cacheBox = 'cache_box';

  // ═══════════════════════════════════════════════════════════════
  // HIVE TYPE IDS (for TypeAdapters)
  // ═══════════════════════════════════════════════════════════════

  static const int userTypeId = 0;
  static const int productTypeId = 1;
  static const int cartItemTypeId = 2;
  static const int categoryTypeId = 3;
  static const int orderTypeId = 4;
  static const int addressTypeId = 5;
  static const int notificationTypeId = 6;
}
