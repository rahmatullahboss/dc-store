import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';

/// Service to handle Google Sign-In authentication
class GoogleSignInService {
  static GoogleSignInService? _instance;
  late final GoogleSignIn _googleSignIn;

  GoogleSignInService._() {
    _googleSignIn = GoogleSignIn(
      scopes: ['email', 'profile'],
      // For web, the client ID should be configured in index.html meta tag
      // For iOS/Android, it comes from GoogleService-Info.plist / google-services.json
    );
  }

  /// Get singleton instance
  static GoogleSignInService get instance {
    _instance ??= GoogleSignInService._();
    return _instance!;
  }

  /// Get the current signed-in user (if any)
  GoogleSignInAccount? get currentUser => _googleSignIn.currentUser;

  /// Sign in with Google
  /// Returns the signed-in account or null if cancelled/failed
  Future<GoogleSignInAccount?> signIn() async {
    try {
      // Try silent sign-in first (for returning users)
      GoogleSignInAccount? account = await _googleSignIn.signInSilently();

      // If silent sign-in fails, show the sign-in dialog
      account ??= await _googleSignIn.signIn();

      if (account != null) {
        debugPrint('Google Sign-In successful: ${account.email}');
      }

      return account;
    } on Exception catch (e) {
      debugPrint('Google Sign-In error: $e');
      rethrow;
    }
  }

  /// Sign out from Google
  Future<void> signOut() async {
    try {
      await _googleSignIn.signOut();
      debugPrint('Google Sign-Out successful');
    } on Exception catch (e) {
      debugPrint('Google Sign-Out error: $e');
      rethrow;
    }
  }

  /// Disconnect (revoke access)
  Future<void> disconnect() async {
    try {
      await _googleSignIn.disconnect();
      debugPrint('Google disconnect successful');
    } on Exception catch (e) {
      debugPrint('Google disconnect error: $e');
      rethrow;
    }
  }

  /// Check if user is currently signed in
  Future<bool> isSignedIn() async {
    return _googleSignIn.isSignedIn();
  }

  /// Get authentication tokens for backend API calls
  Future<GoogleSignInAuthentication?> getAuthentication() async {
    final account = _googleSignIn.currentUser;
    if (account == null) return null;
    return await account.authentication;
  }
}
