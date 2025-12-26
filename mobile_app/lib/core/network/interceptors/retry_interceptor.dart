import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

/// Retry Interceptor - Automatically retries failed requests
class RetryInterceptor extends Interceptor {
  final Dio dio;
  final int maxRetries;
  final Duration retryDelay;
  final List<int> retryableStatusCodes;

  RetryInterceptor({
    required this.dio,
    this.maxRetries = 3,
    this.retryDelay = const Duration(seconds: 1),
    this.retryableStatusCodes = const [408, 500, 502, 503, 504],
  });

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    // Get current retry count
    final retryCount = err.requestOptions.extra['retryCount'] ?? 0;

    // Check if we should retry
    if (_shouldRetry(err) && retryCount < maxRetries) {
      debugPrint(
        '🔄 Retrying request (${retryCount + 1}/$maxRetries): ${err.requestOptions.uri}',
      );

      // Wait before retrying
      await Future.delayed(retryDelay * (retryCount + 1));

      // Update retry count
      err.requestOptions.extra['retryCount'] = retryCount + 1;

      try {
        // Retry the request
        final response = await dio.fetch(err.requestOptions);
        return handler.resolve(response);
      } on DioException catch (e) {
        // If retry also failed, continue with the new error
        return handler.next(e);
      }
    }

    // Don't retry, pass the error
    handler.next(err);
  }

  bool _shouldRetry(DioException err) {
    // Don't retry if cancelled
    if (err.type == DioExceptionType.cancel) return false;

    // Retry on connection timeout
    if (err.type == DioExceptionType.connectionTimeout ||
        err.type == DioExceptionType.receiveTimeout) {
      return true;
    }

    // Retry on connection error (network issues)
    if (err.type == DioExceptionType.connectionError) {
      return true;
    }

    // Retry on specific status codes
    if (err.response != null &&
        retryableStatusCodes.contains(err.response!.statusCode)) {
      return true;
    }

    return false;
  }
}
