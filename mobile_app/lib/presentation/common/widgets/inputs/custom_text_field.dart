import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';

/// Enum for text field variants
enum TextFieldVariant { outlined, filled, underlined }

/// Enum for text field types
enum TextFieldType { text, email, password, phone, number, multiline, search }

/// CustomTextField - A fully customizable text input component
///
/// Supports multiple variants, validation, and input types.
///
/// Example usage:
/// ```dart
/// CustomTextField(
///   label: 'Email',
///   hint: 'Enter your email',
///   type: TextFieldType.email,
///   validator: (value) => Validators.email(value),
/// )
/// ```
class CustomTextField extends StatefulWidget {
  /// Text field label
  final String? label;

  /// Placeholder text
  final String? hint;

  /// Text editing controller
  final TextEditingController? controller;

  /// Text field variant
  final TextFieldVariant variant;

  /// Text field type
  final TextFieldType type;

  /// Validation function
  final String? Function(String?)? validator;

  /// On changed callback
  final ValueChanged<String>? onChanged;

  /// On submitted callback
  final ValueChanged<String>? onSubmitted;

  /// Focus node
  final FocusNode? focusNode;

  /// Prefix icon
  final IconData? prefixIcon;

  /// Suffix icon
  final IconData? suffixIcon;

  /// Suffix icon callback
  final VoidCallback? onSuffixTap;

  /// Whether the field is enabled
  final bool enabled;

  /// Whether the field is read-only
  final bool readOnly;

  /// Auto-focus
  final bool autofocus;

  /// Max length
  final int? maxLength;

  /// Max lines (for multiline)
  final int? maxLines;

  /// Min lines (for multiline)
  final int? minLines;

  /// Input formatters
  final List<TextInputFormatter>? inputFormatters;

  /// Helper text
  final String? helperText;

  /// Error text (overrides validator)
  final String? errorText;

  /// Custom border radius
  final double? borderRadius;

  /// Custom content padding
  final EdgeInsetsGeometry? contentPadding;

  /// Filled color (for filled variant)
  final Color? fillColor;

  const CustomTextField({
    super.key,
    this.label,
    this.hint,
    this.controller,
    this.variant = TextFieldVariant.outlined,
    this.type = TextFieldType.text,
    this.validator,
    this.onChanged,
    this.onSubmitted,
    this.focusNode,
    this.prefixIcon,
    this.suffixIcon,
    this.onSuffixTap,
    this.enabled = true,
    this.readOnly = false,
    this.autofocus = false,
    this.maxLength,
    this.maxLines,
    this.minLines,
    this.inputFormatters,
    this.helperText,
    this.errorText,
    this.borderRadius,
    this.contentPadding,
    this.fillColor,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  late bool _obscureText;
  late FocusNode _focusNode;
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.type == TextFieldType.password;
    _focusNode = widget.focusNode ?? FocusNode();
    _focusNode.addListener(_onFocusChange);
  }

  @override
  void dispose() {
    if (widget.focusNode == null) {
      _focusNode.dispose();
    }
    super.dispose();
  }

  void _onFocusChange() {
    setState(() {
      _isFocused = _focusNode.hasFocus;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (widget.label != null) ...[
          Text(
            widget.label!,
            style: AppTextStyles.labelMedium.copyWith(
              color: isDark
                  ? AppColors.darkTextSecondary
                  : AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 8),
        ],
        TextFormField(
          controller: widget.controller,
          focusNode: _focusNode,
          obscureText: _obscureText,
          enabled: widget.enabled,
          readOnly: widget.readOnly,
          autofocus: widget.autofocus,
          maxLength: widget.maxLength,
          maxLines: widget.type == TextFieldType.multiline
              ? widget.maxLines ?? 4
              : 1,
          minLines: widget.type == TextFieldType.multiline
              ? widget.minLines ?? 2
              : 1,
          keyboardType: _getKeyboardType(),
          textInputAction: _getTextInputAction(),
          inputFormatters: widget.inputFormatters ?? _getInputFormatters(),
          validator: widget.validator,
          onChanged: widget.onChanged,
          onFieldSubmitted: widget.onSubmitted,
          style: AppTextStyles.bodyMedium.copyWith(
            color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
          ),
          decoration: _buildDecoration(isDark),
        ),
        if (widget.helperText != null && widget.errorText == null) ...[
          const SizedBox(height: 4),
          Text(
            widget.helperText!,
            style: AppTextStyles.caption.copyWith(
              color: isDark ? AppColors.darkTextHint : AppColors.textHint,
            ),
          ),
        ],
      ],
    );
  }

  InputDecoration _buildDecoration(bool isDark) {
    return InputDecoration(
      hintText: widget.hint,
      hintStyle: AppTextStyles.bodyMedium.copyWith(
        color: isDark ? AppColors.darkTextHint : AppColors.textHint,
      ),
      errorText: widget.errorText,
      errorStyle: AppTextStyles.caption.copyWith(color: AppColors.error),
      prefixIcon: widget.prefixIcon != null
          ? Icon(
              widget.prefixIcon,
              size: 20,
              color: _isFocused
                  ? (isDark ? AppColors.darkPrimary : AppColors.primary)
                  : (isDark ? AppColors.darkTextHint : AppColors.textHint),
            )
          : null,
      suffixIcon: _buildSuffixIcon(isDark),
      contentPadding:
          widget.contentPadding ??
          const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      filled: widget.variant == TextFieldVariant.filled,
      fillColor:
          widget.fillColor ??
          (isDark ? AppColors.darkInput : AppColors.surfaceVariant),
      border: _getBorder(isDark, isError: false, isFocused: false),
      enabledBorder: _getBorder(isDark, isError: false, isFocused: false),
      focusedBorder: _getBorder(isDark, isError: false, isFocused: true),
      errorBorder: _getBorder(isDark, isError: true, isFocused: false),
      focusedErrorBorder: _getBorder(isDark, isError: true, isFocused: true),
      disabledBorder: _getBorder(
        isDark,
        isError: false,
        isFocused: false,
        isDisabled: true,
      ),
    );
  }

  Widget? _buildSuffixIcon(bool isDark) {
    if (widget.type == TextFieldType.password) {
      return GestureDetector(
        onTap: () => setState(() => _obscureText = !_obscureText),
        child: Icon(
          _obscureText
              ? Icons.visibility_off_outlined
              : Icons.visibility_outlined,
          size: 20,
          color: isDark ? AppColors.darkTextHint : AppColors.textHint,
        ),
      );
    }

    if (widget.type == TextFieldType.search) {
      return GestureDetector(
        onTap: widget.onSuffixTap ?? () => widget.controller?.clear(),
        child: Icon(
          Icons.close,
          size: 20,
          color: isDark ? AppColors.darkTextHint : AppColors.textHint,
        ),
      );
    }

    if (widget.suffixIcon != null) {
      return GestureDetector(
        onTap: widget.onSuffixTap,
        child: Icon(
          widget.suffixIcon,
          size: 20,
          color: isDark ? AppColors.darkTextHint : AppColors.textHint,
        ),
      );
    }

    return null;
  }

  InputBorder _getBorder(
    bool isDark, {
    required bool isError,
    required bool isFocused,
    bool isDisabled = false,
  }) {
    Color borderColor;
    if (isDisabled) {
      borderColor = isDark ? AppColors.darkBorder : AppColors.border;
    } else if (isError) {
      borderColor = AppColors.error;
    } else if (isFocused) {
      borderColor = isDark
          ? AppColors.darkBorderFocused
          : AppColors.borderFocused;
    } else {
      borderColor = isDark ? AppColors.darkBorder : AppColors.border;
    }

    final radius = BorderRadius.circular(widget.borderRadius ?? 8);

    switch (widget.variant) {
      case TextFieldVariant.outlined:
        return OutlineInputBorder(
          borderRadius: radius,
          borderSide: BorderSide(color: borderColor, width: isFocused ? 2 : 1),
        );
      case TextFieldVariant.filled:
        return OutlineInputBorder(
          borderRadius: radius,
          borderSide: BorderSide.none,
        );
      case TextFieldVariant.underlined:
        return UnderlineInputBorder(
          borderSide: BorderSide(color: borderColor, width: isFocused ? 2 : 1),
        );
    }
  }

  TextInputType _getKeyboardType() {
    switch (widget.type) {
      case TextFieldType.email:
        return TextInputType.emailAddress;
      case TextFieldType.phone:
        return TextInputType.phone;
      case TextFieldType.number:
        return TextInputType.number;
      case TextFieldType.multiline:
        return TextInputType.multiline;
      case TextFieldType.search:
        return TextInputType.text;
      default:
        return TextInputType.text;
    }
  }

  TextInputAction _getTextInputAction() {
    switch (widget.type) {
      case TextFieldType.multiline:
        return TextInputAction.newline;
      case TextFieldType.search:
        return TextInputAction.search;
      default:
        return TextInputAction.next;
    }
  }

  List<TextInputFormatter> _getInputFormatters() {
    switch (widget.type) {
      case TextFieldType.phone:
        return [FilteringTextInputFormatter.digitsOnly];
      case TextFieldType.number:
        return [FilteringTextInputFormatter.digitsOnly];
      default:
        return [];
    }
  }
}

/// Search text field with specific styling
class SearchTextField extends StatelessWidget {
  final TextEditingController? controller;
  final String? hint;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final VoidCallback? onClear;
  final bool autofocus;

  const SearchTextField({
    super.key,
    this.controller,
    this.hint = 'Search...',
    this.onChanged,
    this.onSubmitted,
    this.onClear,
    this.autofocus = false,
  });

  @override
  Widget build(BuildContext context) {
    return CustomTextField(
      controller: controller,
      hint: hint,
      type: TextFieldType.search,
      variant: TextFieldVariant.filled,
      prefixIcon: Icons.search,
      onChanged: onChanged,
      onSubmitted: onSubmitted,
      onSuffixTap: onClear,
      autofocus: autofocus,
      borderRadius: 24,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    );
  }
}
