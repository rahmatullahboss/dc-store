import 'package:flutter/material.dart';
import 'package:dc_store/core/theme/app_colors.dart';
import 'package:dc_store/core/theme/app_text_styles.dart';

/// AppErrorWidget - Displays error states with retry option
///
/// Example usage:
/// ```dart
/// AppErrorWidget(
///   message: 'Failed to load products',
///   onRetry: () => fetchProducts(),
/// )
/// ```
class AppErrorWidget extends StatelessWidget {
  /// Error icon
  final IconData icon;

  /// Error title
  final String? title;

  /// Error message
  final String message;

  /// Retry button label
  final String retryLabel;

  /// Callback for retry
  final VoidCallback? onRetry;

  /// Whether to use compact layout
  final bool compact;

  const AppErrorWidget({
    super.key,
    this.icon = Icons.error_outline_rounded,
    this.title,
    required this.message,
    this.retryLabel = 'Try Again',
    this.onRetry,
    this.compact = false,
  });

  /// Network error preset
  factory AppErrorWidget.network({VoidCallback? onRetry}) {
    return AppErrorWidget(
      icon: Icons.wifi_off_rounded,
      title: 'No Internet Connection',
      message: 'Please check your network and try again',
      onRetry: onRetry,
    );
  }

  /// Server error preset
  factory AppErrorWidget.server({VoidCallback? onRetry}) {
    return AppErrorWidget(
      icon: Icons.cloud_off_rounded,
      title: 'Server Error',
      message: 'Something went wrong. Please try again later',
      onRetry: onRetry,
    );
  }

  /// Timeout error preset
  factory AppErrorWidget.timeout({VoidCallback? onRetry}) {
    return AppErrorWidget(
      icon: Icons.timer_off_rounded,
      title: 'Request Timeout',
      message: 'The request took too long. Please try again',
      onRetry: onRetry,
    );
  }

  /// Generic error preset
  factory AppErrorWidget.generic({String? message, VoidCallback? onRetry}) {
    return AppErrorWidget(
      icon: Icons.error_outline_rounded,
      title: 'Something Went Wrong',
      message: message ?? 'An unexpected error occurred',
      onRetry: onRetry,
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final iconSize = compact ? 48.0 : 64.0;

    return Center(
      child: Padding(
        padding: EdgeInsets.all(compact ? 16 : 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Error icon
            Container(
              width: iconSize + 24,
              height: iconSize + 24,
              decoration: BoxDecoration(
                color: AppColors.errorLight,
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: Icon(icon, size: iconSize, color: AppColors.error),
            ),
            SizedBox(height: compact ? 16 : 24),

            // Title
            if (title != null)
              Text(
                title!,
                style: (compact ? AppTextStyles.h5 : AppTextStyles.h4).copyWith(
                  color: isDark
                      ? AppColors.darkTextPrimary
                      : AppColors.textPrimary,
                ),
                textAlign: TextAlign.center,
              ),

            // Message
            if (title != null) const SizedBox(height: 8),
            Text(
              message,
              style:
                  (compact ? AppTextStyles.bodySmall : AppTextStyles.bodyMedium)
                      .copyWith(
                        color: isDark
                            ? AppColors.darkTextSecondary
                            : AppColors.textSecondary,
                      ),
              textAlign: TextAlign.center,
            ),

            // Retry button
            if (onRetry != null) ...[
              SizedBox(height: compact ? 16 : 24),
              ElevatedButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh_rounded, size: 18),
                label: Text(retryLabel),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(
                    horizontal: compact ? 20 : 28,
                    vertical: compact ? 10 : 14,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Inline error display for forms and small sections
class InlineError extends StatelessWidget {
  final String message;
  final VoidCallback? onDismiss;

  const InlineError({super.key, required this.message, this.onDismiss});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.errorLight,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.error.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Icon(Icons.error_outline_rounded, size: 18, color: AppColors.error),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              message,
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.errorDark,
              ),
            ),
          ),
          if (onDismiss != null) ...[
            const SizedBox(width: 8),
            GestureDetector(
              onTap: onDismiss,
              child: Icon(
                Icons.close_rounded,
                size: 18,
                color: AppColors.error,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
