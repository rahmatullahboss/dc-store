/// Asset Path Constants
/// All image, icon, lottie, and font paths
class AssetConstants {
  AssetConstants._();

  // ═══════════════════════════════════════════════════════════════
  // BASE PATHS
  // ═══════════════════════════════════════════════════════════════

  static const String _imagesPath = 'assets/images';
  static const String _iconsPath = 'assets/icons';
  static const String _lottiePath = 'assets/lottie';
  static const String _fontsPath = 'assets/fonts';

  // ═══════════════════════════════════════════════════════════════
  // LOGO & BRANDING
  // ═══════════════════════════════════════════════════════════════

  static const String logo = '$_imagesPath/logo.png';
  static const String logoLight = '$_imagesPath/logo_light.png';
  static const String logoDark = '$_imagesPath/logo_dark.png';
  static const String logoIcon = '$_imagesPath/logo_icon.png';
  static const String splashLogo = '$_imagesPath/splash_logo.png';

  // ═══════════════════════════════════════════════════════════════
  // PLACEHOLDER IMAGES
  // ═══════════════════════════════════════════════════════════════

  static const String placeholderProduct =
      '$_imagesPath/placeholder_product.png';
  static const String placeholderUser = '$_imagesPath/placeholder_user.png';
  static const String placeholderCategory =
      '$_imagesPath/placeholder_category.png';
  static const String placeholderBanner = '$_imagesPath/placeholder_banner.png';

  // ═══════════════════════════════════════════════════════════════
  // EMPTY STATE IMAGES
  // ═══════════════════════════════════════════════════════════════

  static const String emptyCart = '$_imagesPath/empty_cart.png';
  static const String emptyWishlist = '$_imagesPath/empty_wishlist.png';
  static const String emptyOrders = '$_imagesPath/empty_orders.png';
  static const String emptySearch = '$_imagesPath/empty_search.png';
  static const String emptyNotifications =
      '$_imagesPath/empty_notifications.png';
  static const String noInternet = '$_imagesPath/no_internet.png';
  static const String error = '$_imagesPath/error.png';

  // ═══════════════════════════════════════════════════════════════
  // ONBOARDING IMAGES
  // ═══════════════════════════════════════════════════════════════

  static const String onboarding1 = '$_imagesPath/onboarding_1.png';
  static const String onboarding2 = '$_imagesPath/onboarding_2.png';
  static const String onboarding3 = '$_imagesPath/onboarding_3.png';

  // ═══════════════════════════════════════════════════════════════
  // AUTH IMAGES
  // ═══════════════════════════════════════════════════════════════

  static const String loginBg = '$_imagesPath/login_bg.png';
  static const String successMark = '$_imagesPath/success_mark.png';

  // ═══════════════════════════════════════════════════════════════
  // PAYMENT ICONS
  // ═══════════════════════════════════════════════════════════════

  static const String bkash = '$_imagesPath/payment/bkash.png';
  static const String nagad = '$_imagesPath/payment/nagad.png';
  static const String rocket = '$_imagesPath/payment/rocket.png';
  static const String visa = '$_imagesPath/payment/visa.png';
  static const String mastercard = '$_imagesPath/payment/mastercard.png';
  static const String cod = '$_imagesPath/payment/cod.png';

  // ═══════════════════════════════════════════════════════════════
  // SVG ICONS
  // ═══════════════════════════════════════════════════════════════

  static const String icHome = '$_iconsPath/home.svg';
  static const String icProducts = '$_iconsPath/products.svg';
  static const String icCart = '$_iconsPath/cart.svg';
  static const String icProfile = '$_iconsPath/profile.svg';
  static const String icSearch = '$_iconsPath/search.svg';
  static const String icHeart = '$_iconsPath/heart.svg';
  static const String icShare = '$_iconsPath/share.svg';
  static const String icFilter = '$_iconsPath/filter.svg';
  static const String icSort = '$_iconsPath/sort.svg';
  static const String icNotification = '$_iconsPath/notification.svg';
  static const String icSettings = '$_iconsPath/settings.svg';
  static const String icGoogle = '$_iconsPath/google.svg';
  static const String icApple = '$_iconsPath/apple.svg';
  static const String icFacebook = '$_iconsPath/facebook.svg';

  // ═══════════════════════════════════════════════════════════════
  // LOTTIE ANIMATIONS
  // ═══════════════════════════════════════════════════════════════

  static const String loadingLottie = '$_lottiePath/loading.json';
  static const String successLottie = '$_lottiePath/success.json';
  static const String errorLottie = '$_lottiePath/error.json';
  static const String emptyLottie = '$_lottiePath/empty.json';
  static const String noInternetLottie = '$_lottiePath/no_internet.json';
  static const String shoppingLottie = '$_lottiePath/shopping.json';
  static const String deliveryLottie = '$_lottiePath/delivery.json';
  static const String confettiLottie = '$_lottiePath/confetti.json';
  static const String searchingLottie = '$_lottiePath/searching.json';
  static const String paymentSuccessLottie =
      '$_lottiePath/payment_success.json';

  // ═══════════════════════════════════════════════════════════════
  // FONTS
  // ═══════════════════════════════════════════════════════════════

  static const String fontInter = '$_fontsPath/Inter-Regular.ttf';
  static const String fontInterBold = '$_fontsPath/Inter-Bold.ttf';
  static const String fontInterMedium = '$_fontsPath/Inter-Medium.ttf';
  static const String fontInterSemiBold = '$_fontsPath/Inter-SemiBold.ttf';

  // ═══════════════════════════════════════════════════════════════
  // NETWORK PLACEHOLDERS (for when assets don't exist)
  // ═══════════════════════════════════════════════════════════════

  static const String networkPlaceholder =
      'https://placehold.co/400x400/f5f5f5/cccccc?text=No+Image';
  static const String networkUserPlaceholder =
      'https://placehold.co/150x150/f5f5f5/cccccc?text=User';
}
