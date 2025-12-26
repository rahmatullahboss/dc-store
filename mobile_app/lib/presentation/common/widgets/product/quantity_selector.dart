import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';

/// QuantitySelector - Plus/minus buttons for quantity selection
///
/// Example usage:
/// ```dart
/// QuantitySelector(
///   value: quantity,
///   min: 1,
///   max: 10,
///   onChanged: (value) => setState(() => quantity = value),
/// )
/// ```
class QuantitySelector extends StatelessWidget {
  /// Current quantity value
  final int value;

  /// Minimum allowed value
  final int min;

  /// Maximum allowed value
  final int max;

  /// Callback when value changes
  final ValueChanged<int> onChanged;

  /// Whether the selector is enabled
  final bool enabled;

  /// Size variant
  final QuantitySelectorSize size;

  /// Whether to use compact style
  final bool compact;

  const QuantitySelector({
    super.key,
    required this.value,
    this.min = 1,
    this.max = 99,
    required this.onChanged,
    this.enabled = true,
    this.size = QuantitySelectorSize.medium,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final canDecrement = enabled && value > min;
    final canIncrement = enabled && value < max;

    if (compact) {
      return _buildCompact(isDark, canDecrement, canIncrement);
    }

    return _buildStandard(isDark, canDecrement, canIncrement);
  }

  Widget _buildStandard(bool isDark, bool canDecrement, bool canIncrement) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.surface,
        borderRadius: BorderRadius.circular(_getBorderRadius()),
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.border,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildButton(
            icon: Icons.remove,
            onTap: canDecrement ? () => onChanged(value - 1) : null,
            isDark: isDark,
            enabled: canDecrement,
          ),
          Container(
            constraints: BoxConstraints(minWidth: _getValueWidth()),
            alignment: Alignment.center,
            padding: EdgeInsets.symmetric(horizontal: _getValuePadding()),
            child: Text(
              value.toString(),
              style: _getValueStyle(isDark),
              textAlign: TextAlign.center,
            ),
          ),
          _buildButton(
            icon: Icons.add,
            onTap: canIncrement ? () => onChanged(value + 1) : null,
            isDark: isDark,
            enabled: canIncrement,
          ),
        ],
      ),
    );
  }

  Widget _buildCompact(bool isDark, bool canDecrement, bool canIncrement) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildCompactButton(
          icon: Icons.remove,
          onTap: canDecrement ? () => onChanged(value - 1) : null,
          isDark: isDark,
          enabled: canDecrement,
        ),
        SizedBox(
          width: _getValueWidth(),
          child: Text(
            value.toString(),
            style: _getValueStyle(isDark),
            textAlign: TextAlign.center,
          ),
        ),
        _buildCompactButton(
          icon: Icons.add,
          onTap: canIncrement ? () => onChanged(value + 1) : null,
          isDark: isDark,
          enabled: canIncrement,
        ),
      ],
    );
  }

  Widget _buildButton({
    required IconData icon,
    required VoidCallback? onTap,
    required bool isDark,
    required bool enabled,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(_getBorderRadius()),
        child: Container(
          width: _getButtonSize(),
          height: _getButtonSize(),
          alignment: Alignment.center,
          child: Icon(
            icon,
            size: _getIconSize(),
            color: enabled
                ? (isDark ? AppColors.darkTextPrimary : AppColors.textPrimary)
                : (isDark
                      ? AppColors.darkTextDisabled
                      : AppColors.textDisabled),
          ),
        ),
      ),
    );
  }

  Widget _buildCompactButton({
    required IconData icon,
    required VoidCallback? onTap,
    required bool isDark,
    required bool enabled,
  }) {
    return Material(
      color: enabled
          ? (isDark ? AppColors.darkSurface : AppColors.surface)
          : Colors.transparent,
      borderRadius: BorderRadius.circular(_getBorderRadius()),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(_getBorderRadius()),
        child: Container(
          width: _getButtonSize(),
          height: _getButtonSize(),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(_getBorderRadius()),
            border: Border.all(
              color: enabled
                  ? (isDark ? AppColors.darkBorder : AppColors.border)
                  : Colors.transparent,
            ),
          ),
          child: Icon(
            icon,
            size: _getIconSize(),
            color: enabled
                ? (isDark ? AppColors.darkTextPrimary : AppColors.textPrimary)
                : (isDark
                      ? AppColors.darkTextDisabled
                      : AppColors.textDisabled),
          ),
        ),
      ),
    );
  }

  TextStyle _getValueStyle(bool isDark) {
    final color = enabled
        ? (isDark ? AppColors.darkTextPrimary : AppColors.textPrimary)
        : (isDark ? AppColors.darkTextDisabled : AppColors.textDisabled);

    switch (size) {
      case QuantitySelectorSize.small:
        return AppTextStyles.labelMedium.copyWith(color: color);
      case QuantitySelectorSize.medium:
        return AppTextStyles.labelLarge.copyWith(color: color);
      case QuantitySelectorSize.large:
        return AppTextStyles.h6.copyWith(color: color);
    }
  }

  double _getButtonSize() {
    switch (size) {
      case QuantitySelectorSize.small:
        return 28;
      case QuantitySelectorSize.medium:
        return 36;
      case QuantitySelectorSize.large:
        return 44;
    }
  }

  double _getIconSize() {
    switch (size) {
      case QuantitySelectorSize.small:
        return 16;
      case QuantitySelectorSize.medium:
        return 20;
      case QuantitySelectorSize.large:
        return 24;
    }
  }

  double _getValueWidth() {
    switch (size) {
      case QuantitySelectorSize.small:
        return 28;
      case QuantitySelectorSize.medium:
        return 36;
      case QuantitySelectorSize.large:
        return 44;
    }
  }

  double _getValuePadding() {
    switch (size) {
      case QuantitySelectorSize.small:
        return 4;
      case QuantitySelectorSize.medium:
        return 8;
      case QuantitySelectorSize.large:
        return 12;
    }
  }

  double _getBorderRadius() {
    switch (size) {
      case QuantitySelectorSize.small:
        return 4;
      case QuantitySelectorSize.medium:
        return 6;
      case QuantitySelectorSize.large:
        return 8;
    }
  }
}

enum QuantitySelectorSize { small, medium, large }
