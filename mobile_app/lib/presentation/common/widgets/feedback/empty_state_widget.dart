import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';

/// EmptyStateWidget - Displays when content is empty
///
/// Example usage:
/// ```dart
/// EmptyStateWidget(
///   icon: Icons.shopping_cart_outlined,
///   title: 'Your cart is empty',
///   message: 'Add items to get started',
///   actionLabel: 'Start Shopping',
///   onAction: () => navigate('/home'),
/// )
/// ```
class EmptyStateWidget extends StatelessWidget {
  /// Icon to display
  final IconData icon;

  /// Custom illustration widget (overrides icon)
  final Widget? illustration;

  /// Title text
  final String title;

  /// Description message
  final String? message;

  /// Action button label
  final String? actionLabel;

  /// Callback for action button
  final VoidCallback? onAction;

  /// Whether to use compact layout
  final bool compact;

  /// Icon size
  final double? iconSize;

  /// Icon color
  final Color? iconColor;

  const EmptyStateWidget({
    super.key,
    required this.icon,
    this.illustration,
    required this.title,
    this.message,
    this.actionLabel,
    this.onAction,
    this.compact = false,
    this.iconSize,
    this.iconColor,
  });

  /// Empty cart preset
  factory EmptyStateWidget.emptyCart({VoidCallback? onAction}) {
    return EmptyStateWidget(
      icon: Icons.shopping_cart_outlined,
      title: 'Your cart is empty',
      message: 'Looks like you haven\'t added any items yet',
      actionLabel: 'Start Shopping',
      onAction: onAction,
    );
  }

  /// Empty wishlist preset
  factory EmptyStateWidget.emptyWishlist({VoidCallback? onAction}) {
    return EmptyStateWidget(
      icon: Icons.favorite_outline_rounded,
      title: 'Your wishlist is empty',
      message: 'Save items you love to buy later',
      actionLabel: 'Explore Products',
      onAction: onAction,
    );
  }

  /// No orders preset
  factory EmptyStateWidget.noOrders({VoidCallback? onAction}) {
    return EmptyStateWidget(
      icon: Icons.receipt_long_outlined,
      title: 'No orders yet',
      message: 'Your order history will appear here',
      actionLabel: 'Start Shopping',
      onAction: onAction,
    );
  }

  /// No search results preset
  factory EmptyStateWidget.noResults({String? query}) {
    return EmptyStateWidget(
      icon: Icons.search_off_rounded,
      title: 'No results found',
      message: query != null
          ? 'We couldn\'t find anything for "$query"'
          : 'Try adjusting your search or filters',
    );
  }

  /// No notifications preset
  factory EmptyStateWidget.noNotifications() {
    return const EmptyStateWidget(
      icon: Icons.notifications_off_outlined,
      title: 'No notifications',
      message: 'You\'re all caught up!',
    );
  }

  /// No address preset
  factory EmptyStateWidget.noAddress({VoidCallback? onAction}) {
    return EmptyStateWidget(
      icon: Icons.location_off_outlined,
      title: 'No addresses saved',
      message: 'Add a delivery address to continue',
      actionLabel: 'Add Address',
      onAction: onAction,
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final effectiveIconSize = iconSize ?? (compact ? 48 : 80);
    final effectiveIconColor =
        iconColor ?? (isDark ? AppColors.darkTextHint : AppColors.textHint);

    return Center(
      child: Padding(
        padding: EdgeInsets.all(compact ? 16 : 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Illustration or Icon
            if (illustration != null)
              illustration!
            else
              Container(
                width: effectiveIconSize + 24,
                height: effectiveIconSize + 24,
                decoration: BoxDecoration(
                  color: (isDark ? AppColors.darkSurface : AppColors.surface),
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: Icon(
                  icon,
                  size: effectiveIconSize,
                  color: effectiveIconColor,
                ),
              ),
            SizedBox(height: compact ? 16 : 24),

            // Title
            Text(
              title,
              style: (compact ? AppTextStyles.h5 : AppTextStyles.h4).copyWith(
                color: isDark
                    ? AppColors.darkTextPrimary
                    : AppColors.textPrimary,
              ),
              textAlign: TextAlign.center,
            ),

            // Message
            if (message != null) ...[
              SizedBox(height: compact ? 8 : 12),
              Text(
                message!,
                style:
                    (compact
                            ? AppTextStyles.bodySmall
                            : AppTextStyles.bodyMedium)
                        .copyWith(
                          color: isDark
                              ? AppColors.darkTextSecondary
                              : AppColors.textSecondary,
                        ),
                textAlign: TextAlign.center,
              ),
            ],

            // Action button
            if (actionLabel != null && onAction != null) ...[
              SizedBox(height: compact ? 16 : 24),
              ElevatedButton(
                onPressed: onAction,
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(
                    horizontal: compact ? 24 : 32,
                    vertical: compact ? 12 : 16,
                  ),
                ),
                child: Text(actionLabel!),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
