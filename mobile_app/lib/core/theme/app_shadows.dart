import 'package:flutter/material.dart';

/// Shadow definitions for consistent elevation
class AppShadows {
  AppShadows._();

  // ═══════════════════════════════════════════════════════════════
  // LIGHT THEME SHADOWS
  // ═══════════════════════════════════════════════════════════════

  /// No shadow
  static const List<BoxShadow> none = [];

  /// Extra small shadow (subtle)
  static const List<BoxShadow> xs = [
    BoxShadow(color: Color(0x0A000000), blurRadius: 2, offset: Offset(0, 1)),
  ];

  /// Small shadow
  static const List<BoxShadow> sm = [
    BoxShadow(color: Color(0x0F000000), blurRadius: 4, offset: Offset(0, 2)),
  ];

  /// Medium shadow (cards, buttons)
  static const List<BoxShadow> md = [
    BoxShadow(color: Color(0x14000000), blurRadius: 8, offset: Offset(0, 4)),
  ];

  /// Large shadow (modals, dropdowns)
  static const List<BoxShadow> lg = [
    BoxShadow(color: Color(0x19000000), blurRadius: 16, offset: Offset(0, 8)),
  ];

  /// Extra large shadow (popovers)
  static const List<BoxShadow> xl = [
    BoxShadow(color: Color(0x1F000000), blurRadius: 24, offset: Offset(0, 12)),
  ];

  /// 2XL shadow (dialogs)
  static const List<BoxShadow> xxl = [
    BoxShadow(color: Color(0x24000000), blurRadius: 32, offset: Offset(0, 16)),
  ];

  // ═══════════════════════════════════════════════════════════════
  // DARK THEME SHADOWS
  // ═══════════════════════════════════════════════════════════════

  /// Dark theme shadows are more subtle
  static const List<BoxShadow> darkSm = [
    BoxShadow(color: Color(0x40000000), blurRadius: 4, offset: Offset(0, 2)),
  ];

  static const List<BoxShadow> darkMd = [
    BoxShadow(color: Color(0x50000000), blurRadius: 8, offset: Offset(0, 4)),
  ];

  static const List<BoxShadow> darkLg = [
    BoxShadow(color: Color(0x60000000), blurRadius: 16, offset: Offset(0, 8)),
  ];

  // ═══════════════════════════════════════════════════════════════
  // COLORED SHADOWS
  // ═══════════════════════════════════════════════════════════════

  /// Primary color shadow (for primary buttons)
  static List<BoxShadow> primary = [
    BoxShadow(
      color: const Color(0xFF343434).withAlpha(51),
      blurRadius: 12,
      offset: const Offset(0, 4),
    ),
  ];

  /// Success color shadow
  static List<BoxShadow> success = [
    BoxShadow(
      color: const Color(0xFF22C55E).withAlpha(51),
      blurRadius: 12,
      offset: const Offset(0, 4),
    ),
  ];

  /// Error color shadow
  static List<BoxShadow> error = [
    BoxShadow(
      color: const Color(0xFFEF4444).withAlpha(51),
      blurRadius: 12,
      offset: const Offset(0, 4),
    ),
  ];

  // ═══════════════════════════════════════════════════════════════
  // SEMANTIC SHADOWS
  // ═══════════════════════════════════════════════════════════════

  /// Card shadow
  static const List<BoxShadow> card = sm;

  /// Elevated card shadow
  static const List<BoxShadow> cardElevated = md;

  /// Button shadow
  static const List<BoxShadow> button = sm;

  /// App bar shadow
  static const List<BoxShadow> appBar = xs;

  /// Bottom navigation shadow
  static const List<BoxShadow> bottomNav = [
    BoxShadow(color: Color(0x0F000000), blurRadius: 10, offset: Offset(0, -2)),
  ];

  /// Floating action button shadow
  static const List<BoxShadow> fab = lg;

  // ═══════════════════════════════════════════════════════════════
  // UTILITY
  // ═══════════════════════════════════════════════════════════════

  /// Get shadow based on theme brightness
  static List<BoxShadow> adaptive(
    BuildContext context,
    List<BoxShadow> light,
    List<BoxShadow> dark,
  ) {
    return Theme.of(context).brightness == Brightness.dark ? dark : light;
  }
}
