import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:toastification/toastification.dart';
import '../../../core/theme/app_colors.dart';
import '../../../l10n/app_localizations.dart';
import 'providers/auth_provider.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _rememberMe = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _login() async {
    if (_formKey.currentState!.validate()) {
      final success = await ref
          .read(authControllerProvider.notifier)
          .login(_emailController.text.trim(), _passwordController.text);

      if (success && mounted) {
        final l10n = AppLocalizations.of(context)!;
        toastification.show(
          context: context,
          type: ToastificationType.success,
          style: ToastificationStyle.minimal,
          title: Text(l10n.welcome),
          autoCloseDuration: const Duration(seconds: 2),
        );
        context.go('/');
      }
    }
  }

  void _signInWithGoogle() async {
    final success = await ref
        .read(authControllerProvider.notifier)
        .signInWithGoogle();

    if (mounted) {
      final l10n = AppLocalizations.of(context)!;
      if (success) {
        toastification.show(
          context: context,
          type: ToastificationType.success,
          style: ToastificationStyle.minimal,
          title: Text(l10n.welcome),
          autoCloseDuration: const Duration(seconds: 2),
        );
        context.go('/');
      } else {
        final error = ref.read(authControllerProvider).value?.error;
        if (error != null && error != 'Sign-in cancelled') {
          toastification.show(
            context: context,
            type: ToastificationType.error,
            style: ToastificationStyle.minimal,
            title: Text(error),
            autoCloseDuration: const Duration(seconds: 3),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final authStateAsync = ref.watch(authControllerProvider);
    final authState = authStateAsync.value;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context)!;

    // Theme-aware colors using AppColors
    final bgColor = AppColors.adaptive(
      context,
      const Color(0xFFF9FAFB),
      AppColors.darkBackground,
    );
    final surfaceColor = AppColors.adaptive(
      context,
      Colors.white,
      AppColors.darkCard,
    );
    final textMain = AppColors.getTextPrimary(context);
    final textSecondary = AppColors.adaptive(
      context,
      const Color(0xFF6B7280),
      AppColors.darkTextSecondary,
    );
    final inputBg = AppColors.adaptive(
      context,
      const Color(0xFFF3F4F6),
      AppColors.darkInput,
    );
    final dividerColor = AppColors.adaptive(
      context,
      const Color(0xFFE5E7EB),
      AppColors.darkBorder,
    );

    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Container(
              constraints: const BoxConstraints(maxWidth: 400),
              decoration: BoxDecoration(
                color: surfaceColor,
                borderRadius: BorderRadius.circular(32),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withAlpha(isDark ? 50 : 26),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Header Icon
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: AppColors.accent.withAlpha(26),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          Icons.lock_outline,
                          color: AppColors.accent,
                          size: 28,
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Title
                      Text(
                        l10n.welcome,
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: textMain,
                          letterSpacing: -0.5,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        l10n.loginSubtitle,
                        style: TextStyle(fontSize: 16, color: textSecondary),
                      ),
                      const SizedBox(height: 32),

                      // Error Message
                      if (authState?.error != null) ...[
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: AppColors.errorLight,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: AppColors.error.withAlpha(77),
                            ),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.error_outline,
                                color: AppColors.error,
                                size: 20,
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  authState!.error!,
                                  style: TextStyle(color: AppColors.error),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                      ],

                      // Email Input
                      Container(
                        decoration: BoxDecoration(
                          color: inputBg,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: TextFormField(
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: textMain,
                          ),
                          decoration: InputDecoration(
                            hintText: l10n.emailOrPhone,
                            hintStyle: TextStyle(
                              color: AppColors.adaptive(
                                context,
                                const Color(0xFF9CA3AF),
                                AppColors.darkTextHint,
                              ),
                              fontWeight: FontWeight.w500,
                            ),
                            prefixIcon: Icon(
                              Icons.mail_outline,
                              color: AppColors.adaptive(
                                context,
                                const Color(0xFF9CA3AF),
                                AppColors.darkTextHint,
                              ),
                              size: 22,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: BorderSide.none,
                            ),
                            filled: true,
                            fillColor: inputBg,
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 16,
                            ),
                          ),
                          validator: (v) =>
                              v!.isEmpty ? l10n.emailRequired : null,
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Password Input
                      Container(
                        decoration: BoxDecoration(
                          color: inputBg,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: TextFormField(
                          controller: _passwordController,
                          obscureText: _obscurePassword,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: textMain,
                          ),
                          decoration: InputDecoration(
                            hintText: l10n.password,
                            hintStyle: TextStyle(
                              color: AppColors.adaptive(
                                context,
                                const Color(0xFF9CA3AF),
                                AppColors.darkTextHint,
                              ),
                              fontWeight: FontWeight.w500,
                            ),
                            prefixIcon: Icon(
                              Icons.key_outlined,
                              color: AppColors.adaptive(
                                context,
                                const Color(0xFF9CA3AF),
                                AppColors.darkTextHint,
                              ),
                              size: 22,
                            ),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscurePassword
                                    ? Icons.visibility_off_outlined
                                    : Icons.visibility_outlined,
                                color: AppColors.adaptive(
                                  context,
                                  const Color(0xFF9CA3AF),
                                  AppColors.darkTextHint,
                                ),
                                size: 20,
                              ),
                              onPressed: () => setState(
                                () => _obscurePassword = !_obscurePassword,
                              ),
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: BorderSide.none,
                            ),
                            filled: true,
                            fillColor: inputBg,
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 16,
                            ),
                          ),
                          validator: (v) =>
                              v!.length < 6 ? l10n.passwordMinLength : null,
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Remember Me & Forgot Password
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              SizedBox(
                                width: 20,
                                height: 20,
                                child: Checkbox(
                                  value: _rememberMe,
                                  onChanged: (value) {
                                    setState(() {
                                      _rememberMe = value ?? false;
                                    });
                                  },
                                  activeColor: AppColors.accent,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                l10n.rememberMe,
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: textSecondary,
                                ),
                              ),
                            ],
                          ),
                          GestureDetector(
                            onTap: () {
                              // Navigate to forgot password
                            },
                            child: Text(
                              l10n.forgotPassword,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: AppColors.accent,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),

                      // Sign In Button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: (authState?.isLoading ?? false)
                              ? null
                              : _login,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.accent,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            elevation: 0,
                          ),
                          child: (authState?.isLoading ?? false)
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                              : Text(
                                  l10n.signIn,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Face ID / Touch ID Button
                      SizedBox(
                        width: double.infinity,
                        child: TextButton.icon(
                          onPressed: () {
                            toastification.show(
                              context: context,
                              type: ToastificationType.info,
                              title: Text(l10n.biometricComingSoon),
                              autoCloseDuration: const Duration(seconds: 2),
                            );
                          },
                          icon: Icon(
                            Icons.fingerprint,
                            color: AppColors.accent,
                            size: 20,
                          ),
                          label: Text(
                            l10n.useBiometric,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: AppColors.accent,
                            ),
                          ),
                          style: TextButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 32),

                      // Divider
                      Row(
                        children: [
                          Expanded(child: Divider(color: dividerColor)),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Text(
                              l10n.orContinueWith,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: textSecondary,
                              ),
                            ),
                          ),
                          Expanded(child: Divider(color: dividerColor)),
                        ],
                      ),
                      const SizedBox(height: 24),

                      // Social Login Buttons
                      Row(
                        children: [
                          Expanded(
                            child: _buildSocialButton(
                              onTap: () => _signInWithGoogle(),
                              iconUrl: 'https://www.google.com/favicon.ico',
                              fallbackIcon: Icons.g_mobiledata,
                              isDark: isDark,
                              dividerColor: dividerColor,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: _buildSocialButton(
                              onTap: () {
                                toastification.show(
                                  context: context,
                                  type: ToastificationType.info,
                                  title: Text(l10n.appleSignInComingSoon),
                                  autoCloseDuration: const Duration(seconds: 2),
                                );
                              },
                              iconUrl: null,
                              fallbackIcon: Icons.apple,
                              isDark: isDark,
                              dividerColor: dividerColor,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: _buildSocialButton(
                              onTap: () {
                                toastification.show(
                                  context: context,
                                  type: ToastificationType.info,
                                  title: Text(l10n.facebookSignInComingSoon),
                                  autoCloseDuration: const Duration(seconds: 2),
                                );
                              },
                              iconUrl: null,
                              fallbackIcon: Icons.facebook,
                              iconColor: AppColors.info,
                              isDark: isDark,
                              dividerColor: dividerColor,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 32),

                      // Sign Up Link
                      Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              l10n.noAccount,
                              style: TextStyle(
                                fontSize: 14,
                                color: textSecondary,
                              ),
                            ),
                            const SizedBox(width: 4),
                            GestureDetector(
                              onTap: () => context.push('/register'),
                              child: Text(
                                l10n.signUp,
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.accent,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Home Indicator
                      Center(
                        child: Container(
                          width: 128,
                          height: 4,
                          decoration: BoxDecoration(
                            color: dividerColor,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSocialButton({
    required VoidCallback onTap,
    required String? iconUrl,
    required IconData fallbackIcon,
    required bool isDark,
    required Color dividerColor,
    Color? iconColor,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
          color: AppColors.adaptive(context, Colors.white, AppColors.darkCard),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: dividerColor),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(8),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Center(
          child: iconUrl != null
              ? Image.network(
                  iconUrl,
                  width: 24,
                  height: 24,
                  errorBuilder: (context, error, stackTrace) =>
                      Icon(fallbackIcon, size: 24, color: iconColor),
                )
              : Icon(
                  fallbackIcon,
                  size: 24,
                  color: iconColor ?? (isDark ? Colors.white : Colors.black),
                ),
        ),
      ),
    );
  }
}
