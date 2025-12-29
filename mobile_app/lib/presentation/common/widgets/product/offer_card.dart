import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:toastification/toastification.dart';
import 'package:dc_store/core/theme/app_colors.dart';

/// OfferType - Types of promotional offers
enum OfferType { bank, special, coupon }

/// OfferCard - Promotional offer card with coupon code
///
/// Example usage:
/// ```dart
/// OfferCard(
///   type: OfferType.bank,
///   title: '10% Instant Discount on Citi Cards',
///   code: 'CITI10',
///   subtitle: 'Bank Offer',
///   logoUrl: 'https://example.com/citi.png',
/// )
/// ```
class OfferCard extends StatelessWidget {
  /// Type of offer (affects styling)
  final OfferType type;

  /// Main offer title/description
  final String title;

  /// Coupon code
  final String code;

  /// Subtitle/category label
  final String subtitle;

  /// Optional logo URL (for bank offers)
  final String? logoUrl;

  /// Card width
  final double width;

  const OfferCard({
    super.key,
    required this.type,
    required this.title,
    required this.code,
    required this.subtitle,
    this.logoUrl,
    this.width = 256,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: width,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        gradient: _getGradient(isDark),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _getBorderColor(isDark)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header row with subtitle and logo
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Subtitle/Category
                    Text(
                      subtitle.toUpperCase(),
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                        color: _getAccentColor(),
                      ),
                    ),
                    const SizedBox(height: 4),
                    // Title
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: isDark ? Colors.white : AppColors.textPrimary,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              if (logoUrl != null)
                Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: Image.network(
                    logoUrl!,
                    height: 16,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stack) =>
                        const SizedBox.shrink(),
                  ),
                ),
            ],
          ),

          const SizedBox(height: 12),

          // Coupon code row
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.darkCard : Colors.white,
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(
                    color: isDark ? AppColors.darkBorder : AppColors.border,
                    style: BorderStyle.solid,
                  ),
                ),
                child: Text(
                  code,
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                    color: isDark ? Colors.grey[400] : AppColors.textSecondary,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              GestureDetector(
                onTap: () => _copyCode(context),
                child: Text(
                  'Tap to copy',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                    color: AppColors.accent,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _copyCode(BuildContext context) {
    Clipboard.setData(ClipboardData(text: code));
    toastification.show(
      context: context,
      type: ToastificationType.success,
      style: ToastificationStyle.minimal,
      title: const Text('Code copied!'),
      description: Text(code),
      autoCloseDuration: const Duration(seconds: 2),
    );
  }

  LinearGradient _getGradient(bool isDark) {
    switch (type) {
      case OfferType.bank:
        return LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDark
              ? [AppColors.darkSurface, AppColors.darkBackground]
              : [const Color(0xFFEFF6FF), const Color(0xFFE0E7FF)],
        );
      case OfferType.special:
        return LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDark
              ? [AppColors.darkSurface, AppColors.darkBackground]
              : [const Color(0xFFFFF7ED), const Color(0xFFFFEDD5)],
        );
      case OfferType.coupon:
        return LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDark
              ? [AppColors.darkSurface, AppColors.darkBackground]
              : [const Color(0xFFF0FDF4), const Color(0xFFDCFCE7)],
        );
    }
  }

  Color _getBorderColor(bool isDark) {
    if (isDark) return AppColors.darkBorder;
    switch (type) {
      case OfferType.bank:
        return const Color(0xFFDBEAFE);
      case OfferType.special:
        return const Color(0xFFFED7AA);
      case OfferType.coupon:
        return const Color(0xFFBBF7D0);
    }
  }

  Color _getAccentColor() {
    switch (type) {
      case OfferType.bank:
        return AppColors.accent;
      case OfferType.special:
        return const Color(0xFFEA580C);
      case OfferType.coupon:
        return AppColors.success;
    }
  }
}
