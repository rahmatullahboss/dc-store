import 'package:flutter/material.dart';
import 'package:dc_store/core/theme/app_colors.dart';
import 'package:dc_store/core/theme/app_text_styles.dart';

/// Enum for button variants
enum ButtonVariant { primary, secondary, outlined, text, gradient }

/// Enum for button sizes
enum ButtonSize { small, medium, large }

/// CustomButton - A fully customizable button component
///
/// Supports multiple variants, sizes, loading state, and icons.
///
/// Example usage:
/// ```dart
/// CustomButton(
///   text: 'Add to Cart',
///   onPressed: () => addToCart(),
///   variant: ButtonVariant.primary,
///   isLoading: isAdding,
///   leadingIcon: Icons.shopping_cart,
/// )
/// ```
class CustomButton extends StatelessWidget {
  /// Button text
  final String text;

  /// Callback when button is pressed
  final VoidCallback? onPressed;

  /// Button variant (primary, secondary, outlined, text, gradient)
  final ButtonVariant variant;

  /// Button size (small, medium, large)
  final ButtonSize size;

  /// Whether the button is in loading state
  final bool isLoading;

  /// Whether the button is disabled
  final bool isDisabled;

  /// Leading icon (before text)
  final IconData? leadingIcon;

  /// Trailing icon (after text)
  final IconData? trailingIcon;

  /// Full width button
  final bool fullWidth;

  /// Custom border radius
  final double? borderRadius;

  /// Custom padding
  final EdgeInsetsGeometry? padding;

  /// Custom background color (overrides variant)
  final Color? backgroundColor;

  /// Custom foreground color (overrides variant)
  final Color? foregroundColor;

  /// Custom gradient (only for gradient variant)
  final Gradient? gradient;

  const CustomButton({
    super.key,
    required this.text,
    this.onPressed,
    this.variant = ButtonVariant.primary,
    this.size = ButtonSize.medium,
    this.isLoading = false,
    this.isDisabled = false,
    this.leadingIcon,
    this.trailingIcon,
    this.fullWidth = false,
    this.borderRadius,
    this.padding,
    this.backgroundColor,
    this.foregroundColor,
    this.gradient,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final effectiveDisabled = isDisabled || isLoading;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      width: fullWidth ? double.infinity : null,
      decoration: _getDecoration(isDark, effectiveDisabled),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: effectiveDisabled ? null : onPressed,
          borderRadius: BorderRadius.circular(
            borderRadius ?? _getBorderRadius(),
          ),
          child: Padding(
            padding: padding ?? _getPadding(),
            child: Row(
              mainAxisSize: fullWidth ? MainAxisSize.max : MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (isLoading) ...[
                  SizedBox(
                    width: _getIconSize(),
                    height: _getIconSize(),
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation(
                        _getForegroundColor(isDark, effectiveDisabled),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                ] else if (leadingIcon != null) ...[
                  Icon(
                    leadingIcon,
                    size: _getIconSize(),
                    color: _getForegroundColor(isDark, effectiveDisabled),
                  ),
                  const SizedBox(width: 8),
                ],
                Text(text, style: _getTextStyle(isDark, effectiveDisabled)),
                if (trailingIcon != null && !isLoading) ...[
                  const SizedBox(width: 8),
                  Icon(
                    trailingIcon,
                    size: _getIconSize(),
                    color: _getForegroundColor(isDark, effectiveDisabled),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  BoxDecoration? _getDecoration(bool isDark, bool disabled) {
    if (variant == ButtonVariant.gradient && !disabled) {
      return BoxDecoration(
        gradient: gradient ?? AppColors.brandGradient,
        borderRadius: BorderRadius.circular(borderRadius ?? _getBorderRadius()),
        boxShadow: [
          BoxShadow(
            color: AppColors.goldMedium.withValues(alpha: 0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      );
    }

    if (variant == ButtonVariant.outlined) {
      return BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(borderRadius ?? _getBorderRadius()),
        border: Border.all(
          color: disabled
              ? AppColors.border
              : (backgroundColor ??
                    (isDark ? AppColors.darkPrimary : AppColors.primary)),
          width: 1.5,
        ),
      );
    }

    if (variant == ButtonVariant.text) {
      return null;
    }

    return BoxDecoration(
      color: _getBackgroundColor(isDark, disabled),
      borderRadius: BorderRadius.circular(borderRadius ?? _getBorderRadius()),
    );
  }

  Color _getBackgroundColor(bool isDark, bool disabled) {
    if (disabled) {
      return isDark ? AppColors.darkMuted : AppColors.muted;
    }

    if (backgroundColor != null) return backgroundColor!;

    switch (variant) {
      case ButtonVariant.primary:
        return isDark ? AppColors.darkPrimary : AppColors.primary;
      case ButtonVariant.secondary:
        return isDark ? AppColors.darkSecondary : AppColors.secondary;
      case ButtonVariant.outlined:
      case ButtonVariant.text:
        return Colors.transparent;
      case ButtonVariant.gradient:
        return AppColors.goldMedium;
    }
  }

  Color _getForegroundColor(bool isDark, bool disabled) {
    if (disabled) {
      return isDark ? AppColors.darkTextDisabled : AppColors.textDisabled;
    }

    if (foregroundColor != null) return foregroundColor!;

    switch (variant) {
      case ButtonVariant.primary:
        return isDark
            ? AppColors.darkPrimaryForeground
            : AppColors.primaryForeground;
      case ButtonVariant.secondary:
        return isDark
            ? AppColors.darkSecondaryForeground
            : AppColors.secondaryForeground;
      case ButtonVariant.outlined:
      case ButtonVariant.text:
        return isDark ? AppColors.darkPrimary : AppColors.primary;
      case ButtonVariant.gradient:
        return AppColors.accentForeground;
    }
  }

  TextStyle _getTextStyle(bool isDark, bool disabled) {
    TextStyle baseStyle;
    switch (size) {
      case ButtonSize.small:
        baseStyle = AppTextStyles.buttonSmall;
        break;
      case ButtonSize.medium:
        baseStyle = AppTextStyles.buttonMedium;
        break;
      case ButtonSize.large:
        baseStyle = AppTextStyles.buttonLarge;
        break;
    }
    return baseStyle.copyWith(color: _getForegroundColor(isDark, disabled));
  }

  EdgeInsetsGeometry _getPadding() {
    switch (size) {
      case ButtonSize.small:
        return const EdgeInsets.symmetric(horizontal: 12, vertical: 8);
      case ButtonSize.medium:
        return const EdgeInsets.symmetric(horizontal: 16, vertical: 12);
      case ButtonSize.large:
        return const EdgeInsets.symmetric(horizontal: 24, vertical: 16);
    }
  }

  double _getBorderRadius() {
    switch (size) {
      case ButtonSize.small:
        return 6;
      case ButtonSize.medium:
        return 8;
      case ButtonSize.large:
        return 12;
    }
  }

  double _getIconSize() {
    switch (size) {
      case ButtonSize.small:
        return 16;
      case ButtonSize.medium:
        return 20;
      case ButtonSize.large:
        return 24;
    }
  }
}

/// Icon-only button variant
class CustomIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onPressed;
  final ButtonVariant variant;
  final ButtonSize size;
  final bool isLoading;
  final bool isDisabled;
  final Color? backgroundColor;
  final Color? iconColor;
  final String? tooltip;

  const CustomIconButton({
    super.key,
    required this.icon,
    this.onPressed,
    this.variant = ButtonVariant.primary,
    this.size = ButtonSize.medium,
    this.isLoading = false,
    this.isDisabled = false,
    this.backgroundColor,
    this.iconColor,
    this.tooltip,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final effectiveDisabled = isDisabled || isLoading;

    final double iconSize = size == ButtonSize.small
        ? 18
        : size == ButtonSize.medium
        ? 22
        : 26;

    final double buttonSize = size == ButtonSize.small
        ? 36
        : size == ButtonSize.medium
        ? 44
        : 52;

    Widget button = Container(
      width: buttonSize,
      height: buttonSize,
      decoration: _getDecoration(isDark, effectiveDisabled),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: effectiveDisabled ? null : onPressed,
          borderRadius: BorderRadius.circular(buttonSize / 2),
          child: Center(
            child: isLoading
                ? SizedBox(
                    width: iconSize,
                    height: iconSize,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation(
                        _getForegroundColor(isDark, effectiveDisabled),
                      ),
                    ),
                  )
                : Icon(
                    icon,
                    size: iconSize,
                    color: _getForegroundColor(isDark, effectiveDisabled),
                  ),
          ),
        ),
      ),
    );

    if (tooltip != null) {
      return Tooltip(message: tooltip!, child: button);
    }

    return button;
  }

  BoxDecoration _getDecoration(bool isDark, bool disabled) {
    if (variant == ButtonVariant.outlined) {
      return BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: disabled
              ? AppColors.border
              : (backgroundColor ??
                    (isDark ? AppColors.darkPrimary : AppColors.primary)),
        ),
      );
    }

    if (variant == ButtonVariant.text) {
      return const BoxDecoration(shape: BoxShape.circle);
    }

    return BoxDecoration(
      shape: BoxShape.circle,
      color: disabled
          ? (isDark ? AppColors.darkMuted : AppColors.muted)
          : (backgroundColor ??
                (isDark ? AppColors.darkPrimary : AppColors.primary)),
    );
  }

  Color _getForegroundColor(bool isDark, bool disabled) {
    if (disabled) {
      return isDark ? AppColors.darkTextDisabled : AppColors.textDisabled;
    }

    if (iconColor != null) return iconColor!;

    switch (variant) {
      case ButtonVariant.primary:
        return isDark
            ? AppColors.darkPrimaryForeground
            : AppColors.primaryForeground;
      case ButtonVariant.secondary:
        return isDark
            ? AppColors.darkSecondaryForeground
            : AppColors.secondaryForeground;
      case ButtonVariant.outlined:
      case ButtonVariant.text:
        return isDark ? AppColors.darkPrimary : AppColors.primary;
      case ButtonVariant.gradient:
        return AppColors.accentForeground;
    }
  }
}
