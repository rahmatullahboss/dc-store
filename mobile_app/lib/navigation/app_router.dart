import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'app_routes.dart';
import 'app_transitions.dart';
import 'route_guards.dart';
import 'navigation_service.dart';
import '../core/config/white_label_config.dart';
import '../services/storage_service.dart';

// Layout
import '../presentation/home/home_screen.dart';
import '../presentation/splash/splash_screen.dart';
import '../presentation/onboarding/onboarding_screen.dart';
import '../presentation/search/search_screen.dart';
import '../presentation/categories/categories_screen.dart';

// Products
import '../presentation/products/products_screen.dart';
import '../presentation/products/product_details_screen.dart';

// Cart & Checkout
import '../presentation/cart/cart_screen.dart';
import '../features/checkout/presentation/checkout_screen.dart';
import '../features/checkout/presentation/order_success_screen.dart';

// Profile
import '../presentation/profile/profile_screen.dart';
import '../presentation/profile/edit_profile_screen.dart';
import '../presentation/profile/addresses_screen.dart';
import '../presentation/profile/settings_screen.dart';
import '../presentation/profile/help_support_screen.dart';
import '../presentation/profile/coupons_screen.dart';

// Orders
import '../presentation/orders/orders_screen.dart';
import '../presentation/orders/order_details_screen.dart';

// Other
import '../presentation/notifications/notifications_screen.dart';
import '../presentation/wallet/wallet_screen.dart';
import '../presentation/wishlist/wishlist_screen.dart';

// Auth
import '../features/auth/presentation/login_screen.dart';
import '../features/auth/presentation/register_screen.dart';

/// App Router Configuration
class AppRouter {
  final StorageService _storageService;
  late final RouteGuards _guards;
  late final GoRouter _router;

  AppRouter(this._storageService) {
    _guards = RouteGuards(_storageService);
    _router = _createRouter();
    NavigationService.setRouter(_router);
  }

  GoRouter get router => _router;

  GoRouter _createRouter() {
    return GoRouter(
      initialLocation: AppRoutes.splashPath,
      debugLogDiagnostics: true,
      redirect: _guards.redirect,
      errorBuilder: (context, state) => _ErrorScreen(error: state.error),
      routes: [
        // ═══════════════════════════════════════════════════════════════
        // INITIAL ROUTES
        // ═══════════════════════════════════════════════════════════════
        GoRoute(
          path: AppRoutes.splashPath,
          name: AppRoutes.splash,
          pageBuilder: (context, state) =>
              AppTransitions.fade(child: const SplashScreen(), state: state),
        ),
        GoRoute(
          path: AppRoutes.onboardingPath,
          name: AppRoutes.onboarding,
          pageBuilder: (context, state) => AppTransitions.fade(
            child: const OnboardingScreen(),
            state: state,
          ),
        ),

        // ═══════════════════════════════════════════════════════════════
        // AUTH ROUTES
        // ═══════════════════════════════════════════════════════════════
        GoRoute(
          path: AppRoutes.loginPath,
          name: AppRoutes.login,
          pageBuilder: (context, state) =>
              AppTransitions.slideUp(child: const LoginScreen(), state: state),
        ),
        GoRoute(
          path: AppRoutes.registerPath,
          name: AppRoutes.register,
          pageBuilder: (context, state) => AppTransitions.slideRight(
            child: const RegisterScreen(),
            state: state,
          ),
        ),
        GoRoute(
          path: AppRoutes.forgotPasswordPath,
          name: AppRoutes.forgotPassword,
          pageBuilder: (context, state) => AppTransitions.slideRight(
            child: const _ForgotPasswordScreen(),
            state: state,
          ),
        ),
        GoRoute(
          path: AppRoutes.verifyOtpPath,
          name: AppRoutes.verifyOtp,
          pageBuilder: (context, state) => AppTransitions.slideRight(
            child: const _VerifyOtpScreen(),
            state: state,
          ),
        ),

        // ═══════════════════════════════════════════════════════════════
        // MAIN SHELL ROUTE (Bottom Navigation)
        // ═══════════════════════════════════════════════════════════════
        StatefulShellRoute.indexedStack(
          builder: (context, state, navigationShell) {
            return _MainShellScaffold(navigationShell: navigationShell);
          },
          branches: [
            // Home Branch
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: AppRoutes.homePath,
                  name: AppRoutes.home,
                  pageBuilder: (context, state) => AppTransitions.fade(
                    child: const HomeScreen(),
                    state: state,
                  ),
                ),
              ],
            ),
            // Categories Branch
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: AppRoutes.categoriesPath,
                  name: AppRoutes.categories,
                  pageBuilder: (context, state) => AppTransitions.fade(
                    child: const CategoriesScreen(),
                    state: state,
                  ),
                  routes: [
                    GoRoute(
                      path: ':categoryId/products',
                      name: AppRoutes.categoryProducts,
                      pageBuilder: (context, state) {
                        final categoryId = state.pathParameters['categoryId']!;
                        final extra = state.extra as Map<String, dynamic>?;
                        return AppTransitions.slideRight(
                          child: _ProductListScreen(
                            categoryId: categoryId,
                            categoryName: extra?['categoryName'],
                          ),
                          state: state,
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
            // Search Branch
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: AppRoutes.searchPath,
                  name: AppRoutes.search,
                  pageBuilder: (context, state) => AppTransitions.fade(
                    child: const SearchScreen(),
                    state: state,
                  ),
                ),
              ],
            ),
            // Cart Branch
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: AppRoutes.cartPath,
                  name: AppRoutes.cart,
                  pageBuilder: (context, state) => AppTransitions.fade(
                    child: const CartScreen(),
                    state: state,
                  ),
                ),
              ],
            ),
            // Profile Branch
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: AppRoutes.profilePath,
                  name: AppRoutes.profile,
                  pageBuilder: (context, state) => AppTransitions.fade(
                    child: const ProfileScreen(),
                    state: state,
                  ),
                  routes: [
                    GoRoute(
                      path: 'edit',
                      name: AppRoutes.editProfile,
                      pageBuilder: (context, state) =>
                          AppTransitions.slideRight(
                            child: const EditProfileScreen(),
                            state: state,
                          ),
                    ),
                    GoRoute(
                      path: 'addresses',
                      name: AppRoutes.addresses,
                      pageBuilder: (context, state) =>
                          AppTransitions.slideRight(
                            child: const AddressesScreen(),
                            state: state,
                          ),
                      routes: [
                        GoRoute(
                          path: 'add',
                          name: AppRoutes.addAddress,
                          pageBuilder: (context, state) =>
                              AppTransitions.slideUp(
                                child: const _AddAddressScreen(),
                                state: state,
                              ),
                        ),
                        GoRoute(
                          path: ':addressId/edit',
                          name: AppRoutes.editAddress,
                          pageBuilder: (context, state) {
                            final addressId =
                                state.pathParameters['addressId']!;
                            return AppTransitions.slideRight(
                              child: _EditAddressScreen(addressId: addressId),
                              state: state,
                            );
                          },
                        ),
                      ],
                    ),
                    GoRoute(
                      path: 'change-password',
                      name: AppRoutes.changePassword,
                      pageBuilder: (context, state) =>
                          AppTransitions.slideRight(
                            child: const _ChangePasswordScreen(),
                            state: state,
                          ),
                    ),
                    GoRoute(
                      path: 'settings',
                      name: AppRoutes.settings,
                      pageBuilder: (context, state) =>
                          AppTransitions.slideRight(
                            child: const SettingsScreen(),
                            state: state,
                          ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),

        // ═══════════════════════════════════════════════════════════════
        // PRODUCT ROUTES
        // ═══════════════════════════════════════════════════════════════
        GoRoute(
          path: AppRoutes.productsPath,
          name: AppRoutes.products,
          pageBuilder: (context, state) => AppTransitions.slideRight(
            child: const ProductsScreen(),
            state: state,
          ),
        ),
        GoRoute(
          path: AppRoutes.productDetailPath,
          name: AppRoutes.productDetail,
          pageBuilder: (context, state) {
            final productId = state.pathParameters['productId']!;
            return AppTransitions.sharedAxisHorizontal(
              child: ProductDetailsScreen(id: productId),
              state: state,
            );
          },
        ),
        // Deep link for products
        GoRoute(
          path: '/p/:productId',
          redirect: (context, state) {
            final productId = state.pathParameters['productId'];
            return '/products/$productId';
          },
        ),
        // Category products
        GoRoute(
          path: AppRoutes.productsByCategoryPath,
          name: AppRoutes.productsByCategory,
          pageBuilder: (context, state) {
            final categoryId = state.pathParameters['categoryId']!;
            final extra = state.extra as Map<String, dynamic>?;
            return AppTransitions.slideRight(
              child: _ProductListScreen(
                categoryId: categoryId,
                categoryName: extra?['categoryName'],
              ),
              state: state,
            );
          },
        ),

        // ═══════════════════════════════════════════════════════════════
        // WISHLIST ROUTES
        // ═══════════════════════════════════════════════════════════════
        GoRoute(
          path: AppRoutes.wishlistPath,
          name: AppRoutes.wishlist,
          pageBuilder: (context, state) => AppTransitions.slideRight(
            child: const WishlistScreen(),
            state: state,
          ),
        ),

        // ═══════════════════════════════════════════════════════════════
        // CHECKOUT ROUTES
        // ═══════════════════════════════════════════════════════════════
        GoRoute(
          path: AppRoutes.checkoutPath,
          name: AppRoutes.checkout,
          pageBuilder: (context, state) => AppTransitions.slideUp(
            child: const CheckoutScreen(),
            state: state,
          ),
          routes: [
            GoRoute(
              path: 'address',
              name: AppRoutes.addressSelection,
              pageBuilder: (context, state) => AppTransitions.slideRight(
                child: const _AddressSelectionScreen(),
                state: state,
              ),
            ),
            GoRoute(
              path: 'payment',
              name: AppRoutes.paymentMethod,
              pageBuilder: (context, state) => AppTransitions.slideRight(
                child: const _PaymentMethodScreen(),
                state: state,
              ),
            ),
            GoRoute(
              path: 'review',
              name: AppRoutes.orderReview,
              pageBuilder: (context, state) => AppTransitions.slideRight(
                child: const _OrderReviewScreen(),
                state: state,
              ),
            ),
          ],
        ),
        GoRoute(
          path: AppRoutes.orderSuccessPath,
          name: AppRoutes.orderSuccess,
          pageBuilder: (context, state) {
            final orderId = state.pathParameters['orderId']!;
            return AppTransitions.scale(
              child: const OrderSuccessScreen(),
              state: state,
            );
          },
        ),

        // ═══════════════════════════════════════════════════════════════
        // ORDER ROUTES
        // ═══════════════════════════════════════════════════════════════
        GoRoute(
          path: AppRoutes.ordersPath,
          name: AppRoutes.orders,
          pageBuilder: (context, state) => AppTransitions.slideRight(
            child: const OrdersScreen(),
            state: state,
          ),
        ),
        GoRoute(
          path: AppRoutes.orderDetailPath,
          name: AppRoutes.orderDetail,
          pageBuilder: (context, state) {
            final orderId = state.pathParameters['orderId']!;
            return AppTransitions.slideRight(
              child: OrderDetailsScreen(orderId: orderId),
              state: state,
            );
          },
        ),
        GoRoute(
          path: AppRoutes.trackOrderPath,
          name: AppRoutes.trackOrder,
          pageBuilder: (context, state) {
            final orderId = state.pathParameters['orderId']!;
            return AppTransitions.slideUp(
              child: _TrackOrderScreen(orderId: orderId),
              state: state,
            );
          },
        ),

        // ═══════════════════════════════════════════════════════════════
        // NOTIFICATION ROUTES
        // ═══════════════════════════════════════════════════════════════
        GoRoute(
          path: AppRoutes.notificationsPath,
          name: AppRoutes.notifications,
          pageBuilder: (context, state) => AppTransitions.slideRight(
            child: const NotificationsScreen(),
            state: state,
          ),
        ),

        // ═══════════════════════════════════════════════════════════════
        // WALLET ROUTES
        // ═══════════════════════════════════════════════════════════════
        GoRoute(
          path: AppRoutes.walletPath,
          name: AppRoutes.wallet,
          pageBuilder: (context, state) => AppTransitions.slideRight(
            child: const WalletScreen(),
            state: state,
          ),
        ),

        // ═══════════════════════════════════════════════════════════════
        // COUPONS ROUTES
        // ═══════════════════════════════════════════════════════════════
        GoRoute(
          path: AppRoutes.couponsPath,
          name: AppRoutes.coupons,
          pageBuilder: (context, state) => AppTransitions.slideRight(
            child: const CouponsScreen(),
            state: state,
          ),
        ),

        // ═══════════════════════════════════════════════════════════════
        // SUPPORT ROUTES
        // ═══════════════════════════════════════════════════════════════
        GoRoute(
          path: AppRoutes.helpPath,
          name: AppRoutes.help,
          pageBuilder: (context, state) => AppTransitions.slideRight(
            child: const HelpSupportScreen(),
            state: state,
          ),
        ),
        GoRoute(
          path: AppRoutes.faqPath,
          name: AppRoutes.faq,
          pageBuilder: (context, state) => AppTransitions.slideRight(
            child: const _FaqScreen(),
            state: state,
          ),
        ),
        GoRoute(
          path: AppRoutes.contactUsPath,
          name: AppRoutes.contactUs,
          pageBuilder: (context, state) => AppTransitions.slideRight(
            child: const _ContactUsScreen(),
            state: state,
          ),
        ),
        GoRoute(
          path: AppRoutes.aboutPath,
          name: AppRoutes.about,
          pageBuilder: (context, state) => AppTransitions.slideRight(
            child: const _AboutScreen(),
            state: state,
          ),
        ),
        GoRoute(
          path: AppRoutes.privacyPolicyPath,
          name: AppRoutes.privacyPolicy,
          pageBuilder: (context, state) => AppTransitions.slideRight(
            child: const _PrivacyPolicyScreen(),
            state: state,
          ),
        ),
        GoRoute(
          path: AppRoutes.termsOfServicePath,
          name: AppRoutes.termsOfService,
          pageBuilder: (context, state) => AppTransitions.slideRight(
            child: const _TermsScreen(),
            state: state,
          ),
        ),

        // ═══════════════════════════════════════════════════════════════
        // DEEP LINK ROUTES
        // ═══════════════════════════════════════════════════════════════
        GoRoute(
          path: '/c/:categoryId',
          redirect: (context, state) {
            final categoryId = state.pathParameters['categoryId'];
            return '/category/$categoryId/products';
          },
        ),
        GoRoute(
          path: '/promo/:promoCode',
          redirect: (context, state) {
            // Redirect to cart with promo code
            return AppRoutes.cartPath;
          },
        ),
      ],
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// MAIN SHELL SCAFFOLD
// ═══════════════════════════════════════════════════════════════

class _MainShellScaffold extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const _MainShellScaffold({required this.navigationShell});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: NavigationBar(
          selectedIndex: navigationShell.currentIndex,
          onDestinationSelected: (index) {
            navigationShell.goBranch(
              index,
              initialLocation: index == navigationShell.currentIndex,
            );
          },
          backgroundColor: theme.colorScheme.surface,
          elevation: 0,
          height: 65,
          labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.home_outlined),
              selectedIcon: Icon(Icons.home),
              label: 'Home',
            ),
            NavigationDestination(
              icon: Icon(Icons.category_outlined),
              selectedIcon: Icon(Icons.category),
              label: 'Categories',
            ),
            NavigationDestination(
              icon: Icon(Icons.search_outlined),
              selectedIcon: Icon(Icons.search),
              label: 'Search',
            ),
            NavigationDestination(
              icon: _CartBadge(selected: false),
              selectedIcon: _CartBadge(selected: true),
              label: 'Cart',
            ),
            NavigationDestination(
              icon: Icon(Icons.person_outline),
              selectedIcon: Icon(Icons.person),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}

class _CartBadge extends StatelessWidget {
  final bool selected;

  const _CartBadge({required this.selected});

  @override
  Widget build(BuildContext context) {
    // TODO: Get cart count from CartCubit
    const cartCount = 0;

    return Badge(
      isLabelVisible: cartCount > 0,
      label: Text(cartCount.toString()),
      child: Icon(
        selected ? Icons.shopping_cart : Icons.shopping_cart_outlined,
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// PLACEHOLDER SCREENS (Replace with actual implementations)
// ═══════════════════════════════════════════════════════════════

class _SplashScreen extends StatelessWidget {
  const _SplashScreen();

  @override
  Widget build(BuildContext context) {
    // Auto-navigate after delay
    Future.delayed(const Duration(seconds: 2), () {
      if (context.mounted) {
        context.go(AppRoutes.homePath);
      }
    });

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.shopping_bag,
              size: 80,
              color: Theme.of(context).primaryColor,
            ),
            const SizedBox(height: 16),
            Text(
              WhiteLabelConfig.appName,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
    );
  }
}

class _OnboardingScreen extends StatelessWidget {
  const _OnboardingScreen();
  @override
  Widget build(BuildContext context) =>
      const Scaffold(body: Center(child: Text('Onboarding')));
}

class _LoginScreen extends StatelessWidget {
  const _LoginScreen();
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Login')),
    body: const Center(child: Text('Login Screen')),
  );
}

class _RegisterScreen extends StatelessWidget {
  const _RegisterScreen();
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Register')),
    body: const Center(child: Text('Register Screen')),
  );
}

class _ForgotPasswordScreen extends StatelessWidget {
  const _ForgotPasswordScreen();
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Forgot Password')),
    body: const Center(child: Text('Forgot Password Screen')),
  );
}

class _VerifyOtpScreen extends StatelessWidget {
  const _VerifyOtpScreen();
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Verify OTP')),
    body: const Center(child: Text('Verify OTP Screen')),
  );
}

class _CategoriesScreen extends StatelessWidget {
  const _CategoriesScreen();
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Categories')),
    body: const Center(child: Text('Categories Screen')),
  );
}

class _SearchScreen extends StatelessWidget {
  const _SearchScreen();
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Search')),
    body: const Center(child: Text('Search Screen')),
  );
}

class _CartScreen extends StatelessWidget {
  const _CartScreen();
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Cart')),
    body: const Center(child: Text('Cart Screen')),
  );
}

class _ProfileScreen extends StatelessWidget {
  const _ProfileScreen();
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Profile')),
    body: ListView(
      children: [
        ListTile(
          title: const Text('Edit Profile'),
          onTap: () => context.goNamed(AppRoutes.editProfile),
        ),
        ListTile(
          title: const Text('Addresses'),
          onTap: () => context.goNamed(AppRoutes.addresses),
        ),
        ListTile(
          title: const Text('Orders'),
          onTap: () => context.go(AppRoutes.ordersPath),
        ),
        ListTile(
          title: const Text('Wishlist'),
          onTap: () => context.go(AppRoutes.wishlistPath),
        ),
        ListTile(
          title: const Text('Settings'),
          onTap: () => context.goNamed(AppRoutes.settings),
        ),
      ],
    ),
  );
}

class _ProductListScreen extends StatelessWidget {
  final String? categoryId;
  final String? categoryName;
  const _ProductListScreen({this.categoryId, this.categoryName});
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: Text(categoryName ?? 'Products')),
    body: Center(child: Text('Products for ${categoryId ?? 'all'}')),
  );
}

class _ProductDetailScreen extends StatelessWidget {
  final String productId;
  const _ProductDetailScreen({required this.productId});
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Product Detail')),
    body: Center(child: Text('Product: $productId')),
  );
}

class _WishlistScreen extends StatelessWidget {
  const _WishlistScreen();
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Wishlist')),
    body: const Center(child: Text('Wishlist Screen')),
  );
}

class _CheckoutScreen extends StatelessWidget {
  const _CheckoutScreen();
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Checkout')),
    body: const Center(child: Text('Checkout Screen')),
  );
}

class _AddressSelectionScreen extends StatelessWidget {
  const _AddressSelectionScreen();
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Select Address')),
    body: const Center(child: Text('Address Selection')),
  );
}

class _PaymentMethodScreen extends StatelessWidget {
  const _PaymentMethodScreen();
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Payment Method')),
    body: const Center(child: Text('Payment Method Screen')),
  );
}

class _OrderReviewScreen extends StatelessWidget {
  const _OrderReviewScreen();
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Review Order')),
    body: const Center(child: Text('Order Review Screen')),
  );
}

class _OrderSuccessScreen extends StatelessWidget {
  final String orderId;
  const _OrderSuccessScreen({required this.orderId});
  @override
  Widget build(BuildContext context) => Scaffold(
    body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.check_circle, size: 80, color: Colors.green),
          const SizedBox(height: 16),
          const Text('Order Placed Successfully!'),
          Text('Order ID: $orderId'),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () => context.go(AppRoutes.homePath),
            child: const Text('Continue Shopping'),
          ),
        ],
      ),
    ),
  );
}

class _OrdersScreen extends StatelessWidget {
  const _OrdersScreen();
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('My Orders')),
    body: const Center(child: Text('Orders Screen')),
  );
}

class _OrderDetailScreen extends StatelessWidget {
  final String orderId;
  const _OrderDetailScreen({required this.orderId});
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Order Details')),
    body: Center(child: Text('Order: $orderId')),
  );
}

class _TrackOrderScreen extends StatelessWidget {
  final String orderId;
  const _TrackOrderScreen({required this.orderId});
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Track Order')),
    body: Center(child: Text('Tracking: $orderId')),
  );
}

class _AddAddressScreen extends StatelessWidget {
  const _AddAddressScreen();
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Add Address')),
    body: const Center(child: Text('Add Address Screen')),
  );
}

class _EditAddressScreen extends StatelessWidget {
  final String addressId;
  const _EditAddressScreen({required this.addressId});
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Edit Address')),
    body: Center(child: Text('Edit Address: $addressId')),
  );
}

class _ChangePasswordScreen extends StatelessWidget {
  const _ChangePasswordScreen();
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Change Password')),
    body: const Center(child: Text('Change Password Screen')),
  );
}

class _FaqScreen extends StatelessWidget {
  const _FaqScreen();
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('FAQ')),
    body: const Center(child: Text('FAQ Screen')),
  );
}

class _ContactUsScreen extends StatelessWidget {
  const _ContactUsScreen();
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Contact Us')),
    body: const Center(child: Text('Contact Us Screen')),
  );
}

class _AboutScreen extends StatelessWidget {
  const _AboutScreen();
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('About')),
    body: const Center(child: Text('About Screen')),
  );
}

class _PrivacyPolicyScreen extends StatelessWidget {
  const _PrivacyPolicyScreen();
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Privacy Policy')),
    body: const Center(child: Text('Privacy Policy Screen')),
  );
}

class _TermsScreen extends StatelessWidget {
  const _TermsScreen();
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Terms of Service')),
    body: const Center(child: Text('Terms of Service Screen')),
  );
}

class _ErrorScreen extends StatelessWidget {
  final Exception? error;
  const _ErrorScreen({this.error});
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Error')),
    body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 64, color: Colors.red),
          const SizedBox(height: 16),
          const Text('Page not found'),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => context.go(AppRoutes.homePath),
            child: const Text('Go Home'),
          ),
        ],
      ),
    ),
  );
}
