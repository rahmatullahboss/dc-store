import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz_data;
import '../data/models/common/common_models.dart';

/// Background message handler - must be top-level function
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  debugPrint('Handling a background message: ${message.messageId}');
}

/// NotificationService - Handles push and local notifications
class NotificationService {
  static NotificationService? _instance;
  static final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();
  static FirebaseMessaging? _firebaseMessaging;

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
    await _initializeFCM();
    _initializeTimezone();
  }

  void _initializeTimezone() {
    tz_data.initializeTimeZones();
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

  Future<void> _initializeFCM() async {
    try {
      _firebaseMessaging = FirebaseMessaging.instance;

      // Request permission for iOS
      final settings = await _firebaseMessaging!.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
        sound: true,
      );

      debugPrint('FCM Permission status: ${settings.authorizationStatus}');

      // Set up message handlers
      FirebaseMessaging.onBackgroundMessage(
        _firebaseMessagingBackgroundHandler,
      );

      // Handle foreground messages
      FirebaseMessaging.onMessage.listen(_handleForegroundMessage);

      // Handle when app is opened from notification
      FirebaseMessaging.onMessageOpenedApp.listen(_handleMessageOpenedApp);

      // Check for initial message (app opened from terminated state)
      final initialMessage = await _firebaseMessaging!.getInitialMessage();
      if (initialMessage != null) {
        _handleMessageOpenedApp(initialMessage);
      }

      debugPrint('FCM initialized successfully');
    } catch (e) {
      debugPrint('Error initializing FCM: $e');
    }
  }

  void _handleForegroundMessage(RemoteMessage message) {
    debugPrint('Received foreground message: ${message.messageId}');

    // Show local notification for foreground messages
    final notification = message.notification;
    if (notification != null) {
      showNotification(
        id: message.hashCode,
        title: notification.title ?? 'New Notification',
        body: notification.body ?? '',
        payload: message.data['action'] ?? '',
      );
    }

    // Add to stream
    _notificationController.add(
      NotificationModel(
        id:
            message.messageId ??
            DateTime.now().millisecondsSinceEpoch.toString(),
        title: notification?.title ?? 'Notification',
        body: notification?.body ?? '',
        type: 'push',
        createdAt: DateTime.now(),
        data: message.data,
      ),
    );
  }

  void _handleMessageOpenedApp(RemoteMessage message) {
    debugPrint('App opened from notification: ${message.messageId}');
    handleDeepLink(message.data['action'] as String?);
  }

  void _onNotificationTap(NotificationResponse response) {
    debugPrint('Notification tapped: ${response.payload}');
    // Handle notification tap - navigate to appropriate screen
    // Parse payload and use deep linking
    handleDeepLink(response.payload);
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
    final androidDetails = const AndroidNotificationDetails(
      'scheduled_channel',
      'Scheduled Notifications',
      channelDescription: 'Scheduled notification channel',
      importance: Importance.high,
      priority: Priority.high,
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

    await _localNotifications.zonedSchedule(
      id,
      title,
      body,
      tz.TZDateTime.from(scheduledTime, tz.local),
      details,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      payload: payload,
    );

    debugPrint('Notification scheduled for: $scheduledTime');
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
  // FCM (Firebase Cloud Messaging)
  // ═══════════════════════════════════════════════════════════════

  /// Get FCM token
  Future<String?> getFCMToken() async {
    try {
      return await _firebaseMessaging?.getToken();
    } catch (e) {
      debugPrint('Error getting FCM token: $e');
      return null;
    }
  }

  /// Subscribe to topic
  Future<void> subscribeToTopic(String topic) async {
    try {
      await _firebaseMessaging?.subscribeToTopic(topic);
      debugPrint('Subscribed to topic: $topic');
    } catch (e) {
      debugPrint('Error subscribing to topic: $e');
    }
  }

  /// Unsubscribe from topic
  Future<void> unsubscribeFromTopic(String topic) async {
    try {
      await _firebaseMessaging?.unsubscribeFromTopic(topic);
      debugPrint('Unsubscribed from topic: $topic');
    } catch (e) {
      debugPrint('Error unsubscribing from topic: $e');
    }
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
