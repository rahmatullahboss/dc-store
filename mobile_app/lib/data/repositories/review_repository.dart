/// Review Repository Implementation
import '../../core/utils/either.dart';
import '../../core/errors/failures.dart';
import '../../core/errors/exceptions.dart';
import '../../core/network/network_info.dart';
import '../../domain/repositories/i_review_repository.dart';
import '../datasources/remote/review_remote_datasource.dart';
import '../models/review/review_model.dart';
import '../models/common/pagination.dart';

class ReviewRepository implements IReviewRepository {
  final IReviewRemoteDataSource _remoteDataSource;
  final NetworkInfo _networkInfo;

  ReviewRepository({
    required IReviewRemoteDataSource remoteDataSource,
    required NetworkInfo networkInfo,
  }) : _remoteDataSource = remoteDataSource,
       _networkInfo = networkInfo;

  @override
  Future<Result<PaginatedResponse<ReviewModel>>> getProductReviews({
    required String productId,
    int page = 1,
    int perPage = 10,
    ReviewSortOption sortBy = ReviewSortOption.newest,
  }) async {
    return tryCatch(() async {
      if (!await _networkInfo.isConnected) {
        throw NetworkException.noConnection();
      }

      final (reviews, pagination) = await _remoteDataSource.getProductReviews(
        productId: productId,
        page: page,
        perPage: perPage,
        sortBy: sortBy,
      );

      return PaginatedResponse(items: reviews, pagination: pagination);
    }, onError: _handleError);
  }

  @override
  Future<Result<List<ReviewModel>>> getUserReviews() async {
    return tryCatch(() async {
      if (!await _networkInfo.isConnected) {
        throw NetworkException.noConnection();
      }
      return _remoteDataSource.getUserReviews();
    }, onError: _handleError);
  }

  @override
  Future<Result<ReviewModel>> getReviewById(String reviewId) async {
    return tryCatch(() async {
      throw UnimplementedError('Get review by ID not implemented');
    }, onError: _handleError);
  }

  @override
  Future<Result<ReviewModel>> createReview({
    required String productId,
    required String orderId,
    required int rating,
    String? title,
    String? content,
    List<String>? images,
  }) async {
    return tryCatch(() async {
      if (!await _networkInfo.isConnected) {
        throw NetworkException.noConnection();
      }

      return _remoteDataSource.createReview(
        productId: productId,
        orderId: orderId,
        rating: rating,
        title: title,
        content: content,
        images: images,
      );
    }, onError: _handleError);
  }

  @override
  Future<Result<ReviewModel>> updateReview({
    required String reviewId,
    int? rating,
    String? title,
    String? content,
    List<String>? images,
  }) async {
    return tryCatch(() async {
      if (!await _networkInfo.isConnected) {
        throw NetworkException.noConnection();
      }

      return _remoteDataSource.updateReview(
        reviewId: reviewId,
        rating: rating,
        title: title,
        content: content,
      );
    }, onError: _handleError);
  }

  @override
  Future<Result<void>> deleteReview(String reviewId) async {
    return tryCatch(() async {
      if (!await _networkInfo.isConnected) {
        throw NetworkException.noConnection();
      }
      await _remoteDataSource.deleteReview(reviewId);
    }, onError: _handleError);
  }

  @override
  Future<Result<void>> markHelpful(String reviewId) async {
    return tryCatch(() async {
      throw UnimplementedError('Mark helpful not implemented');
    }, onError: _handleError);
  }

  @override
  Future<Result<void>> reportReview({
    required String reviewId,
    required String reason,
    String? description,
  }) async {
    return tryCatch(() async {
      throw UnimplementedError('Report review not implemented');
    }, onError: _handleError);
  }

  @override
  Future<Result<ReviewSummary>> getReviewSummary(String productId) async {
    return tryCatch(() async {
      if (!await _networkInfo.isConnected) {
        throw NetworkException.noConnection();
      }

      final data = await _remoteDataSource.getReviewSummary(productId);

      return ReviewSummary(
        productId: productId,
        averageRating: (data['averageRating'] as num?)?.toDouble() ?? 0,
        totalReviews: data['totalReviews'] as int? ?? 0,
        ratingBreakdown: Map<int, int>.from(
          (data['ratingBreakdown'] as Map? ?? {}).map(
            (key, value) => MapEntry(int.parse(key.toString()), value as int),
          ),
        ),
        recommendedCount: data['recommendedCount'] as int? ?? 0,
        recommendedPercentage:
            (data['recommendedPercentage'] as num?)?.toDouble() ?? 0,
      );
    }, onError: _handleError);
  }

  @override
  Future<Result<bool>> canReviewProduct(String productId) async {
    return tryCatch(() async {
      // This would check if user has purchased the product
      throw UnimplementedError('Can review check not implemented');
    }, onError: _handleError);
  }

  @override
  Future<Result<List<String>>> uploadReviewImages(
    List<String> imagePaths,
  ) async {
    return tryCatch(() async {
      throw UnimplementedError('Upload review images not implemented');
    }, onError: _handleError);
  }

  Failure _handleError(Object error, StackTrace stack) {
    if (error is NetworkException) {
      return NetworkFailure(error.message);
    } else if (error is ServerException) {
      return ServerFailure(error.message);
    }
    return ServerFailure(error.toString());
  }
}
