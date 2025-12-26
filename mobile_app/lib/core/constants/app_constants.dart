import '../config/white_label_config.dart';

/// Application-wide Constants
/// General app configuration values and defaults
class AppConstants {
  AppConstants._();

  // ═══════════════════════════════════════════════════════════════
  // APP INFO (from WhiteLabelConfig)
  // ═══════════════════════════════════════════════════════════════

  static String get appName => WhiteLabelConfig.appName;
  static String get appVersion => WhiteLabelConfig.appVersion;
  static String get buildNumber => WhiteLabelConfig.buildNumber;
  static String get appTagline => WhiteLabelConfig.appTagline;
  static String get companyName => WhiteLabelConfig.companyName;
  static String get supportEmail => WhiteLabelConfig.supportEmail;
  static String get supportPhone => WhiteLabelConfig.supportPhone;

  // ═══════════════════════════════════════════════════════════════
  // PAGINATION
  // ═══════════════════════════════════════════════════════════════

  /// Default page size for list APIs
  static const int defaultPageSize = 20;

  /// Maximum page size allowed
  static const int maxPageSize = 50;

  /// Products per page on product listing
  static const int productsPerPage = 12;

  /// Orders per page on order history
  static const int ordersPerPage = 10;

  /// Reviews per page on product reviews
  static const int reviewsPerPage = 10;

  // ═══════════════════════════════════════════════════════════════
  // CACHE DURATIONS
  // ═══════════════════════════════════════════════════════════════

  /// Products cache duration in minutes
  static const int productsCacheDuration = 15;

  /// Categories cache duration in minutes
  static const int categoriesCacheDuration = 60;

  /// User profile cache duration in minutes
  static const int userCacheDuration = 5;

  /// Banners cache duration in minutes
  static const int bannersCacheDuration = 30;

  /// Settings cache duration in minutes
  static const int settingsCacheDuration = 120;

  /// Default cache duration (15 minutes)
  static const Duration defaultCacheDuration = Duration(minutes: 15);

  // ═══════════════════════════════════════════════════════════════
  // DEFAULT VALUES
  // ═══════════════════════════════════════════════════════════════

  /// Default currency symbol
  static const String defaultCurrency = '৳';

  /// Default currency code
  static const String defaultCurrencyCode = 'BDT';

  /// Default locale
  static const String defaultLocale = 'en';

  /// Supported locales
  static const List<String> supportedLocales = ['en', 'bn'];

  /// Default country code
  static const String defaultCountryCode = 'BD';

  /// Default phone country code
  static const String defaultPhoneCode = '+880';

  // ═══════════════════════════════════════════════════════════════
  // CART & CHECKOUT
  // ═══════════════════════════════════════════════════════════════

  /// Maximum items allowed in cart
  static const int maxCartItems = 50;

  /// Maximum quantity per item
  static const int maxItemQuantity = 10;

  /// Minimum order amount for checkout
  static const double minOrderAmount = 100.0;

  /// Free shipping threshold
  static const double freeShippingThreshold = 5000.0;

  /// Default shipping cost
  static const double defaultShippingCost = 120.0;

  /// Inside Dhaka shipping cost
  static const double insideDhakaShipping = 80.0;

  /// Outside Dhaka shipping cost
  static const double outsideDhakaShipping = 150.0;

  // ═══════════════════════════════════════════════════════════════
  // IMAGE SETTINGS
  // ═══════════════════════════════════════════════════════════════

  /// Maximum image upload size in bytes (5MB)
  static const int maxImageSize = 5 * 1024 * 1024;

  /// Allowed image extensions
  static const List<String> allowedImageExtensions = [
    'jpg',
    'jpeg',
    'png',
    'webp',
  ];

  /// Thumbnail size
  static const int thumbnailSize = 150;

  /// Product image size
  static const int productImageSize = 500;

  // ═══════════════════════════════════════════════════════════════
  // DATE & TIME
  // ═══════════════════════════════════════════════════════════════

  /// Date format for display
  static const String displayDateFormat = 'dd MMM, yyyy';

  /// Time format for display
  static const String displayTimeFormat = 'hh:mm a';

  /// DateTime format for display
  static const String displayDateTimeFormat = 'dd MMM, yyyy hh:mm a';

  /// API date format
  static const String apiDateFormat = 'yyyy-MM-dd';

  /// API datetime format
  static const String apiDateTimeFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'";

  // ═══════════════════════════════════════════════════════════════
  // SEARCH
  // ═══════════════════════════════════════════════════════════════

  /// Minimum search query length
  static const int minSearchLength = 2;

  /// Maximum recent searches to store
  static const int maxRecentSearches = 10;

  /// Search debounce duration in milliseconds
  static const int searchDebounce = 300;

  // ═══════════════════════════════════════════════════════════════
  // SOCIAL & LINKS (from WhiteLabelConfig)
  // ═══════════════════════════════════════════════════════════════

  static String get playStoreUrl => WhiteLabelConfig.playStoreUrl;
  static String get appStoreUrl => WhiteLabelConfig.appStoreUrl;
  static String get websiteUrl => WhiteLabelConfig.websiteUrl;
  static String get privacyPolicyUrl => WhiteLabelConfig.privacyPolicyUrl;
  static String get termsOfServiceUrl => WhiteLabelConfig.termsOfServiceUrl;
  static String get facebookUrl => WhiteLabelConfig.facebookUrl;
  static String get instagramUrl => WhiteLabelConfig.instagramUrl;
}
