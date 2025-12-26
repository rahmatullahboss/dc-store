/// Review Repository Interface - Domain Layer
/// Defines all product review operations

import '../../core/utils/either.dart';
import '../../data/models/review/review_model.dart';
import '../../data/models/common/pagination.dart';

abstract class IReviewRepository {
  /// Get reviews for a product
  Future<Result<PaginatedResponse<ReviewModel>>> getProductReviews({
    required String productId,
    int page = 1,
    int perPage = 10,
    ReviewSortOption sortBy = ReviewSortOption.newest,
  });

  /// Get current user's reviews
  Future<Result<List<ReviewModel>>> getUserReviews();

  /// Get review by ID
  Future<Result<ReviewModel>> getReviewById(String reviewId);

  /// Create a new review
  Future<Result<ReviewModel>> createReview({
    required String productId,
    required String orderId,
    required int rating,
    String? title,
    String? content,
    List<String>? images,
  });

  /// Update existing review
  Future<Result<ReviewModel>> updateReview({
    required String reviewId,
    int? rating,
    String? title,
    String? content,
    List<String>? images,
  });

  /// Delete a review
  Future<Result<void>> deleteReview(String reviewId);

  /// Mark review as helpful
  Future<Result<void>> markHelpful(String reviewId);

  /// Report a review
  Future<Result<void>> reportReview({
    required String reviewId,
    required String reason,
    String? description,
  });

  /// Get review summary for a product
  Future<Result<ReviewSummary>> getReviewSummary(String productId);

  /// Check if user can review a product
  Future<Result<bool>> canReviewProduct(String productId);

  /// Upload review images
  Future<Result<List<String>>> uploadReviewImages(List<String> imagePaths);
}

/// Review summary with rating breakdown
class ReviewSummary {
  final String productId;
  final double averageRating;
  final int totalReviews;
  final Map<int, int> ratingBreakdown; // {5: 100, 4: 50, 3: 20, 2: 5, 1: 2}
  final int recommendedCount;
  final double recommendedPercentage;

  ReviewSummary({
    required this.productId,
    required this.averageRating,
    required this.totalReviews,
    required this.ratingBreakdown,
    required this.recommendedCount,
    required this.recommendedPercentage,
  });
}

/// Review sort options
enum ReviewSortOption {
  newest('newest', 'Newest First'),
  oldest('oldest', 'Oldest First'),
  highestRating('rating_desc', 'Highest Rated'),
  lowestRating('rating_asc', 'Lowest Rated'),
  mostHelpful('helpful', 'Most Helpful');

  final String value;
  final String displayName;

  const ReviewSortOption(this.value, this.displayName);
}
