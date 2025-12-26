/// Route Constants
/// All route names and paths for navigation
class RouteConstants {
  RouteConstants._();

  // ═══════════════════════════════════════════════════════════════
  // ROUTE PATHS
  // ═══════════════════════════════════════════════════════════════

  // Main Routes
  static const String splash = '/splash';
  static const String onboarding = '/onboarding';
  static const String home = '/';
  static const String products = '/products';
  static String getProduct(String id) => '/product/$id';
  static const String cart = '/cart';
  static const String profile = '/profile';

  // Auth Routes
  static const String login = '/login';
  static const String register = '/register';
  static const String forgotPassword = '/forgot-password';
  static const String resetPassword = '/reset-password';
  static const String verifyOtp = '/verify-otp';
  static const String changePassword = '/change-password';

  // Product Routes
  static String productDetails(String id) => '/product/$id';
  static String categoryProducts(String id) => '/category/$id';
  static const String searchProducts = '/search';
  static const String allCategories = '/categories';

  // Cart & Checkout Routes
  static const String checkout = '/checkout';
  static const String payment = '/payment';
  static const String orderSuccess = '/order-success';
  static const String orderFailed = '/order-failed';

  // Order Routes
  static const String orders = '/orders';
  static String orderDetails(String id) => '/orders/$id';
  static String trackOrder(String id) => '/orders/$id/track';

  // User Routes
  static const String editProfile = '/profile/edit';
  static const String addresses = '/profile/addresses';
  static const String addAddress = '/profile/addresses/add';
  static String editAddress(String id) => '/profile/addresses/$id/edit';
  static const String wishlist = '/wishlist';
  static const String notifications = '/notifications';
  static const String settings = '/settings';

  // Info Routes
  static const String aboutUs = '/about';
  static const String contactUs = '/contact';
  static const String faq = '/faq';
  static const String privacyPolicy = '/privacy-policy';
  static const String termsOfService = '/terms';
  static const String refundPolicy = '/refund-policy';
  static const String shippingPolicy = '/shipping-policy';

  // ═══════════════════════════════════════════════════════════════
  // ROUTE NAMES (for GoRouter named navigation)
  // ═══════════════════════════════════════════════════════════════

  static const String splashName = 'splash';
  static const String onboardingName = 'onboarding';
  static const String homeName = 'home';
  static const String productsName = 'products';
  static const String productDetailsName = 'product-details';
  static const String cartName = 'cart';
  static const String profileName = 'profile';
  static const String loginName = 'login';
  static const String registerName = 'register';
  static const String forgotPasswordName = 'forgot-password';
  static const String checkoutName = 'checkout';
  static const String orderSuccessName = 'order-success';
  static const String ordersName = 'orders';
  static const String orderDetailsName = 'order-details';
  static const String wishlistName = 'wishlist';
  static const String settingsName = 'settings';
  static const String editProfileName = 'edit-profile';
  static const String addressesName = 'addresses';
  static const String notificationsName = 'notifications';
  static const String searchName = 'search';
  static const String categoriesName = 'categories';
  static const String categoryName = 'category';
}
