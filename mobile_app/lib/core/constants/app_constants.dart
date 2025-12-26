/// Application-wide Constants
/// General app configuration values and defaults
class AppConstants {
  AppConstants._();

  // ═══════════════════════════════════════════════════════════════
  // APP INFO
  // ═══════════════════════════════════════════════════════════════

  static const String appName = 'DC Store';
  static const String appVersion = '1.0.0';
  static const String buildNumber = '1';
  static const String appTagline = 'Shop Smart, Live Better';
  static const String companyName = 'Digital Care';
  static const String supportEmail = 'support@digitalcare.site';
  static const String supportPhone = '+880 1234-567890';

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
  // SOCIAL & LINKS
  // ═══════════════════════════════════════════════════════════════

  static const String playStoreUrl =
      'https://play.google.com/store/apps/details?id=com.digitalcare.dcstore';
  static const String appStoreUrl =
      'https://apps.apple.com/app/dc-store/id123456789';
  static const String websiteUrl = 'https://store.digitalcare.site';
  static const String privacyPolicyUrl =
      'https://store.digitalcare.site/privacy';
  static const String termsOfServiceUrl =
      'https://store.digitalcare.site/terms';
  static const String facebookUrl = 'https://facebook.com/digitalcarestore';
  static const String instagramUrl = 'https://instagram.com/digitalcarestore';
}
