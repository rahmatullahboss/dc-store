/// Core utility functions for the app
library;

class AppUtils {
  AppUtils._();

  /// Format price with currency symbol
  static String formatPrice(double price, {String currency = '৳'}) {
    return '$currency${price.toStringAsFixed(2)}';
  }

  /// Truncate text with ellipsis
  static String truncateText(String text, int maxLength) {
    if (text.length <= maxLength) return text;
    return '${text.substring(0, maxLength)}...';
  }

  /// Validate email format
  static bool isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  /// Validate Bangladesh phone number
  static bool isValidBDPhone(String phone) {
    return RegExp(r'^01[3-9]\d{8}$').hasMatch(phone);
  }

  /// Get initials from name
  static String getInitials(String name) {
    final words = name.trim().split(' ');
    if (words.isEmpty) return '';
    if (words.length == 1) return words[0][0].toUpperCase();
    return '${words[0][0]}${words[words.length - 1][0]}'.toUpperCase();
  }
}
