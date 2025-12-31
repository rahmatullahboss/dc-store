import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:toastification/toastification.dart';
import '../../features/auth/presentation/providers/auth_provider.dart';
import '../../core/providers/settings_provider.dart';

/// Primary accent color
const _accentColor = Color(0xFF4F46E5);

/// Theme Mode enum
enum AppThemeMode { light, dark, system }

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  // Settings state - language and currency now managed by provider
  final String _country = 'Bangladesh';
  AppThemeMode _themeMode = AppThemeMode.light;
  double _textSize = 50;

  // Notifications
  bool _pushNotifications = true;
  bool _orderUpdates = true;
  bool _promotionalOffers = false;
  bool _priceAlerts = true;
  bool _restockAlerts = true;

  // Privacy
  final String _locationServices = 'While Using';
  bool _analyticsOptOut = false;
  bool _personalization = true;

  // Security
  bool _biometricLogin = true;

  @override
  Widget build(BuildContext context) {
    final settings = ref.watch(settingsProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = isDark
        ? const Color(0xFF101622)
        : const Color(0xFFF3F4F6);
    final surfaceColor = isDark ? const Color(0xFF1E293B) : Colors.white;
    final textColor = isDark ? Colors.white : const Color(0xFF111827);
    final subtleTextColor = isDark
        ? const Color(0xFF94A3B8)
        : const Color(0xFF6B7280);
    final borderColor = isDark
        ? const Color(0xFF334155)
        : const Color(0xFFE5E7EB);

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor.withAlpha(230),
        elevation: 0,
        leading: IconButton(
          icon: Icon(LucideIcons.arrowLeft, color: textColor),
          onPressed: () => context.pop(),
        ),
        title: Text(
          'Settings',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: textColor,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // General Section
            _buildSectionTitle('General', subtleTextColor),
            _buildSettingsCard(
              [
                _buildNavigationRow(
                  icon: LucideIcons.globe,
                  label: 'Language',
                  value: settings.language,
                  onTap: () => _showLanguageSheet(),
                  isDark: isDark,
                  textColor: textColor,
                  subtleTextColor: subtleTextColor,
                ),
                _buildNavigationRow(
                  icon: LucideIcons.wallet,
                  label: 'Currency',
                  value: '${settings.currency} (${settings.currencySymbol})',
                  onTap: () => _showCurrencySheet(),
                  isDark: isDark,
                  textColor: textColor,
                  subtleTextColor: subtleTextColor,
                ),
                _buildNavigationRow(
                  icon: LucideIcons.mapPin,
                  label: 'Country/Region',
                  value: _country,
                  onTap: () => _showComingSoonToast('Country/Region selection'),
                  isDark: isDark,
                  textColor: textColor,
                  subtleTextColor: subtleTextColor,
                  isLast: true,
                ),
              ],
              surfaceColor,
              borderColor,
            ),

            // Appearance Section
            _buildSectionTitle('Appearance', subtleTextColor),
            _buildAppearanceCard(
              isDark,
              surfaceColor,
              textColor,
              subtleTextColor,
              borderColor,
            ),

            // Notifications Section
            _buildSectionTitle('Notifications', subtleTextColor),
            _buildNotificationsCard(
              isDark,
              surfaceColor,
              textColor,
              subtleTextColor,
              borderColor,
            ),

            // Privacy Section
            _buildSectionTitle('Privacy', subtleTextColor),
            _buildPrivacyCard(
              isDark,
              surfaceColor,
              textColor,
              subtleTextColor,
              borderColor,
            ),

            // Security Section
            _buildSectionTitle('Security', subtleTextColor),
            _buildSecurityCard(
              isDark,
              surfaceColor,
              textColor,
              subtleTextColor,
              borderColor,
            ),

            // Storage Section
            _buildSectionTitle('Storage', subtleTextColor),
            _buildStorageCard(
              isDark,
              surfaceColor,
              textColor,
              subtleTextColor,
              borderColor,
            ),

            // About Section
            _buildSectionTitle('About', subtleTextColor),
            _buildAboutCard(
              isDark,
              surfaceColor,
              textColor,
              subtleTextColor,
              borderColor,
            ),

            const SizedBox(height: 24),

            // Sign Out Button
            GestureDetector(
              onTap: () => _showSignOutDialog(),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 16),
                decoration: BoxDecoration(
                  color: surfaceColor,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: borderColor),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(LucideIcons.logOut, size: 20, color: Colors.red[500]),
                    const SizedBox(width: 8),
                    Text(
                      'Sign Out',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.red[500],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // User ID
            Center(
              child: Text(
                'UserID: 8493-2019-XKLD',
                style: TextStyle(
                  fontSize: 12,
                  color: subtleTextColor.withAlpha(150),
                ),
              ),
            ),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title, Color color) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 12, top: 20),
      child: Text(
        title.toUpperCase(),
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: color,
          letterSpacing: 0.5,
        ),
      ),
    ).animate().fadeIn(duration: 200.ms);
  }

  Widget _buildSettingsCard(
    List<Widget> children,
    Color surfaceColor,
    Color borderColor,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(8),
            blurRadius: 3,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(children: children),
    ).animate().fadeIn(duration: 300.ms).slideY(begin: 0.02);
  }

  Widget _buildNavigationRow({
    required IconData icon,
    required String label,
    required String value,
    required VoidCallback onTap,
    required bool isDark,
    required Color textColor,
    required Color subtleTextColor,
    bool isLast = false,
    Color? iconBgColor,
    Color? iconColor,
  }) {
    final borderColor = isDark
        ? const Color(0xFF334155)
        : const Color(0xFFE5E7EB);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: BoxDecoration(
          border: isLast
              ? null
              : Border(bottom: BorderSide(color: borderColor)),
        ),
        child: Row(
          children: [
            if (iconBgColor != null)
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: iconBgColor,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, size: 18, color: iconColor),
              )
            else
              Icon(icon, size: 22, color: subtleTextColor),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: textColor,
                ),
              ),
            ),
            Text(value, style: TextStyle(fontSize: 14, color: subtleTextColor)),
            const SizedBox(width: 4),
            Icon(LucideIcons.chevronRight, size: 18, color: subtleTextColor),
          ],
        ),
      ),
    );
  }

  Widget _buildToggleRow({
    required IconData? icon,
    required String label,
    String? subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
    required bool isDark,
    required Color textColor,
    required Color subtleTextColor,
    bool isLast = false,
    Color? iconBgColor,
    Color? iconColor,
  }) {
    final borderColor = isDark
        ? const Color(0xFF334155)
        : const Color(0xFFE5E7EB);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      decoration: BoxDecoration(
        border: isLast ? null : Border(bottom: BorderSide(color: borderColor)),
      ),
      child: Row(
        children: [
          if (icon != null) ...[
            if (iconBgColor != null)
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: iconBgColor,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, size: 18, color: iconColor),
              )
            else
              Icon(icon, size: 22, color: subtleTextColor),
            const SizedBox(width: 12),
          ],
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: textColor,
                  ),
                ),
                if (subtitle != null) ...[
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: TextStyle(fontSize: 12, color: subtleTextColor),
                  ),
                ],
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            thumbColor: WidgetStatePropertyAll(value ? _accentColor : null),
            activeTrackColor: _accentColor.withAlpha(128),
          ),
        ],
      ),
    );
  }

  Widget _buildAppearanceCard(
    bool isDark,
    Color surfaceColor,
    Color textColor,
    Color subtleTextColor,
    Color borderColor,
  ) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(8),
            blurRadius: 3,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Theme',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: textColor,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              _buildThemeOption('Light', AppThemeMode.light, isDark, textColor),
              const SizedBox(width: 12),
              _buildThemeOption('Dark', AppThemeMode.dark, isDark, textColor),
              const SizedBox(width: 12),
              _buildThemeOption(
                'System',
                AppThemeMode.system,
                isDark,
                textColor,
              ),
            ],
          ),
          const SizedBox(height: 20),
          Divider(color: borderColor, height: 1),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Text Size',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: textColor,
                ),
              ),
              Text(
                'Default',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: subtleTextColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Text(
                'A',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: subtleTextColor,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: SliderTheme(
                  data: SliderTheme.of(context).copyWith(
                    activeTrackColor: _accentColor,
                    inactiveTrackColor: borderColor,
                    thumbColor: _accentColor,
                    trackHeight: 6,
                  ),
                  child: Slider(
                    value: _textSize,
                    min: 0,
                    max: 100,
                    onChanged: (value) => setState(() => _textSize = value),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Text(
                'A',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
              ),
            ],
          ),
        ],
      ),
    ).animate().fadeIn(duration: 300.ms).slideY(begin: 0.02);
  }

  Widget _buildThemeOption(
    String label,
    AppThemeMode mode,
    bool isDark,
    Color textColor,
  ) {
    final isSelected = _themeMode == mode;

    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _themeMode = mode),
        child: Column(
          children: [
            Container(
              height: 80,
              decoration: BoxDecoration(
                color: mode == AppThemeMode.dark
                    ? const Color(0xFF1F2937)
                    : Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isSelected
                      ? _accentColor
                      : (isDark
                            ? const Color(0xFF374151)
                            : const Color(0xFFE5E7EB)),
                  width: isSelected ? 2 : 1,
                ),
              ),
              child: Stack(
                children: [
                  Column(
                    children: [
                      Container(
                        height: 16,
                        decoration: BoxDecoration(
                          color: mode == AppThemeMode.dark
                              ? const Color(0xFF374151)
                              : const Color(0xFFF3F4F6),
                          borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(11),
                          ),
                        ),
                      ),
                      Expanded(
                        child: mode == AppThemeMode.system
                            ? Center(
                                child: Icon(
                                  LucideIcons.sunMoon,
                                  size: 24,
                                  color: isDark
                                      ? Colors.grey[400]
                                      : Colors.grey[500],
                                ),
                              )
                            : Padding(
                                padding: const EdgeInsets.all(8),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      height: 8,
                                      width: 50,
                                      decoration: BoxDecoration(
                                        color: mode == AppThemeMode.dark
                                            ? const Color(0xFF4B5563)
                                            : const Color(0xFFE5E7EB),
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                    ),
                                    const SizedBox(height: 6),
                                    Container(
                                      height: 8,
                                      width: 35,
                                      decoration: BoxDecoration(
                                        color: mode == AppThemeMode.dark
                                            ? const Color(0xFF4B5563)
                                            : const Color(0xFFE5E7EB),
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                      ),
                    ],
                  ),
                  if (isSelected)
                    Positioned(
                      bottom: 4,
                      right: 4,
                      child: Container(
                        padding: const EdgeInsets.all(2),
                        decoration: const BoxDecoration(
                          color: _accentColor,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.check,
                          size: 12,
                          color: Colors.white,
                        ),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: isSelected
                    ? _accentColor
                    : (isDark ? Colors.grey[400] : Colors.grey[600]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationsCard(
    bool isDark,
    Color surfaceColor,
    Color textColor,
    Color subtleTextColor,
    Color borderColor,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(8),
            blurRadius: 3,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildToggleRow(
            icon: null,
            label: 'Push Notifications',
            subtitle: 'Enable notifications on this device',
            value: _pushNotifications,
            onChanged: (v) => setState(() => _pushNotifications = v),
            isDark: isDark,
            textColor: textColor,
            subtleTextColor: subtleTextColor,
          ),
          if (_pushNotifications)
            Container(
              padding: const EdgeInsets.all(20),
              color: isDark ? const Color(0xFF0F172A) : const Color(0xFFF9FAFB),
              child: Column(
                children: [
                  _buildCheckboxRow(
                    'Order Updates',
                    _orderUpdates,
                    (v) => setState(() => _orderUpdates = v!),
                    textColor,
                  ),
                  const SizedBox(height: 16),
                  _buildCheckboxRow(
                    'Promotional Offers',
                    _promotionalOffers,
                    (v) => setState(() => _promotionalOffers = v!),
                    textColor,
                  ),
                  const SizedBox(height: 16),
                  _buildCheckboxRow(
                    'Price Alerts',
                    _priceAlerts,
                    (v) => setState(() => _priceAlerts = v!),
                    textColor,
                  ),
                  const SizedBox(height: 16),
                  _buildCheckboxRow(
                    'Restock Alerts',
                    _restockAlerts,
                    (v) => setState(() => _restockAlerts = v!),
                    textColor,
                  ),
                ],
              ),
            ),
          _buildNavigationRow(
            icon: LucideIcons.mail,
            label: 'Email Preferences',
            value: '',
            onTap: () => _showComingSoonToast('Email preferences'),
            isDark: isDark,
            textColor: textColor,
            subtleTextColor: subtleTextColor,
            isLast: true,
          ),
        ],
      ),
    ).animate().fadeIn(duration: 300.ms).slideY(begin: 0.02);
  }

  Widget _buildCheckboxRow(
    String label,
    bool value,
    ValueChanged<bool?> onChanged,
    Color textColor,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: TextStyle(fontSize: 14, color: textColor)),
        SizedBox(
          width: 22,
          height: 22,
          child: Checkbox(
            value: value,
            onChanged: onChanged,
            activeColor: _accentColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPrivacyCard(
    bool isDark,
    Color surfaceColor,
    Color textColor,
    Color subtleTextColor,
    Color borderColor,
  ) {
    return _buildSettingsCard(
      [
        _buildNavigationRow(
          icon: LucideIcons.mapPin,
          label: 'Location Services',
          value: _locationServices,
          onTap: () => _showLocationServicesSheet(),
          isDark: isDark,
          textColor: textColor,
          subtleTextColor: subtleTextColor,
          iconBgColor: Colors.blue[50],
          iconColor: Colors.blue[600],
        ),
        _buildToggleRow(
          icon: null,
          label: 'Analytics Opt-out',
          subtitle: 'Share anonymous usage data',
          value: _analyticsOptOut,
          onChanged: (v) => setState(() => _analyticsOptOut = v),
          isDark: isDark,
          textColor: textColor,
          subtleTextColor: subtleTextColor,
        ),
        _buildToggleRow(
          icon: null,
          label: 'Personalization',
          subtitle: 'Tailored recommendations',
          value: _personalization,
          onChanged: (v) => setState(() => _personalization = v),
          isDark: isDark,
          textColor: textColor,
          subtleTextColor: subtleTextColor,
          isLast: true,
        ),
      ],
      surfaceColor,
      borderColor,
    );
  }

  Widget _buildSecurityCard(
    bool isDark,
    Color surfaceColor,
    Color textColor,
    Color subtleTextColor,
    Color borderColor,
  ) {
    return _buildSettingsCard(
      [
        _buildToggleRow(
          icon: LucideIcons.fingerprint,
          label: 'Biometric Login',
          value: _biometricLogin,
          onChanged: (v) => setState(() => _biometricLogin = v),
          isDark: isDark,
          textColor: textColor,
          subtleTextColor: subtleTextColor,
          iconBgColor: Colors.green[50],
          iconColor: Colors.green[600],
        ),
        _buildNavigationRow(
          icon: LucideIcons.shield,
          label: 'Two-Factor Authentication',
          value: '',
          onTap: () => _showComingSoonToast('Two-Factor Authentication'),
          isDark: isDark,
          textColor: textColor,
          subtleTextColor: subtleTextColor,
          iconBgColor: Colors.orange[50],
          iconColor: Colors.orange[600],
        ),
        _buildNavigationRow(
          icon: LucideIcons.smartphone,
          label: 'Active Sessions',
          value: '2 devices',
          onTap: () => _showComingSoonToast('Active sessions management'),
          isDark: isDark,
          textColor: textColor,
          subtleTextColor: subtleTextColor,
          iconBgColor: Colors.purple[50],
          iconColor: Colors.purple[600],
          isLast: true,
        ),
      ],
      surfaceColor,
      borderColor,
    );
  }

  Widget _buildStorageCard(
    bool isDark,
    Color surfaceColor,
    Color textColor,
    Color subtleTextColor,
    Color borderColor,
  ) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(8),
            blurRadius: 3,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildStorageButton(
            icon: LucideIcons.trash,
            label: 'Clear Cache',
            subtitle: 'Frees up space',
            trailing: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: isDark
                    ? const Color(0xFF374151)
                    : const Color(0xFFF3F4F6),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                '128 MB',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: subtleTextColor,
                ),
              ),
            ),
            onTap: () => _clearCache(),
            isDark: isDark,
            textColor: textColor,
            subtleTextColor: subtleTextColor,
          ),
          Divider(color: borderColor, height: 1, indent: 16, endIndent: 16),
          _buildStorageButton(
            icon: LucideIcons.history,
            label: 'Clear Search History',
            onTap: () => _clearHistory(),
            isDark: isDark,
            textColor: textColor,
            subtleTextColor: subtleTextColor,
          ),
          Divider(color: borderColor, height: 1, indent: 16, endIndent: 16),
          _buildStorageButton(
            icon: LucideIcons.download,
            label: 'Download My Data',
            trailing: Icon(
              LucideIcons.chevronRight,
              size: 18,
              color: subtleTextColor,
            ),
            onTap: () => _showComingSoonToast('Data download'),
            isDark: isDark,
            textColor: textColor,
            subtleTextColor: subtleTextColor,
          ),
        ],
      ),
    ).animate().fadeIn(duration: 300.ms).slideY(begin: 0.02);
  }

  Widget _buildStorageButton({
    required IconData icon,
    required String label,
    String? subtitle,
    Widget? trailing,
    required VoidCallback onTap,
    required bool isDark,
    required Color textColor,
    required Color subtleTextColor,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: isDark
                    ? const Color(0xFF374151)
                    : const Color(0xFFF3F4F6),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, size: 18, color: subtleTextColor),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: textColor,
                    ),
                  ),
                  if (subtitle != null) ...[
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: TextStyle(fontSize: 12, color: subtleTextColor),
                    ),
                  ],
                ],
              ),
            ),
            if (trailing != null) trailing,
          ],
        ),
      ),
    );
  }

  Widget _buildAboutCard(
    bool isDark,
    Color surfaceColor,
    Color textColor,
    Color subtleTextColor,
    Color borderColor,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(8),
            blurRadius: 3,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildInfoRow(
            'Version',
            '4.2.0 (Build 2023)',
            isDark,
            textColor,
            subtleTextColor,
            borderColor,
          ),
          _buildNavigationRow(
            icon: LucideIcons.fileText,
            label: 'Open Source Licenses',
            value: '',
            onTap: () => _showComingSoonToast('Open Source Licenses'),
            isDark: isDark,
            textColor: textColor,
            subtleTextColor: subtleTextColor,
          ),
          _buildActionRow(
            icon: LucideIcons.star,
            label: 'Rate App',
            onTap: () => _showComingSoonToast('App rating'),
            color: _accentColor,
            isDark: isDark,
            borderColor: borderColor,
          ),
          _buildActionRow(
            icon: LucideIcons.share2,
            label: 'Share App',
            onTap: () => _showComingSoonToast('App sharing'),
            color: _accentColor,
            isDark: isDark,
            borderColor: borderColor,
            isLast: true,
          ),
        ],
      ),
    ).animate().fadeIn(duration: 300.ms).slideY(begin: 0.02);
  }

  Widget _buildInfoRow(
    String label,
    String value,
    bool isDark,
    Color textColor,
    Color subtleTextColor,
    Color borderColor,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: borderColor)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: textColor,
            ),
          ),
          Text(value, style: TextStyle(fontSize: 14, color: subtleTextColor)),
        ],
      ),
    );
  }

  Widget _buildActionRow({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    required Color color,
    required bool isDark,
    required Color borderColor,
    bool isLast = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: BoxDecoration(
          border: isLast
              ? null
              : Border(bottom: BorderSide(color: borderColor)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: color,
              ),
            ),
            Icon(icon, size: 20, color: color),
          ],
        ),
      ),
    );
  }

  void _showLanguageSheet() {
    final settings = ref.read(settingsProvider);
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        final isDark = Theme.of(context).brightness == Brightness.dark;
        final surfaceColor = isDark ? const Color(0xFF1E293B) : Colors.white;
        final textColor = isDark ? Colors.white : const Color(0xFF111827);

        return Container(
          decoration: BoxDecoration(
            color: surfaceColor,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.all(20),
                child: Text(
                  'Select Language',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                ),
              ),
              ...availableLanguages.map(
                (lang) => ListTile(
                  title: Text(lang.name, style: TextStyle(color: textColor)),
                  subtitle: Text(
                    lang.nativeName,
                    style: TextStyle(color: textColor.withAlpha(150)),
                  ),
                  trailing: lang.name == settings.language
                      ? const Icon(Icons.check, color: _accentColor)
                      : null,
                  onTap: () {
                    ref.read(settingsProvider.notifier).setLanguage(lang);
                    Navigator.pop(context);
                  },
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  void _showCurrencySheet() {
    final settings = ref.read(settingsProvider);
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        final isDark = Theme.of(context).brightness == Brightness.dark;
        final surfaceColor = isDark ? const Color(0xFF1E293B) : Colors.white;
        final textColor = isDark ? Colors.white : const Color(0xFF111827);

        return Container(
          decoration: BoxDecoration(
            color: surfaceColor,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.all(20),
                child: Text(
                  'Select Currency',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                ),
              ),
              ...availableCurrencies.map(
                (currency) => ListTile(
                  title: Text(
                    '${currency.code} (${currency.symbol})',
                    style: TextStyle(color: textColor),
                  ),
                  subtitle: Text(
                    currency.name,
                    style: TextStyle(color: textColor.withAlpha(150)),
                  ),
                  trailing: currency.code == settings.currency
                      ? const Icon(Icons.check, color: _accentColor)
                      : null,
                  onTap: () {
                    ref.read(settingsProvider.notifier).setCurrency(currency);
                    Navigator.pop(context);
                  },
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  void _showOptionSheet(
    String title,
    List<String> options,
    String selected,
    ValueChanged<String> onSelect,
  ) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        final isDark = Theme.of(context).brightness == Brightness.dark;
        final surfaceColor = isDark ? const Color(0xFF1E293B) : Colors.white;
        final textColor = isDark ? Colors.white : const Color(0xFF111827);

        return Container(
          decoration: BoxDecoration(
            color: surfaceColor,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.all(20),
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                ),
              ),
              ...options.map(
                (option) => ListTile(
                  title: Text(option, style: TextStyle(color: textColor)),
                  trailing: option == selected
                      ? const Icon(Icons.check, color: _accentColor)
                      : null,
                  onTap: () {
                    onSelect(option);
                    Navigator.pop(context);
                  },
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  void _clearCache() {
    toastification.show(
      context: context,
      type: ToastificationType.success,
      title: const Text('Cache cleared successfully'),
      autoCloseDuration: const Duration(seconds: 2),
    );
  }

  void _clearHistory() {
    toastification.show(
      context: context,
      type: ToastificationType.success,
      title: const Text('Search history cleared'),
      autoCloseDuration: const Duration(seconds: 2),
    );
  }

  void _showSignOutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Sign Out'),
        content: const Text('Are you sure you want to sign out?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              // Sign out using auth provider
              await ref.read(authControllerProvider.notifier).logout();
              if (context.mounted) {
                context.go('/login');
              }
            },
            child: Text('Sign Out', style: TextStyle(color: Colors.red[500])),
          ),
        ],
      ),
    );
  }

  void _showComingSoonToast(String feature) {
    toastification.show(
      context: context,
      type: ToastificationType.info,
      title: Text('$feature coming soon!'),
      autoCloseDuration: const Duration(seconds: 2),
    );
  }

  void _showLocationServicesSheet() {
    final options = ['Never', 'While Using', 'Always'];
    _showOptionSheet(
      'Location Services',
      options,
      _locationServices,
      (v) => _showComingSoonToast('Location services'),
    );
  }
}
