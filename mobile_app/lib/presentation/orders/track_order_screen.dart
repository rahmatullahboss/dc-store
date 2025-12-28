import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../core/config/white_label_config.dart';

/// Track Order Screen with timeline stepper
class TrackOrderScreen extends ConsumerWidget {
  final String orderId;

  const TrackOrderScreen({super.key, required this.orderId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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

    // Mock tracking data - in production, fetch from API
    final trackingSteps = [
      _TrackingStep(
        title: 'Order Placed',
        description: 'Your order has been placed successfully',
        time: 'Dec 25, 2024 10:30 AM',
        isCompleted: true,
      ),
      _TrackingStep(
        title: 'Order Confirmed',
        description: 'Seller has confirmed your order',
        time: 'Dec 25, 2024 11:45 AM',
        isCompleted: true,
      ),
      _TrackingStep(
        title: 'Shipped',
        description: 'Your order is on the way',
        time: 'Dec 26, 2024 09:00 AM',
        isCompleted: true,
        isCurrent: true,
      ),
      _TrackingStep(
        title: 'Out for Delivery',
        description: 'Order is out for delivery',
        time: 'Expected: Dec 27, 2024',
        isCompleted: false,
      ),
      _TrackingStep(
        title: 'Delivered',
        description: 'Order delivered successfully',
        time: '',
        isCompleted: false,
      ),
    ];

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
          'Track Order',
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
            // Order Info Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: surfaceColor,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: borderColor),
              ),
              child: Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: WhiteLabelConfig.accentColor.withAlpha(20),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      LucideIcons.package,
                      color: WhiteLabelConfig.accentColor,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Order #$orderId',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: textColor,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Estimated Delivery: Dec 27, 2024',
                          style: TextStyle(fontSize: 13, color: subtleColor),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ).animate().fadeIn().slideY(begin: 0.1),
            const SizedBox(height: 24),

            // Tracking Timeline
            Text(
              'Order Status',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
            const SizedBox(height: 16),
            ...trackingSteps.asMap().entries.map((entry) {
              final index = entry.key;
              final step = entry.value;
              final isLast = index == trackingSteps.length - 1;

              return _buildTimelineItem(
                step: step,
                isLast: isLast,
                isDark: isDark,
                surfaceColor: surfaceColor,
                textColor: textColor,
                subtleColor: subtleColor,
                borderColor: borderColor,
              ).animate(delay: (100 * index).ms).fadeIn().slideX(begin: 0.1);
            }),

            const SizedBox(height: 24),

            // Delivery Address
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
                        LucideIcons.mapPin,
                        size: 18,
                        color: WhiteLabelConfig.accentColor,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Delivery Address',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: textColor,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Home\n123 Main Street\nDhaka 1000, Bangladesh',
                    style: TextStyle(
                      fontSize: 14,
                      color: subtleColor,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ).animate(delay: 400.ms).fadeIn(),

            const SizedBox(height: 16),

            // Contact Support Button
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () => context.push('/chat'),
                icon: const Icon(LucideIcons.messageCircle),
                label: const Text('Need Help? Chat with us'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: WhiteLabelConfig.accentColor,
                  side: BorderSide(color: WhiteLabelConfig.accentColor),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ).animate(delay: 500.ms).fadeIn(),
          ],
        ),
      ),
    );
  }

  Widget _buildTimelineItem({
    required _TrackingStep step,
    required bool isLast,
    required bool isDark,
    required Color surfaceColor,
    required Color textColor,
    required Color subtleColor,
    required Color borderColor,
  }) {
    final activeColor = WhiteLabelConfig.accentColor;
    final inactiveColor = isDark
        ? const Color(0xFF475569)
        : const Color(0xFFD1D5DB);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Timeline Column
        SizedBox(
          width: 40,
          child: Column(
            children: [
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: step.isCompleted ? activeColor : inactiveColor,
                  border: step.isCurrent
                      ? Border.all(color: activeColor, width: 3)
                      : null,
                ),
                child: step.isCompleted
                    ? const Icon(Icons.check, size: 14, color: Colors.white)
                    : null,
              ),
              if (!isLast)
                Container(
                  width: 2,
                  height: 60,
                  color: step.isCompleted ? activeColor : inactiveColor,
                ),
            ],
          ),
        ),
        // Content
        Expanded(
          child: Padding(
            padding: EdgeInsets.only(bottom: isLast ? 0 : 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  step.title,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: step.isCompleted || step.isCurrent
                        ? textColor
                        : subtleColor,
                  ),
                ),
                if (step.description.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                    step.description,
                    style: TextStyle(fontSize: 13, color: subtleColor),
                  ),
                ],
                if (step.time.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                    step.time,
                    style: TextStyle(
                      fontSize: 12,
                      color: step.isCurrent ? activeColor : subtleColor,
                      fontWeight: step.isCurrent
                          ? FontWeight.w500
                          : FontWeight.normal,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _TrackingStep {
  final String title;
  final String description;
  final String time;
  final bool isCompleted;
  final bool isCurrent;

  _TrackingStep({
    required this.title,
    required this.description,
    required this.time,
    required this.isCompleted,
    this.isCurrent = false,
  });
}
