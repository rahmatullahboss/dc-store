import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';

/// BottomNavItem configuration
class BottomNavItem {
  final IconData icon;
  final IconData? activeIcon;
  final String label;
  final int? badgeCount;

  const BottomNavItem({
    required this.icon,
    this.activeIcon,
    required this.label,
    this.badgeCount,
  });
}

/// BottomNavBar - Customizable bottom navigation with badges
///
/// Example usage:
/// ```dart
/// BottomNavBar(
///   currentIndex: _selectedIndex,
///   onTap: (index) => setState(() => _selectedIndex = index),
///   items: [
///     BottomNavItem(icon: Icons.home_outlined, label: 'Home'),
///     BottomNavItem(icon: Icons.category_outlined, label: 'Categories'),
///     BottomNavItem(icon: Icons.shopping_cart_outlined, label: 'Cart', badgeCount: 3),
///     BottomNavItem(icon: Icons.favorite_outline, label: 'Wishlist'),
///     BottomNavItem(icon: Icons.person_outline, label: 'Profile'),
///   ],
/// )
/// ```
class BottomNavBar extends StatelessWidget {
  /// Currently selected index
  final int currentIndex;

  /// Callback when tab is selected
  final ValueChanged<int> onTap;

  /// Navigation items
  final List<BottomNavItem> items;

  /// Background color
  final Color? backgroundColor;

  /// Selected item color
  final Color? selectedColor;

  /// Unselected item color
  final Color? unselectedColor;

  /// Show labels
  final bool showLabels;

  /// Animation duration
  final Duration animationDuration;

  const BottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
    required this.items,
    this.backgroundColor,
    this.selectedColor,
    this.unselectedColor,
    this.showLabels = true,
    this.animationDuration = const Duration(milliseconds: 200),
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor =
        backgroundColor ?? (isDark ? AppColors.darkCard : AppColors.card);
    final selectedClr =
        selectedColor ?? (isDark ? AppColors.darkPrimary : AppColors.primary);
    final unselectedClr =
        unselectedColor ??
        (isDark ? AppColors.darkTextHint : AppColors.textHint);

    return Container(
      decoration: BoxDecoration(
        color: bgColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.08),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: items.asMap().entries.map((entry) {
              final index = entry.key;
              final item = entry.value;
              final isSelected = index == currentIndex;

              return _NavItem(
                item: item,
                isSelected: isSelected,
                selectedColor: selectedClr,
                unselectedColor: unselectedClr,
                showLabel: showLabels,
                animationDuration: animationDuration,
                onTap: () => onTap(index),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final BottomNavItem item;
  final bool isSelected;
  final Color selectedColor;
  final Color unselectedColor;
  final bool showLabel;
  final Duration animationDuration;
  final VoidCallback onTap;

  const _NavItem({
    required this.item,
    required this.isSelected,
    required this.selectedColor,
    required this.unselectedColor,
    required this.showLabel,
    required this.animationDuration,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = isSelected ? selectedColor : unselectedColor;
    final icon = isSelected ? (item.activeIcon ?? item.icon) : item.icon;

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: animationDuration,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? selectedColor.withValues(alpha: 0.1)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                AnimatedScale(
                  scale: isSelected ? 1.1 : 1.0,
                  duration: animationDuration,
                  child: Icon(icon, color: color, size: 24),
                ),
                if (item.badgeCount != null && item.badgeCount! > 0)
                  Positioned(
                    right: -8,
                    top: -4,
                    child: _Badge(count: item.badgeCount!),
                  ),
              ],
            ),
            if (showLabel) ...[
              const SizedBox(height: 4),
              AnimatedDefaultTextStyle(
                duration: animationDuration,
                style: AppTextStyles.overline.copyWith(
                  color: color,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                ),
                child: Text(item.label),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  final int count;

  const _Badge({required this.count});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
      decoration: BoxDecoration(
        color: AppColors.error,
        borderRadius: BorderRadius.circular(10),
      ),
      constraints: const BoxConstraints(minWidth: 16),
      child: Text(
        count > 99 ? '99+' : count.toString(),
        style: AppTextStyles.overline.copyWith(
          color: Colors.white,
          fontWeight: FontWeight.w600,
          fontSize: 9,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}

/// Standard 5-tab bottom nav for ecommerce
class EcommerceBottomNav extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;
  final int cartCount;
  final int wishlistCount;

  const EcommerceBottomNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
    this.cartCount = 0,
    this.wishlistCount = 0,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavBar(
      currentIndex: currentIndex,
      onTap: onTap,
      items: [
        const BottomNavItem(
          icon: Icons.home_outlined,
          activeIcon: Icons.home_rounded,
          label: 'Home',
        ),
        const BottomNavItem(
          icon: Icons.category_outlined,
          activeIcon: Icons.category_rounded,
          label: 'Categories',
        ),
        BottomNavItem(
          icon: Icons.shopping_cart_outlined,
          activeIcon: Icons.shopping_cart_rounded,
          label: 'Cart',
          badgeCount: cartCount,
        ),
        BottomNavItem(
          icon: Icons.favorite_outline_rounded,
          activeIcon: Icons.favorite_rounded,
          label: 'Wishlist',
          badgeCount: wishlistCount,
        ),
        const BottomNavItem(
          icon: Icons.person_outline_rounded,
          activeIcon: Icons.person_rounded,
          label: 'Profile',
        ),
      ],
    );
  }
}
