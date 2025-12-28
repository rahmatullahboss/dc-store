import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../core/config/white_label_config.dart';

/// FAQ Screen with expandable questions
class FaqScreen extends StatefulWidget {
  const FaqScreen({super.key});

  @override
  State<FaqScreen> createState() => _FaqScreenState();
}

class _FaqScreenState extends State<FaqScreen> {
  final List<_FaqItem> _faqItems = [
    _FaqItem(
      question: 'How do I place an order?',
      answer:
          'Browse our products, add items to your cart, and proceed to checkout. You can pay using various payment methods including Cash on Delivery, Credit/Debit cards, and mobile banking.',
    ),
    _FaqItem(
      question: 'What payment methods do you accept?',
      answer:
          'We accept Cash on Delivery (COD), Credit/Debit Cards (Visa, Mastercard), bKash, Nagad, and bank transfers. All online payments are secured with industry-standard encryption.',
    ),
    _FaqItem(
      question: 'How long does delivery take?',
      answer:
          'Standard delivery within Dhaka takes 1-3 business days. Outside Dhaka, delivery takes 3-7 business days depending on your location. Express delivery options are also available.',
    ),
    _FaqItem(
      question: 'Can I track my order?',
      answer:
          'Yes! Once your order is shipped, you\'ll receive a tracking number via SMS and email. You can also track your order in the app under Orders → Track Order.',
    ),
    _FaqItem(
      question: 'What is your return policy?',
      answer:
          'We offer a 7-day return policy for most products. Items must be unused and in original packaging. Some categories like underwear and personalized items are non-returnable.',
    ),
    _FaqItem(
      question: 'How do I return a product?',
      answer:
          'Go to Orders → Select the order → Request Return. Our team will contact you within 24 hours to arrange pickup. Refunds are processed within 5-7 business days.',
    ),
    _FaqItem(
      question: 'How can I contact customer support?',
      answer:
          'You can reach us through:\n• Live Chat (available 9 AM - 10 PM)\n• Email: ${WhiteLabelConfig.supportEmail}\n• Phone: ${WhiteLabelConfig.supportPhone}\n• Our AI assistant is available 24/7',
    ),
    _FaqItem(
      question: 'Do you offer gift wrapping?',
      answer:
          'Yes! We offer premium gift wrapping for a small additional fee. You can select this option during checkout and add a personalized message.',
    ),
  ];

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
          'Frequently Asked Questions',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: textColor,
          ),
        ),
        centerTitle: true,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _faqItems.length,
        itemBuilder: (context, index) {
          final item = _faqItems[index];
          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(
              color: surfaceColor,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isDark
                    ? const Color(0xFF334155)
                    : const Color(0xFFE5E7EB),
              ),
            ),
            child: Theme(
              data: Theme.of(
                context,
              ).copyWith(dividerColor: Colors.transparent),
              child: ExpansionTile(
                tilePadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 4,
                ),
                childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                leading: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: WhiteLabelConfig.accentColor.withAlpha(20),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    LucideIcons.helpCircle,
                    color: WhiteLabelConfig.accentColor,
                    size: 20,
                  ),
                ),
                title: Text(
                  item.question,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: textColor,
                  ),
                ),
                iconColor: subtleColor,
                collapsedIconColor: subtleColor,
                children: [
                  Text(
                    item.answer,
                    style: TextStyle(
                      fontSize: 14,
                      color: subtleColor,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _FaqItem {
  final String question;
  final String answer;

  _FaqItem({required this.question, required this.answer});
}
