/// API Configuration Constants
/// Handles all API-related configurations including URLs, endpoints, and timeouts
class ApiConstants {
  ApiConstants._();

  // ═══════════════════════════════════════════════════════════════
  // BASE URLs
  // ═══════════════════════════════════════════════════════════════

  /// Development environment URL
  static const String devBaseUrl = 'http://localhost:3000';

  /// Staging environment URL
  static const String stagingBaseUrl = 'https://staging.digitalcare.site';

  /// Production environment URL
  static const String prodBaseUrl = 'https://store.digitalcare.site';

  /// Current active base URL (change based on environment)
  static const String baseUrl = prodBaseUrl;

  // ═══════════════════════════════════════════════════════════════
  // API VERSION
  // ═══════════════════════════════════════════════════════════════

  static const String apiVersion = 'v1';
  static const String apiPrefix = '/api/$apiVersion';

  // ═══════════════════════════════════════════════════════════════
  // TIMEOUT DURATIONS
  // ═══════════════════════════════════════════════════════════════

  /// Connection timeout in milliseconds
  static const int connectTimeout = 30000; // 30 seconds

  /// Receive timeout in milliseconds
  static const int receiveTimeout = 30000; // 30 seconds

  /// Send timeout in milliseconds
  static const int sendTimeout = 30000; // 30 seconds

  /// Upload timeout in milliseconds
  static const int uploadTimeout = 120000; // 2 minutes

  // ═══════════════════════════════════════════════════════════════
  // AUTH ENDPOINTS
  // ═══════════════════════════════════════════════════════════════

  static const String login = '/api/auth/sign-in/email';
  static const String register = '/api/auth/sign-up/email';
  static const String logout = '/api/auth/sign-out';
  static const String refreshToken = '/api/auth/refresh';
  static const String forgotPassword = '/api/auth/forgot-password';
  static const String resetPassword = '/api/auth/reset-password';
  static const String verifyOtp = '/api/auth/verify-otp';
  static const String verifyEmail = '/api/auth/verify-email';
  static const String getSession = '/api/auth/get-session';
  static const String googleSignIn = '/api/auth/sign-in/social';
  static const String updateProfile = '/api/auth/update-profile';

  // ═══════════════════════════════════════════════════════════════
  // PRODUCT ENDPOINTS
  // ═══════════════════════════════════════════════════════════════

  static const String products = '/api/products';
  static String productById(String id) => '/api/products/$id';
  static String productBySlug(String slug) => '/api/products/slug/$slug';
  static const String featuredProducts = '/api/products/featured';
  static const String searchProducts = '/api/products/search';
  static const String productCategories = '/api/categories';

  // ═══════════════════════════════════════════════════════════════
  // CATEGORY ENDPOINTS
  // ═══════════════════════════════════════════════════════════════

  static const String categories = '/api/categories';
  static String categoryById(String id) => '/api/categories/$id';
  static String categoryProducts(String id) => '/api/categories/$id/products';

  // ═══════════════════════════════════════════════════════════════
  // CART ENDPOINTS
  // ═══════════════════════════════════════════════════════════════

  static const String cart = '/api/cart';
  static const String addToCart = '/api/cart/add';
  static const String updateCartItem = '/api/cart/update';
  static const String removeFromCart = '/api/cart/remove';
  static const String clearCart = '/api/cart/clear';
  static const String applyCoupon = '/api/cart/apply-coupon';
  static const String removeCoupon = '/api/cart/remove-coupon';

  // ═══════════════════════════════════════════════════════════════
  // ORDER ENDPOINTS
  // ═══════════════════════════════════════════════════════════════

  static const String orders = '/api/orders';
  static String orderById(String id) => '/api/orders/$id';
  static const String createOrder = '/api/orders/create';
  static const String orderHistory = '/api/orders/history';
  static const String trackOrder = '/api/orders/track';
  static const String cancelOrder = '/api/orders/cancel';

  // ═══════════════════════════════════════════════════════════════
  // WISHLIST ENDPOINTS
  // ═══════════════════════════════════════════════════════════════

  static const String wishlist = '/api/user/wishlist';
  static String removeFromWishlistById(String productId) =>
      '/api/user/wishlist/$productId';

  // ═══════════════════════════════════════════════════════════════
  // USER ENDPOINTS
  // ═══════════════════════════════════════════════════════════════

  static const String userProfile = '/api/user/profile';
  static const String updateUser = '/api/user/update';
  static const String changePassword = '/api/user/change-password';
  static const String userAddresses = '/api/user/addresses';
  static const String addAddress = '/api/user/addresses/add';
  static const String deleteAddress = '/api/user/addresses/delete';

  // ═══════════════════════════════════════════════════════════════
  // REVIEW ENDPOINTS
  // ═══════════════════════════════════════════════════════════════

  static String productReviews(String productId) =>
      '/api/products/$productId/reviews';
  static const String addReview = '/api/reviews/add';
  static const String updateReview = '/api/reviews/update';
  static const String deleteReview = '/api/reviews/delete';

  // ═══════════════════════════════════════════════════════════════
  // PAYMENT ENDPOINTS
  // ═══════════════════════════════════════════════════════════════

  static const String paymentMethods = '/api/payment/methods';
  static const String payments = '/api/payments';
  static const String initiatePayment = '/api/payment/initiate';
  static const String confirmPayment = '/api/payment/confirm';
  static const String paymentStatus = '/api/payment/status';

  // ═══════════════════════════════════════════════════════════════
  // PROFILE ENDPOINTS
  // ═══════════════════════════════════════════════════════════════

  static const String profile = '/api/user/profile';
  static const String addresses = '/api/user/addresses';
  static const String reviews = '/api/reviews';

  // ═══════════════════════════════════════════════════════════════
  // NOTIFICATION ENDPOINTS
  // ═══════════════════════════════════════════════════════════════

  static const String notifications = '/api/notifications';
  static const String markNotificationRead = '/api/notifications/mark-read';
  static const String registerDevice = '/api/notifications/register-device';

  // ═══════════════════════════════════════════════════════════════
  // MISC ENDPOINTS
  // ═══════════════════════════════════════════════════════════════

  static const String banners = '/api/banners';
  static const String settings = '/api/settings';
  static const String faq = '/api/faq';
  static const String contactUs = '/api/contact';
}
