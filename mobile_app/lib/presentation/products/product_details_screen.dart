import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:lucide_icons/lucide_icons.dart';
import 'package:toastification/toastification.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/app_haptics.dart';
import '../../core/utils/price_formatter.dart';
import '../../core/config/app_config.dart';
import '../../features/product/presentation/providers/product_provider.dart';
import '../../features/cart/presentation/providers/cart_provider.dart';
import '../../services/share_service.dart';
import '../common/widgets/product/image_carousel.dart';
import '../common/widgets/product/color_selector.dart';
import '../common/widgets/product/size_selector.dart';
import '../common/widgets/product/offer_card.dart';
import '../common/widgets/product/quantity_selector.dart';
import '../common/widgets/animated_heart_button.dart';
import '../common/widgets/price_text.dart';

class ProductDetailsScreen extends ConsumerStatefulWidget {
  final String id;

  const ProductDetailsScreen({super.key, required this.id});

  @override
  ConsumerState<ProductDetailsScreen> createState() =>
      _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends ConsumerState<ProductDetailsScreen> {
  int _quantity = 1;
  bool _isWishlisted = false;
  String _selectedColorId = 'blue';
  String _selectedSizeId = '9';
  int _selectedTabIndex = 0;
  final TextEditingController _pincodeController = TextEditingController();

  // Demo data for colors and sizes
  final List<ColorSelectorItem> _colors = const [
    ColorSelectorItem(
      id: 'blue',
      name: 'Obsidian Blue',
      color: Color(0xFF1E3A8A),
    ),
    ColorSelectorItem(id: 'black', name: 'Black', color: Colors.black),
    ColorSelectorItem(id: 'grey', name: 'Light Grey', color: Color(0xFFE2E8F0)),
  ];

  final List<SizeSelectorItem> _sizes = const [
    SizeSelectorItem(id: '7', label: '7', inStock: false),
    SizeSelectorItem(id: '8', label: '8'),
    SizeSelectorItem(id: '9', label: '9', stockCount: 2),
    SizeSelectorItem(id: '10', label: '10'),
    SizeSelectorItem(id: '11', label: '11'),
  ];

  @override
  void dispose() {
    _pincodeController.dispose();
    super.dispose();
  }

  void _shareProduct() async {
    // Get product details from the provider
    final productAsync = ref.read(productDetailsProvider(widget.id));
    productAsync.whenData((product) {
      if (product == null) return;
      ShareService.instance.shareProduct(
        productId: product.id,
        productName: product.name,
        productImage: product.featuredImage,
        price: product.price,
        description: product.description,
      );
    });
  }

  void _showSizeGuide(BuildContext context, bool isDark, Color textColor) {
    final subtleColor = isDark ? Colors.grey[400] : Colors.grey[600];
    final borderColor = isDark ? Colors.grey[800]! : Colors.grey[200]!;
    final cardColor = isDark ? AppColors.darkCard : Colors.white;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: cardColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.6,
        maxChildSize: 0.9,
        minChildSize: 0.4,
        expand: false,
        builder: (context, scrollController) => SingleChildScrollView(
          controller: scrollController,
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Handle bar
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey[400],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Title
              Text(
                'Size Guide',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Use this chart to find your perfect size',
                style: TextStyle(fontSize: 14, color: subtleColor),
              ),
              const SizedBox(height: 24),

              // Size Chart Table
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: borderColor),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    // Header
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: isDark ? Colors.grey[800] : Colors.grey[100],
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(11),
                        ),
                      ),
                      child: Row(
                        children: [
                          _buildSizeColumn('US', textColor, flex: 1),
                          _buildSizeColumn('UK', textColor, flex: 1),
                          _buildSizeColumn('EU', textColor, flex: 1),
                          _buildSizeColumn('CM', textColor, flex: 1),
                        ],
                      ),
                    ),
                    // Size rows
                    ...const [
                      ['7', '6', '40', '25'],
                      ['8', '7', '41', '26'],
                      ['9', '8', '42', '27'],
                      ['10', '9', '43', '28'],
                      ['11', '10', '44', '29'],
                      ['12', '11', '45', '30'],
                    ].asMap().entries.map((entry) {
                      final index = entry.key;
                      final row = entry.value;
                      return Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: index % 2 == 0
                              ? Colors.transparent
                              : (isDark ? Colors.grey[850] : Colors.grey[50]),
                          border: Border(top: BorderSide(color: borderColor)),
                        ),
                        child: Row(
                          children: [
                            _buildSizeColumn(
                              row[0],
                              textColor,
                              flex: 1,
                              isHeader: false,
                            ),
                            _buildSizeColumn(
                              row[1],
                              textColor,
                              flex: 1,
                              isHeader: false,
                            ),
                            _buildSizeColumn(
                              row[2],
                              textColor,
                              flex: 1,
                              isHeader: false,
                            ),
                            _buildSizeColumn(
                              row[3],
                              textColor,
                              flex: 1,
                              isHeader: false,
                            ),
                          ],
                        ),
                      );
                    }),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Measurement Tips
              Text(
                'How to Measure',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: textColor,
                ),
              ),
              const SizedBox(height: 12),
              ...[
                '1. Place your foot on a piece of paper',
                '2. Mark the heel and longest toe',
                '3. Measure the distance in cm',
                '4. Compare with the size chart above',
              ].map(
                (tip) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        LucideIcons.check,
                        size: 16,
                        color: AppColors.success,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(tip, style: TextStyle(color: subtleColor)),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Close button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isDark ? Colors.white : Colors.black,
                    foregroundColor: isDark ? Colors.black : Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Got it!',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Categories that need size/color selectors
  bool _categoryNeedsVariants(String? categoryId) {
    if (categoryId == null) return false;

    final variantCategories = [
      'clothing',
      'clothes',
      'shoes',
      'footwear',
      'fashion',
      'apparel',
      'sneakers',
      'activewear',
      'sportswear',
      't-shirts',
      'shirts',
      'pants',
      'dresses',
      'jackets',
    ];

    final lowerCategory = categoryId.toLowerCase();
    return variantCategories.any((cat) => lowerCategory.contains(cat));
  }

  /// Quantity-only section for products without variants
  Widget _buildQuantityOnlySection(bool isDark, Color textColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Text(
            'Quantity',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: textColor,
            ),
          ),
          const SizedBox(width: 16),
          QuantitySelector(
            value: _quantity,
            min: 1,
            max: 10,
            onChanged: (value) => setState(() => _quantity = value),
          ),
        ],
      ),
    ).animate().fadeIn(delay: 300.ms);
  }

  Widget _buildSizeColumn(
    String text,
    Color textColor, {
    int flex = 1,
    bool isHeader = true,
  }) {
    return Expanded(
      flex: flex,
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontWeight: isHeader ? FontWeight.w600 : FontWeight.normal,
          color: textColor,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final productAsync = ref.watch(productDetailsProvider(widget.id));
    final priceFormatter = ref.watch(priceFormatterProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? AppColors.darkBackground : Colors.white;
    final cardColor = isDark ? AppColors.darkCard : Colors.white;
    final textColor = isDark ? Colors.white : AppColors.textPrimary;

    return Scaffold(
      backgroundColor: bgColor,
      body: productAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
        data: (product) {
          if (product == null) {
            return const Center(child: Text('Product not found'));
          }
          final discount =
              product.compareAtPrice != null &&
                  product.compareAtPrice! > product.price
              ? ((product.compareAtPrice! - product.price) /
                        product.compareAtPrice! *
                        100)
                    .round()
              : 0;

          final images = product.images.isNotEmpty
              ? product.images
              : (product.featuredImage != null
                    ? [product.featuredImage!]
                    : <String>[]);

          return Stack(
            children: [
              // Main Scrollable Content
              CustomScrollView(
                slivers: [
                  // Hero Image Section
                  SliverToBoxAdapter(
                    child: ImageCarousel(
                      images: images,
                      discountPercentage: discount > 0 ? discount : null,
                    ),
                  ),

                  // Product Info Section
                  SliverToBoxAdapter(
                    child: _buildProductInfo(
                      context,
                      product.name,
                      product.price,
                      product.compareAtPrice,
                      discount,
                      product.categoryId,
                      isDark,
                      textColor,
                      priceFormatter,
                    ),
                  ),

                  // Divider
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Divider(
                        color: isDark ? Colors.grey[800] : Colors.grey[200],
                        height: 32,
                      ),
                    ),
                  ),

                  // Variants Section (only for applicable categories)
                  if (_categoryNeedsVariants(product.categoryId))
                    SliverToBoxAdapter(
                      child: _buildVariantsSection(isDark, textColor),
                    )
                  else
                    // Just show quantity selector for non-variant products
                    SliverToBoxAdapter(
                      child: _buildQuantityOnlySection(isDark, textColor),
                    ),

                  // Offers Section
                  SliverToBoxAdapter(
                    child: _buildOffersSection(isDark, textColor),
                  ),

                  // Delivery Section
                  SliverToBoxAdapter(
                    child: _buildDeliverySection(isDark, textColor, cardColor),
                  ),

                  // Details Tabs
                  SliverToBoxAdapter(
                    child: _buildDetailsTabs(
                      isDark,
                      textColor,
                      product.description,
                    ),
                  ),

                  // Similar Products
                  SliverToBoxAdapter(
                    child: _buildSimilarProducts(product, isDark, textColor),
                  ),

                  // Bottom Spacing for sticky footer
                  const SliverToBoxAdapter(child: SizedBox(height: 120)),
                ],
              ),

              // Floating Navigation Bar
              _buildFloatingNavBar(isDark, cardColor, textColor),

              // Sticky Footer
              _buildStickyFooter(
                product,
                isDark,
                cardColor,
                textColor,
                priceFormatter,
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildFloatingNavBar(bool isDark, Color cardColor, Color textColor) {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Back Button
              _buildFloatingButton(
                icon: LucideIcons.arrowLeft,
                onTap: () => context.pop(),
                isDark: isDark,
              ),
              // Right Actions
              Row(
                children: [
                  _buildFloatingButton(
                    icon: LucideIcons.share2,
                    onTap: () => _shareProduct(),
                    isDark: isDark,
                  ),
                  const SizedBox(width: 12),
                  // Animated heart for wishlist
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.black.withAlpha(77),
                      shape: BoxShape.circle,
                    ),
                    child: AnimatedHeartButton(
                      isWishlisted: _isWishlisted,
                      onToggle: () =>
                          setState(() => _isWishlisted = !_isWishlisted),
                      size: 20,
                      activeColor: Colors.red,
                      inactiveColor: Colors.white,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFloatingButton({
    required IconData icon,
    required VoidCallback onTap,
    required bool isDark,
    bool isActive = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: Colors.black.withAlpha(77),
          shape: BoxShape.circle,
        ),
        child: Center(
          child: Icon(
            icon,
            color: isActive ? Colors.red : Colors.white,
            size: 20,
          ),
        ),
      ),
    );
  }

  Widget _buildProductInfo(
    BuildContext context,
    String name,
    double price,
    double? compareAtPrice,
    int discount,
    String? categoryId,
    bool isDark,
    Color textColor,
    PriceFormatter priceFormatter,
  ) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Brand and Rating Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Brand Link
              GestureDetector(
                onTap: () =>
                    context.push('/products?category=${categoryId ?? ''}'),
                child: Text(
                  categoryId?.toUpperCase() ?? 'BRAND',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.accent,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
              // Rating Badge
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.amber.withAlpha(26),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.star, size: 14, color: Colors.amber),
                    const SizedBox(width: 2),
                    Text(
                      '4.8 (2.3k)',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.amber[200] : Colors.amber[800],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ).animate().fadeIn().slideX(begin: -0.05),

          const SizedBox(height: 8),

          // Product Title
          Text(
            name,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: textColor,
              height: 1.2,
            ),
          ).animate().fadeIn(delay: 100.ms).slideX(begin: -0.05),

          const SizedBox(height: 12),

          // Price Row
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                priceFormatter.format(price),
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
              ),
              if (compareAtPrice != null) ...[
                const SizedBox(width: 12),
                Padding(
                  padding: const EdgeInsets.only(bottom: 2),
                  child: Text(
                    priceFormatter.format(compareAtPrice),
                    style: TextStyle(
                      fontSize: 18,
                      color: isDark ? Colors.grey[500] : Colors.grey[400],
                      decoration: TextDecoration.lineThrough,
                    ),
                  ),
                ),
              ],
              if (discount > 0) ...[
                const SizedBox(width: 12),
                Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Text(
                    '$discount% OFF',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: AppColors.success,
                    ),
                  ),
                ),
              ],
            ],
          ).animate().fadeIn(delay: 200.ms).slideX(begin: -0.05),

          const SizedBox(height: 4),

          // EMI Info
          Text(
            'EMI starts at ৳12/month',
            style: TextStyle(
              fontSize: 12,
              color: isDark ? Colors.grey[500] : Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVariantsSection(bool isDark, Color textColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Color Selector
          ColorSelector(
            colors: _colors,
            selectedId: _selectedColorId,
            onSelected: (item) => setState(() => _selectedColorId = item.id),
          ),

          const SizedBox(height: 24),

          // Size Selector
          SizeSelector(
            sizes: _sizes,
            selectedId: _selectedSizeId,
            onSelected: (item) => setState(() => _selectedSizeId = item.id),
            onSizeGuide: () => _showSizeGuide(context, isDark, textColor),
          ),

          const SizedBox(height: 24),

          // Quantity Selector
          Row(
            children: [
              Text(
                'Quantity',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: textColor,
                ),
              ),
              const SizedBox(width: 16),
              QuantitySelector(
                value: _quantity,
                min: 1,
                max: 10,
                onChanged: (value) => setState(() => _quantity = value),
              ),
            ],
          ),
        ],
      ),
    ).animate().fadeIn(delay: 300.ms);
  }

  Widget _buildOffersSection(bool isDark, Color textColor) {
    return Padding(
      padding: const EdgeInsets.only(top: 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                Icon(LucideIcons.tag, size: 18, color: AppColors.accent),
                const SizedBox(width: 8),
                Text(
                  'Available Offers',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 12),

          // Offers Horizontal Scroll
          SizedBox(
            height: 100,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              children: const [
                OfferCard(
                  type: OfferType.bank,
                  title: '10% Instant Discount on Citi Cards',
                  code: 'CITI10',
                  subtitle: 'Bank Offer',
                ),
                SizedBox(width: 12),
                OfferCard(
                  type: OfferType.special,
                  title: 'Get Flat ৳200 Cashback',
                  code: 'CASH200',
                  subtitle: 'Special',
                ),
                SizedBox(width: 12),
                OfferCard(
                  type: OfferType.coupon,
                  title: 'Free Delivery on orders above ৳500',
                  code: 'FREESHIP',
                  subtitle: 'Shipping',
                ),
              ],
            ),
          ),
        ],
      ),
    ).animate().fadeIn(delay: 400.ms);
  }

  Widget _buildDeliverySection(bool isDark, Color textColor, Color cardColor) {
    return Container(
      margin: const EdgeInsets.only(top: 24),
      padding: const EdgeInsets.all(20),
      color: isDark ? AppColors.darkSurface.withAlpha(128) : Colors.grey[50],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Check Delivery',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: textColor,
            ),
          ),
          const SizedBox(height: 12),

          // Pincode Input Row
          Row(
            children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.darkCard : Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withAlpha(13),
                        blurRadius: 4,
                        offset: const Offset(0, 1),
                      ),
                    ],
                  ),
                  child: TextField(
                    controller: _pincodeController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      hintText: 'Enter Pincode',
                      hintStyle: TextStyle(
                        color: isDark ? Colors.grey[600] : Colors.grey[400],
                        fontSize: 14,
                      ),
                      prefixIcon: Icon(
                        LucideIcons.mapPin,
                        size: 18,
                        color: isDark ? Colors.grey[500] : Colors.grey[400],
                      ),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 12,
                      ),
                    ),
                    style: TextStyle(fontSize: 14, color: textColor),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: isDark
                      ? Colors.white
                      : AppColors.textPrimary,
                  foregroundColor: isDark
                      ? AppColors.textPrimary
                      : Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  'Check',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Delivery Info
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(LucideIcons.truck, size: 16, color: AppColors.success),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RichText(
                      text: TextSpan(
                        style: TextStyle(
                          fontSize: 12,
                          color: isDark ? Colors.grey[400] : Colors.grey[600],
                        ),
                        children: [
                          const TextSpan(text: 'Free delivery by '),
                          TextSpan(
                            text: 'Wed, 24 May',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: textColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Cash on delivery available',
                      style: TextStyle(
                        fontSize: 12,
                        color: isDark ? Colors.grey[500] : Colors.grey[400],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    ).animate().fadeIn(delay: 500.ms);
  }

  Widget _buildDetailsTabs(bool isDark, Color textColor, String? description) {
    final tabs = ['Description', 'Specs', 'Reviews'];

    return Column(
      children: [
        // Tab Bar
        Container(
          margin: const EdgeInsets.only(top: 32),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: isDark ? Colors.grey[800]! : Colors.grey[200]!,
              ),
            ),
          ),
          child: Row(
            children: List.generate(tabs.length, (index) {
              final isSelected = _selectedTabIndex == index;
              return Expanded(
                child: GestureDetector(
                  onTap: () => setState(() => _selectedTabIndex = index),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: isSelected
                              ? AppColors.accent
                              : Colors.transparent,
                          width: 2,
                        ),
                      ),
                    ),
                    child: Text(
                      tabs[index],
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: isSelected
                            ? FontWeight.w600
                            : FontWeight.w500,
                        color: isSelected
                            ? AppColors.accent
                            : (isDark ? Colors.grey[400] : Colors.grey[500]),
                      ),
                    ),
                  ),
                ),
              );
            }),
          ),
        ),

        // Tab Content
        Padding(
          padding: const EdgeInsets.all(20),
          child: _buildTabContent(isDark, textColor, description),
        ),
      ],
    ).animate().fadeIn(delay: 600.ms);
  }

  Widget _buildTabContent(bool isDark, Color textColor, String? description) {
    switch (_selectedTabIndex) {
      case 0:
        return _buildDescriptionTab(isDark, textColor, description);
      case 1:
        return _buildSpecsTab(isDark, textColor);
      case 2:
        return _buildReviewsTab(isDark, textColor);
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildDescriptionTab(
    bool isDark,
    Color textColor,
    String? description,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          description ?? 'No description available.',
          style: TextStyle(
            fontSize: 14,
            color: isDark ? Colors.grey[400] : Colors.grey[600],
            height: 1.6,
          ),
        ),
        const SizedBox(height: 16),
        // Feature bullets
        ...[
          'Made with premium quality materials',
          'Comfortable fit for all-day wear',
          'Easy to clean and maintain',
        ].map(
          (feature) => Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 6),
                  width: 4,
                  height: 4,
                  decoration: BoxDecoration(
                    color: isDark ? Colors.grey[500] : Colors.grey[400],
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    feature,
                    style: TextStyle(
                      fontSize: 12,
                      color: isDark ? Colors.grey[400] : Colors.grey[600],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSpecsTab(bool isDark, Color textColor) {
    final specs = {
      'Weight': '340g',
      'Material': 'Synthetic & Mesh',
      'Sole': 'Rubber',
      'Closure': 'Lace-up',
    };

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isDark ? Colors.grey[800]! : Colors.grey[200]!,
        ),
      ),
      child: Column(
        children: specs.entries.toList().asMap().entries.map((entry) {
          final index = entry.key;
          final spec = entry.value;
          final isEven = index % 2 == 0;

          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: isEven
                  ? (isDark
                        ? AppColors.darkSurface.withAlpha(128)
                        : Colors.grey[50])
                  : Colors.transparent,
              border: index < specs.length - 1
                  ? Border(
                      bottom: BorderSide(
                        color: isDark ? Colors.grey[800]! : Colors.grey[200]!,
                      ),
                    )
                  : null,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  spec.key,
                  style: TextStyle(
                    fontSize: 12,
                    color: isDark ? Colors.grey[400] : Colors.grey[500],
                  ),
                ),
                Text(
                  spec.value,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: textColor,
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildReviewsTab(bool isDark, Color textColor) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Column(
          children: [
            Icon(
              LucideIcons.messageSquare,
              size: 48,
              color: isDark ? Colors.grey[600] : Colors.grey[300],
            ),
            const SizedBox(height: 12),
            Text(
              'No reviews yet',
              style: TextStyle(
                fontSize: 14,
                color: isDark ? Colors.grey[500] : Colors.grey[400],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Be the first to review this product',
              style: TextStyle(
                fontSize: 12,
                color: isDark ? Colors.grey[600] : Colors.grey[350],
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () =>
                  _showWriteReviewDialog(context, isDark, textColor),
              icon: const Icon(LucideIcons.star, size: 18),
              label: const Text('Write a Review'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.accent,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showWriteReviewDialog(
    BuildContext context,
    bool isDark,
    Color textColor,
  ) {
    int selectedRating = 0;
    final titleController = TextEditingController();
    final contentController = TextEditingController();
    bool isSubmitting = false;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: isDark ? AppColors.darkCard : Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => StatefulBuilder(
        builder: (context, setSheetState) => Padding(
          padding: EdgeInsets.fromLTRB(
            20,
            20,
            20,
            MediaQuery.of(context).viewInsets.bottom + 20,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Write a Review',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: textColor,
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: Icon(LucideIcons.x, color: textColor),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Star Rating
              Text(
                'Your Rating',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: textColor,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: List.generate(5, (index) {
                  return GestureDetector(
                    onTap: () =>
                        setSheetState(() => selectedRating = index + 1),
                    child: Icon(
                      index < selectedRating
                          ? LucideIcons.star
                          : LucideIcons.star,
                      size: 32,
                      color: index < selectedRating
                          ? Colors.amber
                          : (isDark ? Colors.grey[700] : Colors.grey[300]),
                    ),
                  );
                }),
              ),
              const SizedBox(height: 20),

              // Title
              TextField(
                controller: titleController,
                style: TextStyle(color: textColor),
                decoration: InputDecoration(
                  hintText: 'Review title (optional)',
                  hintStyle: TextStyle(
                    color: isDark ? Colors.grey[500] : Colors.grey[400],
                  ),
                  filled: true,
                  fillColor: isDark ? AppColors.darkSurface : Colors.grey[100],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 12),

              // Content
              TextField(
                controller: contentController,
                style: TextStyle(color: textColor),
                maxLines: 3,
                decoration: InputDecoration(
                  hintText: 'Write your review...',
                  hintStyle: TextStyle(
                    color: isDark ? Colors.grey[500] : Colors.grey[400],
                  ),
                  filled: true,
                  fillColor: isDark ? AppColors.darkSurface : Colors.grey[100],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Submit Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: isSubmitting || selectedRating == 0
                      ? null
                      : () async {
                          setSheetState(() => isSubmitting = true);
                          await _submitReview(
                            context,
                            selectedRating,
                            titleController.text,
                            contentController.text,
                          );
                          setSheetState(() => isSubmitting = false);
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.accent,
                    foregroundColor: Colors.white,
                    disabledBackgroundColor: Colors.grey,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: isSubmitting
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Text(
                          'Submit Review',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _submitReview(
    BuildContext context,
    int rating,
    String title,
    String content,
  ) async {
    final productId = GoRouterState.of(context).pathParameters['slug'];

    try {
      await http.post(
        Uri.parse('${AppConfig.baseUrl}/api/reviews'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'productId': productId,
          'rating': rating,
          'title': title.isNotEmpty ? title : null,
          'content': content.isNotEmpty ? content : null,
        }),
      );

      if (context.mounted) {
        Navigator.pop(context);

        toastification.show(
          context: context,
          type: ToastificationType.success,
          title: const Text('Review submitted!'),
          description: const Text('Thank you for your feedback'),
          autoCloseDuration: const Duration(seconds: 3),
        );
      }
    } catch (e) {
      if (context.mounted) {
        toastification.show(
          context: context,
          type: ToastificationType.error,
          title: const Text('Failed to submit review'),
          autoCloseDuration: const Duration(seconds: 2),
        );
      }
    }
  }

  Widget _buildSimilarProducts(dynamic product, bool isDark, Color textColor) {
    // Fetch related products using the provider
    final relatedProductsAsync = ref.watch(
      relatedProductsProvider((
        productId: product.id,
        categoryId: product.categoryId,
      )),
    );

    return Container(
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.only(top: 24),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: isDark ? Colors.grey[800]! : Colors.grey[200]!,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Similar Products',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                ),
                GestureDetector(
                  onTap: () => context.push('/products'),
                  child: Text(
                    'View all',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppColors.accent,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Products Horizontal Scroll
          SizedBox(
            height: 200,
            child: relatedProductsAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stack) =>
                  const Center(child: Text('Failed to load')),
              data: (similarProducts) {
                if (similarProducts.isEmpty) {
                  return Center(
                    child: Text(
                      'No similar products found',
                      style: TextStyle(color: textColor.withAlpha(153)),
                    ),
                  );
                }
                return ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  itemCount: similarProducts.length,
                  itemBuilder: (context, index) {
                    final relatedProduct = similarProducts[index];
                    return GestureDetector(
                      onTap: () =>
                          context.push('/products/${relatedProduct.id}'),
                      child: Container(
                        width: 144,
                        margin: const EdgeInsets.only(right: 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Image
                            Stack(
                              children: [
                                Container(
                                  height: 120,
                                  decoration: BoxDecoration(
                                    color: isDark
                                        ? AppColors.darkSurface
                                        : Colors.grey[100],
                                    borderRadius: BorderRadius.circular(12),
                                    image: relatedProduct.featuredImage != null
                                        ? DecorationImage(
                                            image: NetworkImage(
                                              relatedProduct.featuredImage!,
                                            ),
                                            fit: BoxFit.cover,
                                          )
                                        : null,
                                  ),
                                  child: relatedProduct.featuredImage == null
                                      ? Center(
                                          child: Icon(
                                            LucideIcons.image,
                                            size: 32,
                                            color: isDark
                                                ? Colors.grey[600]
                                                : Colors.grey[400],
                                          ),
                                        )
                                      : null,
                                ),
                                // Wishlist Button
                                Positioned(
                                  top: 8,
                                  right: 8,
                                  child: Container(
                                    width: 28,
                                    height: 28,
                                    decoration: BoxDecoration(
                                      color: isDark
                                          ? Colors.black.withAlpha(51)
                                          : Colors.white.withAlpha(179),
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(
                                      LucideIcons.heart,
                                      size: 14,
                                      color: isDark
                                          ? Colors.white
                                          : Colors.grey[800],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            // Name
                            Text(
                              relatedProduct.name,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: textColor,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            // Category
                            Text(
                              relatedProduct.categoryId ?? 'Product',
                              style: TextStyle(
                                fontSize: 12,
                                color: isDark
                                    ? Colors.grey[500]
                                    : Colors.grey[400],
                              ),
                            ),
                            const SizedBox(height: 4),
                            // Price
                            PriceText(
                              price: relatedProduct.price,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: textColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),

          const SizedBox(height: 16),
        ],
      ),
    ).animate().fadeIn(delay: 700.ms);
  }

  Widget _buildStickyFooter(
    dynamic product,
    bool isDark,
    Color cardColor,
    Color textColor,
    PriceFormatter priceFormatter,
  ) {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        padding: EdgeInsets.fromLTRB(
          20,
          12,
          20,
          MediaQuery.of(context).padding.bottom + 12,
        ),
        decoration: BoxDecoration(
          color: cardColor,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(13),
              blurRadius: 8,
              offset: const Offset(0, -2),
            ),
          ],
          border: Border(
            top: BorderSide(
              color: isDark ? Colors.grey[800]! : Colors.grey[200]!,
            ),
          ),
        ),
        child: Row(
          children: [
            // Price Column
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Total Price',
                  style: TextStyle(
                    fontSize: 12,
                    color: isDark ? Colors.grey[400] : Colors.grey[500],
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  priceFormatter.format(product.price * _quantity),
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                ),
              ],
            ),

            const SizedBox(width: 16),

            // Action Buttons
            Expanded(
              child: Row(
                children: [
                  // Add to Cart Button
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        AppHaptics.mediumImpact();
                        for (var i = 0; i < _quantity; i++) {
                          ref.read(cartProvider.notifier).addToCart(product);
                        }
                        toastification.show(
                          context: context,
                          type: ToastificationType.success,
                          style: ToastificationStyle.minimal,
                          title: const Text('Added to cart'),
                          description: Text('$_quantity × ${product.name}'),
                          autoCloseDuration: const Duration(seconds: 2),
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                          borderRadius: BorderRadius.circular(50),
                          border: Border.all(color: AppColors.accent, width: 2),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              LucideIcons.shoppingCart,
                              size: 18,
                              color: AppColors.accent,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              'Add',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: AppColors.accent,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(width: 12),

                  // Buy Now Button
                  Expanded(
                    flex: 2,
                    child: GestureDetector(
                      onTap: () {
                        AppHaptics.heavyImpact();
                        for (var i = 0; i < _quantity; i++) {
                          ref.read(cartProvider.notifier).addToCart(product);
                        }
                        // Use context.go for shell route tab navigation
                        context.go('/cart');
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        decoration: BoxDecoration(
                          color: AppColors.accent,
                          borderRadius: BorderRadius.circular(50),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.accent.withAlpha(77),
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: const Center(
                          child: Text(
                            'Buy Now',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
