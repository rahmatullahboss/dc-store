import 'package:flutter/material.dart';
import 'package:dc_store/core/theme/app_colors.dart';
import 'package:dc_store/core/theme/app_text_styles.dart';
import '../feedback/loading_shimmer.dart';

/// Enum for CategoryCard sizes
enum CategoryCardSize { small, medium, large }

/// CategoryCard - Displays category with image, name, and product count
///
/// Example usage:
/// ```dart
/// CategoryCard(
///   name: 'Electronics',
///   imageUrl: 'https://...',
///   productCount: 156,
///   onTap: () => navigateToCategory('electronics'),
/// )
/// ```
class CategoryCard extends StatelessWidget {
  /// Category name
  final String name;

  /// Category image URL
  final String? imageUrl;

  /// Icon to display if no image
  final IconData? icon;

  /// Number of products in category
  final int? productCount;

  /// Card size
  final CategoryCardSize size;

  /// Whether to use icon style (no image, centered icon)
  final bool iconStyle;

  /// Background color (for icon style)
  final Color? backgroundColor;

  /// Icon color (for icon style)
  final Color? iconColor;

  /// Callback when card is tapped
  final VoidCallback? onTap;

  const CategoryCard({
    super.key,
    required this.name,
    this.imageUrl,
    this.icon,
    this.productCount,
    this.size = CategoryCardSize.medium,
    this.iconStyle = false,
    this.backgroundColor,
    this.iconColor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    if (iconStyle) {
      return _buildIconStyle(context);
    }
    return _buildImageStyle(context);
  }

  Widget _buildImageStyle(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: _getCardWidth(),
        height: _getCardHeight(),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(_getBorderRadius()),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.08),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Background image
            ClipRRect(
              borderRadius: BorderRadius.circular(_getBorderRadius()),
              child: _buildImage(),
            ),

            // Gradient overlay
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(_getBorderRadius()),
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withValues(alpha: 0.7),
                  ],
                  stops: const [0.4, 1.0],
                ),
              ),
            ),

            // Content
            Positioned(
              left: _getContentPadding(),
              right: _getContentPadding(),
              bottom: _getContentPadding(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    name,
                    style: _getNameStyle().copyWith(color: Colors.white),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (productCount != null) ...[
                    const SizedBox(height: 2),
                    Text(
                      '$productCount products',
                      style: _getCountStyle().copyWith(
                        color: Colors.white.withValues(alpha: 0.8),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIconStyle(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor =
        backgroundColor ?? (isDark ? AppColors.darkSurface : AppColors.surface);
    final fgColor = iconColor ?? AppColors.primary;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: _getCardWidth(),
        padding: EdgeInsets.all(_getContentPadding()),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(_getBorderRadius()),
          border: Border.all(
            color: isDark ? AppColors.darkBorder : AppColors.border,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Icon container
            Container(
              width: _getIconContainerSize(),
              height: _getIconContainerSize(),
              decoration: BoxDecoration(
                color: fgColor.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: Icon(
                icon ?? Icons.category_outlined,
                size: _getIconSize(),
                color: fgColor,
              ),
            ),
            SizedBox(height: _getContentPadding()),

            // Name
            Text(
              name,
              style: _getNameStyle().copyWith(
                color: isDark
                    ? AppColors.darkTextPrimary
                    : AppColors.textPrimary,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
            ),

            // Count
            if (productCount != null) ...[
              const SizedBox(height: 2),
              Text(
                '$productCount items',
                style: _getCountStyle().copyWith(
                  color: isDark
                      ? AppColors.darkTextSecondary
                      : AppColors.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildImage() {
    if (imageUrl == null || imageUrl!.isEmpty) {
      return Container(
        color: AppColors.muted,
        alignment: Alignment.center,
        child: Icon(
          icon ?? Icons.category_outlined,
          size: _getIconSize(),
          color: AppColors.textHint,
        ),
      );
    }

    return Image.network(
      imageUrl!,
      fit: BoxFit.cover,
      errorBuilder: (_, __, ___) => Container(
        color: AppColors.muted,
        alignment: Alignment.center,
        child: Icon(
          Icons.broken_image_outlined,
          size: _getIconSize(),
          color: AppColors.textHint,
        ),
      ),
    );
  }

  double _getCardWidth() {
    switch (size) {
      case CategoryCardSize.small:
        return 100;
      case CategoryCardSize.medium:
        return 140;
      case CategoryCardSize.large:
        return 180;
    }
  }

  double _getCardHeight() {
    switch (size) {
      case CategoryCardSize.small:
        return 100;
      case CategoryCardSize.medium:
        return 140;
      case CategoryCardSize.large:
        return 180;
    }
  }

  double _getBorderRadius() {
    switch (size) {
      case CategoryCardSize.small:
        return 8;
      case CategoryCardSize.medium:
        return 12;
      case CategoryCardSize.large:
        return 16;
    }
  }

  double _getContentPadding() {
    switch (size) {
      case CategoryCardSize.small:
        return 8;
      case CategoryCardSize.medium:
        return 12;
      case CategoryCardSize.large:
        return 16;
    }
  }

  double _getIconContainerSize() {
    switch (size) {
      case CategoryCardSize.small:
        return 40;
      case CategoryCardSize.medium:
        return 56;
      case CategoryCardSize.large:
        return 72;
    }
  }

  double _getIconSize() {
    switch (size) {
      case CategoryCardSize.small:
        return 20;
      case CategoryCardSize.medium:
        return 28;
      case CategoryCardSize.large:
        return 36;
    }
  }

  TextStyle _getNameStyle() {
    switch (size) {
      case CategoryCardSize.small:
        return AppTextStyles.labelSmall;
      case CategoryCardSize.medium:
        return AppTextStyles.labelMedium;
      case CategoryCardSize.large:
        return AppTextStyles.labelLarge;
    }
  }

  TextStyle _getCountStyle() {
    switch (size) {
      case CategoryCardSize.small:
        return AppTextStyles.overline;
      case CategoryCardSize.medium:
        return AppTextStyles.caption;
      case CategoryCardSize.large:
        return AppTextStyles.bodySmall;
    }
  }

  /// Creates a skeleton loading version
  static Widget skeleton({
    CategoryCardSize size = CategoryCardSize.medium,
    bool iconStyle = false,
  }) {
    return CategoryCardSkeleton(size: size, iconStyle: iconStyle);
  }
}

/// Skeleton loading state for CategoryCard
class CategoryCardSkeleton extends StatelessWidget {
  final CategoryCardSize size;
  final bool iconStyle;

  const CategoryCardSkeleton({
    super.key,
    this.size = CategoryCardSize.medium,
    this.iconStyle = false,
  });

  @override
  Widget build(BuildContext context) {
    final width = _getCardWidth();
    final height = iconStyle ? null : _getCardHeight();

    return ShimmerBox(
      width: width,
      height: height ?? width,
      borderRadius: BorderRadius.all(Radius.circular(_getBorderRadius())),
    );
  }

  double _getCardWidth() {
    switch (size) {
      case CategoryCardSize.small:
        return 100;
      case CategoryCardSize.medium:
        return 140;
      case CategoryCardSize.large:
        return 180;
    }
  }

  double _getCardHeight() {
    switch (size) {
      case CategoryCardSize.small:
        return 100;
      case CategoryCardSize.medium:
        return 140;
      case CategoryCardSize.large:
        return 180;
    }
  }

  double _getBorderRadius() {
    switch (size) {
      case CategoryCardSize.small:
        return 8;
      case CategoryCardSize.medium:
        return 12;
      case CategoryCardSize.large:
        return 16;
    }
  }
}

/// Horizontal scrollable category list
class CategoryList extends StatelessWidget {
  final List<CategoryCard> categories;
  final EdgeInsetsGeometry? padding;
  final double spacing;

  const CategoryList({
    super.key,
    required this.categories,
    this.padding,
    this.spacing = 12,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 140,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: padding ?? const EdgeInsets.symmetric(horizontal: 16),
        itemCount: categories.length,
        separatorBuilder: (_, __) => SizedBox(width: spacing),
        itemBuilder: (_, index) => categories[index],
      ),
    );
  }
}
