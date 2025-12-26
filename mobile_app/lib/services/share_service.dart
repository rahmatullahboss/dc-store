import 'package:flutter/foundation.dart';
import 'package:share_plus/share_plus.dart';
import '../core/constants/api_constants.dart';
import '../core/config/white_label_config.dart';

/// ShareService - Handles content sharing and deep link generation
class ShareService {
  static ShareService? _instance;

  ShareService._();

  static ShareService get instance {
    _instance ??= ShareService._();
    return _instance!;
  }

  // ═══════════════════════════════════════════════════════════════
  // PRODUCT SHARING
  // ═══════════════════════════════════════════════════════════════

  /// Share product
  Future<void> shareProduct({
    required String productId,
    required String productName,
    String? productImage,
    double? price,
    String? description,
  }) async {
    final link = generateProductDeepLink(productId);

    String message = '🛍️ Check out $productName';
    if (price != null) {
      message += ' - ৳${price.toStringAsFixed(0)}';
    }
    if (description != null && description.isNotEmpty) {
      message += '\n\n$description';
    }
    message += '\n\n$link';

    await SharePlus.instance.share(
      ShareParams(
        text: message,
        title: 'Check out $productName on ${WhiteLabelConfig.appName}',
      ),
    );
  }

  /// Share category
  Future<void> shareCategory({
    required String categoryId,
    required String categoryName,
  }) async {
    final link = generateCategoryDeepLink(categoryId);

    await SharePlus.instance.share(
      ShareParams(
        text:
            '🏷️ Explore $categoryName collection on ${WhiteLabelConfig.appName}!\n\n$link',
        title: '$categoryName - ${WhiteLabelConfig.appName}',
      ),
    );
  }

  /// Share order (for support)
  Future<void> shareOrder({
    required String orderId,
    required String orderNumber,
  }) async {
    await SharePlus.instance.share(
      ShareParams(
        text:
            '📦 Order #$orderNumber\nOrder ID: $orderId\n\nI need help with this order.',
        title: 'Order #$orderNumber',
      ),
    );
  }

  /// Share referral code
  Future<void> shareReferralCode({
    required String referralCode,
    String? discountText,
  }) async {
    final link = generateReferralDeepLink(referralCode);

    String message =
        '🎁 Join ${WhiteLabelConfig.appName} with my referral code: $referralCode';
    if (discountText != null) {
      message += '\n\nGet $discountText off on your first order!';
    }
    message += '\n\n$link';

    await SharePlus.instance.share(
      ShareParams(text: message, title: 'Join ${WhiteLabelConfig.appName}'),
    );
  }

  /// Share app
  Future<void> shareApp() async {
    const link = 'https://dcstore.com/app';

    await SharePlus.instance.share(
      ShareParams(
        text:
            '📱 Download ${WhiteLabelConfig.appName} - Premium E-commerce App!\n\nShop the best products with great deals.\n\n$link',
        title: 'Download ${WhiteLabelConfig.appName} App',
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════
  // DEEP LINK GENERATION
  // ═══════════════════════════════════════════════════════════════

  /// Generate product deep link
  String generateProductDeepLink(String productId) {
    return '${ApiConstants.baseUrl}/product/$productId';
  }

  /// Generate category deep link
  String generateCategoryDeepLink(String categoryId) {
    return '${ApiConstants.baseUrl}/category/$categoryId';
  }

  /// Generate referral deep link
  String generateReferralDeepLink(String referralCode) {
    return '${ApiConstants.baseUrl}/invite/$referralCode';
  }

  /// Generate order tracking deep link
  String generateOrderTrackingLink(String orderId) {
    return '${ApiConstants.baseUrl}/track/$orderId';
  }

  /// Generate promo deep link
  String generatePromoDeepLink(String promoCode) {
    return '${ApiConstants.baseUrl}/promo/$promoCode';
  }

  // ═══════════════════════════════════════════════════════════════
  // SOCIAL SHARING
  // ═══════════════════════════════════════════════════════════════

  /// Share to specific platform
  Future<void> shareToSocial({
    required String platform,
    required String content,
    String? url,
  }) async {
    // For now, use generic share
    // TODO: Implement platform-specific sharing if needed
    await SharePlus.instance.share(ShareParams(text: content));
  }

  /// Share with file
  Future<void> shareWithFile({required String filePath, String? text}) async {
    try {
      await SharePlus.instance.share(
        ShareParams(files: [XFile(filePath)], text: text),
      );
    } catch (e) {
      debugPrint('Error sharing file: $e');
    }
  }

  // ═══════════════════════════════════════════════════════════════
  // DEEP LINK PARSING
  // ═══════════════════════════════════════════════════════════════

  /// Parse deep link
  DeepLinkData? parseDeepLink(String url) {
    try {
      final uri = Uri.parse(url);
      final segments = uri.pathSegments;

      if (segments.isEmpty) return null;

      switch (segments[0]) {
        case 'product':
          if (segments.length > 1) {
            return DeepLinkData(type: DeepLinkType.product, id: segments[1]);
          }
          break;
        case 'category':
          if (segments.length > 1) {
            return DeepLinkData(type: DeepLinkType.category, id: segments[1]);
          }
          break;
        case 'invite':
          if (segments.length > 1) {
            return DeepLinkData(type: DeepLinkType.referral, id: segments[1]);
          }
          break;
        case 'track':
          if (segments.length > 1) {
            return DeepLinkData(type: DeepLinkType.order, id: segments[1]);
          }
          break;
        case 'promo':
          if (segments.length > 1) {
            return DeepLinkData(type: DeepLinkType.promo, id: segments[1]);
          }
          break;
      }

      return null;
    } catch (e) {
      debugPrint('Error parsing deep link: $e');
      return null;
    }
  }
}

// ═══════════════════════════════════════════════════════════════
// DATA CLASSES
// ═══════════════════════════════════════════════════════════════

enum DeepLinkType { product, category, referral, order, promo }

class DeepLinkData {
  final DeepLinkType type;
  final String id;
  final Map<String, String>? params;

  const DeepLinkData({required this.type, required this.id, this.params});
}
