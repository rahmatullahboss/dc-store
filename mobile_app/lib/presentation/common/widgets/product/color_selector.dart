import 'package:flutter/material.dart';
import 'package:dc_store/core/theme/app_colors.dart';

/// ColorSelectorItem - Represents a single color option
class ColorSelectorItem {
  final String id;
  final String name;
  final Color color;
  final bool inStock;

  const ColorSelectorItem({
    required this.id,
    required this.name,
    required this.color,
    this.inStock = true,
  });
}

/// ColorSelector - Circular color swatches for product variants
///
/// Example usage:
/// ```dart
/// ColorSelector(
///   colors: [
///     ColorSelectorItem(id: '1', name: 'Blue', color: Colors.blue),
///     ColorSelectorItem(id: '2', name: 'Black', color: Colors.black),
///   ],
///   selectedId: '1',
///   onSelected: (item) => print(item.name),
/// )
/// ```
class ColorSelector extends StatelessWidget {
  /// Available colors
  final List<ColorSelectorItem> colors;

  /// Currently selected color ID
  final String? selectedId;

  /// Callback when a color is selected
  final ValueChanged<ColorSelectorItem>? onSelected;

  /// Size of color swatches
  final double swatchSize;

  /// Whether to show the color name
  final bool showColorName;

  const ColorSelector({
    super.key,
    required this.colors,
    this.selectedId,
    this.onSelected,
    this.swatchSize = 40,
    this.showColorName = true,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final selectedItem = colors.where((c) => c.id == selectedId).firstOrNull;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header with selected color name
        if (showColorName)
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: RichText(
              text: TextSpan(
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: isDark ? Colors.white : AppColors.textPrimary,
                ),
                children: [
                  const TextSpan(text: 'Color: '),
                  TextSpan(
                    text: selectedItem?.name ?? 'Select',
                    style: TextStyle(
                      fontWeight: FontWeight.normal,
                      color: isDark
                          ? Colors.grey[400]
                          : AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ),

        // Color Swatches
        Wrap(
          spacing: 16,
          runSpacing: 12,
          children: colors.map((item) {
            final isSelected = item.id == selectedId;
            return GestureDetector(
              onTap: item.inStock ? () => onSelected?.call(item) : null,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: swatchSize,
                height: swatchSize,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: item.color,
                  border: Border.all(
                    color: _getBorderColor(item, isDark),
                    width: 1,
                  ),
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: AppColors.info.withAlpha(77),
                            blurRadius: 8,
                            spreadRadius: 2,
                          ),
                        ]
                      : null,
                ),
                child: isSelected
                    ? Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: AppColors.info, width: 2),
                        ),
                        margin: const EdgeInsets.all(-4),
                      )
                    : item.inStock
                    ? null
                    : Center(
                        child: Icon(
                          Icons.close,
                          size: swatchSize * 0.5,
                          color: Colors.white.withAlpha(179),
                        ),
                      ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Color _getBorderColor(ColorSelectorItem item, bool isDark) {
    // Add visible border for light colors
    final luminance = item.color.computeLuminance();
    if (luminance > 0.7) {
      return isDark ? Colors.grey[600]! : Colors.grey[300]!;
    }
    return Colors.transparent;
  }
}
