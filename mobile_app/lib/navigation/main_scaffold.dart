import 'package:flutter/material.dart';

/// Main Shell Scaffold with Bottom Navigation
/// Used as the shell route for main app tabs
class MainScaffold extends StatelessWidget {
  final Widget child;
  final int currentIndex;

  const MainScaffold({
    super.key,
    required this.child,
    required this.currentIndex,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      body: child,
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: colorScheme.surface,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: SafeArea(
          child: NavigationBar(
            selectedIndex: currentIndex,
            onDestinationSelected: (index) => _onItemTapped(context, index),
            backgroundColor: Colors.transparent,
            elevation: 0,
            height: 65,
            labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
            destinations: const [
              NavigationDestination(
                icon: Icon(Icons.home_outlined),
                selectedIcon: Icon(Icons.home),
                label: 'Home',
              ),
              NavigationDestination(
                icon: Icon(Icons.category_outlined),
                selectedIcon: Icon(Icons.category),
                label: 'Categories',
              ),
              NavigationDestination(
                icon: Icon(Icons.search_outlined),
                selectedIcon: Icon(Icons.search),
                label: 'Search',
              ),
              NavigationDestination(
                icon: _CartIcon(),
                selectedIcon: _CartIcon(selected: true),
                label: 'Cart',
              ),
              NavigationDestination(
                icon: Icon(Icons.person_outline),
                selectedIcon: Icon(Icons.person),
                label: 'Profile',
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _onItemTapped(BuildContext context, int index) {
    final locations = ['/home', '/categories', '/search', '/cart', '/profile'];

    // Use go to switch tabs (replaces current location)
    // This ensures proper tab switching behavior
    if (index != currentIndex) {
      // Import go_router and use context.go
      // For now, we'll use Navigator as fallback
      Navigator.of(
        context,
      ).pushNamedAndRemoveUntil(locations[index], (route) => false);
    }
  }
}

/// Cart icon with badge
class _CartIcon extends StatelessWidget {
  final bool selected;

  const _CartIcon({this.selected = false});

  @override
  Widget build(BuildContext context) {
    // TODO: Get actual cart count from CartCubit
    const cartCount = 0;

    return Badge(
      isLabelVisible: cartCount > 0,
      label: Text(
        cartCount.toString(),
        style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
      ),
      child: Icon(
        selected ? Icons.shopping_cart : Icons.shopping_cart_outlined,
      ),
    );
  }
}
