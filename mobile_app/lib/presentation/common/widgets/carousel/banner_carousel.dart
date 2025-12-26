import 'dart:async';
import 'package:flutter/material.dart';
import 'package:dc_store/core/theme/app_colors.dart';
import '../feedback/loading_shimmer.dart';

/// Banner item configuration
class BannerItem {
  final String imageUrl;
  final String? title;
  final String? subtitle;
  final VoidCallback? onTap;
  final Color? overlayColor;

  const BannerItem({
    required this.imageUrl,
    this.title,
    this.subtitle,
    this.onTap,
    this.overlayColor,
  });
}

/// BannerCarousel - Auto-scrolling banner with indicators
///
/// Example usage:
/// ```dart
/// BannerCarousel(
///   items: [
///     BannerItem(imageUrl: 'https://...', title: 'Summer Sale'),
///     BannerItem(imageUrl: 'https://...', title: 'New Arrivals'),
///   ],
///   autoScrollDuration: Duration(seconds: 5),
///   onTap: (index) => navigateToBanner(index),
/// )
/// ```
class BannerCarousel extends StatefulWidget {
  /// Banner items
  final List<BannerItem> items;

  /// Height of the carousel
  final double height;

  /// Whether to auto-scroll
  final bool autoScroll;

  /// Duration between auto-scrolls
  final Duration autoScrollDuration;

  /// Page transition duration
  final Duration transitionDuration;

  /// Whether to show indicators
  final bool showIndicators;

  /// Indicator position
  final IndicatorPosition indicatorPosition;

  /// Border radius
  final double borderRadius;

  /// Horizontal padding
  final double horizontalPadding;

  /// Callback when banner is tapped
  final ValueChanged<int>? onTap;

  const BannerCarousel({
    super.key,
    required this.items,
    this.height = 180,
    this.autoScroll = true,
    this.autoScrollDuration = const Duration(seconds: 5),
    this.transitionDuration = const Duration(milliseconds: 400),
    this.showIndicators = true,
    this.indicatorPosition = IndicatorPosition.bottom,
    this.borderRadius = 12,
    this.horizontalPadding = 16,
    this.onTap,
  });

  @override
  State<BannerCarousel> createState() => _BannerCarouselState();
}

class _BannerCarouselState extends State<BannerCarousel> {
  late PageController _pageController;
  int _currentPage = 0;
  Timer? _autoScrollTimer;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: 1.0);
    _startAutoScroll();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _autoScrollTimer?.cancel();
    super.dispose();
  }

  void _startAutoScroll() {
    if (!widget.autoScroll || widget.items.length <= 1) return;

    _autoScrollTimer?.cancel();
    _autoScrollTimer = Timer.periodic(widget.autoScrollDuration, (_) {
      if (_pageController.hasClients) {
        final nextPage = (_currentPage + 1) % widget.items.length;
        _pageController.animateToPage(
          nextPage,
          duration: widget.transitionDuration,
          curve: Curves.easeInOut,
        );
      }
    });
  }

  void _resetAutoScroll() {
    _autoScrollTimer?.cancel();
    _startAutoScroll();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.items.isEmpty) {
      return SizedBox(height: widget.height);
    }

    return SizedBox(
      height: widget.height,
      child: Stack(
        children: [
          // Page view
          Padding(
            padding: EdgeInsets.symmetric(horizontal: widget.horizontalPadding),
            child: PageView.builder(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() => _currentPage = index);
                _resetAutoScroll();
              },
              itemCount: widget.items.length,
              itemBuilder: (context, index) {
                return _BannerItemWidget(
                  item: widget.items[index],
                  borderRadius: widget.borderRadius,
                  onTap: widget.onTap != null
                      ? () => widget.onTap!(index)
                      : null,
                );
              },
            ),
          ),

          // Indicators
          if (widget.showIndicators && widget.items.length > 1)
            _buildIndicators(),
        ],
      ),
    );
  }

  Widget _buildIndicators() {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    Widget indicators = _PageIndicators(
      count: widget.items.length,
      currentIndex: _currentPage,
      activeColor: widget.indicatorPosition == IndicatorPosition.bottom
          ? Colors.white
          : (isDark ? AppColors.darkPrimary : AppColors.primary),
      inactiveColor: widget.indicatorPosition == IndicatorPosition.bottom
          ? Colors.white.withValues(alpha: 0.5)
          : (isDark ? AppColors.darkTextHint : AppColors.textHint),
    );

    switch (widget.indicatorPosition) {
      case IndicatorPosition.bottom:
        return Positioned(
          left: 0,
          right: 0,
          bottom: 12,
          child: Center(child: indicators),
        );
      case IndicatorPosition.belowBanner:
        return Positioned(
          left: 0,
          right: 0,
          bottom: -20,
          child: Center(child: indicators),
        );
    }
  }
}

enum IndicatorPosition { bottom, belowBanner }

class _BannerItemWidget extends StatelessWidget {
  final BannerItem item;
  final double borderRadius;
  final VoidCallback? onTap;

  const _BannerItemWidget({
    required this.item,
    required this.borderRadius,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap ?? item.onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(borderRadius),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.12),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(borderRadius),
          child: Stack(
            fit: StackFit.expand,
            children: [
              // Image
              Image.network(
                item.imageUrl,
                fit: BoxFit.cover,
                loadingBuilder: (_, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return const ShimmerBox();
                },
                errorBuilder: (_, __, ___) => Container(
                  color: AppColors.muted,
                  alignment: Alignment.center,
                  child: Icon(
                    Icons.image_not_supported_outlined,
                    size: 48,
                    color: AppColors.textHint,
                  ),
                ),
              ),

              // Gradient overlay
              if (item.title != null || item.subtitle != null)
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        (item.overlayColor ?? Colors.black).withValues(
                          alpha: 0.6,
                        ),
                      ],
                      stops: const [0.4, 1.0],
                    ),
                  ),
                ),

              // Content
              if (item.title != null || item.subtitle != null)
                Positioned(
                  left: 16,
                  right: 16,
                  bottom: 16,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (item.title != null)
                        Text(
                          item.title!,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      if (item.subtitle != null) ...[
                        const SizedBox(height: 4),
                        Text(
                          item.subtitle!,
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.9),
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PageIndicators extends StatelessWidget {
  final int count;
  final int currentIndex;
  final Color activeColor;
  final Color inactiveColor;

  const _PageIndicators({
    required this.count,
    required this.currentIndex,
    required this.activeColor,
    required this.inactiveColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(count, (index) {
        final isActive = index == currentIndex;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          margin: const EdgeInsets.symmetric(horizontal: 3),
          width: isActive ? 20 : 8,
          height: 8,
          decoration: BoxDecoration(
            color: isActive ? activeColor : inactiveColor,
            borderRadius: BorderRadius.circular(4),
          ),
        );
      }),
    );
  }
}

/// Simple image slider without titles
class ImageCarousel extends StatelessWidget {
  final List<String> images;
  final double height;
  final bool autoScroll;
  final ValueChanged<int>? onTap;

  const ImageCarousel({
    super.key,
    required this.images,
    this.height = 180,
    this.autoScroll = true,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return BannerCarousel(
      items: images.map((url) => BannerItem(imageUrl: url)).toList(),
      height: height,
      autoScroll: autoScroll,
      onTap: onTap,
    );
  }
}
