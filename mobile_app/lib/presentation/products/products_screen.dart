import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:toastification/toastification.dart';
import '../../core/theme/app_colors.dart';
import '../../features/product/presentation/providers/product_provider.dart';
import '../../features/cart/presentation/providers/cart_provider.dart';
import '../common/widgets/product_card.dart';

enum SortOption { nameAsc, nameDesc, priceAsc, priceDesc }

class ProductsScreen extends ConsumerStatefulWidget {
  const ProductsScreen({super.key});

  @override
  ConsumerState<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends ConsumerState<ProductsScreen> {
  final _searchController = TextEditingController();
  String _searchQuery = '';
  SortOption _sortOption = SortOption.nameAsc;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _showSortOptions() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) => Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Sort By",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              _buildSortOption("Name (A-Z)", SortOption.nameAsc, setModalState),
              _buildSortOption(
                "Name (Z-A)",
                SortOption.nameDesc,
                setModalState,
              ),
              _buildSortOption(
                "Price (Low to High)",
                SortOption.priceAsc,
                setModalState,
              ),
              _buildSortOption(
                "Price (High to Low)",
                SortOption.priceDesc,
                setModalState,
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSortOption(
    String label,
    SortOption option,
    StateSetter setModalState,
  ) {
    final isSelected = option == _sortOption;
    return ListTile(
      title: Text(label),
      trailing: isSelected
          ? const Icon(LucideIcons.check, color: AppColors.primary)
          : null,
      onTap: () {
        setState(() => _sortOption = option);
        setModalState(() {});
        Navigator.pop(context);
      },
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      tileColor: isSelected ? AppColors.primary.withAlpha(25) : null,
    );
  }

  @override
  Widget build(BuildContext context) {
    final productsAsync = ref.watch(productsProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text("Products"),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(LucideIcons.arrowUpDown),
            onPressed: _showSortOptions,
          ),
        ],
      ),
      body: Column(
        children: [
          // Search Bar
          Container(
            color: Colors.white,
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: TextField(
              controller: _searchController,
              onChanged: (value) {
                setState(() => _searchQuery = value.toLowerCase());
              },
              decoration: InputDecoration(
                hintText: "Search products...",
                prefixIcon: const Icon(LucideIcons.search, size: 20),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(LucideIcons.x, size: 18),
                        onPressed: () {
                          _searchController.clear();
                          setState(() => _searchQuery = '');
                        },
                      )
                    : null,
                filled: true,
                fillColor: Colors.grey[100],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
              ),
            ),
          ),

          // Products Grid
          Expanded(
            child: productsAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, stack) => Center(child: Text('Error: $err')),
              data: (products) {
                // Filter
                var filtered = products.where((p) {
                  if (_searchQuery.isEmpty) return true;
                  return p.name.toLowerCase().contains(_searchQuery) ||
                      (p.categoryId?.toLowerCase().contains(_searchQuery) ??
                          false);
                }).toList();

                // Sort
                switch (_sortOption) {
                  case SortOption.nameAsc:
                    filtered.sort((a, b) => a.name.compareTo(b.name));
                    break;
                  case SortOption.nameDesc:
                    filtered.sort((a, b) => b.name.compareTo(a.name));
                    break;
                  case SortOption.priceAsc:
                    filtered.sort((a, b) => a.price.compareTo(b.price));
                    break;
                  case SortOption.priceDesc:
                    filtered.sort((a, b) => b.price.compareTo(a.price));
                    break;
                }

                if (filtered.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          LucideIcons.searchX,
                          size: 48,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          "No products found",
                          style: TextStyle(fontSize: 16, color: Colors.grey),
                        ),
                      ],
                    ),
                  );
                }

                return GridView.builder(
                  padding: const EdgeInsets.all(16),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 12,
                    childAspectRatio: 0.65,
                  ),
                  itemCount: filtered.length,
                  itemBuilder: (context, index) {
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
                            context.go('/cart');
                          },
                        )
                        .animate()
                        .fadeIn(delay: (50 * index).ms)
                        .scale(
                          begin: const Offset(0.95, 0.95),
                          end: const Offset(1, 1),
                        );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
