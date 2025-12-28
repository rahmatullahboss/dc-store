import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../core/config/white_label_config.dart';

/// Terms of Service Screen
class TermsScreen extends StatelessWidget {
  const TermsScreen({super.key});

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
          'Terms of Service',
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
              '1. Acceptance of Terms',
              'By accessing or using ${WhiteLabelConfig.appName}, you agree to be bound by these Terms of Service. If you do not agree to these terms, please do not use our services.',
              textColor,
              subtleColor,
            ),
            _buildSection(
              '2. Account Registration',
              '• You must provide accurate and complete information when creating an account\n• You are responsible for maintaining the confidentiality of your account\n• You must be at least 18 years old to create an account\n• One person may not maintain more than one account',
              textColor,
              subtleColor,
            ),
            _buildSection(
              '3. Orders and Payment',
              '• All prices are listed in BDT (Bangladeshi Taka)\n• Payment must be made at the time of order or on delivery (COD)\n• We reserve the right to refuse or cancel orders\n• Order confirmation does not guarantee availability',
              textColor,
              subtleColor,
            ),
            _buildSection(
              '4. Shipping and Delivery',
              '• Delivery times are estimates and not guaranteed\n• You are responsible for providing accurate delivery information\n• Risk of loss passes to you upon delivery\n• Shipping fees are calculated based on location and order size',
              textColor,
              subtleColor,
            ),
            _buildSection(
              '5. Returns and Refunds',
              '• Products may be returned within 7 days of delivery\n• Items must be unused and in original packaging\n• Some items are non-returnable (underwear, personalized items)\n• Refunds are processed within 5-7 business days',
              textColor,
              subtleColor,
            ),
            _buildSection(
              '6. User Conduct',
              'You agree not to:\n\n• Violate any applicable laws or regulations\n• Infringe on the rights of others\n• Use the service for fraudulent purposes\n• Attempt to gain unauthorized access\n• Interfere with the service\'s operation',
              textColor,
              subtleColor,
            ),
            _buildSection(
              '7. Limitation of Liability',
              '${WhiteLabelConfig.appName} shall not be liable for any indirect, incidental, special, or consequential damages arising from your use of the service.',
              textColor,
              subtleColor,
            ),
            _buildSection(
              '8. Contact Information',
              'For any questions regarding these Terms of Service, please contact us at ${WhiteLabelConfig.supportEmail}.',
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
