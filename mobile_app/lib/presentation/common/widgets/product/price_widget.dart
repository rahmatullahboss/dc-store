import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';

/// PriceWidget - Displays product pricing with original, sale, and discount badge
///
/// Example usage:
/// ```dart
/// PriceWidget(
///   price: 1599,
///   originalPrice: 1999,
///   showDiscount: true,
/// )
/// ```
class PriceWidget extends StatelessWidget {
  /// Current price
  final double price;

  /// Original price (for showing discount)
  final double? originalPrice;

  /// Currency symbol
  final String currency;

  /// Size variant
  final PriceSize size;

  /// Whether to show discount badge
  final bool showDiscount;

  /// Layout direction
  final Axis direction;

  /// Custom spacing between elements
  final double? spacing;

  const PriceWidget({
    super.key,
    required this.price,
    this.originalPrice,
    this.currency = '৳',
    this.size = PriceSize.medium,
    this.showDiscount = true,
    this.direction = Axis.horizontal,
    this.spacing,
  });

  bool get hasDiscount => originalPrice != null && originalPrice! > price;

  int get discountPercent {
    if (!hasDiscount) return 0;
    return (((originalPrice! - price) / originalPrice!) * 100).round();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    if (direction == Axis.vertical) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: _buildPriceElements(isDark),
      );
    }

    return Wrap(
      spacing: spacing ?? 8,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: _buildPriceElements(isDark),
    );
  }

  List<Widget> _buildPriceElements(bool isDark) {
    return [
      // Current price
      Text(
        '$currency${_formatPrice(price)}',
        style: _getCurrentPriceStyle(isDark),
      ),

      // Original price (strikethrough)
      if (hasDiscount) ...[
        SizedBox(
          width: spacing ?? 4,
          height: direction == Axis.vertical ? 2 : 0,
        ),
        Text(
          '$currency${_formatPrice(originalPrice!)}',
          style: _getOriginalPriceStyle(isDark),
        ),
      ],

      // Discount badge
      if (hasDiscount && showDiscount) ...[
        SizedBox(
          width: spacing ?? 4,
          height: direction == Axis.vertical ? 4 : 0,
        ),
        _DiscountBadge(percentage: discountPercent, size: size),
      ],
    ];
  }

  TextStyle _getCurrentPriceStyle(bool isDark) {
    Color color = isDark ? AppColors.darkTextPrimary : AppColors.textPrimary;

    switch (size) {
      case PriceSize.small:
        return AppTextStyles.labelLarge.copyWith(
          color: color,
          fontWeight: FontWeight.w700,
        );
      case PriceSize.medium:
        return AppTextStyles.h5.copyWith(color: color);
      case PriceSize.large:
        return AppTextStyles.h3.copyWith(color: color);
    }
  }

  TextStyle _getOriginalPriceStyle(bool isDark) {
    Color color = isDark ? AppColors.darkTextHint : AppColors.textHint;

    switch (size) {
      case PriceSize.small:
        return AppTextStyles.caption.copyWith(
          color: color,
          decoration: TextDecoration.lineThrough,
        );
      case PriceSize.medium:
        return AppTextStyles.bodySmall.copyWith(
          color: color,
          decoration: TextDecoration.lineThrough,
        );
      case PriceSize.large:
        return AppTextStyles.bodyLarge.copyWith(
          color: color,
          decoration: TextDecoration.lineThrough,
        );
    }
  }

  String _formatPrice(double value) {
    if (value == value.toInt()) {
      return value.toInt().toString();
    }
    return value.toStringAsFixed(2);
  }
}

enum PriceSize { small, medium, large }

class _DiscountBadge extends StatelessWidget {
  final int percentage;
  final PriceSize size;

  const _DiscountBadge({required this.percentage, required this.size});

  @override
  Widget build(BuildContext context) {
    final paddingH = size == PriceSize.small ? 4.0 : 6.0;
    final paddingV = size == PriceSize.small ? 2.0 : 4.0;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: paddingH, vertical: paddingV),
      decoration: BoxDecoration(
        color: AppColors.error,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        '-$percentage%',
        style:
            (size == PriceSize.small
                    ? AppTextStyles.overline
                    : AppTextStyles.caption)
                .copyWith(color: Colors.white, fontWeight: FontWeight.w600),
      ),
    );
  }
}

/// Compact price display for cards
class CompactPriceWidget extends StatelessWidget {
  final double price;
  final double? originalPrice;
  final String currency;

  const CompactPriceWidget({
    super.key,
    required this.price,
    this.originalPrice,
    this.currency = '৳',
  });

  @override
  Widget build(BuildContext context) {
    return PriceWidget(
      price: price,
      originalPrice: originalPrice,
      currency: currency,
      size: PriceSize.small,
      showDiscount: false,
    );
  }
}
