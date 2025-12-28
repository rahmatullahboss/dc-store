import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:go_router/go_router.dart';
import '../../../core/config/white_label_config.dart';
import '../../../data/models/chat_product.dart';

/// Chat product card widget
///
/// Displays a tappable product card in chat messages.
/// Navigates to product details on tap.
class ChatProductCard extends StatelessWidget {
  final ChatProduct product;

  const ChatProductCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Material(
        color: isDark ? const Color(0xFF2A2A2A) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        elevation: 1,
        child: InkWell(
          onTap: () => context.push('/products/${product.slug}'),
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isDark
                    ? Colors.white.withValues(alpha: 0.1)
                    : const Color(0xFFE2E8F0),
              ),
            ),
            child: Row(
              children: [
                // Product image
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: SizedBox(
                    width: 56,
                    height: 56,
                    child: _buildImage(isDark),
                  ),
                ),
                const SizedBox(width: 12),

                // Product info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        product.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: isDark
                              ? Colors.white
                              : const Color(0xFF1E293B),
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        product.category,
                        style: TextStyle(
                          fontSize: 12,
                          color: isDark
                              ? Colors.white60
                              : const Color(0xFF64748B),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Text(
                            '৳${product.price.toStringAsFixed(0)}',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: WhiteLabelConfig.accentColor,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: product.inStock
                                  ? Colors.green.withValues(alpha: 0.1)
                                  : Colors.red.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              product.inStock ? 'In Stock' : 'Out',
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w500,
                                color: product.inStock
                                    ? Colors.green.shade700
                                    : Colors.red.shade700,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Arrow icon
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 16,
                  color: isDark ? Colors.white38 : const Color(0xFF94A3B8),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildImage(bool isDark) {
    if (product.imageUrl != null && product.imageUrl!.isNotEmpty) {
      final imageUrl = product.imageUrl!.startsWith('http')
          ? product.imageUrl!
          : '${WhiteLabelConfig.apiBaseUrl}${product.imageUrl}';

      return CachedNetworkImage(
        imageUrl: imageUrl,
        fit: BoxFit.cover,
        placeholder: (context, url) => Container(
          color: isDark ? const Color(0xFF3A3A3A) : const Color(0xFFF1F5F9),
          child: Icon(
            Icons.shopping_bag_outlined,
            color: isDark ? Colors.white38 : const Color(0xFF94A3B8),
          ),
        ),
        errorWidget: (context, url, error) => Container(
          color: isDark ? const Color(0xFF3A3A3A) : const Color(0xFFF1F5F9),
          child: Icon(
            Icons.shopping_bag_outlined,
            color: isDark ? Colors.white38 : const Color(0xFF94A3B8),
          ),
        ),
      );
    }

    return Container(
      color: isDark ? const Color(0xFF3A3A3A) : const Color(0xFFF1F5F9),
      child: Icon(
        Icons.shopping_bag_outlined,
        color: isDark ? Colors.white38 : const Color(0xFF94A3B8),
      ),
    );
  }
}
