import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '../data/models/common/common_models.dart';

/// NotificationService - Handles push and local notifications
class NotificationService {
  static NotificationService? _instance;
  static final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();

  // Stream controller for notification events
  static final StreamController<NotificationModel> _notificationController =
      StreamController<NotificationModel>.broadcast();

  NotificationService._();

  static NotificationService get instance {
    _instance ??= NotificationService._();
    return _instance!;
  }

  /// Stream of notifications
  Stream<NotificationModel> get onNotification =>
      _notificationController.stream;

  // ═══════════════════════════════════════════════════════════════
  // INITIALIZATION
  // ═══════════════════════════════════════════════════════════════

  /// Initialize notification service
  Future<void> initialize() async {
    await _initializeLocalNotifications();
    // TODO: Initialize FCM when package is added
    // await _initializeFCM();
  }

  Future<void> _initializeLocalNotifications() async {
    const androidSettings = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _localNotifications.initialize(
      initSettings,
      onDidReceiveNotificationResponse: _onNotificationTap,
    );
  }

  void _onNotificationTap(NotificationResponse response) {
    debugPrint('Notification tapped: ${response.payload}');
    // Handle notification tap - navigate to appropriate screen
    // Parse payload and use deep linking
  }

  // ═══════════════════════════════════════════════════════════════
  // LOCAL NOTIFICATIONS
  // ═══════════════════════════════════════════════════════════════

  /// Show local notification
  Future<void> showNotification({
    required int id,
    required String title,
    required String body,
    String? payload,
    String? channelId,
    String? channelName,
  }) async {
    final androidDetails = AndroidNotificationDetails(
      channelId ?? 'default_channel',
      channelName ?? 'Default Notifications',
      channelDescription: 'Default notification channel',
      importance: Importance.high,
      priority: Priority.high,
      showWhen: true,
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    final details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _localNotifications.show(id, title, body, details, payload: payload);
  }

  /// Show order notification
  Future<void> showOrderNotification({
    required String orderId,
    required String status,
    required String message,
  }) async {
    await showNotification(
      id: orderId.hashCode,
      title: 'Order Update',
      body: message,
      payload: 'order:$orderId',
    );
  }

  /// Show promo notification
  Future<void> showPromoNotification({
    required String title,
    required String message,
    String? promoCode,
  }) async {
    await showNotification(
      id: DateTime.now().millisecondsSinceEpoch ~/ 1000,
      title: title,
      body: message,
      payload: promoCode != null ? 'promo:$promoCode' : null,
      channelId: 'promo_channel',
      channelName: 'Promotions',
    );
  }

  /// Schedule notification
  Future<void> scheduleNotification({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledTime,
    String? payload,
  }) async {
    // TODO: Implement scheduled notifications with timezone
    debugPrint('Schedule notification for: $scheduledTime');
  }

  /// Cancel notification
  Future<void> cancelNotification(int id) async {
    await _localNotifications.cancel(id);
  }

  /// Cancel all notifications
  Future<void> cancelAllNotifications() async {
    await _localNotifications.cancelAll();
  }

  // ═══════════════════════════════════════════════════════════════
  // FCM (Firebase Cloud Messaging) - Placeholder
  // ═══════════════════════════════════════════════════════════════

  /// Get FCM token
  Future<String?> getFCMToken() async {
    // TODO: Implement with firebase_messaging package
    // return await FirebaseMessaging.instance.getToken();
    return null;
  }

  /// Subscribe to topic
  Future<void> subscribeToTopic(String topic) async {
    // TODO: Implement with firebase_messaging package
    // await FirebaseMessaging.instance.subscribeToTopic(topic);
    debugPrint('Subscribe to topic: $topic');
  }

  /// Unsubscribe from topic
  Future<void> unsubscribeFromTopic(String topic) async {
    // TODO: Implement with firebase_messaging package
    // await FirebaseMessaging.instance.unsubscribeFromTopic(topic);
    debugPrint('Unsubscribe from topic: $topic');
  }

  // ═══════════════════════════════════════════════════════════════
  // DEEP LINKING
  // ═══════════════════════════════════════════════════════════════

  /// Handle deep link from notification
  void handleDeepLink(String? payload) {
    if (payload == null) return;

    final parts = payload.split(':');
    if (parts.length < 2) return;

    final type = parts[0];
    final value = parts[1];

    switch (type) {
      case 'order':
        // Navigate to order details
        debugPrint('Navigate to order: $value');
        break;
      case 'product':
        // Navigate to product details
        debugPrint('Navigate to product: $value');
        break;
      case 'category':
        // Navigate to category
        debugPrint('Navigate to category: $value');
        break;
      case 'promo':
        // Apply promo code
        debugPrint('Apply promo code: $value');
        break;
      default:
        debugPrint('Unknown deep link type: $type');
    }
  }

  /// Request notification permissions
  Future<bool> requestPermissions() async {
    final result = await _localNotifications
        .resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin
        >()
        ?.requestPermissions(alert: true, badge: true, sound: true);
    return result ?? true;
  }

  /// Dispose
  void dispose() {
    _notificationController.close();
  }
}
