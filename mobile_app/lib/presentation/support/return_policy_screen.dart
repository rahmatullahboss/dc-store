import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../core/config/white_label_config.dart';

/// Return Policy Screen
class ReturnPolicyScreen extends StatelessWidget {
  const ReturnPolicyScreen({super.key});

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
          'Return Policy',
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
              '1. Return Eligibility',
              'Products may be returned within 7 days of delivery. To qualify for a return:\n\n• Items must be unused and in original packaging\n• Products must include all original tags and accessories\n• You must have the purchase receipt or order confirmation\n• Items must be free from damage or wear',
              textColor,
              subtleColor,
            ),
            _buildSection(
              '2. Non-Returnable Items',
              'The following items cannot be returned:\n\n• Undergarments and intimate apparel\n• Personalized or customized items\n• Perishable goods\n• Items marked as "Final Sale"\n• Gift cards\n• Downloaded software or digital products\n• Items damaged due to misuse',
              textColor,
              subtleColor,
            ),
            _buildSection(
              '3. Return Process',
              'To initiate a return:\n\n1. Log in to your account and go to "My Orders"\n2. Select the order containing the item you wish to return\n3. Click "Request Return" and select the item(s)\n4. Choose your reason for return\n5. Pack the item securely in its original packaging\n6. A pickup will be scheduled within 2-3 business days',
              textColor,
              subtleColor,
            ),
            _buildSection(
              '4. Refund Policy',
              '• Refunds are processed within 5-7 business days after we receive the returned item\n• Refunds will be credited to your original payment method\n• Shipping charges are non-refundable unless the return is due to our error\n• For Cash on Delivery orders, refunds will be credited to your ${WhiteLabelConfig.appName} Wallet',
              textColor,
              subtleColor,
            ),
            _buildSection(
              '5. Exchange Policy',
              'We offer free exchanges for:\n\n• Wrong size received\n• Defective or damaged items\n• Wrong product shipped\n\nExchanges are subject to product availability. If the desired item is not available, a full refund will be processed.',
              textColor,
              subtleColor,
            ),
            _buildSection(
              '6. Damaged or Defective Items',
              'If you receive a damaged or defective item:\n\n• Report the issue within 48 hours of delivery\n• Take clear photos of the damage\n• Contact our support team with order details\n• We will arrange a free pickup and replacement',
              textColor,
              subtleColor,
            ),
            _buildSection(
              '7. Refund Timeline',
              'Once we receive your return:\n\n• Quality check: 1-2 business days\n• Refund initiation: 2-3 business days\n• Bank processing: 3-7 business days\n\nTotal estimated time: 7-12 business days',
              textColor,
              subtleColor,
            ),
            _buildSection(
              '8. Contact Us',
              'For any questions about returns or refunds, please contact us:\n\n📧 Email: ${WhiteLabelConfig.supportEmail}\n📞 Phone: ${WhiteLabelConfig.supportPhone}\n\nOur support team is ${WhiteLabelConfig.supportHours.toLowerCase()}.',
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
