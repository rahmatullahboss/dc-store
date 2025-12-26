import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../services/storage_service.dart';
import '../../core/constants/storage_keys.dart';
import '../../core/config/white_label_config.dart';

/// Onboarding data model
class OnboardingPage {
  final String title;
  final String description;
  final IconData icon;
  final Color gradientColor;
  final String imageUrl;

  const OnboardingPage({
    required this.title,
    required this.description,
    required this.icon,
    required this.gradientColor,
    required this.imageUrl,
  });
}

/// Onboarding pages data
const _onboardingPages = [
  OnboardingPage(
    title: 'Discover Products',
    description:
        'Explore thousands of top-rated items tailored just for your unique taste.',
    icon: Icons.explore_rounded,
    gradientColor: Color(0xFF3B82F6), // Blue
    imageUrl:
        'https://lh3.googleusercontent.com/aida-public/AB6AXuADgY8r3a6PttsgONyCbbKZvAoqXQ2qwrR8u03UJ_kafWPTuSp7zz0JsjgtTC3x-DfpHAREiW6C3wH42PKc5xo6P3NhbNNcOMMn3W-rsQe6wqn9g1ztRnD86Z1zfnOh7MkyoaDAV33R8NWNpBr3pz9FTp9dvEJF9YIy5bpkgOGU9Gyrl3M0bVLmdFPkN1J_dkL-7-ApSg3j1qvglkiSeqTMZlyePuOEoqP7uX3RWyVnF86ADYHIjVCr3sVHbX6WUofPodhHavnt8V4',
  ),
  OnboardingPage(
    title: 'Easy Shopping',
    description:
        'Seamless checkout process designed to save you time and effort every day.',
    icon: Icons.shopping_cart_rounded,
    gradientColor: Color(0xFFA855F7), // Purple
    imageUrl:
        'https://lh3.googleusercontent.com/aida-public/AB6AXuDuVtfoCm_QnGxoW04xM1onYaM9X3FnY08qQ2kAzF2WDD3bAPQWXax5oXO3NG3uGhbm14bVtcAMKG3tpnORNnZcqICChRrE2AmVcQn5-rAaiAfIL2d5pEUrqQHqCF0e51GeljeZN9r_MS08Qf-xxbh9vRWVj4GRUrNJOktGd6dXeHTaPDWUxkWrBvOyD7DzjDl4X-YaZBDE8XcYgUoUyL0_8V4aZbb-LXUuR03i_DYP0ql2mtR9H7PLs5S-x4u0hWTYa_HnJK6xBKE',
  ),
  OnboardingPage(
    title: 'Fast Delivery',
    description:
        'Get your orders delivered to your doorstep in record time with live tracking.',
    icon: Icons.local_shipping_rounded,
    gradientColor: Color(0xFFF97316), // Orange
    imageUrl:
        'https://lh3.googleusercontent.com/aida-public/AB6AXuA6cUefz3LdUpWqUfw8v36lVkqt3I9tJJ6yZPRXxQjA1ADDMKd0_gVCXOwQMVYE5mboZRahPTjpHe_5TcBpu5Mg4z4-WUMVFF_so788dDHLNaHb6OTOD_xa-6ENyV9tR12-jofw_ayGwgxSZMy1ttUFpGai4lkZg1s_PG8ePMNVHRYLs7nLlR9TEWiXQt5f-x1FjEck1byiVbwuddQ7p7WiaioZeEOpplmATyBOnnL1s0ksUM98h6eg33leIi21PO7i1zojIhiXh-E',
  ),
  OnboardingPage(
    title: 'Secure Payment',
    description:
        'Your data is safe with our encrypted and secure payment gateways.',
    icon: Icons.security_rounded,
    gradientColor: Color(0xFF22C55E), // Green
    imageUrl:
        'https://lh3.googleusercontent.com/aida-public/AB6AXuA7iZQb7AiapPWzyAr91hdlTCQbQ_YoC8M5v56siEcbiJoU_5QJoXT-C5H3PTsdaZ8eElESFFwBTwdWsltNO7FwlWqXxBsmRVt1WNeBuoyhdG6jh_kWnzCi4meKhzzgYq6t7n-K3Ft5bCmqrXFnXJS9AygQrFzTfs7sqCTtfv8gqD_SN57BAZue0xDti1bb12vnArbxGHTFSOuf8Ci2nXZqVB5kjtNNJ0WTWwTuo3bHZmwQBcWo-QTTwNbzl6pIJ3tcJfFDOygfo1M',
  ),
];

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  void _nextPage() {
    if (_currentPage < _onboardingPages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeOutCubic,
      );
    } else {
      _completeOnboarding();
    }
  }

  Future<void> _completeOnboarding() async {
    // Save onboarding completed flag to local storage
    final storageService = await StorageService.getInstance();
    await storageService.setBool(StorageKeys.onboardingComplete, true);

    if (mounted) {
      context.go('/');
    }
  }

  void _skip() {
    _completeOnboarding();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = isDark
        ? const Color(0xFF101622)
        : const Color(0xFFF6F6F8);
    final primaryColor = WhiteLabelConfig.accentColor;

    return Scaffold(
      backgroundColor: backgroundColor,
      body: Stack(
        children: [
          // Page View
          PageView.builder(
            controller: _pageController,
            itemCount: _onboardingPages.length,
            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
              });
            },
            itemBuilder: (context, index) {
              return _OnboardingPageWidget(
                page: _onboardingPages[index],
                isDark: isDark,
              );
            },
          ),

          // Skip Button (Top Right)
          Positioned(
            top: MediaQuery.of(context).padding.top + 16,
            right: 24,
            child: TextButton(
              onPressed: _skip,
              child: Text(
                'Skip',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.5,
                  color: isDark
                      ? const Color(0xFF94A3B8)
                      : const Color(0xFF64748B),
                ),
              ),
            ),
          ),

          // Bottom Navigation
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: EdgeInsets.fromLTRB(
                24,
                24,
                24,
                MediaQuery.of(context).padding.bottom + 40,
              ),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    backgroundColor.withValues(alpha: 0),
                    backgroundColor,
                    backgroundColor,
                  ],
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Page Indicators
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      _onboardingPages.length,
                      (index) => AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        margin: const EdgeInsets.symmetric(horizontal: 6),
                        height: 8,
                        width: _currentPage == index ? 32 : 8,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          color: _currentPage == index
                              ? primaryColor
                              : (isDark
                                    ? const Color(0xFF334155)
                                    : const Color(0xFFCBD5E1)),
                          boxShadow: _currentPage == index
                              ? [
                                  BoxShadow(
                                    color: primaryColor.withValues(alpha: 0.4),
                                    blurRadius: 8,
                                    offset: const Offset(0, 2),
                                  ),
                                ]
                              : null,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 32),

                  // Next / Get Started Button
                  SizedBox(
                    width: double.infinity,
                    child: Material(
                      color: primaryColor,
                      borderRadius: BorderRadius.circular(16),
                      child: InkWell(
                        onTap: _nextPage,
                        borderRadius: BorderRadius.circular(16),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 18),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: primaryColor.withValues(alpha: 0.25),
                                blurRadius: 20,
                                offset: const Offset(0, 8),
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                _currentPage == _onboardingPages.length - 1
                                    ? 'Get Started'
                                    : 'Next',
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                  letterSpacing: 0.5,
                                ),
                              ),
                              const SizedBox(width: 8),
                              const Icon(
                                Icons.arrow_forward_rounded,
                                color: Colors.white,
                                size: 22,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Individual onboarding page widget
class _OnboardingPageWidget extends StatelessWidget {
  final OnboardingPage page;
  final bool isDark;

  const _OnboardingPageWidget({required this.page, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Illustration Area (Top ~60%)
        Expanded(
          flex: 3,
          child: Stack(
            children: [
              // Background Gradient
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        page.gradientColor.withValues(
                          alpha: isDark ? 0.1 : 0.05,
                        ),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ),

              // Floating decorative elements
              Positioned(
                top: 80,
                left: 32,
                child: _FloatingBlob(
                  size: 64,
                  color: page.gradientColor.withValues(
                    alpha: isDark ? 0.2 : 0.3,
                  ),
                ),
              ),
              Positioned(
                bottom: 80,
                right: 32,
                child: _FloatingBlob(
                  size: 96,
                  color: page.gradientColor.withValues(
                    alpha: isDark ? 0.15 : 0.25,
                  ),
                  delay: const Duration(milliseconds: 700),
                ),
              ),

              // Main Image
              Center(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(32, 80, 32, 0),
                  child: AspectRatio(
                    aspectRatio: 1,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(32),
                        boxShadow: [
                          BoxShadow(
                            color: page.gradientColor.withValues(alpha: 0.2),
                            blurRadius: 40,
                            offset: const Offset(0, 20),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(32),
                        child: ShaderMask(
                          shaderCallback: (bounds) {
                            return LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.white,
                                Colors.white,
                                Colors.white.withValues(alpha: 0),
                              ],
                              stops: const [0.0, 0.7, 1.0],
                            ).createShader(bounds);
                          },
                          blendMode: BlendMode.dstIn,
                          child: Image.network(
                            page.imageUrl,
                            fit: BoxFit.cover,
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) return child;
                              return Container(
                                decoration: BoxDecoration(
                                  color: page.gradientColor.withValues(
                                    alpha: 0.1,
                                  ),
                                  borderRadius: BorderRadius.circular(32),
                                ),
                                child: Center(
                                  child: Icon(
                                    page.icon,
                                    size: 80,
                                    color: page.gradientColor.withValues(
                                      alpha: 0.5,
                                    ),
                                  ),
                                ),
                              );
                            },
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                decoration: BoxDecoration(
                                  color: page.gradientColor.withValues(
                                    alpha: 0.1,
                                  ),
                                  borderRadius: BorderRadius.circular(32),
                                ),
                                child: Center(
                                  child: Icon(
                                    page.icon,
                                    size: 100,
                                    color: page.gradientColor,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),

        // Text Content Area (Bottom ~40%)
        Expanded(
          flex: 2,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(32, 16, 32, 128),
            child: Column(
              children: [
                Text(
                  page.title,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w800,
                    color: isDark ? Colors.white : const Color(0xFF0F172A),
                    letterSpacing: -0.5,
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  page.description,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: isDark
                        ? const Color(0xFF94A3B8)
                        : const Color(0xFF64748B),
                    height: 1.6,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

/// Animated floating blob decoration
class _FloatingBlob extends StatefulWidget {
  final double size;
  final Color color;
  final Duration delay;

  const _FloatingBlob({
    required this.size,
    required this.color,
    this.delay = Duration.zero,
  });

  @override
  State<_FloatingBlob> createState() => _FloatingBlobState();
}

class _FloatingBlobState extends State<_FloatingBlob>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    _animation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    Future.delayed(widget.delay, () {
      if (mounted) {
        _controller.repeat(reverse: true);
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Transform.scale(
          scale: _animation.value,
          child: Container(
            width: widget.size,
            height: widget.size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: widget.color,
            ),
          ),
        );
      },
    );
  }
}
