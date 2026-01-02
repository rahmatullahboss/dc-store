import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/config/white_label_config.dart';
import '../../services/storage_service.dart';
import '../../core/constants/storage_keys.dart';

/// Splash screen status enumeration
enum SplashStatus { loading, error }

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen>
    with SingleTickerProviderStateMixin {
  SplashStatus _status = SplashStatus.loading;
  late AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);

    _initializeApp();
  }

  Future<void> _initializeApp() async {
    try {
      // Get storage service and check onboarding status
      final storageService = await StorageService.getInstance();
      final isOnboardingComplete =
          storageService.getBool(StorageKeys.onboardingComplete) ?? false;

      // Simulate initialization (network check, auth, data preload)
      await Future.delayed(const Duration(seconds: 2));

      // Navigate based on onboarding status
      if (mounted) {
        if (isOnboardingComplete) {
          // Onboarding already done, go to home
          context.go('/');
        } else {
          // First time user, show onboarding
          context.go('/onboarding');
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _status = SplashStatus.error;
        });
      }
    }
  }

  void _retry() {
    setState(() {
      _status = SplashStatus.loading;
    });
    _initializeApp();
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = isDark
        ? AppColors.darkBackground
        : const Color(0xFFF6F6F8);
    final primaryColor = WhiteLabelConfig.accentColor;
    final textColor = isDark ? Colors.white : const Color(0xFF0F172A);
    final subtextColor = isDark
        ? const Color(0xFF94A3B8)
        : const Color(0xFF64748B);

    return Scaffold(
      backgroundColor: backgroundColor,
      body: LayoutBuilder(
        builder: (context, constraints) {
          // Calculate responsive sizes based on screen dimensions
          final screenWidth = constraints.maxWidth;
          final screenHeight = constraints.maxHeight;
          final isLargeScreen = screenWidth > 600;

          // Responsive circle sizes for background decorations
          final circleSize = isLargeScreen
              ? screenWidth * 0.4
              : screenWidth * 0.8;
          final circleSizeClamped = circleSize.clamp(300.0, 600.0);

          // Responsive logo size
          final logoOuterSize = isLargeScreen ? 180.0 : 140.0;
          final logoInnerSize = isLargeScreen ? 144.0 : 112.0;
          final logoIconSize = isLargeScreen ? 72.0 : 56.0;

          // Responsive text sizes
          final titleSize = isLargeScreen ? 52.0 : 40.0;
          final subtitleSize = isLargeScreen ? 16.0 : 14.0;

          return Stack(
            fit: StackFit.expand,
            children: [
              // Full screen gradient background
              Container(
                width: double.infinity,
                height: double.infinity,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      backgroundColor,
                      isDark
                          ? primaryColor.withValues(alpha: 0.05)
                          : primaryColor.withValues(alpha: 0.02),
                      backgroundColor,
                    ],
                  ),
                ),
              ),

              // Decorative Background Elements - Top Left
              Positioned(
                left: -circleSizeClamped * 0.2,
                top: -circleSizeClamped * 0.2,
                child: Container(
                  height: circleSizeClamped,
                  width: circleSizeClamped,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        primaryColor.withValues(alpha: isDark ? 0.15 : 0.08),
                        primaryColor.withValues(alpha: isDark ? 0.05 : 0.02),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ),

              // Decorative Background Elements - Bottom Right
              Positioned(
                right: -circleSizeClamped * 0.2,
                bottom: -circleSizeClamped * 0.2,
                child: Container(
                  height: circleSizeClamped,
                  width: circleSizeClamped,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        primaryColor.withValues(alpha: isDark ? 0.08 : 0.12),
                        primaryColor.withValues(alpha: isDark ? 0.02 : 0.04),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ),

              // Center accent circle
              if (isLargeScreen)
                Positioned(
                  left: screenWidth * 0.5 - circleSizeClamped * 0.3,
                  top: screenHeight * 0.5 - circleSizeClamped * 0.3,
                  child: Container(
                    height: circleSizeClamped * 0.6,
                    width: circleSizeClamped * 0.6,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [
                          primaryColor.withValues(alpha: 0.03),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                ),

              // Blur effect overlay - fills entire screen
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: RadialGradient(
                      center: Alignment.topLeft,
                      radius: 2.0,
                      colors: [
                        primaryColor.withValues(alpha: 0.05),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ),

              // Main Content - centered and responsive
              SafeArea(
                child: Center(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      maxWidth: isLargeScreen ? 500 : double.infinity,
                    ),
                    child: Column(
                      children: [
                        // Top Spacer
                        const Spacer(flex: 2),

                        // Centered Content
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: isLargeScreen ? 48 : 24,
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // Logo Container with Glow
                              _buildResponsiveLogoSection(
                                primaryColor,
                                isDark,
                                logoOuterSize,
                                logoInnerSize,
                                logoIconSize,
                              ),

                              SizedBox(height: isLargeScreen ? 48 : 32),

                              // App Name & Slogan
                              _buildResponsiveAppNameSection(
                                textColor,
                                subtextColor,
                                titleSize,
                                subtitleSize,
                              ),

                              SizedBox(height: isLargeScreen ? 48 : 32),

                              // Status Indicator
                              AnimatedSwitcher(
                                duration: const Duration(milliseconds: 300),
                                child: _status == SplashStatus.loading
                                    ? _buildLoadingState(primaryColor, isDark)
                                    : _buildErrorState(isDark),
                              ),
                            ],
                          ),
                        ),

                        // Bottom Spacer with Version
                        const Spacer(flex: 2),

                        // Version Info
                        Padding(
                          padding: EdgeInsets.only(
                            bottom: isLargeScreen ? 48 : 32,
                          ),
                          child: Text(
                            'Version 1.0.0 (Build 204)',
                            style: TextStyle(
                              fontSize: isLargeScreen ? 14 : 12,
                              fontWeight: FontWeight.w500,
                              color: isDark
                                  ? const Color(0xFF475569)
                                  : const Color(0xFF94A3B8),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildResponsiveLogoSection(
    Color primaryColor,
    bool isDark,
    double outerSize,
    double innerSize,
    double iconSize,
  ) {
    return AnimatedBuilder(
      animation: _pulseController,
      builder: (context, child) {
        final scale = 1.0 + (_pulseController.value * 0.05);
        return Transform.scale(
          scale: scale,
          child: Container(
            height: outerSize,
            width: outerSize,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(outerSize * 0.2),
              boxShadow: [
                BoxShadow(
                  color: primaryColor.withValues(alpha: 0.3),
                  blurRadius: 40,
                  spreadRadius: 10,
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(outerSize * 0.2),
              child: Image.asset('assets/images/logo.png', fit: BoxFit.contain),
            ),
          ),
        );
      },
    );
  }

  Widget _buildResponsiveAppNameSection(
    Color textColor,
    Color subtextColor,
    double titleSize,
    double subtitleSize,
  ) {
    return Column(
      children: [
        Text(
          WhiteLabelConfig.appName,
          style: TextStyle(
            fontSize: titleSize,
            fontWeight: FontWeight.w800,
            color: textColor,
            letterSpacing: -1,
            height: 1.1,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Handcrafted experiences, delivered to perfection',
          style: TextStyle(
            fontSize: subtitleSize,
            fontWeight: FontWeight.w500,
            color: subtextColor,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildLoadingState(Color primaryColor, bool isDark) {
    return Container(
      key: const ValueKey('loading'),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : Colors.white,
        borderRadius: BorderRadius.circular(999),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(
          color: isDark
              ? Colors.white.withValues(alpha: 0.1)
              : const Color(0xFF0F172A).withValues(alpha: 0.05),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: 20,
            width: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2.5,
              color: primaryColor,
            ),
          ),
          const SizedBox(width: 12),
          Text(
            'Setting things up...',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: isDark ? const Color(0xFFCBD5E1) : const Color(0xFF475569),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(bool isDark) {
    return Container(
      key: const ValueKey('error'),
      child: Column(
        children: [
          // Error Card
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: isDark
                  ? const Color(0xFF1E293B).withValues(alpha: 0.5)
                  : Colors.white.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isDark
                    ? Colors.white.withValues(alpha: 0.1)
                    : Colors.black.withValues(alpha: 0.05),
              ),
            ),
            child: Column(
              children: [
                // Error Icon
                Container(
                  height: 48,
                  width: 48,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isDark
                        ? const Color(0xFF7F1D1D).withValues(alpha: 0.3)
                        : const Color(0xFFFEE2E2),
                  ),
                  child: Icon(
                    Icons.wifi_off_rounded,
                    color: isDark
                        ? const Color(0xFFFCA5A5)
                        : const Color(0xFFEF4444),
                    size: 24,
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: 200,
                  child: Text(
                    'Unable to connect. Please check your internet.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: isDark
                          ? const Color(0xFFCBD5E1)
                          : const Color(0xFF475569),
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Retry Button
          Material(
            color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
            borderRadius: BorderRadius.circular(12),
            child: InkWell(
              onTap: _retry,
              borderRadius: BorderRadius.circular(12),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 14,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.refresh_rounded,
                      size: 20,
                      color: isDark ? Colors.white : const Color(0xFF0F172A),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Retry',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: isDark ? Colors.white : const Color(0xFF0F172A),
                      ),
                    ),
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
