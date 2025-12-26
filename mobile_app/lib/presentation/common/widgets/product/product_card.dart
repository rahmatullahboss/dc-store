import 'package:flutter/material.dart';
import 'package:dc_store/core/theme/app_colors.dart';
import 'package:dc_store/core/theme/app_text_styles.dart';
import '../product/price_widget.dart';
import '../rating/rating_widget.dart';
import '../feedback/loading_shimmer.dart';

/// Enum for ProductCard display variants
enum ProductCardVariant { grid, list, horizontal }

/// ProductCard - Versatile product display component
///
/// Supports multiple layouts: grid, list, and horizontal (cart-style).
///
/// Example usage:
/// ```dart
/// ProductCard(
///   id: product.id,
///   name: product.name,
///   price: product.price,
///   imageUrl: product.image,
///   onTap: () => navigateToProduct(product.id),
///   onAddToCart: () => addToCart(product.id),
/// )
/// ```
class ProductCard extends StatelessWidget {
  /// Product ID
  final String id;

  /// Product name
  final String name;

  /// Current price
  final double price;

  /// Original price (for discount display)
  final double? originalPrice;

  /// Product image URL
  final String? imageUrl;

  /// Product rating
  final double? rating;

  /// Number of reviews
  final int? reviewCount;

  /// Card variant
  final ProductCardVariant variant;

  /// Whether product is in wishlist
  final bool isInWishlist;

  /// Callback when card is tapped
  final VoidCallback? onTap;

  /// Callback for wishlist toggle
  final VoidCallback? onWishlistToggle;

  /// Callback for quick add to cart
  final VoidCallback? onAddToCart;

  /// Badge text (e.g., "New", "Sale")
  final String? badge;

  /// Badge color
  final Color? badgeColor;

  /// Whether product is out of stock
  final bool isOutOfStock;

  /// Currency symbol
  final String currency;

  const ProductCard({
    super.key,
    required this.id,
    required this.name,
    required this.price,
    this.originalPrice,
    this.imageUrl,
    this.rating,
    this.reviewCount,
    this.variant = ProductCardVariant.grid,
    this.isInWishlist = false,
    this.onTap,
    this.onWishlistToggle,
    this.onAddToCart,
    this.badge,
    this.badgeColor,
    this.isOutOfStock = false,
    this.currency = '৳',
  });

  @override
  Widget build(BuildContext context) {
    switch (variant) {
      case ProductCardVariant.grid:
        return _buildGridCard(context);
      case ProductCardVariant.list:
        return _buildListCard(context);
      case ProductCardVariant.horizontal:
        return _buildHorizontalCard(context);
    }
  }

  Widget _buildGridCard(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkCard : AppColors.card,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.08),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image section
            _buildImageSection(context, aspectRatio: 1.0),

            // Content section
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Name
                  Text(
                    name,
                    style: AppTextStyles.labelMedium.copyWith(
                      color: isDark
                          ? AppColors.darkTextPrimary
                          : AppColors.textPrimary,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),

                  // Rating
                  if (rating != null) ...[
                    RatingSummary(
                      rating: rating!,
                      reviewCount: reviewCount ?? 0,
                    ),
                    const SizedBox(height: 8),
                  ],

                  // Price
                  PriceWidget(
                    price: price,
                    originalPrice: originalPrice,
                    currency: currency,
                    size: PriceSize.small,
                  ),

                  // Add to cart button
                  if (onAddToCart != null && !isOutOfStock) ...[
                    const SizedBox(height: 8),
                    _buildAddToCartButton(context, compact: true),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildListCard(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkCard : AppColors.card,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.08),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            // Image
            SizedBox(
              width: 100,
              height: 100,
              child: _buildImageSection(context, showWishlist: false),
            ),
            const SizedBox(width: 12),

            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Name
                  Text(
                    name,
                    style: AppTextStyles.labelLarge.copyWith(
                      color: isDark
                          ? AppColors.darkTextPrimary
                          : AppColors.textPrimary,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),

                  // Rating
                  if (rating != null) ...[
                    RatingSummary(
                      rating: rating!,
                      reviewCount: reviewCount ?? 0,
                    ),
                    const SizedBox(height: 8),
                  ],

                  // Price and actions row
                  Row(
                    children: [
                      Expanded(
                        child: PriceWidget(
                          price: price,
                          originalPrice: originalPrice,
                          currency: currency,
                          size: PriceSize.medium,
                        ),
                      ),
                      if (onWishlistToggle != null)
                        _buildWishlistButton(isDark),
                      if (onAddToCart != null && !isOutOfStock) ...[
                        const SizedBox(width: 8),
                        _buildAddToCartButton(context, compact: true),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHorizontalCard(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : AppColors.card,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.border,
        ),
      ),
      child: Row(
        children: [
          // Image
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: SizedBox(width: 80, height: 80, child: _buildImage()),
          ),
          const SizedBox(width: 12),

          // Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: AppTextStyles.labelMedium.copyWith(
                    color: isDark
                        ? AppColors.darkTextPrimary
                        : AppColors.textPrimary,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                PriceWidget(
                  price: price,
                  originalPrice: originalPrice,
                  currency: currency,
                  size: PriceSize.small,
                ),
              ],
            ),
          ),

          // Actions
          Column(
            children: [
              if (onWishlistToggle != null)
                _buildWishlistButton(isDark, size: 20),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildImageSection(
    BuildContext context, {
    double aspectRatio = 1.0,
    bool showWishlist = true,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return AspectRatio(
      aspectRatio: aspectRatio,
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Image
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            child: _buildImage(),
          ),

          // Out of stock overlay
          if (isOutOfStock)
            Container(
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.5),
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(12),
                ),
              ),
              alignment: Alignment.center,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: AppColors.error,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  'Out of Stock',
                  style: AppTextStyles.labelSmall.copyWith(color: Colors.white),
                ),
              ),
            ),

          // Badge
          if (badge != null && !isOutOfStock)
            Positioned(
              top: 8,
              left: 8,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: badgeColor ?? AppColors.error,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  badge!,
                  style: AppTextStyles.overline.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),

          // Wishlist button
          if (showWishlist && onWishlistToggle != null)
            Positioned(top: 8, right: 8, child: _buildWishlistButton(isDark)),
        ],
      ),
    );
  }

  Widget _buildImage() {
    if (imageUrl == null || imageUrl!.isEmpty) {
      return Container(
        color: AppColors.muted,
        alignment: Alignment.center,
        child: Icon(Icons.image_outlined, size: 40, color: AppColors.textHint),
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
          size: 40,
          color: AppColors.textHint,
        ),
      ),
    );
  }

  Widget _buildWishlistButton(bool isDark, {double size = 24}) {
    return GestureDetector(
      onTap: onWishlistToggle,
      child: Container(
        width: size + 12,
        height: size + 12,
        decoration: BoxDecoration(
          color: (isDark ? AppColors.darkCard : AppColors.card).withValues(
            alpha: 0.9,
          ),
          shape: BoxShape.circle,
        ),
        alignment: Alignment.center,
        child: Icon(
          isInWishlist
              ? Icons.favorite_rounded
              : Icons.favorite_outline_rounded,
          size: size,
          color: isInWishlist
              ? AppColors.error
              : (isDark
                    ? AppColors.darkTextSecondary
                    : AppColors.textSecondary),
        ),
      ),
    );
  }

  Widget _buildAddToCartButton(BuildContext context, {bool compact = false}) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    if (compact) {
      return GestureDetector(
        onTap: onAddToCart,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkPrimary : AppColors.primary,
            borderRadius: BorderRadius.circular(6),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.add_shopping_cart_rounded,
                size: 14,
                color: isDark
                    ? AppColors.darkPrimaryForeground
                    : AppColors.primaryForeground,
              ),
              const SizedBox(width: 4),
              Text(
                'Add',
                style: AppTextStyles.buttonSmall.copyWith(
                  color: isDark
                      ? AppColors.darkPrimaryForeground
                      : AppColors.primaryForeground,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: onAddToCart,
        icon: const Icon(Icons.add_shopping_cart_rounded, size: 18),
        label: const Text('Add to Cart'),
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 10),
        ),
      ),
    );
  }

  /// Creates a skeleton loading version of the card
  static Widget skeleton({
    ProductCardVariant variant = ProductCardVariant.grid,
  }) {
    return ProductCardSkeleton(variant: variant);
  }
}

/// Skeleton loading state for ProductCard
class ProductCardSkeleton extends StatelessWidget {
  final ProductCardVariant variant;

  const ProductCardSkeleton({
    super.key,
    this.variant = ProductCardVariant.grid,
  });

  @override
  Widget build(BuildContext context) {
    switch (variant) {
      case ProductCardVariant.grid:
        return _buildGridSkeleton(context);
      case ProductCardVariant.list:
        return _buildListSkeleton(context);
      case ProductCardVariant.horizontal:
        return _buildHorizontalSkeleton(context);
    }
  }

  Widget _buildGridSkeleton(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : AppColors.card,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const AspectRatio(
            aspectRatio: 1.0,
            child: ShimmerBox(
              borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                ShimmerBox(height: 14, width: double.infinity),
                SizedBox(height: 8),
                ShimmerBox(height: 14, width: 100),
                SizedBox(height: 8),
                ShimmerBox(height: 18, width: 80),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildListSkeleton(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : AppColors.card,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          const ShimmerBox(
            width: 100,
            height: 100,
            borderRadius: BorderRadius.all(Radius.circular(8)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                ShimmerBox(height: 16, width: double.infinity),
                SizedBox(height: 8),
                ShimmerBox(height: 14, width: 80),
                SizedBox(height: 8),
                ShimmerBox(height: 20, width: 100),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHorizontalSkeleton(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : AppColors.card,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.border,
        ),
      ),
      child: Row(
        children: [
          const ShimmerBox(
            width: 80,
            height: 80,
            borderRadius: BorderRadius.all(Radius.circular(8)),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ShimmerBox(height: 14, width: double.infinity),
                SizedBox(height: 6),
                ShimmerBox(height: 14, width: 80),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
