import 'package:flutter/foundation.dart';
import 'package:google_sign_in_platform_interface/google_sign_in_platform_interface.dart';

/// Service to handle Google Sign-In authentication
/// Uses google_sign_in v7.x platform interface API
class GoogleSignInService {
  static GoogleSignInService? _instance;
  bool _initialized = false;

  GoogleSignInService._();

  /// Get singleton instance
  static GoogleSignInService get instance {
    _instance ??= GoogleSignInService._();
    return _instance!;
  }

  /// Initialize the Google Sign-In platform
  Future<void> _ensureInitialized() async {
    if (_initialized) return;

    try {
      await GoogleSignInPlatform.instance.init(
        const InitParameters(scopes: ['email', 'profile']),
      );
      _initialized = true;
    } catch (e) {
      debugPrint('Google Sign-In init error: $e');
      rethrow;
    }
  }

  /// Sign in with Google
  /// Returns the signed-in user data or null if cancelled/failed
  Future<GoogleSignInUserData?> signIn() async {
    try {
      await _ensureInitialized();

      // Try silent sign-in first (for returning users)
      GoogleSignInUserData? user;
      try {
        user = await GoogleSignInPlatform.instance.signInSilently();
      } catch (_) {
        // Silent sign-in failed, will try interactive sign-in
      }

      // If silent sign-in fails, show the sign-in dialog
      if (user == null) {
        user = await GoogleSignInPlatform.instance.signIn();
      }

      if (user != null) {
        debugPrint('Google Sign-In successful: ${user.email}');
      }

      return user;
    } on GoogleSignInException catch (e) {
      debugPrint('Google Sign-In error: ${e.code} - ${e.description}');
      rethrow;
    } catch (e) {
      debugPrint('Google Sign-In error: $e');
      rethrow;
    }
  }

  /// Sign out from Google
  Future<void> signOut() async {
    try {
      await _ensureInitialized();
      await GoogleSignInPlatform.instance.signOut();
      debugPrint('Google Sign-Out successful');
    } catch (e) {
      debugPrint('Google Sign-Out error: $e');
      rethrow;
    }
  }

  /// Disconnect (revoke access)
  Future<void> disconnect() async {
    try {
      await _ensureInitialized();
      await GoogleSignInPlatform.instance.disconnect();
      debugPrint('Google disconnect successful');
    } catch (e) {
      debugPrint('Google disconnect error: $e');
      rethrow;
    }
  }

  /// Check if user is currently signed in
  Future<bool> isSignedIn() async {
    try {
      await _ensureInitialized();
      return await GoogleSignInPlatform.instance.isSignedIn();
    } catch (_) {
      return false;
    }
  }

  /// Get current user (if signed in)
  Future<GoogleSignInUserData?> getCurrentUser() async {
    try {
      await _ensureInitialized();
      // Try silent sign-in to get current user
      return await GoogleSignInPlatform.instance.signInSilently();
    } catch (_) {
      return null;
    }
  }
}
