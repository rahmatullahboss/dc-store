import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:toastification/toastification.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/app_haptics.dart';
import '../../features/product/presentation/providers/product_provider.dart';
import '../../features/cart/presentation/providers/cart_provider.dart';
import '../common/widgets/product_card.dart';
import '../common/widgets/shimmer_loading.dart';

class ProductsScreen extends ConsumerStatefulWidget {
  const ProductsScreen({super.key});

  @override
  ConsumerState<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends ConsumerState<ProductsScreen> {
  final _searchController = TextEditingController();
  String _searchQuery = '';
  String _sortOption = 'default';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final productsAsync = ref.watch(productsProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? AppColors.darkBackground : const Color(0xFFF9FAFB);
    final cardColor = isDark ? AppColors.darkCard : Colors.white;
    final textColor = isDark ? Colors.white : Colors.black87;

    return Scaffold(
      backgroundColor: bgColor,
      body: CustomScrollView(
        slivers: [
          // App Bar
          SliverAppBar(
            floating: true,
            pinned: true,
            backgroundColor: cardColor,
            expandedHeight: 140,
            flexibleSpace: FlexibleSpaceBar(
              background: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "All Products",
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: textColor,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "Find the best products for you",
                        style: TextStyle(
                          color: isDark ? Colors.grey[400] : Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(60),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                child: Row(
                  children: [
                    // Search Bar
                    Expanded(
                      child: Container(
                        height: 48,
                        decoration: BoxDecoration(
                          color: isDark
                              ? AppColors.darkSecondary
                              : Colors.grey[100],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: TextField(
                          controller: _searchController,
                          onChanged: (value) {
                            setState(() => _searchQuery = value);
                          },
                          decoration: InputDecoration(
                            hintText: "Search products...",
                            hintStyle: TextStyle(
                              color: isDark
                                  ? Colors.grey[500]
                                  : Colors.grey[400],
                            ),
                            prefixIcon: Icon(
                              LucideIcons.search,
                              color: isDark
                                  ? Colors.grey[400]
                                  : Colors.grey[500],
                            ),
                            suffixIcon: _searchQuery.isNotEmpty
                                ? IconButton(
                                    icon: Icon(
                                      LucideIcons.x,
                                      color: isDark
                                          ? Colors.grey[400]
                                          : Colors.grey[500],
                                    ),
                                    onPressed: () {
                                      _searchController.clear();
                                      setState(() => _searchQuery = '');
                                    },
                                  )
                                : null,
                            border: InputBorder.none,
                            contentPadding: const EdgeInsets.symmetric(
                              vertical: 14,
                            ),
                          ),
                          style: TextStyle(color: textColor),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    // Sort Button
                    Container(
                      height: 48,
                      decoration: BoxDecoration(
                        color: isDark
                            ? AppColors.darkSecondary
                            : Colors.grey[100],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: PopupMenuButton<String>(
                        initialValue: _sortOption,
                        onSelected: (value) {
                          setState(() => _sortOption = value);
                        },
                        offset: const Offset(0, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        color: cardColor,
                        itemBuilder: (context) => [
                          _buildSortItem(
                            'default',
                            'Default',
                            _sortOption,
                            textColor,
                          ),
                          _buildSortItem(
                            'low',
                            'Price: Low to High',
                            _sortOption,
                            textColor,
                          ),
                          _buildSortItem(
                            'high',
                            'Price: High to Low',
                            _sortOption,
                            textColor,
                          ),
                          _buildSortItem(
                            'name',
                            'Name: A-Z',
                            _sortOption,
                            textColor,
                          ),
                        ],
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 14),
                          child: Row(
                            children: [
                              Icon(
                                LucideIcons.arrowUpDown,
                                color: isDark
                                    ? Colors.grey[400]
                                    : Colors.grey[600],
                                size: 20,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                "Sort",
                                style: TextStyle(
                                  color: isDark
                                      ? Colors.grey[300]
                                      : Colors.grey[700],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Products Grid
          productsAsync.when(
            loading: () => SliverPadding(
              padding: const EdgeInsets.all(16),
              sliver: SliverGrid(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 12,
                  childAspectRatio: 0.65,
                ),
                delegate: SliverChildBuilderDelegate(
                  (context, index) => const ProductCardSkeleton(),
                  childCount: 6,
                ),
              ),
            ),
            error: (err, stack) => SliverFillRemaining(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      LucideIcons.alertCircle,
                      size: 48,
                      color: Colors.red[400],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Error loading products',
                      style: TextStyle(color: textColor),
                    ),
                    const SizedBox(height: 8),
                    ElevatedButton(
                      onPressed: () => ref.invalidate(productsProvider),
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              ),
            ),
            data: (products) {
              // Filter and sort
              var filtered = products
                  .where(
                    (p) => p.name.toLowerCase().contains(
                      _searchQuery.toLowerCase(),
                    ),
                  )
                  .toList();

              switch (_sortOption) {
                case 'low':
                  filtered.sort((a, b) => a.price.compareTo(b.price));
                  break;
                case 'high':
                  filtered.sort((a, b) => b.price.compareTo(a.price));
                  break;
                case 'name':
                  filtered.sort((a, b) => a.name.compareTo(b.name));
                  break;
              }

              if (filtered.isEmpty) {
                return SliverFillRemaining(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          LucideIcons.searchX,
                          size: 48,
                          color: isDark ? Colors.grey[600] : Colors.grey[400],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No products found',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: textColor,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Try adjusting your search',
                          style: TextStyle(
                            color: isDark ? Colors.grey[400] : Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }

              return SliverPadding(
                padding: const EdgeInsets.all(16),
                sliver: SliverGrid(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 12,
                    childAspectRatio: 0.65,
                  ),
                  delegate: SliverChildBuilderDelegate((context, index) {
                    final product = filtered[index];
                    return ProductCard(
                          id: product.id,
                          name: product.name,
                          price: product.price,
                          compareAtPrice: product.compareAtPrice,
                          category: product.categoryId,
                          isFeatured: product.isFeatured,
                          imageUrl: product.featuredImage,
                          onAddToCart: () {
                            AppHaptics.mediumImpact();
                            ref.read(cartProvider.notifier).addToCart(product);
                            toastification.show(
                              context: context,
                              type: ToastificationType.success,
                              style: ToastificationStyle.minimal,
                              title: const Text("Added to cart"),
                              autoCloseDuration: const Duration(seconds: 2),
                            );
                          },
                          onOrderNow: () {
                            ref.read(cartProvider.notifier).addToCart(product);
                            // Navigate to cart
                          },
                        )
                        .animate()
                        .fadeIn(delay: (50 * index).ms)
                        .slideY(begin: 0.05);
                  }, childCount: filtered.length),
                ),
              );
            },
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 32)),
        ],
      ),
    );
  }

  PopupMenuItem<String> _buildSortItem(
    String value,
    String label,
    String current,
    Color textColor,
  ) {
    return PopupMenuItem(
      value: value,
      child: Row(
        children: [
          if (current == value)
            const Icon(LucideIcons.check, size: 16, color: AppColors.primary)
          else
            const SizedBox(width: 16),
          const SizedBox(width: 8),
          Text(label, style: TextStyle(color: textColor)),
        ],
      ),
    );
  }
}
