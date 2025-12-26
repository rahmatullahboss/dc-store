import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:toastification/toastification.dart';

import '../../cart/presentation/providers/cart_provider.dart';
import 'widgets/checkout_step_indicator.dart';
import 'widgets/wallet_section.dart';
import 'widgets/saved_card_widget.dart';
import 'widgets/payment_method_tile.dart';
import 'widgets/add_card_sheet.dart';

/// Redesigned Checkout Screen - Payment Step
/// Features: Progress stepper, wallet toggle, saved cards carousel,
/// payment methods, sticky footer with dark mode support
class CheckoutScreen extends ConsumerStatefulWidget {
  const CheckoutScreen({super.key});

  @override
  ConsumerState<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends ConsumerState<CheckoutScreen> {
  // State
  bool _useWallet = false;
  String? _selectedCardId = '1';
  String? _selectedPaymentMethod;
  bool _billingSameAsShipping = true;

  // Mock saved cards
  final List<SavedCard> _savedCards = const [
    SavedCard(
      id: '1',
      cardNumber: '4242',
      cardHolder: 'Jonathan Doe',
      expiryDate: '12/25',
      cardType: 'visa',
      label: 'Personal',
      isDefault: true,
    ),
    SavedCard(
      id: '2',
      cardNumber: '8899',
      cardHolder: 'Jonathan Doe',
      expiryDate: '09/24',
      cardType: 'mastercard',
      label: 'Business',
    ),
  ];

  // Mock wallet balance
  final double _walletBalance = 45.00;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cartTotal = ref.watch(cartTotalProvider);

    // Theme colors
    const primaryBlue = Color(0xFF135bec);
    final bgColor = isDark ? const Color(0xFF101622) : const Color(0xFFF6F6F8);
    final surfaceColor = isDark ? const Color(0xFF1b2431) : Colors.white;
    final textColor = isDark ? Colors.white : const Color(0xFF111827);
    final subtleColor = isDark ? Colors.grey[400]! : Colors.grey[500]!;
    final borderColor = isDark ? Colors.grey[800]! : Colors.grey[100]!;

    // Calculate total
    final shippingCost = cartTotal > 500 ? 0.0 : 60.0;
    final walletDiscount = _useWallet ? _walletBalance : 0.0;
    final total = (cartTotal + shippingCost - walletDiscount).clamp(
      0.0,
      double.infinity,
    );

    return Scaffold(
      backgroundColor: bgColor,
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              // Sticky App Bar
              SliverAppBar(
                pinned: true,
                backgroundColor: surfaceColor,
                surfaceTintColor: Colors.transparent,
                elevation: 0,
                leading: IconButton(
                  onPressed: () => context.pop(),
                  icon: Icon(LucideIcons.arrowLeft, color: textColor),
                ),
                centerTitle: true,
                title: Text(
                  'Checkout',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                ),
                bottom: PreferredSize(
                  preferredSize: const Size.fromHeight(1),
                  child: Container(height: 1, color: borderColor),
                ),
              ),

              // Progress Stepper
              const SliverToBoxAdapter(
                child: CheckoutStepIndicator(currentStep: 1),
              ),

              // Divider
              SliverToBoxAdapter(child: Container(height: 8, color: bgColor)),

              // Wallet Section
              SliverToBoxAdapter(
                child: WalletSection(
                  balance: _walletBalance,
                  isEnabled: _useWallet,
                  onToggle: (value) => setState(() => _useWallet = value),
                ),
              ),

              // Divider
              SliverToBoxAdapter(child: Container(height: 16, color: bgColor)),

              // Saved Cards Section
              SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        'Saved Cards',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: textColor,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      height: 192,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: _savedCards.length + 1,
                        separatorBuilder: (_, __) => const SizedBox(width: 16),
                        itemBuilder: (context, index) {
                          if (index == _savedCards.length) {
                            return AddCardButton(
                              onTap: () => AddCardSheet.show(
                                context,
                                onCardAdded: () {
                                  toastification.show(
                                    context: context,
                                    type: ToastificationType.success,
                                    title: const Text(
                                      'Card added successfully!',
                                    ),
                                    autoCloseDuration: const Duration(
                                      seconds: 2,
                                    ),
                                  );
                                },
                              ),
                            );
                          }
                          final card = _savedCards[index];
                          return SavedCardWidget(
                            card: card,
                            isSelected: _selectedCardId == card.id,
                            onTap: () {
                              setState(() {
                                _selectedCardId = card.id;
                                _selectedPaymentMethod = null;
                              });
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),

              // Divider
              SliverToBoxAdapter(child: Container(height: 24, color: bgColor)),

              // More Payment Options
              SliverToBoxAdapter(
                child: Container(
                  color: surfaceColor,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                        child: Text(
                          'More Options',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: textColor,
                          ),
                        ),
                      ),
                      // UPI
                      PaymentMethodTile(
                        icon: LucideIcons.qrCode,
                        iconColor: Colors.orange[600]!,
                        iconBgColor: isDark
                            ? Colors.orange.withAlpha(51)
                            : const Color(0xFFFFF7ED),
                        title: 'UPI / VPA',
                        subtitle: 'Google Pay, PhonePe, Paytm',
                        isSelected: _selectedPaymentMethod == 'upi',
                        onTap: () {
                          setState(() {
                            _selectedPaymentMethod = 'upi';
                            _selectedCardId = null;
                          });
                        },
                      ),
                      // Net Banking
                      PaymentMethodTile(
                        icon: LucideIcons.landmark,
                        iconColor: Colors.blue[600]!,
                        iconBgColor: isDark
                            ? Colors.blue.withAlpha(51)
                            : const Color(0xFFEFF6FF),
                        title: 'Net Banking',
                        subtitle: 'All major banks supported',
                        isSelected: _selectedPaymentMethod == 'netbanking',
                        onTap: () {
                          setState(() {
                            _selectedPaymentMethod = 'netbanking';
                            _selectedCardId = null;
                          });
                        },
                      ),
                      // Cash on Delivery
                      PaymentMethodTile(
                        icon: LucideIcons.banknote,
                        iconColor: Colors.green[600]!,
                        iconBgColor: isDark
                            ? Colors.green.withAlpha(51)
                            : const Color(0xFFF0FDF4),
                        title: 'Cash on Delivery',
                        subtitle: 'Pay when you receive',
                        isSelected: _selectedPaymentMethod == 'cod',
                        onTap: () {
                          setState(() {
                            _selectedPaymentMethod = 'cod';
                            _selectedCardId = null;
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ),

              // Divider
              SliverToBoxAdapter(child: Container(height: 8, color: bgColor)),

              // Billing Address Toggle
              SliverToBoxAdapter(
                child: Container(
                  color: surfaceColor,
                  padding: const EdgeInsets.all(16),
                  child: InkWell(
                    onTap: () => setState(
                      () => _billingSameAsShipping = !_billingSameAsShipping,
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 20,
                          height: 20,
                          decoration: BoxDecoration(
                            color: _billingSameAsShipping
                                ? primaryBlue
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(4),
                            border: Border.all(
                              color: _billingSameAsShipping
                                  ? primaryBlue
                                  : (isDark
                                        ? Colors.grey[600]!
                                        : Colors.grey[400]!),
                              width: 2,
                            ),
                          ),
                          child: _billingSameAsShipping
                              ? const Icon(
                                  LucideIcons.check,
                                  color: Colors.white,
                                  size: 14,
                                )
                              : null,
                        ),
                        const SizedBox(width: 12),
                        Text(
                          'Billing address is same as shipping',
                          style: TextStyle(
                            fontSize: 14,
                            color: isDark ? Colors.grey[300] : Colors.grey[700],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // Gift Card / Promo Section
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: TextButton.icon(
                    onPressed: () {
                      toastification.show(
                        context: context,
                        type: ToastificationType.info,
                        title: const Text('Coming soon!'),
                        autoCloseDuration: const Duration(seconds: 2),
                      );
                    },
                    icon: Icon(LucideIcons.gift, color: primaryBlue, size: 18),
                    label: Text(
                      'Add Gift Card or Promo Code',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: primaryBlue,
                      ),
                    ),
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                      alignment: Alignment.centerLeft,
                    ),
                  ),
                ),
              ),

              // Bottom spacing for sticky footer
              const SliverToBoxAdapter(child: SizedBox(height: 140)),
            ],
          ),

          // Sticky Footer
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: _buildStickyFooter(
              total: total,
              isDark: isDark,
              surfaceColor: surfaceColor,
              textColor: textColor,
              subtleColor: subtleColor,
              borderColor: borderColor,
              primaryBlue: primaryBlue,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStickyFooter({
    required double total,
    required bool isDark,
    required Color surfaceColor,
    required Color textColor,
    required Color subtleColor,
    required Color borderColor,
    required Color primaryBlue,
  }) {
    return Container(
      padding: EdgeInsets.fromLTRB(
        16,
        16,
        16,
        MediaQuery.of(context).padding.bottom + 16,
      ),
      decoration: BoxDecoration(
        color: surfaceColor,
        border: Border(top: BorderSide(color: borderColor)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(13),
            blurRadius: 8,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Order Summary Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Total to Pay',
                    style: TextStyle(fontSize: 12, color: subtleColor),
                  ),
                  Row(
                    children: [
                      Text(
                        '\$${total.toStringAsFixed(2)}',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: textColor,
                        ),
                      ),
                      const SizedBox(width: 8),
                      GestureDetector(
                        onTap: () {
                          // Show order summary
                          toastification.show(
                            context: context,
                            type: ToastificationType.info,
                            title: const Text('Order summary'),
                            autoCloseDuration: const Duration(seconds: 2),
                          );
                        },
                        child: Text(
                          'View Details',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: primaryBlue,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              // Security Badge
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: isDark ? Colors.grey[800] : Colors.grey[100],
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(LucideIcons.lock, size: 12, color: Colors.green[600]),
                    const SizedBox(width: 4),
                    Text(
                      '100% Secure',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w500,
                        color: subtleColor,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // CTA Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed:
                  _selectedCardId != null || _selectedPaymentMethod != null
                  ? () {
                      // Navigate to review step
                      toastification.show(
                        context: context,
                        type: ToastificationType.success,
                        title: const Text('Proceeding to Review'),
                        autoCloseDuration: const Duration(seconds: 2),
                      );
                      // TODO: Navigate to review screen
                      // context.push('/checkout/review');
                    }
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryBlue,
                foregroundColor: Colors.white,
                disabledBackgroundColor: isDark
                    ? Colors.grey[700]
                    : Colors.grey[300],
                disabledForegroundColor: isDark
                    ? Colors.grey[500]
                    : Colors.grey[500],
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 4,
                shadowColor: primaryBlue.withAlpha(77),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Continue to Review',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(width: 8),
                  Icon(LucideIcons.arrowRight, size: 18),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
