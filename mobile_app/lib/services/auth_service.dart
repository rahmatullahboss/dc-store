import 'package:flutter/foundation.dart';
import 'package:local_auth/local_auth.dart';
import '../core/constants/api_constants.dart';
import '../core/constants/storage_keys.dart';
import '../core/network/dio_client.dart';
import '../core/network/api_response.dart';
import '../data/models/user/user_model.dart';
import 'storage_service.dart';

/// AuthService - Handles authentication operations
class AuthService {
  static AuthService? _instance;
  final DioClient _dioClient;
  final StorageService _storageService;

  AuthService._({
    required DioClient dioClient,
    required StorageService storageService,
  }) : _dioClient = dioClient,
       _storageService = storageService;

  static Future<AuthService> getInstance({
    required DioClient dioClient,
    required StorageService storageService,
  }) async {
    _instance ??= AuthService._(
      dioClient: dioClient,
      storageService: storageService,
    );
    return _instance!;
  }

  // ═══════════════════════════════════════════════════════════════
  // AUTHENTICATION
  // ═══════════════════════════════════════════════════════════════

  /// Login with email and password
  Future<ApiResponse<AuthResponseModel>> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _dioClient.post<AuthResponseModel>(
        ApiConstants.login,
        data: {'email': email, 'password': password},
        fromJson: (json) => AuthResponseModel.fromJson(json),
      );

      if (response.isSuccess && response.data != null) {
        await _saveAuthData(response.data!);
      }

      return response;
    } catch (e) {
      return ApiResponse.fromMessage(e.toString());
    }
  }

  /// Register new user
  Future<ApiResponse<AuthResponseModel>> register({
    required String name,
    required String email,
    required String password,
    String? phone,
  }) async {
    try {
      final response = await _dioClient.post<AuthResponseModel>(
        ApiConstants.register,
        data: {
          'name': name,
          'email': email,
          'password': password,
          if (phone != null) 'phone': phone,
        },
        fromJson: (json) => AuthResponseModel.fromJson(json),
      );

      if (response.isSuccess && response.data != null) {
        await _saveAuthData(response.data!);
      }

      return response;
    } catch (e) {
      return ApiResponse.fromMessage(e.toString());
    }
  }

  /// Logout
  Future<void> logout() async {
    try {
      // Call logout API (optional, fire and forget)
      await _dioClient.post(ApiConstants.logout);
    } catch (e) {
      debugPrint('Logout API error: $e');
    } finally {
      await _clearAuthData();
    }
  }

  /// Forgot password
  Future<ApiResponse<void>> forgotPassword(String email) async {
    try {
      return await _dioClient.post(
        ApiConstants.forgotPassword,
        data: {'email': email},
      );
    } catch (e) {
      return ApiResponse.fromMessage(e.toString());
    }
  }

  /// Reset password
  Future<ApiResponse<void>> resetPassword({
    required String token,
    required String newPassword,
  }) async {
    try {
      return await _dioClient.post(
        ApiConstants.resetPassword,
        data: {'token': token, 'password': newPassword},
      );
    } catch (e) {
      return ApiResponse.fromMessage(e.toString());
    }
  }

  /// Verify OTP
  Future<ApiResponse<void>> verifyOtp({
    required String email,
    required String otp,
  }) async {
    try {
      return await _dioClient.post(
        ApiConstants.verifyOtp,
        data: {'email': email, 'otp': otp},
      );
    } catch (e) {
      return ApiResponse.fromMessage(e.toString());
    }
  }

  // ═══════════════════════════════════════════════════════════════
  // TOKEN MANAGEMENT
  // ═══════════════════════════════════════════════════════════════

  /// Get current access token
  String? get accessToken => _storageService.getString(StorageKeys.authToken);

  /// Get refresh token
  String? get refreshToken =>
      _storageService.getString(StorageKeys.refreshToken);

  /// Check if user is authenticated
  bool get isAuthenticated => accessToken != null && accessToken!.isNotEmpty;

  /// Refresh access token
  Future<bool> refreshAccessToken() async {
    final currentRefreshToken = refreshToken;
    if (currentRefreshToken == null) return false;

    try {
      final response = await _dioClient.post<Map<String, dynamic>>(
        ApiConstants.refreshToken,
        data: {'refresh_token': currentRefreshToken},
      );

      if (response.isSuccess && response.data != null) {
        final newAccessToken = response.data!['access_token'] as String?;
        final newRefreshToken = response.data!['refresh_token'] as String?;

        if (newAccessToken != null) {
          await _storageService.setString(
            StorageKeys.authToken,
            newAccessToken,
          );
        }
        if (newRefreshToken != null) {
          await _storageService.setString(
            StorageKeys.refreshToken,
            newRefreshToken,
          );
        }
        return true;
      }
      return false;
    } catch (e) {
      debugPrint('Token refresh error: $e');
      return false;
    }
  }

  // ═══════════════════════════════════════════════════════════════
  // SESSION HANDLING
  // ═══════════════════════════════════════════════════════════════

  /// Get current user from storage
  UserModel? getCurrentUser() {
    final userId = _storageService.getString(StorageKeys.userId);
    final userEmail = _storageService.getString(StorageKeys.userEmail);
    final userName = _storageService.getString(StorageKeys.userName);

    if (userId == null || userEmail == null) return null;

    return UserModel(id: userId, email: userEmail, name: userName);
  }

  /// Fetch current user profile from API
  Future<ApiResponse<UserModel>> fetchUserProfile() async {
    try {
      return await _dioClient.get<UserModel>(
        ApiConstants.userProfile,
        fromJson: (json) => UserModel.fromJson(json),
      );
    } catch (e) {
      return ApiResponse.fromMessage(e.toString());
    }
  }

  /// Update user session
  Future<void> updateSession(UserModel user) async {
    await _storageService.setString(StorageKeys.userId, user.id);
    await _storageService.setString(StorageKeys.userEmail, user.email);
    if (user.name != null) {
      await _storageService.setString(StorageKeys.userName, user.name!);
    }
  }

  // ═══════════════════════════════════════════════════════════════
  // BIOMETRIC AUTH (using local_auth package)
  // ═══════════════════════════════════════════════════════════════

  /// Check if biometric is available
  Future<bool> isBiometricAvailable() async {
    try {
      final LocalAuthentication localAuth = LocalAuthentication();
      final canAuthenticateWithBiometrics = await localAuth.canCheckBiometrics;
      final canAuthenticate =
          canAuthenticateWithBiometrics || await localAuth.isDeviceSupported();
      return canAuthenticate;
    } catch (e) {
      debugPrint('Error checking biometric availability: $e');
      return false;
    }
  }

  /// Get available biometric types
  Future<List<BiometricType>> getAvailableBiometrics() async {
    try {
      final LocalAuthentication localAuth = LocalAuthentication();
      return await localAuth.getAvailableBiometrics();
    } catch (e) {
      debugPrint('Error getting available biometrics: $e');
      return [];
    }
  }

  /// Authenticate with biometrics
  Future<bool> authenticateWithBiometrics({
    String reason = 'Please authenticate to continue',
  }) async {
    try {
      final LocalAuthentication localAuth = LocalAuthentication();
      final authenticated = await localAuth.authenticate(
        localizedReason: reason,
      );
      return authenticated;
    } catch (e) {
      debugPrint('Error during biometric authentication: $e');
      return false;
    }
  }

  /// Enable biometric login
  Future<void> enableBiometricLogin() async {
    await _storageService.setBool(StorageKeys.biometricEnabled, true);
  }

  /// Disable biometric login
  Future<void> disableBiometricLogin() async {
    await _storageService.setBool(StorageKeys.biometricEnabled, false);
  }

  /// Check if biometric login is enabled
  bool get isBiometricEnabled =>
      _storageService.getBool(StorageKeys.biometricEnabled) ?? false;

  // ═══════════════════════════════════════════════════════════════
  // PRIVATE HELPERS
  // ═══════════════════════════════════════════════════════════════

  Future<void> _saveAuthData(AuthResponseModel authResponse) async {
    await _storageService.setString(
      StorageKeys.authToken,
      authResponse.tokens.accessToken,
    );
    if (authResponse.tokens.refreshToken != null) {
      await _storageService.setString(
        StorageKeys.refreshToken,
        authResponse.tokens.refreshToken!,
      );
    }
    await updateSession(authResponse.user);
  }

  Future<void> _clearAuthData() async {
    await _storageService.remove(StorageKeys.authToken);
    await _storageService.remove(StorageKeys.refreshToken);
    await _storageService.remove(StorageKeys.userId);
    await _storageService.remove(StorageKeys.userEmail);
    await _storageService.remove(StorageKeys.userName);
  }
}
