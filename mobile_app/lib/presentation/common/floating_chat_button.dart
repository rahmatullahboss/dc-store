import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/config/white_label_config.dart';

/// Floating Chat Button for quick access to AI chatbot
///
/// A branded draggable floating button with pulse animation
/// that navigates to the chat screen when tapped.
/// User can drag it to any position on the screen.
class FloatingChatButton extends StatefulWidget {
  const FloatingChatButton({super.key});

  @override
  State<FloatingChatButton> createState() => _FloatingChatButtonState();
}

class _FloatingChatButtonState extends State<FloatingChatButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  // Position state - starts at bottom right
  Offset _position = const Offset(0, 0);
  bool _initialized = false;
  bool _isDragging = false;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.08).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  void _initPosition(BuildContext context) {
    if (!_initialized) {
      final size = MediaQuery.of(context).size;
      final padding = MediaQuery.of(context).padding;
      // Start at bottom right, above the bottom nav bar
      _position = Offset(
        size.width - 72, // 56 (button) + 16 (padding)
        size.height - padding.bottom - 150, // Above bottom nav
      );
      _initialized = true;
    }
  }

  void _onPanStart(DragStartDetails details) {
    setState(() => _isDragging = true);
    _pulseController.stop();
  }

  void _onPanUpdate(DragUpdateDetails details) {
    setState(() {
      _position += details.delta;
      // Keep within screen bounds
      final size = MediaQuery.of(context).size;
      final padding = MediaQuery.of(context).padding;
      _position = Offset(
        _position.dx.clamp(16.0, size.width - 72),
        _position.dy.clamp(padding.top + 16, size.height - padding.bottom - 80),
      );
    });
  }

  void _onPanEnd(DragEndDetails details) {
    setState(() => _isDragging = false);
    _pulseController.repeat(reverse: true);

    // Snap to nearest edge
    final size = MediaQuery.of(context).size;
    final centerX = size.width / 2;
    setState(() {
      if (_position.dx < centerX - 28) {
        // Snap to left
        _position = Offset(16, _position.dy);
      } else {
        // Snap to right
        _position = Offset(size.width - 72, _position.dy);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    _initPosition(context);

    return Positioned(
      left: _position.dx,
      top: _position.dy,
      child: GestureDetector(
        onPanStart: _onPanStart,
        onPanUpdate: _onPanUpdate,
        onPanEnd: _onPanEnd,
        onTap: () => context.push('/chat'),
        child: AnimatedScale(
          scale: _isDragging ? 1.15 : _pulseAnimation.value,
          duration: const Duration(milliseconds: 100),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  WhiteLabelConfig.accentColor,
                  WhiteLabelConfig.accentLightColor,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: WhiteLabelConfig.accentColor.withValues(
                    alpha: _isDragging ? 0.6 : 0.4,
                  ),
                  blurRadius: _isDragging ? 16 : 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: const Icon(
              Icons.smart_toy_rounded,
              color: Colors.white,
              size: 28,
            ),
          ),
        ),
      ),
    );
  }
}

/// Wrapper to use FloatingChatButton as an overlay
/// Use this in a Stack to make the button draggable
class DraggableChatButtonOverlay extends StatelessWidget {
  final Widget child;

  const DraggableChatButtonOverlay({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Stack(children: [child, const FloatingChatButton()]);
  }
}
