import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

/// Wallet balance section with toggle switch
class WalletSection extends StatelessWidget {
  final double balance;
  final bool isEnabled;
  final ValueChanged<bool> onToggle;

  const WalletSection({
    super.key,
    required this.balance,
    required this.isEnabled,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final surfaceColor = isDark ? const Color(0xFF1b2431) : Colors.white;
    final textColor = isDark ? Colors.white : const Color(0xFF111827);
    final subtleColor = isDark ? Colors.grey[400]! : Colors.grey[500]!;
    final primaryBlue = const Color(0xFF135bec);

    return Container(
      color: surfaceColor,
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          // Icon
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: isDark
                  ? primaryBlue.withAlpha(51)
                  : const Color(0xFFEEF2FF),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Icon(LucideIcons.wallet, color: primaryBlue, size: 20),
          ),
          const SizedBox(width: 12),
          // Text
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Wallet Balance',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                ),
                Text(
                  'Available: \$${balance.toStringAsFixed(2)}',
                  style: TextStyle(fontSize: 12, color: subtleColor),
                ),
              ],
            ),
          ),
          // Toggle Switch
          Switch(
            value: isEnabled,
            onChanged: onToggle,
            thumbColor: WidgetStatePropertyAll(isEnabled ? primaryBlue : null),
            activeTrackColor: primaryBlue.withAlpha(128),
          ),
        ],
      ),
    );
  }
}
