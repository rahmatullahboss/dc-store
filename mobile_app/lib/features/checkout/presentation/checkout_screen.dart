import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/utils/price_formatter.dart';
import '../../../l10n/app_localizations.dart';

import '../../cart/presentation/providers/cart_provider.dart';
import 'widgets/checkout_step_indicator.dart';
import 'providers/checkout_provider.dart';

/// Checkout Screen - Payment Step
/// Features: Progress stepper, payment methods (COD + Stripe only),
/// sticky footer with dark mode support
class CheckoutScreen extends ConsumerStatefulWidget {
  const CheckoutScreen({super.key});

  @override
  ConsumerState<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends ConsumerState<CheckoutScreen> {
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cartTotal = ref.watch(cartTotalProvider);
    final priceFormatter = ref.watch(priceFormatterProvider);
    final l10n = AppLocalizations.of(context)!;
    final checkoutState = ref.watch(checkoutProvider);

    // Theme-aware colors using AppColors
    final bgColor = AppColors.getBackground(context);
    final surfaceColor = AppColors.getCard(context);
    final textColor = AppColors.getTextPrimary(context);
    final subtleColor = AppColors.adaptive(
      context,
      AppColors.textSecondary,
      AppColors.darkTextSecondary,
    );
    final borderColor = AppColors.adaptive(
      context,
      AppColors.border,
      AppColors.darkBorder,
    );
    const primaryAccent = AppColors.accent;

    // Calculate total
    final shippingCost = cartTotal > 500 ? 0.0 : 60.0;
    final total = cartTotal + shippingCost;

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
                  l10n.checkout,
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
              SliverToBoxAdapter(child: Container(height: 16, color: bgColor)),

              // Payment Methods Section
              SliverToBoxAdapter(
                child: Container(
                  color: surfaceColor,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                        child: Text(
                          'Payment Method',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: textColor,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Text(
                          'Select your preferred payment option',
                          style: TextStyle(fontSize: 13, color: subtleColor),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Cash on Delivery
                      _PaymentOptionTile(
                        icon: LucideIcons.banknote,
                        iconColor: Colors.green[600]!,
                        iconBgColor: isDark
                            ? Colors.green.withAlpha(38)
                            : const Color(0xFFF0FDF4),
                        title: 'Cash on Delivery',
                        subtitle: 'Pay when you receive your order',
                        isSelected: checkoutState.paymentMethod == 'cod',
                        onTap: () {
                          ref
                              .read(checkoutProvider.notifier)
                              .setPaymentMethod('cod');
                        },
                        isDark: isDark,
                        textColor: textColor,
                        subtleColor: subtleColor,
                        borderColor: borderColor,
                      ),

                      // Stripe Card Payment
                      _PaymentOptionTile(
                        icon: LucideIcons.creditCard,
                        iconColor: Colors.indigo[600]!,
                        iconBgColor: isDark
                            ? Colors.indigo.withAlpha(38)
                            : const Color(0xFFEEF2FF),
                        title: 'Card Payment',
                        subtitle: 'Pay securely with Visa, Mastercard',
                        isSelected: checkoutState.paymentMethod == 'stripe',
                        onTap: () {
                          ref
                              .read(checkoutProvider.notifier)
                              .setPaymentMethod('stripe');
                        },
                        isDark: isDark,
                        textColor: textColor,
                        subtleColor: subtleColor,
                        borderColor: borderColor,
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Image.asset(
                              'assets/images/visa.png',
                              width: 32,
                              height: 20,
                              errorBuilder: (context, error, stackTrace) =>
                                  const SizedBox(),
                            ),
                            const SizedBox(width: 4),
                            Image.asset(
                              'assets/images/mastercard.png',
                              width: 32,
                              height: 20,
                              errorBuilder: (context, error, stackTrace) =>
                                  const SizedBox(),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 8),
                    ],
                  ),
                ),
              ),

              // Divider
              SliverToBoxAdapter(child: Container(height: 16, color: bgColor)),

              // Security & Trust Badges
              SliverToBoxAdapter(
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: surfaceColor,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: borderColor),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _TrustBadge(
                        icon: LucideIcons.shield,
                        label: 'Secure Payment',
                        color: Colors.green[600]!,
                        isDark: isDark,
                        subtleColor: subtleColor,
                      ),
                      Container(width: 1, height: 32, color: borderColor),
                      _TrustBadge(
                        icon: LucideIcons.truck,
                        label: 'Fast Delivery',
                        color: Colors.blue[600]!,
                        isDark: isDark,
                        subtleColor: subtleColor,
                      ),
                      Container(width: 1, height: 32, color: borderColor),
                      _TrustBadge(
                        icon: LucideIcons.refreshCw,
                        label: 'Easy Returns',
                        color: Colors.orange[600]!,
                        isDark: isDark,
                        subtleColor: subtleColor,
                      ),
                    ],
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
              primaryAccent: primaryAccent,
              isPaymentSelected: checkoutState.paymentMethod != null,
              priceFormatter: priceFormatter,
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
    required Color primaryAccent,
    required bool isPaymentSelected,
    required PriceFormatter priceFormatter,
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
                  Text(
                    priceFormatter.format(total),
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: textColor,
                    ),
                  ),
                ],
              ),
              // Security Badge
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: isDark
                      ? Colors.green.withAlpha(25)
                      : Colors.green.withAlpha(20),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(LucideIcons.lock, size: 14, color: Colors.green[600]),
                    const SizedBox(width: 4),
                    Text(
                      '100% Secure',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Colors.green[600],
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
              onPressed: isPaymentSelected
                  ? () {
                      context.push('/checkout/review');
                    }
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryAccent,
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
                elevation: 2,
                shadowColor: primaryAccent.withAlpha(77),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    isPaymentSelected
                        ? 'Continue to Review'
                        : 'Select Payment Method',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (isPaymentSelected) ...[
                    const SizedBox(width: 8),
                    const Icon(LucideIcons.arrowRight, size: 18),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Payment Option Tile Widget
class _PaymentOptionTile extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final Color iconBgColor;
  final String title;
  final String subtitle;
  final bool isSelected;
  final VoidCallback onTap;
  final bool isDark;
  final Color textColor;
  final Color subtleColor;
  final Color borderColor;
  final Widget? trailing;

  const _PaymentOptionTile({
    required this.icon,
    required this.iconColor,
    required this.iconBgColor,
    required this.title,
    required this.subtitle,
    required this.isSelected,
    required this.onTap,
    required this.isDark,
    required this.textColor,
    required this.subtleColor,
    required this.borderColor,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected
              ? (isDark
                    ? AppColors.accent.withAlpha(15)
                    : AppColors.accent.withAlpha(10))
              : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppColors.accent : borderColor,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            // Icon Container
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: iconBgColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: iconColor, size: 24),
            ),
            const SizedBox(width: 14),
            // Title & Subtitle
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: textColor,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: TextStyle(fontSize: 12, color: subtleColor),
                  ),
                ],
              ),
            ),
            // Trailing widget or radio indicator
            if (trailing != null) ...[trailing!, const SizedBox(width: 12)],
            // Selection Indicator
            Container(
              width: 22,
              height: 22,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isSelected ? AppColors.accent : Colors.transparent,
                border: Border.all(
                  color: isSelected
                      ? AppColors.accent
                      : (isDark ? Colors.grey[600]! : Colors.grey[400]!),
                  width: 2,
                ),
              ),
              child: isSelected
                  ? const Icon(LucideIcons.check, size: 14, color: Colors.white)
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}

/// Trust Badge Widget
class _TrustBadge extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final bool isDark;
  final Color subtleColor;

  const _TrustBadge({
    required this.icon,
    required this.label,
    required this.color,
    required this.isDark,
    required this.subtleColor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 20, color: color),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w500,
            color: subtleColor,
          ),
        ),
      ],
    );
  }
}
