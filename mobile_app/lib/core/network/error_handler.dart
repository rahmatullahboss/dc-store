import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../errors/exceptions.dart';

/// Error Handler - Centralized error parsing and user-friendly messages
class ErrorHandler {
  ErrorHandler._();

  /// Parse any error into AppException
  static AppException parse(dynamic error) {
    if (error is AppException) {
      return error;
    }

    if (error is DioException) {
      return _parseDioException(error);
    }

    if (error is FormatException) {
      return ParseException.invalidJson();
    }

    if (error is TypeError) {
      return ParseException.invalidData();
    }

    return ServerException(
      message: error?.toString() ?? 'An unexpected error occurred',
      code: 'UNKNOWN',
      originalError: error,
    );
  }

  /// Parse DioException
  static AppException _parseDioException(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return NetworkException.timeout();

      case DioExceptionType.connectionError:
        return NetworkException.noConnection();

      case DioExceptionType.cancel:
        return NetworkException.cancelled();

      case DioExceptionType.badResponse:
        return _parseResponseError(error.response);

      case DioExceptionType.badCertificate:
        return const NetworkException(
          message: 'Security certificate error',
          code: 'BAD_CERTIFICATE',
        );

      case DioExceptionType.unknown:
      default:
        return ServerException(
          message: error.message ?? 'An error occurred',
          code: 'UNKNOWN',
          originalError: error,
        );
    }
  }

  /// Parse response error
  static AppException _parseResponseError(Response? response) {
    final statusCode = response?.statusCode ?? 0;
    final data = response?.data;

    String message = 'Something went wrong';
    Map<String, dynamic>? errors;

    if (data is Map<String, dynamic>) {
      message = data['message'] ?? data['error'] ?? message;
      if (data['errors'] is Map<String, dynamic>) {
        errors = data['errors'];
      }
    } else if (data is String && data.isNotEmpty) {
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
        return UnauthorizedException.sessionExpired();

      case 403:
        return UnauthorizedException.forbidden();

      case 404:
        return ServerException.notFound();

      case 422:
        return ValidationException(
          message: message,
          code: 'VALIDATION_ERROR',
          errors: errors,
        );

      case 429:
        return const ServerException(
          message: 'Too many requests. Please try again later.',
          code: 'RATE_LIMITED',
          statusCode: 429,
        );

      case 500:
      case 502:
      case 503:
      case 504:
        return ServerException.serviceUnavailable();

      default:
        return ServerException(
          message: message,
          code: 'SERVER_ERROR',
          statusCode: statusCode,
        );
    }
  }

  /// Get user-friendly error message
  static String getUserMessage(dynamic error) {
    final exception = parse(error);
    return exception.message;
  }

  /// Log error for debugging
  static void log(dynamic error, {String? context}) {
    if (kDebugMode) {
      final exception = parse(error);
      debugPrint('══════════════════════════════════════════');
      if (context != null) {
        debugPrint('Context: $context');
      }
      debugPrint('Error: ${exception.runtimeType}');
      debugPrint('Message: ${exception.message}');
      debugPrint('Code: ${exception.code}');
      if (exception.originalError != null) {
        debugPrint('Original: ${exception.originalError}');
      }
      debugPrint('══════════════════════════════════════════');
    }
  }

  /// Check if error is network related
  static bool isNetworkError(dynamic error) {
    final exception = parse(error);
    return exception is NetworkException;
  }

  /// Check if error requires re-authentication
  static bool isAuthError(dynamic error) {
    final exception = parse(error);
    return exception is UnauthorizedException;
  }

  /// Check if error is validation related
  static bool isValidationError(dynamic error) {
    final exception = parse(error);
    return exception is ValidationException;
  }
}
