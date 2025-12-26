/// Custom App Exceptions for Error Handling
/// Provides structured error handling across the application
library;

/// Base exception class
abstract class AppException implements Exception {
  final String message;
  final String? code;
  final dynamic originalError;

  const AppException({required this.message, this.code, this.originalError});

  @override
  String toString() => '$runtimeType: $message (code: $code)';
}

/// Server/API related errors
class ServerException extends AppException {
  final int? statusCode;

  const ServerException({
    required super.message,
    super.code,
    super.originalError,
    this.statusCode,
  });

  factory ServerException.unknown() => const ServerException(
    message: 'An unexpected error occurred',
    code: 'UNKNOWN',
  );

  factory ServerException.timeout() => const ServerException(
    message: 'Server took too long to respond',
    code: 'TIMEOUT',
  );

  factory ServerException.notFound() => const ServerException(
    message: 'The requested resource was not found',
    code: 'NOT_FOUND',
    statusCode: 404,
  );

  factory ServerException.serviceUnavailable() => const ServerException(
    message: 'Service is temporarily unavailable',
    code: 'SERVICE_UNAVAILABLE',
    statusCode: 503,
  );
}

/// Network connectivity errors
class NetworkException extends AppException {
  const NetworkException({
    required super.message,
    super.code,
    super.originalError,
  });

  factory NetworkException.noConnection() => const NetworkException(
    message: 'No internet connection. Please check your network.',
    code: 'NO_CONNECTION',
  );

  factory NetworkException.timeout() => const NetworkException(
    message: 'Connection timed out. Please try again.',
    code: 'TIMEOUT',
  );

  factory NetworkException.cancelled() => const NetworkException(
    message: 'Request was cancelled',
    code: 'CANCELLED',
  );
}

/// Cache related errors
class CacheException extends AppException {
  const CacheException({
    required super.message,
    super.code,
    super.originalError,
  });

  factory CacheException.notFound() => const CacheException(
    message: 'No cached data found',
    code: 'CACHE_NOT_FOUND',
  );

  factory CacheException.expired() => const CacheException(
    message: 'Cached data has expired',
    code: 'CACHE_EXPIRED',
  );

  factory CacheException.writeError() => const CacheException(
    message: 'Failed to write to cache',
    code: 'CACHE_WRITE_ERROR',
  );

  factory CacheException.readError() => const CacheException(
    message: 'Failed to read from cache',
    code: 'CACHE_READ_ERROR',
  );
}

/// Authentication/Authorization errors
class UnauthorizedException extends AppException {
  const UnauthorizedException({
    required super.message,
    super.code,
    super.originalError,
  });

  factory UnauthorizedException.sessionExpired() => const UnauthorizedException(
    message: 'Your session has expired. Please login again.',
    code: 'SESSION_EXPIRED',
  );

  factory UnauthorizedException.invalidCredentials() =>
      const UnauthorizedException(
        message: 'Invalid email or password',
        code: 'INVALID_CREDENTIALS',
      );

  factory UnauthorizedException.forbidden() => const UnauthorizedException(
    message: 'You don\'t have permission to access this resource',
    code: 'FORBIDDEN',
  );

  factory UnauthorizedException.tokenInvalid() => const UnauthorizedException(
    message: 'Authentication token is invalid',
    code: 'TOKEN_INVALID',
  );
}

/// Validation errors
class ValidationException extends AppException {
  final Map<String, dynamic>? errors;

  const ValidationException({
    required super.message,
    super.code,
    super.originalError,
    this.errors,
  });

  factory ValidationException.invalidInput(String field, String message) =>
      ValidationException(
        message: message,
        code: 'INVALID_INPUT',
        errors: {
          field: [message],
        },
      );

  factory ValidationException.requiredField(String field) =>
      ValidationException(
        message: '$field is required',
        code: 'REQUIRED_FIELD',
        errors: {
          field: ['This field is required'],
        },
      );

  /// Get first error message for a field
  String? getFieldError(String field) {
    if (errors == null) return null;
    final fieldErrors = errors![field];
    if (fieldErrors is List && fieldErrors.isNotEmpty) {
      return fieldErrors.first.toString();
    }
    return null;
  }

  /// Get all error messages as a list
  List<String> get allErrors {
    if (errors == null) return [message];
    return errors!.values
        .expand((v) => v is List ? v.map((e) => e.toString()) : [v.toString()])
        .toList();
  }
}

/// Local storage errors
class StorageException extends AppException {
  const StorageException({
    required super.message,
    super.code,
    super.originalError,
  });

  factory StorageException.readError() => const StorageException(
    message: 'Failed to read from storage',
    code: 'STORAGE_READ_ERROR',
  );

  factory StorageException.writeError() => const StorageException(
    message: 'Failed to write to storage',
    code: 'STORAGE_WRITE_ERROR',
  );
}

/// Parse/Format errors
class ParseException extends AppException {
  const ParseException({
    required super.message,
    super.code,
    super.originalError,
  });

  factory ParseException.invalidJson() => const ParseException(
    message: 'Invalid JSON format',
    code: 'INVALID_JSON',
  );

  factory ParseException.invalidData() => const ParseException(
    message: 'Failed to parse data',
    code: 'PARSE_ERROR',
  );
}
