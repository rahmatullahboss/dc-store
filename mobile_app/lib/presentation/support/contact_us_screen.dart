import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../core/config/white_label_config.dart';

/// Contact Us Screen
class ContactUsScreen extends StatelessWidget {
  const ContactUsScreen({super.key});

  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? const Color(0xFF101622) : const Color(0xFFF9FAFB);
    final surfaceColor = isDark ? const Color(0xFF1E293B) : Colors.white;
    final textColor = isDark ? Colors.white : const Color(0xFF111827);
    final subtleColor = isDark
        ? const Color(0xFF94A3B8)
        : const Color(0xFF6B7280);
    final borderColor = isDark
        ? const Color(0xFF334155)
        : const Color(0xFFE5E7EB);

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: surfaceColor,
        elevation: 0,
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: Icon(LucideIcons.arrowLeft, color: textColor),
        ),
        title: Text(
          'Contact Us',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: textColor,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Center(
              child: Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: WhiteLabelConfig.accentColor.withAlpha(20),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  LucideIcons.headphones,
                  size: 40,
                  color: WhiteLabelConfig.accentColor,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Center(
              child: Text(
                'We\'re here to help!',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Center(
              child: Text(
                'Reach out to us through any of these channels',
                style: TextStyle(fontSize: 14, color: subtleColor),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 32),

            // Contact Options
            _buildContactCard(
              context,
              icon: LucideIcons.messageCircle,
              title: 'AI Chat Assistant',
              subtitle: 'Available 24/7 for instant help',
              onTap: () => context.push('/chat'),
              isDark: isDark,
              surfaceColor: surfaceColor,
              textColor: textColor,
              subtleColor: subtleColor,
              borderColor: borderColor,
              isPrimary: true,
            ),
            const SizedBox(height: 12),
            _buildContactCard(
              context,
              icon: LucideIcons.phone,
              title: 'Call Us',
              subtitle: WhiteLabelConfig.supportPhone,
              onTap: () => _launchUrl('tel:${WhiteLabelConfig.supportPhone}'),
              isDark: isDark,
              surfaceColor: surfaceColor,
              textColor: textColor,
              subtleColor: subtleColor,
              borderColor: borderColor,
            ),
            const SizedBox(height: 12),
            _buildContactCard(
              context,
              icon: LucideIcons.mail,
              title: 'Email Us',
              subtitle: WhiteLabelConfig.supportEmail,
              onTap: () =>
                  _launchUrl('mailto:${WhiteLabelConfig.supportEmail}'),
              isDark: isDark,
              surfaceColor: surfaceColor,
              textColor: textColor,
              subtleColor: subtleColor,
              borderColor: borderColor,
            ),
            const SizedBox(height: 12),
            _buildContactCard(
              context,
              icon: LucideIcons.mapPin,
              title: 'Visit Us',
              subtitle: 'Dhaka, Bangladesh',
              onTap: () {},
              isDark: isDark,
              surfaceColor: surfaceColor,
              textColor: textColor,
              subtleColor: subtleColor,
              borderColor: borderColor,
            ),

            const SizedBox(height: 32),

            // Business Hours
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: surfaceColor,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: borderColor),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        LucideIcons.clock,
                        color: WhiteLabelConfig.accentColor,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Business Hours',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: textColor,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  _buildHoursRow(
                    'Saturday - Thursday',
                    '9:00 AM - 10:00 PM',
                    textColor,
                    subtleColor,
                  ),
                  const SizedBox(height: 6),
                  _buildHoursRow(
                    'Friday',
                    '2:00 PM - 10:00 PM',
                    textColor,
                    subtleColor,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContactCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    required bool isDark,
    required Color surfaceColor,
    required Color textColor,
    required Color subtleColor,
    required Color borderColor,
    bool isPrimary = false,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isPrimary ? WhiteLabelConfig.accentColor : surfaceColor,
          borderRadius: BorderRadius.circular(12),
          border: isPrimary ? null : Border.all(color: borderColor),
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: isPrimary
                    ? Colors.white.withAlpha(51)
                    : WhiteLabelConfig.accentColor.withAlpha(20),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: isPrimary ? Colors.white : WhiteLabelConfig.accentColor,
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: isPrimary ? Colors.white : textColor,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 14,
                      color: isPrimary
                          ? Colors.white.withAlpha(204)
                          : subtleColor,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              LucideIcons.chevronRight,
              color: isPrimary ? Colors.white : subtleColor,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHoursRow(
    String day,
    String hours,
    Color textColor,
    Color subtleColor,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(day, style: TextStyle(color: subtleColor, fontSize: 14)),
        Text(
          hours,
          style: TextStyle(
            color: textColor,
            fontWeight: FontWeight.w500,
            fontSize: 14,
          ),
        ),
      ],
    );
  }
}
