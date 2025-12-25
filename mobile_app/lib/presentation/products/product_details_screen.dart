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

class ProductDetailsScreen extends ConsumerWidget {
  final String id;

  const ProductDetailsScreen({super.key, required this.id});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productAsync = ref.watch(productDetailsProvider(id));

    return Scaffold(
      backgroundColor: Colors.white,
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

          return CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: 400,
                pinned: true,
                backgroundColor: Colors.white,
                leading: IconButton(
                  icon: const Icon(LucideIcons.arrowLeft, color: Colors.black),
                  style: IconButton.styleFrom(
                    backgroundColor: Colors.white.withOpacity(0.8),
                  ),
                  onPressed: () => context.pop(),
                ),
                flexibleSpace: FlexibleSpaceBar(
                  background: Stack(
                    fit: StackFit.expand,
                    children: [
                      if (product.featuredImage != null)
                        CachedNetworkImage(
                          imageUrl: product.featuredImage!,
                          fit: BoxFit.cover,
                        )
                      else
                        Container(color: Colors.grey[200]),
                    ],
                  ),
                ),
              ),

              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          if (product.categoryId != null)
                            AppBadge(
                              label: product.categoryId!,
                              backgroundColor: AppColors.secondary,
                              foregroundColor: AppColors.foreground,
                            ),
                          if (discount > 0)
                            AppBadge(
                              label: "-$discount% OFF",
                              backgroundColor: AppColors.destructive,
                            ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        product.name,
                        style: Theme.of(context).textTheme.headlineSmall
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            "\$${product.price.toStringAsFixed(2)}",
                            style: Theme.of(context).textTheme.headlineMedium
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
                                "\$${product.compareAtPrice!.toStringAsFixed(2)}",
                                style: Theme.of(context).textTheme.titleMedium
                                    ?.copyWith(
                                      decoration: TextDecoration.lineThrough,
                                      color: AppColors.mutedForeground,
                                    ),
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      const Divider(),
                      const SizedBox(height: 24),
                      Text(
                        "Description",
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        product.description ?? "No description available.",
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: AppColors.mutedForeground,
                          height: 1.6,
                        ),
                      ),
                      const SizedBox(height: 100),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
      bottomSheet: productAsync.hasValue && productAsync.value != null
          ? Container(
              padding:
                  const EdgeInsets.all(16) + const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, -4),
                  ),
                ],
              ),
              child: SafeArea(
                child: Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: AppColors.border),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: IconButton(
                        onPressed: () {
                          ref
                              .read(cartProvider.notifier)
                              .addToCart(productAsync.value!);
                          toastification.show(
                            context: context,
                            type: ToastificationType.success,
                            style: ToastificationStyle.minimal,
                            title: const Text("Added to cart"),
                            description: Text(
                              "${productAsync.value!.name} added to cart",
                            ),
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
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          // Add to cart and push checkout/cart
                          ref
                              .read(cartProvider.notifier)
                              .addToCart(productAsync.value!);
                          context.push('/cart');
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          minimumSize: const Size(double.infinity, 56),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          "Buy Now",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          : null,
    );
  }
}
