import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:toastification/toastification.dart';
import '../../core/config/white_label_config.dart';

class WishlistScreen extends StatefulWidget {
  const WishlistScreen({super.key});

  @override
  State<WishlistScreen> createState() => _WishlistScreenState();
}

class _WishlistScreenState extends State<WishlistScreen> {
  String _selectedCollection = 'All Items';

  final List<String> _collections = ['All Items', 'Holiday Gifts', 'Tech'];

  // Mock wishlist items
  final List<_WishlistItem> _wishlistItems = [
    _WishlistItem(
      id: '1',
      name: 'Urban Runner X1',
      price: 120.00,
      imageUrl:
          'https://lh3.googleusercontent.com/aida-public/AB6AXuD8iZyEbXGJ0qqjkDMkzl4YIPZDljXapsTH0b9uVLy4JvfcNhb23y2DlfUbXzj3xek0dxvNqot9MAOL05GAPgBZZxUwy82OKyRRolUdBnU2Q2ULI_heqpaAxDoGxBhf82dpZFAKXS3mykGrU-Cu3GrEQWuuQJ9KSratqxgg3criZDdfFMHZrQRqy1HlneIBw0POIdCSSflAUGgucuobkycflR11og7elSghHECFG9_bwX4lJBRpONc4nabcz9vlWKBvTF_r2hmjltE',
      isInStock: true,
    ),
    _WishlistItem(
      id: '2',
      name: 'Noise Cancel Pro',
      price: 299.00,
      imageUrl:
          'https://lh3.googleusercontent.com/aida-public/AB6AXuDXuH-MhK05lBrjn45maN52YBHX7rwDswV31fCZBny-UnwZGtfPBkMvwZ8EyTp92ibKmVY3qyONngLOnHDn93EpkdD2-ca5HCR_KVu3-y2oDz3HcuOQgr7CacYMcuKSgNAKYIckYGbT3txP54H3x9IwdZBbVhIV9fnS92TC9EoquQcIJ4Fz6rI1jeUc9bpcZrxh3F0rYTDxM1OUhTwepa3uh267q4UcAVOsmxIYORkDrww1CPVPwty1GSgAODDAXPW-U3UYBjN9KvM',
      isInStock: false,
    ),
    _WishlistItem(
      id: '3',
      name: 'Classic Chrono S',
      price: 140.00,
      originalPrice: 175.00,
      imageUrl:
          'https://lh3.googleusercontent.com/aida-public/AB6AXuCxpzdS3eKNvdo_gcH5QAmRjUil7wBH73DWek7Bh753lsaVh2sCAqYOfnHzDlwPLA8bGdGpyThC_w-se5a6ZCUfPF1hTXKrOhKtNkm-NVJCWMpudLlyQdKUlqYqYEMFNNJXTQfMFYj9qZMY0i4US8MacedHzAsrg2seNjw9VaA3rAaKIu_Az1j4Sc2MiwMPHcz8tutoWeRuNyJhpaobI79myQNjmqBeyxdgpJIxItHcwHm5m_gQAhyayvO1P87yK5kHFlHRNnhEwzE',
      isInStock: true,
      discountPercent: 20,
    ),
    _WishlistItem(
      id: '4',
      name: 'Traveler Backpack',
      price: 85.00,
      imageUrl:
          'https://lh3.googleusercontent.com/aida-public/AB6AXuD3xCYyupX6mU4IxWiOK8OeH4tL4stj6DQh33cSA14TjaX6orTFv4mZNdnWt_FXua3A313eG-9QXV26i9J1eyMG0tTvw5ndVumpc4bO9mPr1xRMFnbZFONwvt-nO9jboec9dSKvH-k8m0K9fGTcFwVZX3QqXFne1d9e_RYco3k1hcryGVuXDf5a-QJcYeYua0qHn_jkHygYX87_kEXYeaEes-oBMAhUpLEW9IM6U9Ue6iMFkz5Vc5jZJyQ5OvBZ8aCLqSEGUhxXwHA',
      isInStock: true,
    ),
    _WishlistItem(
      id: '5',
      name: 'Ceramic Vase',
      price: 45.00,
      imageUrl:
          'https://lh3.googleusercontent.com/aida-public/AB6AXuBk8-44FZ-YWe7SJb6DB0yeZO6VhzkL4bU4YDkrKuVLGuOmkYzlp3LD5IJStYVycsJBalLIswA-LNQxNaptBkIrn3w2WdItHkoqEGNQ_gVHGlfgOrqVy33Q5oWBoXikBcabcdhb19qNbnCDpUntlQL7fe9dsG7yGvA1x7VTcddjHyEO75tYMmKvrnBdCOdI9YTwW6RRT2l9AwnUp4F09NDdaE4Eu1bmKRqjmFqZJ9OrCTQIO3rItE20zGzJzqOgDnyxWO7S3On9bhE',
      isInStock: true,
    ),
  ];

  void _removeItem(String id) {
    setState(() {
      _wishlistItems.removeWhere((item) => item.id == id);
    });
    toastification.show(
      context: context,
      type: ToastificationType.info,
      title: const Text("Removed from wishlist"),
      autoCloseDuration: const Duration(seconds: 2),
    );
  }

  void _addToCart(String id) {
    toastification.show(
      context: context,
      type: ToastificationType.success,
      title: const Text("Added to cart"),
      autoCloseDuration: const Duration(seconds: 2),
    );
  }

  void _notifyWhenAvailable(String id) {
    toastification.show(
      context: context,
      type: ToastificationType.info,
      title: const Text("We'll notify you when available"),
      autoCloseDuration: const Duration(seconds: 2),
    );
  }

  void _moveAllToCart() {
    final inStockItems = _wishlistItems.where((item) => item.isInStock).length;
    toastification.show(
      context: context,
      type: ToastificationType.success,
      title: Text("$inStockItems items added to cart"),
      autoCloseDuration: const Duration(seconds: 2),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Theme colors
    const primaryBlue = Color(0xFF135bec);
    final bgColor = isDark ? const Color(0xFF101622) : const Color(0xFFF6F6F8);
    final surfaceColor = isDark ? const Color(0xFF1E293B) : Colors.white;
    final cardColor = isDark ? Colors.grey[800]! : Colors.white;
    final textColor = isDark ? Colors.white : const Color(0xFF111318);
    final subtleTextColor = isDark ? Colors.grey[400]! : Colors.grey[500]!;
    final borderColor = isDark ? Colors.grey[800]! : Colors.grey[200]!;

    return Scaffold(
      backgroundColor: bgColor,
      body: _wishlistItems.isEmpty
          ? _buildEmptyState(isDark, textColor, subtleTextColor, primaryBlue)
          : Stack(
              children: [
                CustomScrollView(
                  slivers: [
                    // Sticky Header
                    SliverAppBar(
                      pinned: true,
                      backgroundColor: bgColor.withAlpha(242),
                      surfaceTintColor: Colors.transparent,
                      elevation: 0,
                      automaticallyImplyLeading: false,
                      flexibleSpace: Container(
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(color: borderColor),
                          ),
                        ),
                        child: SafeArea(
                          bottom: false,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "Wishlist",
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: textColor,
                                      ),
                                    ),
                                    Text(
                                      "${_wishlistItems.length} items",
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                        color: subtleTextColor,
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    _buildHeaderButton(
                                      icon: LucideIcons.share,
                                      onTap: () {},
                                      isDark: isDark,
                                      cardColor: cardColor,
                                      textColor: textColor,
                                    ),
                                    const SizedBox(width: 12),
                                    _buildHeaderButton(
                                      icon: LucideIcons.layoutGrid,
                                      onTap: () {},
                                      isDark: isDark,
                                      cardColor: cardColor,
                                      textColor: textColor,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      toolbarHeight: 72,
                    ),

                    // Collection Chips
                    SliverToBoxAdapter(
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Row(
                            children: [
                              ..._collections.map(
                                (collection) => Padding(
                                  padding: const EdgeInsets.only(right: 12),
                                  child: _buildCollectionChip(
                                    collection,
                                    collection == _selectedCollection,
                                    isDark,
                                    cardColor,
                                    textColor,
                                    primaryBlue,
                                  ),
                                ),
                              ),
                              _buildAddCollectionChip(primaryBlue),
                            ],
                          ),
                        ),
                      ),
                    ),

                    // Product Grid
                    SliverPadding(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 100),
                      sliver: SliverGrid(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 16,
                              mainAxisSpacing: 16,
                              childAspectRatio: 0.58,
                            ),
                        delegate: SliverChildBuilderDelegate((context, index) {
                          final item = _wishlistItems[index];
                          return _buildProductCard(
                            item,
                            index,
                            isDark,
                            cardColor,
                            textColor,
                            subtleTextColor,
                            primaryBlue,
                            borderColor,
                          );
                        }, childCount: _wishlistItems.length),
                      ),
                    ),
                  ],
                ),

                // Fixed Bottom Action Bar
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: surfaceColor.withAlpha(204),
                      border: Border(top: BorderSide(color: borderColor)),
                    ),
                    child: ClipRRect(
                      child: SafeArea(
                        top: false,
                        child: GestureDetector(
                          onTap: _moveAllToCart,
                          child: Container(
                            height: 48,
                            decoration: BoxDecoration(
                              color: primaryBlue,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: primaryBlue.withAlpha(64),
                                  blurRadius: 12,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  LucideIcons.shoppingBag,
                                  size: 18,
                                  color: Colors.white,
                                ),
                                const SizedBox(width: 8),
                                const Text(
                                  "Move all to Cart",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildHeaderButton({
    required IconData icon,
    required VoidCallback onTap,
    required bool isDark,
    required Color cardColor,
    required Color textColor,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: cardColor,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(13),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Icon(icon, size: 18, color: textColor),
      ),
    );
  }

  Widget _buildCollectionChip(
    String label,
    bool isSelected,
    bool isDark,
    Color cardColor,
    Color textColor,
    Color primaryBlue,
  ) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedCollection = label;
        });
      },
      child: Container(
        height: 36,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          color: isSelected ? primaryBlue : cardColor,
          borderRadius: BorderRadius.circular(50),
          border: Border.all(
            color: isSelected
                ? primaryBlue
                : (isDark ? Colors.grey[700]! : Colors.transparent),
          ),
          boxShadow: [
            if (!isSelected)
              BoxShadow(
                color: Colors.black.withAlpha(8),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
          ],
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              fontSize: 14,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
              color: isSelected ? Colors.white : textColor,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAddCollectionChip(Color primaryBlue) {
    return GestureDetector(
      onTap: () {
        // Add new collection
      },
      child: Container(
        height: 36,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: primaryBlue.withAlpha(26),
          borderRadius: BorderRadius.circular(50),
        ),
        child: Row(
          children: [
            Icon(LucideIcons.plus, size: 16, color: primaryBlue),
            const SizedBox(width: 4),
            Text(
              "New",
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: primaryBlue,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProductCard(
    _WishlistItem item,
    int index,
    bool isDark,
    Color cardColor,
    Color textColor,
    Color subtleTextColor,
    Color primaryBlue,
    Color borderColor,
  ) {
    final hasDiscount =
        item.discountPercent != null && item.discountPercent! > 0;

    return Container(
          decoration: BoxDecoration(
            color: cardColor,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha(13),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Image
                Expanded(
                  child: Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: CachedNetworkImage(
                          imageUrl: item.imageUrl,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          color: item.isInStock
                              ? null
                              : Colors.black.withAlpha(77),
                          colorBlendMode: item.isInStock
                              ? null
                              : BlendMode.darken,
                          placeholder: (context, url) => Container(
                            color: isDark ? Colors.grey[700] : Colors.grey[100],
                          ),
                        ),
                      ),
                      // Out of stock overlay
                      if (!item.isInStock)
                        Positioned.fill(
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.black.withAlpha(102),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Center(
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white.withAlpha(51),
                                  borderRadius: BorderRadius.circular(50),
                                  border: Border.all(
                                    color: Colors.white.withAlpha(77),
                                  ),
                                ),
                                child: const Text(
                                  "Out of Stock",
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      // Discount badge
                      if (hasDiscount && item.isInStock)
                        Positioned(
                          top: 8,
                          left: 8,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFF22C55E),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              "-${item.discountPercent}%",
                              style: const TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      // Remove button
                      Positioned(
                        top: 8,
                        right: 8,
                        child: GestureDetector(
                          onTap: () => _removeItem(item.id),
                          child: Container(
                            width: 32,
                            height: 32,
                            decoration: BoxDecoration(
                              color: isDark
                                  ? Colors.black.withAlpha(153)
                                  : Colors.white.withAlpha(230),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              LucideIcons.x,
                              size: 16,
                              color: isDark
                                  ? Colors.grey[200]
                                  : Colors.grey[700],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                // Product info
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.name,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: item.isInStock ? textColor : subtleTextColor,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Text(
                            "\$${item.price.toStringAsFixed(2)}",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: item.isInStock
                                  ? primaryBlue
                                  : subtleTextColor,
                            ),
                          ),
                          if (item.originalPrice != null) ...[
                            const SizedBox(width: 6),
                            Text(
                              "\$${item.originalPrice!.toStringAsFixed(2)}",
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: subtleTextColor,
                                decoration: TextDecoration.lineThrough,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                // Action button
                GestureDetector(
                  onTap: () => item.isInStock
                      ? _addToCart(item.id)
                      : _notifyWhenAvailable(item.id),
                  child: Container(
                    width: double.infinity,
                    height: 40,
                    decoration: BoxDecoration(
                      color: item.isInStock ? primaryBlue : Colors.transparent,
                      borderRadius: BorderRadius.circular(8),
                      border: item.isInStock
                          ? null
                          : Border.all(color: borderColor),
                      boxShadow: item.isInStock
                          ? [
                              BoxShadow(
                                color: primaryBlue.withAlpha(51),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ]
                          : null,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          item.isInStock
                              ? LucideIcons.shoppingCart
                              : LucideIcons.bell,
                          size: 16,
                          color: item.isInStock ? Colors.white : textColor,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          item.isInStock ? "ADD" : "NOTIFY",
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.5,
                            color: item.isInStock ? Colors.white : textColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        )
        .animate()
        .fadeIn(delay: (index * 80).ms)
        .scale(begin: const Offset(0.95, 0.95));
  }

  Widget _buildEmptyState(
    bool isDark,
    Color textColor,
    Color subtleTextColor,
    Color primaryBlue,
  ) {
    return SafeArea(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 128,
                height: 128,
                decoration: BoxDecoration(
                  color: isDark ? Colors.grey[800] : Colors.grey[100],
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  LucideIcons.heart,
                  size: 56,
                  color: isDark ? Colors.grey[600] : Colors.grey[300],
                ),
              ),
              const SizedBox(height: 24),
              Text(
                "Your wishlist is empty",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                "Save items you love to revisit them later.",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, color: subtleTextColor),
              ),
              const SizedBox(height: 32),
              GestureDetector(
                onTap: () => context.go('/'),
                child: Container(
                  height: 48,
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  decoration: BoxDecoration(
                    color: primaryBlue,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: primaryBlue.withAlpha(51),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: const Center(
                    child: Text(
                      "Browse Products",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ).animate().fadeIn().scale(begin: const Offset(0.9, 0.9)),
        ),
      ),
    );
  }
}

class _WishlistItem {
  final String id;
  final String name;
  final double price;
  final double? originalPrice;
  final String imageUrl;
  final bool isInStock;
  final int? discountPercent;

  _WishlistItem({
    required this.id,
    required this.name,
    required this.price,
    this.originalPrice,
    required this.imageUrl,
    this.isInStock = true,
    this.discountPercent,
  });
}
