import 'package:dio/dio.dart';
import '../errors/exceptions.dart';

/// Generic API Response Wrapper
/// Handles success, error states, and pagination support
class ApiResponse<T> {
  final T? data;
  final bool isSuccess;
  final String? message;
  final ApiError? error;
  final PaginationMeta? pagination;
  final Map<String, dynamic>? meta;

  const ApiResponse._({
    this.data,
    required this.isSuccess,
    this.message,
    this.error,
    this.pagination,
    this.meta,
  });

  // ═══════════════════════════════════════════════════════════════
  // FACTORY CONSTRUCTORS
  // ═══════════════════════════════════════════════════════════════

  /// Create success response
  factory ApiResponse.success(
    T data, {
    String? message,
    PaginationMeta? pagination,
    Map<String, dynamic>? meta,
  }) {
    return ApiResponse._(
      data: data,
      isSuccess: true,
      message: message,
      pagination: pagination,
      meta: meta,
    );
  }

  /// Create error response from DioException
  factory ApiResponse.error(DioException exception) {
    return ApiResponse._(
      isSuccess: false,
      error: ApiError.fromDioException(exception),
    );
  }

  /// Create error response from message
  factory ApiResponse.fromMessage(String message, {String? code}) {
    return ApiResponse._(
      isSuccess: false,
      error: ApiError(message: message, code: code),
    );
  }

  /// Create error response from custom exception
  factory ApiResponse.fromException(AppException exception) {
    return ApiResponse._(
      isSuccess: false,
      error: ApiError(message: exception.message, code: exception.code),
    );
  }

  /// Create response from Dio Response
  factory ApiResponse.fromResponse(
    Response response, {
    T Function(dynamic)? fromJson,
  }) {
    final statusCode = response.statusCode ?? 0;
    final responseData = response.data;

    // Error response (4xx)
    if (statusCode >= 400 && statusCode < 500) {
      return ApiResponse._(
        isSuccess: false,
        error: ApiError(
          message: _extractMessage(responseData) ?? 'Request failed',
          code: statusCode.toString(),
          statusCode: statusCode,
          errors: _extractErrors(responseData),
        ),
      );
    }

    // Success response
    try {
      T? parsedData;
      String? message;
      PaginationMeta? pagination;
      Map<String, dynamic>? meta;

      if (responseData is Map<String, dynamic>) {
        // Extract message
        message = responseData['message'] as String?;

        // Extract pagination
        if (responseData.containsKey('pagination')) {
          pagination = PaginationMeta.fromJson(responseData['pagination']);
        } else if (responseData.containsKey('meta')) {
          final metaData = responseData['meta'];
          if (metaData is Map<String, dynamic> &&
              metaData.containsKey('pagination')) {
            pagination = PaginationMeta.fromJson(metaData['pagination']);
          }
          meta = metaData is Map<String, dynamic> ? metaData : null;
        }

        // Extract and parse data
        final dataKey = responseData.containsKey('data')
            ? responseData['data']
            : responseData;
        parsedData = fromJson != null ? fromJson(dataKey) : dataKey as T?;
      } else {
        parsedData = fromJson != null
            ? fromJson(responseData)
            : responseData as T?;
      }

      return ApiResponse._(
        data: parsedData,
        isSuccess: true,
        message: message,
        pagination: pagination,
        meta: meta,
      );
    } catch (e) {
      return ApiResponse._(
        isSuccess: false,
        error: ApiError(
          message: 'Failed to parse response: $e',
          code: 'PARSE_ERROR',
        ),
      );
    }
  }

  // ═══════════════════════════════════════════════════════════════
  // HELPER METHODS
  // ═══════════════════════════════════════════════════════════════

  static String? _extractMessage(dynamic data) {
    if (data is Map<String, dynamic>) {
      return data['message'] as String? ??
          data['error'] as String? ??
          data['msg'] as String?;
    }
    if (data is String) return data;
    return null;
  }

  static Map<String, List<String>>? _extractErrors(dynamic data) {
    if (data is Map<String, dynamic> && data.containsKey('errors')) {
      final errors = data['errors'];
      if (errors is Map<String, dynamic>) {
        return errors.map((key, value) {
          if (value is List) {
            return MapEntry(key, value.map((e) => e.toString()).toList());
          }
          return MapEntry(key, [value.toString()]);
        });
      }
    }
    return null;
  }

  /// Check if response has data
  bool get hasData => data != null;

  /// Check if response has pagination
  bool get hasPagination => pagination != null;

  /// Check if there are more pages
  bool get hasMorePages => pagination?.hasMore ?? false;

  /// Get error message
  String get errorMessage => error?.message ?? 'Unknown error occurred';

  /// Fold pattern for handling success/error
  R fold<R>({
    required R Function(T data) onSuccess,
    required R Function(ApiError error) onError,
  }) {
    if (isSuccess && data != null) {
      return onSuccess(data as T);
    }
    return onError(error ?? ApiError(message: 'Unknown error'));
  }

  /// Map data to another type
  ApiResponse<R> map<R>(R Function(T) mapper) {
    if (isSuccess && data != null) {
      return ApiResponse.success(
        mapper(data as T),
        pagination: pagination,
        meta: meta,
      );
    }
    return ApiResponse._(isSuccess: false, error: error);
  }
}

// ═══════════════════════════════════════════════════════════════
// API ERROR
// ═══════════════════════════════════════════════════════════════

class ApiError {
  final String message;
  final String? code;
  final int? statusCode;
  final Map<String, List<String>>? errors;

  const ApiError({
    required this.message,
    this.code,
    this.statusCode,
    this.errors,
  });

  factory ApiError.fromDioException(DioException exception) {
    String message;
    String code;
    int? statusCode = exception.response?.statusCode;

    switch (exception.type) {
      case DioExceptionType.connectionTimeout:
        message = 'Connection timeout. Please check your internet connection.';
        code = 'CONNECTION_TIMEOUT';
        break;
      case DioExceptionType.sendTimeout:
        message = 'Send timeout. Please try again.';
        code = 'SEND_TIMEOUT';
        break;
      case DioExceptionType.receiveTimeout:
        message = 'Server took too long to respond. Please try again.';
        code = 'RECEIVE_TIMEOUT';
        break;
      case DioExceptionType.badResponse:
        final response = exception.response;
        message =
            ApiResponse._extractMessage(response?.data) ??
            'Server error occurred (${statusCode ?? 'Unknown'})';
        code = 'BAD_RESPONSE';
        break;
      case DioExceptionType.cancel:
        message = 'Request was cancelled';
        code = 'CANCELLED';
        break;
      case DioExceptionType.connectionError:
        message = 'No internet connection. Please check your network.';
        code = 'CONNECTION_ERROR';
        break;
      case DioExceptionType.badCertificate:
        message = 'Security certificate error';
        code = 'BAD_CERTIFICATE';
        break;
      case DioExceptionType.unknown:
      default:
        message = exception.message ?? 'An unexpected error occurred';
        code = 'UNKNOWN';
    }

    return ApiError(
      message: message,
      code: code,
      statusCode: statusCode,
      errors: ApiResponse._extractErrors(exception.response?.data),
    );
  }

  /// Check if error is authentication related
  bool get isAuthError => statusCode == 401 || statusCode == 403;

  /// Check if error is validation related
  bool get isValidationError => statusCode == 422 || errors != null;

  /// Check if error is server error
  bool get isServerError => statusCode != null && statusCode! >= 500;

  /// Check if error is network related
  bool get isNetworkError =>
      code == 'CONNECTION_ERROR' || code == 'CONNECTION_TIMEOUT';

  @override
  String toString() => 'ApiError: $message (code: $code, status: $statusCode)';
}

// ═══════════════════════════════════════════════════════════════
// PAGINATION META
// ═══════════════════════════════════════════════════════════════

class PaginationMeta {
  final int currentPage;
  final int lastPage;
  final int perPage;
  final int total;

  const PaginationMeta({
    required this.currentPage,
    required this.lastPage,
    required this.perPage,
    required this.total,
  });

  factory PaginationMeta.fromJson(Map<String, dynamic> json) {
    return PaginationMeta(
      currentPage: json['current_page'] ?? json['page'] ?? 1,
      lastPage: json['last_page'] ?? json['totalPages'] ?? 1,
      perPage: json['per_page'] ?? json['limit'] ?? 20,
      total: json['total'] ?? json['totalItems'] ?? 0,
    );
  }

  bool get hasMore => currentPage < lastPage;
  bool get isFirstPage => currentPage == 1;
  bool get isLastPage => currentPage >= lastPage;
  int get nextPage => hasMore ? currentPage + 1 : currentPage;
  int get previousPage => currentPage > 1 ? currentPage - 1 : 1;

  Map<String, dynamic> toJson() => {
    'current_page': currentPage,
    'last_page': lastPage,
    'per_page': perPage,
    'total': total,
  };
}
