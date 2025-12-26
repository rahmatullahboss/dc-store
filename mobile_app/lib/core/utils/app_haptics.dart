import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Utility class for adding haptic feedback to interactions.
/// Provides consistent feedback across the app.
class AppHaptics {
  AppHaptics._();

  /// Light haptic feedback for taps on buttons, switches, etc.
  static void lightImpact() {
    HapticFeedback.lightImpact();
  }

  /// Medium haptic feedback for selection changes
  static void mediumImpact() {
    HapticFeedback.mediumImpact();
  }

  /// Heavy haptic feedback for significant actions
  static void heavyImpact() {
    HapticFeedback.heavyImpact();
  }

  /// Selection haptic feedback (iOS style)
  static void selectionClick() {
    HapticFeedback.selectionClick();
  }

  /// Vibrate for errors or warnings
  static void vibrate() {
    HapticFeedback.vibrate();
  }
}

/// Extension on Widget to easily add haptic feedback
extension HapticWidget on Widget {
  /// Wraps widget with GestureDetector that adds haptic feedback on tap
  Widget withHapticFeedback({
    VoidCallback? onTap,
    HapticFeedbackType type = HapticFeedbackType.light,
  }) {
    return GestureDetector(
      onTap: () {
        switch (type) {
          case HapticFeedbackType.light:
            AppHaptics.lightImpact();
          case HapticFeedbackType.medium:
            AppHaptics.mediumImpact();
          case HapticFeedbackType.heavy:
            AppHaptics.heavyImpact();
          case HapticFeedbackType.selection:
            AppHaptics.selectionClick();
        }
        onTap?.call();
      },
      child: this,
    );
  }
}

enum HapticFeedbackType { light, medium, heavy, selection }
