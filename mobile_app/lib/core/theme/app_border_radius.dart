import 'package:flutter/material.dart';

/// Border Radius Constants for consistent rounded corners
class AppBorderRadius {
  AppBorderRadius._();

  // ═══════════════════════════════════════════════════════════════
  // BASE VALUES
  // ═══════════════════════════════════════════════════════════════

  static const double none = 0.0;
  static const double xs = 4.0;
  static const double sm = 8.0;
  static const double md = 12.0;
  static const double lg = 16.0;
  static const double xl = 20.0;
  static const double xxl = 24.0;
  static const double xxxl = 32.0;
  static const double full = 9999.0;

  // ═══════════════════════════════════════════════════════════════
  // BORDER RADIUS OBJECTS
  // ═══════════════════════════════════════════════════════════════

  static final BorderRadius noneRadius = BorderRadius.circular(none);
  static final BorderRadius xsRadius = BorderRadius.circular(xs);
  static final BorderRadius smRadius = BorderRadius.circular(sm);
  static final BorderRadius mdRadius = BorderRadius.circular(md);
  static final BorderRadius lgRadius = BorderRadius.circular(lg);
  static final BorderRadius xlRadius = BorderRadius.circular(xl);
  static final BorderRadius xxlRadius = BorderRadius.circular(xxl);
  static final BorderRadius xxxlRadius = BorderRadius.circular(xxxl);
  static final BorderRadius fullRadius = BorderRadius.circular(full);

  // ═══════════════════════════════════════════════════════════════
  // SEMANTIC RADIUS
  // ═══════════════════════════════════════════════════════════════

  /// Card border radius
  static final BorderRadius card = BorderRadius.circular(lg);

  /// Button border radius
  static final BorderRadius button = BorderRadius.circular(md);

  /// Input field border radius
  static final BorderRadius input = BorderRadius.circular(sm);

  /// Chip/Badge border radius
  static final BorderRadius chip = BorderRadius.circular(full);

  /// Bottom sheet border radius (top only)
  static final BorderRadius bottomSheet = const BorderRadius.only(
    topLeft: Radius.circular(24),
    topRight: Radius.circular(24),
  );

  /// Modal border radius
  static final BorderRadius modal = BorderRadius.circular(xxl);

  /// Image border radius
  static final BorderRadius image = BorderRadius.circular(md);

  /// Avatar border radius (circular)
  static final BorderRadius avatar = BorderRadius.circular(full);
}
