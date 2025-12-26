import 'package:flutter/material.dart';

/// ═══════════════════════════════════════════════════════════════════════════
/// WHITE-LABEL CONFIGURATION
/// ═══════════════════════════════════════════════════════════════════════════
///
/// 🎨 CHANGE THESE VALUES TO REBRAND THE ENTIRE APP
///
/// This is the SINGLE SOURCE OF TRUTH for all branding.
/// Modify this file to change:
///   - App name & tagline
///   - Company information
///   - Theme colors (primary, accent, etc.)
///   - Support contact details
///   - Social links & URLs
///
/// After changing values here, hot restart the app to see changes.
/// ═══════════════════════════════════════════════════════════════════════════

class WhiteLabelConfig {
  WhiteLabelConfig._();

  // ─────────────────────────────────────────────────────────────────────────
  // APP IDENTITY
  // ─────────────────────────────────────────────────────────────────────────

  /// App name displayed throughout the app
  static const String appName = 'DC Store';

  /// Short tagline for the app
  static const String appTagline = 'Shop Smart, Live Better';

  /// Company/brand name
  static const String companyName = 'Digital Care';

  /// App version
  static const String appVersion = '1.0.0';

  /// Build number
  static const String buildNumber = '1';

  // ─────────────────────────────────────────────────────────────────────────
  // BRAND COLORS
  // ─────────────────────────────────────────────────────────────────────────

  /// Primary brand color (main theme color)
  /// Used for: AppBar, buttons, primary UI elements
  static const Color primaryColor = Color(0xFF0F172A); // Slate

  /// Primary light variant
  static const Color primaryLightColor = Color(0xFF334155);

  /// Primary dark variant
  static const Color primaryDarkColor = Color(0xFF020617);

  /// Accent/Secondary color (highlights, CTAs)
  /// Used for: Add to cart buttons, sale badges, highlights
  static const Color accentColor = Color(0xFFF97316); // Orange

  /// Accent light variant
  static const Color accentLightColor = Color(0xFFFB923C);

  /// Accent dark variant
  static const Color accentDarkColor = Color(0xFFEA580C);

  // ─────────────────────────────────────────────────────────────────────────
  // CURRENCY & LOCALE
  // ─────────────────────────────────────────────────────────────────────────

  /// Default currency symbol
  static const String currencySymbol = '৳';

  /// Default currency code
  static const String currencyCode = 'BDT';

  /// Default locale
  static const String defaultLocale = 'en';

  /// Default country code
  static const String defaultCountryCode = 'BD';

  /// Default phone country code
  static const String defaultPhoneCode = '+880';

  // ─────────────────────────────────────────────────────────────────────────
  // SUPPORT & CONTACT
  // ─────────────────────────────────────────────────────────────────────────

  /// Support email address
  static const String supportEmail = 'support@dcstore.com';

  /// Support phone number
  static const String supportPhone = '+1-800-DC-STORE';

  /// Support phone (display format)
  static const String supportPhoneDisplay = '1-800-DC-STORE';

  /// WhatsApp business number
  static const String whatsappNumber = '1234567890';

  /// Live chat URL
  static const String liveChatUrl = 'https://tawk.to/dcstore';

  /// Support hours text
  static const String supportHours = 'Available 24/7';

  /// Average response time
  static const String responseTime = '< 5 minutes';

  // ─────────────────────────────────────────────────────────────────────────
  // URLS & SOCIAL
  // ─────────────────────────────────────────────────────────────────────────

  /// Main website URL
  static const String websiteUrl = 'https://store.digitalcare.site';

  /// API base URL (production)
  static const String apiBaseUrl = 'https://store.digitalcare.site';

  /// Play Store URL
  static const String playStoreUrl =
      'https://play.google.com/store/apps/details?id=com.digitalcare.dcstore';

  /// App Store URL
  static const String appStoreUrl =
      'https://apps.apple.com/app/dc-store/id123456789';

  /// Privacy Policy URL
  static const String privacyPolicyUrl =
      'https://store.digitalcare.site/privacy';

  /// Terms of Service URL
  static const String termsOfServiceUrl =
      'https://store.digitalcare.site/terms';

  /// Facebook page URL
  static const String facebookUrl = 'https://facebook.com/digitalcarestore';

  /// Instagram page URL
  static const String instagramUrl = 'https://instagram.com/digitalcarestore';

  // ─────────────────────────────────────────────────────────────────────────
  // GENERATED STRINGS (computed from appName)
  // ─────────────────────────────────────────────────────────────────────────

  /// Email subject for support
  static String get emailSubject => 'Support Request - $appName App';

  /// Email subject for problem reports
  static String get reportProblemSubject => 'Problem Report - $appName App';

  /// WhatsApp pre-filled message
  static String get whatsappMessage =>
      'Hi, I need help with my $appName order.';

  /// Share app message
  static String get shareAppMessage =>
      '📱 Download $appName - Premium E-commerce App!\n\nShop the best products with great deals.';

  /// Referral message
  static String referralMessage(String code) =>
      '🎁 Join $appName with my referral code: $code';

  /// Product share message
  static String productShareMessage(String productName, String link) =>
      '🛒 Check out $productName on $appName!\n\n$link';

  /// Category share message
  static String categoryShareMessage(String categoryName, String link) =>
      '🏷️ Explore $categoryName collection on $appName!\n\n$link';

  /// Welcome message
  static String get welcomeMessage => 'Welcome to $appName';
}
