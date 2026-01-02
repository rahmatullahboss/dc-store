import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:toastification/toastification.dart';
import '../../core/config/white_label_config.dart';
import '../../core/widgets/skeleton_loader.dart';
import '../../features/cart/presentation/providers/cart_provider.dart';
import '../../features/product/presentation/providers/product_provider.dart';
import '../../features/product/domain/product_model.dart';
import '../../services/voice_search_service.dart';
import '../common/widgets/price_text.dart';

/// Primary/accent color for the app (orange - matches web store)
final _primaryColor = WhiteLabelConfig.accentColor;

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

  // Voice search
  final VoiceSearchService _voiceSearchService = VoiceSearchService();
  bool _isListening = false;
  String _voiceSearchText = '';

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

  void _showVoiceSearch(BuildContext context, bool isDark) {
    showModalBottomSheet(
      context: context,
      backgroundColor: isDark ? const Color(0xFF1E293B) : Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Container(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Handle bar
                  Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: isDark ? Colors.grey[600] : Colors.grey[300],
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Title
                  Text(
                    _isListening ? 'Listening...' : 'Tap to speak',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: isDark ? Colors.white : Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Voice text result
                  if (_voiceSearchText.isNotEmpty)
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: isDark ? Colors.grey[800] : Colors.grey[100],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        _voiceSearchText,
                        style: TextStyle(
                          fontSize: 16,
                          color: isDark ? Colors.white : Colors.black87,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  const SizedBox(height: 24),

                  // Mic button
                  GestureDetector(
                    onTap: () async {
                      if (_isListening) {
                        await _voiceSearchService.stopListening();
                        setModalState(() => _isListening = false);
                        setState(() {});

                        // Navigate to search with the text
                        if (_voiceSearchText.isNotEmpty && context.mounted) {
                          Navigator.pop(context);
                          context.push(
                            '/products?search=${Uri.encodeComponent(_voiceSearchText)}',
                          );
                        }
                      } else {
                        setModalState(() {
                          _isListening = true;
                          _voiceSearchText = '';
                        });
                        setState(() {});

                        await _voiceSearchService.startListening(
                          onResult: (text) {
                            setModalState(() => _voiceSearchText = text);
                            setState(() => _voiceSearchText = text);
                          },
                          onFinalResult: (finalText) {
                            setModalState(() => _isListening = false);
                            setState(() => _isListening = false);

                            // Auto navigate after final result
                            if (finalText.isNotEmpty && context.mounted) {
                              Navigator.pop(context);
                              context.push(
                                '/products?search=${Uri.encodeComponent(finalText)}',
                              );
                            }
                          },
                        );
                      }
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: _isListening ? Colors.red : _primaryColor,
                        boxShadow: [
                          BoxShadow(
                            color: (_isListening ? Colors.red : _primaryColor)
                                .withValues(alpha: 0.3),
                            blurRadius: 20,
                            spreadRadius: 5,
                          ),
                        ],
                      ),
                      child: Icon(
                        _isListening ? Icons.stop : Icons.mic,
                        color: Colors.white,
                        size: 36,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  Text(
                    _isListening ? 'Tap to stop' : 'Search by voice',
                    style: TextStyle(
                      fontSize: 14,
                      color: isDark ? Colors.grey[400] : Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            );
          },
        );
      },
    );
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
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(productsProvider);
          await Future.delayed(const Duration(milliseconds: 500));
        },
        color: _primaryColor,
        child: CustomScrollView(
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

                  const SizedBox(height: 16),

                  // Categories Section
                  _buildCategoriesSection(isDark),

                  const SizedBox(height: 16),

                  // Flash Sale Section - Hidden for now
                  // _buildFlashSaleSection(isDark, surfaceColor),
                  // const SizedBox(height: 24),

                  // Featured Products
                  _buildFeaturedProductsSection(isDark, surfaceColor),

                  const SizedBox(height: 24),

                  // New Arrivals
                  _buildNewArrivalsSection(isDark, surfaceColor),

                  // Popular Brands - Hidden for now
                  // const SizedBox(height: 24),
                  // _buildPopularBrandsSection(isDark, surfaceColor),
                  const SizedBox(height: 24),

                  // Recommended For You
                  _buildRecommendedSection(isDark, surfaceColor),

                  const SizedBox(height: 100), // Bottom padding for nav bar
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStickyHeader(
    BuildContext context,
    bool isDark,
    Color backgroundColor,
  ) {
    final cartCount = ref.watch(cartItemCountProvider);

    return SliverAppBar(
      floating: true,
      pinned: true,
      elevation: 0,
      backgroundColor: backgroundColor,
      surfaceTintColor: Colors.transparent,
      expandedHeight: 120,
      collapsedHeight: 60,
      // Title (Logo) - visible when collapsed
      title: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.asset(
              'assets/images/logo.png',
              width: 32,
              height: 32,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) {
                // Fallback to text if image fails
                return Container(
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
                );
              },
            ),
          ),
          const SizedBox(width: 8),
          Text(
            WhiteLabelConfig.appName,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : const Color(0xFF0F172A),
            ),
          ),
        ],
      ),
      // Actions - visible when collapsed
      actions: [
        // Notification
        Stack(
          children: [
            IconButton(
              onPressed: () => context.push('/notifications'),
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
                  border: Border.all(color: backgroundColor, width: 2),
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
                    border: Border.all(color: backgroundColor, width: 2),
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
        const SizedBox(width: 8),
      ],
      // FlexibleSpace - Search bar (visible when expanded)
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: BoxDecoration(
            color: backgroundColor,
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
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                // Search Bar at bottom
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
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
                        // Search icon + text - tappable for search
                        Expanded(
                          child: GestureDetector(
                            onTap: () => context.push('/search'),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.search,
                                  color: isDark
                                      ? const Color(0xFF64748B)
                                      : const Color(0xFF94A3B8),
                                  size: 22,
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    'Search for products...',
                                    style: TextStyle(
                                      color: isDark
                                          ? const Color(0xFF64748B)
                                          : const Color(0xFF64748B),
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        // Mic button - voice search
                        GestureDetector(
                          onTap: () => _showVoiceSearch(context, isDark),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            child: Icon(
                              Icons.mic_none_outlined,
                              color: isDark
                                  ? const Color(0xFF64748B)
                                  : const Color(0xFF94A3B8),
                              size: 22,
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
      // Bottom border when collapsed
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(0),
        child: Container(
          height: 1,
          color: isDark
              ? Colors.white.withValues(alpha: 0.05)
              : Colors.black.withValues(alpha: 0.05),
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
          Icon(Icons.location_on, color: _primaryColor, size: 20),
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
                    text: 'Dhaka, Bangladesh',
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
            onPressed: () => _showLocationPicker(context),
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: Text(
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
                              child: Icon(
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
                                  style: TextStyle(
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
                onPressed: () => context.push('/categories'),
                child: Text(
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
        const SizedBox(height: 4),
        SizedBox(
          height: 90,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: categories.length,
            separatorBuilder: (context, index) => const SizedBox(width: 16),
            itemBuilder: (context, index) {
              final category = categories[index];
              return GestureDetector(
                onTap: () {
                  if (category.name == 'More') {
                    context.push('/categories');
                  } else {
                    // Navigate to products filtered by category
                    context.push(
                      '/products?category=${category.name.toLowerCase()}',
                    );
                  }
                },
                child: SizedBox(
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
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  // ignore: unused_element
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

    final productsAsync = ref.watch(productsProvider);

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
                  onPressed: () => context.push('/products?filter=flash-sale'),
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
          // Products - using real API data
          productsAsync.when(
            loading: () => SizedBox(
              height: 235,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: 3,
                separatorBuilder: (context, index) => const SizedBox(width: 12),
                itemBuilder: (context, index) => const ProductCardSkeleton(),
              ),
            ),
            error: (err, stack) => const SizedBox(
              height: 235,
              child: Center(child: Text('Unable to load flash sale products')),
            ),
            data: (products) {
              // Filter for products with discounts
              final discountedProducts = products
                  .where(
                    (p) =>
                        p.compareAtPrice != null && p.compareAtPrice! > p.price,
                  )
                  .take(6)
                  .toList();

              // If no discounted products, use first 6 regular products
              final displayProducts = discountedProducts.isNotEmpty
                  ? discountedProducts
                  : products.take(6).toList();

              if (displayProducts.isEmpty) {
                return const SizedBox(
                  height: 235,
                  child: Center(
                    child: Text('No flash sale products available'),
                  ),
                );
              }

              return SizedBox(
                height: 235,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: displayProducts.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(width: 12),
                  itemBuilder: (context, index) {
                    final product = displayProducts[index];
                    return _buildRealFlashSaleCard(
                      product,
                      isDark,
                      surfaceColor,
                    );
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildRealFlashSaleCard(
    Product product,
    bool isDark,
    Color surfaceColor,
  ) {
    final hasDiscount =
        product.compareAtPrice != null &&
        product.compareAtPrice! > product.price;
    final discount = hasDiscount
        ? ((1 - product.price / product.compareAtPrice!) * 100).round()
        : 0;
    // Simulate stock progress (random for visual variety)
    final soldPercent = 30 + (product.id.hashCode % 60);
    final leftCount = 5 + (product.id.hashCode % 50);

    return GestureDetector(
      onTap: () => context.push('/products/${product.id}'),
      child: Container(
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
                    child: CachedNetworkImage(
                      imageUrl: product.featuredImage ?? '',
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Container(
                        color: Colors.grey[200],
                        child: const Center(
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                      ),
                      errorWidget: (context, url, error) => Container(
                        color: Colors.grey[200],
                        child: const Icon(Icons.image, color: Colors.grey),
                      ),
                    ),
                  ),
                ),
                // Discount Badge
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
                        '-$discount%',
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
                      PriceText(
                        price: product.price,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFEF4444),
                        ),
                      ),
                      if (hasDiscount) ...[
                        const SizedBox(width: 4),
                        PriceText(
                          price: product.compareAtPrice!,
                          isStrikethrough: true,
                          style: TextStyle(
                            fontSize: 12,
                            color: isDark
                                ? const Color(0xFF64748B)
                                : const Color(0xFF94A3B8),
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 8),
                  // Progress bar
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: soldPercent / 100,
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
                    '$leftCount left',
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

  /// Skeleton loading grid for products
  Widget _buildProductGridSkeleton() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        childAspectRatio: 0.65,
      ),
      itemCount: 4,
      itemBuilder: (context, index) => const ProductCardSkeleton(),
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
                child: Text(
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
          // No gap - title and grid are close together
          productsAsync.when(
            loading: () => _buildProductGridSkeleton(),
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
                      )
                      .animate()
                      .fadeIn(delay: (50 * index).ms, duration: 300.ms)
                      .slideY(begin: 0.1, end: 0, delay: (50 * index).ms);
                },
              );
            },
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
                              PriceText(
                                price: product.compareAtPrice!,
                                isStrikethrough: true,
                                style: TextStyle(
                                  fontSize: 10,
                                  color: isDark
                                      ? const Color(0xFF64748B)
                                      : const Color(0xFF94A3B8),
                                ),
                              ),
                            PriceText(
                              price: product.price,
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
                        GestureDetector(
                          onTap: () {
                            // Add to cart
                            ref.read(cartProvider.notifier).addToCart(product);
                            // Show confirmation toast
                            toastification.show(
                              context: context,
                              type: ToastificationType.success,
                              style: ToastificationStyle.fillColored,
                              title: Text('${product.name} added to cart'),
                              autoCloseDuration: const Duration(seconds: 2),
                              alignment: Alignment.bottomCenter,
                            );
                          },
                          child: Container(
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
    final productsAsync = ref.watch(productsProvider);

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
                  onPressed: () => context.push('/products?filter=new'),
                  child: Text(
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
          // No gap
          productsAsync.when(
            loading: () => SizedBox(
              height: 160,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: 2,
                separatorBuilder: (context, index) => const SizedBox(width: 16),
                itemBuilder: (context, index) => Container(
                  width: 280,
                  decoration: BoxDecoration(
                    color: isDark
                        ? const Color(0xFF1E293B)
                        : const Color(0xFFF1F5F9),
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),
            ),
            error: (err, stack) => const SizedBox(
              height: 160,
              child: Center(child: Text('Unable to load new arrivals')),
            ),
            data: (products) {
              // Take the last 4 products as "new arrivals" (or reverse order for newest)
              final newProducts = products.take(4).toList();

              if (newProducts.isEmpty) {
                return const SizedBox(
                  height: 160,
                  child: Center(child: Text('No new arrivals')),
                );
              }

              return SizedBox(
                height: 160,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: newProducts.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(width: 16),
                  itemBuilder: (context, index) {
                    final product = newProducts[index];
                    return GestureDetector(
                      onTap: () => context.push('/products/${product.id}'),
                      child: Container(
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
                              CachedNetworkImage(
                                imageUrl: product.featuredImage ?? '',
                                fit: BoxFit.cover,
                                placeholder: (context, url) => Container(
                                  color: _primaryColor.withValues(alpha: 0.2),
                                ),
                                errorWidget: (context, url, error) => Container(
                                  color: _primaryColor.withValues(alpha: 0.2),
                                  child: const Icon(
                                    Icons.image,
                                    color: Colors.white54,
                                  ),
                                ),
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
                                top: 12,
                                left: 12,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: _primaryColor,
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: const Text(
                                    'NEW',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                    ),
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
                                      product.name,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 4),
                                    PriceText(
                                      price: product.price,
                                      style: TextStyle(
                                        color: Colors.white.withValues(
                                          alpha: 0.9,
                                        ),
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
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
              );
            },
          ),
        ],
      ),
    );
  }

  // ignore: unused_element
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
              separatorBuilder: (context, index) => const SizedBox(width: 16),
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
    final productsAsync = ref.watch(productsProvider);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Recommended For You',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : const Color(0xFF0F172A),
                ),
              ),
              TextButton(
                onPressed: () => context.push('/products'),
                child: Text(
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
          // No gap
          productsAsync.when(
            loading: () => _buildProductGridSkeleton(),
            error: (err, stack) => SizedBox(
              height: 200,
              child: Center(
                child: Text(
                  'Unable to load recommendations',
                  style: TextStyle(
                    color: isDark ? Colors.grey : Colors.grey[600],
                  ),
                ),
              ),
            ),
            data: (products) {
              if (products.isEmpty) {
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

              // Take products from different positions for variety
              // Skip the first few (used in featured/new) and take the next 4
              final skipCount = products.length > 8 ? 4 : 0;
              final recommendedProducts = products
                  .skip(skipCount)
                  .take(4)
                  .toList();

              // If not enough, just use what we have
              final displayProducts = recommendedProducts.isNotEmpty
                  ? recommendedProducts
                  : products.take(4).toList();

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
                      )
                      .animate()
                      .fadeIn(delay: (50 * index).ms, duration: 300.ms)
                      .slideY(begin: 0.1, end: 0, delay: (50 * index).ms);
                },
              );
            },
          ),
        ],
      ),
    );
  }

  void _showLocationPicker(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: isDark ? const Color(0xFF1E293B) : Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Delivery Location',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : const Color(0xFF0F172A),
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: Icon(
                    Icons.close,
                    color: isDark ? Colors.grey[400] : Colors.grey[600],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: _primaryColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: _primaryColor.withValues(alpha: 0.3)),
              ),
              child: Row(
                children: [
                  Icon(Icons.location_on, color: _primaryColor),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Current Location',
                          style: TextStyle(
                            fontSize: 12,
                            color: isDark ? Colors.grey[400] : Colors.grey[600],
                          ),
                        ),
                        Text(
                          'Dhaka, Bangladesh',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: isDark
                                ? Colors.white
                                : const Color(0xFF0F172A),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(Icons.check_circle, color: _primaryColor),
                ],
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.pop(context);
                context.push('/profile/addresses');
              },
              icon: const Icon(Icons.add),
              label: const Text('Manage Addresses'),
              style: ElevatedButton.styleFrom(
                backgroundColor: _primaryColor,
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 48),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}

// Data classes (only keeping used ones)
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
