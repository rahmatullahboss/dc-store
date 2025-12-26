import '../config/white_label_config.dart';

/// SupportConfig - Centralized support contact details
///
/// This class provides a single source of truth for all support-related
/// contact information. Values are sourced from WhiteLabelConfig.
class SupportConfig {
  SupportConfig._();

  // ═══════════════════════════════════════════════════════════════
  // EMAIL (from WhiteLabelConfig)
  // ═══════════════════════════════════════════════════════════════

  /// Primary support email address
  static String get email => WhiteLabelConfig.supportEmail;

  /// Email subject for general support requests
  static String get emailSubject => WhiteLabelConfig.emailSubject;

  /// Email subject for problem reports
  static String get reportProblemSubject =>
      WhiteLabelConfig.reportProblemSubject;

  // ═══════════════════════════════════════════════════════════════
  // PHONE (from WhiteLabelConfig)
  // ═══════════════════════════════════════════════════════════════

  /// Support phone number
  static String get phone => WhiteLabelConfig.supportPhone;

  /// Display-friendly phone number
  static String get phoneDisplay => WhiteLabelConfig.supportPhoneDisplay;

  // ═══════════════════════════════════════════════════════════════
  // WHATSAPP (from WhiteLabelConfig)
  // ═══════════════════════════════════════════════════════════════

  /// WhatsApp business number (without + or country code formatting)
  static String get whatsappNumber => WhiteLabelConfig.whatsappNumber;

  /// Pre-filled message for WhatsApp
  static String get whatsappMessage => WhiteLabelConfig.whatsappMessage;

  // ═══════════════════════════════════════════════════════════════
  // LIVE CHAT (from WhiteLabelConfig)
  // ═══════════════════════════════════════════════════════════════

  /// Live chat URL (Tawk.to, Intercom, etc.)
  static String get liveChatUrl => WhiteLabelConfig.liveChatUrl;

  // ═══════════════════════════════════════════════════════════════
  // SUPPORT HOURS (from WhiteLabelConfig)
  // ═══════════════════════════════════════════════════════════════

  /// Support availability text
  static String get supportHours => WhiteLabelConfig.supportHours;

  /// Average response time
  static String get responseTime => WhiteLabelConfig.responseTime;
}
