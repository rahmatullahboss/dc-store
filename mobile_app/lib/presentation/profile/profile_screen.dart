import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../core/providers/theme_provider.dart';
import '../../features/auth/presentation/providers/auth_provider.dart';

/// Redesigned Profile Screen
/// Features: Profile header with stats, grouped settings sections,
/// toggle switches, and full dark mode support
class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authControllerProvider);

    if (!authState.isAuthenticated) {
      return _buildGuestView(context);
    }

    return _buildAuthenticatedView(context, ref, authState);
  }

  Widget _buildGuestView(BuildContext context) {
    const primaryColor = Color(0xFF4F46E5);
    final bgColor = const Color(0xFFF9FAFB);
    final textMain = const Color(0xFF111827);
    final textSecondary = const Color(0xFF6B7280);

    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Container(
              constraints: const BoxConstraints(maxWidth: 400),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(32),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withAlpha(
                      25,
                    ), // Equivalent to withValues(alpha: 0.1)
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Lock Icon
                    Container(
                      width: 64,
                      height: 64,
                      decoration: BoxDecoration(
                        color: const Color(0xFFE0E7FF),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Icon(
                        Icons.lock_outline,
                        color: primaryColor,
                        size: 32,
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Title
                    Text(
                      'Welcome',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: textMain,
                        letterSpacing: -0.5,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Sign in to access your orders, wishlist, and personalized experience.',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16, color: textSecondary),
                    ),
                    const SizedBox(height: 32),

                    // Sign In Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () => context.push('/login'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryColor,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          elevation: 0,
                        ),
                        child: const Text(
                          'Sign In',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Create Account Button
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton(
                        onPressed: () => context.push('/register'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: textMain,
                          side: const BorderSide(color: Color(0xFFE5E7EB)),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: const Text(
                          'Create Account',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Divider
                    Row(
                      children: [
                        const Expanded(
                          child: Divider(color: Color(0xFFE5E7EB)),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Text(
                            'Or continue with',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: textSecondary,
                            ),
                          ),
                        ),
                        const Expanded(
                          child: Divider(color: Color(0xFFE5E7EB)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // Social Login Row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildSocialButton(Icons.g_mobiledata, null),
                        const SizedBox(width: 16),
                        _buildSocialButton(Icons.apple, Colors.black),
                        const SizedBox(width: 16),
                        _buildSocialButton(
                          Icons.facebook,
                          const Color(0xFF1877F2),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSocialButton(IconData icon, Color? iconColor) {
    return Container(
      width: 56,
      height: 48,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE5E7EB)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(
              7,
            ), // Equivalent to withValues(alpha: 0.03)
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Icon(icon, size: 24, color: iconColor ?? Colors.black),
    );
  }

  Widget _buildAuthenticatedView(
    BuildContext context,
    WidgetRef ref,
    AuthState authState,
  ) {
    final user = authState.user!;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final themeMode = ref.watch(themeModeProvider);

    // Theme colors
    final bgColor = isDark ? const Color(0xFF101622) : const Color(0xFFF9FAFB);
    final surfaceColor = isDark ? const Color(0xFF1b2431) : Colors.white;
    final textColor = isDark ? Colors.white : const Color(0xFF111827);
    final subtleColor = isDark ? Colors.grey[400]! : const Color(0xFF6B7280);
    final borderColor = isDark ? Colors.grey[800]! : Colors.grey[100]!;
    const primaryColor = Color(0xFF4F46E5);
    const primarySoft = Color(0xFFEEF2FF);

    return Scaffold(
      backgroundColor: bgColor,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Profile Header
            Container(
              decoration: BoxDecoration(
                color: surfaceColor,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(24),
                  bottomRight: Radius.circular(24),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withAlpha(13),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: SafeArea(
                bottom: false,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(24, 24, 24, 24),
                  child: Column(
                    children: [
                      // Avatar with edit button
                      Stack(
                        children: [
                          Container(
                            width: 96,
                            height: 96,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: isDark
                                    ? primaryColor.withAlpha(77)
                                    : primarySoft,
                                width: 4,
                              ),
                            ),
                            child: ClipOval(
                              child: _buildAvatarPlaceholder(
                                user,
                                primaryColor,
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: Container(
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: primaryColor,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: surfaceColor,
                                  width: 2,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withAlpha(26),
                                    blurRadius: 4,
                                  ),
                                ],
                              ),
                              child: const Icon(
                                LucideIcons.pencil,
                                color: Colors.white,
                                size: 12,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Name
                      Text(
                        user.name ?? "User",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: textColor,
                        ),
                      ),
                      const SizedBox(height: 4),

                      // Email
                      Text(
                        user.email,
                        style: TextStyle(fontSize: 14, color: subtleColor),
                      ),
                      const SizedBox(height: 12),

                      // Edit Profile Button
                      ElevatedButton(
                        onPressed: () => context.push('/profile/edit'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: textColor,
                          foregroundColor: surfaceColor,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 10,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50),
                          ),
                          elevation: 0,
                        ),
                        child: const Text(
                          'Edit Profile',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Member badges
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: isDark
                                  ? primaryColor.withAlpha(51)
                                  : primarySoft,
                              borderRadius: BorderRadius.circular(50),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  LucideIcons.award,
                                  size: 14,
                                  color: primaryColor,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  'Gold Member',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    color: primaryColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 16),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                LucideIcons.calendar,
                                size: 14,
                                color: subtleColor,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                'Member since 2021',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: subtleColor,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Stats Card
            Padding(
              padding: const EdgeInsets.all(20),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: surfaceColor,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withAlpha(13),
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    _buildStatItem('24', 'Orders', textColor, subtleColor),
                    _buildStatDivider(borderColor),
                    _buildStatItem('12', 'Wishlist', textColor, subtleColor),
                    _buildStatDivider(borderColor),
                    _buildStatItem('8', 'Reviews', textColor, subtleColor),
                    _buildStatDivider(borderColor),
                    _buildStatItem(
                      '\$140',
                      'Wallet',
                      primaryColor,
                      subtleColor,
                      isHighlighted: true,
                    ),
                  ],
                ),
              ),
            ),

            // Account Settings Section
            _buildSection(
              context: context,
              title: 'Account Settings',
              items: [
                _SettingsItem(
                  icon: LucideIcons.user,
                  iconBgColor: Colors.blue[50]!,
                  iconColor: Colors.blue[600]!,
                  title: 'Personal Information',
                  onTap: () {},
                ),
                _SettingsItem(
                  icon: LucideIcons.mapPin,
                  iconBgColor: Colors.orange[50]!,
                  iconColor: Colors.orange[600]!,
                  title: 'Addresses',
                  onTap: () {},
                ),
                _SettingsItem(
                  icon: LucideIcons.lock,
                  iconBgColor: Colors.purple[50]!,
                  iconColor: Colors.purple[600]!,
                  title: 'Password & Security',
                  onTap: () {},
                ),
                _SettingsItem(
                  icon: LucideIcons.bell,
                  iconBgColor: Colors.pink[50]!,
                  iconColor: Colors.pink[600]!,
                  title: 'Notification Preferences',
                  onTap: () {},
                ),
              ],
              isDark: isDark,
              surfaceColor: surfaceColor,
              textColor: textColor,
              subtleColor: subtleColor,
              borderColor: borderColor,
            ),

            // Orders & Payments Section
            _buildSection(
              context: context,
              title: 'Orders & Payments',
              items: [
                _SettingsItem(
                  icon: LucideIcons.shoppingBag,
                  iconBgColor: Colors.green[50]!,
                  iconColor: Colors.green[600]!,
                  title: 'My Orders',
                  onTap: () => context.push('/orders'),
                ),
                _SettingsItem(
                  icon: LucideIcons.creditCard,
                  iconBgColor: Colors.indigo[50]!,
                  iconColor: Colors.indigo[600]!,
                  title: 'Payment Methods',
                  onTap: () {},
                ),
                _SettingsItem(
                  icon: LucideIcons.wallet,
                  iconBgColor: Colors.yellow[50]!,
                  iconColor: Colors.yellow[700]!,
                  title: 'Wallet & Credits',
                  onTap: () {},
                ),
                _SettingsItem(
                  icon: LucideIcons.tag,
                  iconBgColor: Colors.red[50]!,
                  iconColor: Colors.red[600]!,
                  title: 'Coupons & Offers',
                  onTap: () {},
                ),
              ],
              isDark: isDark,
              surfaceColor: surfaceColor,
              textColor: textColor,
              subtleColor: subtleColor,
              borderColor: borderColor,
            ),

            // App Settings Section
            _buildAppSettingsSection(
              context: context,
              ref: ref,
              themeMode: themeMode,
              isDark: isDark,
              surfaceColor: surfaceColor,
              textColor: textColor,
              subtleColor: subtleColor,
              borderColor: borderColor,
              primaryColor: primaryColor,
            ),

            // Support Section
            _buildSection(
              context: context,
              title: 'Support',
              items: [
                _SettingsItem(
                  icon: LucideIcons.helpCircle,
                  iconBgColor: Colors.teal[50]!,
                  iconColor: Colors.teal[600]!,
                  title: 'Help Center / FAQ',
                  onTap: () {},
                ),
                _SettingsItem(
                  icon: LucideIcons.mail,
                  iconBgColor: Colors.teal[50]!,
                  iconColor: Colors.teal[600]!,
                  title: 'Contact Us',
                  onTap: () {},
                ),
                _SettingsItem(
                  icon: LucideIcons.messageCircle,
                  iconBgColor: Colors.teal[50]!,
                  iconColor: Colors.teal[600]!,
                  title: 'Live Chat',
                  onTap: () {},
                ),
                _SettingsItem(
                  icon: LucideIcons.alertTriangle,
                  iconBgColor: Colors.teal[50]!,
                  iconColor: Colors.teal[600]!,
                  title: 'Report a Problem',
                  onTap: () {},
                ),
              ],
              isDark: isDark,
              surfaceColor: surfaceColor,
              textColor: textColor,
              subtleColor: subtleColor,
              borderColor: borderColor,
            ),

            // Legal Section
            _buildSection(
              context: context,
              title: 'Legal',
              items: [
                _SettingsItem(
                  icon: LucideIcons.scale,
                  iconBgColor: isDark ? Colors.grey[800]! : Colors.grey[100]!,
                  iconColor: isDark ? Colors.grey[400]! : Colors.grey[500]!,
                  title: 'Terms of Service',
                  onTap: () => context.push('/terms'),
                ),
                _SettingsItem(
                  icon: LucideIcons.shield,
                  iconBgColor: isDark ? Colors.grey[800]! : Colors.grey[100]!,
                  iconColor: isDark ? Colors.grey[400]! : Colors.grey[500]!,
                  title: 'Privacy Policy',
                  onTap: () => context.push('/privacy-policy'),
                ),
                _SettingsItem(
                  icon: LucideIcons.undo2,
                  iconBgColor: isDark ? Colors.grey[800]! : Colors.grey[100]!,
                  iconColor: isDark ? Colors.grey[400]! : Colors.grey[500]!,
                  title: 'Return Policy',
                  onTap: () {},
                ),
              ],
              isDark: isDark,
              surfaceColor: surfaceColor,
              textColor: textColor,
              subtleColor: subtleColor,
              borderColor: borderColor,
            ),

            // Logout Button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () => _showLogoutDialog(context, ref),
                  icon: const Icon(LucideIcons.logOut),
                  label: const Text('Log Out'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isDark
                        ? Colors.red[900]!.withAlpha(128)
                        : Colors.red[50],
                    foregroundColor: Colors.red[600],
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(
                        color: isDark ? Colors.red[800]! : Colors.red[100]!,
                      ),
                    ),
                    elevation: 0,
                  ),
                ),
              ),
            ),

            // App Version
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Text(
                'App Version 2.4.1 (Build 2024)',
                style: TextStyle(
                  fontSize: 12,
                  color: subtleColor.withAlpha(128),
                ),
              ),
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildAvatarPlaceholder(dynamic user, Color primaryColor) {
    return Container(
      color: primaryColor.withAlpha(51),
      child: Center(
        child: Text(
          (user.name ?? user.email)[0].toUpperCase(),
          style: TextStyle(
            fontSize: 36,
            fontWeight: FontWeight.bold,
            color: primaryColor,
          ),
        ),
      ),
    );
  }

  Widget _buildStatItem(
    String value,
    String label,
    Color valueColor,
    Color labelColor, {
    bool isHighlighted = false,
  }) {
    return Expanded(
      child: Column(
        children: [
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: valueColor,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w500,
              color: labelColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatDivider(Color color) {
    return Container(width: 1, height: 32, color: color);
  }

  Widget _buildSection({
    required BuildContext context,
    required String title,
    required List<_SettingsItem> items,
    required bool isDark,
    required Color surfaceColor,
    required Color textColor,
    required Color subtleColor,
    required Color borderColor,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 8, bottom: 8),
            child: Text(
              title.toUpperCase(),
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                color: subtleColor,
                letterSpacing: 0.5,
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: surfaceColor,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withAlpha(10),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              children: items.asMap().entries.map((entry) {
                final index = entry.key;
                final item = entry.value;
                final isLast = index == items.length - 1;

                return Column(
                  children: [
                    InkWell(
                      onTap: item.onTap,
                      borderRadius: BorderRadius.vertical(
                        top: index == 0
                            ? const Radius.circular(16)
                            : Radius.zero,
                        bottom: isLast
                            ? const Radius.circular(16)
                            : Radius.zero,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          children: [
                            Container(
                              width: 32,
                              height: 32,
                              decoration: BoxDecoration(
                                color: isDark
                                    ? item.iconColor.withAlpha(51)
                                    : item.iconBgColor,
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Icon(
                                item.icon,
                                size: 18,
                                color: item.iconColor,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                item.title,
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: textColor,
                                ),
                              ),
                            ),
                            if (item.trailing != null)
                              Padding(
                                padding: const EdgeInsets.only(right: 8),
                                child: Text(
                                  item.trailing!,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: subtleColor,
                                  ),
                                ),
                              ),
                            Icon(
                              LucideIcons.chevronRight,
                              size: 20,
                              color: subtleColor.withAlpha(153),
                            ),
                          ],
                        ),
                      ),
                    ),
                    if (!isLast)
                      Divider(height: 1, indent: 60, color: borderColor),
                  ],
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppSettingsSection({
    required BuildContext context,
    required WidgetRef ref,
    required ThemeMode themeMode,
    required bool isDark,
    required Color surfaceColor,
    required Color textColor,
    required Color subtleColor,
    required Color borderColor,
    required Color primaryColor,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 8, bottom: 8),
            child: Text(
              'APP SETTINGS',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                color: subtleColor,
                letterSpacing: 0.5,
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: surfaceColor,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withAlpha(10),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              children: [
                // Language
                _buildSettingsTile(
                  icon: LucideIcons.globe,
                  iconBgColor: isDark ? Colors.grey[800]! : Colors.grey[100]!,
                  iconColor: isDark ? Colors.grey[400]! : Colors.grey[600]!,
                  title: 'Language',
                  trailing: 'English (US)',
                  onTap: () {},
                  textColor: textColor,
                  subtleColor: subtleColor,
                  isDark: isDark,
                  showChevron: true,
                ),
                Divider(height: 1, indent: 60, color: borderColor),
                // Currency
                _buildSettingsTile(
                  icon: LucideIcons.dollarSign,
                  iconBgColor: isDark ? Colors.grey[800]! : Colors.grey[100]!,
                  iconColor: isDark ? Colors.grey[400]! : Colors.grey[600]!,
                  title: 'Currency',
                  trailing: 'USD (\$)',
                  onTap: () {},
                  textColor: textColor,
                  subtleColor: subtleColor,
                  isDark: isDark,
                  showChevron: true,
                ),
                Divider(height: 1, indent: 60, color: borderColor),
                // Dark Theme Toggle
                _buildToggleTile(
                  icon: LucideIcons.moon,
                  iconBgColor: isDark ? Colors.grey[800]! : Colors.grey[100]!,
                  iconColor: isDark ? Colors.grey[400]! : Colors.grey[600]!,
                  title: 'Dark Theme',
                  value: themeMode == ThemeMode.dark,
                  onChanged: (val) {
                    ref
                        .read(themeModeProvider.notifier)
                        .setThemeMode(val ? ThemeMode.dark : ThemeMode.light);
                  },
                  textColor: textColor,
                  primaryColor: primaryColor,
                  isDark: isDark,
                ),
                Divider(height: 1, indent: 60, color: borderColor),
                // Push Notifications Toggle
                _buildToggleTile(
                  icon: LucideIcons.bellRing,
                  iconBgColor: isDark ? Colors.grey[800]! : Colors.grey[100]!,
                  iconColor: isDark ? Colors.grey[400]! : Colors.grey[600]!,
                  title: 'Push Notifications',
                  value: true,
                  onChanged: (val) {},
                  textColor: textColor,
                  primaryColor: primaryColor,
                  isDark: isDark,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsTile({
    required IconData icon,
    required Color iconBgColor,
    required Color iconColor,
    required String title,
    String? trailing,
    required VoidCallback onTap,
    required Color textColor,
    required Color subtleColor,
    required bool isDark,
    bool showChevron = false,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: iconBgColor,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(icon, size: 18, color: iconColor),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: textColor,
                ),
              ),
            ),
            if (trailing != null)
              Padding(
                padding: const EdgeInsets.only(right: 8),
                child: Text(
                  trailing,
                  style: TextStyle(fontSize: 12, color: subtleColor),
                ),
              ),
            if (showChevron)
              Icon(
                LucideIcons.chevronRight,
                size: 20,
                color: subtleColor.withAlpha(153),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildToggleTile({
    required IconData icon,
    required Color iconBgColor,
    required Color iconColor,
    required String title,
    required bool value,
    required ValueChanged<bool> onChanged,
    required Color textColor,
    required Color primaryColor,
    required bool isDark,
  }) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: iconBgColor,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(icon, size: 18, color: iconColor),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: textColor,
              ),
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: primaryColor,
            activeTrackColor: primaryColor.withAlpha(128),
          ),
        ],
      ),
    );
  }

  void _showLogoutDialog(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: isDark ? const Color(0xFF1b2431) : Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          "Sign Out",
          style: TextStyle(color: isDark ? Colors.white : Colors.black87),
        ),
        content: Text(
          "Are you sure you want to sign out?",
          style: TextStyle(color: isDark ? Colors.grey[400] : Colors.grey[600]),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              "Cancel",
              style: TextStyle(
                color: isDark ? Colors.grey[400] : Colors.grey[600],
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              ref.read(authControllerProvider.notifier).logout();
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text("Sign Out"),
          ),
        ],
      ),
    );
  }
}

class _SettingsItem {
  final IconData icon;
  final Color iconBgColor;
  final Color iconColor;
  final String title;
  final String? trailing;
  final VoidCallback onTap;

  _SettingsItem({
    required this.icon,
    required this.iconBgColor,
    required this.iconColor,
    required this.title,
    this.trailing,
    required this.onTap,
  });
}
