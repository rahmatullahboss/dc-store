import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:package_info_plus/package_info_plus.dart';
import '../../core/config/white_label_config.dart';

/// About Screen
class AboutScreen extends StatefulWidget {
  const AboutScreen({super.key});

  @override
  State<AboutScreen> createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen> {
  String _version = '1.0.0';
  String _buildNumber = '1';

  @override
  void initState() {
    super.initState();
    _loadPackageInfo();
  }

  Future<void> _loadPackageInfo() async {
    try {
      final info = await PackageInfo.fromPlatform();
      if (mounted) {
        setState(() {
          _version = info.version;
          _buildNumber = info.buildNumber;
        });
      }
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? const Color(0xFF101622) : const Color(0xFFF9FAFB);
    final surfaceColor = isDark ? const Color(0xFF1E293B) : Colors.white;
    final textColor = isDark ? Colors.white : const Color(0xFF111827);
    final subtleColor = isDark
        ? const Color(0xFF94A3B8)
        : const Color(0xFF6B7280);
    final borderColor = isDark
        ? const Color(0xFF334155)
        : const Color(0xFFE5E7EB);

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: surfaceColor,
        elevation: 0,
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: Icon(LucideIcons.arrowLeft, color: textColor),
        ),
        title: Text(
          'About',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: textColor,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // App Logo
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: WhiteLabelConfig.accentColor.withAlpha(77),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(24),
                child: Image.asset('assets/images/logo.png', fit: BoxFit.cover),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              WhiteLabelConfig.appName,
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Version $_version (Build $_buildNumber)',
              style: TextStyle(fontSize: 14, color: subtleColor),
            ),
            const SizedBox(height: 32),

            // About Text
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: surfaceColor,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: borderColor),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Your One-Stop Shopping Destination',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: textColor,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    '${WhiteLabelConfig.appName} is your trusted e-commerce platform offering a wide range of quality products at competitive prices. We\'re committed to providing an exceptional shopping experience with fast delivery, secure payments, and outstanding customer service.',
                    style: TextStyle(
                      fontSize: 14,
                      color: subtleColor,
                      height: 1.6,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Features
            _buildFeatureCard(
              icon: LucideIcons.truck,
              title: 'Fast Delivery',
              description: 'Quick delivery across Bangladesh',
              isDark: isDark,
              surfaceColor: surfaceColor,
              textColor: textColor,
              subtleColor: subtleColor,
              borderColor: borderColor,
            ),
            const SizedBox(height: 12),
            _buildFeatureCard(
              icon: LucideIcons.shield,
              title: 'Secure Payments',
              description: 'Multiple secure payment options',
              isDark: isDark,
              surfaceColor: surfaceColor,
              textColor: textColor,
              subtleColor: subtleColor,
              borderColor: borderColor,
            ),
            const SizedBox(height: 12),
            _buildFeatureCard(
              icon: LucideIcons.refreshCw,
              title: 'Easy Returns',
              description: '7-day hassle-free return policy',
              isDark: isDark,
              surfaceColor: surfaceColor,
              textColor: textColor,
              subtleColor: subtleColor,
              borderColor: borderColor,
            ),
            const SizedBox(height: 32),

            // Footer
            Text(
              '© ${DateTime.now().year} ${WhiteLabelConfig.appName}',
              style: TextStyle(fontSize: 12, color: subtleColor),
            ),
            const SizedBox(height: 4),
            Text(
              'Made with ❤️ in Bangladesh',
              style: TextStyle(fontSize: 12, color: subtleColor),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureCard({
    required IconData icon,
    required String title,
    required String description,
    required bool isDark,
    required Color surfaceColor,
    required Color textColor,
    required Color subtleColor,
    required Color borderColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderColor),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: WhiteLabelConfig.accentColor.withAlpha(20),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: WhiteLabelConfig.accentColor, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: textColor,
                  ),
                ),
                Text(
                  description,
                  style: TextStyle(fontSize: 13, color: subtleColor),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
