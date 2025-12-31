import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../features/cart/presentation/providers/cart_provider.dart';
import '../presentation/common/floating_chat_button.dart';

/// Main Shell Scaffold with Bottom Navigation
/// Used as the shell route for main app tabs
class MainScaffold extends ConsumerWidget {
  final Widget child;
  final int currentIndex;

  const MainScaffold({
    super.key,
    required this.child,
    required this.currentIndex,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // Get real cart count from provider
    final cartCount = ref.watch(cartItemCountProvider);

    return Scaffold(
      body: child,
      floatingActionButton: const FloatingChatButton(),
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
            destinations: [
              const NavigationDestination(
                icon: Icon(Icons.home_outlined),
                selectedIcon: Icon(Icons.home),
                label: 'Home',
              ),
              const NavigationDestination(
                icon: Icon(Icons.category_outlined),
                selectedIcon: Icon(Icons.category),
                label: 'Categories',
              ),
              const NavigationDestination(
                icon: Icon(Icons.search_outlined),
                selectedIcon: Icon(Icons.search),
                label: 'Search',
              ),
              NavigationDestination(
                icon: _CartIcon(count: cartCount),
                selectedIcon: _CartIcon(count: cartCount, selected: true),
                label: 'Cart',
              ),
              const NavigationDestination(
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

    if (index != currentIndex) {
      context.go(locations[index]);
    }
  }
}

/// Cart icon with real-time badge from cart provider
class _CartIcon extends StatelessWidget {
  final int count;
  final bool selected;

  const _CartIcon({required this.count, this.selected = false});

  @override
  Widget build(BuildContext context) {
    return Badge(
      isLabelVisible: count > 0,
      label: Text(
        count > 99 ? '99+' : count.toString(),
        style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
      ),
      child: Icon(
        selected ? Icons.shopping_cart : Icons.shopping_cart_outlined,
      ),
    );
  }
}
