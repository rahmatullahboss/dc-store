import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../features/cart/presentation/providers/cart_provider.dart';
import '../../features/product/presentation/providers/product_provider.dart';
import '../../features/product/domain/product_model.dart';

/// Primary/accent color for the app (orange - matches web store)
const _primaryColor = Color(0xFFF97316);

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final PageController _bannerController = PageController();
  int _currentBannerIndex = 0;
  Timer? _flashSaleTimer;
  Duration _flashSaleRemaining = const Duration(
    hours: 2,
    minutes: 14,
    seconds: 55,
  );

  @override
  void initState() {
    super.initState();
    _startFlashSaleTimer();
    _startBannerAutoScroll();
  }

  void _startFlashSaleTimer() {
    _flashSaleTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_flashSaleRemaining.inSeconds > 0) {
        setState(() {
          _flashSaleRemaining = Duration(
            seconds: _flashSaleRemaining.inSeconds - 1,
          );
        });
      }
    });
  }

  void _startBannerAutoScroll() {
    Future.delayed(const Duration(seconds: 4), () {
      if (mounted && _bannerController.hasClients) {
        final nextPage = (_currentBannerIndex + 1) % 3;
        _bannerController.animateToPage(
          nextPage,
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeOutCubic,
        );
        _startBannerAutoScroll();
      }
    });
  }

  @override
  void dispose() {
    _flashSaleTimer?.cancel();
    _bannerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = isDark
        ? const Color(0xFF101622)
        : const Color(0xFFF8F9FC);
    final surfaceColor = isDark ? const Color(0xFF1E293B) : Colors.white;

    return Scaffold(
      backgroundColor: backgroundColor,
      body: CustomScrollView(
        slivers: [
          // Sticky Header
          _buildStickyHeader(context, isDark, backgroundColor),

          // Location Bar
          SliverToBoxAdapter(child: _buildLocationBar(isDark)),

          // Main Content
          SliverToBoxAdapter(
            child: Column(
              children: [
                const SizedBox(height: 16),

                // Banner Carousel
                _buildBannerCarousel(isDark),

                const SizedBox(height: 24),

                // Categories Section
                _buildCategoriesSection(isDark),

                const SizedBox(height: 8),

                // Flash Sale Section
                _buildFlashSaleSection(isDark, surfaceColor),

                const SizedBox(height: 24),

                // Featured Products
                _buildFeaturedProductsSection(isDark, surfaceColor),

                const SizedBox(height: 24),

                // New Arrivals
                _buildNewArrivalsSection(isDark, surfaceColor),

                const SizedBox(height: 24),

                // Popular Brands
                _buildPopularBrandsSection(isDark, surfaceColor),

                const SizedBox(height: 24),

                // Recommended For You
                _buildRecommendedSection(isDark, surfaceColor),

                const SizedBox(height: 100), // Bottom padding for nav bar
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStickyHeader(
    BuildContext context,
    bool isDark,
    Color backgroundColor,
  ) {
    final cartItems = ref.watch(cartProvider);
    final cartCount = cartItems.fold<int>(
      0,
      (sum, item) => sum + item.quantity,
    );

    return SliverAppBar(
      floating: true,
      pinned: true,
      elevation: 0,
      backgroundColor: backgroundColor.withValues(alpha: 0.95),
      surfaceTintColor: Colors.transparent,
      expandedHeight: 120,
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: BoxDecoration(
            color: backgroundColor.withValues(alpha: 0.95),
            border: Border(
              bottom: BorderSide(
                color: isDark
                    ? Colors.white.withValues(alpha: 0.05)
                    : Colors.black.withValues(alpha: 0.05),
              ),
            ),
          ),
          child: SafeArea(
            child: Column(
              children: [
                // Top App Bar
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Logo
                      Row(
                        children: [
                          Container(
                            width: 32,
                            height: 32,
                            decoration: BoxDecoration(
                              color: const Color(0xFF0F172A),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Center(
                              child: Text(
                                'DC',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'DC Store',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: isDark
                                  ? Colors.white
                                  : const Color(0xFF0F172A),
                            ),
                          ),
                        ],
                      ),

                      // Icons
                      Row(
                        children: [
                          // Notification
                          Stack(
                            children: [
                              IconButton(
                                onPressed: () {},
                                icon: Icon(
                                  Icons.notifications_outlined,
                                  color: isDark
                                      ? const Color(0xFFCBD5E1)
                                      : const Color(0xFF475569),
                                ),
                              ),
                              Positioned(
                                right: 10,
                                top: 10,
                                child: Container(
                                  width: 10,
                                  height: 10,
                                  decoration: BoxDecoration(
                                    color: Colors.red,
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: backgroundColor,
                                      width: 2,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),

                          // Cart
                          Stack(
                            children: [
                              IconButton(
                                onPressed: () => context.go('/cart'),
                                icon: Icon(
                                  Icons.shopping_cart_outlined,
                                  color: isDark
                                      ? const Color(0xFFCBD5E1)
                                      : const Color(0xFF475569),
                                ),
                              ),
                              if (cartCount > 0)
                                Positioned(
                                  right: 6,
                                  top: 6,
                                  child: Container(
                                    width: 18,
                                    height: 18,
                                    decoration: BoxDecoration(
                                      color: Colors.red,
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: backgroundColor,
                                        width: 2,
                                      ),
                                    ),
                                    child: Center(
                                      child: Text(
                                        cartCount > 9 ? '9+' : '$cartCount',
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Search Bar
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Container(
                    height: 44,
                    decoration: BoxDecoration(
                      color: isDark
                          ? Colors.white.withValues(alpha: 0.05)
                          : const Color(0xFFE2E8F0).withValues(alpha: 0.5),
                      borderRadius: BorderRadius.circular(22),
                    ),
                    child: Row(
                      children: [
                        const SizedBox(width: 16),
                        Icon(
                          Icons.search,
                          color: isDark
                              ? const Color(0xFF64748B)
                              : const Color(0xFF94A3B8),
                          size: 22,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: TextField(
                            decoration: InputDecoration(
                              hintText: 'Search for Nike shoes...',
                              hintStyle: TextStyle(
                                color: isDark
                                    ? const Color(0xFF64748B)
                                    : const Color(0xFF64748B),
                                fontSize: 14,
                              ),
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.zero,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLocationBar(bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: isDark
            ? Colors.white.withValues(alpha: 0.05)
            : _primaryColor.withValues(alpha: 0.1),
      ),
      child: Row(
        children: [
          const Icon(Icons.location_on, color: _primaryColor, size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: RichText(
              overflow: TextOverflow.ellipsis,
              text: TextSpan(
                style: TextStyle(
                  fontSize: 14,
                  color: isDark
                      ? const Color(0xFFCBD5E1)
                      : const Color(0xFF334155),
                ),
                children: [
                  const TextSpan(text: 'Delivering to '),
                  TextSpan(
                    text: 'New York, 10001',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: isDark ? Colors.white : const Color(0xFF0F172A),
                    ),
                  ),
                ],
              ),
            ),
          ),
          TextButton(
            onPressed: () {},
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: const Text(
              'Change',
              style: TextStyle(
                color: _primaryColor,
                fontWeight: FontWeight.w600,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBannerCarousel(bool isDark) {
    final banners = [
      _BannerData(
        title: 'Summer Sale\nUp to 50% Off',
        subtitle: 'Limited Time',
        buttonText: 'Shop Now',
        gradient: const [Color(0x99000000), Colors.transparent],
        imageUrl:
            'https://lh3.googleusercontent.com/aida-public/AB6AXuA72VQq7bASqjgG68B86UmzX65w4v-zUmeUxqmggFnmsWHAOELXyknUgw5WTVt1UtKWjF0tElsa7w1JatGIIE7OihrvcFeTKkVmW-nVb-oeY8Wld7JfyqT5L3uwy-mgZ3Pl97D0GcYPTA1gStvncX_5KaEICYTqwu3hZoKGcDky_cZodidXvNeglA_Lad5ffGjDluZ0jscPd5t9l5MYpzlUZqTxcxv4A3ZX0-8dl3c1b0seULpO0YlwZX273tCvD0cDDAhnthYWrOo',
      ),
      _BannerData(
        title: 'Winter Fashion\nArrivals',
        subtitle: 'New Collection',
        buttonText: 'Explore',
        gradient: [_primaryColor.withValues(alpha: 0.8), Colors.transparent],
        imageUrl:
            'https://lh3.googleusercontent.com/aida-public/AB6AXuCWYQRekFXvODz4aXDV658Jx3WTA0qEtB66QcG-qE3isZjfnCXHt6W8h1WAvszLbgFOk3PaT70HMZQUYYmva1fmWH6tfvTVN3f-3h6P8Kuh_SWHAg5EzYrCdq9uj_F8Ffoqk3xMwupxK4efLE4DgvywrCi3L4oVn-iMgsSePvIOzdbqaoSHxkSZaHw8bQ53jsW2V_70ws8Ze0M3z00B05vO3Pc3rS2IoIo9i6i6RyHnfxomgm95nZ2ZsvVMaW5kIN_zYfBEmtfV3cQ',
      ),
      _BannerData(
        title: 'Electronics\nMega Sale',
        subtitle: 'Hot Deals',
        buttonText: 'View All',
        gradient: [Colors.purple.withValues(alpha: 0.8), Colors.transparent],
        imageUrl:
            'https://lh3.googleusercontent.com/aida-public/AB6AXuBO2GFvcuZ_3f0wagOXuzMCC6yUJYRHazTcvoJjgkUpeE-Wbint32mNWwq-0FpSIiGQT6081r2WYLv-r-Y69B4NF2i_Ey4MbQKSyIzHM6J2EgLIbEdvLEl7WldABPkvNzRqoH9E1CZ_IUH7tz5wZ9SF7HhWfFhQxAmjjx1pHpHX03QfbmuZVn_ydKXRpHLF7VwvfCPUM84TnPF_uWl-IVDzkUQEsRNkS2Rnivv4p3zRwXaW8cdNe5VZl4e5UyUyE4SL0EX8IicvxeY',
      ),
    ];

    return Column(
      children: [
        SizedBox(
          height: 160,
          child: PageView.builder(
            controller: _bannerController,
            onPageChanged: (index) {
              setState(() {
                _currentBannerIndex = index;
              });
            },
            itemCount: banners.length,
            itemBuilder: (context, index) {
              final banner = banners[index];
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        Image.network(
                          banner.imageUrl,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              color: _primaryColor.withValues(alpha: 0.2),
                              child: const Icon(
                                Icons.image,
                                size: 48,
                                color: _primaryColor,
                              ),
                            );
                          },
                        ),
                        Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                              colors: banner.gradient,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                banner.subtitle,
                                style: TextStyle(
                                  color: Colors.white.withValues(alpha: 0.8),
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                banner.title,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 22,
                                  fontWeight: FontWeight.w800,
                                  height: 1.2,
                                ),
                              ),
                              const SizedBox(height: 12),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 8,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(20),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withValues(
                                        alpha: 0.2,
                                      ),
                                      blurRadius: 8,
                                    ),
                                  ],
                                ),
                                child: Text(
                                  banner.buttonText,
                                  style: const TextStyle(
                                    color: _primaryColor,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
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
              );
            },
          ),
        ),
        const SizedBox(height: 12),
        // Pagination Dots
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            banners.length,
            (index) => AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              margin: const EdgeInsets.symmetric(horizontal: 3),
              width: _currentBannerIndex == index ? 6 : 6,
              height: 6,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _currentBannerIndex == index
                    ? _primaryColor
                    : (isDark
                          ? const Color(0xFF334155)
                          : const Color(0xFFCBD5E1)),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCategoriesSection(bool isDark) {
    final categories = [
      _CategoryData('Phones', Icons.smartphone),
      _CategoryData('Fashion', Icons.checkroom),
      _CategoryData('Beauty', Icons.spa),
      _CategoryData('Home', Icons.chair),
      _CategoryData('More', Icons.grid_view),
    ];

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Categories',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : const Color(0xFF0F172A),
                ),
              ),
              TextButton(
                onPressed: () {},
                child: const Text(
                  'View All',
                  style: TextStyle(
                    color: _primaryColor,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 90,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: categories.length,
            separatorBuilder: (_, __) => const SizedBox(width: 16),
            itemBuilder: (context, index) {
              final category = categories[index];
              return SizedBox(
                width: 70,
                child: Column(
                  children: [
                    Container(
                      width: 64,
                      height: 64,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isDark
                            ? const Color(0xFF1E293B)
                            : const Color(0xFFF1F5F9),
                        border: Border.all(
                          color: isDark
                              ? const Color(0xFF334155)
                              : const Color(0xFFE2E8F0),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.05),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Icon(
                        category.icon,
                        color: _primaryColor,
                        size: 28,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      category.name,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: isDark
                            ? const Color(0xFFCBD5E1)
                            : const Color(0xFF334155),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildFlashSaleSection(bool isDark, Color surfaceColor) {
    final hours = _flashSaleRemaining.inHours.toString().padLeft(2, '0');
    final minutes = (_flashSaleRemaining.inMinutes % 60).toString().padLeft(
      2,
      '0',
    );
    final seconds = (_flashSaleRemaining.inSeconds % 60).toString().padLeft(
      2,
      '0',
    );

    final flashSaleProducts = [
      _FlashSaleProduct(
        name: 'Headphones',
        price: 59,
        originalPrice: 99,
        discount: 40,
        soldPercent: 80,
        leftCount: 12,
        imageUrl:
            'https://lh3.googleusercontent.com/aida-public/AB6AXuBBlMKPBhXJOrFcVwZ1QH0GkgnsETfnR5XsiW7H5uBBNdtC8AcUprcyqnS3Zwwrm3XcArvRykaz_nnXLvDhnP--fZbc34zTqxS78rLM5hjAuECroAyCeeflDO9ESeGk5j-H5UXBx7AHiJ738jplifNk2BWqr9NfmH7WVjqk3zfNiJ9aSWNxOSNuzpVHuyxGcgO1Hd4UtnHXGZLhVhLwlHZatendQ98Fx7Wh-bjmTVWsFTGe7v46IKDtPJZEsCxl_s-dXBaVRsjyXvI',
      ),
      _FlashSaleProduct(
        name: 'Smart Watch',
        price: 149,
        originalPrice: 199,
        discount: 25,
        soldPercent: 45,
        leftCount: 45,
        imageUrl:
            'https://lh3.googleusercontent.com/aida-public/AB6AXuB4OlJXJAculxmrhCPc1eD1RNfEnevfEkT8kDs2UBwm_zTL_G5U44UJrFCa0moXdKAl4v0DqbdokXsZVLphVj7aJ7PnC1IdrU3zDJu29njq-JfS0Qb75zYY518dmelVyQvk3YnrNwR54n_erIcm2lhJakMvBXTbLHfSI4qRtk3RENyAwePwZCxlGaZotLkbc1Y5VfCgXGubyCD22ynUboIZGqrM27rseIonMbL2Scb5Wp1v_k84CF4mZpqc5qE5DprwzXrVzUejNs8',
      ),
      _FlashSaleProduct(
        name: 'Luxury Perfume',
        price: 85,
        originalPrice: 100,
        discount: 15,
        soldPercent: 60,
        leftCount: 22,
        imageUrl:
            'https://lh3.googleusercontent.com/aida-public/AB6AXuAhMYmkhBngOnymDPSW3YVscbB0Ulw5sPqFyYgkQJiR-Z6MC0hSuJFK5BtUHhUcNH0Fh7-d0v7zn8nwju1DljT4512WkxtW4aZ5WE5t_kKWp6st8r4T2wFHgZNoWBJToEvjYcgwDQStCYSPkaAWU4ELYYIYwra0dCfOtDKs_3DHLXxuB97jOjNkECfxv8PbSTjpirsrYI3kJNRjAKo2rfHMV0GndDXmiDldRxMMuwKMmQwDN8qwelIp1t6mh3_6XZH3SBnP9PxcNfM',
      ),
    ];

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isDark
              ? [
                  const Color(0xFF7F1D1D).withValues(alpha: 0.1),
                  const Color(0xFF9A3412).withValues(alpha: 0.1),
                ]
              : [const Color(0xFFFEF2F2), const Color(0xFFFFF7ED)],
        ),
        border: Border.symmetric(
          horizontal: BorderSide(
            color: isDark
                ? const Color(0xFF7F1D1D).withValues(alpha: 0.2)
                : const Color(0xFFFECACA),
          ),
        ),
      ),
      child: Column(
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Text(
                      'FLASH SALE',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        fontStyle: FontStyle.italic,
                        color: isDark
                            ? const Color(0xFFFCA5A5)
                            : const Color(0xFFDC2626),
                      ),
                    ),
                    const SizedBox(width: 12),
                    // Timer
                    Row(
                      children: [
                        _timerBox(hours),
                        _timerColon(),
                        _timerBox(minutes),
                        _timerColon(),
                        _timerBox(seconds),
                      ],
                    ),
                  ],
                ),
                TextButton(
                  onPressed: () {},
                  child: Text(
                    'See All',
                    style: TextStyle(
                      color: isDark
                          ? const Color(0xFFFCA5A5)
                          : const Color(0xFFDC2626),
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          // Products
          SizedBox(
            height: 235,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: flashSaleProducts.length,
              separatorBuilder: (_, __) => const SizedBox(width: 12),
              itemBuilder: (context, index) {
                final product = flashSaleProducts[index];
                return _buildFlashSaleCard(product, isDark, surfaceColor);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _timerBox(String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFFEF4444),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        value,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _timerColon() {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 2),
      child: Text(
        ':',
        style: TextStyle(color: Color(0xFFEF4444), fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildFlashSaleCard(
    _FlashSaleProduct product,
    bool isDark,
    Color surfaceColor,
  ) {
    return Container(
      width: 140,
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark
              ? const Color(0xFF7F1D1D).withValues(alpha: 0.3)
              : const Color(0xFFFECACA),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(12),
                ),
                child: AspectRatio(
                  aspectRatio: 1,
                  child: Image.network(
                    product.imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: Colors.grey[200],
                        child: const Icon(Icons.image, color: Colors.grey),
                      );
                    },
                  ),
                ),
              ),
              // Discount Badge
              Positioned(
                top: 8,
                left: 8,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEF4444),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    '-${product.discount}%',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
          // Info
          Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.name,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: isDark ? Colors.white : const Color(0xFF0F172A),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text(
                      '\$${product.price}',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFEF4444),
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '\$${product.originalPrice}',
                      style: TextStyle(
                        fontSize: 12,
                        color: isDark
                            ? const Color(0xFF64748B)
                            : const Color(0xFF94A3B8),
                        decoration: TextDecoration.lineThrough,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                // Progress bar
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: product.soldPercent / 100,
                    backgroundColor: isDark
                        ? const Color(0xFF334155)
                        : const Color(0xFFE2E8F0),
                    valueColor: const AlwaysStoppedAnimation<Color>(
                      Color(0xFFEF4444),
                    ),
                    minHeight: 6,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${product.leftCount} left',
                  style: TextStyle(
                    fontSize: 10,
                    color: isDark
                        ? const Color(0xFF64748B)
                        : const Color(0xFF64748B),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeaturedProductsSection(bool isDark, Color surfaceColor) {
    final productsAsync = ref.watch(productsProvider);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Featured Products',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : const Color(0xFF0F172A),
                ),
              ),
              TextButton(
                onPressed: () => context.push('/products'),
                child: const Text(
                  'View All',
                  style: TextStyle(
                    color: _primaryColor,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          productsAsync.when(
            loading: () => const SizedBox(
              height: 200,
              child: Center(child: CircularProgressIndicator()),
            ),
            error: (err, stack) => SizedBox(
              height: 200,
              child: Center(
                child: Text(
                  'Error loading products',
                  style: TextStyle(
                    color: isDark ? Colors.grey : Colors.grey[600],
                  ),
                ),
              ),
            ),
            data: (products) {
              // Take first 4 featured products or all if less than 4
              final featuredProducts = products
                  .where((p) => p.isFeatured)
                  .take(4)
                  .toList();
              final displayProducts = featuredProducts.isNotEmpty
                  ? featuredProducts
                  : products.take(4).toList();

              if (displayProducts.isEmpty) {
                return SizedBox(
                  height: 200,
                  child: Center(
                    child: Text(
                      'No products available',
                      style: TextStyle(
                        color: isDark ? Colors.grey : Colors.grey[600],
                      ),
                    ),
                  ),
                );
              }

              return GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  childAspectRatio: 0.65,
                ),
                itemCount: displayProducts.length,
                itemBuilder: (context, index) {
                  return _buildRealProductCard(
                    displayProducts[index],
                    isDark,
                    surfaceColor,
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildProductCard(
    _ProductData product,
    bool isDark,
    Color surfaceColor,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image
          Expanded(
            flex: 5,
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(16),
                  ),
                  child: SizedBox.expand(
                    child: Image.network(
                      product.imageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: isDark
                              ? const Color(0xFF1E293B)
                              : const Color(0xFFF1F5F9),
                          child: const Icon(Icons.image, color: Colors.grey),
                        );
                      },
                    ),
                  ),
                ),
                // Favorite Button
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: isDark
                          ? Colors.black.withValues(alpha: 0.5)
                          : Colors.white.withValues(alpha: 0.9),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.favorite_border,
                      size: 20,
                      color: isDark
                          ? const Color(0xFF94A3B8)
                          : const Color(0xFF94A3B8),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Info
          Expanded(
            flex: 4,
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Brand & Rating
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        product.brand,
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.5,
                          color: isDark
                              ? const Color(0xFF64748B)
                              : const Color(0xFF94A3B8),
                        ),
                      ),
                      Row(
                        children: [
                          const Icon(
                            Icons.star,
                            size: 14,
                            color: Color(0xFFFACC15),
                          ),
                          const SizedBox(width: 2),
                          Text(
                            product.rating.toString(),
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w500,
                              color: isDark
                                  ? const Color(0xFF64748B)
                                  : const Color(0xFF64748B),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  // Name
                  Text(
                    product.name,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: isDark ? Colors.white : const Color(0xFF0F172A),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const Spacer(),
                  // Price & Add to Cart
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (product.originalPrice != null)
                            Text(
                              '\$${product.originalPrice}',
                              style: TextStyle(
                                fontSize: 10,
                                color: isDark
                                    ? const Color(0xFF64748B)
                                    : const Color(0xFF94A3B8),
                                decoration: TextDecoration.lineThrough,
                              ),
                            ),
                          Text(
                            '\$${product.price}',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: isDark
                                  ? Colors.white
                                  : const Color(0xFF0F172A),
                            ),
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: _primaryColor,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(
                          Icons.add_shopping_cart,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRealProductCard(
    Product product,
    bool isDark,
    Color surfaceColor,
  ) {
    final hasDiscount =
        product.compareAtPrice != null &&
        product.compareAtPrice! > product.price;

    return GestureDetector(
      onTap: () => context.push('/products/${product.id}'),
      child: Container(
        decoration: BoxDecoration(
          color: surfaceColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image
            Expanded(
              flex: 5,
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(16),
                    ),
                    child: SizedBox.expand(
                      child: CachedNetworkImage(
                        imageUrl: product.featuredImage ?? '',
                        fit: BoxFit.cover,
                        placeholder: (context, url) => Container(
                          color: isDark
                              ? const Color(0xFF1E293B)
                              : const Color(0xFFF1F5F9),
                          child: const Center(
                            child: CircularProgressIndicator(strokeWidth: 2),
                          ),
                        ),
                        errorWidget: (context, url, error) => Container(
                          color: isDark
                              ? const Color(0xFF1E293B)
                              : const Color(0xFFF1F5F9),
                          child: const Icon(Icons.image, color: Colors.grey),
                        ),
                      ),
                    ),
                  ),
                  // Sale badge
                  if (hasDiscount)
                    Positioned(
                      top: 8,
                      left: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFEF4444),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          '-${((1 - product.price / product.compareAtPrice!) * 100).round()}%',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  // Favorite Button
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: isDark
                            ? Colors.black.withValues(alpha: 0.5)
                            : Colors.white.withValues(alpha: 0.9),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.favorite_border,
                        size: 20,
                        color: isDark
                            ? const Color(0xFF94A3B8)
                            : const Color(0xFF94A3B8),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Info
            Expanded(
              flex: 4,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Category & Rating
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            product.categoryId ?? 'General',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.5,
                              color: isDark
                                  ? const Color(0xFF64748B)
                                  : const Color(0xFF94A3B8),
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Row(
                          children: [
                            const Icon(
                              Icons.star,
                              size: 14,
                              color: Color(0xFFFACC15),
                            ),
                            const SizedBox(width: 2),
                            Text(
                              '4.5',
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w500,
                                color: isDark
                                    ? const Color(0xFF64748B)
                                    : const Color(0xFF64748B),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    // Name
                    Text(
                      product.name,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: isDark ? Colors.white : const Color(0xFF0F172A),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const Spacer(),
                    // Price & Add to Cart
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (hasDiscount)
                              Text(
                                '৳${product.compareAtPrice!.toStringAsFixed(0)}',
                                style: TextStyle(
                                  fontSize: 10,
                                  color: isDark
                                      ? const Color(0xFF64748B)
                                      : const Color(0xFF94A3B8),
                                  decoration: TextDecoration.lineThrough,
                                ),
                              ),
                            Text(
                              '৳${product.price.toStringAsFixed(0)}',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: isDark
                                    ? Colors.white
                                    : const Color(0xFF0F172A),
                              ),
                            ),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: _primaryColor,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(
                            Icons.add_shopping_cart,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNewArrivalsSection(bool isDark, Color surfaceColor) {
    final arrivals = [
      _ArrivalData(
        title: 'Sports Collection',
        description: 'Discover the latest gear for your training sessions.',
        imageUrl:
            'https://lh3.googleusercontent.com/aida-public/AB6AXuB7L7b2uxp4NRSk81T8jOEC1iWLzk4U1nBW6uujsUKxVpCvAHdMgECxUR9PHpaw4348CkXxFQbfUrTVRcTIV99gH93NleAUJIiiQ2haVyvkT7zQV8fEwoYD9oda4UAVHOfiXQwwgMBINiKyhT7xEi35JpGvKY1qynns1jm6v6NS1Nx-Tz0ybP3Ew9GV0zG3Fn9nB6HAlPeeodJcFX5CwS5TOB3CKZdPQHvf3UBxwweFfNY-9y2TO-Aw8rxny6c60ECNopysxLlcKeo',
      ),
      _ArrivalData(
        title: 'Urban Streetwear',
        description: 'Trendy styles for the modern city life.',
        imageUrl:
            'https://lh3.googleusercontent.com/aida-public/AB6AXuBVS2cj2tlCXUyuUQDPMRLcN0EUUVKc576s34Y5Kk1L-CoGIuvML96q21NBMAZiTozlWGr9W8Jb6O2rALIpAE1-fIUFClznm0gl4_Dks0hZhNO03UPNHMifSGfAShX60MkzK5nJZW8ICoJzPACCdhXeeCzPvyfXnN0Wn7Ya7f2diU9qVxWEMp2I6B1S6IoFMz7mjenuYMR8vOyolE4dl5PtKBH81FJhyiz7QfAv2-L60uac-gZcucvkhNeFlz5e6DnH-Jpb8VBVX_s',
      ),
    ];

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 24),
      decoration: BoxDecoration(
        color: surfaceColor,
        border: Border.symmetric(
          horizontal: BorderSide(
            color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9),
          ),
        ),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'New Arrivals',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : const Color(0xFF0F172A),
                  ),
                ),
                TextButton(
                  onPressed: () {},
                  child: const Text(
                    'View All',
                    style: TextStyle(
                      color: _primaryColor,
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 160,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: arrivals.length,
              separatorBuilder: (_, __) => const SizedBox(width: 16),
              itemBuilder: (context, index) {
                final arrival = arrivals[index];
                return Container(
                  width: 280,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.1),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        Image.network(
                          arrival.imageUrl,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              color: _primaryColor.withValues(alpha: 0.2),
                            );
                          },
                        ),
                        Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.transparent,
                                Colors.black.withValues(alpha: 0.8),
                              ],
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 16,
                          left: 16,
                          right: 16,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                arrival.title,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                arrival.description,
                                style: TextStyle(
                                  color: Colors.white.withValues(alpha: 0.8),
                                  fontSize: 12,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPopularBrandsSection(bool isDark, Color surfaceColor) {
    final brands = ['Nike', 'Adidas', 'Apple', 'Samsung', 'Puma'];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Popular Brands',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : const Color(0xFF0F172A),
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 70,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: brands.length,
              separatorBuilder: (_, __) => const SizedBox(width: 16),
              itemBuilder: (context, index) {
                return Container(
                  width: 70,
                  height: 70,
                  decoration: BoxDecoration(
                    color: surfaceColor,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isDark
                          ? const Color(0xFF334155)
                          : const Color(0xFFE2E8F0),
                    ),
                  ),
                  child: Center(
                    child: Text(
                      brands[index][0],
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: isDark
                            ? Colors.white.withValues(alpha: 0.7)
                            : Colors.black.withValues(alpha: 0.7),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecommendedSection(bool isDark, Color surfaceColor) {
    final products = [
      _ProductData(
        name: 'Classic Denim',
        brand: 'Levi\'s',
        price: 45,
        originalPrice: null,
        rating: 4.3,
        imageUrl:
            'https://lh3.googleusercontent.com/aida-public/AB6AXuBRRwKTLXeaeajNDP7Bhn7va81aU2Wcs1I7cW2M5Wf-4so63F4RkNK_ZZJ4cCatnVUonhWlGJCCnBe4bIcw_cwljjUEAQ9xynHMgv0fAm9FET0PCvQanAoTrJIKbppZPx848UcLjz2DYzWRs6RdQFgBbOi3TPm7V9fleV5ZhsY2j3_f5WMAsXQv7oM3eeV3VOb35HBNu9O8WebP6cm6Jwa4yjfl4S9qfv8RbtH3Mb9WIi_PpjmYGU3IR3ux71JkfymSHkbKywrndCI',
      ),
      _ProductData(
        name: 'Street Kicks',
        brand: 'Vans',
        price: 75,
        originalPrice: null,
        rating: 4.7,
        imageUrl:
            'https://lh3.googleusercontent.com/aida-public/AB6AXuCS4Q01ZtF98Uu4vmRsPU7uk8zxAD6emsLb37XdGyCVnwNcy_Wklxgx76swddsvDf0ypHSdch6EqAwoA6mGJekJZefCzj6JWZ4vlALzRPaYHYVCCqF14JZFOU2-Di2Wkn_VvLa-WE4jpxA_R0MxKqbc-UDTaT942mmlhtORubcp_rCEXrOyG9nm65DS16lTxXeVhMVGbT4BpkrHVAFBXxvnTwLhUADubgTz-zBPsmu4xvnnJEmx5asNIjYwaJ5QaQoggg8wYDrXZBg',
      ),
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Recommended For You',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : const Color(0xFF0F172A),
            ),
          ),
          const SizedBox(height: 16),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              childAspectRatio: 0.65,
            ),
            itemCount: products.length,
            itemBuilder: (context, index) {
              return _buildProductCard(products[index], isDark, surfaceColor);
            },
          ),
        ],
      ),
    );
  }
}

// Data classes
class _BannerData {
  final String title;
  final String subtitle;
  final String buttonText;
  final List<Color> gradient;
  final String imageUrl;

  _BannerData({
    required this.title,
    required this.subtitle,
    required this.buttonText,
    required this.gradient,
    required this.imageUrl,
  });
}

class _CategoryData {
  final String name;
  final IconData icon;

  _CategoryData(this.name, this.icon);
}

class _FlashSaleProduct {
  final String name;
  final int price;
  final int originalPrice;
  final int discount;
  final int soldPercent;
  final int leftCount;
  final String imageUrl;

  _FlashSaleProduct({
    required this.name,
    required this.price,
    required this.originalPrice,
    required this.discount,
    required this.soldPercent,
    required this.leftCount,
    required this.imageUrl,
  });
}

class _ProductData {
  final String name;
  final String brand;
  final int price;
  final int? originalPrice;
  final double rating;
  final String imageUrl;

  _ProductData({
    required this.name,
    required this.brand,
    required this.price,
    required this.originalPrice,
    required this.rating,
    required this.imageUrl,
  });
}

class _ArrivalData {
  final String title;
  final String description;
  final String imageUrl;

  _ArrivalData({
    required this.title,
    required this.description,
    required this.imageUrl,
  });
}
