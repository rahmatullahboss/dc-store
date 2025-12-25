import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../core/theme/app_colors.dart';
import 'app_badge.dart';
import 'shimmer_loading.dart';

class ProductCard extends StatefulWidget {
  final String id;
  final String name;
  final double price;
  final double? compareAtPrice;
  final String? imageUrl;
  final String? category;
  final bool isFeatured;
  final VoidCallback? onAddToCart;
  final VoidCallback? onOrderNow;
  final bool isWishlisted;
  final VoidCallback? onWishlistToggle;

  const ProductCard({
    super.key,
    required this.id,
    required this.name,
    required this.price,
    this.compareAtPrice,
    this.imageUrl,
    this.category,
    this.isFeatured = false,
    this.onAddToCart,
    this.onOrderNow,
    this.isWishlisted = false,
    this.onWishlistToggle,
  });

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.03,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final discount =
        widget.compareAtPrice != null && widget.compareAtPrice! > widget.price
        ? ((widget.compareAtPrice! - widget.price) /
                  widget.compareAtPrice! *
                  100)
              .round()
        : 0;

    return MouseRegion(
      onEnter: (_) {
        setState(() => _isHovered = true);
        _controller.forward();
      },
      onExit: (_) {
        setState(() => _isHovered = false);
        _controller.reverse();
      },
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(scale: _scaleAnimation.value, child: child);
        },
        child: GestureDetector(
          onTap: () => context.push('/products/${widget.id}'),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: _isHovered
                    ? AppColors.primary.withOpacity(0.3)
                    : AppColors.border,
              ),
              boxShadow: [
                BoxShadow(
                  color: _isHovered
                      ? AppColors.primary.withOpacity(0.1)
                      : Colors.black.withOpacity(0.05),
                  blurRadius: _isHovered ? 20 : 10,
                  offset: Offset(0, _isHovered ? 8 : 4),
                ),
              ],
            ),
            clipBehavior: Clip.antiAlias,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Image Section
                Expanded(
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      if (widget.imageUrl != null)
                        CachedNetworkImage(
                          imageUrl: widget.imageUrl!,
                          fit: BoxFit.cover,
                          placeholder: (context, url) => const ShimmerLoading(
                            width: double.infinity,
                            height: double.infinity,
                          ),
                          errorWidget: (context, url, error) => Container(
                            color: Colors.grey[100],
                            child: const Icon(
                              LucideIcons.image,
                              color: Colors.grey,
                            ),
                          ),
                        )
                      else
                        Container(
                          color: Colors.grey[100],
                          child: const Center(
                            child: Icon(
                              LucideIcons.shoppingBag,
                              size: 40,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      // Wishlist Button
                      Positioned(
                        top: 8,
                        right: 8,
                        child: GestureDetector(
                          onTap: widget.onWishlistToggle,
                          child: Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 8,
                                ),
                              ],
                            ),
                            child: Icon(
                              widget.isWishlisted
                                  ? LucideIcons.heartHandshake
                                  : LucideIcons.heart,
                              size: 18,
                              color: widget.isWishlisted
                                  ? Colors.red
                                  : Colors.grey[600],
                            ),
                          ),
                        ),
                      ),
                      // Discount Badge
                      if (discount > 0)
                        Positioned(
                          top: 8,
                          left: 8,
                          child: AppBadge(
                            label: "-$discount%",
                            backgroundColor: AppColors.destructive,
                          ),
                        ),
                      // Category Badge
                      if (widget.category != null && discount == 0)
                        Positioned(
                          top: 8,
                          left: 8,
                          child: AppBadge(
                            label: widget.category!,
                            backgroundColor: Colors.white.withOpacity(0.9),
                            foregroundColor: Colors.black87,
                          ),
                        ),
                      // Featured Badge
                      if (widget.isFeatured)
                        Positioned(
                          bottom: 8,
                          left: 8,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [Color(0xFFFFD700), Color(0xFFDAA520)],
                              ),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  LucideIcons.star,
                                  size: 12,
                                  color: Colors.white,
                                ),
                                SizedBox(width: 4),
                                Text(
                                  'Featured',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                // Details Section
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                          color: Colors.black87,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),
                      // Price Row
                      Row(
                        children: [
                          Text(
                            "৳${widget.price.toStringAsFixed(0)}",
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Colors.black,
                            ),
                          ),
                          if (widget.compareAtPrice != null) ...[
                            const SizedBox(width: 6),
                            Text(
                              "৳${widget.compareAtPrice!.toStringAsFixed(0)}",
                              style: TextStyle(
                                decoration: TextDecoration.lineThrough,
                                color: Colors.grey[500],
                                fontSize: 12,
                              ),
                            ),
                          ],
                          const Spacer(),
                          // Quick Add Button
                          GestureDetector(
                            onTap: widget.onAddToCart,
                            child: Container(
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: AppColors.primary.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Icon(
                                LucideIcons.plus,
                                size: 18,
                                color: AppColors.primary,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      // Order Now Button
                      SizedBox(
                        width: double.infinity,
                        height: 34,
                        child: ElevatedButton(
                          onPressed: widget.onOrderNow,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: Colors.white,
                            padding: EdgeInsets.zero,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            elevation: 0,
                          ),
                          child: const Text(
                            "Order Now",
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
