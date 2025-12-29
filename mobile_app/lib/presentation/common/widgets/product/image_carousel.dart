import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dc_store/core/theme/app_colors.dart';

/// ImageCarousel - Hero image carousel with thumbnails and dot indicators
///
/// Example usage:
/// ```dart
/// ImageCarousel(
///   images: ['url1', 'url2'],
///   discountPercentage: 30,
///   onImageTap: () {},
/// )
/// ```
class ImageCarousel extends StatefulWidget {
  /// List of image URLs
  final List<String> images;

  /// Discount percentage to show as badge (null = no badge)
  final int? discountPercentage;

  /// Callback when image is tapped
  final VoidCallback? onImageTap;

  /// Height of the carousel (defaults to 60% of screen height)
  final double? height;

  const ImageCarousel({
    super.key,
    required this.images,
    this.discountPercentage,
    this.onImageTap,
    this.height,
  });

  @override
  State<ImageCarousel> createState() => _ImageCarouselState();
}

class _ImageCarouselState extends State<ImageCarousel> {
  late PageController _pageController;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _goToPage(int index) {
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final carouselHeight =
        widget.height ?? MediaQuery.of(context).size.height * 0.55;

    // Handle empty images
    final images = widget.images.isEmpty
        ? ['https://via.placeholder.com/400x400?text=No+Image']
        : widget.images;

    return SizedBox(
      height: carouselHeight,
      child: Stack(
        children: [
          // Main Image PageView
          PageView.builder(
            controller: _pageController,
            onPageChanged: (index) => setState(() => _currentPage = index),
            itemCount: images.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: widget.onImageTap,
                child: CachedNetworkImage(
                  imageUrl: images[index],
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Container(
                    color: isDark ? AppColors.darkSurface : Colors.grey[200],
                    child: const Center(
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  ),
                  errorWidget: (context, url, error) => Container(
                    color: isDark ? AppColors.darkSurface : Colors.grey[200],
                    child: Icon(
                      Icons.image_not_supported_outlined,
                      size: 48,
                      color: isDark ? Colors.grey[600] : Colors.grey[400],
                    ),
                  ),
                ),
              );
            },
          ),

          // Sale Badge
          if (widget.discountPercentage != null &&
              widget.discountPercentage! > 0)
            Positioned(
              top: 100,
              left: 0,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: const BoxDecoration(
                  color: AppColors.error,
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  ),
                ),
                child: Text(
                  'SALE -${widget.discountPercentage}%',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

          // Dot Indicators
          if (images.length > 1)
            Positioned(
              bottom: 80,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  images.length,
                  (index) => AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width: _currentPage == index ? 8 : 8,
                    height: 8,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _currentPage == index
                          ? AppColors.accent
                          : Colors.white.withAlpha(128),
                      border: _currentPage == index
                          ? Border.all(color: AppColors.accent, width: 2)
                          : null,
                    ),
                  ),
                ),
              ),
            ),

          // Thumbnail Strip
          if (images.length > 1)
            Positioned(
              bottom: 16,
              left: 0,
              right: 0,
              child: SizedBox(
                height: 56,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: images.length,
                  itemBuilder: (context, index) {
                    final isSelected = _currentPage == index;
                    return GestureDetector(
                      onTap: () => _goToPage(index),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        margin: const EdgeInsets.only(right: 12),
                        width: 56,
                        height: 56,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: isSelected
                                ? AppColors.accent
                                : Colors.transparent,
                            width: 2,
                          ),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(6),
                          child: Opacity(
                            opacity: isSelected ? 1.0 : 0.7,
                            child: CachedNetworkImage(
                              imageUrl: images[index],
                              fit: BoxFit.cover,
                              placeholder: (context, url) => Container(
                                color: isDark
                                    ? AppColors.darkSurface
                                    : Colors.grey[200],
                              ),
                              errorWidget: (context, url, error) => Container(
                                color: isDark
                                    ? AppColors.darkSurface
                                    : Colors.grey[200],
                                child: const Icon(Icons.image, size: 20),
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),

          // Bottom gradient overlay
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            height: 100,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    isDark ? AppColors.darkBackground : Colors.white,
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
