import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/utils/app_haptics.dart';
import '../../../core/theme/app_colors.dart';

/// Animated heart button for wishlist functionality.
/// Shows a satisfying animation when toggled.
class AnimatedHeartButton extends StatefulWidget {
  final bool isWishlisted;
  final VoidCallback onToggle;
  final double size;
  final Color? activeColor;
  final Color? inactiveColor;

  const AnimatedHeartButton({
    super.key,
    required this.isWishlisted,
    required this.onToggle,
    this.size = 24,
    this.activeColor,
    this.inactiveColor,
  });

  @override
  State<AnimatedHeartButton> createState() => _AnimatedHeartButtonState();
}

class _AnimatedHeartButtonState extends State<AnimatedHeartButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  bool _showParticles = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.3,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.elasticOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTap() {
    AppHaptics.mediumImpact();

    if (!widget.isWishlisted) {
      // Adding to wishlist - show animation
      _controller.forward().then((_) {
        _controller.reverse();
      });
      setState(() => _showParticles = true);
      Future.delayed(const Duration(milliseconds: 600), () {
        if (mounted) setState(() => _showParticles = false);
      });
    }

    widget.onToggle();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final activeColor = widget.activeColor ?? AppColors.error;
    final inactiveColor =
        widget.inactiveColor ??
        (isDark ? Colors.grey[400]! : Colors.grey[600]!);

    return GestureDetector(
      onTap: _handleTap,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Particles effect
          if (_showParticles) ...[
            for (int i = 0; i < 6; i++)
              Positioned(
                child:
                    Container(
                          width: 6,
                          height: 6,
                          decoration: BoxDecoration(
                            color: activeColor.withAlpha(200),
                            shape: BoxShape.circle,
                          ),
                        )
                        .animate(onComplete: (c) => c.forward(from: 0))
                        .scale(
                          begin: const Offset(0, 0),
                          end: const Offset(1, 1),
                        )
                        .fadeOut()
                        .move(
                          begin: Offset.zero,
                          end: Offset(
                            (i % 2 == 0 ? 1 : -1) * (10 + (i * 5)).toDouble(),
                            (i < 3 ? -1 : 1) * (10 + (i * 3)).toDouble(),
                          ),
                        ),
              ),
          ],

          // Heart icon
          ScaleTransition(
            scale: _scaleAnimation,
            child: Icon(
              widget.isWishlisted ? Icons.favorite : Icons.favorite_border,
              size: widget.size,
              color: widget.isWishlisted ? activeColor : inactiveColor,
            ),
          ),
        ],
      ),
    );
  }
}
