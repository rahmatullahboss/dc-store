import 'package:flutter/material.dart';

class AppColors {
  // Brand Gradient Colors
  static const Color goldDark = Color(0xFFB8860B);
  static const Color goldMedium = Color(0xFFDAA520);
  static const Color goldLight = Color(0xFFFFD700);

  static const LinearGradient brandGradient = LinearGradient(
    colors: [goldDark, goldMedium, goldLight],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );

  // Light Mode Colors (Approximated from oklch)
  static const Color background = Colors.white; // oklch(1 0 0)
  static const Color foreground = Color(0xFF252525); // oklch(0.145 0 0)
  static const Color card = Colors.white;
  static const Color cardForeground = Color(0xFF252525);
  static const Color primary = Color(0xFF343434); // oklch(0.205 0 0)
  static const Color primaryForeground = Color(0xFFFAFAFA); // oklch(0.985 0 0)
  static const Color secondary = Color(0xFFF7F7F7); // oklch(0.97 0 0)
  static const Color secondaryForeground = Color(0xFF343434);
  static const Color muted = Color(0xFFF7F7F7);
  static const Color mutedForeground = Color(0xFF8F8F8F); // oklch(0.556 0 0)
  static const Color destructive = Color(0xFFEF4444); // Approx red
  static const Color border = Color(0xFFEBEBEB); // oklch(0.922 0 0)
  static const Color input = Color(0xFFEBEBEB);

  // Dark Mode Colors
  static const Color darkBackground = Color(0xFF252525); // oklch(0.145 0 0)
  static const Color darkForeground = Color(0xFFFAFAFA); // oklch(0.985 0 0)
  static const Color darkCard = Color(0xFF343434); // oklch(0.205 0 0)
  static const Color darkCardForeground = Color(0xFFFAFAFA);
  static const Color darkPrimary = Color(0xFFEBEBEB); // oklch(0.922 0 0)
  static const Color darkPrimaryForeground = Color(0xFF343434);
  static const Color darkSecondary = Color(0xFF454545); // oklch(0.269 0 0)
  static const Color darkSecondaryForeground = Color(0xFFFAFAFA);
  static const Color darkMuted = Color(0xFF454545);
  static const Color darkMutedForeground = Color(0xFFB5B5B5); // oklch(0.708 0 0)
  static const Color darkBorder = Color(0x1AFFFFFF); // oklch(1 0 0 / 10%)
}
