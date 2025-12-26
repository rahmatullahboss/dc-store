/// SupportConfig - Centralized support contact details
///
/// This class provides a single source of truth for all support-related
/// contact information. Update these values to change contact details
/// across the entire application.
class SupportConfig {
  SupportConfig._();

  // ═══════════════════════════════════════════════════════════════
  // EMAIL
  // ═══════════════════════════════════════════════════════════════

  /// Primary support email address
  static const String email = 'support@dcstore.com';

  /// Email subject for general support requests
  static const String emailSubject = 'Support Request - DC Store App';

  /// Email subject for problem reports
  static const String reportProblemSubject = 'Problem Report - DC Store App';

  // ═══════════════════════════════════════════════════════════════
  // PHONE
  // ═══════════════════════════════════════════════════════════════

  /// Support phone number
  static const String phone = '+1-800-DC-STORE';

  /// Display-friendly phone number
  static const String phoneDisplay = '1-800-DC-STORE';

  // ═══════════════════════════════════════════════════════════════
  // WHATSAPP
  // ═══════════════════════════════════════════════════════════════

  /// WhatsApp business number (without + or country code formatting)
  static const String whatsappNumber = '1234567890';

  /// Pre-filled message for WhatsApp
  static const String whatsappMessage =
      'Hi, I need help with my DC Store order.';

  // ═══════════════════════════════════════════════════════════════
  // LIVE CHAT
  // ═══════════════════════════════════════════════════════════════

  /// Live chat URL (Tawk.to, Intercom, etc.)
  static const String liveChatUrl = 'https://tawk.to/dcstore';

  // ═══════════════════════════════════════════════════════════════
  // SUPPORT HOURS
  // ═══════════════════════════════════════════════════════════════

  /// Support availability text
  static const String supportHours = 'Available 24/7';

  /// Average response time
  static const String responseTime = '< 5 minutes';
}
