import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';

/// Service to handle Google Sign-In authentication
/// Uses google_sign_in v7.x API with GoogleSignIn.instance singleton
class GoogleSignInService {
  static GoogleSignInService? _instance;
  bool _initialized = false;

  GoogleSignInService._();

  /// Get singleton instance
  static GoogleSignInService get instance {
    _instance ??= GoogleSignInService._();
    return _instance!;
  }

  /// Initialize the Google Sign-In
  Future<void> _ensureInitialized() async {
    if (_initialized) return;

    try {
      await GoogleSignIn.instance.initialize(
        // For iOS/Android, client IDs come from GoogleService-Info.plist / google-services.json
        // For web, configure in index.html meta tag
      );
      _initialized = true;
    } catch (e) {
      debugPrint('Google Sign-In init error: $e');
      rethrow;
    }
  }

  /// Sign in with Google
  /// Returns the signed-in account or null if cancelled/failed
  Future<GoogleSignInAccount?> signIn() async {
    try {
      await _ensureInitialized();

      // Try lightweight (silent) sign-in first for returning users
      GoogleSignInAccount? account;

      final Future<GoogleSignInAccount?>? lightweightFuture = GoogleSignIn
          .instance
          .attemptLightweightAuthentication();

      if (lightweightFuture != null) {
        try {
          account = await lightweightFuture;
        } catch (_) {
          // Lightweight auth failed, will try full authentication
        }
      }

      // If lightweight fails, do full authentication
      account ??= await GoogleSignIn.instance.authenticate();

      if (account != null) {
        debugPrint('Google Sign-In successful: ${account.email}');
      }

      return account;
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
      await GoogleSignIn.instance.signOut();
      debugPrint('Google Sign-Out successful');
    } catch (e) {
      debugPrint('Google Sign-Out error: $e');
      rethrow;
    }
  }

  /// Get authentication info from account for backend API calls
  GoogleSignInAuthentication? getAuthentication(GoogleSignInAccount account) {
    return account.authentication;
  }
}
