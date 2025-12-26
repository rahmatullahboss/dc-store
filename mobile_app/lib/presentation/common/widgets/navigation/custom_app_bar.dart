import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';

/// CustomAppBar - App bar with search and cart badge
///
/// Example usage:
/// ```dart
/// CustomAppBar(
///   title: 'DC Store',
///   showSearch: true,
///   cartCount: 3,
///   onSearchTap: () => openSearch(),
///   onCartTap: () => openCart(),
/// )
/// ```
class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  /// App bar title
  final String? title;

  /// Custom title widget (overrides title string)
  final Widget? titleWidget;

  /// Whether to show back button
  final bool showBack;

  /// Whether to show search icon
  final bool showSearch;

  /// Whether to show cart icon
  final bool showCart;

  /// Whether to show notifications icon
  final bool showNotifications;

  /// Number of items in cart (for badge)
  final int cartCount;

  /// Number of notifications (for badge)
  final int notificationCount;

  /// Callback for back button
  final VoidCallback? onBack;

  /// Callback for search tap
  final VoidCallback? onSearchTap;

  /// Callback for cart tap
  final VoidCallback? onCartTap;

  /// Callback for notifications tap
  final VoidCallback? onNotificationsTap;

  /// Custom leading widget
  final Widget? leading;

  /// Custom actions
  final List<Widget>? actions;

  /// Background color
  final Color? backgroundColor;

  /// Whether to center the title
  final bool centerTitle;

  /// Elevation
  final double elevation;

  /// Scroll controller for elevation on scroll
  final ScrollController? scrollController;

  const CustomAppBar({
    super.key,
    this.title,
    this.titleWidget,
    this.showBack = false,
    this.showSearch = false,
    this.showCart = false,
    this.showNotifications = false,
    this.cartCount = 0,
    this.notificationCount = 0,
    this.onBack,
    this.onSearchTap,
    this.onCartTap,
    this.onNotificationsTap,
    this.leading,
    this.actions,
    this.backgroundColor,
    this.centerTitle = false,
    this.elevation = 0,
    this.scrollController,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor =
        backgroundColor ??
        (isDark ? AppColors.darkBackground : AppColors.background);

    return AppBar(
      backgroundColor: bgColor,
      elevation: elevation,
      scrolledUnderElevation: 1,
      surfaceTintColor: Colors.transparent,
      systemOverlayStyle: isDark
          ? SystemUiOverlayStyle.light
          : SystemUiOverlayStyle.dark,
      leading: _buildLeading(context, isDark),
      title: _buildTitle(isDark),
      centerTitle: centerTitle,
      actions: _buildActions(isDark),
    );
  }

  Widget? _buildLeading(BuildContext context, bool isDark) {
    if (leading != null) return leading;

    if (showBack) {
      return IconButton(
        icon: Icon(
          Icons.arrow_back_ios_new_rounded,
          color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
        ),
        onPressed: onBack ?? () => Navigator.of(context).maybePop(),
      );
    }

    return null;
  }

  Widget? _buildTitle(bool isDark) {
    if (titleWidget != null) return titleWidget;

    if (title != null) {
      return Text(
        title!,
        style: AppTextStyles.h5.copyWith(
          color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
        ),
      );
    }

    return null;
  }

  List<Widget>? _buildActions(bool isDark) {
    if (actions != null) return actions;

    final List<Widget> actionWidgets = [];

    if (showSearch) {
      actionWidgets.add(
        IconButton(
          icon: Icon(
            Icons.search_rounded,
            color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
          ),
          onPressed: onSearchTap,
        ),
      );
    }

    if (showNotifications) {
      actionWidgets.add(
        _BadgeIconButton(
          icon: Icons.notifications_outlined,
          count: notificationCount,
          onTap: onNotificationsTap,
          isDark: isDark,
        ),
      );
    }

    if (showCart) {
      actionWidgets.add(
        _BadgeIconButton(
          icon: Icons.shopping_cart_outlined,
          count: cartCount,
          onTap: onCartTap,
          isDark: isDark,
        ),
      );
    }

    return actionWidgets.isEmpty ? null : actionWidgets;
  }
}

/// App bar with integrated search field
class SearchAppBar extends StatelessWidget implements PreferredSizeWidget {
  final TextEditingController? controller;
  final String? hint;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final VoidCallback? onBack;
  final VoidCallback? onClear;
  final bool autofocus;

  const SearchAppBar({
    super.key,
    this.controller,
    this.hint = 'Search products...',
    this.onChanged,
    this.onSubmitted,
    this.onBack,
    this.onClear,
    this.autofocus = true,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return AppBar(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.background,
      elevation: 0,
      scrolledUnderElevation: 1,
      surfaceTintColor: Colors.transparent,
      leading: IconButton(
        icon: Icon(
          Icons.arrow_back_ios_new_rounded,
          color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
        ),
        onPressed: onBack ?? () => Navigator.of(context).maybePop(),
      ),
      title: TextField(
        controller: controller,
        autofocus: autofocus,
        onChanged: onChanged,
        onSubmitted: onSubmitted,
        style: AppTextStyles.bodyMedium.copyWith(
          color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
        ),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: AppTextStyles.bodyMedium.copyWith(
            color: isDark ? AppColors.darkTextHint : AppColors.textHint,
          ),
          border: InputBorder.none,
          contentPadding: EdgeInsets.zero,
        ),
      ),
      actions: [
        IconButton(
          icon: Icon(
            Icons.close_rounded,
            color: isDark
                ? AppColors.darkTextSecondary
                : AppColors.textSecondary,
          ),
          onPressed: () {
            controller?.clear();
            onClear?.call();
          },
        ),
      ],
    );
  }
}

/// SliverAppBar variant with scroll behavior
class CustomSliverAppBar extends StatelessWidget {
  final String? title;
  final Widget? titleWidget;
  final Widget? flexibleSpace;
  final double expandedHeight;
  final bool pinned;
  final bool floating;
  final bool snap;
  final bool showBack;
  final List<Widget>? actions;
  final Color? backgroundColor;

  const CustomSliverAppBar({
    super.key,
    this.title,
    this.titleWidget,
    this.flexibleSpace,
    this.expandedHeight = 200,
    this.pinned = true,
    this.floating = false,
    this.snap = false,
    this.showBack = true,
    this.actions,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return SliverAppBar(
      backgroundColor:
          backgroundColor ??
          (isDark ? AppColors.darkBackground : AppColors.background),
      expandedHeight: expandedHeight,
      pinned: pinned,
      floating: floating,
      snap: snap,
      elevation: 0,
      scrolledUnderElevation: 1,
      surfaceTintColor: Colors.transparent,
      leading: showBack
          ? IconButton(
              icon: Icon(
                Icons.arrow_back_ios_new_rounded,
                color: isDark
                    ? AppColors.darkTextPrimary
                    : AppColors.textPrimary,
              ),
              onPressed: () => Navigator.of(context).maybePop(),
            )
          : null,
      title:
          titleWidget ??
          (title != null
              ? Text(
                  title!,
                  style: AppTextStyles.h5.copyWith(
                    color: isDark
                        ? AppColors.darkTextPrimary
                        : AppColors.textPrimary,
                  ),
                )
              : null),
      actions: actions,
      flexibleSpace: flexibleSpace,
    );
  }
}

class _BadgeIconButton extends StatelessWidget {
  final IconData icon;
  final int count;
  final VoidCallback? onTap;
  final bool isDark;

  const _BadgeIconButton({
    required this.icon,
    required this.count,
    this.onTap,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        IconButton(
          icon: Icon(
            icon,
            color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
          ),
          onPressed: onTap,
        ),
        if (count > 0)
          Positioned(
            right: 4,
            top: 4,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
              decoration: BoxDecoration(
                color: AppColors.error,
                borderRadius: BorderRadius.circular(10),
              ),
              constraints: const BoxConstraints(minWidth: 18),
              child: Text(
                count > 99 ? '99+' : count.toString(),
                style: AppTextStyles.overline.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
      ],
    );
  }
}
