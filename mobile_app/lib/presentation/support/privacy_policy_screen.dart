import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../core/config/white_label_config.dart';

/// Privacy Policy Screen
class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? const Color(0xFF101622) : const Color(0xFFF9FAFB);
    final surfaceColor = isDark ? const Color(0xFF1E293B) : Colors.white;
    final textColor = isDark ? Colors.white : const Color(0xFF111827);
    final subtleColor = isDark
        ? const Color(0xFF94A3B8)
        : const Color(0xFF6B7280);

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
          'Privacy Policy',
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
            Text(
              'Last updated: December 2024',
              style: TextStyle(fontSize: 12, color: subtleColor),
            ),
            const SizedBox(height: 24),
            _buildSection(
              'Information We Collect',
              'We collect information you provide directly to us, such as when you create an account, make a purchase, or contact us for support. This includes:\n\n• Name and contact information\n• Payment information\n• Delivery address\n• Order history\n• Device information',
              textColor,
              subtleColor,
            ),
            _buildSection(
              'How We Use Your Information',
              'We use the information we collect to:\n\n• Process your orders and payments\n• Provide customer support\n• Send order updates and notifications\n• Improve our services\n• Prevent fraud and abuse',
              textColor,
              subtleColor,
            ),
            _buildSection(
              'Information Sharing',
              'We do not sell your personal information. We may share your information with:\n\n• Payment processors to complete transactions\n• Delivery partners to fulfill orders\n• Service providers who assist our operations\n• Law enforcement when required by law',
              textColor,
              subtleColor,
            ),
            _buildSection(
              'Data Security',
              'We implement industry-standard security measures to protect your personal information. All payment transactions are encrypted using SSL technology.',
              textColor,
              subtleColor,
            ),
            _buildSection(
              'Your Rights',
              'You have the right to:\n\n• Access your personal data\n• Request correction of your data\n• Request deletion of your account\n• Opt-out of marketing communications',
              textColor,
              subtleColor,
            ),
            _buildSection(
              'Contact Us',
              'If you have any questions about this Privacy Policy, please contact us at ${WhiteLabelConfig.supportEmail}.',
              textColor,
              subtleColor,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(
    String title,
    String content,
    Color textColor,
    Color subtleColor,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            content,
            style: TextStyle(fontSize: 14, color: subtleColor, height: 1.6),
          ),
        ],
      ),
    );
  }
}
