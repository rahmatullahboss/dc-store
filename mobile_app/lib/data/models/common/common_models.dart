import 'package:freezed_annotation/freezed_annotation.dart';
import '../product/product_model.dart';

part 'common_models.freezed.dart';
part 'common_models.g.dart';

/// Wishlist Item Model
@freezed
class WishlistItemModel with _$WishlistItemModel {
  const factory WishlistItemModel({
    required String id,
    required String productId,
    required String productName,
    String? productImage,
    required double price,
    double? compareAtPrice,
    @Default(true) bool inStock,
    DateTime? addedAt,
  }) = _WishlistItemModel;

  const WishlistItemModel._();

  factory WishlistItemModel.fromJson(Map<String, dynamic> json) =>
      _$WishlistItemModelFromJson(json);

  /// Check if on sale
  bool get isOnSale => compareAtPrice != null && compareAtPrice! > price;
}

/// Banner Model - Promotional banners
@freezed
class BannerModel with _$BannerModel {
  const factory BannerModel({
    required String id,
    required String image,
    String? mobileImage,
    String? title,
    String? subtitle,
    String? buttonText,
    String? actionType, // product, category, url, screen
    String? actionValue, // product_id, category_id, url, screen_name
    @Default(0) int sortOrder,
    @Default(true) bool isActive,
    DateTime? startDate,
    DateTime? endDate,
  }) = _BannerModel;

  const BannerModel._();

  factory BannerModel.fromJson(Map<String, dynamic> json) =>
      _$BannerModelFromJson(json);

  /// Check if banner is valid (within date range)
  bool get isValid {
    final now = DateTime.now();
    if (startDate != null && now.isBefore(startDate!)) return false;
    if (endDate != null && now.isAfter(endDate!)) return false;
    return isActive;
  }
}

/// Notification Model - Push/in-app notifications
@freezed
class NotificationModel with _$NotificationModel {
  const factory NotificationModel({
    required String id,
    required String title,
    required String body,
    String? image,
    required String type, // order, promo, system, chat
    Map<String, dynamic>? data,
    @Default(false) bool isRead,
    required DateTime createdAt,
  }) = _NotificationModel;

  const NotificationModel._();

  factory NotificationModel.fromJson(Map<String, dynamic> json) =>
      _$NotificationModelFromJson(json);

  /// Get time ago string
  String get timeAgo {
    final diff = DateTime.now().difference(createdAt);
    if (diff.inDays > 7) return '${(diff.inDays / 7).floor()}w ago';
    if (diff.inDays > 0) return '${diff.inDays}d ago';
    if (diff.inHours > 0) return '${diff.inHours}h ago';
    if (diff.inMinutes > 0) return '${diff.inMinutes}m ago';
    return 'Just now';
  }
}

/// FAQ Model
@freezed
class FaqModel with _$FaqModel {
  const factory FaqModel({
    required String id,
    required String question,
    required String answer,
    String? category,
    @Default(0) int sortOrder,
  }) = _FaqModel;

  factory FaqModel.fromJson(Map<String, dynamic> json) =>
      _$FaqModelFromJson(json);
}

/// Settings Model
@freezed
class SettingsModel with _$SettingsModel {
  const factory SettingsModel({
    @Default(true) bool pushNotifications,
    @Default(true) bool emailNotifications,
    @Default(true) bool smsNotifications,
    @Default('en') String language,
    @Default('BDT') String currency,
    @Default('system') String themeMode,
    @Default(false) bool biometricEnabled,
  }) = _SettingsModel;

  factory SettingsModel.fromJson(Map<String, dynamic> json) =>
      _$SettingsModelFromJson(json);
}

/// Pagination Model
@freezed
class PaginatedResponse<T> with _$PaginatedResponse<T> {
  const factory PaginatedResponse({
    required List<T> data,
    required int currentPage,
    required int lastPage,
    required int perPage,
    required int total,
  }) = _PaginatedResponse<T>;

  const PaginatedResponse._();

  /// Check if has more pages
  bool get hasMore => currentPage < lastPage;

  /// Check if first page
  bool get isFirstPage => currentPage == 1;

  /// Check if last page
  bool get isLastPage => currentPage >= lastPage;

  /// Get next page number
  int get nextPage => hasMore ? currentPage + 1 : currentPage;
}
