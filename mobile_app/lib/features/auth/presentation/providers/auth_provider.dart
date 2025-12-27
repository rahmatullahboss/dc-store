import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/network/dio_client.dart';
import '../../../../services/google_sign_in_service.dart';
import '../../../../services/storage_service.dart';
import '../../data/auth_repository.dart';
import '../../domain/user_model.dart';

/// Authentication state
class AuthState {
  final User? user;
  final bool isLoading;
  final String? error;
  final bool isInitialized;

  AuthState({
    this.user,
    this.isLoading = false,
    this.error,
    this.isInitialized = false,
  });

  bool get isAuthenticated => user != null;

  AuthState copyWith({
    User? user,
    bool? isLoading,
    String? error,
    bool? isInitialized,
    bool clearError = false,
    bool clearUser = false,
  }) {
    return AuthState(
      user: clearUser ? null : (user ?? this.user),
      isLoading: isLoading ?? this.isLoading,
      error: clearError ? null : (error ?? this.error),
      isInitialized: isInitialized ?? this.isInitialized,
    );
  }
}

/// Authentication controller - manages auth state with real API
class AuthController extends AsyncNotifier<AuthState> {
  late AuthRepository _repository;

  @override
  Future<AuthState> build() async {
    // Initialize repository with dependencies
    final dioClient = ref.read(dioClientProvider);
    final storage = await StorageService.getInstance();
    _repository = AuthRepository(client: dioClient, storage: storage);

    // Check for existing session on app start
    return _checkExistingSession();
  }

  /// Check if user has an existing valid session
  Future<AuthState> _checkExistingSession() async {
    try {
      final user = await _repository.getSession();
      return AuthState(user: user, isInitialized: true);
    } catch (e) {
      return AuthState(isInitialized: true);
    }
  }

  /// Login with email and password
  Future<bool> login(String email, String password) async {
    state = AsyncValue.data(
      state.value?.copyWith(isLoading: true, clearError: true) ??
          AuthState(isLoading: true),
    );

    try {
      final user = await _repository.signIn(email, password);

      if (user != null) {
        state = AsyncValue.data(AuthState(user: user, isInitialized: true));
        return true;
      } else {
        state = AsyncValue.data(
          AuthState(error: 'Invalid email or password', isInitialized: true),
        );
        return false;
      }
    } catch (e) {
      state = AsyncValue.data(
        AuthState(error: 'Login failed: ${e.toString()}', isInitialized: true),
      );
      return false;
    }
  }

  /// Register new user
  Future<bool> register(String name, String email, String password) async {
    state = AsyncValue.data(
      state.value?.copyWith(isLoading: true, clearError: true) ??
          AuthState(isLoading: true),
    );

    try {
      final user = await _repository.signUp(name, email, password);

      if (user != null) {
        state = AsyncValue.data(AuthState(user: user, isInitialized: true));
        return true;
      } else {
        state = AsyncValue.data(
          AuthState(
            error: 'Registration failed. Please try again.',
            isInitialized: true,
          ),
        );
        return false;
      }
    } catch (e) {
      state = AsyncValue.data(
        AuthState(
          error: 'Registration failed: ${e.toString()}',
          isInitialized: true,
        ),
      );
      return false;
    }
  }

  /// Sign in with Google
  Future<bool> signInWithGoogle() async {
    state = AsyncValue.data(
      state.value?.copyWith(isLoading: true, clearError: true) ??
          AuthState(isLoading: true),
    );

    try {
      final googleService = GoogleSignInService.instance;
      final account = await googleService.signIn();

      if (account != null) {
        // For Google Sign-In, we create a user from Google account
        // In production, you'd send the Google token to your backend
        // to create/link an account
        final user = User(
          id: account.id,
          email: account.email,
          name: account.displayName ?? account.email.split('@')[0],
          image: account.photoUrl,
        );

        state = AsyncValue.data(AuthState(user: user, isInitialized: true));
        return true;
      } else {
        state = AsyncValue.data(
          AuthState(error: 'Sign-in cancelled', isInitialized: true),
        );
        return false;
      }
    } catch (e) {
      state = AsyncValue.data(
        AuthState(
          error: 'Google Sign-In failed: ${e.toString()}',
          isInitialized: true,
        ),
      );
      return false;
    }
  }

  /// Logout user
  Future<void> logout() async {
    state = AsyncValue.data(
      state.value?.copyWith(isLoading: true) ?? AuthState(isLoading: true),
    );

    try {
      // Sign out from Google if applicable
      await GoogleSignInService.instance.signOut();

      // Sign out from backend
      await _repository.signOut();
    } catch (e) {
      // Ignore errors during logout
    } finally {
      state = AsyncValue.data(AuthState(isInitialized: true));
    }
  }

  /// Clear any error state
  void clearError() {
    if (state.value?.error != null) {
      state = AsyncValue.data(state.value!.copyWith(clearError: true));
    }
  }
}

/// Auth controller provider
final authControllerProvider = AsyncNotifierProvider<AuthController, AuthState>(
  AuthController.new,
);

/// Convenience provider for checking if user is authenticated
final isAuthenticatedProvider = Provider<bool>((ref) {
  final authState = ref.watch(authControllerProvider);
  return authState.value?.isAuthenticated ?? false;
});

/// Convenience provider for getting current user
final currentUserProvider = Provider<User?>((ref) {
  final authState = ref.watch(authControllerProvider);
  return authState.value?.user;
});
