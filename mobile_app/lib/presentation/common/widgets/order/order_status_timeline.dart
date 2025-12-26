import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';

/// Order status step configuration
class OrderStatusStep {
  final String title;
  final String? subtitle;
  final DateTime? timestamp;
  final IconData? icon;
  final OrderStepStatus status;

  const OrderStatusStep({
    required this.title,
    this.subtitle,
    this.timestamp,
    this.icon,
    this.status = OrderStepStatus.pending,
  });
}

/// Status of individual step
enum OrderStepStatus { completed, current, pending }

/// OrderStatusTimeline - Vertical timeline for order tracking
///
/// Example usage:
/// ```dart
/// OrderStatusTimeline(
///   steps: [
///     OrderStatusStep(
///       title: 'Order Placed',
///       subtitle: 'Your order has been confirmed',
///       timestamp: orderDate,
///       status: OrderStepStatus.completed,
///     ),
///     OrderStatusStep(
///       title: 'Processing',
///       status: OrderStepStatus.current,
///     ),
///     OrderStatusStep(
///       title: 'Shipped',
///       status: OrderStepStatus.pending,
///     ),
///   ],
/// )
/// ```
class OrderStatusTimeline extends StatelessWidget {
  /// Timeline steps
  final List<OrderStatusStep> steps;

  /// Completed step color
  final Color? completedColor;

  /// Current step color
  final Color? currentColor;

  /// Pending step color
  final Color? pendingColor;

  /// Whether to show connector lines
  final bool showConnectors;

  const OrderStatusTimeline({
    super.key,
    required this.steps,
    this.completedColor,
    this.currentColor,
    this.pendingColor,
    this.showConnectors = true,
  });

  /// Standard ecommerce order timeline
  factory OrderStatusTimeline.standard({
    required int currentStep,
    DateTime? orderDate,
    DateTime? processingDate,
    DateTime? shippedDate,
    DateTime? deliveredDate,
  }) {
    final statuses = [
      OrderStepStatus.completed,
      if (currentStep >= 1)
        OrderStepStatus.completed
      else
        OrderStepStatus.pending,
      if (currentStep >= 2)
        OrderStepStatus.completed
      else
        OrderStepStatus.pending,
      if (currentStep >= 3)
        OrderStepStatus.completed
      else
        OrderStepStatus.pending,
    ];

    // Mark current step
    if (currentStep < 4) {
      statuses[currentStep] = OrderStepStatus.current;
    }

    return OrderStatusTimeline(
      steps: [
        OrderStatusStep(
          title: 'Order Placed',
          subtitle: 'Your order has been confirmed',
          icon: Icons.receipt_outlined,
          timestamp: orderDate,
          status: statuses[0],
        ),
        OrderStatusStep(
          title: 'Processing',
          subtitle: 'Your order is being prepared',
          icon: Icons.inventory_2_outlined,
          timestamp: processingDate,
          status: statuses[1],
        ),
        OrderStatusStep(
          title: 'Shipped',
          subtitle: 'Your order is on the way',
          icon: Icons.local_shipping_outlined,
          timestamp: shippedDate,
          status: statuses[2],
        ),
        OrderStatusStep(
          title: 'Delivered',
          subtitle: 'Your order has been delivered',
          icon: Icons.check_circle_outline,
          timestamp: deliveredDate,
          status: statuses[3],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final completed = completedColor ?? AppColors.success;
    final current =
        currentColor ?? (isDark ? AppColors.darkPrimary : AppColors.primary);
    final pending =
        pendingColor ?? (isDark ? AppColors.darkTextHint : AppColors.textHint);

    return Column(
      children: steps.asMap().entries.map((entry) {
        final index = entry.key;
        final step = entry.value;
        final isLast = index == steps.length - 1;

        return _TimelineStep(
          step: step,
          isLast: isLast,
          showConnector: showConnectors && !isLast,
          completedColor: completed,
          currentColor: current,
          pendingColor: pending,
          isDark: isDark,
        );
      }).toList(),
    );
  }
}

class _TimelineStep extends StatelessWidget {
  final OrderStatusStep step;
  final bool isLast;
  final bool showConnector;
  final Color completedColor;
  final Color currentColor;
  final Color pendingColor;
  final bool isDark;

  const _TimelineStep({
    required this.step,
    required this.isLast,
    required this.showConnector,
    required this.completedColor,
    required this.currentColor,
    required this.pendingColor,
    required this.isDark,
  });

  Color get _stepColor {
    switch (step.status) {
      case OrderStepStatus.completed:
        return completedColor;
      case OrderStepStatus.current:
        return currentColor;
      case OrderStepStatus.pending:
        return pendingColor;
    }
  }

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Timeline indicator column
          SizedBox(
            width: 48,
            child: Column(
              children: [
                // Step indicator
                _StepIndicator(
                  status: step.status,
                  icon: step.icon,
                  completedColor: completedColor,
                  currentColor: currentColor,
                  pendingColor: pendingColor,
                ),

                // Connector line
                if (showConnector)
                  Expanded(
                    child: Container(
                      width: 2,
                      margin: const EdgeInsets.symmetric(vertical: 4),
                      color: step.status == OrderStepStatus.completed
                          ? completedColor
                          : (isDark ? AppColors.darkBorder : AppColors.border),
                    ),
                  ),
              ],
            ),
          ),

          // Content
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(left: 8, bottom: isLast ? 0 : 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Text(
                    step.title,
                    style: AppTextStyles.labelLarge.copyWith(
                      color: step.status == OrderStepStatus.pending
                          ? (isDark
                                ? AppColors.darkTextHint
                                : AppColors.textHint)
                          : (isDark
                                ? AppColors.darkTextPrimary
                                : AppColors.textPrimary),
                      fontWeight: step.status == OrderStepStatus.current
                          ? FontWeight.w700
                          : FontWeight.w600,
                    ),
                  ),

                  // Subtitle
                  if (step.subtitle != null) ...[
                    const SizedBox(height: 2),
                    Text(
                      step.subtitle!,
                      style: AppTextStyles.bodySmall.copyWith(
                        color: isDark
                            ? AppColors.darkTextSecondary
                            : AppColors.textSecondary,
                      ),
                    ),
                  ],

                  // Timestamp
                  if (step.timestamp != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      _formatTimestamp(step.timestamp!),
                      style: AppTextStyles.caption.copyWith(
                        color: isDark
                            ? AppColors.darkTextHint
                            : AppColors.textHint,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatTimestamp(DateTime date) {
    final now = DateTime.now();
    final diff = now.difference(date);

    if (diff.inDays == 0) {
      return 'Today at ${_formatTime(date)}';
    } else if (diff.inDays == 1) {
      return 'Yesterday at ${_formatTime(date)}';
    } else {
      return '${date.day}/${date.month}/${date.year} at ${_formatTime(date)}';
    }
  }

  String _formatTime(DateTime date) {
    final hour = date.hour > 12 ? date.hour - 12 : date.hour;
    final period = date.hour >= 12 ? 'PM' : 'AM';
    final minute = date.minute.toString().padLeft(2, '0');
    return '$hour:$minute $period';
  }
}

class _StepIndicator extends StatelessWidget {
  final OrderStepStatus status;
  final IconData? icon;
  final Color completedColor;
  final Color currentColor;
  final Color pendingColor;

  const _StepIndicator({
    required this.status,
    this.icon,
    required this.completedColor,
    required this.currentColor,
    required this.pendingColor,
  });

  @override
  Widget build(BuildContext context) {
    switch (status) {
      case OrderStepStatus.completed:
        return Container(
          width: 28,
          height: 28,
          decoration: BoxDecoration(
            color: completedColor,
            shape: BoxShape.circle,
          ),
          alignment: Alignment.center,
          child: Icon(icon ?? Icons.check, size: 16, color: Colors.white),
        );

      case OrderStepStatus.current:
        return Container(
          width: 28,
          height: 28,
          decoration: BoxDecoration(
            color: currentColor.withValues(alpha: 0.15),
            shape: BoxShape.circle,
            border: Border.all(color: currentColor, width: 2),
          ),
          alignment: Alignment.center,
          child: icon != null
              ? Icon(icon, size: 14, color: currentColor)
              : Container(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    color: currentColor,
                    shape: BoxShape.circle,
                  ),
                ),
        );

      case OrderStepStatus.pending:
        return Container(
          width: 28,
          height: 28,
          decoration: BoxDecoration(
            color: Colors.transparent,
            shape: BoxShape.circle,
            border: Border.all(color: pendingColor, width: 2),
          ),
          alignment: Alignment.center,
          child: icon != null
              ? Icon(icon, size: 14, color: pendingColor)
              : null,
        );
    }
  }
}

/// Horizontal compact timeline for order cards
class CompactOrderTimeline extends StatelessWidget {
  final int currentStep;
  final int totalSteps;
  final Color? activeColor;

  const CompactOrderTimeline({
    super.key,
    required this.currentStep,
    this.totalSteps = 4,
    this.activeColor,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final active = activeColor ?? AppColors.success;
    final inactive = isDark ? AppColors.darkBorder : AppColors.border;

    return Row(
      children: List.generate(totalSteps * 2 - 1, (index) {
        if (index.isOdd) {
          // Connector
          final stepIndex = index ~/ 2;
          return Expanded(
            child: Container(
              height: 2,
              color: stepIndex < currentStep ? active : inactive,
            ),
          );
        } else {
          // Dot
          final stepIndex = index ~/ 2;
          final isCompleted = stepIndex < currentStep;
          final isCurrent = stepIndex == currentStep;

          return Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isCompleted || isCurrent ? active : inactive,
            ),
          );
        }
      }),
    );
  }
}
