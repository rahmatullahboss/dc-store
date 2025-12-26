import 'package:dio/dio.dart';
import '../../errors/exceptions.dart';

/// Error Interceptor - Transforms DioExceptions to custom exceptions
class ErrorInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final exception = _mapException(err);

    // We still pass the DioException but attach our custom exception info
    err.requestOptions.extra['appException'] = exception;

    handler.next(err);
  }

  AppException _mapException(DioException err) {
    switch (err.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return NetworkException(
          message: 'Connection timed out. Please check your internet.',
          code: 'TIMEOUT',
        );

      case DioExceptionType.connectionError:
        return NetworkException(
          message: 'No internet connection. Please check your network.',
          code: 'NO_CONNECTION',
        );

      case DioExceptionType.badResponse:
        return _handleBadResponse(err.response);

      case DioExceptionType.cancel:
        return NetworkException(
          message: 'Request was cancelled',
          code: 'CANCELLED',
        );

      case DioExceptionType.badCertificate:
        return NetworkException(
          message: 'Security certificate error',
          code: 'BAD_CERTIFICATE',
        );

      case DioExceptionType.unknown:
      default:
        return ServerException(
          message: err.message ?? 'An unexpected error occurred',
          code: 'UNKNOWN',
        );
    }
  }

  AppException _handleBadResponse(Response? response) {
    final statusCode = response?.statusCode ?? 0;
    final data = response?.data;

    String message = 'Something went wrong';
    String code = 'SERVER_ERROR';
    Map<String, dynamic>? errors;

    // Extract error message from response
    if (data is Map<String, dynamic>) {
      message = data['message'] ?? data['error'] ?? message;
      errors = data['errors'] is Map<String, dynamic> ? data['errors'] : null;
    } else if (data is String) {
      message = data;
    }

    switch (statusCode) {
      case 400:
        return ValidationException(
          message: message,
          code: 'BAD_REQUEST',
          errors: errors,
        );

      case 401:
        return UnauthorizedException(
          message: 'Session expired. Please login again.',
          code: 'UNAUTHORIZED',
        );

      case 403:
        return UnauthorizedException(
          message: 'You don\'t have permission to access this resource.',
          code: 'FORBIDDEN',
        );

      case 404:
        return ServerException(
          message: 'The requested resource was not found.',
          code: 'NOT_FOUND',
          statusCode: statusCode,
        );

      case 422:
        return ValidationException(
          message: message,
          code: 'VALIDATION_ERROR',
          errors: errors,
        );

      case 429:
        return ServerException(
          message: 'Too many requests. Please try again later.',
          code: 'RATE_LIMITED',
          statusCode: statusCode,
        );

      case 500:
      case 502:
      case 503:
      case 504:
        return ServerException(
          message: 'Server error. Please try again later.',
          code: 'SERVER_ERROR',
          statusCode: statusCode,
        );

      default:
        return ServerException(
          message: message,
          code: code,
          statusCode: statusCode,
        );
    }
  }
}
