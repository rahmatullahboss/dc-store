import 'package:flutter/material.dart';
import 'package:dc_store/core/theme/app_colors.dart';

/// LoadingShimmer - Shimmer effect for loading states
///
/// Example usage:
/// ```dart
/// if (isLoading)
///   ShimmerBox(height: 100)
/// else
///   MyContent()
/// ```
class LoadingShimmer extends StatefulWidget {
  final Widget child;
  final bool enabled;

  const LoadingShimmer({super.key, required this.child, this.enabled = true});

  @override
  State<LoadingShimmer> createState() => _LoadingShimmerState();
}

class _LoadingShimmerState extends State<LoadingShimmer>
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
    if (!widget.enabled) return widget.child;

    final isDark = Theme.of(context).brightness == Brightness.dark;

    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return ShaderMask(
          shaderCallback: (bounds) {
            return LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: isDark
                  ? [
                      AppColors.darkSurfaceVariant,
                      AppColors.darkSurface,
                      AppColors.darkSurfaceVariant,
                    ]
                  : [
                      AppColors.surfaceVariant,
                      AppColors.surface,
                      AppColors.surfaceVariant,
                    ],
              stops: [
                _animation.value - 0.3,
                _animation.value,
                _animation.value + 0.3,
              ].map((e) => e.clamp(0.0, 1.0)).toList(),
            ).createShader(bounds);
          },
          blendMode: BlendMode.srcATop,
          child: widget.child,
        );
      },
    );
  }
}

/// Simple shimmer box placeholder
class ShimmerBox extends StatefulWidget {
  final double? width;
  final double? height;
  final BorderRadius? borderRadius;

  const ShimmerBox({super.key, this.width, this.height, this.borderRadius});

  @override
  State<ShimmerBox> createState() => _ShimmerBoxState();
}

class _ShimmerBoxState extends State<ShimmerBox>
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
      begin: -2.0,
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

    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Container(
          width: widget.width,
          height: widget.height ?? 16,
          decoration: BoxDecoration(
            borderRadius: widget.borderRadius ?? BorderRadius.circular(4),
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: isDark
                  ? [
                      AppColors.darkSurfaceVariant,
                      AppColors.darkSurface,
                      AppColors.darkSurfaceVariant,
                    ]
                  : [
                      const Color(0xFFEEEEEE),
                      const Color(0xFFF5F5F5),
                      const Color(0xFFEEEEEE),
                    ],
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

/// Prebuilt shimmer patterns for common use cases
class ShimmerPatterns {
  ShimmerPatterns._();

  /// Product grid shimmer (2 columns)
  static Widget productGrid({int itemCount = 4}) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.7,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: itemCount,
      itemBuilder: (_, __) => const _ProductCardShimmer(),
    );
  }

  /// Product list shimmer
  static Widget productList({int itemCount = 3}) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.all(16),
      itemCount: itemCount,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (_, __) => _ProductListItemShimmer(),
    );
  }

  /// Category list shimmer (horizontal)
  static Widget categoryList({int itemCount = 4}) {
    return SizedBox(
      height: 120,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: itemCount,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (_, __) => const ShimmerBox(
          width: 100,
          height: 120,
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
      ),
    );
  }

  /// Banner shimmer
  static Widget banner({double height = 180}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: ShimmerBox(
        height: height,
        width: double.infinity,
        borderRadius: const BorderRadius.all(Radius.circular(12)),
      ),
    );
  }

  /// Text block shimmer
  static Widget textBlock({int lineCount = 3}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List.generate(lineCount, (index) {
        final isLast = index == lineCount - 1;
        return Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: ShimmerBox(height: 14, width: isLast ? 120 : double.infinity),
        );
      }),
    );
  }

  /// Profile header shimmer
  static Widget profileHeader() {
    return const Row(
      children: [
        ShimmerBox(
          width: 64,
          height: 64,
          borderRadius: BorderRadius.all(Radius.circular(32)),
        ),
        SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ShimmerBox(height: 18, width: 120),
              SizedBox(height: 8),
              ShimmerBox(height: 14, width: 180),
            ],
          ),
        ),
      ],
    );
  }

  /// Order card shimmer
  static Widget orderCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ShimmerBox(height: 16, width: 100),
              ShimmerBox(height: 24, width: 80),
            ],
          ),
          SizedBox(height: 12),
          ShimmerBox(height: 60, width: double.infinity),
          SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ShimmerBox(height: 14, width: 80),
              ShimmerBox(height: 14, width: 60),
            ],
          ),
        ],
      ),
    );
  }
}

class _ProductCardShimmer extends StatelessWidget {
  const _ProductCardShimmer();

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : AppColors.card,
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AspectRatio(
            aspectRatio: 1.0,
            child: ShimmerBox(
              borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ShimmerBox(height: 14, width: double.infinity),
                SizedBox(height: 8),
                ShimmerBox(height: 14, width: 80),
                SizedBox(height: 8),
                ShimmerBox(height: 18, width: 60),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ProductListItemShimmer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : AppColors.card,
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Row(
        children: [
          ShimmerBox(
            width: 100,
            height: 100,
            borderRadius: BorderRadius.all(Radius.circular(8)),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ShimmerBox(height: 16, width: double.infinity),
                SizedBox(height: 8),
                ShimmerBox(height: 14, width: 80),
                SizedBox(height: 12),
                ShimmerBox(height: 20, width: 100),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
