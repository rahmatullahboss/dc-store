import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:toastification/toastification.dart';
import '../../core/config/white_label_config.dart';

class OrderDetailsScreen extends StatelessWidget {
  final String orderId;

  const OrderDetailsScreen({super.key, required this.orderId});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final primaryBlue = WhiteLabelConfig.accentColor;
    final bgColor = isDark ? const Color(0xFF101622) : const Color(0xFFF6F6F8);
    final cardColor = isDark ? Colors.grey[850]! : Colors.white;
    final textColor = isDark ? Colors.white : const Color(0xFF0F172A);
    final subtleTextColor = isDark
        ? Colors.grey[400]!
        : const Color(0xFF64748B);
    final borderColor = isDark ? Colors.grey[700]! : const Color(0xFFE2E8F0);

    // Mock order data
    final order = _OrderDetails(
      id: orderId,
      estimatedArrival: 'Today, by 8:00 PM',
      carrier: 'FedEx Express',
      trackingNumber: 'TRK-882930192',
      currentStep:
          3, // 0-4: Placed, Confirmed, Shipped, Out for Delivery, Delivered
      items: [
        _OrderItem(
          name: 'Nike Air Zoom Pegasus',
          size: '10',
          color: 'Red',
          quantity: 1,
          price: 120.00,
          imageUrl:
              'https://lh3.googleusercontent.com/aida-public/AB6AXuDFkjPmxHckRKFDi9Ceg3xbcW8JzxpXkHUU0hOfWbkHFEaRDnEGrWqYiMTYt4B1qLo_l_YNL3o8h64HtiGmK2FkXt6OrR5Yf-b8bfPSupC30LJBfaWimsOstfxqsCFXKyONYakjuuRUZsPZURmDX8oBwN6Dlls0yesNnhSXPdQieMRvsdi_fE0TLupkIaPLJD4ELgm2mWinWe7T2CVNuvCdN9NxoZV5_Dd3UkXk3Ch_8TbJsjmlton6EOH0Nr99u2fqHYiVGunWaUI',
        ),
        _OrderItem(
          name: 'Nike React Infinity Run',
          size: '10',
          color: 'Yellow',
          quantity: 1,
          price: 160.00,
          imageUrl:
              'https://lh3.googleusercontent.com/aida-public/AB6AXuAc-gj7-3OsFJt9xetZkZa28JdulUUiXStX0oatnmKsZgPOI14Vk5siVojw495-kM7KHF0Uv649LYHSw0dYAYAecqu889DEsydc4fQ3sV1HJzhciEiCNqe9ckMtjaVNZdGnXsHvBmVkY-tVpGGYOgP2TTs8fJpNM4ciOpI0Atgoj6dRQCF86HwCSmu4E3WUMAGNZKKj-Ulp6zb-R-PPPI9434LkB2_JF7EpQZpHD7SqkZ-xeSRmw1rP2AmcD1W--Elglfs3YGxKTfg',
        ),
      ],
      deliveryAddress: '123 Design St, Apt 4B\nSan Francisco, CA 94103',
      paymentMethod: 'Visa ending in 4242',
      subtotal: 280.00,
      shipping: 0.00,
      tax: 24.50,
      discount: 10.00,
      total: 294.50,
    );

    return Scaffold(
      backgroundColor: bgColor,
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              // App Bar
              SliverAppBar(
                pinned: true,
                backgroundColor: cardColor.withAlpha(230),
                surfaceTintColor: Colors.transparent,
                elevation: 0,
                leading: IconButton(
                  icon: Icon(LucideIcons.chevronLeft, color: textColor),
                  onPressed: () => context.pop(),
                ),
                title: Text(
                  'Order #$orderId',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                ),
                centerTitle: true,
                actions: [
                  IconButton(
                    icon: Icon(LucideIcons.share, size: 20, color: textColor),
                    onPressed: () {},
                  ),
                ],
              ),

              // Content
              SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Tracking Hero Section
                    _buildTrackingHero(
                      order,
                      isDark,
                      cardColor,
                      textColor,
                      subtleTextColor,
                      borderColor,
                      primaryBlue,
                      context,
                    ),

                    // Items Section
                    _buildItemsSection(
                      order.items,
                      isDark,
                      cardColor,
                      textColor,
                      subtleTextColor,
                      borderColor,
                      context,
                      order.id,
                    ),

                    // Delivery & Payment Info
                    _buildDeliveryPaymentInfo(
                      order,
                      isDark,
                      cardColor,
                      textColor,
                      subtleTextColor,
                      borderColor,
                    ),

                    // Order Summary
                    _buildOrderSummary(
                      order,
                      isDark,
                      cardColor,
                      textColor,
                      subtleTextColor,
                      borderColor,
                    ),

                    // Secondary Actions
                    _buildSecondaryActions(
                      isDark,
                      cardColor,
                      textColor,
                      borderColor,
                      context,
                    ),

                    const SizedBox(height: 120),
                  ],
                ),
              ),
            ],
          ),

          // Fixed Bottom Actions
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
              decoration: BoxDecoration(
                color: cardColor,
                border: Border(top: BorderSide(color: borderColor)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withAlpha(13),
                    blurRadius: 8,
                    offset: const Offset(0, -4),
                  ),
                ],
              ),
              child: SafeArea(
                top: false,
                child: Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () {},
                        child: Container(
                          height: 52,
                          decoration: BoxDecoration(
                            color: isDark ? Colors.grey[800] : Colors.grey[100],
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                LucideIcons.receipt,
                                size: 18,
                                color: textColor,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'Invoice',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: textColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      flex: 2,
                      child: GestureDetector(
                        onTap: () {},
                        child: Container(
                          height: 52,
                          decoration: BoxDecoration(
                            color: primaryBlue,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: primaryBlue.withAlpha(77),
                                blurRadius: 12,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Icon(
                                LucideIcons.truck,
                                size: 18,
                                color: Colors.white,
                              ),
                              SizedBox(width: 8),
                              Text(
                                'Track Shipment',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTrackingHero(
    _OrderDetails order,
    bool isDark,
    Color cardColor,
    Color textColor,
    Color subtleTextColor,
    Color borderColor,
    Color primaryBlue,
    BuildContext context,
  ) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: borderColor),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Estimated Arrival
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Estimated Arrival',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: subtleTextColor,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      order.estimatedArrival,
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: primaryBlue,
                      ),
                    ),
                  ],
                ),
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: isDark
                        ? primaryBlue.withAlpha(51)
                        : const Color(0xFFEFF6FF),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(LucideIcons.truck, size: 22, color: primaryBlue),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Tracking Number
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isDark
                    ? Colors.grey[900]!.withAlpha(128)
                    : Colors.grey[50],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        order.carrier,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: subtleTextColor,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        order.trackingNumber,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: textColor,
                        ),
                      ),
                    ],
                  ),
                  GestureDetector(
                    onTap: () {
                      Clipboard.setData(
                        ClipboardData(text: order.trackingNumber),
                      );
                      toastification.show(
                        context: context,
                        type: ToastificationType.success,
                        title: const Text('Tracking number copied'),
                        autoCloseDuration: const Duration(seconds: 2),
                      );
                    },
                    child: Text(
                      'COPY',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: primaryBlue,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Timeline
            _buildTimeline(
              order.currentStep,
              isDark,
              textColor,
              subtleTextColor,
              primaryBlue,
              borderColor,
            ),
          ],
        ),
      ),
    ).animate().fadeIn().slideY(begin: 0.05);
  }

  Widget _buildTimeline(
    int currentStep,
    bool isDark,
    Color textColor,
    Color subtleTextColor,
    Color primaryBlue,
    Color borderColor,
  ) {
    final steps = [
      _TimelineStep(
        title: 'Order Placed',
        date: 'May 24, 10:30 AM',
        icon: LucideIcons.check,
      ),
      _TimelineStep(
        title: 'Confirmed',
        date: 'May 24, 2:00 PM',
        icon: LucideIcons.check,
      ),
      _TimelineStep(
        title: 'Shipped',
        date: 'May 25, 9:00 AM',
        icon: LucideIcons.check,
      ),
      _TimelineStep(
        title: 'Out for Delivery',
        date: 'Today, 8:00 AM',
        icon: LucideIcons.truck,
      ),
      _TimelineStep(title: 'Delivered', date: '', icon: LucideIcons.package),
    ];

    return Column(
      children: List.generate(steps.length, (index) {
        final step = steps[index];
        final isCompleted = index < currentStep;
        final isActive = index == currentStep;
        final isFuture = index > currentStep;

        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              children: [
                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: isFuture
                        ? (isDark ? Colors.grey[700] : Colors.grey[200])
                        : primaryBlue,
                    shape: BoxShape.circle,
                    boxShadow: isActive
                        ? [
                            BoxShadow(
                              color: primaryBlue.withAlpha(77),
                              blurRadius: 8,
                              spreadRadius: 2,
                            ),
                          ]
                        : null,
                  ),
                  child: Icon(
                    step.icon,
                    size: 14,
                    color: isFuture
                        ? (isDark ? Colors.grey[500] : Colors.grey[400])
                        : Colors.white,
                  ),
                ),
                if (index < steps.length - 1)
                  Container(
                    width: 2,
                    height: 32,
                    color: isCompleted || isActive
                        ? primaryBlue
                        : (isDark ? Colors.grey[700] : Colors.grey[200]),
                  ),
              ],
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      step.title,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: isActive
                            ? primaryBlue
                            : (isFuture ? subtleTextColor : textColor),
                      ),
                    ),
                    if (step.date.isNotEmpty)
                      Text(
                        step.date,
                        style: TextStyle(fontSize: 12, color: subtleTextColor),
                      ),
                  ],
                ),
              ),
            ),
          ],
        );
      }),
    );
  }

  Widget _buildItemsSection(
    List<_OrderItem> items,
    bool isDark,
    Color cardColor,
    Color textColor,
    Color subtleTextColor,
    Color borderColor,
    BuildContext context,
    String orderId,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Items in Shipment',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
          const SizedBox(height: 12),
          ...items.map(
            (item) => Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: cardColor,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: borderColor),
              ),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: CachedNetworkImage(
                      imageUrl: item.imageUrl,
                      width: 96,
                      height: 96,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Container(
                        width: 96,
                        height: 96,
                        color: isDark ? Colors.grey[800] : Colors.grey[100],
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.name,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: textColor,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Size: ${item.size} • Color: ${item.color}',
                          style: TextStyle(
                            fontSize: 12,
                            color: subtleTextColor,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Qty: ${item.quantity}',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: subtleTextColor,
                              ),
                            ),
                            Text(
                              '\$${item.price.toStringAsFixed(2)}',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: textColor,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        // Write Review Button
                        GestureDetector(
                          onTap: () {
                            context.push(
                              '/write-review?productId=${item.name.hashCode}&orderId=$orderId',
                            );
                          },
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            decoration: BoxDecoration(
                              color: isDark
                                  ? const Color(0xFF135bec).withAlpha(26)
                                  : const Color(0xFFEFF6FF),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: const Color(0xFF135bec).withAlpha(51),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                Icon(
                                  LucideIcons.star,
                                  size: 16,
                                  color: Color(0xFF135bec),
                                ),
                                SizedBox(width: 6),
                                Text(
                                  'Write Review',
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFF135bec),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDeliveryPaymentInfo(
    _OrderDetails order,
    bool isDark,
    Color cardColor,
    Color textColor,
    Color subtleTextColor,
    Color borderColor,
  ) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Container(
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: borderColor),
        ),
        child: Column(
          children: [
            // Delivery Address
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: isDark ? Colors.grey[800] : Colors.grey[50],
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      LucideIcons.mapPin,
                      size: 18,
                      color: subtleTextColor,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Delivery Address',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: textColor,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          order.deliveryAddress,
                          style: TextStyle(
                            fontSize: 14,
                            color: subtleTextColor,
                            height: 1.4,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Divider(height: 1, color: borderColor),
            // Payment Method
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 28,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF1E40AF), Color(0xFF2563EB)],
                      ),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Center(
                      child: Text(
                        'VISA',
                        style: TextStyle(
                          fontSize: 8,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Payment Method',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: textColor,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          order.paymentMethod,
                          style: TextStyle(
                            fontSize: 14,
                            color: subtleTextColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Icon(
                    LucideIcons.checkCircle2,
                    size: 20,
                    color: Color(0xFF10B981),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderSummary(
    _OrderDetails order,
    bool isDark,
    Color cardColor,
    Color textColor,
    Color subtleTextColor,
    Color borderColor,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: borderColor),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Order Summary',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
            const SizedBox(height: 16),
            _buildSummaryRow(
              'Subtotal (${order.items.length} items)',
              '\$${order.subtotal.toStringAsFixed(2)}',
              subtleTextColor,
              null,
            ),
            const SizedBox(height: 12),
            _buildSummaryRow(
              'Shipping',
              order.shipping == 0
                  ? 'Free'
                  : '\$${order.shipping.toStringAsFixed(2)}',
              subtleTextColor,
              const Color(0xFF10B981),
            ),
            const SizedBox(height: 12),
            _buildSummaryRow(
              'Tax',
              '\$${order.tax.toStringAsFixed(2)}',
              subtleTextColor,
              null,
            ),
            const SizedBox(height: 12),
            _buildSummaryRow(
              'Discount',
              '- \$${order.discount.toStringAsFixed(2)}',
              subtleTextColor,
              const Color(0xFF10B981),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Divider(height: 1, color: borderColor),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Total',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                ),
                Text(
                  '\$${order.total.toStringAsFixed(2)}',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryRow(
    String label,
    String value,
    Color labelColor,
    Color? valueColor,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: TextStyle(fontSize: 14, color: labelColor)),
        Text(
          value,
          style: TextStyle(
            fontSize: 14,
            fontWeight: valueColor != null
                ? FontWeight.w500
                : FontWeight.normal,
            color: valueColor ?? labelColor,
          ),
        ),
      ],
    );
  }

  Widget _buildSecondaryActions(
    bool isDark,
    Color cardColor,
    Color textColor,
    Color borderColor,
    BuildContext context,
  ) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () {},
              child: Container(
                height: 48,
                decoration: BoxDecoration(
                  color: cardColor,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: borderColor),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(LucideIcons.helpCircle, size: 18, color: textColor),
                    const SizedBox(width: 8),
                    Text(
                      'Need Help?',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: textColor,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: GestureDetector(
              onTap: () {},
              child: Container(
                height: 48,
                decoration: BoxDecoration(
                  color: cardColor,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: borderColor),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(LucideIcons.xCircle, size: 18, color: Colors.red[600]),
                    const SizedBox(width: 8),
                    Text(
                      'Cancel Order',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.red[600],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _OrderDetails {
  final String id;
  final String estimatedArrival;
  final String carrier;
  final String trackingNumber;
  final int currentStep;
  final List<_OrderItem> items;
  final String deliveryAddress;
  final String paymentMethod;
  final double subtotal;
  final double shipping;
  final double tax;
  final double discount;
  final double total;

  _OrderDetails({
    required this.id,
    required this.estimatedArrival,
    required this.carrier,
    required this.trackingNumber,
    required this.currentStep,
    required this.items,
    required this.deliveryAddress,
    required this.paymentMethod,
    required this.subtotal,
    required this.shipping,
    required this.tax,
    required this.discount,
    required this.total,
  });
}

class _OrderItem {
  final String name;
  final String size;
  final String color;
  final int quantity;
  final double price;
  final String imageUrl;

  _OrderItem({
    required this.name,
    required this.size,
    required this.color,
    required this.quantity,
    required this.price,
    required this.imageUrl,
  });
}

class _TimelineStep {
  final String title;
  final String date;
  final IconData icon;

  _TimelineStep({required this.title, required this.date, required this.icon});
}
