import 'dart:developer' as developer;
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

/// Logging Interceptor - Logs all HTTP requests and responses
class AppLoggingInterceptor extends Interceptor {
  final bool logRequest;
  final bool logResponse;
  final bool logError;
  final bool logHeaders;
  final bool logBody;

  AppLoggingInterceptor({
    this.logRequest = true,
    this.logResponse = true,
    this.logError = true,
    this.logHeaders = false,
    this.logBody = true,
  });

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (logRequest && kDebugMode) {
      _logRequest(options);
    }
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    if (logResponse && kDebugMode) {
      _logResponse(response);
    }
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (logError && kDebugMode) {
      _logError(err);
    }
    handler.next(err);
  }

  void _logRequest(RequestOptions options) {
    final buffer = StringBuffer();
    buffer.writeln(
      '┌──────────────────────────────────────────────────────────────',
    );
    buffer.writeln('│ 📤 REQUEST');
    buffer.writeln(
      '├──────────────────────────────────────────────────────────────',
    );
    buffer.writeln('│ ${options.method} ${options.uri}');

    if (logHeaders && options.headers.isNotEmpty) {
      buffer.writeln('│ Headers:');
      options.headers.forEach((key, value) {
        if (key != 'Authorization') {
          buffer.writeln('│   $key: $value');
        } else {
          buffer.writeln('│   $key: [HIDDEN]');
        }
      });
    }

    if (logBody && options.data != null) {
      buffer.writeln('│ Body: ${_truncate(options.data.toString())}');
    }

    if (options.queryParameters.isNotEmpty) {
      buffer.writeln('│ Query: ${options.queryParameters}');
    }

    buffer.writeln(
      '└──────────────────────────────────────────────────────────────',
    );

    developer.log(buffer.toString(), name: 'HTTP');
  }

  void _logResponse(Response response) {
    final buffer = StringBuffer();
    buffer.writeln(
      '┌──────────────────────────────────────────────────────────────',
    );
    buffer.writeln('│ 📥 RESPONSE');
    buffer.writeln(
      '├──────────────────────────────────────────────────────────────',
    );
    buffer.writeln(
      '│ ${response.statusCode} ${response.requestOptions.method} ${response.requestOptions.uri}',
    );
    buffer.writeln(
      '│ Time: ${response.requestOptions.extra['startTime'] != null ? '${DateTime.now().difference(response.requestOptions.extra['startTime'] as DateTime).inMilliseconds}ms' : 'N/A'}',
    );

    if (logBody && response.data != null) {
      buffer.writeln('│ Data: ${_truncate(response.data.toString())}');
    }

    buffer.writeln(
      '└──────────────────────────────────────────────────────────────',
    );

    developer.log(buffer.toString(), name: 'HTTP');
  }

  void _logError(DioException err) {
    final buffer = StringBuffer();
    buffer.writeln(
      '┌──────────────────────────────────────────────────────────────',
    );
    buffer.writeln('│ ❌ ERROR');
    buffer.writeln(
      '├──────────────────────────────────────────────────────────────',
    );
    buffer.writeln('│ ${err.requestOptions.method} ${err.requestOptions.uri}');
    buffer.writeln('│ Type: ${err.type}');
    buffer.writeln('│ Status: ${err.response?.statusCode ?? 'N/A'}');
    buffer.writeln('│ Message: ${err.message}');

    if (logBody && err.response?.data != null) {
      buffer.writeln('│ Response: ${_truncate(err.response!.data.toString())}');
    }

    buffer.writeln(
      '└──────────────────────────────────────────────────────────────',
    );

    developer.log(buffer.toString(), name: 'HTTP');
  }

  String _truncate(String text, [int maxLength = 500]) {
    if (text.length <= maxLength) return text;
    return '${text.substring(0, maxLength)}... [truncated]';
  }
}
