import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import 'package:dc_store/core/theme/app_colors.dart';
import 'package:dc_store/core/theme/app_text_styles.dart';
import 'package:dc_store/core/theme/app_border_radius.dart';

/// Write Review Screen - Allows users to submit product reviews
/// Matches the modern design in the provided HTML mockup
class WriteReviewScreen extends StatefulWidget {
  final String? productId;
  final String? orderId;

  const WriteReviewScreen({super.key, this.productId, this.orderId});

  @override
  State<WriteReviewScreen> createState() => _WriteReviewScreenState();
}

class _WriteReviewScreenState extends State<WriteReviewScreen> {
  // Form controllers
  final _titleController = TextEditingController();
  final _reviewController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  // Rating states
  int _overallRating = 4;
  int _qualityRating = 5;
  int _valueRating = 3;
  int _deliveryRating = 4;

  // Other states
  bool _postAnonymously = false;
  final List<File> _selectedImages = [];
  final ImagePicker _imagePicker = ImagePicker();

  // Mock product data - in real app, this would come from API
  final _mockProduct = const _ProductInfo(
    id: '1',
    name: 'Nike Air Max 270 React - Special Edition',
    image:
        'https://lh3.googleusercontent.com/aida-public/AB6AXuCBtuD9BZksGsi3JQ4CcTg8Mmv7rBMAPxVbIUcDtHf30XuBblISEZVzGCEHS4TEvDgspAhAnCS77U9Ytam_032GniK2ErQApCKCHXKW3-shKflsUPfNZzrBnLOLJVjpFWb2LBUzLUp0mp9hK0wKF2_mvbIqaasqEVMBfOODIpcbLUsnzhUb5AROm8SX38ipCdVXLh8zUAxM2IsiGa-vRdu8tfQca8BQKKVbMq0uiryQ0Z7Pk-y6zG-WVTbKnEAu0JCb0Ga3jQc9ddo',
    size: '42',
    color: 'Red',
  );

  @override
  void dispose() {
    _titleController.dispose();
    _reviewController.dispose();
    super.dispose();
  }

  String _getRatingText(int rating) {
    switch (rating) {
      case 1:
        return 'Poor';
      case 2:
        return 'Fair';
      case 3:
        return 'Average';
      case 4:
        return 'Good';
      case 5:
        return 'Excellent';
      default:
        return '';
    }
  }

  Future<void> _pickImage() async {
    final XFile? image = await _imagePicker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 1024,
      maxHeight: 1024,
      imageQuality: 80,
    );

    if (image != null) {
      setState(() {
        _selectedImages.add(File(image.path));
      });
    }
  }

  void _removeImage(int index) {
    setState(() {
      _selectedImages.removeAt(index);
    });
  }

  void _submitReview() {
    if (_formKey.currentState?.validate() ?? false) {
      // TODO: Implement actual review submission
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Review submitted successfully!'),
          backgroundColor: AppColors.success,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: AppBorderRadius.smRadius),
        ),
      );
      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = isDark
        ? AppColors.darkBackground
        : AppColors.background;
    final cardColor = isDark ? AppColors.darkCard : AppColors.card;
    final textColor = isDark
        ? AppColors.darkTextPrimary
        : AppColors.textPrimary;
    final subtleTextColor = isDark
        ? AppColors.darkTextSecondary
        : AppColors.textSecondary;
    final borderColor = isDark ? AppColors.darkBorder : AppColors.border;
    final primaryColor = Theme.of(context).colorScheme.primary;

    return Scaffold(
      backgroundColor: backgroundColor,
      body: Stack(
        children: [
          // Main content
          CustomScrollView(
            slivers: [
              // App Bar
              SliverAppBar(
                pinned: true,
                elevation: 0,
                backgroundColor: cardColor.withOpacity(0.9),
                surfaceTintColor: Colors.transparent,
                leading: IconButton(
                  onPressed: () => context.pop(),
                  icon: Icon(LucideIcons.arrowLeft, color: textColor),
                ),
                title: Text(
                  'Write Review',
                  style: AppTextStyles.h5.copyWith(color: textColor),
                ),
                centerTitle: true,
              ),

              // Content
              SliverToBoxAdapter(
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Product Info
                      _buildProductInfo(
                        cardColor,
                        textColor,
                        subtleTextColor,
                        borderColor,
                      ).animate().fadeIn(duration: 300.ms),

                      // Overall Rating
                      _buildOverallRating(
                        textColor,
                        subtleTextColor,
                        borderColor,
                      ).animate().fadeIn(duration: 300.ms, delay: 50.ms),

                      // Category Ratings
                      _buildCategoryRatings(
                        textColor,
                        subtleTextColor,
                        borderColor,
                      ).animate().fadeIn(duration: 300.ms, delay: 100.ms),

                      // Form Fields
                      _buildFormFields(
                        isDark,
                        cardColor,
                        textColor,
                        subtleTextColor,
                        borderColor,
                        primaryColor,
                      ).animate().fadeIn(duration: 300.ms, delay: 150.ms),

                      // Bottom spacing for fixed button
                      const SizedBox(height: 120),
                    ],
                  ),
                ),
              ),
            ],
          ),

          // Fixed Submit Button
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: _buildSubmitButton(cardColor, borderColor),
          ),
        ],
      ),
    );
  }

  Widget _buildProductInfo(
    Color cardColor,
    Color textColor,
    Color subtleTextColor,
    Color borderColor,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardColor,
        border: Border(bottom: BorderSide(color: borderColor)),
      ),
      child: Row(
        children: [
          // Product Image
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              borderRadius: AppBorderRadius.lgRadius,
              border: Border.all(color: borderColor),
            ),
            clipBehavior: Clip.antiAlias,
            child: CachedNetworkImage(
              imageUrl: _mockProduct.image,
              fit: BoxFit.cover,
              placeholder: (context, url) => Container(
                color: borderColor,
                child: Icon(LucideIcons.image, color: subtleTextColor),
              ),
              errorWidget: (context, url, error) => Container(
                color: borderColor,
                child: Icon(LucideIcons.imageOff, color: subtleTextColor),
              ),
            ),
          ),
          const SizedBox(width: 16),
          // Product Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _mockProduct.name,
                  style: AppTextStyles.labelLarge.copyWith(
                    color: textColor,
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  'Size: ${_mockProduct.size} • Color: ${_mockProduct.color}',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: subtleTextColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOverallRating(
    Color textColor,
    Color subtleTextColor,
    Color borderColor,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: borderColor)),
      ),
      child: Column(
        children: [
          Text(
            'How would you rate your experience?',
            style: AppTextStyles.labelMedium.copyWith(
              color: subtleTextColor,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 16),
          // Interactive Star Rating
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(5, (index) {
              final starIndex = index + 1;
              final isFilled = starIndex <= _overallRating;
              return GestureDetector(
                onTap: () => setState(() => _overallRating = starIndex),
                child: AnimatedScale(
                  scale: isFilled ? 1.0 : 0.9,
                  duration: const Duration(milliseconds: 150),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: Icon(
                      isFilled
                          ? Icons.star_rounded
                          : Icons.star_outline_rounded,
                      size: 40,
                      color: isFilled ? AppColors.warning : borderColor,
                    ),
                  ),
                ),
              );
            }),
          ),
          const SizedBox(height: 12),
          Text(
            _getRatingText(_overallRating),
            style: AppTextStyles.h5.copyWith(color: textColor),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryRatings(
    Color textColor,
    Color subtleTextColor,
    Color borderColor,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: borderColor)),
      ),
      child: Column(
        children: [
          _buildCategoryRatingRow(
            'Quality',
            _qualityRating,
            (value) => setState(() => _qualityRating = value),
            subtleTextColor,
            borderColor,
          ),
          const SizedBox(height: 20),
          _buildCategoryRatingRow(
            'Value for money',
            _valueRating,
            (value) => setState(() => _valueRating = value),
            subtleTextColor,
            borderColor,
          ),
          const SizedBox(height: 20),
          _buildCategoryRatingRow(
            'Delivery',
            _deliveryRating,
            (value) => setState(() => _deliveryRating = value),
            subtleTextColor,
            borderColor,
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryRatingRow(
    String label,
    int rating,
    ValueChanged<int> onChanged,
    Color subtleTextColor,
    Color borderColor,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: AppTextStyles.bodySmall.copyWith(
            color: subtleTextColor,
            fontWeight: FontWeight.w500,
          ),
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(5, (index) {
            final starIndex = index + 1;
            final isFilled = starIndex <= rating;
            return GestureDetector(
              onTap: () => onChanged(starIndex),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 2),
                child: Icon(
                  isFilled ? Icons.star_rounded : Icons.star_outline_rounded,
                  size: 22,
                  color: isFilled ? AppColors.warning : borderColor,
                ),
              ),
            );
          }),
        ),
      ],
    );
  }

  Widget _buildFormFields(
    bool isDark,
    Color cardColor,
    Color textColor,
    Color subtleTextColor,
    Color borderColor,
    Color primaryColor,
  ) {
    final inputFillColor = isDark ? AppColors.darkSurface : AppColors.surface;
    final focusedBorderColor = isDark ? AppColors.darkPrimary : primaryColor;

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Add Photos Section
          Text(
            'Add Photos',
            style: AppTextStyles.labelLarge.copyWith(
              color: textColor,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 80,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                // Add Photo Button
                GestureDetector(
                  onTap: _pickImage,
                  child: Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      borderRadius: AppBorderRadius.lgRadius,
                      border: Border.all(
                        color: primaryColor.withOpacity(0.3),
                        width: 2,
                        strokeAlign: BorderSide.strokeAlignInside,
                      ),
                      color: primaryColor.withOpacity(0.05),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(LucideIcons.camera, size: 24, color: primaryColor),
                        const SizedBox(height: 4),
                        Text(
                          'Add',
                          style: AppTextStyles.overline.copyWith(
                            color: primaryColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                // Selected Images
                ..._selectedImages.asMap().entries.map((entry) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 12),
                    child: _buildImageThumbnail(
                      entry.key,
                      entry.value,
                      borderColor,
                    ),
                  );
                }),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Review Title
          Text(
            'Review Title',
            style: AppTextStyles.labelLarge.copyWith(
              color: textColor,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          TextFormField(
            controller: _titleController,
            style: AppTextStyles.bodyMedium.copyWith(color: textColor),
            decoration: InputDecoration(
              hintText: 'Summarize your thoughts',
              hintStyle: AppTextStyles.bodyMedium.copyWith(
                color: subtleTextColor,
              ),
              filled: true,
              fillColor: inputFillColor,
              border: OutlineInputBorder(
                borderRadius: AppBorderRadius.lgRadius,
                borderSide: BorderSide(color: borderColor),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: AppBorderRadius.lgRadius,
                borderSide: BorderSide(color: borderColor),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: AppBorderRadius.lgRadius,
                borderSide: BorderSide(color: focusedBorderColor, width: 2),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 14,
              ),
            ),
          ),

          const SizedBox(height: 20),

          // Review Body
          Text(
            'Review',
            style: AppTextStyles.labelLarge.copyWith(
              color: textColor,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Stack(
            children: [
              TextFormField(
                controller: _reviewController,
                style: AppTextStyles.bodyMedium.copyWith(color: textColor),
                maxLines: 4,
                decoration: InputDecoration(
                  hintText: 'What did you like or dislike? How was the fit?',
                  hintStyle: AppTextStyles.bodyMedium.copyWith(
                    color: subtleTextColor,
                  ),
                  filled: true,
                  fillColor: inputFillColor,
                  border: OutlineInputBorder(
                    borderRadius: AppBorderRadius.lgRadius,
                    borderSide: BorderSide(color: borderColor),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: AppBorderRadius.lgRadius,
                    borderSide: BorderSide(color: borderColor),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: AppBorderRadius.lgRadius,
                    borderSide: BorderSide(color: focusedBorderColor, width: 2),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                ),
                validator: (value) {
                  if (value == null || value.length < 50) {
                    return 'Review must be at least 50 characters';
                  }
                  return null;
                },
              ),
              Positioned(
                right: 12,
                bottom: 12,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: cardColor.withOpacity(0.8),
                    borderRadius: AppBorderRadius.smRadius,
                  ),
                  child: Text(
                    'Min 50 chars',
                    style: AppTextStyles.overline.copyWith(
                      color: subtleTextColor,
                    ),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          // Post Anonymously Toggle
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Post Anonymously',
                    style: AppTextStyles.labelLarge.copyWith(
                      color: textColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Your name will be hidden',
                    style: AppTextStyles.caption.copyWith(
                      color: subtleTextColor,
                    ),
                  ),
                ],
              ),
              Switch.adaptive(
                value: _postAnonymously,
                onChanged: (value) => setState(() => _postAnonymously = value),
                activeColor: Theme.of(context).colorScheme.primary,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildImageThumbnail(int index, File image, Color borderColor) {
    return Stack(
      children: [
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            borderRadius: AppBorderRadius.lgRadius,
            border: Border.all(color: borderColor),
          ),
          clipBehavior: Clip.antiAlias,
          child: Image.file(image, fit: BoxFit.cover),
        ),
        Positioned(
          top: 4,
          right: 4,
          child: GestureDetector(
            onTap: () => _removeImage(index),
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.6),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(LucideIcons.x, size: 14, color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSubmitButton(Color cardColor, Color borderColor) {
    final primaryColor = Theme.of(context).colorScheme.primary;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardColor,
        border: Border(top: BorderSide(color: borderColor)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: _submitReview,
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryColor,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: AppBorderRadius.xlRadius,
              ),
              elevation: 0,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Submit Review',
                  style: AppTextStyles.buttonMedium.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(width: 8),
                const Icon(LucideIcons.arrowRight, size: 18),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Mock product info class
class _ProductInfo {
  final String id;
  final String name;
  final String image;
  final String size;
  final String color;

  const _ProductInfo({
    required this.id,
    required this.name,
    required this.image,
    required this.size,
    required this.color,
  });
}
