import 'package:freezed_annotation/freezed_annotation.dart';

part 'review_model.freezed.dart';
part 'review_model.g.dart';

/// Review Model - Product review with rating
@freezed
class ReviewModel with _$ReviewModel {
  const factory ReviewModel({
    required String id,
    required String productId,
    required String userId,
    required String userName,
    String? userAvatar,
    required double rating,
    String? title,
    String? comment,
    @Default([]) List<String> images,
    @Default(0) int helpfulCount,
    @Default(false) bool isVerifiedPurchase,
    @Default(false) bool isRecommended,
    ReviewReplyModel? reply,
    required DateTime createdAt,
    DateTime? updatedAt,
  }) = _ReviewModel;

  const ReviewModel._();

  factory ReviewModel.fromJson(Map<String, dynamic> json) =>
      _$ReviewModelFromJson(json);

  /// Get star rating as integer
  int get starRating => rating.round();

  /// Check if has images
  bool get hasImages => images.isNotEmpty;

  /// Check if has reply from seller
  bool get hasReply => reply != null;
}

/// Review Reply Model - Seller's reply to review
@freezed
class ReviewReplyModel with _$ReviewReplyModel {
  const factory ReviewReplyModel({
    required String id,
    required String content,
    required String repliedBy,
    required DateTime repliedAt,
  }) = _ReviewReplyModel;

  factory ReviewReplyModel.fromJson(Map<String, dynamic> json) =>
      _$ReviewReplyModelFromJson(json);
}

/// Review Summary Model - Aggregated review stats
@freezed
class ReviewSummaryModel with _$ReviewSummaryModel {
  const factory ReviewSummaryModel({
    required double averageRating,
    required int totalReviews,
    @Default({})
    Map<int, int> ratingBreakdown, // {5: 100, 4: 50, 3: 20, 2: 5, 1: 2}
    @Default(0) int recommendedCount,
    @Default(0) int verifiedPurchaseCount,
  }) = _ReviewSummaryModel;

  const ReviewSummaryModel._();

  factory ReviewSummaryModel.fromJson(Map<String, dynamic> json) =>
      _$ReviewSummaryModelFromJson(json);

  /// Get percentage of recommenders
  double get recommendedPercentage =>
      totalReviews > 0 ? (recommendedCount / totalReviews) * 100 : 0;

  /// Get percentage for each rating
  double getRatingPercentage(int stars) {
    if (totalReviews == 0) return 0;
    return ((ratingBreakdown[stars] ?? 0) / totalReviews) * 100;
  }
}
