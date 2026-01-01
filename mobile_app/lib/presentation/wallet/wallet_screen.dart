import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/config/white_label_config.dart';
import '../common/widgets/price_text.dart';

class WalletScreen extends ConsumerStatefulWidget {
  const WalletScreen({super.key});

  @override
  ConsumerState<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends ConsumerState<WalletScreen> {
  String _selectedFilter = 'All';
  double _addMoneyAmount = 100;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = isDark
        ? const Color(0xFF101622)
        : const Color(0xFFF3F4F6);
    final surfaceColor = isDark ? const Color(0xFF1E293B) : Colors.white;
    final textPrimary = isDark ? Colors.white : const Color(0xFF111827);
    final textSecondary = isDark
        ? const Color(0xFF9CA3AF)
        : const Color(0xFF6B7280);

    return Scaffold(
      backgroundColor: backgroundColor,
      body: Stack(
        children: [
          Column(
            children: [
              // Header
              _buildHeader(context, isDark, surfaceColor, textPrimary),

              // Scrollable Content
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    children: [
                      const SizedBox(height: 24),

                      // Balance Card
                      _buildBalanceCard(context),

                      const SizedBox(height: 24),

                      // Quick Actions
                      _buildQuickActions(isDark, textSecondary),

                      const SizedBox(height: 32),

                      // Exclusive Offers
                      _buildExclusiveOffers(isDark),

                      const SizedBox(height: 16),

                      // Recent Transactions Section
                      _buildTransactionsSection(
                        isDark,
                        surfaceColor,
                        textPrimary,
                        textSecondary,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          // Floating Add Button
          Positioned(
            bottom: 100,
            right: 24,
            child: _buildFloatingAddButton(context, isDark),
          ),

          // Bottom Navigation
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: _buildBottomNavigation(isDark, surfaceColor),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(
    BuildContext context,
    bool isDark,
    Color surfaceColor,
    Color textPrimary,
  ) {
    return Container(
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 12,
        left: 20,
        right: 20,
        bottom: 16,
      ),
      decoration: BoxDecoration(
        color: surfaceColor,
        border: Border(
          bottom: BorderSide(
            color: isDark
                ? Colors.white.withValues(alpha: 0.1)
                : const Color(0xFFF3F4F6),
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              GestureDetector(
                onTap: () => context.pop(),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Icon(Icons.arrow_back, color: textPrimary),
                ),
              ),
              const SizedBox(width: 12),
              Text(
                'My Wallet',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: textPrimary,
                ),
              ),
            ],
          ),
          Stack(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Icon(Icons.notifications_outlined, color: textPrimary),
              ),
              Positioned(
                right: 8,
                top: 8,
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 1.5),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBalanceCard(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF4F46E5), Color(0xFF7C3AED)],
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: WhiteLabelConfig.accentColor.withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Decorative circles
          Positioned(
            top: -40,
            right: -40,
            child: Container(
              width: 128,
              height: 128,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.05),
              ),
            ),
          ),
          Positioned(
            bottom: -32,
            left: -32,
            child: Container(
              width: 96,
              height: 96,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.05),
              ),
            ),
          ),

          // Content
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Total Balance',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.white.withValues(alpha: 0.8),
                ),
              ),
              const SizedBox(height: 4),
              PriceText(
                price: 2458.50,
                style: const TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Cashback Earned',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.white.withValues(alpha: 0.7),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(
                            Icons.star,
                            color: Color(0xFFFDE047),
                            size: 16,
                          ),
                          const SizedBox(width: 4),
                          PriceText(
                            price: 142.00,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  GestureDetector(
                    onTap: () => _showAddMoneySheet(context),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.1),
                            blurRadius: 8,
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.add,
                            size: 16,
                            color: WhiteLabelConfig.accentColor,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Add Money',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: WhiteLabelConfig.accentColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions(bool isDark, Color textSecondary) {
    final actions = [
      _QuickAction(Icons.add_card, 'Add Money'),
      _QuickAction(Icons.send, 'Transfer'),
      _QuickAction(Icons.receipt_long, 'History'),
      _QuickAction(Icons.more_horiz, 'More'),
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: actions.map((action) {
          return GestureDetector(
            onTap: () {
              if (action.label == 'Add Money') {
                _showAddMoneySheet(context);
              }
            },
            child: Column(
              children: [
                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    color: isDark
                        ? WhiteLabelConfig.accentColor.withValues(alpha: 0.15)
                        : const Color(0xFFEEF2FF),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(
                    action.icon,
                    color: WhiteLabelConfig.accentColor,
                    size: 24,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  action.label,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: textSecondary,
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildExclusiveOffers(bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Exclusive Offers',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : const Color(0xFF111827),
                ),
              ),
              TextButton(
                onPressed: () {},
                child: Text(
                  'See All',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: WhiteLabelConfig.accentColor,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 140,
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            physics: const BouncingScrollPhysics(),
            children: [
              _buildOfferCard(
                tag: 'Limited',
                tagColor: WhiteLabelConfig.accentColor,
                title: 'Get 5% Cashback',
                subtitle: 'On adding \$50 or more to wallet',
                buttonText: 'Redeem Now',
                icon: Icons.account_balance_wallet,
                gradientColors: [
                  const Color(0xFFFFF7ED),
                  const Color(0xFFFFEDD5),
                ],
                borderColor: const Color(0xFFFED7AA),
                iconBgColor: const Color(0xFFFED7AA),
                iconColor: WhiteLabelConfig.accentColor,
                buttonColor: WhiteLabelConfig.accentColor,
                isDark: isDark,
              ),
              const SizedBox(width: 16),
              _buildOfferCard(
                tag: 'New',
                tagColor: const Color(0xFF3B82F6),
                title: 'Flat \$10 Bonus',
                subtitle: 'First transfer to bank account',
                buttonText: 'Claim Bonus',
                icon: Icons.payments,
                gradientColors: [
                  const Color(0xFFEFF6FF),
                  const Color(0xFFDBEAFE),
                ],
                borderColor: const Color(0xFFBFDBFE),
                iconBgColor: const Color(0xFFBFDBFE),
                iconColor: const Color(0xFF3B82F6),
                buttonColor: const Color(0xFF3B82F6),
                isDark: isDark,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildOfferCard({
    required String tag,
    required Color tagColor,
    required String title,
    required String subtitle,
    required String buttonText,
    required IconData icon,
    required List<Color> gradientColors,
    required Color borderColor,
    required Color iconBgColor,
    required Color iconColor,
    required Color buttonColor,
    required bool isDark,
  }) {
    return Container(
      width: 260,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isDark
              ? [
                  gradientColors[0].withValues(alpha: 0.1),
                  gradientColors[1].withValues(alpha: 0.1),
                ]
              : gradientColors,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? borderColor.withValues(alpha: 0.3) : borderColor,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: tagColor,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    tag.toUpperCase(),
                    style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : const Color(0xFF1F2937),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 12,
                    color: isDark
                        ? Colors.white.withValues(alpha: 0.7)
                        : const Color(0xFF6B7280),
                  ),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.6),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: isDark
                          ? borderColor.withValues(alpha: 0.5)
                          : borderColor,
                    ),
                  ),
                  child: Text(
                    buttonText,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: buttonColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: isDark ? iconBgColor.withValues(alpha: 0.2) : iconBgColor,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: iconColor, size: 24),
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionsSection(
    bool isDark,
    Color surfaceColor,
    Color textPrimary,
    Color textSecondary,
  ) {
    final filters = ['All', 'Credits', 'Debits', 'Failed'];

    return Container(
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, -4),
          ),
        ],
        border: Border(
          top: BorderSide(
            color: isDark
                ? Colors.white.withValues(alpha: 0.1)
                : const Color(0xFFF3F4F6),
          ),
        ),
      ),
      child: Column(
        children: [
          // Section Header
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Recent Transactions',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: textPrimary,
                  ),
                ),
                Icon(Icons.filter_list, color: textSecondary, size: 20),
              ],
            ),
          ),

          // Filter Chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            physics: const BouncingScrollPhysics(),
            child: Row(
              children: filters.map((filter) {
                final isSelected = _selectedFilter == filter;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedFilter = filter;
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? (isDark
                                  ? const Color(0xFF1F2937)
                                  : const Color(0xFF111827))
                            : (isDark
                                  ? Colors.white.withValues(alpha: 0.05)
                                  : const Color(0xFFF3F4F6)),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        filter,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: isSelected
                              ? Colors.white
                              : (isDark
                                    ? const Color(0xFF9CA3AF)
                                    : const Color(0xFF6B7280)),
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),

          const SizedBox(height: 24),

          // Transaction List
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                _buildTransactionItem(
                  icon: Icons.arrow_downward,
                  iconBgColor: const Color(0xFFDCFCE7),
                  iconColor: const Color(0xFF16A34A),
                  title: 'Wallet Top-up',
                  subtitle: 'Today, 10:42 AM',
                  price: 250.00,
                  isCredit: true,
                  amountColor: const Color(0xFF16A34A),
                  status: 'Success',
                  statusColor: textSecondary,
                  isDark: isDark,
                  textPrimary: textPrimary,
                  textSecondary: textSecondary,
                ),
                const SizedBox(height: 24),
                _buildTransactionItem(
                  icon: Icons.shopping_bag_outlined,
                  iconBgColor: const Color(0xFFFEE2E2),
                  iconColor: const Color(0xFFDC2626),
                  title: 'Nike Store Purchase',
                  subtitle: 'Yesterday, 4:20 PM',
                  price: 129.99,
                  isCredit: false,
                  amountColor: textPrimary,
                  status: 'Success',
                  statusColor: textSecondary,
                  isDark: isDark,
                  textPrimary: textPrimary,
                  textSecondary: textSecondary,
                ),
                const SizedBox(height: 24),
                _buildTransactionItem(
                  icon: Icons.person_outline,
                  iconBgColor: const Color(0xFFFED7AA),
                  iconColor: WhiteLabelConfig.accentColor,
                  title: 'Transfer to John Doe',
                  subtitle: 'Oct 24, 2:30 PM',
                  price: 50.00,
                  isCredit: false,
                  amountColor: textPrimary,
                  status: 'Pending',
                  statusColor: WhiteLabelConfig.accentColor,
                  isDark: isDark,
                  textPrimary: textPrimary,
                  textSecondary: textSecondary,
                ),
                const SizedBox(height: 24),
                _buildTransactionItem(
                  icon: Icons.redeem,
                  iconBgColor: const Color(0xFFDCFCE7),
                  iconColor: const Color(0xFF16A34A),
                  title: 'Cashback Received',
                  subtitle: 'Oct 22, 9:15 AM',
                  price: 12.50,
                  isCredit: true,
                  amountColor: const Color(0xFF16A34A),
                  status: 'Success',
                  statusColor: textSecondary,
                  isDark: isDark,
                  textPrimary: textPrimary,
                  textSecondary: textSecondary,
                ),
                const SizedBox(height: 120),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionItem({
    required IconData icon,
    required Color iconBgColor,
    required Color iconColor,
    required String title,
    required String subtitle,
    required double price,
    required bool isCredit,
    required Color amountColor,
    required String status,
    required Color statusColor,
    required bool isDark,
    required Color textPrimary,
    required Color textSecondary,
  }) {
    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: isDark ? iconBgColor.withValues(alpha: 0.2) : iconBgColor,
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: iconColor, size: 20),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: textPrimary,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: TextStyle(fontSize: 12, color: textSecondary),
              ),
            ],
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  isCredit ? '+' : '-',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: amountColor,
                  ),
                ),
                PriceText(
                  price: price,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: amountColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 2),
            Text(status, style: TextStyle(fontSize: 12, color: statusColor)),
          ],
        ),
      ],
    );
  }

  Widget _buildFloatingAddButton(BuildContext context, bool isDark) {
    return GestureDetector(
      onTap: () => _showAddMoneySheet(context),
      child: Container(
        width: 56,
        height: 56,
        decoration: BoxDecoration(
          color: WhiteLabelConfig.accentColor,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: WhiteLabelConfig.accentColor.withValues(alpha: 0.4),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: const Icon(Icons.add, color: Colors.white, size: 28),
      ),
    );
  }

  Widget _buildBottomNavigation(bool isDark, Color surfaceColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      decoration: BoxDecoration(
        color: surfaceColor,
        border: Border(
          top: BorderSide(
            color: isDark
                ? Colors.white.withValues(alpha: 0.1)
                : const Color(0xFFF3F4F6),
          ),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildNavItem(Icons.home_outlined, 'Home', false, isDark),
            _buildNavItem(Icons.account_balance_wallet, 'Wallet', true, isDark),
            _buildNavItem(Icons.qr_code_scanner, 'Scan', false, isDark),
            _buildNavItem(Icons.history, 'History', false, isDark),
            _buildNavItem(Icons.person_outline, 'Profile', false, isDark),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(
    IconData icon,
    String label,
    bool isSelected,
    bool isDark,
  ) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          color: isSelected
              ? WhiteLabelConfig.accentColor
              : (isDark ? const Color(0xFF9CA3AF) : const Color(0xFF9CA3AF)),
          size: 24,
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 10,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
            color: isSelected
                ? WhiteLabelConfig.accentColor
                : (isDark ? const Color(0xFF9CA3AF) : const Color(0xFF9CA3AF)),
          ),
        ),
      ],
    );
  }

  void _showAddMoneySheet(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final surfaceColor = isDark ? const Color(0xFF1E293B) : Colors.white;
    final textPrimary = isDark ? Colors.white : const Color(0xFF111827);
    final textSecondary = isDark
        ? const Color(0xFF9CA3AF)
        : const Color(0xFF6B7280);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) => Container(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          decoration: BoxDecoration(
            color: surfaceColor,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Handle
                Center(
                  child: Container(
                    width: 48,
                    height: 4,
                    decoration: BoxDecoration(
                      color: isDark
                          ? Colors.white.withValues(alpha: 0.2)
                          : const Color(0xFFE5E7EB),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Add Money',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: textPrimary,
                      ),
                    ),
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Icon(Icons.close, color: textSecondary),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Amount Input
                Text(
                  'ENTER AMOUNT',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: textSecondary,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    Text(
                      '\$',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: textPrimary,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: TextField(
                        controller: TextEditingController(
                          text: _addMoneyAmount.toInt().toString(),
                        ),
                        keyboardType: TextInputType.number,
                        style: TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                          color: textPrimary,
                        ),
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.zero,
                        ),
                        onChanged: (value) {
                          setModalState(() {
                            _addMoneyAmount =
                                double.tryParse(value) ?? _addMoneyAmount;
                          });
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Quick Amount Buttons
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  child: Row(
                    children: [50.0, 100.0, 200.0, 500.0].map((amount) {
                      final isSelected = _addMoneyAmount == amount;
                      return Padding(
                        padding: const EdgeInsets.only(right: 12),
                        child: GestureDetector(
                          onTap: () {
                            setModalState(() {
                              _addMoneyAmount = amount;
                            });
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 10,
                            ),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? (isDark
                                        ? WhiteLabelConfig.accentColor
                                              .withValues(alpha: 0.15)
                                        : const Color(0xFFEEF2FF))
                                  : (isDark
                                        ? Colors.white.withValues(alpha: 0.05)
                                        : const Color(0xFFF9FAFB)),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: isSelected
                                    ? (isDark
                                          ? WhiteLabelConfig.accentColor
                                                .withValues(alpha: 0.3)
                                          : const Color(0xFFC7D2FE))
                                    : (isDark
                                          ? Colors.white.withValues(alpha: 0.1)
                                          : const Color(0xFFE5E7EB)),
                              ),
                            ),
                            child: Text(
                              '+\$${amount.toInt()}',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: isSelected
                                    ? WhiteLabelConfig.accentColor
                                    : (isDark
                                          ? const Color(0xFF9CA3AF)
                                          : const Color(0xFF374151)),
                              ),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(height: 24),

                // Payment Method
                Text(
                  'PAYMENT METHOD',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: textSecondary,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isDark
                          ? Colors.white.withValues(alpha: 0.1)
                          : const Color(0xFFE5E7EB),
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 40,
                        height: 24,
                        decoration: BoxDecoration(
                          color: const Color(0xFF1E293B),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Center(
                          child: Text(
                            'VISA',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 8,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Visa •••• 4242',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: textPrimary,
                              ),
                            ),
                            Text(
                              'Expires 12/25',
                              style: TextStyle(
                                fontSize: 12,
                                color: textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Icon(Icons.chevron_right, color: textSecondary),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Cashback Applied
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: isDark
                        ? const Color(0xFF16A34A).withValues(alpha: 0.1)
                        : const Color(0xFFF0FDF4),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isDark
                          ? const Color(0xFF16A34A).withValues(alpha: 0.2)
                          : const Color(0xFFBBF7D0),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.local_offer,
                        color: isDark
                            ? const Color(0xFF4ADE80)
                            : const Color(0xFF166534),
                        size: 18,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Applied: 5% Cashback on this transaction',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: isDark
                                ? const Color(0xFF4ADE80)
                                : const Color(0xFF166534),
                          ),
                        ),
                      ),
                      Icon(
                        Icons.close,
                        color: isDark
                            ? const Color(0xFF4ADE80)
                            : const Color(0xFF166534),
                        size: 16,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),

                // Proceed Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      // Close sheet and show success
                      Navigator.pop(context);

                      // Show success message
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Row(
                            children: [
                              const Icon(
                                Icons.check_circle,
                                color: Colors.white,
                                size: 20,
                              ),
                              const SizedBox(width: 12),
                              Text(
                                '\$${_addMoneyAmount.toInt()} added to your wallet!',
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                          backgroundColor: const Color(0xFF16A34A),
                          behavior: SnackBarBehavior.floating,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          duration: const Duration(seconds: 3),
                        ),
                      );

                      // Note: In production, this would call an API to process payment
                      // and update the wallet balance. The UI would refresh via provider.
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: WhiteLabelConfig.accentColor,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 0,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Proceed to Add \$${_addMoneyAmount.toInt()}',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Icon(Icons.arrow_forward, size: 18),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 8),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _QuickAction {
  final IconData icon;
  final String label;

  _QuickAction(this.icon, this.label);
}
