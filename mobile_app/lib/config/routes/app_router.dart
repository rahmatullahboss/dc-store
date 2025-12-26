import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../presentation/layout/main_layout.dart';
import '../../presentation/home/home_screen.dart';
import '../../presentation/products/products_screen.dart';
import '../../presentation/products/product_details_screen.dart';
import '../../presentation/cart/cart_screen.dart';
import '../../presentation/profile/profile_screen.dart';
import '../../features/auth/presentation/login_screen.dart';
import '../../features/auth/presentation/register_screen.dart';
import '../../features/checkout/presentation/checkout_screen.dart';
import '../../presentation/reviews/write_review_screen.dart';

/// App Router Configuration
class AppRouter {
  AppRouter._();

  static final _rootNavigatorKey = GlobalKey<NavigatorState>();
  static final _shellNavigatorKey = GlobalKey<NavigatorState>();

  static final GoRouter router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/',
    debugLogDiagnostics: true,
    routes: [
      // Shell route for bottom navigation
      ShellRoute(
        navigatorKey: _shellNavigatorKey,
        builder: (context, state, child) =>
            MainLayout(currentPath: state.uri.path, child: child),
        routes: [
          GoRoute(
            path: '/',
            name: 'home',
            pageBuilder: (context, state) =>
                const NoTransitionPage(child: HomeScreen()),
          ),
          GoRoute(
            path: '/products',
            name: 'products',
            pageBuilder: (context, state) =>
                const NoTransitionPage(child: ProductsScreen()),
          ),
          GoRoute(
            path: '/cart',
            name: 'cart',
            pageBuilder: (context, state) =>
                const NoTransitionPage(child: CartScreen()),
          ),
          GoRoute(
            path: '/profile',
            name: 'profile',
            pageBuilder: (context, state) =>
                const NoTransitionPage(child: ProfileScreen()),
          ),
        ],
      ),

      // Auth routes (outside shell)
      GoRoute(
        path: '/login',
        name: 'login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/register',
        name: 'register',
        builder: (context, state) => const RegisterScreen(),
      ),

      // Product details
      GoRoute(
        path: '/product/:id',
        name: 'product-details',
        builder: (context, state) {
          final productId = state.pathParameters['id']!;
          return ProductDetailsScreen(id: productId);
        },
      ),

      // Checkout
      GoRoute(
        path: '/checkout',
        name: 'checkout',
        builder: (context, state) => const CheckoutScreen(),
      ),

      // Order success
      GoRoute(
        path: '/order-success',
        name: 'order-success',
        builder: (context, state) => const Scaffold(
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.check_circle, color: Colors.green, size: 80),
                SizedBox(height: 16),
                Text(
                  'Order Placed Successfully!',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ),
      ),

      // Write Review
      GoRoute(
        path: '/write-review',
        name: 'write-review',
        builder: (context, state) {
          final productId = state.uri.queryParameters['productId'];
          final orderId = state.uri.queryParameters['orderId'];
          return WriteReviewScreen(productId: productId, orderId: orderId);
        },
      ),
    ],
    errorBuilder: (context, state) =>
        Scaffold(body: Center(child: Text('Page not found: ${state.uri}'))),
  );
}
