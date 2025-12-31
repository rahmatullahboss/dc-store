import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/utils/price_formatter.dart';

/// PriceText - A reusable Consumer widget for displaying prices with dynamic currency
///
/// This widget automatically watches the priceFormatterProvider and displays
/// prices in the user's selected currency (e.g., BDT or USD).
///
/// Usage:
/// ```dart
/// PriceText(price: 1500.0)
/// PriceText(price: 1500.0, style: TextStyle(fontSize: 20))
/// PriceText.large(price: 1500.0)
/// PriceText.small(price: 1500.0, isStrikethrough: true)
/// ```
class PriceText extends ConsumerWidget {
  final double price;
  final TextStyle? style;
  final bool isStrikethrough;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;

  const PriceText({
    super.key,
    required this.price,
    this.style,
    this.isStrikethrough = false,
    this.textAlign,
    this.maxLines,
    this.overflow,
  });

  /// Large price text (for main product prices, totals)
  factory PriceText.large({
    Key? key,
    required double price,
    Color? color,
    FontWeight fontWeight = FontWeight.bold,
  }) {
    return PriceText(
      key: key,
      price: price,
      style: TextStyle(fontSize: 24, fontWeight: fontWeight, color: color),
    );
  }

  /// Medium price text (for card prices)
  factory PriceText.medium({
    Key? key,
    required double price,
    Color? color,
    FontWeight fontWeight = FontWeight.bold,
  }) {
    return PriceText(
      key: key,
      price: price,
      style: TextStyle(fontSize: 16, fontWeight: fontWeight, color: color),
    );
  }

  /// Small price text (for compare-at prices, discounts)
  factory PriceText.small({
    Key? key,
    required double price,
    Color? color,
    bool isStrikethrough = false,
  }) {
    return PriceText(
      key: key,
      price: price,
      isStrikethrough: isStrikethrough,
      style: TextStyle(
        fontSize: 12,
        color: color,
        decoration: isStrikethrough ? TextDecoration.lineThrough : null,
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final priceFormatter = ref.watch(priceFormatterProvider);
    final formattedPrice = priceFormatter.format(price);

    // Apply strikethrough decoration if needed
    TextStyle? effectiveStyle = style;
    if (isStrikethrough && effectiveStyle != null) {
      effectiveStyle = effectiveStyle.copyWith(
        decoration: TextDecoration.lineThrough,
      );
    } else if (isStrikethrough) {
      effectiveStyle = const TextStyle(decoration: TextDecoration.lineThrough);
    }

    return Text(
      formattedPrice,
      style: effectiveStyle,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
    );
  }
}

/// Extension on PriceFormatter for easier formatting in non-Consumer widgets
/// Use this when you already have access to ref in a ConsumerWidget/ConsumerStatefulWidget
extension PriceFormatterExtension on WidgetRef {
  /// Format a price using the current currency settings
  String formatPrice(double price) {
    return watch(priceFormatterProvider).format(price);
  }

  /// Get the current currency symbol
  String get currencySymbol {
    return watch(priceFormatterProvider).symbol;
  }

  /// Get the current currency code (e.g., 'USD', 'BDT')
  String get currencyCode {
    return watch(priceFormatterProvider).code;
  }
}
