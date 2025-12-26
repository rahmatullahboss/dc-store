/// Review Remote Data Source - API calls for reviews
library;
import '../../../core/network/dio_client.dart';
import '../../../core/constants/api_constants.dart';
import '../../../core/errors/exceptions.dart';
import '../../models/review/review_model.dart';
import '../../models/common/pagination.dart';
import '../../../domain/repositories/i_review_repository.dart';

abstract class IReviewRemoteDataSource {
  Future<(List<ReviewModel>, PaginationModel)> getProductReviews({
    required String productId,
    int page = 1,
    int perPage = 10,
    ReviewSortOption sortBy = ReviewSortOption.newest,
  });
  Future<List<ReviewModel>> getUserReviews();
  Future<ReviewModel> createReview({
    required String productId,
    required String orderId,
    required int rating,
    String? title,
    String? content,
    List<String>? images,
  });
  Future<ReviewModel> updateReview({
    required String reviewId,
    int? rating,
    String? title,
    String? content,
  });
  Future<void> deleteReview(String reviewId);
  Future<Map<String, dynamic>> getReviewSummary(String productId);
}

class ReviewRemoteDataSource implements IReviewRemoteDataSource {
  final DioClient _client;

  ReviewRemoteDataSource({required DioClient client}) : _client = client;

  @override
  Future<(List<ReviewModel>, PaginationModel)> getProductReviews({
    required String productId,
    int page = 1,
    int perPage = 10,
    ReviewSortOption sortBy = ReviewSortOption.newest,
  }) async {
    final response = await _client.get<Map<String, dynamic>>(
      '${ApiConstants.products}/$productId/reviews',
      queryParameters: {
        'page': page,
        'perPage': perPage,
        'sortBy': sortBy.value,
      },
    );

    if (!response.isSuccess || response.data == null) {
      throw ServerException(
        message: response.message ?? 'Failed to fetch reviews',
        statusCode: response.error?.statusCode,
      );
    }

    final data = response.data!;
    final items = (data['reviews'] as List? ?? data['data'] as List? ?? [])
        .map((item) => ReviewModel.fromJson(item as Map<String, dynamic>))
        .toList();

    final pagination = data['pagination'] != null
        ? PaginationModel.fromJson(data['pagination'] as Map<String, dynamic>)
        : PaginationModel(currentPage: page, totalItems: items.length);

    return (items, pagination);
  }

  @override
  Future<List<ReviewModel>> getUserReviews() async {
    final response = await _client.get<Map<String, dynamic>>(
      '${ApiConstants.profile}/reviews',
    );

    if (!response.isSuccess || response.data == null) {
      throw ServerException(
        message: response.message ?? 'Failed to fetch user reviews',
        statusCode: response.error?.statusCode,
      );
    }

    final data = response.data!;
    return (data['reviews'] as List? ?? data['data'] as List? ?? [])
        .map((item) => ReviewModel.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<ReviewModel> createReview({
    required String productId,
    required String orderId,
    required int rating,
    String? title,
    String? content,
    List<String>? images,
  }) async {
    final response = await _client.post<Map<String, dynamic>>(
      ApiConstants.reviews,
      data: {
        'productId': productId,
        'orderId': orderId,
        'rating': rating,
        if (title != null) 'title': title,
        if (content != null) 'content': content,
        if (images != null) 'images': images,
      },
    );

    if (!response.isSuccess || response.data == null) {
      throw ServerException(
        message: response.message ?? 'Failed to create review',
        statusCode: response.error?.statusCode,
      );
    }

    final data = response.data!;
    return ReviewModel.fromJson(
      data['review'] as Map<String, dynamic>? ?? data,
    );
  }

  @override
  Future<ReviewModel> updateReview({
    required String reviewId,
    int? rating,
    String? title,
    String? content,
  }) async {
    final response = await _client.patch<Map<String, dynamic>>(
      '${ApiConstants.reviews}/$reviewId',
      data: {
        if (rating != null) 'rating': rating,
        if (title != null) 'title': title,
        if (content != null) 'content': content,
      },
    );

    if (!response.isSuccess || response.data == null) {
      throw ServerException(
        message: response.message ?? 'Failed to update review',
        statusCode: response.error?.statusCode,
      );
    }

    final data = response.data!;
    return ReviewModel.fromJson(
      data['review'] as Map<String, dynamic>? ?? data,
    );
  }

  @override
  Future<void> deleteReview(String reviewId) async {
    final response = await _client.delete<Map<String, dynamic>>(
      '${ApiConstants.reviews}/$reviewId',
    );

    if (!response.isSuccess) {
      throw ServerException(
        message: response.message ?? 'Failed to delete review',
        statusCode: response.error?.statusCode,
      );
    }
  }

  @override
  Future<Map<String, dynamic>> getReviewSummary(String productId) async {
    final response = await _client.get<Map<String, dynamic>>(
      '${ApiConstants.products}/$productId/reviews/summary',
    );

    if (!response.isSuccess || response.data == null) {
      throw ServerException(
        message: response.message ?? 'Failed to fetch review summary',
        statusCode: response.error?.statusCode,
      );
    }

    return response.data!;
  }
}
