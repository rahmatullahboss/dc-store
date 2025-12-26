import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../core/theme/app_colors.dart';

/// Parallax scroll header widget for product details and similar screens.
/// Creates a beautiful depth effect as the user scrolls.
class ParallaxHeader extends StatelessWidget {
  final String imageUrl;
  final double height;
  final double parallaxFactor;
  final Widget? overlay;
  final Widget? child;

  const ParallaxHeader({
    super.key,
    required this.imageUrl,
    this.height = 400,
    this.parallaxFactor = 0.5,
    this.overlay,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      expandedHeight: height,
      pinned: true,
      stretch: true,
      backgroundColor: AppColors.adaptive(
        context,
        Colors.white,
        AppColors.darkBackground,
      ),
      flexibleSpace: FlexibleSpaceBar(
        stretchModes: const [
          StretchMode.zoomBackground,
          StretchMode.blurBackground,
        ],
        background: Stack(
          fit: StackFit.expand,
          children: [
            // Parallax image
            CachedNetworkImage(
              imageUrl: imageUrl,
              fit: BoxFit.cover,
              placeholder: (context, url) => Container(
                color: AppColors.adaptive(
                  context,
                  Colors.grey[200]!,
                  Colors.grey[800]!,
                ),
                child: const Center(
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              ),
              errorWidget: (context, url, error) => Container(
                color: AppColors.adaptive(
                  context,
                  Colors.grey[200]!,
                  Colors.grey[800]!,
                ),
                child: Icon(
                  Icons.image_not_supported,
                  size: 64,
                  color: Colors.grey[400],
                ),
              ),
            ),

            // Optional gradient overlay
            if (overlay != null) overlay!,

            // Optional child widget
            if (child != null) child!,
          ],
        ),
      ),
    );
  }
}

/// A sliver that creates a parallax scrolling effect on its child.
class SliverParallax extends StatelessWidget {
  final Widget child;
  final double parallaxFactor;

  const SliverParallax({
    super.key,
    required this.child,
    this.parallaxFactor = 0.5,
  });

  @override
  Widget build(BuildContext context) {
    return SliverLayoutBuilder(
      builder: (context, constraints) {
        final scrollOffset = constraints.scrollOffset;
        final parallaxOffset = scrollOffset * parallaxFactor;

        return SliverToBoxAdapter(
          child: Transform.translate(
            offset: Offset(0, parallaxOffset),
            child: child,
          ),
        );
      },
    );
  }
}

/// Gradient overlay for parallax headers
class ParallaxGradientOverlay extends StatelessWidget {
  final List<Color>? colors;
  final AlignmentGeometry begin;
  final AlignmentGeometry end;

  const ParallaxGradientOverlay({
    super.key,
    this.colors,
    this.begin = Alignment.topCenter,
    this.end = Alignment.bottomCenter,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final defaultColors = isDark
        ? [Colors.transparent, Colors.black.withAlpha(180)]
        : [Colors.transparent, Colors.black.withAlpha(100)];

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: begin,
          end: end,
          colors: colors ?? defaultColors,
        ),
      ),
    );
  }
}

/// Scrolling effect controller for advanced parallax animations
class ParallaxScrollController extends ScrollController {
  double get parallaxOffset => hasClients ? offset : 0.0;

  double normalizedOffset(double maxOffset) {
    if (!hasClients) return 0.0;
    return (offset / maxOffset).clamp(0.0, 1.0);
  }
}
