import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:share_plus/share_plus.dart';
import '../../core/theme/app_colors.dart';
import '../../core/providers/theme_provider.dart';
import '../../features/auth/presentation/providers/auth_provider.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authControllerProvider);

    if (!authState.isAuthenticated) {
      return _buildGuestView(context);
    }

    return _buildAuthenticatedView(context, ref, authState);
  }

  Widget _buildGuestView(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "Profile",
          style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(28),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppColors.primary.withOpacity(0.1),
                      AppColors.primary.withOpacity(0.05),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  LucideIcons.user,
                  size: 56,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: 28),
              const Text(
                "Welcome, Guest",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                "Sign in to access your orders, wishlist, and personalized experience",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey[600], fontSize: 15),
              ),
              const SizedBox(height: 40),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: () => context.push('/login'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 2,
                  ),
                  child: const Text(
                    "Sign In",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: OutlinedButton(
                  onPressed: () => context.push('/register'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.black87,
                    side: const BorderSide(color: Colors.black26, width: 1.5),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    "Create Account",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAuthenticatedView(
    BuildContext context,
    WidgetRef ref,
    AuthState authState,
  ) {
    final user = authState.user!;

    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: CustomScrollView(
        slivers: [
          // Custom App Bar with Profile Header
          SliverAppBar(
            expandedHeight: 200,
            pinned: true,
            backgroundColor: AppColors.primary,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppColors.primary,
                      AppColors.primary.withOpacity(0.8),
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
                child: SafeArea(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 20),
                      CircleAvatar(
                        radius: 40,
                        backgroundColor: Colors.white,
                        child: Text(
                          (user.name ?? user.email)[0].toUpperCase(),
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        user.name ?? "User",
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        user.email,
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.8),
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            actions: [
              IconButton(
                icon: const Icon(LucideIcons.edit, color: Colors.white),
                onPressed: () {
                  // Edit profile
                },
              ),
            ],
          ),

          // Menu Sections
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Account Section
                  _buildSectionTitle("Account"),
                  _buildMenuCard([
                    _MenuItem(
                      icon: LucideIcons.package,
                      title: "My Orders",
                      subtitle: "Track and manage orders",
                      onTap: () => context.push('/orders'),
                    ),
                    _MenuItem(
                      icon: LucideIcons.heart,
                      title: "Wishlist",
                      subtitle: "Your saved items",
                      onTap: () => context.push('/wishlist'),
                    ),
                    _MenuItem(
                      icon: LucideIcons.mapPin,
                      title: "Addresses",
                      subtitle: "Manage delivery addresses",
                      onTap: () {},
                    ),
                    _MenuItem(
                      icon: LucideIcons.creditCard,
                      title: "Payment Methods",
                      subtitle: "Manage payment options",
                      onTap: () {},
                    ),
                  ]),

                  const SizedBox(height: 24),

                  // Preferences Section
                  _buildSectionTitle("Preferences"),
                  _buildMenuCard([
                    _MenuItem(
                      icon: LucideIcons.bell,
                      title: "Notifications",
                      subtitle: "Push and email settings",
                      onTap: () {},
                    ),
                  ]),
                  const SizedBox(height: 8),
                  _buildThemeMenuItem(context, ref),
                  const SizedBox(height: 8),
                  _buildMenuCard([
                    _MenuItem(
                      icon: LucideIcons.globe,
                      title: "Language",
                      subtitle: "English",
                      onTap: () {},
                    ),
                    _MenuItem(
                      icon: LucideIcons.banknote,
                      title: "Currency",
                      subtitle: "BDT (৳)",
                      onTap: () {},
                    ),
                  ]),

                  const SizedBox(height: 24),

                  // Support Section
                  _buildSectionTitle("Support"),
                  _buildMenuCard([
                    _MenuItem(
                      icon: LucideIcons.helpCircle,
                      title: "Help & Support",
                      subtitle: "FAQs and contact",
                      onTap: () {},
                    ),
                    _MenuItem(
                      icon: LucideIcons.messageCircle,
                      title: "Contact Us",
                      subtitle: "Chat with support",
                      onTap: () {},
                    ),
                  ]),

                  const SizedBox(height: 24),

                  // Legal Section
                  _buildSectionTitle("Legal"),
                  _buildMenuCard([
                    _MenuItem(
                      icon: LucideIcons.shield,
                      title: "Privacy Policy",
                      onTap: () => context.push('/privacy-policy'),
                    ),
                    _MenuItem(
                      icon: LucideIcons.fileText,
                      title: "Terms & Conditions",
                      onTap: () => context.push('/terms'),
                    ),
                  ]),

                  const SizedBox(height: 24),

                  // App Section
                  _buildSectionTitle("App"),
                  _buildMenuCard([
                    _MenuItem(
                      icon: LucideIcons.star,
                      title: "Rate App",
                      subtitle: "Love the app? Rate us!",
                      onTap: () {
                        // Open app store
                      },
                    ),
                    _MenuItem(
                      icon: LucideIcons.share2,
                      title: "Share App",
                      subtitle: "Share with friends",
                      onTap: () {
                        Share.share(
                          'Check out DC Store - the best shopping app! https://dcstore.app',
                        );
                      },
                    ),
                    _MenuItem(
                      icon: LucideIcons.info,
                      title: "About",
                      subtitle: "Version 1.0.0",
                      onTap: () => context.push('/about'),
                    ),
                  ]),

                  const SizedBox(height: 24),

                  // Danger Zone
                  _buildSectionTitle("Danger Zone", isDestructive: true),
                  _buildMenuCard([
                    _MenuItem(
                      icon: LucideIcons.logOut,
                      title: "Sign Out",
                      isDestructive: true,
                      onTap: () {
                        _showLogoutDialog(context, ref);
                      },
                    ),
                    _MenuItem(
                      icon: LucideIcons.trash2,
                      title: "Delete Account",
                      subtitle: "Permanently delete your account",
                      isDestructive: true,
                      onTap: () {
                        _showDeleteAccountDialog(context);
                      },
                    ),
                  ]),

                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildThemeMenuItem(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);
    final isDark = themeMode == ThemeMode.dark;

    return Container(
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Color(0xFFF5F5F5), width: 1)),
      ),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(
            isDark ? LucideIcons.moon : LucideIcons.sun,
            color: AppColors.primary,
            size: 20,
          ),
        ),
        title: const Text(
          "Theme",
          style: TextStyle(fontWeight: FontWeight.w500, color: Colors.black87),
        ),
        subtitle: Text(
          isDark ? "Dark mode" : "Light mode",
          style: TextStyle(fontSize: 12, color: Colors.grey[500]),
        ),
        trailing: Switch(
          value: isDark,
          onChanged: (val) {
            ref
                .read(themeModeProvider.notifier)
                .setThemeMode(val ? ThemeMode.dark : ThemeMode.light);
          },
          activeColor: AppColors.primary,
        ),
        onTap: () {
          ref.read(themeModeProvider.notifier).toggleTheme();
        },
      ),
    );
  }

  Widget _buildSectionTitle(String title, {bool isDestructive = false}) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 12),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: isDestructive ? Colors.red[700] : Colors.grey[600],
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _buildMenuCard(List<_MenuItem> items) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: items.asMap().entries.map((entry) {
          final index = entry.key;
          final item = entry.value;
          final isLast = index == items.length - 1;

          return Column(
            children: [
              ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: item.isDestructive
                        ? Colors.red.withOpacity(0.1)
                        : AppColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    item.icon,
                    color: item.isDestructive ? Colors.red : AppColors.primary,
                    size: 20,
                  ),
                ),
                title: Text(
                  item.title,
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: item.isDestructive ? Colors.red : Colors.black87,
                  ),
                ),
                subtitle: item.subtitle != null
                    ? Text(
                        item.subtitle!,
                        style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                      )
                    : null,
                trailing:
                    item.trailing ??
                    Icon(
                      LucideIcons.chevronRight,
                      size: 18,
                      color: Colors.grey[400],
                    ),
                onTap: item.onTap,
              ),
              if (!isLast)
                Divider(height: 1, indent: 56, color: Colors.grey[100]),
            ],
          );
        }).toList(),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text("Sign Out"),
        content: const Text("Are you sure you want to sign out?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              ref.read(authControllerProvider.notifier).logout();
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text("Sign Out"),
          ),
        ],
      ),
    );
  }

  void _showDeleteAccountDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Row(
          children: [
            Icon(LucideIcons.alertTriangle, color: Colors.red),
            SizedBox(width: 8),
            Text("Delete Account"),
          ],
        ),
        content: const Text(
          "This action is permanent and cannot be undone. All your data will be deleted.",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              // Delete account logic
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text("Delete"),
          ),
        ],
      ),
    );
  }
}

class _MenuItem {
  final IconData icon;
  final String title;
  final String? subtitle;
  final Widget? trailing;
  final VoidCallback onTap;
  final bool isDestructive;

  _MenuItem({
    required this.icon,
    required this.title,
    this.subtitle,
    this.trailing,
    required this.onTap,
    this.isDestructive = false,
  });
}
