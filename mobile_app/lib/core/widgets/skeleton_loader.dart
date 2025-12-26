import 'package:flutter/material.dart';

/// Skeleton loading widget for showing placeholder content while data loads.
/// Uses shimmer effect to indicate loading state.
class SkeletonLoader extends StatefulWidget {
  final double? width;
  final double? height;
  final BorderRadius? borderRadius;
  final bool isCircle;

  const SkeletonLoader({
    super.key,
    this.width,
    this.height,
    this.borderRadius,
    this.isCircle = false,
  });

  /// Creates a text-like skeleton
  const SkeletonLoader.text({super.key, this.width = 100, this.height = 14})
    : borderRadius = const BorderRadius.all(Radius.circular(4)),
      isCircle = false;

  /// Creates a circular skeleton (avatar, icon)
  const SkeletonLoader.circle({super.key, double size = 40})
    : width = size,
      height = size,
      borderRadius = null,
      isCircle = true;

  /// Creates a rectangular card skeleton
  const SkeletonLoader.card({
    super.key,
    this.width = double.infinity,
    this.height = 120,
  }) : borderRadius = const BorderRadius.all(Radius.circular(12)),
       isCircle = false;

  @override
  State<SkeletonLoader> createState() => _SkeletonLoaderState();
}

class _SkeletonLoaderState extends State<SkeletonLoader>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat();
    _animation = Tween<double>(
      begin: -1.0,
      end: 2.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final baseColor = isDark ? Colors.grey[800]! : Colors.grey[300]!;
    final highlightColor = isDark ? Colors.grey[700]! : Colors.grey[100]!;

    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Container(
          width: widget.width,
          height: widget.height,
          decoration: BoxDecoration(
            shape: widget.isCircle ? BoxShape.circle : BoxShape.rectangle,
            borderRadius: widget.isCircle ? null : widget.borderRadius,
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [baseColor, highlightColor, baseColor],
              stops: [
                (_animation.value - 0.3).clamp(0.0, 1.0),
                _animation.value.clamp(0.0, 1.0),
                (_animation.value + 0.3).clamp(0.0, 1.0),
              ],
            ),
          ),
        );
      },
    );
  }
}

/// Product card skeleton for loading states
class ProductCardSkeleton extends StatelessWidget {
  const ProductCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image skeleton
          const SkeletonLoader(
            width: double.infinity,
            height: 150,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(12),
              topRight: Radius.circular(12),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Brand
                const SkeletonLoader.text(width: 60),
                const SizedBox(height: 8),
                // Title
                const SkeletonLoader.text(width: double.infinity),
                const SizedBox(height: 4),
                const SkeletonLoader.text(width: 80),
                const SizedBox(height: 8),
                // Price
                Row(
                  children: [
                    const SkeletonLoader.text(width: 50),
                    const SizedBox(width: 8),
                    const SkeletonLoader.text(width: 40),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// List item skeleton for loading states
class ListItemSkeleton extends StatelessWidget {
  const ListItemSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      child: Row(
        children: [
          const SkeletonLoader.circle(size: 48),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SkeletonLoader.text(width: double.infinity),
                const SizedBox(height: 8),
                const SkeletonLoader.text(width: 100),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
