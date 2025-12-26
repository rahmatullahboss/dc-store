/// App Semantics Utility
/// Provides consistent accessibility labels and semantic widgets
/// for screen reader support.
library;

import 'package:flutter/material.dart';

/// Centralized semantics utility for consistent accessibility
class AppSemantics {
  AppSemantics._();

  // ═══════════════════════════════════════════════════════════════
  // WIDGET WRAPPERS
  // ═══════════════════════════════════════════════════════════════

  /// Wrap a button with semantics
  static Widget button({
    required Widget child,
    required String label,
    String? hint,
    VoidCallback? onTap,
    bool enabled = true,
  }) {
    return Semantics(
      button: true,
      label: label,
      hint: hint,
      enabled: enabled,
      onTap: enabled ? onTap : null,
      child: child,
    );
  }

  /// Wrap an image with semantics
  static Widget image({required Widget child, required String description}) {
    return Semantics(image: true, label: description, child: child);
  }

  /// Wrap a text field with semantics
  static Widget textField({
    required Widget child,
    required String label,
    String? hint,
    String? value,
    bool obscureText = false,
  }) {
    return Semantics(
      textField: true,
      label: label,
      hint: hint,
      value: value,
      obscured: obscureText,
      child: child,
    );
  }

  /// Wrap a toggle with semantics
  static Widget toggle({
    required Widget child,
    required String label,
    required bool isToggled,
    String? hint,
  }) {
    return Semantics(
      toggled: isToggled,
      label: label,
      hint: hint,
      child: child,
    );
  }

  /// Wrap a link with semantics
  static Widget link({
    required Widget child,
    required String label,
    String? hint,
  }) {
    return Semantics(link: true, label: label, hint: hint, child: child);
  }

  /// Wrap a header with semantics
  static Widget header({required Widget child, required String label}) {
    return Semantics(header: true, label: label, child: child);
  }

  /// Wrap with custom semantics
  static Widget custom({
    required Widget child,
    required String label,
    String? hint,
    bool? button,
    bool? image,
    bool? link,
    bool? header,
    bool? slider,
    bool? hidden,
    bool? enabled,
    VoidCallback? onTap,
    VoidCallback? onLongPress,
  }) {
    return Semantics(
      label: label,
      hint: hint,
      button: button ?? false,
      image: image ?? false,
      link: link ?? false,
      header: header ?? false,
      slider: slider ?? false,
      hidden: hidden ?? false,
      enabled: enabled ?? true,
      onTap: onTap,
      onLongPress: onLongPress,
      child: child,
    );
  }

  // ═══════════════════════════════════════════════════════════════
  // EXCLUDE FROM SEMANTICS
  // ═══════════════════════════════════════════════════════════════

  /// Exclude a widget from semantic tree (for decorative elements)
  static Widget excludeFromSemantics({required Widget child}) {
    return ExcludeSemantics(child: child);
  }

  /// Merge semantics for a group of widgets
  static Widget mergeSemantics({required Widget child}) {
    return MergeSemantics(child: child);
  }

  // ═══════════════════════════════════════════════════════════════
  // COMMON LABELS
  // ═══════════════════════════════════════════════════════════════

  /// Standard labels for common actions
  static String addToCartLabel(String productName) =>
      'Add $productName to cart';

  static String removeFromCartLabel(String productName) =>
      'Remove $productName from cart';

  static String addToWishlistLabel(String productName) =>
      'Add $productName to wishlist';

  static String removeFromWishlistLabel(String productName) =>
      'Remove $productName from wishlist';

  static String productImageLabel(String productName) =>
      'Image of $productName';

  static String categoryImageLabel(String categoryName) =>
      'Category: $categoryName';

  static String ratingLabel(double rating, int reviewCount) =>
      'Rated $rating out of 5 stars, $reviewCount reviews';

  static String priceLabel(String price, {String? originalPrice}) {
    if (originalPrice != null) {
      return 'Price: $price, was $originalPrice';
    }
    return 'Price: $price';
  }

  static String quantityLabel(int quantity) => 'Quantity: $quantity';

  static String increaseQuantityLabel() => 'Increase quantity';

  static String decreaseQuantityLabel() => 'Decrease quantity';

  static String closeLabel() => 'Close';

  static String backLabel() => 'Go back';

  static String menuLabel() => 'Open menu';

  static String searchLabel() => 'Search products';

  static String filterLabel() => 'Filter products';

  static String sortLabel() => 'Sort products';

  static String cartLabel(int itemCount) => itemCount == 0
      ? 'Shopping cart, empty'
      : 'Shopping cart, $itemCount items';

  static String notificationLabel(int count) =>
      count == 0 ? 'Notifications, none' : 'Notifications, $count unread';
}

/// Extension for adding semantics to IconButton widgets
extension SemanticsIconButton on IconButton {
  Widget withSemantics(String label, {String? hint}) {
    return AppSemantics.button(
      child: this,
      label: label,
      hint: hint,
      onTap: onPressed,
      enabled: onPressed != null,
    );
  }
}

/// Extension for adding semantics to Container widgets (clickable)
extension SemanticsContainer on GestureDetector {
  Widget withButtonSemantics(String label, {String? hint}) {
    return AppSemantics.button(
      child: this,
      label: label,
      hint: hint,
      onTap: onTap,
    );
  }
}
