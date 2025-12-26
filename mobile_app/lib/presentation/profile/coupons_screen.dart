import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../core/config/white_label_config.dart';

/// Coupon model
class Coupon {
  final String id;
  final String code;
  final String title;
  final String description;
  final String category;
  final String expiryDate;
  final String? imageUrl;
  final IconData? icon;
  final List<String> terms;
  final bool isExpired;
  final bool isBankOffer;

  const Coupon({
    required this.id,
    required this.code,
    required this.title,
    required this.description,
    required this.category,
    required this.expiryDate,
    this.imageUrl,
    this.icon,
    this.terms = const [],
    this.isExpired = false,
    this.isBankOffer = false,
  });
}

/// Coupons & Offers Screen
/// Features: Tabs for available/my coupons, filter chips by category,
/// coupon cards with copy code, apply button, and expandable T&C
class CouponsScreen extends StatefulWidget {
  const CouponsScreen({super.key});

  @override
  State<CouponsScreen> createState() => _CouponsScreenState();
}

class _CouponsScreenState extends State<CouponsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _selectedCategory = 'All';
  final Map<String, bool> _expandedCards = {};

  final List<String> _categories = [
    'All',
    'Fashion',
    'Electronics',
    'Food',
    'Bank Offers',
  ];

  // Mock coupon data
  final List<Coupon> _availableCoupons = [
    const Coupon(
      id: '1',
      code: 'NIKE20',
      title: 'Flat 20% OFF',
      description: 'On sneakers & sports shoes above \$100',
      category: 'Fashion',
      expiryDate: '24 Oct',
      imageUrl:
          'https://lh3.googleusercontent.com/aida-public/AB6AXuB2AQv_rferTrriTWqzA2z6I1az90cC1LUqTAVvHXzq17NqwFXfqqo_U1PYlCq33iOiuCInLxj45nCtJ1I8roY4B1g5zUjK9ZljrjHYhE36LcSjoISciedb5lan_zd7uiKhg2mRHm20ZHwXHbOUJAzPzO9LwRnhoVfu3yvDpnG4-k_sRtyaiNeRXVCB9hMyWlI0AW2y84KFNEusZNdwgoaEnujy_2sboFIwc_lAnNaKgsci_2uFXO2gh19rgMmO8U-NWugJANi5mGw',
      terms: [
        'Offer valid only on Nike products.',
        'Minimum cart value must be \$100.',
        'Cannot be combined with other offers.',
      ],
    ),
    const Coupon(
      id: '2',
      code: 'TASTY50',
      title: 'Free Burger',
      description: 'On orders above \$25 at BurgerKing',
      category: 'Food',
      expiryDate: '30 Oct',
      icon: LucideIcons.sandwich,
      terms: [
        'Valid at participating locations only.',
        'Not valid on delivery orders.',
      ],
    ),
    const Coupon(
      id: '3',
      code: 'CITI10',
      title: '10% Cashback',
      description: 'Up to \$50 using Citi Cards',
      category: 'Bank Offers',
      expiryDate: '15 Nov',
      icon: LucideIcons.landmark,
      isBankOffer: true,
      terms: [
        'Valid only for Citi credit/debit cards.',
        'Maximum cashback \$50 per transaction.',
        'Minimum purchase \$200 required.',
      ],
    ),
    const Coupon(
      id: '4',
      code: 'TECH30',
      title: '30% OFF Electronics',
      description: 'On all gadgets and accessories',
      category: 'Electronics',
      expiryDate: '20 Nov',
      icon: LucideIcons.smartphone,
      terms: ['Valid on select electronics only.', 'Maximum discount \$150.'],
    ),
    const Coupon(
      id: '5',
      code: 'SHOP15',
      title: '15% OFF Everything',
      description: 'Expired on 10 Oct',
      category: 'Fashion',
      expiryDate: '10 Oct',
      icon: LucideIcons.shoppingBag,
      isExpired: true,
    ),
  ];

  final List<Coupon> _myCoupons = [
    const Coupon(
      id: '6',
      code: 'WELCOME50',
      title: '\$50 Welcome Bonus',
      description: 'First order discount',
      category: 'All',
      expiryDate: '31 Dec',
      icon: LucideIcons.gift,
      terms: ['Valid for first-time users only.', 'One-time use per account.'],
    ),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  List<Coupon> get _filteredCoupons {
    final coupons = _tabController.index == 0 ? _availableCoupons : _myCoupons;

    if (_selectedCategory == 'All') {
      return coupons;
    }
    return coupons.where((c) => c.category == _selectedCategory).toList();
  }

  List<Coupon> get _activeCoupons =>
      _filteredCoupons.where((c) => !c.isExpired).toList();

  List<Coupon> get _expiredCoupons =>
      _filteredCoupons.where((c) => c.isExpired).toList();

  void _copyCouponCode(String code) {
    Clipboard.setData(ClipboardData(text: code));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(LucideIcons.checkCircle, color: Colors.green, size: 20),
            const SizedBox(width: 12),
            Text(
              'Coupon code "$code" copied!',
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ],
        ),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        backgroundColor: Theme.of(context).brightness == Brightness.dark
            ? const Color(0xFF1a2233)
            : const Color(0xFF0d121b),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _applyCoupon(Coupon coupon) {
    // TODO: Implement apply coupon logic
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Applied coupon: ${coupon.code}'),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Theme colors
    final bgColor = isDark ? const Color(0xFF101622) : const Color(0xFFF6F6F8);
    final surfaceColor = isDark ? const Color(0xFF1a2233) : Colors.white;
    final textColor = isDark ? Colors.white : const Color(0xFF0d121b);
    final subtleColor = isDark
        ? const Color(0xFF94a3b8)
        : const Color(0xFF4c669a);
    final borderColor = isDark
        ? const Color(0xFF2a3344)
        : const Color(0xFFe7ebf3);
    const primaryColor = Color(0xFF135bec);

    return Scaffold(
      backgroundColor: bgColor,
      body: Column(
        children: [
          // Sticky Header
          _buildHeader(
            isDark: isDark,
            bgColor: bgColor,
            textColor: textColor,
            borderColor: borderColor,
          ),

          // Tabs
          _buildTabs(
            isDark: isDark,
            bgColor: bgColor,
            textColor: textColor,
            subtleColor: subtleColor,
            primaryColor: primaryColor,
          ),

          // Filter Chips
          _buildFilterChips(
            isDark: isDark,
            bgColor: bgColor,
            textColor: textColor,
            borderColor: borderColor,
            primaryColor: primaryColor,
          ),

          // Content
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildCouponsList(
                  isDark: isDark,
                  surfaceColor: surfaceColor,
                  textColor: textColor,
                  subtleColor: subtleColor,
                  borderColor: borderColor,
                  primaryColor: primaryColor,
                ),
                _buildCouponsList(
                  isDark: isDark,
                  surfaceColor: surfaceColor,
                  textColor: textColor,
                  subtleColor: subtleColor,
                  borderColor: borderColor,
                  primaryColor: primaryColor,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader({
    required bool isDark,
    required Color bgColor,
    required Color textColor,
    required Color borderColor,
  }) {
    return Container(
      padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
      decoration: BoxDecoration(
        color: bgColor.withAlpha(242),
        border: Border(bottom: BorderSide(color: borderColor)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
        child: Row(
          children: [
            IconButton(
              onPressed: () => Navigator.of(context).pop(),
              icon: Icon(LucideIcons.arrowLeft, color: textColor),
            ),
            const Expanded(
              child: Text(
                'Coupons & Offers',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  letterSpacing: -0.3,
                ),
              ),
            ),
            IconButton(
              onPressed: () {
                // Show info dialog
              },
              icon: Icon(LucideIcons.info, color: textColor),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabs({
    required bool isDark,
    required Color bgColor,
    required Color textColor,
    required Color subtleColor,
    required Color primaryColor,
  }) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      color: bgColor,
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF2a3344) : const Color(0xFFe7ebf3),
          borderRadius: BorderRadius.circular(12),
        ),
        child: TabBar(
          controller: _tabController,
          indicator: BoxDecoration(
            color: isDark ? const Color(0xFF3a4555) : Colors.white,
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha(13),
                blurRadius: 4,
                offset: const Offset(0, 1),
              ),
            ],
          ),
          indicatorSize: TabBarIndicatorSize.tab,
          dividerColor: Colors.transparent,
          labelColor: isDark ? Colors.white : primaryColor,
          unselectedLabelColor: subtleColor,
          labelStyle: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.3,
          ),
          unselectedLabelStyle: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.3,
          ),
          tabs: const [
            Tab(text: 'Available Coupons'),
            Tab(text: 'My Coupons'),
          ],
          onTap: (_) => setState(() {}),
        ),
      ),
    );
  }

  Widget _buildFilterChips({
    required bool isDark,
    required Color bgColor,
    required Color textColor,
    required Color borderColor,
    required Color primaryColor,
  }) {
    return Container(
      height: 52,
      color: bgColor,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        itemCount: _categories.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final category = _categories[index];
          final isSelected = _selectedCategory == category;

          return GestureDetector(
            onTap: () => setState(() => _selectedCategory = category),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                color: isSelected
                    ? primaryColor
                    : (isDark ? const Color(0xFF2a3344) : Colors.white),
                borderRadius: BorderRadius.circular(20),
                border: isSelected ? null : Border.all(color: borderColor),
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: primaryColor.withAlpha(77),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ]
                    : null,
              ),
              alignment: Alignment.center,
              child: Text(
                category,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: isSelected
                      ? Colors.white
                      : (isDark ? const Color(0xFFcbd5e1) : textColor),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildCouponsList({
    required bool isDark,
    required Color surfaceColor,
    required Color textColor,
    required Color subtleColor,
    required Color borderColor,
    required Color primaryColor,
  }) {
    final activeCoupons = _activeCoupons;
    final expiredCoupons = _expiredCoupons;

    if (activeCoupons.isEmpty && expiredCoupons.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              LucideIcons.ticket,
              size: 64,
              color: subtleColor.withAlpha(128),
            ),
            const SizedBox(height: 16),
            Text(
              'No coupons available',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: subtleColor,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Check back later for new offers',
              style: TextStyle(fontSize: 14, color: subtleColor.withAlpha(179)),
            ),
          ],
        ),
      );
    }

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Active Coupons
        ...activeCoupons.map(
          (coupon) => Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: coupon.isBankOffer
                ? _buildBankOfferCard(
                    coupon: coupon,
                    isDark: isDark,
                    primaryColor: primaryColor,
                  )
                : _buildCouponCard(
                    coupon: coupon,
                    isDark: isDark,
                    surfaceColor: surfaceColor,
                    textColor: textColor,
                    subtleColor: subtleColor,
                    borderColor: borderColor,
                    primaryColor: primaryColor,
                  ),
          ),
        ),

        // Expired Section
        if (expiredCoupons.isNotEmpty) ...[
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    height: 1,
                    color: isDark
                        ? const Color(0xFF3a4555)
                        : const Color(0xFFe0e0e0),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Text(
                    'PAST OFFERS',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: subtleColor.withAlpha(153),
                      letterSpacing: 1.5,
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    height: 1,
                    color: isDark
                        ? const Color(0xFF3a4555)
                        : const Color(0xFFe0e0e0),
                  ),
                ),
              ],
            ),
          ),
          ...expiredCoupons.map(
            (coupon) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _buildExpiredCouponCard(
                coupon: coupon,
                isDark: isDark,
                subtleColor: subtleColor,
                borderColor: borderColor,
              ),
            ),
          ),
        ],

        const SizedBox(height: 80),
      ],
    );
  }

  Widget _buildCouponCard({
    required Coupon coupon,
    required bool isDark,
    required Color surfaceColor,
    required Color textColor,
    required Color subtleColor,
    required Color borderColor,
    required Color primaryColor,
  }) {
    final isExpanded = _expandedCards[coupon.id] ?? false;
    final categoryColors = _getCategoryColors(coupon.category, isDark);

    return Container(
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(10),
            blurRadius: 12,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          // Decorative circle
          Positioned(
            right: -24,
            top: -24,
            child: Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: categoryColors['bg']!.withAlpha(128),
              ),
            ),
          ),
          // Content
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top Section: Logo & Offer
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Logo/Icon
                    Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        color: categoryColors['bg'],
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: categoryColors['border']!),
                      ),
                      child: coupon.imageUrl != null
                          ? ClipRoundedRect(
                              borderRadius: BorderRadius.circular(11),
                              child: Image.network(
                                coupon.imageUrl!,
                                width: 40,
                                height: 40,
                                fit: BoxFit.contain,
                                errorBuilder: (_, __, ___) => Icon(
                                  coupon.icon ?? LucideIcons.tag,
                                  color: categoryColors['icon'],
                                  size: 28,
                                ),
                              ),
                            )
                          : Icon(
                              coupon.icon ?? LucideIcons.tag,
                              color: categoryColors['icon'],
                              size: 28,
                            ),
                    ),
                    const SizedBox(width: 16),
                    // Info
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: categoryColors['bg'],
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  coupon.category,
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: categoryColors['text'],
                                  ),
                                ),
                              ),
                              Text(
                                'Exp: ${coupon.expiryDate}',
                                style: TextStyle(
                                  fontSize: 10,
                                  color: subtleColor.withAlpha(153),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            coupon.title,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                              color: textColor,
                              letterSpacing: -0.3,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            coupon.description,
                            style: TextStyle(fontSize: 14, color: subtleColor),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // Middle Section: Code & Action
                Row(
                  children: [
                    // Code box
                    Expanded(
                      child: Container(
                        height: 40,
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                          color: isDark
                              ? const Color(0xFF2a3344).withAlpha(77)
                              : const Color(0xFFF8F9FC).withAlpha(128),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: borderColor,
                            style: BorderStyle.solid,
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              coupon.code,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'monospace',
                                color: isDark
                                    ? const Color(0xFFe2e8f0)
                                    : textColor,
                                letterSpacing: 1.5,
                              ),
                            ),
                            GestureDetector(
                              onTap: () => _copyCouponCode(coupon.code),
                              child: Row(
                                children: [
                                  Icon(
                                    LucideIcons.copy,
                                    size: 14,
                                    color: primaryColor,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    'COPY',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color: primaryColor,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    // Apply button
                    ElevatedButton(
                      onPressed: () => _applyCoupon(coupon),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryColor,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        minimumSize: const Size(0, 40),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        'Apply',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),

                // Terms & Conditions Accordion
                if (coupon.terms.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  Container(
                    decoration: BoxDecoration(
                      border: Border(top: BorderSide(color: borderColor)),
                    ),
                    padding: const EdgeInsets.only(top: 12),
                    child: Column(
                      children: [
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              _expandedCards[coupon.id] = !isExpanded;
                            });
                          },
                          child: Row(
                            children: [
                              Text(
                                'Terms & Conditions',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  color: subtleColor,
                                ),
                              ),
                              const SizedBox(width: 4),
                              AnimatedRotation(
                                turns: isExpanded ? 0.5 : 0,
                                duration: const Duration(milliseconds: 200),
                                child: Icon(
                                  LucideIcons.chevronDown,
                                  size: 16,
                                  color: subtleColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                        AnimatedCrossFade(
                          firstChild: const SizedBox.shrink(),
                          secondChild: Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: coupon.terms
                                  .map(
                                    (term) => Padding(
                                      padding: const EdgeInsets.only(bottom: 4),
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            '• ',
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: subtleColor.withAlpha(153),
                                            ),
                                          ),
                                          Expanded(
                                            child: Text(
                                              term,
                                              style: TextStyle(
                                                fontSize: 12,
                                                color: subtleColor.withAlpha(
                                                  153,
                                                ),
                                                height: 1.4,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
                                  .toList(),
                            ),
                          ),
                          crossFadeState: isExpanded
                              ? CrossFadeState.showSecond
                              : CrossFadeState.showFirst,
                          duration: const Duration(milliseconds: 200),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBankOfferCard({
    required Coupon coupon,
    required bool isDark,
    required Color primaryColor,
  }) {
    final isExpanded = _expandedCards[coupon.id] ?? false;

    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF101622), Color(0xFF2d3b55)],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(51),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          // Background decoration
          Positioned(
            right: 16,
            top: 0,
            child: Opacity(
              opacity: 0.1,
              child: Icon(
                LucideIcons.creditCard,
                size: 120,
                color: Colors.white,
              ),
            ),
          ),
          // Content
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top Section
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Icon
                    Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        color: Colors.white.withAlpha(26),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.white.withAlpha(51)),
                      ),
                      child: const Icon(
                        LucideIcons.landmark,
                        color: Colors.white,
                        size: 28,
                      ),
                    ),
                    const SizedBox(width: 16),
                    // Info
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white.withAlpha(51),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: const Text(
                                  'Bank Offer',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              Text(
                                'Exp: ${coupon.expiryDate}',
                                style: TextStyle(
                                  fontSize: 10,
                                  color: Colors.white.withAlpha(179),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            coupon.title,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                              letterSpacing: -0.3,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            coupon.description,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.white.withAlpha(204),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // Code & Action
                Row(
                  children: [
                    // Code box
                    Expanded(
                      child: Container(
                        height: 40,
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                          color: Colors.white.withAlpha(13),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: Colors.white.withAlpha(77),
                            style: BorderStyle.solid,
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              coupon.code,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'monospace',
                                color: Colors.white,
                                letterSpacing: 1.5,
                              ),
                            ),
                            GestureDetector(
                              onTap: () => _copyCouponCode(coupon.code),
                              child: const Row(
                                children: [
                                  Icon(
                                    LucideIcons.copy,
                                    size: 14,
                                    color: Colors.white,
                                  ),
                                  SizedBox(width: 4),
                                  Text(
                                    'COPY',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    // Apply button
                    ElevatedButton(
                      onPressed: () => _applyCoupon(coupon),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: primaryColor,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        minimumSize: const Size(0, 40),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        'Apply',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),

                // Terms
                if (coupon.terms.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _expandedCards[coupon.id] = !isExpanded;
                      });
                    },
                    child: Row(
                      children: [
                        Text(
                          'Terms & Conditions',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: Colors.white.withAlpha(179),
                          ),
                        ),
                        const SizedBox(width: 4),
                        AnimatedRotation(
                          turns: isExpanded ? 0.5 : 0,
                          duration: const Duration(milliseconds: 200),
                          child: Icon(
                            LucideIcons.chevronDown,
                            size: 16,
                            color: Colors.white.withAlpha(179),
                          ),
                        ),
                      ],
                    ),
                  ),
                  AnimatedCrossFade(
                    firstChild: const SizedBox.shrink(),
                    secondChild: Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: coupon.terms
                            .map(
                              (term) => Padding(
                                padding: const EdgeInsets.only(bottom: 4),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '• ',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.white.withAlpha(153),
                                      ),
                                    ),
                                    Expanded(
                                      child: Text(
                                        term,
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.white.withAlpha(153),
                                          height: 1.4,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )
                            .toList(),
                      ),
                    ),
                    crossFadeState: isExpanded
                        ? CrossFadeState.showSecond
                        : CrossFadeState.showFirst,
                    duration: const Duration(milliseconds: 200),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExpiredCouponCard({
    required Coupon coupon,
    required bool isDark,
    required Color subtleColor,
    required Color borderColor,
  }) {
    return Opacity(
      opacity: 0.7,
      child: ColorFiltered(
        colorFilter: const ColorFilter.mode(Colors.grey, BlendMode.saturation),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isDark
                ? const Color(0xFF2a3344).withAlpha(102)
                : const Color(0xFFF5F5F5),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: borderColor),
          ),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: isDark
                      ? const Color(0xFF3a4555)
                      : const Color(0xFFE0E0E0),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  coupon.icon ?? LucideIcons.shoppingBag,
                  color: subtleColor,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      coupon.title,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: subtleColor,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      coupon.description,
                      style: TextStyle(
                        fontSize: 12,
                        color: subtleColor.withAlpha(153),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: isDark
                      ? const Color(0xFF3a4555)
                      : const Color(0xFFE0E0E0),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  'EXPIRED',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: subtleColor,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Map<String, Color> _getCategoryColors(String category, bool isDark) {
    switch (category) {
      case 'Fashion':
        return {
          'bg': isDark
              ? const Color(0xFF3B82F6).withAlpha(51)
              : const Color(0xFFEFF6FF),
          'border': isDark
              ? const Color(0xFF3B82F6).withAlpha(77)
              : const Color(0xFFDBEAFE),
          'icon': isDark ? const Color(0xFF60A5FA) : const Color(0xFF2563EB),
          'text': isDark ? const Color(0xFF93C5FD) : const Color(0xFF1D4ED8),
        };
      case 'Food':
        return {
          'bg': isDark
              ? const Color(0xFFF97316).withAlpha(51)
              : const Color(0xFFFFF7ED),
          'border': isDark
              ? const Color(0xFFF97316).withAlpha(77)
              : const Color(0xFFFED7AA),
          'icon': isDark ? const Color(0xFFFB923C) : const Color(0xFFEA580C),
          'text': isDark ? const Color(0xFFFDBA74) : const Color(0xFFC2410C),
        };
      case 'Electronics':
        return {
          'bg': isDark
              ? const Color(0xFF8B5CF6).withAlpha(51)
              : const Color(0xFFF5F3FF),
          'border': isDark
              ? const Color(0xFF8B5CF6).withAlpha(77)
              : const Color(0xFFE9D5FF),
          'icon': isDark ? const Color(0xFFA78BFA) : const Color(0xFF7C3AED),
          'text': isDark ? const Color(0xFFC4B5FD) : const Color(0xFF6D28D9),
        };
      case 'Bank Offers':
        return {
          'bg': isDark
              ? const Color(0xFF10B981).withAlpha(51)
              : const Color(0xFFECFDF5),
          'border': isDark
              ? const Color(0xFF10B981).withAlpha(77)
              : const Color(0xFFA7F3D0),
          'icon': isDark ? const Color(0xFF34D399) : const Color(0xFF059669),
          'text': isDark ? const Color(0xFF6EE7B7) : const Color(0xFF047857),
        };
      default:
        return {
          'bg': isDark
              ? const Color(0xFF6B7280).withAlpha(51)
              : const Color(0xFFF9FAFB),
          'border': isDark
              ? const Color(0xFF6B7280).withAlpha(77)
              : const Color(0xFFE5E7EB),
          'icon': isDark ? const Color(0xFF9CA3AF) : const Color(0xFF4B5563),
          'text': isDark ? const Color(0xFFD1D5DB) : const Color(0xFF374151),
        };
    }
  }
}

/// Helper widget for clipping with rounded corners
class ClipRoundedRect extends StatelessWidget {
  final BorderRadius borderRadius;
  final Widget child;

  const ClipRoundedRect({
    super.key,
    required this.borderRadius,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(borderRadius: borderRadius, child: child);
  }
}
