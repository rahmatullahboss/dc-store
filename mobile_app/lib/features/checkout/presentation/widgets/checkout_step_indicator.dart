import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

/// Checkout progress step indicator
/// Shows: Address (done) → Payment (active) → Review (pending)
class CheckoutStepIndicator extends StatelessWidget {
  final int currentStep;

  const CheckoutStepIndicator({
    super.key,
    this.currentStep = 1, // 0: Address, 1: Payment, 2: Review
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryBlue = const Color(0xFF135bec);
    final surfaceColor = isDark ? const Color(0xFF1b2431) : Colors.white;

    return Container(
      color: surfaceColor,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Row(
        children: [
          // Step 1: Address
          _buildStep(
            context,
            step: 0,
            label: 'Address',
            isCompleted: currentStep > 0,
            isActive: currentStep == 0,
            primaryBlue: primaryBlue,
            isDark: isDark,
          ),
          // Connector line
          Expanded(
            child: Container(
              height: 2,
              color: currentStep > 0
                  ? const Color(0xFF22C55E)
                  : (isDark ? Colors.grey[700] : Colors.grey[200]),
            ),
          ),
          // Step 2: Payment
          _buildStep(
            context,
            step: 1,
            label: 'Payment',
            isCompleted: currentStep > 1,
            isActive: currentStep == 1,
            primaryBlue: primaryBlue,
            isDark: isDark,
          ),
          // Connector line
          Expanded(
            child: Container(
              height: 2,
              color: currentStep > 1
                  ? const Color(0xFF22C55E)
                  : (isDark ? Colors.grey[700] : Colors.grey[200]),
            ),
          ),
          // Step 3: Review
          _buildStep(
            context,
            step: 2,
            label: 'Review',
            isCompleted: currentStep > 2,
            isActive: currentStep == 2,
            primaryBlue: primaryBlue,
            isDark: isDark,
          ),
        ],
      ),
    );
  }

  Widget _buildStep(
    BuildContext context, {
    required int step,
    required String label,
    required bool isCompleted,
    required bool isActive,
    required Color primaryBlue,
    required bool isDark,
  }) {
    final greenColor = const Color(0xFF22C55E);
    final grayColor = isDark ? Colors.grey[600]! : Colors.grey[400]!;

    Color bgColor;
    Color textColor;
    Widget child;

    if (isCompleted) {
      bgColor = greenColor;
      textColor = isDark ? const Color(0xFF4ADE80) : greenColor;
      child = const Icon(LucideIcons.check, color: Colors.white, size: 16);
    } else if (isActive) {
      bgColor = primaryBlue;
      textColor = primaryBlue;
      child = Text(
        '${step + 1}',
        style: const TextStyle(
          color: Colors.white,
          fontSize: 14,
          fontWeight: FontWeight.bold,
        ),
      );
    } else {
      bgColor = isDark ? Colors.grey[700]! : Colors.grey[200]!;
      textColor = grayColor;
      child = Text(
        '${step + 1}',
        style: TextStyle(
          color: isDark ? Colors.grey[400] : Colors.grey[500],
          fontSize: 14,
          fontWeight: FontWeight.bold,
        ),
      );
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: bgColor,
            shape: BoxShape.circle,
            boxShadow: isActive
                ? [
                    BoxShadow(
                      color: primaryBlue.withAlpha(51),
                      blurRadius: 8,
                      spreadRadius: 2,
                    ),
                  ]
                : null,
          ),
          child: Center(child: child),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: isActive ? FontWeight.bold : FontWeight.w500,
            color: textColor,
          ),
        ),
      ],
    );
  }
}
