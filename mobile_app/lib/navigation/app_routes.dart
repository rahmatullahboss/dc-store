/// App Route Names and Paths
/// All named routes for the application
class AppRoutes {
  AppRoutes._();

  // ═══════════════════════════════════════════════════════════════
  // ROUTE NAMES
  // ═══════════════════════════════════════════════════════════════

  // Initial
  static const String splash = 'splash';
  static const String onboarding = 'onboarding';

  // Auth
  static const String login = 'login';
  static const String register = 'register';
  static const String forgotPassword = 'forgot-password';
  static const String resetPassword = 'reset-password';
  static const String verifyOtp = 'verify-otp';

  // Main Tabs
  static const String home = 'home';
  static const String categories = 'categories';
  static const String search = 'search';
  static const String cart = 'cart';
  static const String profile = 'profile';

  // Products
  static const String products = 'products';
  static const String productDetail = 'product-detail';
  static const String productsByCategory = 'products-by-category';

  // Categories
  static const String categoryProducts = 'category-products';
  static const String subCategories = 'sub-categories';

  // Wishlist
  static const String wishlist = 'wishlist';

  // Checkout
  static const String checkout = 'checkout';
  static const String addressSelection = 'address-selection';
  static const String paymentMethod = 'payment-method';
  static const String orderReview = 'order-review';
  static const String orderSuccess = 'order-success';
  static const String paymentProcess = 'payment-process';

  // Orders
  static const String orders = 'orders';
  static const String orderDetail = 'order-detail';
  static const String trackOrder = 'track-order';

  // Profile
  static const String editProfile = 'edit-profile';
  static const String addresses = 'addresses';
  static const String addAddress = 'add-address';
  static const String editAddress = 'edit-address';
  static const String changePassword = 'change-password';
  static const String settings = 'settings';
  static const String notifications = 'notifications';
  static const String wallet = 'wallet';
  static const String coupons = 'coupons';

  // Support
  static const String help = 'help';
  static const String faq = 'faq';
  static const String contactUs = 'contact-us';
  static const String about = 'about';
  static const String privacyPolicy = 'privacy-policy';
  static const String termsOfService = 'terms-of-service';

  // AI Chat
  static const String chat = 'chat';

  // ═══════════════════════════════════════════════════════════════
  // ROUTE PATHS
  // ═══════════════════════════════════════════════════════════════

  // Initial
  static const String splashPath = '/splash';
  static const String onboardingPath = '/onboarding';

  // Auth
  static const String loginPath = '/login';
  static const String registerPath = '/register';
  static const String forgotPasswordPath = '/forgot-password';
  static const String resetPasswordPath = '/reset-password';
  static const String verifyOtpPath = '/verify-otp';

  // Main Tabs (Shell Routes)
  static const String homePath = '/';
  static const String categoriesPath = '/categories';
  static const String searchPath = '/search';
  static const String cartPath = '/cart';
  static const String profilePath = '/profile';

  // Products
  static const String productsPath = '/products';
  static const String productDetailPath = '/products/:productId';
  static const String productsByCategoryPath = '/category/:categoryId/products';

  // Categories
  static const String categoryProductsPath = 'products';
  static const String subCategoriesPath = ':categoryId/sub';

  // Wishlist
  static const String wishlistPath = '/wishlist';

  // Checkout
  static const String checkoutPath = '/checkout';
  static const String addressSelectionPath = 'address';
  static const String paymentMethodPath = 'payment';
  static const String orderReviewPath = 'review';
  static const String orderSuccessPath = '/order-success/:orderId';
  static const String paymentProcessPath = '/payment/:transactionId';

  // Orders
  static const String ordersPath = '/orders';
  static const String orderDetailPath = '/orders/:orderId';
  static const String trackOrderPath = '/track/:orderId';

  // Profile nested
  static const String editProfilePath = 'edit';
  static const String addressesPath = 'addresses';
  static const String addAddressPath = 'addresses/add';
  static const String editAddressPath = 'addresses/:addressId/edit';
  static const String changePasswordPath = 'change-password';
  static const String settingsPath = 'settings';
  static const String notificationsPath = '/notifications';
  static const String walletPath = '/wallet';
  static const String couponsPath = '/coupons';

  // Support
  static const String helpPath = '/help';
  static const String faqPath = '/faq';
  static const String contactUsPath = '/contact';
  static const String aboutPath = '/about';
  static const String privacyPolicyPath = '/privacy';
  static const String termsOfServicePath = '/terms';

  // AI Chat
  static const String chatPath = '/chat';

  // Deep link patterns
  static const String productDeepLink = '/p/:productId';
  static const String categoryDeepLink = '/c/:categoryId';
  static const String promoDeepLink = '/promo/:promoCode';
}
