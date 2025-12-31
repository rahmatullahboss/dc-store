import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../../core/config/white_label_config.dart';
import '../../../core/config/app_config.dart';
import '../../../services/payment_service.dart';
import '../../cart/presentation/providers/cart_provider.dart';
import 'providers/checkout_provider.dart';

/// Order Review Screen - Final checkout step
class OrderReviewScreen extends ConsumerStatefulWidget {
  const OrderReviewScreen({super.key});

  @override
  ConsumerState<OrderReviewScreen> createState() => _OrderReviewScreenState();
}

class _OrderReviewScreenState extends ConsumerState<OrderReviewScreen> {
  bool _isPlacingOrder = false;
  String? _errorMessage;

  Future<void> _placeOrder() async {
    setState(() {
      _isPlacingOrder = true;
      _errorMessage = null;
    });

    try {
      final cartState = ref.read(cartProvider);
      final checkoutState = ref.read(checkoutProvider);
      final paymentMethod = checkoutState.paymentMethod ?? 'cod';
      final isStripe = paymentMethod == 'stripe';
      final items = cartState.items;
      const shipping = 50.0;
      final subtotal = cartState.totalPrice;
      final total = subtotal + shipping;

      // Generate temp order ID for payment
      final tempOrderId = 'ORD-${DateTime.now().millisecondsSinceEpoch}';

      // If Stripe payment, process payment first
      if (isStripe) {
        final paymentService = PaymentService.instance;
        final paymentResult = await paymentService.processStripePayment(
          orderId: tempOrderId,
          amount: total,
          currency: 'BDT',
        );

        if (!paymentResult.success) {
          throw Exception(paymentResult.message ?? 'Payment failed');
        }
      }

      // Prepare order items for API
      final orderItems = items
          .map(
            (item) => {
              'productId': item.product.id,
              'name': item.product.name,
              'price': item.product.price,
              'quantity': item.quantity,
              'image': item.product.featuredImage,
              'total': item.product.price * item.quantity,
            },
          )
          .toList();

      // Create order via API
      final response = await http.post(
        Uri.parse('${AppConfig.baseUrl}/api/orders'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'items': orderItems,
          'subtotal': subtotal,
          'shippingCost': shipping,
          'total': total,
          'customerName': 'Mobile User', // TODO: Get from user profile
          'customerPhone': '+880123456789', // TODO: Get from user profile
          'customerEmail': null,
          'shippingAddress': {
            'name': 'Mobile User',
            'phone': '+880123456789',
            'address': 'Dhaka, Bangladesh',
            'city': 'Dhaka',
            'country': 'Bangladesh',
          },
          'paymentMethod': paymentMethod,
          'paymentStatus': isStripe ? 'paid' : 'pending',
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);
        final orderNumber =
            data['order']?['orderNumber'] ??
            'ORD-${DateTime.now().millisecondsSinceEpoch}';

        if (mounted) {
          // Clear cart and navigate to success
          ref.read(cartProvider.notifier).clearCart();
          context.go('/order-success/$orderNumber');
        }
      } else {
        final data = jsonDecode(response.body);
        throw Exception(data['error'] ?? 'Failed to place order');
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = e.toString().replaceFirst('Exception: ', '');
          _isPlacingOrder = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(_errorMessage ?? 'Failed to place order'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

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

    final cartState = ref.watch(cartProvider);
    final checkoutState = ref.watch(checkoutProvider);
    final items = cartState.items;
    final subtotal = cartState.totalPrice;
    const shipping = 50.0;
    final total = subtotal + shipping;
    final paymentMethod = checkoutState.paymentMethod ?? 'cod';
    final isStripe = paymentMethod == 'stripe';

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
          'Review Order',
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
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Shipping Address
                  _buildSection(
                    title: 'Shipping Address',
                    icon: LucideIcons.mapPin,
                    onEdit: () => context.push('/checkout/address'),
                    isDark: isDark,
                    surfaceColor: surfaceColor,
                    textColor: textColor,
                    subtleColor: subtleColor,
                    borderColor: borderColor,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'John Doe',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: textColor,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '123 Main Street, Gulshan 1\nDhaka 1212, Bangladesh\n01712345678',
                          style: TextStyle(
                            fontSize: 13,
                            color: subtleColor,
                            height: 1.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Payment Method
                  _buildSection(
                    title: 'Payment Method',
                    icon: LucideIcons.creditCard,
                    onEdit: () => context.push('/checkout/payment'),
                    isDark: isDark,
                    surfaceColor: surfaceColor,
                    textColor: textColor,
                    subtleColor: subtleColor,
                    borderColor: borderColor,
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: isStripe
                                ? Colors.indigo.withAlpha(20)
                                : Colors.green.withAlpha(20),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(
                            isStripe
                                ? LucideIcons.creditCard
                                : LucideIcons.banknote,
                            size: 20,
                            color: isStripe
                                ? Colors.indigo[600]
                                : Colors.green[600],
                          ),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          isStripe ? 'Card Payment' : 'Cash on Delivery',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                            color: textColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Order Items
                  _buildSection(
                    title: 'Order Items (${items.length})',
                    icon: LucideIcons.shoppingBag,
                    isDark: isDark,
                    surfaceColor: surfaceColor,
                    textColor: textColor,
                    subtleColor: subtleColor,
                    borderColor: borderColor,
                    child: Column(
                      children: items.map((item) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: Row(
                            children: [
                              Container(
                                width: 60,
                                height: 60,
                                decoration: BoxDecoration(
                                  color: isDark
                                      ? Colors.grey[800]
                                      : Colors.grey[200],
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: item.product.featuredImage != null
                                    ? ClipRRect(
                                        borderRadius: BorderRadius.circular(8),
                                        child: Image.network(
                                          item.product.featuredImage!,
                                          fit: BoxFit.cover,
                                          errorBuilder: (_, __, ___) => Icon(
                                            LucideIcons.image,
                                            color: subtleColor,
                                          ),
                                        ),
                                      )
                                    : Icon(
                                        LucideIcons.image,
                                        color: subtleColor,
                                      ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      item.product.name,
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                        color: textColor,
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      'Qty: ${item.quantity}',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: subtleColor,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Text(
                                '৳${(item.product.price * item.quantity).toStringAsFixed(0)}',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                  color: textColor,
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Order Summary
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: surfaceColor,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: borderColor),
                    ),
                    child: Column(
                      children: [
                        _buildSummaryRow(
                          'Subtotal',
                          '৳${subtotal.toStringAsFixed(0)}',
                          textColor,
                          subtleColor,
                        ),
                        const SizedBox(height: 8),
                        _buildSummaryRow(
                          'Shipping',
                          '৳${shipping.toStringAsFixed(0)}',
                          textColor,
                          subtleColor,
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 12),
                          child: Divider(),
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
                              '৳${total.toStringAsFixed(0)}',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: WhiteLabelConfig.accentColor,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Place Order Button
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
                  onPressed: _isPlacingOrder ? null : _placeOrder,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: WhiteLabelConfig.accentColor,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: _isPlacingOrder
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation(Colors.white),
                          ),
                        )
                      : Text(
                          'Place Order • ৳${total.toStringAsFixed(0)}',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required IconData icon,
    required bool isDark,
    required Color surfaceColor,
    required Color textColor,
    required Color subtleColor,
    required Color borderColor,
    required Widget child,
    VoidCallback? onEdit,
  }) {
    return Container(
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
              Icon(icon, size: 18, color: WhiteLabelConfig.accentColor),
              const SizedBox(width: 8),
              Text(
                title,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: textColor,
                ),
              ),
              const Spacer(),
              if (onEdit != null)
                GestureDetector(
                  onTap: onEdit,
                  child: Text(
                    'Edit',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: WhiteLabelConfig.accentColor,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }

  Widget _buildSummaryRow(
    String label,
    String value,
    Color textColor,
    Color subtleColor,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: TextStyle(fontSize: 14, color: subtleColor)),
        Text(
          value,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: textColor,
          ),
        ),
      ],
    );
  }
}
