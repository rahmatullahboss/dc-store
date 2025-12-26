import 'package:flutter/material.dart';
import 'package:dc_store/core/theme/app_colors.dart';
import 'package:dc_store/core/theme/app_text_styles.dart';

/// RatingWidget - Displays and/or allows selection of star ratings
///
/// Example usage:
/// ```dart
/// RatingWidget(
///   rating: 4.5,
///   reviewCount: 128,
///   onRatingChanged: (rating) => updateRating(rating),
/// )
/// ```
class RatingWidget extends StatelessWidget {
  /// Current rating value (0-5)
  final double rating;

  /// Number of reviews
  final int? reviewCount;

  /// Callback when rating changes (enables interactive mode)
  final ValueChanged<double>? onRatingChanged;

  /// Whether to allow half-star ratings
  final bool allowHalf;

  /// Size variant
  final RatingSize size;

  /// Whether to show the rating number
  final bool showRatingValue;

  /// Custom color for filled stars
  final Color? filledColor;

  /// Custom color for empty stars
  final Color? emptyColor;

  const RatingWidget({
    super.key,
    required this.rating,
    this.reviewCount,
    this.onRatingChanged,
    this.allowHalf = true,
    this.size = RatingSize.medium,
    this.showRatingValue = false,
    this.filledColor,
    this.emptyColor,
  });

  bool get isInteractive => onRatingChanged != null;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Stars
        Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(5, (index) {
            return _buildStar(index, isDark);
          }),
        ),

        // Rating value
        if (showRatingValue) ...[
          SizedBox(width: _getSpacing()),
          Text(rating.toStringAsFixed(1), style: _getRatingTextStyle(isDark)),
        ],

        // Review count
        if (reviewCount != null) ...[
          SizedBox(width: _getSpacing()),
          Text('($reviewCount)', style: _getReviewCountStyle(isDark)),
        ],
      ],
    );
  }

  Widget _buildStar(int index, bool isDark) {
    final starValue = index + 1;
    final isFullFilled = rating >= starValue;
    final isHalfFilled = !isFullFilled && rating > index && rating < starValue;

    IconData icon;
    Color color;

    if (isFullFilled) {
      icon = Icons.star_rounded;
      color = filledColor ?? AppColors.warning;
    } else if (isHalfFilled && allowHalf) {
      icon = Icons.star_half_rounded;
      color = filledColor ?? AppColors.warning;
    } else {
      icon = Icons.star_outline_rounded;
      color =
          emptyColor ?? (isDark ? AppColors.darkTextHint : AppColors.textHint);
    }

    final star = Icon(icon, size: _getStarSize(), color: color);

    if (isInteractive) {
      return GestureDetector(
        onTap: () => onRatingChanged!(starValue.toDouble()),
        onHorizontalDragUpdate: (details) {
          if (allowHalf) {
            final dx = details.localPosition.dx;
            final halfWidth = _getStarSize() / 2;
            if (dx < halfWidth) {
              onRatingChanged!(index + 0.5);
            } else {
              onRatingChanged!(starValue.toDouble());
            }
          }
        },
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: _getStarSpacing() / 2),
          child: star,
        ),
      );
    }

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: _getStarSpacing() / 2),
      child: star,
    );
  }

  TextStyle _getRatingTextStyle(bool isDark) {
    final color = isDark ? AppColors.darkTextPrimary : AppColors.textPrimary;

    switch (size) {
      case RatingSize.small:
        return AppTextStyles.caption.copyWith(
          color: color,
          fontWeight: FontWeight.w600,
        );
      case RatingSize.medium:
        return AppTextStyles.labelMedium.copyWith(
          color: color,
          fontWeight: FontWeight.w600,
        );
      case RatingSize.large:
        return AppTextStyles.labelLarge.copyWith(
          color: color,
          fontWeight: FontWeight.w600,
        );
    }
  }

  TextStyle _getReviewCountStyle(bool isDark) {
    final color = isDark
        ? AppColors.darkTextSecondary
        : AppColors.textSecondary;

    switch (size) {
      case RatingSize.small:
        return AppTextStyles.overline.copyWith(color: color);
      case RatingSize.medium:
        return AppTextStyles.caption.copyWith(color: color);
      case RatingSize.large:
        return AppTextStyles.bodySmall.copyWith(color: color);
    }
  }

  double _getStarSize() {
    switch (size) {
      case RatingSize.small:
        return 14;
      case RatingSize.medium:
        return 18;
      case RatingSize.large:
        return 24;
    }
  }

  double _getStarSpacing() {
    switch (size) {
      case RatingSize.small:
        return 1;
      case RatingSize.medium:
        return 2;
      case RatingSize.large:
        return 3;
    }
  }

  double _getSpacing() {
    switch (size) {
      case RatingSize.small:
        return 4;
      case RatingSize.medium:
        return 6;
      case RatingSize.large:
        return 8;
    }
  }
}

enum RatingSize { small, medium, large }

/// Interactive rating input for reviews
class RatingInput extends StatefulWidget {
  final double initialRating;
  final ValueChanged<double> onChanged;
  final bool allowHalf;
  final String? label;

  const RatingInput({
    super.key,
    this.initialRating = 0,
    required this.onChanged,
    this.allowHalf = true,
    this.label,
  });

  @override
  State<RatingInput> createState() => _RatingInputState();
}

class _RatingInputState extends State<RatingInput> {
  late double _rating;

  @override
  void initState() {
    super.initState();
    _rating = widget.initialRating;
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
        RatingWidget(
          rating: _rating,
          size: RatingSize.large,
          showRatingValue: true,
          allowHalf: widget.allowHalf,
          onRatingChanged: (value) {
            setState(() => _rating = value);
            widget.onChanged(value);
          },
        ),
      ],
    );
  }
}

/// Compact rating display with average and count
class RatingSummary extends StatelessWidget {
  final double rating;
  final int reviewCount;

  const RatingSummary({
    super.key,
    required this.rating,
    required this.reviewCount,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.star_rounded, size: 16, color: AppColors.warning),
        const SizedBox(width: 4),
        Text(
          rating.toStringAsFixed(1),
          style: AppTextStyles.labelMedium.copyWith(
            color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(width: 4),
        Text(
          '($reviewCount)',
          style: AppTextStyles.caption.copyWith(
            color: isDark
                ? AppColors.darkTextSecondary
                : AppColors.textSecondary,
          ),
        ),
      ],
    );
  }
}
