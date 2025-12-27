import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:toastification/toastification.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/config/white_label_config.dart';
import '../../../l10n/app_localizations.dart';
import 'providers/auth_provider.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _referralController = TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _agreedToTerms = false;
  bool _showReferralField = false;
  final String _selectedCountryCode = '+1';
  final String _selectedCountryFlag = '🇺🇸';

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _referralController.dispose();
    super.dispose();
  }

  // Password strength calculation
  int _getPasswordStrength(String password) {
    if (password.isEmpty) return 0;
    int strength = 0;
    if (password.length >= 8) strength++;
    if (password.contains(RegExp(r'[A-Z]'))) strength++;
    if (password.contains(RegExp(r'[0-9]'))) strength++;
    if (password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) strength++;
    return strength;
  }

  String _getPasswordStrengthLabel(int strength) {
    switch (strength) {
      case 0:
        return 'Too weak';
      case 1:
        return 'Weak';
      case 2:
        return 'Medium';
      case 3:
        return 'Strong';
      case 4:
        return 'Very Strong';
      default:
        return '';
    }
  }

  Color _getPasswordStrengthColor(int strength) {
    switch (strength) {
      case 0:
      case 1:
        return Colors.red;
      case 2:
        return Colors.orange;
      case 3:
        return Colors.green;
      case 4:
        return Colors.green.shade700;
      default:
        return Colors.grey;
    }
  }

  void _register() async {
    final l10n = AppLocalizations.of(context)!;
    if (!_agreedToTerms) {
      toastification.show(
        context: context,
        type: ToastificationType.warning,
        title: Text(l10n.agreeToTermsWarning),
        autoCloseDuration: const Duration(seconds: 2),
      );
      return;
    }

    if (_formKey.currentState!.validate()) {
      if (_passwordController.text != _confirmPasswordController.text) {
        toastification.show(
          context: context,
          type: ToastificationType.error,
          title: Text(l10n.passwordsDoNotMatch),
          autoCloseDuration: const Duration(seconds: 2),
        );
        return;
      }

      final success = await ref
          .read(authControllerProvider.notifier)
          .register(
            _nameController.text.trim(),
            _emailController.text.trim(),
            _passwordController.text,
          );

      if (success && mounted) {
        toastification.show(
          context: context,
          type: ToastificationType.success,
          style: ToastificationStyle.minimal,
          title: Text(l10n.accountCreated),
          description: Text(WhiteLabelConfig.welcomeMessage),
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
        final error = ref.read(authControllerProvider).error;
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

  void _signInWithApple() {
    toastification.show(
      context: context,
      type: ToastificationType.info,
      title: const Text('Apple Sign-In'),
      description: const Text('Coming soon!'),
      autoCloseDuration: const Duration(seconds: 2),
    );
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authControllerProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context)!;
    // Theme-aware colors using AppColors
    final backgroundColor = AppColors.getBackground(context);
    final surfaceColor = AppColors.getCard(context);
    final textColor = AppColors.getTextPrimary(context);
    final subtextColor = AppColors.adaptive(
      context,
      AppColors.textSecondary,
      AppColors.darkTextSecondary,
    );
    final borderColor = AppColors.adaptive(
      context,
      AppColors.border,
      AppColors.darkBorder,
    );

    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            // Top App Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => context.pop(),
                    icon: Icon(LucideIcons.arrowLeft, color: textColor),
                    style: IconButton.styleFrom(
                      backgroundColor: isDark
                          ? Colors.white.withValues(alpha: 0.05)
                          : Colors.black.withValues(alpha: 0.05),
                    ),
                  ),
                ],
              ),
            ),

            // Scrollable Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Header
                      Text(
                        l10n.createAccount,
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: textColor,
                          letterSpacing: -0.5,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        l10n.createAccountSubtitle,
                        style: TextStyle(fontSize: 16, color: subtextColor),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 24),

                      // Avatar Upload
                      GestureDetector(
                        onTap: () {
                          // TODO: Implement image picker
                        },
                        child: Stack(
                          children: [
                            Container(
                              width: 112,
                              height: 112,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: isDark
                                    ? const Color(0xFF1E293B)
                                    : const Color(0xFFE2E8F0),
                                border: Border.all(
                                  color: isDark
                                      ? AppColors.darkBorder
                                      : Colors.white,
                                  width: 4,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.1),
                                    blurRadius: 10,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Icon(
                                LucideIcons.user,
                                size: 48,
                                color: subtextColor,
                              ),
                            ),
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: AppColors.primary,
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: backgroundColor,
                                    width: 4,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: AppColors.primary.withValues(
                                        alpha: 0.3,
                                      ),
                                      blurRadius: 8,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: const Icon(
                                  LucideIcons.camera,
                                  size: 18,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 32),

                      // Error Message
                      if (authState.error != null) ...[
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.red.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: Colors.red.withValues(alpha: 0.3),
                            ),
                          ),
                          child: Row(
                            children: [
                              const Icon(
                                LucideIcons.alertCircle,
                                color: Colors.red,
                                size: 20,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  authState.error!,
                                  style: const TextStyle(color: Colors.red),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                      ],

                      // Full Name Field
                      _buildInputField(
                        label: 'Full Name',
                        controller: _nameController,
                        icon: LucideIcons.user,
                        placeholder: 'John Doe',
                        isDark: isDark,
                        surfaceColor: surfaceColor,
                        textColor: textColor,
                        borderColor: borderColor,
                        validator: (v) =>
                            v!.isEmpty ? 'Name is required' : null,
                      ),
                      const SizedBox(height: 20),

                      // Email Field
                      _buildInputField(
                        label: 'Email Address',
                        controller: _emailController,
                        icon: LucideIcons.mail,
                        placeholder: 'example@email.com',
                        keyboardType: TextInputType.emailAddress,
                        isDark: isDark,
                        surfaceColor: surfaceColor,
                        textColor: textColor,
                        borderColor: borderColor,
                        validator: (v) =>
                            v!.isEmpty ? 'Email is required' : null,
                      ),
                      const SizedBox(height: 20),

                      // Phone Number Field
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Phone Number',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: textColor,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              // Country Code Selector
                              Container(
                                height: 56,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                ),
                                decoration: BoxDecoration(
                                  color: surfaceColor,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(color: borderColor),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      _selectedCountryFlag,
                                      style: const TextStyle(fontSize: 20),
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      _selectedCountryCode,
                                      style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        color: textColor,
                                      ),
                                    ),
                                    Icon(
                                      LucideIcons.chevronDown,
                                      size: 16,
                                      color: subtextColor,
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 12),
                              // Phone Input
                              Expanded(
                                child: Container(
                                  height: 56,
                                  decoration: BoxDecoration(
                                    color: surfaceColor,
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(color: borderColor),
                                  ),
                                  child: Row(
                                    children: [
                                      const SizedBox(width: 16),
                                      Icon(
                                        LucideIcons.phone,
                                        size: 20,
                                        color: subtextColor,
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: TextField(
                                          controller: _phoneController,
                                          keyboardType: TextInputType.phone,
                                          style: TextStyle(
                                            color: textColor,
                                            fontWeight: FontWeight.w500,
                                          ),
                                          decoration: InputDecoration(
                                            hintText: '000 000 0000',
                                            hintStyle: TextStyle(
                                              color: subtextColor,
                                            ),
                                            border: InputBorder.none,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),

                      // Password Field with Strength Indicator
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildInputField(
                            label: 'Password',
                            controller: _passwordController,
                            icon: LucideIcons.lock,
                            placeholder: 'Create a password',
                            obscureText: _obscurePassword,
                            isDark: isDark,
                            surfaceColor: surfaceColor,
                            textColor: textColor,
                            borderColor: borderColor,
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscurePassword
                                    ? LucideIcons.eyeOff
                                    : LucideIcons.eye,
                                size: 20,
                                color: subtextColor,
                              ),
                              onPressed: () => setState(
                                () => _obscurePassword = !_obscurePassword,
                              ),
                            ),
                            validator: (v) => v!.length < 8
                                ? 'Password must be at least 8 characters'
                                : null,
                            onChanged: (v) => setState(() {}),
                          ),
                          const SizedBox(height: 8),
                          // Password Strength Indicator
                          Builder(
                            builder: (context) {
                              final strength = _getPasswordStrength(
                                _passwordController.text,
                              );
                              final strengthColor = _getPasswordStrengthColor(
                                strength,
                              );
                              return Column(
                                children: [
                                  Row(
                                    children: List.generate(4, (index) {
                                      return Expanded(
                                        child: Container(
                                          height: 6,
                                          margin: EdgeInsets.only(
                                            right: index < 3 ? 6 : 0,
                                          ),
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(
                                              3,
                                            ),
                                            color: index < strength
                                                ? strengthColor
                                                : AppColors.adaptive(
                                                    context,
                                                    AppColors.border,
                                                    AppColors.darkBorder,
                                                  ),
                                          ),
                                        ),
                                      );
                                    }),
                                  ),
                                  const SizedBox(height: 8),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Strength: ${_getPasswordStrengthLabel(strength)}',
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500,
                                          color: strengthColor,
                                        ),
                                      ),
                                      Text(
                                        'Must contain 8+ chars',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: subtextColor,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              );
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),

                      // Confirm Password Field
                      _buildInputField(
                        label: 'Confirm Password',
                        controller: _confirmPasswordController,
                        icon: LucideIcons.lock,
                        placeholder: 'Re-enter password',
                        obscureText: _obscureConfirmPassword,
                        isDark: isDark,
                        surfaceColor: surfaceColor,
                        textColor: textColor,
                        borderColor: borderColor,
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscureConfirmPassword
                                ? LucideIcons.eyeOff
                                : LucideIcons.eye,
                            size: 20,
                            color: subtextColor,
                          ),
                          onPressed: () => setState(
                            () => _obscureConfirmPassword =
                                !_obscureConfirmPassword,
                          ),
                        ),
                        validator: (v) =>
                            v!.isEmpty ? 'Please confirm your password' : null,
                      ),
                      const SizedBox(height: 20),

                      // Referral Code (Expandable)
                      GestureDetector(
                        onTap: () => setState(
                          () => _showReferralField = !_showReferralField,
                        ),
                        child: Row(
                          children: [
                            Icon(
                              _showReferralField
                                  ? LucideIcons.chevronDown
                                  : LucideIcons.chevronRight,
                              size: 18,
                              color: AppColors.primary,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Have a referral code?',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: AppColors.primary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (_showReferralField) ...[
                        const SizedBox(height: 12),
                        _buildInputField(
                          controller: _referralController,
                          icon: LucideIcons.ticket,
                          placeholder: 'Enter code (Optional)',
                          isDark: isDark,
                          surfaceColor: surfaceColor,
                          textColor: textColor,
                          borderColor: borderColor,
                        ),
                      ],
                      const SizedBox(height: 20),

                      // Terms & Privacy
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: 24,
                            height: 24,
                            child: Checkbox(
                              value: _agreedToTerms,
                              onChanged: (v) =>
                                  setState(() => _agreedToTerms = v ?? false),
                              activeColor: AppColors.primary,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text.rich(
                              TextSpan(
                                text: 'I agree to the ',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: subtextColor,
                                ),
                                children: [
                                  TextSpan(
                                    text: 'Terms of Service',
                                    style: TextStyle(
                                      color: AppColors.primary,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const TextSpan(text: ' and '),
                                  TextSpan(
                                    text: 'Privacy Policy',
                                    style: TextStyle(
                                      color: AppColors.primary,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const TextSpan(text: '.'),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),

                      // Create Account Button
                      SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: ElevatedButton(
                          onPressed: authState.isLoading ? null : _register,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 4,
                            shadowColor: AppColors.primary.withValues(
                              alpha: 0.3,
                            ),
                          ),
                          child: authState.isLoading
                              ? const SizedBox(
                                  width: 24,
                                  height: 24,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2.5,
                                    color: Colors.white,
                                  ),
                                )
                              : const Text(
                                  'Create Account',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Divider
                      Row(
                        children: [
                          Expanded(child: Divider(color: borderColor)),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Text(
                              'Or continue with',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: subtextColor,
                              ),
                            ),
                          ),
                          Expanded(child: Divider(color: borderColor)),
                        ],
                      ),
                      const SizedBox(height: 24),

                      // Social Login Buttons
                      Row(
                        children: [
                          Expanded(
                            child: _buildSocialButton(
                              icon: 'assets/icons/google.png',
                              label: 'Google',
                              onTap: () => _signInWithGoogle(),
                              isDark: isDark,
                              surfaceColor: surfaceColor,
                              textColor: textColor,
                              borderColor: borderColor,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: _buildSocialButton(
                              icon: 'assets/icons/apple.png',
                              label: 'Apple',
                              onTap: () => _signInWithApple(),
                              isDark: isDark,
                              surfaceColor: surfaceColor,
                              textColor: textColor,
                              borderColor: borderColor,
                              isApple: true,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),

                      // Already have account
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Already have an account?',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: subtextColor,
                            ),
                          ),
                          TextButton(
                            onPressed: () => context.push('/login'),
                            child: const Text(
                              'Login',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: AppColors.primary,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 32),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputField({
    String? label,
    required TextEditingController controller,
    required IconData icon,
    required String placeholder,
    TextInputType? keyboardType,
    bool obscureText = false,
    required bool isDark,
    required Color surfaceColor,
    required Color textColor,
    required Color borderColor,
    Widget? suffixIcon,
    String? Function(String?)? validator,
    void Function(String)? onChanged,
  }) {
    final subtextColor = isDark
        ? const Color(0xFF94A3B8)
        : const Color(0xFF64748B);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null) ...[
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: textColor,
            ),
          ),
          const SizedBox(height: 8),
        ],
        Container(
          height: 56,
          decoration: BoxDecoration(
            color: surfaceColor,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: borderColor),
          ),
          child: Row(
            children: [
              const SizedBox(width: 16),
              Icon(icon, size: 20, color: subtextColor),
              const SizedBox(width: 12),
              Expanded(
                child: TextFormField(
                  controller: controller,
                  keyboardType: keyboardType,
                  obscureText: obscureText,
                  style: TextStyle(
                    color: textColor,
                    fontWeight: FontWeight.w500,
                  ),
                  decoration: InputDecoration(
                    hintText: placeholder,
                    hintStyle: TextStyle(color: subtextColor),
                    border: InputBorder.none,
                    errorStyle: const TextStyle(height: 0, fontSize: 0),
                  ),
                  validator: validator,
                  onChanged: onChanged,
                ),
              ),
              if (suffixIcon != null) suffixIcon,
              const SizedBox(width: 4),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSocialButton({
    required String icon,
    required String label,
    required VoidCallback onTap,
    required bool isDark,
    required Color surfaceColor,
    required Color textColor,
    required Color borderColor,
    bool isApple = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 48,
        decoration: BoxDecoration(
          color: surfaceColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: borderColor),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isApple ? LucideIcons.apple : LucideIcons.chrome,
              size: 20,
              color: textColor,
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: textColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
