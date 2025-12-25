import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:toastification/toastification.dart';
import '../common/widgets/product_card.dart';
import 'widgets/app_hero.dart';
import 'widgets/promo_banner.dart';
import 'widgets/categories_section.dart';
import '../../core/theme/app_colors.dart';
import '../../features/product/presentation/providers/product_provider.dart';
import '../../features/cart/presentation/providers/cart_provider.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productsAsync = ref.watch(productsProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(productsProvider);
        },
        child: CustomScrollView(
          slivers: [
            const SliverAppBar(
              floating: true,
              pinned: false,
              backgroundColor: Colors.transparent,
              elevation: 0,
              title: Text(""),
            ),

            const SliverToBoxAdapter(child: AppHero()),

            // Promo Banner (replaces HotDealsSection)
            const SliverToBoxAdapter(child: PromoBanner()),

            // Categories Section
            const SliverToBoxAdapter(child: CategoriesSection()),

            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Featured Products",
                          style: Theme.of(context).textTheme.headlineSmall
                              ?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: AppColors.foreground,
                              ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "Handpicked just for you",
                          style: TextStyle(color: AppColors.mutedForeground),
                        ),
                      ],
                    ),
                    TextButton(
                      onPressed: () => context.push('/products'),
                      child: const Text("View All"),
                    ),
                  ],
                ),
              ),
            ),

            productsAsync.when(
              loading: () => const SliverToBoxAdapter(
                child: Center(child: CircularProgressIndicator()),
              ),
              error: (err, stack) => SliverToBoxAdapter(
                child: Center(child: Text('Error loading products: $err')),
              ),
              data: (products) => SliverPadding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                sliver: SliverGrid(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 12,
                    childAspectRatio: 0.65,
                  ),
                  delegate: SliverChildBuilderDelegate((context, index) {
                    final product = products[index];
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
                        .fadeIn(delay: (100 * index).ms)
                        .slideY(begin: 0.1, end: 0);
                  }, childCount: products.length > 6 ? 6 : products.length),
                ),
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 32)),
          ],
        ),
      ),
    );
  }
}
