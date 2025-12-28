import 'package:flutter/foundation.dart';
import '../../../core/constants/api_constants.dart';
import '../../../core/constants/storage_keys.dart';
import '../../../core/network/dio_client.dart';
import '../../../services/storage_service.dart';
import '../domain/user_model.dart';

/// AuthRepository - Handles all authentication API calls
class AuthRepository {
  final DioClient _client;
  final StorageService _storage;

  AuthRepository({required DioClient client, required StorageService storage})
    : _client = client,
      _storage = storage;

  // ═══════════════════════════════════════════════════════════════
  // SIGN IN
  // ═══════════════════════════════════════════════════════════════

  /// Sign in with email and password
  Future<User?> signIn(String email, String password) async {
    try {
      final response = await _client.post<Map<String, dynamic>>(
        ApiConstants.login,
        data: {'email': email, 'password': password},
      );

      if (response.isSuccess && response.data != null) {
        final data = response.data!;

        // Better Auth returns user in 'user' field and token in 'token'
        final userData = data['user'] as Map<String, dynamic>?;
        final token = data['token'] as String?;

        if (userData != null) {
          // Save auth data
          await _saveAuthData(userData, token);
          return User.fromJson(userData);
        }
      }

      debugPrint('Sign in failed: ${response.errorMessage}');
      return null;
    } catch (e) {
      debugPrint('Sign in error: $e');
      return null;
    }
  }

  // ═══════════════════════════════════════════════════════════════
  // SIGN UP
  // ═══════════════════════════════════════════════════════════════

  /// Sign up with name, email and password
  Future<User?> signUp(String name, String email, String password) async {
    try {
      final response = await _client.post<Map<String, dynamic>>(
        ApiConstants.register,
        data: {'name': name, 'email': email, 'password': password},
      );

      if (response.isSuccess && response.data != null) {
        final data = response.data!;
        final userData = data['user'] as Map<String, dynamic>?;
        final token = data['token'] as String?;

        if (userData != null) {
          await _saveAuthData(userData, token);
          return User.fromJson(userData);
        }
      }

      debugPrint('Sign up failed: ${response.errorMessage}');
      return null;
    } catch (e) {
      debugPrint('Sign up error: $e');
      return null;
    }
  }

  // ═══════════════════════════════════════════════════════════════
  // SIGN OUT
  // ═══════════════════════════════════════════════════════════════

  /// Sign out and clear local storage
  Future<void> signOut() async {
    try {
      // Call logout API
      await _client.post(ApiConstants.logout);
    } catch (e) {
      debugPrint('Sign out API error: $e');
    } finally {
      // Always clear local data regardless of API success
      await _clearAuthData();
    }
  }

  // ═══════════════════════════════════════════════════════════════
  // SESSION MANAGEMENT
  // ═══════════════════════════════════════════════════════════════

  /// Get current session (check if user is logged in)
  Future<User?> getSession() async {
    try {
      // First check if we have a stored token
      final token = _storage.getString(StorageKeys.authToken);
      if (token == null || token.isEmpty) {
        return null;
      }

      // Check if this is a Google Sign-In session (uses local token)
      // Google Sign-In tokens start with 'google_signin_token_'
      if (token.startsWith('google_signin_token_')) {
        // For Google Sign-In, use cached user directly
        // No need to validate with server as this is a social login
        final cachedUser = _getCachedUser();
        if (cachedUser != null) {
          debugPrint('Google Sign-In session restored from cache');
          return cachedUser;
        }
        // If no cached user, session is invalid
        await _clearAuthData();
        return null;
      }

      // For email/password login, validate session with server
      final response = await _client.get<Map<String, dynamic>>(
        ApiConstants.getSession,
      );

      if (response.isSuccess && response.data != null) {
        final data = response.data!;
        final userData = data['user'] as Map<String, dynamic>?;

        if (userData != null) {
          // Update stored user data
          await _saveUserData(userData);
          return User.fromJson(userData);
        }
      }

      // Session invalid, clear local data
      await _clearAuthData();
      return null;
    } catch (e) {
      debugPrint('Get session error: $e');
      // Try to return cached user if available (for offline mode)
      return _getCachedUser();
    }
  }

  /// Get cached user from local storage (for offline mode)
  User? _getCachedUser() {
    final userId = _storage.getString(StorageKeys.userId);
    final userEmail = _storage.getString(StorageKeys.userEmail);
    final userName = _storage.getString(StorageKeys.userName);
    final userAvatar = _storage.getString(StorageKeys.userAvatar);

    if (userId != null && userEmail != null) {
      return User(
        id: userId,
        email: userEmail,
        name: userName,
        image: userAvatar,
      );
    }
    return null;
  }

  // ═══════════════════════════════════════════════════════════════
  // STORAGE HELPERS
  // ═══════════════════════════════════════════════════════════════

  /// Save authentication data to local storage
  Future<void> _saveAuthData(
    Map<String, dynamic> userData,
    String? token,
  ) async {
    if (token != null) {
      await _storage.setString(StorageKeys.authToken, token);
    }
    await _saveUserData(userData);
    await _storage.setBool(StorageKeys.isLoggedIn, true);
  }

  /// Save user data to local storage
  Future<void> _saveUserData(Map<String, dynamic> userData) async {
    final id = userData['id'] as String?;
    final email = userData['email'] as String?;
    final name = userData['name'] as String?;
    final image = userData['image'] as String?;

    if (id != null) await _storage.setString(StorageKeys.userId, id);
    if (email != null) await _storage.setString(StorageKeys.userEmail, email);
    if (name != null) await _storage.setString(StorageKeys.userName, name);
    if (image != null) await _storage.setString(StorageKeys.userAvatar, image);
  }

  /// Clear all auth data from local storage
  Future<void> _clearAuthData() async {
    await _storage.remove(StorageKeys.authToken);
    await _storage.remove(StorageKeys.refreshToken);
    await _storage.remove(StorageKeys.userId);
    await _storage.remove(StorageKeys.userEmail);
    await _storage.remove(StorageKeys.userName);
    await _storage.remove(StorageKeys.userAvatar);
    await _storage.setBool(StorageKeys.isLoggedIn, false);
  }
}
