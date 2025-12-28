import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../core/config/white_label_config.dart';

/// Payment Method Selection Screen
class PaymentMethodScreen extends ConsumerStatefulWidget {
  const PaymentMethodScreen({super.key});

  @override
  ConsumerState<PaymentMethodScreen> createState() =>
      _PaymentMethodScreenState();
}

class _PaymentMethodScreenState extends ConsumerState<PaymentMethodScreen> {
  String _selectedMethod = 'cod';

  final _paymentMethods = [
    _PaymentMethod(
      id: 'cod',
      name: 'Cash on Delivery',
      description: 'Pay when you receive your order',
      icon: LucideIcons.banknote,
    ),
    _PaymentMethod(
      id: 'bkash',
      name: 'bKash',
      description: 'Pay with bKash mobile banking',
      icon: LucideIcons.smartphone,
      logo: '🅱️',
    ),
    _PaymentMethod(
      id: 'nagad',
      name: 'Nagad',
      description: 'Pay with Nagad mobile banking',
      icon: LucideIcons.smartphone,
      logo: '🔴',
    ),
    _PaymentMethod(
      id: 'card',
      name: 'Credit/Debit Card',
      description: 'Visa, Mastercard, American Express',
      icon: LucideIcons.creditCard,
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
          'Payment Method',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: textColor,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _paymentMethods.length,
              itemBuilder: (context, index) {
                final method = _paymentMethods[index];
                return _buildPaymentMethodCard(
                  method: method,
                  isSelected: _selectedMethod == method.id,
                  onTap: () => setState(() => _selectedMethod = method.id),
                  isDark: isDark,
                  surfaceColor: surfaceColor,
                  textColor: textColor,
                  subtleColor: subtleColor,
                  borderColor: borderColor,
                );
              },
            ),
          ),
          // Continue Button
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: surfaceColor,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withAlpha(13),
                  blurRadius: 10,
                  offset: const Offset(0, -4),
                ),
              ],
            ),
            child: SafeArea(
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => context.push('/checkout/review'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: WhiteLabelConfig.accentColor,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Continue to Review',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentMethodCard({
    required _PaymentMethod method,
    required bool isSelected,
    required VoidCallback onTap,
    required bool isDark,
    required Color surfaceColor,
    required Color textColor,
    required Color subtleColor,
    required Color borderColor,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: surfaceColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? WhiteLabelConfig.accentColor : borderColor,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected
                      ? WhiteLabelConfig.accentColor
                      : subtleColor,
                  width: 2,
                ),
                color: isSelected
                    ? WhiteLabelConfig.accentColor
                    : Colors.transparent,
              ),
              child: isSelected
                  ? const Icon(Icons.check, size: 14, color: Colors.white)
                  : null,
            ),
            const SizedBox(width: 16),
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: WhiteLabelConfig.accentColor.withAlpha(20),
                borderRadius: BorderRadius.circular(12),
              ),
              child: method.logo != null
                  ? Center(
                      child: Text(
                        method.logo!,
                        style: const TextStyle(fontSize: 24),
                      ),
                    )
                  : Icon(method.icon, color: WhiteLabelConfig.accentColor),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    method.name,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: textColor,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    method.description,
                    style: TextStyle(fontSize: 13, color: subtleColor),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PaymentMethod {
  final String id;
  final String name;
  final String description;
  final IconData icon;
  final String? logo;

  _PaymentMethod({
    required this.id,
    required this.name,
    required this.description,
    required this.icon,
    this.logo,
  });
}
