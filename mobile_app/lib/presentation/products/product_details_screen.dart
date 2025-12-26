import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:toastification/toastification.dart';
import '../../core/theme/app_colors.dart';
import '../../features/product/presentation/providers/product_provider.dart';
import '../../features/cart/presentation/providers/cart_provider.dart';
import '../common/widgets/app_badge.dart';

class ProductDetailsScreen extends ConsumerStatefulWidget {
  final String id;

  const ProductDetailsScreen({super.key, required this.id});

  @override
  ConsumerState<ProductDetailsScreen> createState() =>
      _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends ConsumerState<ProductDetailsScreen> {
  int _quantity = 1;
  bool _isWishlisted = false;

  @override
  Widget build(BuildContext context) {
    final productAsync = ref.watch(productDetailsProvider(widget.id));
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? AppColors.darkBackground : Colors.white;
    final cardColor = isDark ? AppColors.darkCard : Colors.white;
    final textColor = isDark ? Colors.white : Colors.black87;

    return Scaffold(
      backgroundColor: bgColor,
      body: productAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
        data: (product) {
          if (product == null) {
            return const Center(child: Text('Product not found'));
          }
          final discount =
              product.compareAtPrice != null &&
                  product.compareAtPrice! > product.price
              ? ((product.compareAtPrice! - product.price) /
                        product.compareAtPrice! *
                        100)
                    .round()
              : 0;

          return Stack(
            children: [
              CustomScrollView(
                slivers: [
                  // Image Section with Hero Animation
                  SliverAppBar(
                    expandedHeight: MediaQuery.of(context).size.height * 0.45,
                    pinned: true,
                    backgroundColor: cardColor,
                    leading: Container(
                      margin: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: cardColor.withAlpha(230),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withAlpha(26),
                            blurRadius: 8,
                          ),
                        ],
                      ),
                      child: IconButton(
                        icon: Icon(LucideIcons.arrowLeft, color: textColor),
                        onPressed: () => context.pop(),
                      ),
                    ),
                    actions: [
                      Container(
                        margin: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: cardColor.withAlpha(230),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withAlpha(26),
                              blurRadius: 8,
                            ),
                          ],
                        ),
                        child: IconButton(
                          icon: Icon(
                            _isWishlisted
                                ? LucideIcons.heartHandshake
                                : LucideIcons.heart,
                            color: _isWishlisted ? Colors.red : textColor,
                          ),
                          onPressed: () =>
                              setState(() => _isWishlisted = !_isWishlisted),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(right: 8),
                        decoration: BoxDecoration(
                          color: cardColor.withAlpha(230),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withAlpha(26),
                              blurRadius: 8,
                            ),
                          ],
                        ),
                        child: IconButton(
                          icon: Icon(LucideIcons.share2, color: textColor),
                          onPressed: () {},
                        ),
                      ),
                    ],
                    flexibleSpace: FlexibleSpaceBar(
                      background: Stack(
                        fit: StackFit.expand,
                        children: [
                          if (product.featuredImage != null)
                            Hero(
                              tag: 'product-${product.id}',
                              child: CachedNetworkImage(
                                imageUrl: product.featuredImage!,
                                fit: BoxFit.cover,
                              ),
                            )
                          else
                            Container(color: Colors.grey[200]),
                          // Gradient overlay
                          Positioned(
                            bottom: 0,
                            left: 0,
                            right: 0,
                            height: 100,
                            child: Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.bottomCenter,
                                  end: Alignment.topCenter,
                                  colors: [bgColor, bgColor.withAlpha(0)],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Product Info Section
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Badges Row
                          Row(
                            children: [
                              if (product.categoryId != null)
                                AppBadge(
                                  label: product.categoryId!,
                                  backgroundColor: isDark
                                      ? AppColors.darkSecondary
                                      : AppColors.secondary,
                                  foregroundColor: textColor,
                                ),
                              const SizedBox(width: 8),
                              if (discount > 0)
                                AppBadge(
                                  label: "-$discount% OFF",
                                  backgroundColor: AppColors.destructive,
                                ),
                              const Spacer(),
                              // Rating
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.amber.withAlpha(26),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Row(
                                  children: [
                                    const Icon(
                                      LucideIcons.star,
                                      color: Colors.amber,
                                      size: 16,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      "4.8",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: textColor,
                                      ),
                                    ),
                                    Text(
                                      " (128)",
                                      style: TextStyle(
                                        color: isDark
                                            ? Colors.grey[400]
                                            : Colors.grey[600],
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ).animate().fadeIn().slideX(begin: -0.1),

                          const SizedBox(height: 16),

                          // Product Name
                          Text(
                            product.name,
                            style: Theme.of(context).textTheme.headlineSmall
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: textColor,
                                ),
                          ).animate().fadeIn(delay: 100.ms).slideX(begin: -0.1),

                          const SizedBox(height: 16),

                          // Price Row
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                "৳${product.price.toStringAsFixed(0)}",
                                style: Theme.of(context)
                                    .textTheme
                                    .headlineMedium
                                    ?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.primary,
                                    ),
                              ),
                              const SizedBox(width: 12),
                              if (product.compareAtPrice != null)
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 6),
                                  child: Text(
                                    "৳${product.compareAtPrice!.toStringAsFixed(0)}",
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium
                                        ?.copyWith(
                                          decoration:
                                              TextDecoration.lineThrough,
                                          color: isDark
                                              ? Colors.grey[400]
                                              : AppColors.mutedForeground,
                                        ),
                                  ),
                                ),
                              if (discount > 0) ...[
                                const Spacer(),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 6,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.green.withAlpha(26),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    "Save ৳${(product.compareAtPrice! - product.price).toStringAsFixed(0)}",
                                    style: const TextStyle(
                                      color: Colors.green,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                              ],
                            ],
                          ).animate().fadeIn(delay: 200.ms).slideX(begin: -0.1),

                          const SizedBox(height: 24),
                          Divider(
                            color: isDark ? Colors.grey[700] : Colors.grey[200],
                          ),
                          const SizedBox(height: 24),

                          // Quantity Selector
                          Text(
                            "Quantity",
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: textColor,
                                ),
                          ),
                          const SizedBox(height: 12),
                          Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: isDark
                                  ? AppColors.darkSecondary
                                  : Colors.grey[100],
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  onPressed: _quantity > 1
                                      ? () => setState(() => _quantity--)
                                      : null,
                                  icon: const Icon(LucideIcons.minus, size: 18),
                                  style: IconButton.styleFrom(
                                    backgroundColor: cardColor,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 20,
                                  ),
                                  child: Text(
                                    "$_quantity",
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: textColor,
                                    ),
                                  ),
                                ),
                                IconButton(
                                  onPressed: () => setState(() => _quantity++),
                                  icon: const Icon(LucideIcons.plus, size: 18),
                                  style: IconButton.styleFrom(
                                    backgroundColor: cardColor,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ).animate().fadeIn(delay: 300.ms),

                          const SizedBox(height: 24),
                          Divider(
                            color: isDark ? Colors.grey[700] : Colors.grey[200],
                          ),
                          const SizedBox(height: 24),

                          // Description
                          Text(
                            "Description",
                            style: Theme.of(context).textTheme.titleLarge
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: textColor,
                                ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            product.description ?? "No description available.",
                            style: Theme.of(context).textTheme.bodyLarge
                                ?.copyWith(
                                  color: isDark
                                      ? Colors.grey[400]
                                      : AppColors.mutedForeground,
                                  height: 1.6,
                                ),
                          ).animate().fadeIn(delay: 400.ms),

                          const SizedBox(height: 24),

                          // Features
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: isDark
                                  ? AppColors.darkSecondary
                                  : Colors.grey[50],
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: isDark
                                    ? Colors.grey[700]!
                                    : Colors.grey[200]!,
                              ),
                            ),
                            child: Column(
                              children: [
                                _buildFeatureRow(
                                  LucideIcons.truck,
                                  "Free shipping on orders over ৳500",
                                  isDark,
                                ),
                                const SizedBox(height: 12),
                                _buildFeatureRow(
                                  LucideIcons.rotateCcw,
                                  "7-day return policy",
                                  isDark,
                                ),
                                const SizedBox(height: 12),
                                _buildFeatureRow(
                                  LucideIcons.shield,
                                  "100% authentic products",
                                  isDark,
                                ),
                              ],
                            ),
                          ).animate().fadeIn(delay: 500.ms),

                          const SizedBox(height: 120),
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              // Bottom Action Bar
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  padding:
                      const EdgeInsets.all(16) +
                      EdgeInsets.only(
                        bottom: MediaQuery.of(context).padding.bottom,
                      ),
                  decoration: BoxDecoration(
                    color: cardColor,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withAlpha(26),
                        blurRadius: 20,
                        offset: const Offset(0, -4),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      // Add to Cart Button
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: AppColors.primary),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: IconButton(
                          onPressed: () {
                            for (var i = 0; i < _quantity; i++) {
                              ref
                                  .read(cartProvider.notifier)
                                  .addToCart(product);
                            }
                            toastification.show(
                              context: context,
                              type: ToastificationType.success,
                              style: ToastificationStyle.minimal,
                              title: const Text("Added to cart"),
                              description: Text("$_quantity × ${product.name}"),
                              autoCloseDuration: const Duration(seconds: 2),
                            );
                          },
                          icon: const Icon(
                            LucideIcons.shoppingCart,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      // Buy Now Button
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            for (var i = 0; i < _quantity; i++) {
                              ref
                                  .read(cartProvider.notifier)
                                  .addToCart(product);
                            }
                            context.push('/cart');
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            minimumSize: const Size(double.infinity, 56),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 0,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                "Buy Now",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                "৳${(product.price * _quantity).toStringAsFixed(0)}",
                                style: const TextStyle(
                                  fontSize: 16,
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
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildFeatureRow(IconData icon, String text, bool isDark) {
    return Row(
      children: [
        Icon(icon, size: 20, color: Colors.green),
        const SizedBox(width: 12),
        Text(
          text,
          style: TextStyle(color: isDark ? Colors.grey[300] : Colors.grey[700]),
        ),
      ],
    );
  }
}
