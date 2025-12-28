import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/config/white_label_config.dart';
import '../../../services/external_launcher_service.dart';

/// Human support options bottom sheet
///
/// Shows options to contact human support via:
/// - WhatsApp
/// - Facebook Messenger
/// - Phone call
class HumanSupportSheet extends ConsumerWidget {
  const HumanSupportSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      padding: EdgeInsets.only(
        top: 20,
        left: 20,
        right: 20,
        bottom: MediaQuery.of(context).padding.bottom + 20,
      ),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle bar
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: isDark ? Colors.white24 : const Color(0xFFE2E8F0),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 20),

          // Header
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.blue.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.support_agent_rounded,
                  color: Colors.blue,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Talk to Human',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : const Color(0xFF1E293B),
                      ),
                    ),
                    Text(
                      'Connect with our support team',
                      style: TextStyle(
                        fontSize: 13,
                        color: isDark
                            ? Colors.white60
                            : const Color(0xFF64748B),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // WhatsApp option
          _buildOption(
            context: context,
            icon: Icons.chat_rounded,
            iconColor: const Color(0xFF25D366),
            bgColor: const Color(0xFF25D366).withValues(alpha: 0.1),
            title: 'WhatsApp',
            subtitle: 'Chat on WhatsApp',
            onTap: () async {
              Navigator.pop(context);
              await ExternalLauncherService.instance.launchWhatsApp();
            },
            isDark: isDark,
          ),
          const SizedBox(height: 12),

          // Messenger option
          _buildOption(
            context: context,
            icon: Icons.messenger_rounded,
            iconColor: const Color(0xFF0084FF),
            bgColor: const Color(0xFF0084FF).withValues(alpha: 0.1),
            title: 'Messenger',
            subtitle: 'Chat on Facebook',
            onTap: () async {
              Navigator.pop(context);
              await ExternalLauncherService.instance.openUrl(
                'https://m.me/${WhiteLabelConfig.facebookPageId}',
              );
            },
            isDark: isDark,
          ),
          const SizedBox(height: 12),

          // Phone option
          _buildOption(
            context: context,
            icon: Icons.phone_rounded,
            iconColor: Colors.green,
            bgColor: Colors.green.withValues(alpha: 0.1),
            title: 'Call Us',
            subtitle: WhiteLabelConfig.supportPhoneDisplay,
            onTap: () async {
              Navigator.pop(context);
              await ExternalLauncherService.instance.launchPhone();
            },
            isDark: isDark,
          ),
        ],
      ),
    );
  }

  Widget _buildOption({
    required BuildContext context,
    required IconData icon,
    required Color iconColor,
    required Color bgColor,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    required bool isDark,
  }) {
    return Material(
      color: isDark ? const Color(0xFF2A2A2A) : const Color(0xFFF8FAFC),
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: bgColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: iconColor, size: 22),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: isDark ? Colors.white : const Color(0xFF1E293B),
                      ),
                    ),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 13,
                        color: isDark
                            ? Colors.white60
                            : const Color(0xFF64748B),
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios_rounded,
                size: 16,
                color: isDark ? Colors.white38 : const Color(0xFF94A3B8),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
