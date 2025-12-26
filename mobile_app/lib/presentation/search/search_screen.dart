import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../core/config/white_label_config.dart';
import '../../services/storage_service.dart';
import '../../features/product/presentation/providers/product_provider.dart';
import '../../features/product/domain/product_model.dart';
import '../categories/categories_screen.dart';

/// Recent searches storage key
const _recentSearchesKey = 'recent_searches';

/// Load recent searches from storage
Future<List<String>> _loadRecentSearches() async {
  try {
    final storage = await StorageService.getInstance();
    final searches = storage.getString(_recentSearchesKey);
    if (searches != null && searches.isNotEmpty) {
      return searches.split('|||').where((s) => s.isNotEmpty).toList();
    }
  } catch (e) {
    debugPrint('Error loading recent searches: $e');
  }
  return [];
}

/// Save recent searches to storage
Future<void> _saveRecentSearches(List<String> searches) async {
  try {
    final storage = await StorageService.getInstance();
    await storage.setString(_recentSearchesKey, searches.join('|||'));
  } catch (e) {
    debugPrint('Error saving recent searches: $e');
  }
}

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  final _searchController = TextEditingController();
  final _focusNode = FocusNode();
  Timer? _debounceTimer;
  bool _showResults = false;
  List<String> _recentSearches = [];

  // Trending searches (static - could be from analytics in future)
  final List<String> _trendingSearches = [
    '#Electronics',
    '#Fashion',
    '#Beauty',
    '#HomeDecor',
    '#Sports',
  ];

  @override
  void initState() {
    super.initState();
    // Auto-focus search input
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
      _initRecentSearches();
    });

    // Listen to text changes for debounced search
    _searchController.addListener(_onSearchChanged);
  }

  Future<void> _initRecentSearches() async {
    final searches = await _loadRecentSearches();
    if (mounted) {
      setState(() => _recentSearches = searches);
    }
  }

  void _onSearchChanged() {
    // Cancel previous timer
    _debounceTimer?.cancel();

    final query = _searchController.text.trim();

    if (query.isEmpty) {
      setState(() => _showResults = false);
      ref.read(searchQueryProvider.notifier).setQuery('');
      return;
    }

    // Debounce 300ms
    _debounceTimer = Timer(const Duration(milliseconds: 300), () {
      ref.read(searchQueryProvider.notifier).setQuery(query);
      setState(() => _showResults = true);
    });
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    _searchController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _addToRecentSearches(String query) async {
    if (query.trim().isEmpty) return;

    final newList = _recentSearches.where((s) => s != query).toList();
    newList.insert(0, query);
    if (newList.length > 10) newList.removeLast();

    setState(() => _recentSearches = newList);
    await _saveRecentSearches(newList);
  }

  void _removeFromRecentSearches(int index) async {
    if (index < 0 || index >= _recentSearches.length) return;

    final newList = [..._recentSearches];
    newList.removeAt(index);

    setState(() => _recentSearches = newList);
    await _saveRecentSearches(newList);
  }

  void _clearAllRecentSearches() async {
    setState(() => _recentSearches = []);
    try {
      final storage = await StorageService.getInstance();
      await storage.remove(_recentSearchesKey);
    } catch (e) {
      debugPrint('Error clearing recent searches: $e');
    }
  }

  void _performSearch(String query) {
    if (query.trim().isNotEmpty) {
      // Add to recent searches
      _addToRecentSearches(query);
      // Navigate to products with search
      context.push('/products?search=${Uri.encodeComponent(query)}');
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final searchResults = ref.watch(searchResultsProvider);
    final isSearching = ref.watch(isSearchingProvider);
    final categories = ref.watch(categoriesProvider);

    // Theme colors
    final primaryBlue = WhiteLabelConfig.accentColor;
    final bgColor = isDark ? const Color(0xFF101622) : Colors.white;
    final surfaceColor = isDark ? const Color(0xFF1E293B) : Colors.white;
    final inputBgColor = isDark ? Colors.grey[800]! : const Color(0xFFF0F2F4);
    final textColor = isDark ? Colors.white : const Color(0xFF111318);
    final subtleTextColor = isDark
        ? Colors.grey[400]!
        : const Color(0xFF616F89);
    final borderColor = isDark ? Colors.grey[800]! : Colors.grey[100]!;
    final dividerColor = isDark
        ? const Color(0xFF0F172A)
        : const Color(0xFFF6F6F8);

    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: Column(
          children: [
            // Sticky Search Header
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: surfaceColor,
                border: Border(bottom: BorderSide(color: borderColor)),
              ),
              child: Row(
                children: [
                  // Search Input
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: inputBgColor,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: TextField(
                        controller: _searchController,
                        focusNode: _focusNode,
                        onSubmitted: _performSearch,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: textColor,
                        ),
                        decoration: InputDecoration(
                          hintText: 'Search for products...',
                          hintStyle: TextStyle(
                            color: subtleTextColor,
                            fontWeight: FontWeight.w500,
                          ),
                          prefixIcon: Icon(
                            LucideIcons.search,
                            color: subtleTextColor,
                            size: 20,
                          ),
                          suffixIcon: _searchController.text.isNotEmpty
                              ? GestureDetector(
                                  onTap: () {
                                    _searchController.clear();
                                    ref
                                        .read(searchQueryProvider.notifier)
                                        .setQuery('');
                                    setState(() => _showResults = false);
                                  },
                                  child: Icon(
                                    LucideIcons.x,
                                    color: subtleTextColor,
                                    size: 18,
                                  ),
                                )
                              : Icon(
                                  LucideIcons.mic,
                                  color: subtleTextColor,
                                  size: 20,
                                ),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 14,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Cancel Button
                  GestureDetector(
                    onTap: () => context.pop(),
                    child: Text(
                      'Cancel',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: primaryBlue,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Main Content
            Expanded(
              child: _showResults
                  ? _buildSearchResults(
                      searchResults,
                      isSearching,
                      isDark,
                      textColor,
                      subtleTextColor,
                      primaryBlue,
                    )
                  : SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Recent Searches Section
                          if (_recentSearches.isNotEmpty) ...[
                            Padding(
                              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                              child: Text(
                                'Recent Searches',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: textColor,
                                  letterSpacing: -0.3,
                                ),
                              ),
                            ),
                            ...List.generate(_recentSearches.length, (index) {
                              return _buildRecentSearchItem(
                                _recentSearches[index],
                                index,
                                isDark,
                                textColor,
                                subtleTextColor,
                                inputBgColor,
                              );
                            }),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                              child: GestureDetector(
                                onTap: _clearAllRecentSearches,
                                child: Text(
                                  'Clear All History',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: primaryBlue,
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              height: 8,
                              color: dividerColor,
                              margin: const EdgeInsets.symmetric(vertical: 16),
                            ),
                          ],

                          // Trending Now Section
                          Padding(
                            padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                            child: Row(
                              children: [
                                Icon(
                                  LucideIcons.trendingUp,
                                  size: 20,
                                  color: primaryBlue,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'Trending Now',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: textColor,
                                    letterSpacing: -0.3,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Wrap(
                              spacing: 12,
                              runSpacing: 12,
                              children: _trendingSearches.map((tag) {
                                return _buildTrendingChip(
                                  tag,
                                  isDark,
                                  textColor,
                                  borderColor,
                                  primaryBlue,
                                );
                              }).toList(),
                            ),
                          ),

                          Container(
                            height: 8,
                            color: dividerColor,
                            margin: const EdgeInsets.symmetric(vertical: 16),
                          ),

                          // Popular Categories Section
                          Padding(
                            padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                            child: Text(
                              'Popular Categories',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: textColor,
                                letterSpacing: -0.3,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: categories.when(
                              data: (cats) => GridView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2,
                                      crossAxisSpacing: 12,
                                      mainAxisSpacing: 12,
                                      childAspectRatio: 4 / 3,
                                    ),
                                itemCount: cats.take(4).length,
                                itemBuilder: (context, index) {
                                  final category = cats[index];
                                  return _buildCategoryCard(category, index);
                                },
                              ),
                              loading: () => const Center(
                                child: Padding(
                                  padding: EdgeInsets.all(32),
                                  child: CircularProgressIndicator(),
                                ),
                              ),
                              error: (e, s) => Center(
                                child: Text(
                                  'Failed to load categories',
                                  style: TextStyle(color: subtleTextColor),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 32),
                        ],
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchResults(
    AsyncValue<List<Product>> searchResults,
    bool isSearching,
    bool isDark,
    Color textColor,
    Color subtleTextColor,
    Color primaryBlue,
  ) {
    return searchResults.when(
      data: (products) {
        if (products.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  LucideIcons.searchX,
                  size: 64,
                  color: subtleTextColor.withAlpha(128),
                ),
                const SizedBox(height: 16),
                Text(
                  'No products found',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: textColor,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Try a different search term',
                  style: TextStyle(color: subtleTextColor),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: products.length,
          itemBuilder: (context, index) {
            final product = products[index];
            return _buildProductResultItem(
              product,
              isDark,
              textColor,
              subtleTextColor,
              primaryBlue,
            ).animate().fadeIn(delay: (index * 50).ms).slideX(begin: 0.05);
          },
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, s) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(LucideIcons.alertCircle, size: 48, color: Colors.red[400]),
            const SizedBox(height: 16),
            Text(
              'Search failed',
              style: TextStyle(color: textColor, fontSize: 16),
            ),
            const SizedBox(height: 8),
            TextButton(
              onPressed: () => ref.invalidate(searchResultsProvider),
              child: Text('Retry', style: TextStyle(color: primaryBlue)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProductResultItem(
    Product product,
    bool isDark,
    Color textColor,
    Color subtleTextColor,
    Color primaryBlue,
  ) {
    final imageUrl = product.featuredImage ?? '';

    return GestureDetector(
      onTap: () => context.push('/products/${product.id}'),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1E293B) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isDark ? Colors.grey[800]! : Colors.grey[200]!,
          ),
        ),
        child: Row(
          children: [
            // Product Image
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: imageUrl.isNotEmpty
                  ? CachedNetworkImage(
                      imageUrl: imageUrl,
                      width: 70,
                      height: 70,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Container(
                        color: isDark ? Colors.grey[800] : Colors.grey[200],
                      ),
                      errorWidget: (context, url, error) => Container(
                        width: 70,
                        height: 70,
                        color: isDark ? Colors.grey[800] : Colors.grey[200],
                        child: Icon(LucideIcons.image, color: subtleTextColor),
                      ),
                    )
                  : Container(
                      width: 70,
                      height: 70,
                      color: isDark ? Colors.grey[800] : Colors.grey[200],
                      child: Icon(LucideIcons.image, color: subtleTextColor),
                    ),
            ),
            const SizedBox(width: 12),
            // Product Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: textColor,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Text(
                        '\$${product.price.toStringAsFixed(2)}',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: primaryBlue,
                        ),
                      ),
                      if (product.compareAtPrice != null) ...[
                        const SizedBox(width: 8),
                        Text(
                          '\$${product.compareAtPrice!.toStringAsFixed(2)}',
                          style: TextStyle(
                            fontSize: 13,
                            color: subtleTextColor,
                            decoration: TextDecoration.lineThrough,
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
            Icon(LucideIcons.chevronRight, color: subtleTextColor, size: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentSearchItem(
    String query,
    int index,
    bool isDark,
    Color textColor,
    Color subtleTextColor,
    Color bgColor,
  ) {
    return GestureDetector(
      onTap: () {
        _searchController.text = query;
        _performSearch(query);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: bgColor,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(LucideIcons.clock, size: 20, color: subtleTextColor),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                query,
                style: TextStyle(fontSize: 16, color: textColor),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            GestureDetector(
              onTap: () => _removeFromRecentSearches(index),
              child: Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(LucideIcons.x, size: 18, color: subtleTextColor),
              ),
            ),
          ],
        ),
      ),
    ).animate().fadeIn(delay: (index * 50).ms).slideX(begin: 0.05);
  }

  Widget _buildTrendingChip(
    String tag,
    bool isDark,
    Color textColor,
    Color borderColor,
    Color primaryBlue,
  ) {
    return GestureDetector(
      onTap: () {
        final query = tag.replaceAll('#', '');
        _searchController.text = query;
        ref.read(searchQueryProvider.notifier).setQuery(query);
        setState(() => _showResults = true);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isDark ? Colors.grey[800] : Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isDark ? Colors.grey[700]! : Colors.grey[200]!,
          ),
          boxShadow: [
            if (!isDark)
              BoxShadow(
                color: Colors.black.withAlpha(8),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
          ],
        ),
        child: Text(
          tag,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: textColor,
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryCard(dynamic category, int index) {
    final name = category.name as String;
    final image = category.image as String?;

    return GestureDetector(
          onTap: () {
            context.push(
              '/category/${category.id}/products',
              extra: {'categoryName': name},
            );
          },
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withAlpha(13),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  // Image
                  if (image != null)
                    CachedNetworkImage(
                      imageUrl: image,
                      fit: BoxFit.cover,
                      placeholder: (context, url) =>
                          Container(color: Colors.grey[300]),
                      errorWidget: (context, url, error) => Container(
                        color: WhiteLabelConfig.accentColor.withAlpha(51),
                        child: Icon(
                          LucideIcons.package,
                          color: WhiteLabelConfig.accentColor,
                        ),
                      ),
                    )
                  else
                    Container(
                      color: WhiteLabelConfig.accentColor.withAlpha(51),
                      child: Icon(
                        LucideIcons.package,
                        color: WhiteLabelConfig.accentColor,
                        size: 32,
                      ),
                    ),
                  // Gradient overlay
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withAlpha(51),
                          Colors.black.withAlpha(204),
                        ],
                        stops: const [0.0, 0.5, 1.0],
                      ),
                    ),
                  ),
                  // Category name
                  Positioned(
                    bottom: 12,
                    left: 12,
                    child: Text(
                      name,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 0.3,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        )
        .animate()
        .fadeIn(delay: (index * 100).ms)
        .scale(begin: const Offset(0.95, 0.95));
  }
}
