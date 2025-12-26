import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../services/google_sign_in_service.dart';
import '../../domain/user_model.dart';

class AuthState {
  final User? user;
  final bool isLoading;
  final String? error;

  AuthState({this.user, this.isLoading = false, this.error});

  bool get isAuthenticated => user != null;
}

class AuthController extends Notifier<AuthState> {
  @override
  AuthState build() {
    return AuthState();
  }

  Future<bool> login(String email, String password) async {
    state = AuthState(isLoading: true);
    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 1));

      // Mock login success
      if (email.isNotEmpty && password.length >= 6) {
        state = AuthState(
          user: User(id: 'user_123', email: email, name: email.split('@')[0]),
        );
        return true;
      } else {
        state = AuthState(error: 'Invalid credentials');
        return false;
      }
    } catch (e) {
      state = AuthState(error: e.toString());
      return false;
    }
  }

  Future<bool> register(String name, String email, String password) async {
    state = AuthState(isLoading: true);
    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 1));

      // Mock registration success
      state = AuthState(
        user: User(
          id: 'user_${DateTime.now().millisecondsSinceEpoch}',
          email: email,
          name: name,
        ),
      );
      return true;
    } catch (e) {
      state = AuthState(error: e.toString());
      return false;
    }
  }

  /// Sign in with Google
  Future<bool> signInWithGoogle() async {
    state = AuthState(isLoading: true);
    try {
      final googleService = GoogleSignInService.instance;
      final account = await googleService.signIn();

      if (account != null) {
        // Create user from Google account data
        state = AuthState(
          user: User(
            id: account.id,
            email: account.email,
            name: account.displayName ?? account.email.split('@')[0],
            image: account.photoUrl,
          ),
        );
        return true;
      } else {
        // User cancelled the sign-in
        state = AuthState(error: 'Sign-in cancelled');
        return false;
      }
    } catch (e) {
      state = AuthState(error: 'Google Sign-In failed: ${e.toString()}');
      return false;
    }
  }

  void logout() {
    // Also sign out from Google
    GoogleSignInService.instance.signOut();
    state = AuthState();
  }
}

final authControllerProvider = NotifierProvider<AuthController, AuthState>(
  AuthController.new,
);
