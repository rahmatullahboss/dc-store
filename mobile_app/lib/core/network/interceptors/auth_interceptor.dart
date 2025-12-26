import 'package:dio/dio.dart';
import '../../constants/storage_keys.dart';
import '../../../services/storage_service.dart' show StorageService;

/// Auth Interceptor - Injects auth token and handles 401 responses
class AuthInterceptor extends Interceptor {
  final StorageService? storageService;
  final Future<String?> Function()? onRefreshToken;
  bool _isRefreshing = false;

  AuthInterceptor({this.storageService, this.onRefreshToken});

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    // Get auth token
    final token = storageService?.getString(StorageKeys.authToken);

    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }

    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    // Handle 401 Unauthorized
    if (err.response?.statusCode == 401 && !_isRefreshing) {
      _isRefreshing = true;

      try {
        // Try to refresh token
        final newToken = await onRefreshToken?.call();

        if (newToken != null) {
          // Retry original request with new token
          final options = err.requestOptions;
          options.headers['Authorization'] = 'Bearer $newToken';

          final dio = Dio();
          final response = await dio.fetch(options);

          _isRefreshing = false;
          return handler.resolve(response);
        }
      } catch (e) {
        // Refresh failed, clear tokens
        await storageService?.remove(StorageKeys.authToken);
        await storageService?.remove(StorageKeys.refreshToken);
      }

      _isRefreshing = false;
    }

    handler.next(err);
  }
}
