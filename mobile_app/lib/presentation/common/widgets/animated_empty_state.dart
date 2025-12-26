import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lottie/lottie.dart';
import '../../../core/theme/app_colors.dart';

/// Types of empty states for different screens
enum EmptyStateType { cart, wishlist, orders, search, notifications, generic }

/// Animated empty state widget with Lottie animation support
/// Falls back to icon if Lottie asset not available
class AnimatedEmptyState extends StatelessWidget {
  final EmptyStateType type;
  final String title;
  final String? subtitle;
  final String? actionLabel;
  final VoidCallback? onAction;
  final String? lottieAsset;
  final IconData? fallbackIcon;

  const AnimatedEmptyState({
    super.key,
    required this.type,
    required this.title,
    this.subtitle,
    this.actionLabel,
    this.onAction,
    this.lottieAsset,
    this.fallbackIcon,
  });

  /// Convenience factories for common empty states
  factory AnimatedEmptyState.cart({VoidCallback? onStartShopping}) {
    return AnimatedEmptyState(
      type: EmptyStateType.cart,
      title: 'Your cart is empty',
      subtitle: 'Looks like you haven\'t added anything yet.',
      actionLabel: 'Start Shopping',
      onAction: onStartShopping,
      lottieAsset: 'assets/lottie/empty_cart.json',
      fallbackIcon: Icons.shopping_cart_outlined,
    );
  }

  factory AnimatedEmptyState.wishlist({VoidCallback? onExplore}) {
    return AnimatedEmptyState(
      type: EmptyStateType.wishlist,
      title: 'Your wishlist is empty',
      subtitle: 'Save items you love to buy them later.',
      actionLabel: 'Explore Products',
      onAction: onExplore,
      lottieAsset: 'assets/lottie/empty_wishlist.json',
      fallbackIcon: Icons.favorite_border,
    );
  }

  factory AnimatedEmptyState.orders({VoidCallback? onShopNow}) {
    return AnimatedEmptyState(
      type: EmptyStateType.orders,
      title: 'No orders yet',
      subtitle: 'When you place orders, they\'ll appear here.',
      actionLabel: 'Shop Now',
      onAction: onShopNow,
      lottieAsset: 'assets/lottie/empty_orders.json',
      fallbackIcon: Icons.receipt_long_outlined,
    );
  }

  factory AnimatedEmptyState.search({String? query}) {
    return AnimatedEmptyState(
      type: EmptyStateType.search,
      title: 'No results found',
      subtitle: query != null
          ? 'We couldn\'t find anything for "$query".'
          : 'Try a different search term.',
      lottieAsset: 'assets/lottie/not_found.json',
      fallbackIcon: Icons.search_off,
    );
  }

  factory AnimatedEmptyState.notifications() {
    return const AnimatedEmptyState(
      type: EmptyStateType.notifications,
      title: 'You\'re all caught up!',
      subtitle: 'Check back later for new updates.',
      lottieAsset: 'assets/lottie/empty_notifications.json',
      fallbackIcon: Icons.notifications_none,
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : AppColors.textPrimary;
    final subtleColor = isDark ? Colors.grey[400] : AppColors.textSecondary;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Illustration (Lottie or fallback icon)
            _buildIllustration(isDark),

            const SizedBox(height: 24),

            // Title
            Text(
              title,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
              textAlign: TextAlign.center,
            ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.2, end: 0),

            if (subtitle != null) ...[
              const SizedBox(height: 8),
              Text(
                subtitle!,
                style: TextStyle(fontSize: 16, color: subtleColor),
                textAlign: TextAlign.center,
              ).animate().fadeIn(delay: 300.ms).slideY(begin: 0.2, end: 0),
            ],

            if (actionLabel != null && onAction != null) ...[
              const SizedBox(height: 24),
              ElevatedButton(
                    onPressed: onAction,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.accent,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 32,
                        vertical: 14,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(actionLabel!),
                  )
                  .animate()
                  .fadeIn(delay: 400.ms)
                  .scale(begin: const Offset(0.9, 0.9)),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildIllustration(bool isDark) {
    if (lottieAsset != null) {
      return SizedBox(
        width: 150,
        height: 150,
        child: Lottie.asset(
          lottieAsset!,
          fit: BoxFit.contain,
          repeat: true,
          errorBuilder: (context, error, stackTrace) {
            // Fallback to icon if Lottie fails
            return _buildFallbackIcon(isDark);
          },
        ),
      ).animate().fadeIn().scale(begin: const Offset(0.8, 0.8));
    }
    return _buildFallbackIcon(isDark);
  }

  Widget _buildFallbackIcon(bool isDark) {
    return Container(
      width: 120,
      height: 120,
      decoration: BoxDecoration(
        color: (isDark ? AppColors.accent : AppColors.accent).withAlpha(26),
        shape: BoxShape.circle,
      ),
      child: Icon(
        fallbackIcon ?? Icons.inbox,
        size: 56,
        color: AppColors.accent,
      ),
    ).animate().fadeIn().scale(begin: const Offset(0.8, 0.8));
  }
}
