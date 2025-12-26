import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:dc_store/core/theme/app_colors.dart';

/// SizeSelectorItem - Represents a single size option
class SizeSelectorItem {
  final String id;
  final String label;
  final bool inStock;
  final int? stockCount;

  const SizeSelectorItem({
    required this.id,
    required this.label,
    this.inStock = true,
    this.stockCount,
  });
}

/// SizeSelector - Size buttons with stock indicators
///
/// Example usage:
/// ```dart
/// SizeSelector(
///   sizes: [
///     SizeSelectorItem(id: '7', label: '7', inStock: false),
///     SizeSelectorItem(id: '8', label: '8'),
///     SizeSelectorItem(id: '9', label: '9', stockCount: 2),
///   ],
///   selectedId: '9',
///   onSelected: (item) => print(item.label),
///   lowStockThreshold: 3,
/// )
/// ```
class SizeSelector extends StatelessWidget {
  /// Available sizes
  final List<SizeSelectorItem> sizes;

  /// Currently selected size ID
  final String? selectedId;

  /// Callback when a size is selected
  final ValueChanged<SizeSelectorItem>? onSelected;

  /// Threshold for low stock warning
  final int lowStockThreshold;

  /// Callback when size guide is tapped
  final VoidCallback? onSizeGuide;

  const SizeSelector({
    super.key,
    required this.sizes,
    this.selectedId,
    this.onSelected,
    this.lowStockThreshold = 5,
    this.onSizeGuide,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final selectedItem = sizes.where((s) => s.id == selectedId).firstOrNull;
    final showLowStock =
        selectedItem?.stockCount != null &&
        selectedItem!.stockCount! <= lowStockThreshold &&
        selectedItem.stockCount! > 0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header with size guide link
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Select Size (US)',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: isDark ? Colors.white : AppColors.textPrimary,
              ),
            ),
            if (onSizeGuide != null)
              GestureDetector(
                onTap: onSizeGuide,
                child: Text(
                  'Size Guide',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.info,
                    decoration: TextDecoration.underline,
                    decorationColor: AppColors.info,
                  ),
                ),
              ),
          ],
        ),

        const SizedBox(height: 12),

        // Size Buttons
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: sizes.map((item) {
            final isSelected = item.id == selectedId;
            return _SizeButton(
              item: item,
              isSelected: isSelected,
              isDark: isDark,
              onTap: item.inStock ? () => onSelected?.call(item) : null,
            );
          }).toList(),
        ),

        // Low stock warning
        if (showLowStock)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Row(
              children: [
                Icon(LucideIcons.alertCircle, size: 14, color: AppColors.error),
                const SizedBox(width: 4),
                Text(
                  'Only ${selectedItem.stockCount} left in stock',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: AppColors.error,
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}

class _SizeButton extends StatelessWidget {
  final SizeSelectorItem item;
  final bool isSelected;
  final bool isDark;
  final VoidCallback? onTap;

  const _SizeButton({
    required this.item,
    required this.isSelected,
    required this.isDark,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isOutOfStock = !item.inStock;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        height: 40,
        width: 56,
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.info
              : (isDark ? AppColors.darkSurface : Colors.white),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected
                ? AppColors.info
                : (isDark ? AppColors.darkBorder : AppColors.border),
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppColors.info.withAlpha(51),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Text(
              item.label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                color: isSelected
                    ? Colors.white
                    : isOutOfStock
                    ? (isDark ? Colors.grey[600] : Colors.grey[400])
                    : (isDark ? Colors.white : AppColors.textPrimary),
              ),
            ),
            // Out of stock strikethrough
            if (isOutOfStock)
              Positioned.fill(
                child: CustomPaint(
                  painter: _StrikethroughPainter(
                    color: isDark ? Colors.grey[600]! : Colors.grey[400]!,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _StrikethroughPainter extends CustomPainter {
  final Color color;

  _StrikethroughPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1;

    canvas.drawLine(Offset(0, size.height), Offset(size.width, 0), paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
