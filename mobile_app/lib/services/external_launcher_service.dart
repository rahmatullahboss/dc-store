import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart' as url_launcher;
import '../core/constants/support_config.dart';

/// Result of a launch operation
class LaunchResult {
  final bool success;
  final String? errorMessage;
  final String? fallbackAction;

  const LaunchResult({
    required this.success,
    this.errorMessage,
    this.fallbackAction,
  });

  const LaunchResult.success() : this(success: true);

  const LaunchResult.failure({String? message, String? fallback})
    : this(success: false, errorMessage: message, fallbackAction: fallback);
}

/// ExternalLauncherService - Handles launching external URLs and apps
///
/// Provides a centralized way to launch:
/// - Email clients
/// - Phone dialers
/// - WhatsApp
/// - Live chat
/// - External URLs
/// - Maps
///
/// Follows the singleton pattern consistent with other services in this codebase.
class ExternalLauncherService {
  static ExternalLauncherService? _instance;

  ExternalLauncherService._();

  static ExternalLauncherService get instance {
    _instance ??= ExternalLauncherService._();
    return _instance!;
  }

  // ═══════════════════════════════════════════════════════════════
  // EMAIL
  // ═══════════════════════════════════════════════════════════════

  /// Launch email client with pre-filled subject
  Future<LaunchResult> launchEmail({
    String? email,
    String? subject,
    String? body,
  }) async {
    final emailAddress = email ?? SupportConfig.email;
    final emailSubject = subject ?? SupportConfig.emailSubject;

    final uri = Uri(
      scheme: 'mailto',
      path: emailAddress,
      queryParameters: {
        'subject': emailSubject,
        if (body != null) 'body': body,
      },
    );

    return _launchUri(uri, fallbackText: emailAddress);
  }

  // ═══════════════════════════════════════════════════════════════
  // PHONE
  // ═══════════════════════════════════════════════════════════════

  /// Launch phone dialer
  Future<LaunchResult> launchPhone({String? phoneNumber}) async {
    final number = phoneNumber ?? SupportConfig.phone;
    final uri = Uri(scheme: 'tel', path: number);

    return _launchUri(uri, fallbackText: number);
  }

  // ═══════════════════════════════════════════════════════════════
  // WHATSAPP
  // ═══════════════════════════════════════════════════════════════

  /// Launch WhatsApp with pre-filled message
  Future<LaunchResult> launchWhatsApp({
    String? phoneNumber,
    String? message,
  }) async {
    final number = phoneNumber ?? SupportConfig.whatsappNumber;
    final text = message ?? SupportConfig.whatsappMessage;

    final uri = Uri.parse(
      'https://wa.me/$number?text=${Uri.encodeComponent(text)}',
    );

    try {
      if (await url_launcher.canLaunchUrl(uri)) {
        await url_launcher.launchUrl(
          uri,
          mode: url_launcher.LaunchMode.externalApplication,
        );
        return const LaunchResult.success();
      } else {
        return const LaunchResult.failure(
          message: 'WhatsApp is not installed',
          fallback: 'Please install WhatsApp to use this feature',
        );
      }
    } catch (e) {
      debugPrint('ExternalLauncherService.launchWhatsApp error: $e');
      return LaunchResult.failure(message: 'Failed to launch WhatsApp: $e');
    }
  }

  // ═══════════════════════════════════════════════════════════════
  // LIVE CHAT
  // ═══════════════════════════════════════════════════════════════

  /// Launch live chat URL
  Future<LaunchResult> launchLiveChat({String? chatUrl}) async {
    final url = chatUrl ?? SupportConfig.liveChatUrl;
    return openUrl(url);
  }

  // ═══════════════════════════════════════════════════════════════
  // GENERIC URL
  // ═══════════════════════════════════════════════════════════════

  /// Launch any URL in external browser
  Future<LaunchResult> openUrl(
    String url, {
    url_launcher.LaunchMode mode = url_launcher.LaunchMode.externalApplication,
  }) async {
    final uri = Uri.parse(url);

    try {
      if (await url_launcher.canLaunchUrl(uri)) {
        await url_launcher.launchUrl(uri, mode: mode);
        return const LaunchResult.success();
      } else {
        return LaunchResult.failure(message: 'Could not open URL: $url');
      }
    } catch (e) {
      debugPrint('ExternalLauncherService.openUrl error: $e');
      return LaunchResult.failure(message: 'Failed to open URL: $e');
    }
  }

  /// Launch URL for viewing in-app
  Future<LaunchResult> openUrlInApp(String url) async {
    return openUrl(url, mode: url_launcher.LaunchMode.inAppWebView);
  }

  // ═══════════════════════════════════════════════════════════════
  // MAPS
  // ═══════════════════════════════════════════════════════════════

  /// Launch maps with an address
  Future<LaunchResult> launchMaps({
    required String address,
    double? latitude,
    double? longitude,
  }) async {
    Uri uri;

    if (latitude != null && longitude != null) {
      uri = Uri.parse(
        'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude',
      );
    } else {
      uri = Uri.parse(
        'https://www.google.com/maps/search/?api=1&query=${Uri.encodeComponent(address)}',
      );
    }

    try {
      if (await url_launcher.canLaunchUrl(uri)) {
        await url_launcher.launchUrl(
          uri,
          mode: url_launcher.LaunchMode.externalApplication,
        );
        return const LaunchResult.success();
      } else {
        return const LaunchResult.failure(message: 'Could not open maps');
      }
    } catch (e) {
      debugPrint('ExternalLauncherService.launchMaps error: $e');
      return LaunchResult.failure(message: 'Failed to open maps: $e');
    }
  }

  // ═══════════════════════════════════════════════════════════════
  // SOCIAL MEDIA
  // ═══════════════════════════════════════════════════════════════

  /// Launch social media profile
  Future<LaunchResult> launchSocialMedia({
    required String platform,
    required String username,
  }) async {
    String url;

    switch (platform.toLowerCase()) {
      case 'instagram':
        url = 'https://instagram.com/$username';
        break;
      case 'twitter':
      case 'x':
        url = 'https://twitter.com/$username';
        break;
      case 'facebook':
        url = 'https://facebook.com/$username';
        break;
      case 'tiktok':
        url = 'https://tiktok.com/@$username';
        break;
      default:
        return LaunchResult.failure(message: 'Unknown platform: $platform');
    }

    return openUrl(url);
  }

  // ═══════════════════════════════════════════════════════════════
  // PRIVATE HELPERS
  // ═══════════════════════════════════════════════════════════════

  /// Internal helper for launching URIs with fallback
  Future<LaunchResult> _launchUri(Uri uri, {String? fallbackText}) async {
    try {
      if (await url_launcher.canLaunchUrl(uri)) {
        await url_launcher.launchUrl(uri);
        return const LaunchResult.success();
      } else {
        if (fallbackText != null) {
          await Clipboard.setData(ClipboardData(text: fallbackText));
          return LaunchResult.failure(
            message: 'Could not launch',
            fallback: 'Copied to clipboard: $fallbackText',
          );
        }
        return const LaunchResult.failure(message: 'Could not launch');
      }
    } catch (e) {
      debugPrint('ExternalLauncherService._launchUri error: $e');
      return LaunchResult.failure(message: 'Failed to launch: $e');
    }
  }
}
