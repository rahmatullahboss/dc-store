import 'package:flutter/material.dart';

/// Complete Color System for DC Store
/// Supports both Light and Dark themes with semantic naming
/// Matches web store theme: Primary #0F172A, Accent #3B82F6
class AppColors {
  AppColors._();

  // ═══════════════════════════════════════════════════════════════
  // BRAND COLORS (Matching Web Store)
  // ═══════════════════════════════════════════════════════════════

  /// Primary brand color - Slate theme (matches web)
  static const Color brandPrimary = Color(0xFF0F172A);
  static const Color brandAccent = Color(0xFF3B82F6);

  // Legacy gold colors (kept for backwards compatibility)
  static const Color goldDark = Color(0xFFB8860B);
  static const Color goldMedium = Color(0xFFDAA520);
  static const Color goldLight = Color(0xFFFFD700);

  // ═══════════════════════════════════════════════════════════════
  // LIGHT THEME COLORS
  // ═══════════════════════════════════════════════════════════════

  // Primary (Slate - matching web store)
  static const Color primary = Color(0xFF0F172A);
  static const Color primaryForeground = Color(0xFFFFFFFF);
  static const Color primaryLight = Color(0xFF334155);
  static const Color primaryDark = Color(0xFF020617);

  // Secondary
  static const Color secondary = Color(0xFFF1F5F9);
  static const Color secondaryForeground = Color(0xFF0F172A);

  // Accent (Blue - matching web store)
  static const Color accent = Color(0xFF3B82F6);
  static const Color accentForeground = Color(0xFFFFFFFF);

  // Background & Surface
  static const Color background = Colors.white;
  static const Color foreground = Color(0xFF252525);
  static const Color surface = Color(0xFFFAFAFA);
  static const Color surfaceVariant = Color(0xFFF5F5F5);

  // Card
  static const Color card = Colors.white;
  static const Color cardForeground = Color(0xFF252525);

  // Text Colors
  static const Color textPrimary = Color(0xFF1A1A1A);
  static const Color textSecondary = Color(0xFF666666);
  static const Color textHint = Color(0xFF9E9E9E);
  static const Color textDisabled = Color(0xFFBDBDBD);

  // Muted
  static const Color muted = Color(0xFFF7F7F7);
  static const Color mutedForeground = Color(0xFF8F8F8F);

  // Border & Input
  static const Color border = Color(0xFFEBEBEB);
  static const Color borderFocused = Color(0xFF343434);
  static const Color input = Color(0xFFEBEBEB);
  static const Color inputFocused = Color(0xFFE0E0E0);

  // ═══════════════════════════════════════════════════════════════
  // STATUS COLORS
  // ═══════════════════════════════════════════════════════════════

  // Success
  static const Color success = Color(0xFF22C55E);
  static const Color successLight = Color(0xFFDCFCE7);
  static const Color successDark = Color(0xFF16A34A);

  // Error / Destructive
  static const Color error = Color(0xFFEF4444);
  static const Color errorLight = Color(0xFFFEE2E2);
  static const Color errorDark = Color(0xFFDC2626);
  static const Color destructive = error;

  // Warning
  static const Color warning = Color(0xFFF59E0B);
  static const Color warningLight = Color(0xFFFEF3C7);
  static const Color warningDark = Color(0xFFD97706);

  // Info
  static const Color info = Color(0xFF3B82F6);
  static const Color infoLight = Color(0xFFDBEAFE);
  static const Color infoDark = Color(0xFF2563EB);

  // ═══════════════════════════════════════════════════════════════
  // DARK THEME COLORS
  // ═══════════════════════════════════════════════════════════════

  // Primary (Dark)
  static const Color darkPrimary = Color(0xFFEBEBEB);
  static const Color darkPrimaryForeground = Color(0xFF343434);

  // Secondary (Dark)
  static const Color darkSecondary = Color(0xFF454545);
  static const Color darkSecondaryForeground = Color(0xFFFAFAFA);

  // Background & Surface (Dark)
  static const Color darkBackground = Color(0xFF121212);
  static const Color darkForeground = Color(0xFFFAFAFA);
  static const Color darkSurface = Color(0xFF1E1E1E);
  static const Color darkSurfaceVariant = Color(0xFF2A2A2A);

  // Card (Dark)
  static const Color darkCard = Color(0xFF1E1E1E);
  static const Color darkCardForeground = Color(0xFFFAFAFA);

  // Text Colors (Dark)
  static const Color darkTextPrimary = Color(0xFFFAFAFA);
  static const Color darkTextSecondary = Color(0xFFB3B3B3);
  static const Color darkTextHint = Color(0xFF808080);
  static const Color darkTextDisabled = Color(0xFF5C5C5C);

  // Muted (Dark)
  static const Color darkMuted = Color(0xFF454545);
  static const Color darkMutedForeground = Color(0xFFB5B5B5);

  // Border & Input (Dark)
  static const Color darkBorder = Color(0xFF333333);
  static const Color darkBorderFocused = Color(0xFF666666);
  static const Color darkInput = Color(0xFF2A2A2A);
  static const Color darkInputFocused = Color(0xFF3A3A3A);

  // ═══════════════════════════════════════════════════════════════
  // GRADIENTS
  // ═══════════════════════════════════════════════════════════════

  static const LinearGradient brandGradient = LinearGradient(
    colors: [brandPrimary, primaryLight],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );

  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primary, primaryLight],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient accentGradient = LinearGradient(
    colors: [Color(0xFF2563EB), accent], // Blue gradient
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient successGradient = LinearGradient(
    colors: [successDark, success],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient errorGradient = LinearGradient(
    colors: [errorDark, error],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient shimmerGradient = LinearGradient(
    colors: [Color(0xFFEBEBEB), Color(0xFFF5F5F5), Color(0xFFEBEBEB)],
    stops: [0.0, 0.5, 1.0],
    begin: Alignment(-1.0, -0.3),
    end: Alignment(1.0, 0.3),
  );

  static const LinearGradient darkShimmerGradient = LinearGradient(
    colors: [Color(0xFF2A2A2A), Color(0xFF3A3A3A), Color(0xFF2A2A2A)],
    stops: [0.0, 0.5, 1.0],
    begin: Alignment(-1.0, -0.3),
    end: Alignment(1.0, 0.3),
  );

  // ═══════════════════════════════════════════════════════════════
  // UTILITY METHODS
  // ═══════════════════════════════════════════════════════════════

  /// Get color based on brightness
  static Color adaptive(BuildContext context, Color light, Color dark) {
    return Theme.of(context).brightness == Brightness.dark ? dark : light;
  }

  /// Get background color for current theme
  static Color getBackground(BuildContext context) {
    return adaptive(context, background, darkBackground);
  }

  /// Get text primary color for current theme
  static Color getTextPrimary(BuildContext context) {
    return adaptive(context, textPrimary, darkTextPrimary);
  }

  /// Get card color for current theme
  static Color getCard(BuildContext context) {
    return adaptive(context, card, darkCard);
  }
}
