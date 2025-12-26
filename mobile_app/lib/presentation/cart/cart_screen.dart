import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:toastification/toastification.dart';

import '../../features/cart/domain/cart_item_model.dart';
import '../../features/cart/presentation/providers/cart_provider.dart';

class CartScreen extends ConsumerStatefulWidget {
  const CartScreen({super.key});

  @override
  ConsumerState<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends ConsumerState<CartScreen> {
  final _couponController = TextEditingController();
  String? _appliedCoupon;
  double _discountAmount = 0;

  // Saved for later items (mock data for now)
  final List<_SavedItem> _savedItems = [
    _SavedItem(
      name: 'Smart Watch Series 7',
      price: 399.00,
      imageUrl:
          'https://lh3.googleusercontent.com/aida-public/AB6AXuDdI-lCrVaxhcXYU7IJ6SEwYO0JZdFMHgY1m-C4vaJwPJZzGeWYKZdaL4Xo2O3UzffCyl-WpQdIkUI-gNlwYujSF5Q8PYqAuC9ndgxMZ1YUcd8IPjF43grYBxxsyDX8tm-iWWuTcfvE600hAz2tT7_i6FljV8n3DlpFvWyjmt8zdSWucOf_gd1Ry4nR5_VvDJTq3k-CeDtk0NfImJyOvAOgQtucFYvAuNFvwiTVgrG4LFdOjOtNvTcJvsoIDYbA9IrM-tJK1pE6EoU',
    ),
  ];

  // Recommendation products (mock data)
  final List<_RecommendedProduct> _recommendations = [
    _RecommendedProduct(
      name: 'Laptop Sleeve',
      price: 29.99,
      imageUrl:
          'https://lh3.googleusercontent.com/aida-public/AB6AXuDrLZsRZeSMJ7V3UdKkp8k_9BIzJCe1TZNkVW9mBeEBKxnBs-IH9NxDzVOdlYQIG_yzOOKomEDGlloxwIIcC7p2ACWTT6-og4QiBk3KuXFynTkp7YUgkCZrtZjJk7fJIBK-RyRhHzX8JZTRxqZtJm2TSr1P3k8GlFwEnlYxRvTcCjXcVoKOT1fLKTxBJUmDAOHcGVk2DhT1nD9asA49NMMaPfme8Ow8kglh4T-tRF4FyBppMcPp3CogpzEUqQApkbrs-3dNx5l8Psc',
    ),
    _RecommendedProduct(
      name: 'Fast Charger',
      price: 45.00,
      imageUrl:
          'https://lh3.googleusercontent.com/aida-public/AB6AXuDBNGeCHger-x2r_0iw4ywGhbn-C2yxe_sbRiYlDaAtfeR4aH839sRovJVQ25Ao1prcBU4MvjjhEiTcqQcreznLEM8jDwytH8RaVffTjUsJlXM7LjYNogmxta-TUc2vPhD1gK_yroYEBtBykrDYHIBQ3yMstz8Ql9gQnM-pvrMKnE5-p2V1HB4_iyDYwyywzzHsKxi4Yq8JbqW7x8ArMPq9L-BNYFtdX0Ou9BID6PXGW8sS6potMuNUEQlAPR99rl0h_57WBBMn9eA',
    ),
    _RecommendedProduct(
      name: 'Pro Mouse',
      price: 89.00,
      imageUrl:
          'https://lh3.googleusercontent.com/aida-public/AB6AXuAAkRmbW7wXJJJTN7OG7AZw1SAbx1qmN9ot84OIZhiqulrQQLElngUKrcRh7mXblIycD4IqEFC1yXhzZ4FZC7n_VLYqtaXP2R9D-C0YBKjgFYymoUfyUr33oKqHPdJviBkKUE2tJU6MYtv1qWEyshKJKQcphFhe8ywVzGxXojDuYEqBxm_QBzV06MVxMOt-CQEPgqmFLV6r4SjHM3a6gKAUeKE889kSnO0JUXEbvjsyj939Yru5fCpEkoLbpKrGhwet_IhlUpKXwMY',
    ),
  ];

  @override
  void dispose() {
    _couponController.dispose();
    super.dispose();
  }

  void _applyCoupon() {
    final code = _couponController.text.trim().toUpperCase();
    if (code == 'SUMMER20' || code == 'SAVE10') {
      setState(() {
        _appliedCoupon = code;
        _discountAmount = code == 'SUMMER20' ? 15.0 : 10.0;
      });
      toastification.show(
        context: context,
        type: ToastificationType.success,
        title: const Text("Coupon applied!"),
        description: Text(
          "\$${_discountAmount.toStringAsFixed(0)} discount applied",
        ),
        autoCloseDuration: const Duration(seconds: 2),
      );
    } else {
      toastification.show(
        context: context,
        type: ToastificationType.error,
        title: const Text("Invalid coupon"),
        autoCloseDuration: const Duration(seconds: 2),
      );
    }
    _couponController.clear();
  }

  void _removeCoupon() {
    setState(() {
      _appliedCoupon = null;
      _discountAmount = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    final cartItems = ref.watch(cartProvider);
    final cartTotal = ref.watch(cartTotalProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Theme colors
    const primaryBlue = Color(0xFF135bec);
    final bgColor = isDark ? const Color(0xFF101622) : const Color(0xFFF6F6F8);
    final surfaceColor = isDark ? const Color(0xFF1E293B) : Colors.white;
    final textColor = isDark ? Colors.white : const Color(0xFF111827);
    final subtleTextColor = isDark ? Colors.grey[400]! : Colors.grey[500]!;
    final borderColor = isDark ? Colors.grey[800]! : Colors.grey[200]!;

    // Calculate totals
    final subtotal = cartTotal;
    final shipping = subtotal > 500 ? 0.0 : 60.0;
    final tax = (subtotal - _discountAmount) * 0.03; // ~3% tax
    final total = subtotal - _discountAmount + shipping + tax;
    final totalSavings = _discountAmount + (shipping == 0 ? 60 : 0);

    return Scaffold(
      backgroundColor: bgColor,
      body: cartItems.isEmpty
          ? _buildEmptyCart(context, isDark, textColor, primaryBlue)
          : Stack(
              children: [
                CustomScrollView(
                  slivers: [
                    // Sticky Header
                    SliverAppBar(
                      pinned: true,
                      backgroundColor: surfaceColor.withAlpha(242),
                      surfaceTintColor: Colors.transparent,
                      elevation: 0,
                      title: Row(
                        children: [
                          Text(
                            "My Cart",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: textColor,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            "(${cartItems.length})",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                              color: primaryBlue,
                            ),
                          ),
                        ],
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => _showClearCartDialog(
                            context,
                            ref,
                            surfaceColor,
                            textColor,
                            isDark,
                          ),
                          child: Text(
                            "Clear",
                            style: TextStyle(
                              color: subtleTextColor,
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ],
                      bottom: PreferredSize(
                        preferredSize: const Size.fromHeight(1),
                        child: Container(height: 1, color: borderColor),
                      ),
                    ),

                    // Free Shipping Banner
                    if (subtotal > 500)
                      SliverToBoxAdapter(
                        child: Container(
                          color: isDark
                              ? const Color(0xFF1E3A5F)
                              : const Color(0xFFEFF6FF),
                          padding: const EdgeInsets.symmetric(
                            vertical: 10,
                            horizontal: 16,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                LucideIcons.truck,
                                size: 16,
                                color: primaryBlue,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                "Free shipping on orders over \$500 unlocked!",
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  color: primaryBlue,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                    // Cart Items
                    SliverPadding(
                      padding: const EdgeInsets.all(16),
                      sliver: SliverList(
                        delegate: SliverChildBuilderDelegate((context, index) {
                          final item = cartItems[index];
                          return _buildCartItemCard(
                            context,
                            ref,
                            item,
                            index,
                            isDark,
                            surfaceColor,
                            textColor,
                            subtleTextColor,
                            borderColor,
                            primaryBlue,
                          );
                        }, childCount: cartItems.length),
                      ),
                    ),

                    // Saved for Later Section
                    if (_savedItems.isNotEmpty)
                      SliverToBoxAdapter(
                        child: _buildSavedForLaterSection(
                          isDark,
                          surfaceColor,
                          textColor,
                          subtleTextColor,
                          borderColor,
                          primaryBlue,
                        ),
                      ),

                    // Recommendations Section
                    SliverToBoxAdapter(
                      child: _buildRecommendationsSection(
                        isDark,
                        surfaceColor,
                        textColor,
                        subtleTextColor,
                        borderColor,
                        primaryBlue,
                      ),
                    ),

                    // Coupon Section
                    SliverToBoxAdapter(
                      child: _buildCouponSection(
                        isDark,
                        surfaceColor,
                        textColor,
                        subtleTextColor,
                        borderColor,
                        primaryBlue,
                      ),
                    ),

                    // Order Summary
                    SliverToBoxAdapter(
                      child: _buildOrderSummary(
                        subtotal,
                        _discountAmount,
                        shipping,
                        tax,
                        total,
                        totalSavings,
                        isDark,
                        surfaceColor,
                        textColor,
                        subtleTextColor,
                        borderColor,
                      ),
                    ),

                    // Bottom spacing for sticky footer
                    const SliverToBoxAdapter(child: SizedBox(height: 140)),
                  ],
                ),

                // Sticky Footer
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: _buildStickyFooter(
                    cartItems.length,
                    total,
                    isDark,
                    surfaceColor,
                    borderColor,
                    primaryBlue,
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildEmptyCart(
    BuildContext context,
    bool isDark,
    Color textColor,
    Color primaryBlue,
  ) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                color: primaryBlue.withAlpha(26),
                shape: BoxShape.circle,
              ),
              child: Icon(
                LucideIcons.shoppingCart,
                size: 64,
                color: primaryBlue,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              "Your cart is empty",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              "Looks like you haven't added anything to your cart yet",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: isDark ? Colors.grey[400] : Colors.grey[600],
                fontSize: 15,
              ),
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: () => context.go('/'),
              icon: const Icon(LucideIcons.shoppingBag),
              label: const Text("Start Shopping"),
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryBlue,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 16,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50),
                ),
              ),
            ),
          ],
        ).animate().fadeIn().scale(begin: const Offset(0.9, 0.9)),
      ),
    );
  }

  Widget _buildCartItemCard(
    BuildContext context,
    WidgetRef ref,
    CartItem item,
    int index,
    bool isDark,
    Color surfaceColor,
    Color textColor,
    Color subtleTextColor,
    Color borderColor,
    Color primaryBlue,
  ) {
    final hasDiscount =
        item.product.compareAtPrice != null &&
        item.product.compareAtPrice! > item.product.price;
    final isLowStock = item.product.stock <= 2;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderColor),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(8),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Product Image
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: item.product.featuredImage != null
                        ? CachedNetworkImage(
                            imageUrl: item.product.featuredImage!,
                            width: 96,
                            height: 96,
                            fit: BoxFit.cover,
                            placeholder: (context, url) => Container(
                              width: 96,
                              height: 96,
                              color: isDark
                                  ? Colors.grey[800]
                                  : Colors.grey[100],
                            ),
                          )
                        : Container(
                            width: 96,
                            height: 96,
                            color: isDark ? Colors.grey[800] : Colors.grey[100],
                            child: Icon(
                              LucideIcons.image,
                              color: subtleTextColor,
                            ),
                          ),
                  ),
                  // Price drop badge
                  if (hasDiscount)
                    Positioned(
                      top: 0,
                      left: 0,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: const BoxDecoration(
                          color: Color(0xFF22C55E),
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(8),
                            bottomRight: Radius.circular(8),
                          ),
                        ),
                        child: const Text(
                          "PRICE DROP",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 9,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(width: 12),
              // Product Details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            item.product.name,
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: textColor,
                              height: 1.3,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        // Delete button
                        GestureDetector(
                          onTap: () => ref
                              .read(cartProvider.notifier)
                              .removeFromCart(item.product.id),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 8),
                            child: Icon(
                              LucideIcons.trash2,
                              size: 18,
                              color: subtleTextColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "Default Variant",
                      style: TextStyle(fontSize: 12, color: subtleTextColor),
                    ),
                    if (isLowStock)
                      Padding(
                        padding: const EdgeInsets.only(top: 2),
                        child: Text(
                          "Only ${item.product.stock} left in stock",
                          style: const TextStyle(
                            fontSize: 12,
                            color: Color(0xFFEA580C),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    if (hasDiscount)
                      Padding(
                        padding: const EdgeInsets.only(top: 2),
                        child: Text(
                          "Price dropped by \$${(item.product.compareAtPrice! - item.product.price).toStringAsFixed(0)}",
                          style: const TextStyle(
                            fontSize: 12,
                            color: Color(0xFF16A34A),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Price
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (hasDiscount)
                              Text(
                                "\$${item.product.compareAtPrice!.toStringAsFixed(2)}",
                                style: TextStyle(
                                  fontSize: 12,
                                  color: subtleTextColor,
                                  decoration: TextDecoration.lineThrough,
                                ),
                              ),
                            Text(
                              "\$${item.product.price.toStringAsFixed(2)}",
                              style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                                color: textColor,
                              ),
                            ),
                          ],
                        ),
                        // Quantity Controls
                        Container(
                          padding: const EdgeInsets.all(2),
                          decoration: BoxDecoration(
                            color: isDark
                                ? Colors.grey[800]
                                : const Color(0xFFF9FAFB),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: borderColor),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              _buildQuantityButton(
                                icon: LucideIcons.minus,
                                onTap: () => ref
                                    .read(cartProvider.notifier)
                                    .decrementQuantity(item.product.id),
                                isDark: isDark,
                                surfaceColor: surfaceColor,
                                subtleTextColor: subtleTextColor,
                              ),
                              Container(
                                width: 32,
                                alignment: Alignment.center,
                                child: Text(
                                  "${item.quantity}",
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: textColor,
                                  ),
                                ),
                              ),
                              _buildQuantityButton(
                                icon: LucideIcons.plus,
                                onTap: () => ref
                                    .read(cartProvider.notifier)
                                    .addToCart(item.product),
                                isDark: isDark,
                                surfaceColor: surfaceColor,
                                primaryBlue: primaryBlue,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          // Actions row
          Container(
            margin: const EdgeInsets.only(top: 12),
            padding: const EdgeInsets.only(top: 8),
            decoration: BoxDecoration(
              border: Border(top: BorderSide(color: borderColor)),
            ),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () {
                    // Save for later functionality
                    toastification.show(
                      context: context,
                      type: ToastificationType.info,
                      title: const Text("Saved for later"),
                      autoCloseDuration: const Duration(seconds: 2),
                    );
                  },
                  child: Row(
                    children: [
                      Icon(LucideIcons.heart, size: 14, color: subtleTextColor),
                      const SizedBox(width: 6),
                      Text(
                        "Save for later",
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: subtleTextColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ).animate().fadeIn(delay: (index * 80).ms).slideX(begin: 0.05);
  }

  Widget _buildQuantityButton({
    required IconData icon,
    required VoidCallback onTap,
    required bool isDark,
    required Color surfaceColor,
    Color? subtleTextColor,
    Color? primaryBlue,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 28,
        height: 28,
        decoration: BoxDecoration(
          color: isDark ? Colors.grey[700] : Colors.white,
          borderRadius: BorderRadius.circular(6),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(10),
              blurRadius: 2,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Icon(icon, size: 14, color: primaryBlue ?? subtleTextColor),
      ),
    );
  }

  Widget _buildSavedForLaterSection(
    bool isDark,
    Color surfaceColor,
    Color textColor,
    Color subtleTextColor,
    Color borderColor,
    Color primaryBlue,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Container(
        decoration: BoxDecoration(
          color: surfaceColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: borderColor),
        ),
        child: Theme(
          data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
          child: ExpansionTile(
            tilePadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 4,
            ),
            childrenPadding: EdgeInsets.zero,
            backgroundColor: isDark
                ? Colors.grey[800]!.withAlpha(128)
                : const Color(0xFFF9FAFB),
            collapsedBackgroundColor: isDark
                ? Colors.grey[800]!.withAlpha(128)
                : const Color(0xFFF9FAFB),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            collapsedShape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            leading: Icon(
              LucideIcons.bookmark,
              size: 20,
              color: subtleTextColor,
            ),
            title: Text(
              "Saved for Later (${_savedItems.length})",
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border(top: BorderSide(color: borderColor)),
                ),
                child: Column(
                  children: _savedItems
                      .map(
                        (item) => _buildSavedItem(
                          item,
                          isDark,
                          textColor,
                          subtleTextColor,
                          primaryBlue,
                        ),
                      )
                      .toList(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSavedItem(
    _SavedItem item,
    bool isDark,
    Color textColor,
    Color subtleTextColor,
    Color primaryBlue,
  ) {
    return Row(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: CachedNetworkImage(
            imageUrl: item.imageUrl,
            width: 64,
            height: 64,
            fit: BoxFit.cover,
            placeholder: (context, url) => Container(
              width: 64,
              height: 64,
              color: isDark ? Colors.grey[800] : Colors.grey[100],
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                item.name,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                "\$${item.price.toStringAsFixed(2)}",
                style: TextStyle(fontSize: 12, color: subtleTextColor),
              ),
              const SizedBox(height: 8),
              GestureDetector(
                onTap: () {
                  toastification.show(
                    context: context,
                    type: ToastificationType.success,
                    title: const Text("Moved to cart"),
                    autoCloseDuration: const Duration(seconds: 2),
                  );
                },
                child: Text(
                  "Move to Cart",
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: primaryBlue,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildRecommendationsSection(
    bool isDark,
    Color surfaceColor,
    Color textColor,
    Color subtleTextColor,
    Color borderColor,
    Color primaryBlue,
  ) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, top: 16, bottom: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "You may also like",
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 215,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.only(right: 16),
              itemCount: _recommendations.length,
              separatorBuilder: (context, index) => const SizedBox(width: 12),
              itemBuilder: (context, index) {
                final product = _recommendations[index];
                return _buildRecommendationCard(
                  product,
                  isDark,
                  surfaceColor,
                  textColor,
                  subtleTextColor,
                  borderColor,
                  primaryBlue,
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecommendationCard(
    _RecommendedProduct product,
    bool isDark,
    Color surfaceColor,
    Color textColor,
    Color subtleTextColor,
    Color borderColor,
    Color primaryBlue,
  ) {
    return SizedBox(
      width: 144,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: CachedNetworkImage(
              imageUrl: product.imageUrl,
              width: 144,
              height: 120,
              fit: BoxFit.cover,
              placeholder: (context, url) => Container(
                width: 144,
                height: 120,
                color: isDark ? Colors.grey[800] : Colors.grey[100],
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            product.name,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: textColor,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          Text(
            "\$${product.price.toStringAsFixed(2)}",
            style: TextStyle(fontSize: 12, color: subtleTextColor),
          ),
          const SizedBox(height: 8),
          GestureDetector(
            onTap: () {
              toastification.show(
                context: context,
                type: ToastificationType.success,
                title: const Text("Added to cart"),
                autoCloseDuration: const Duration(seconds: 2),
              );
            },
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: primaryBlue),
              ),
              child: Text(
                "Add",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: primaryBlue,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCouponSection(
    bool isDark,
    Color surfaceColor,
    Color textColor,
    Color subtleTextColor,
    Color borderColor,
    Color primaryBlue,
  ) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: surfaceColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: borderColor),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(8),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Applied Coupon
            if (_appliedCoupon != null) ...[
              Container(
                padding: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: borderColor,
                      style: BorderStyle.solid,
                    ),
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: isDark
                            ? const Color(0xFF166534).withAlpha(77)
                            : const Color(0xFFDCFCE7),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        LucideIcons.tag,
                        size: 16,
                        color: Color(0xFF16A34A),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _appliedCoupon!,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: textColor,
                            ),
                          ),
                          Text(
                            "-\$${_discountAmount.toStringAsFixed(2)} saved",
                            style: const TextStyle(
                              fontSize: 12,
                              color: Color(0xFF16A34A),
                            ),
                          ),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: _removeCoupon,
                      child: const Text(
                        "Remove",
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFFEF4444),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
            ],
            // Input for new coupon
            Text(
              _appliedCoupon != null
                  ? "Have another code?"
                  : "Have a promo code?",
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: subtleTextColor,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: isDark
                          ? const Color(0xFF0F172A)
                          : const Color(0xFFF9FAFB),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: borderColor),
                    ),
                    child: TextField(
                      controller: _couponController,
                      style: TextStyle(fontSize: 14, color: textColor),
                      decoration: InputDecoration(
                        hintText: "Enter promo code",
                        hintStyle: TextStyle(
                          color: subtleTextColor,
                          fontSize: 14,
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 12,
                        ),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: _applyCoupon,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: isDark
                          ? Colors.grey[700]
                          : const Color(0xFF111827),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text(
                      "Apply",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderSummary(
    double subtotal,
    double discount,
    double shipping,
    double tax,
    double total,
    double totalSavings,
    bool isDark,
    Color surfaceColor,
    Color textColor,
    Color subtleTextColor,
    Color borderColor,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: surfaceColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: borderColor),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(8),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Order Summary",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
            const SizedBox(height: 16),
            _buildSummaryRow(
              "Subtotal",
              "\$${subtotal.toStringAsFixed(2)}",
              textColor,
              subtleTextColor,
            ),
            const SizedBox(height: 12),
            if (discount > 0) ...[
              _buildSummaryRow(
                "Discount",
                "-\$${discount.toStringAsFixed(2)}",
                const Color(0xFF16A34A),
                subtleTextColor,
                isHighlight: true,
              ),
              const SizedBox(height: 12),
            ],
            _buildSummaryRow(
              "Shipping",
              shipping == 0 ? "Free" : "\$${shipping.toStringAsFixed(2)}",
              textColor,
              subtleTextColor,
            ),
            const SizedBox(height: 12),
            _buildSummaryRow(
              "Tax (Estimated)",
              "\$${tax.toStringAsFixed(2)}",
              textColor,
              subtleTextColor,
            ),
            Container(
              margin: const EdgeInsets.symmetric(vertical: 16),
              height: 1,
              color: borderColor,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Total Amount",
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                ),
                Text(
                  "\$${total.toStringAsFixed(2)}",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: textColor,
                  ),
                ),
              ],
            ),
            if (totalSavings > 0)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    "You are saving \$${totalSavings.toStringAsFixed(2)} on this order!",
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF16A34A),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryRow(
    String label,
    String value,
    Color valueColor,
    Color labelColor, {
    bool isHighlight = false,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: TextStyle(fontSize: 14, color: labelColor)),
        Text(
          value,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: valueColor,
          ),
        ),
      ],
    );
  }

  Widget _buildStickyFooter(
    int itemCount,
    double total,
    bool isDark,
    Color surfaceColor,
    Color borderColor,
    Color primaryBlue,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: surfaceColor,
        border: Border(top: BorderSide(color: borderColor)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(13),
            blurRadius: 6,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            GestureDetector(
              onTap: () => context.push('/checkout'),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 16,
                ),
                decoration: BoxDecoration(
                  color: primaryBlue,
                  borderRadius: BorderRadius.circular(50),
                  boxShadow: [
                    BoxShadow(
                      color: primaryBlue.withAlpha(77),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Checkout",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.only(right: 12),
                          margin: const EdgeInsets.only(right: 8),
                          decoration: const BoxDecoration(
                            border: Border(
                              right: BorderSide(color: Colors.white24),
                            ),
                          ),
                          child: Text(
                            "$itemCount items",
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.white.withAlpha(204),
                            ),
                          ),
                        ),
                        Text(
                          "\$${total.toStringAsFixed(2)}",
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Icon(
                          LucideIcons.arrowRight,
                          size: 18,
                          color: Colors.white,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  LucideIcons.lock,
                  size: 12,
                  color: isDark ? Colors.grey[500] : Colors.grey[400],
                ),
                const SizedBox(width: 6),
                Text(
                  "SECURE CHECKOUT",
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 1,
                    color: isDark ? Colors.grey[500] : Colors.grey[400],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showClearCartDialog(
    BuildContext context,
    WidgetRef ref,
    Color cardColor,
    Color textColor,
    bool isDark,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: cardColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text("Clear Cart", style: TextStyle(color: textColor)),
        content: Text(
          "Are you sure you want to remove all items?",
          style: TextStyle(color: isDark ? Colors.grey[400] : Colors.grey[600]),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              ref.read(cartProvider.notifier).clearCart();
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text("Clear"),
          ),
        ],
      ),
    );
  }
}

// Helper classes for mock data
class _SavedItem {
  final String name;
  final double price;
  final String imageUrl;

  _SavedItem({required this.name, required this.price, required this.imageUrl});
}

class _RecommendedProduct {
  final String name;
  final double price;
  final String imageUrl;

  _RecommendedProduct({
    required this.name,
    required this.price,
    required this.imageUrl,
  });
}
