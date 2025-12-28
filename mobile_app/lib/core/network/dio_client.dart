import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../constants/api_constants.dart';
import '../constants/storage_keys.dart';
import '../../services/storage_service.dart' show StorageService;
import 'api_response.dart';
import 'interceptors/auth_interceptor.dart';
import 'interceptors/logging_interceptor.dart';
import 'interceptors/error_interceptor.dart';
import 'interceptors/retry_interceptor.dart';

/// DioClient - Centralized HTTP client for all API calls
/// Features: Auth injection, retry logic, logging, error handling
class DioClient {
  late final Dio _dio;
  final StorageService? _storageService;

  DioClient({StorageService? storageService})
    : _storageService = storageService {
    _dio = Dio(_baseOptions);
    _setupInterceptors();
  }

  // ═══════════════════════════════════════════════════════════════
  // BASE CONFIGURATION
  // ═══════════════════════════════════════════════════════════════

  BaseOptions get _baseOptions => BaseOptions(
    baseUrl: ApiConstants.baseUrl,
    connectTimeout: Duration(milliseconds: ApiConstants.connectTimeout),
    receiveTimeout: Duration(milliseconds: ApiConstants.receiveTimeout),
    sendTimeout: Duration(milliseconds: ApiConstants.sendTimeout),
    headers: {'Content-Type': 'application/json', 'Accept': 'application/json'},
    validateStatus: (status) => status != null && status < 500,
  );

  // ═══════════════════════════════════════════════════════════════
  // INTERCEPTORS SETUP
  // ═══════════════════════════════════════════════════════════════

  void _setupInterceptors() {
    // Auth interceptor - add token to requests
    _dio.interceptors.add(
      AuthInterceptor(
        storageService: _storageService,
        onRefreshToken: _refreshToken,
      ),
    );

    // Retry interceptor - retry failed requests
    _dio.interceptors.add(RetryInterceptor(dio: _dio));

    // Error interceptor - handle errors
    _dio.interceptors.add(ErrorInterceptor());

    // Logging interceptor (only in debug mode)
    if (kDebugMode) {
      _dio.interceptors.add(AppLoggingInterceptor());
    }
  }

  // ═══════════════════════════════════════════════════════════════
  // TOKEN REFRESH LOGIC
  // ═══════════════════════════════════════════════════════════════

  Future<String?> _refreshToken() async {
    try {
      final refreshToken = _storageService?.getString(StorageKeys.refreshToken);
      if (refreshToken == null) return null;

      final response = await Dio(
        _baseOptions,
      ).post(ApiConstants.refreshToken, data: {'refreshToken': refreshToken});

      if (response.statusCode == 200) {
        final newToken = response.data['token'] as String?;
        final newRefreshToken = response.data['refreshToken'] as String?;

        if (newToken != null) {
          await _storageService?.setString(StorageKeys.authToken, newToken);
        }
        if (newRefreshToken != null) {
          await _storageService?.setString(
            StorageKeys.refreshToken,
            newRefreshToken,
          );
        }

        return newToken;
      }
    } catch (e) {
      debugPrint('Token refresh failed: $e');
    }
    return null;
  }

  // ═══════════════════════════════════════════════════════════════
  // HTTP METHODS
  // ═══════════════════════════════════════════════════════════════

  /// GET request
  Future<ApiResponse<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    T Function(dynamic)? fromJson,
  }) async {
    try {
      final response = await _dio.get(
        path,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
      return ApiResponse.fromResponse(response, fromJson: fromJson);
    } on DioException catch (e) {
      return ApiResponse.error(e);
    }
  }

  /// POST request
  Future<ApiResponse<T>> post<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    T Function(dynamic)? fromJson,
  }) async {
    try {
      final response = await _dio.post(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
      return ApiResponse.fromResponse(response, fromJson: fromJson);
    } on DioException catch (e) {
      return ApiResponse.error(e);
    }
  }

  /// PUT request
  Future<ApiResponse<T>> put<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    T Function(dynamic)? fromJson,
  }) async {
    try {
      final response = await _dio.put(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
      return ApiResponse.fromResponse(response, fromJson: fromJson);
    } on DioException catch (e) {
      return ApiResponse.error(e);
    }
  }

  /// PATCH request
  Future<ApiResponse<T>> patch<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    T Function(dynamic)? fromJson,
  }) async {
    try {
      final response = await _dio.patch(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
      return ApiResponse.fromResponse(response, fromJson: fromJson);
    } on DioException catch (e) {
      return ApiResponse.error(e);
    }
  }

  /// DELETE request
  Future<ApiResponse<T>> delete<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    T Function(dynamic)? fromJson,
  }) async {
    try {
      final response = await _dio.delete(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
      return ApiResponse.fromResponse(response, fromJson: fromJson);
    } on DioException catch (e) {
      return ApiResponse.error(e);
    }
  }

  /// Upload file with progress
  Future<ApiResponse<T>> upload<T>(
    String path, {
    required FormData data,
    Options? options,
    CancelToken? cancelToken,
    void Function(int, int)? onSendProgress,
    T Function(dynamic)? fromJson,
  }) async {
    try {
      final response = await _dio.post(
        path,
        data: data,
        options: options?.copyWith(
          sendTimeout: Duration(milliseconds: ApiConstants.uploadTimeout),
        ),
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
      );
      return ApiResponse.fromResponse(response, fromJson: fromJson);
    } on DioException catch (e) {
      return ApiResponse.error(e);
    }
  }

  /// Download file with progress
  Future<ApiResponse<String>> download(
    String urlPath,
    String savePath, {
    Options? options,
    CancelToken? cancelToken,
    void Function(int, int)? onReceiveProgress,
  }) async {
    try {
      await _dio.download(
        urlPath,
        savePath,
        options: options,
        cancelToken: cancelToken,
        onReceiveProgress: onReceiveProgress,
      );
      return ApiResponse.success(savePath);
    } on DioException catch (e) {
      return ApiResponse.error(e);
    }
  }

  /// Get Dio instance for advanced usage
  Dio get dio => _dio;
}

// ═══════════════════════════════════════════════════════════════
// PROVIDER
// ═══════════════════════════════════════════════════════════════

/// Storage service provider - initialized in main.dart
final storageServiceProvider = Provider<StorageService?>((ref) {
  // This will be overridden in main.dart with the actual instance
  return null;
});

final dioClientProvider = Provider<DioClient>((ref) {
  final storage = ref.watch(storageServiceProvider);
  return DioClient(storageService: storage);
});
