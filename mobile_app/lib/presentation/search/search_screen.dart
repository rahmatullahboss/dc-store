import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:lucide_icons/lucide_icons.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _searchController = TextEditingController();
  final _focusNode = FocusNode();

  // Recent searches (mock data - in production would be persisted)
  final List<String> _recentSearches = [
    'Nike Air Max',
    'Leather Jacket',
    'Summer Dress',
  ];

  // Trending searches
  final List<String> _trendingSearches = [
    '#RunningShoes',
    '#SmartWatches',
    '#Denim',
    '#WirelessHeadphones',
    '#SummerSale',
  ];

  // Popular categories
  final List<_CategoryItem> _popularCategories = [
    _CategoryItem(
      name: 'Women',
      imageUrl:
          'https://lh3.googleusercontent.com/aida-public/AB6AXuBiVprrbLC3nngjZXbw0zho-TotMkFUa8PN9IKk8pn32nzt2Mb_s0P4WFBi8wwtLV5B2cxPImyCVZ4y5Pv1rKZXgDm53kdWIhf1qrVU8DIDe3i8Lbx8gmMhP_g9SuYwEt8qce5sQcAUOnG7Rplipp28UYI_gJndyMvbLVM1qpVOmG4ar6OnjJJS_TXhDlCx1GgjeFc87i9S_AO8gyk7K3JlRnwwhBuxgLnoFRlzftLRHoALQAGfsi71TEL1EamBcfMoXrlFfKsq6S4',
    ),
    _CategoryItem(
      name: 'Men',
      imageUrl:
          'https://lh3.googleusercontent.com/aida-public/AB6AXuCVMiJKtFXH5w-GAlLf96MDSyho4a1sIgEERV-9FlIopq_kOoNwoTKUiZdmNx6R7jiqkrGGn0JkgbVG7m3jFfFY7uoTIgr3hwnYVy8WCMvp_YUVdS0BWmJmpo1obU6Ua9iApWpDgk0wPmDcR0grbve3DPj-yZHcnMze6aSJz2QpRbtGSWpnqMkb8W4zxeo0093DOhe0Gmq_intO7dsph4Cbc7F3lOQAOJpwV0Y4YzypFxc1wZ_4inesztFVEyJUINbpecOKz55qGTA',
    ),
    _CategoryItem(
      name: 'Electronics',
      imageUrl:
          'https://lh3.googleusercontent.com/aida-public/AB6AXuCID-Lv67PXfACh0i92MpIJrUUqEoGZ6vckSty37vcIp5OCDt_PEE07XW1rTYDkqMDMICfebQdvEQHTXZe5G81qmsSYWHXg-Z7cbjLWCi5BQwa8y5Zfmnel6czrGP-57eHIwOsbk4psA9_wS8T1yNpzP_YOhKQ2sRaSRysnPheDzhrDFwzIETP4y9uvT5EOn860Jt8scjZuFACCWhGwJCj7owG6CiH4i7NJFXRFw8qw5nlKw3uXdv8tVYgJl6dcXwmKg0iFJ98P9Lo',
    ),
    _CategoryItem(
      name: 'Home',
      imageUrl:
          'https://lh3.googleusercontent.com/aida-public/AB6AXuBru7y_cCQxFE9MV3gegXHbct2qbDAV-vwlOm9o6BCf0kTBFitvXlslv9ZxoGbCZ0mSTdc59wKCdRHK2dEOhJOCBULGKPYQ1QOGlGGi4tdgfenSqEN-M_QUaxhRQeZHqBJSZg7FeTXYOEud6o_8czmmGxzou7HWcrPBGaP2UsZkMsx4ACCeRNhlubMiL9KUV93zpYwpwmWfDHQStAmcH7WUOPj4ZUDBNiifP3-R7c_2qIwfw1b-LBvSXL13G014bWib9t0KDse6p3I',
    ),
  ];

  @override
  void initState() {
    super.initState();
    // Auto-focus search input
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _removeRecentSearch(int index) {
    setState(() {
      _recentSearches.removeAt(index);
    });
  }

  void _clearAllHistory() {
    setState(() {
      _recentSearches.clear();
    });
  }

  void _performSearch(String query) {
    if (query.trim().isNotEmpty) {
      // In production, navigate to search results
      context.push('/products?search=${Uri.encodeComponent(query)}');
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Theme colors
    const primaryBlue = Color(0xFF135bec);
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
                          hintText: 'Search for shoes, brands...',
                          hintStyle: TextStyle(
                            color: subtleTextColor,
                            fontWeight: FontWeight.w500,
                          ),
                          prefixIcon: Icon(
                            LucideIcons.search,
                            color: subtleTextColor,
                            size: 20,
                          ),
                          suffixIcon: GestureDetector(
                            onTap: () {
                              // Voice search functionality
                            },
                            child: Icon(
                              LucideIcons.mic,
                              color: subtleTextColor,
                              size: 20,
                            ),
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
              child: SingleChildScrollView(
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
                          onTap: _clearAllHistory,
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
                      child: GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 12,
                              mainAxisSpacing: 12,
                              childAspectRatio: 4 / 3,
                            ),
                        itemCount: _popularCategories.length,
                        itemBuilder: (context, index) {
                          return _buildCategoryCard(
                            _popularCategories[index],
                            index,
                          );
                        },
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

  Widget _buildRecentSearchItem(
    String query,
    int index,
    bool isDark,
    Color textColor,
    Color subtleTextColor,
    Color bgColor,
  ) {
    return GestureDetector(
      onTap: () => _performSearch(query),
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
              onTap: () => _removeRecentSearch(index),
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
      onTap: () => _performSearch(tag.replaceAll('#', '')),
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

  Widget _buildCategoryCard(_CategoryItem category, int index) {
    return GestureDetector(
          onTap: () {
            // Navigate to category
            context.push(
              '/products?category=${Uri.encodeComponent(category.name)}',
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
                  CachedNetworkImage(
                    imageUrl: category.imageUrl,
                    fit: BoxFit.cover,
                    placeholder: (context, url) =>
                        Container(color: Colors.grey[300]),
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
                      category.name,
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

class _CategoryItem {
  final String name;
  final String imageUrl;

  _CategoryItem({required this.name, required this.imageUrl});
}
