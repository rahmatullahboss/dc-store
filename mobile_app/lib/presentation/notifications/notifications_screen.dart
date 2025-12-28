import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../core/config/white_label_config.dart';

/// Notification model
class NotificationItem {
  final String id;
  final String title;
  final String message;
  final String time;
  final NotificationType type;
  final bool isRead;

  const NotificationItem({
    required this.id,
    required this.title,
    required this.message,
    required this.time,
    required this.type,
    this.isRead = false,
  });
}

enum NotificationType {
  orderShipped,
  priceDrop,
  flashSale,
  review,
  backInStock,
  system,
}

/// Redesigned Notifications Screen
/// Features: Grouped by time, color-coded icons, unread indicators,
/// mark all read action, and full dark mode support
class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  // Real notifications would come from an API - empty for now
  final Map<String, List<NotificationItem>> _notifications = {};

  void _markAllAsRead() {
    setState(() {
      for (var group in _notifications.values) {
        for (var i = 0; i < group.length; i++) {
          group[i] = NotificationItem(
            id: group[i].id,
            title: group[i].title,
            message: group[i].message,
            time: group[i].time,
            type: group[i].type,
            isRead: true,
          );
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Theme colors
    final bgColor = isDark ? const Color(0xFF101622) : const Color(0xFFF6F6F8);
    final surfaceColor = isDark ? const Color(0xFF1a2230) : Colors.white;
    final textColor = isDark ? Colors.white : const Color(0xFF0f172a);
    final subtleColor = isDark
        ? const Color(0xFF94a3b8)
        : const Color(0xFF64748b);
    final borderColor = isDark
        ? Colors.white.withAlpha(13)
        : const Color(0xFFf1f5f9);
    final primaryColor = WhiteLabelConfig.accentColor;

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: bgColor,
        elevation: 0,
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: Icon(LucideIcons.arrowLeft, color: textColor),
        ),
        title: Text(
          'Notifications',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: textColor,
          ),
        ),
        actions: [
          if (_notifications.isNotEmpty)
            TextButton(
              onPressed: _markAllAsRead,
              child: Text(
                'Mark all read',
                style: TextStyle(
                  color: primaryColor,
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
            ),
        ],
      ),
      body: _notifications.isEmpty
          ? _buildEmptyState(isDark, textColor, subtleColor, primaryColor)
          : CustomScrollView(
              slivers: [
                // Content
                SliverPadding(
                  padding: const EdgeInsets.all(16),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate((context, index) {
                      final entries = _notifications.entries.toList();
                      if (index >= entries.length) return null;

                      final group = entries[index];
                      return _buildNotificationGroup(
                        context,
                        title: group.key,
                        notifications: group.value,
                        isDark: isDark,
                        surfaceColor: surfaceColor,
                        textColor: textColor,
                        subtleColor: subtleColor,
                        borderColor: borderColor,
                        primaryColor: primaryColor,
                      );
                    }, childCount: _notifications.length),
                  ),
                ),

                const SliverToBoxAdapter(child: SizedBox(height: 40)),
              ],
            ),
    );
  }

  Widget _buildEmptyState(
    bool isDark,
    Color textColor,
    Color subtleColor,
    Color primaryColor,
  ) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: primaryColor.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(LucideIcons.bellOff, size: 40, color: primaryColor),
            ),
            const SizedBox(height: 24),
            Text(
              'No Notifications',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'You\'re all caught up! Check back later for updates on your orders and promotions.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: subtleColor, height: 1.5),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationGroup(
    BuildContext context, {
    required String title,
    required List<NotificationItem> notifications,
    required bool isDark,
    required Color surfaceColor,
    required Color textColor,
    required Color subtleColor,
    required Color borderColor,
    required Color primaryColor,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section Title
          Padding(
            padding: const EdgeInsets.only(left: 4, bottom: 12),
            child: Text(
              title.toUpperCase(),
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: subtleColor,
                letterSpacing: 0.5,
              ),
            ),
          ),
          // Card Group
          Container(
            decoration: BoxDecoration(
              color: surfaceColor,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: borderColor),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withAlpha(10),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              children: notifications.asMap().entries.map((entry) {
                final index = entry.key;
                final notification = entry.value;
                final isLast = index == notifications.length - 1;

                return Column(
                  children: [
                    _buildNotificationTile(
                      notification,
                      isDark: isDark,
                      textColor: textColor,
                      subtleColor: subtleColor,
                      primaryColor: primaryColor,
                    ),
                    if (!isLast)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Divider(height: 1, color: borderColor),
                      ),
                  ],
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationTile(
    NotificationItem notification, {
    required bool isDark,
    required Color textColor,
    required Color subtleColor,
    required Color primaryColor,
  }) {
    final iconData = _getIconForType(notification.type);
    final colors = _getColorsForType(notification.type, isDark);

    return InkWell(
      onTap: () {
        // Handle notification tap
      },
      child: Opacity(
        opacity: notification.isRead ? 0.9 : 1.0,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Icon
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: colors['bg'],
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Icon(iconData, size: 24, color: colors['icon']),
              ),
              const SizedBox(width: 16),
              // Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            notification.title,
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: notification.isRead
                                  ? FontWeight.w600
                                  : FontWeight.bold,
                              color: textColor,
                              height: 1.3,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (!notification.isRead)
                          Container(
                            width: 10,
                            height: 10,
                            margin: const EdgeInsets.only(left: 8, top: 4),
                            decoration: BoxDecoration(
                              color: primaryColor,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: primaryColor.withAlpha(77),
                                  blurRadius: 4,
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      notification.message,
                      style: TextStyle(
                        fontSize: 14,
                        color: isDark
                            ? const Color(0xFF94a3b8)
                            : const Color(0xFF475569),
                        height: 1.4,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      notification.time,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: subtleColor.withAlpha(179),
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
  }

  IconData _getIconForType(NotificationType type) {
    switch (type) {
      case NotificationType.orderShipped:
        return LucideIcons.truck;
      case NotificationType.priceDrop:
        return LucideIcons.trendingDown;
      case NotificationType.flashSale:
        return LucideIcons.tag;
      case NotificationType.review:
        return LucideIcons.star;
      case NotificationType.backInStock:
        return LucideIcons.package;
      case NotificationType.system:
        return LucideIcons.info;
    }
  }

  Map<String, Color> _getColorsForType(NotificationType type, bool isDark) {
    switch (type) {
      case NotificationType.orderShipped:
        return {
          'bg': isDark
              ? const Color(0xFF135bec).withAlpha(51)
              : const Color(0xFFeff6ff),
          'icon': const Color(0xFF135bec),
        };
      case NotificationType.priceDrop:
        return {
          'bg': isDark
              ? const Color(0xFF10b981).withAlpha(51)
              : const Color(0xFFecfdf5),
          'icon': isDark ? const Color(0xFF34d399) : const Color(0xFF059669),
        };
      case NotificationType.flashSale:
        return {
          'bg': isDark
              ? const Color(0xFF8b5cf6).withAlpha(51)
              : const Color(0xFFf3e8ff),
          'icon': isDark ? const Color(0xFFa78bfa) : const Color(0xFF9333ea),
        };
      case NotificationType.review:
        return {
          'bg': isDark
              ? const Color(0xFFf59e0b).withAlpha(51)
              : const Color(0xFFfefce8),
          'icon': isDark ? const Color(0xFFfbbf24) : const Color(0xFFd97706),
        };
      case NotificationType.backInStock:
        return {
          'bg': isDark
              ? const Color(0xFFf97316).withAlpha(51)
              : const Color(0xFFfff7ed),
          'icon': isDark ? const Color(0xFFfb923c) : const Color(0xFFea580c),
        };
      case NotificationType.system:
        return {
          'bg': isDark
              ? Colors.grey[700]!.withAlpha(128)
              : const Color(0xFFf1f5f9),
          'icon': isDark ? const Color(0xFFcbd5e1) : const Color(0xFF475569),
        };
    }
  }
}
