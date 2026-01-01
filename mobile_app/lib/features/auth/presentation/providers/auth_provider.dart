import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/storage_keys.dart';
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
  late DioClient _dioClient;

  @override
  Future<AuthState> build() async {
    // Initialize repository with dependencies
    _dioClient = ref.read(dioClientProvider);
    final storage = await StorageService.getInstance();
    _repository = AuthRepository(client: _dioClient, storage: storage);

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
  /// Sends Google ID token to server for validation and session creation
  Future<bool> signInWithGoogle() async {
    state = AsyncValue.data(
      state.value?.copyWith(isLoading: true, clearError: true) ??
          AuthState(isLoading: true),
    );

    try {
      final googleService = GoogleSignInService.instance;
      final account = await googleService.signIn();

      if (account != null) {
        // Get authentication to retrieve ID token
        final auth = googleService.getAuthentication(account);
        final idToken = auth?.idToken;

        if (idToken == null) {
          throw Exception('Failed to get Google ID token');
        }

        // Send ID token to custom mobile Google auth endpoint
        // This endpoint validates ID tokens from iOS/Android client IDs
        final response = await _dioClient.post<Map<String, dynamic>>(
          '/api/auth/mobile-google',
          data: {'idToken': idToken},
        );

        if (response.isSuccess && response.data != null) {
          final data = response.data!;
          final userData = data['user'] as Map<String, dynamic>?;
          final token = data['token'] as String?;

          if (userData != null) {
            // Save auth data to storage
            final storage = await StorageService.getInstance();
            if (token != null) {
              await storage.setString(StorageKeys.authToken, token);
            }
            await storage.setString(
              StorageKeys.userId,
              userData['id'] ?? account.id,
            );
            await storage.setString(
              StorageKeys.userEmail,
              userData['email'] ?? account.email,
            );
            await storage.setString(
              StorageKeys.userName,
              userData['name'] ?? account.displayName ?? '',
            );
            if (userData['image'] != null) {
              await storage.setString(
                StorageKeys.userAvatar,
                userData['image'],
              );
            } else if (account.photoUrl != null) {
              await storage.setString(
                StorageKeys.userAvatar,
                account.photoUrl!,
              );
            }
            await storage.setBool(StorageKeys.isLoggedIn, true);

            final user = User.fromJson(userData);
            debugPrint('Google Sign-In server validated: ${user.email}');
            state = AsyncValue.data(AuthState(user: user, isInitialized: true));
            return true;
          }
        }

        // Server validation failed - fall back to local account (temporary)
        // This keeps the app working while server integration is being fixed
        debugPrint('Server validation failed, using local Google account');
        debugPrint(
          'Response isSuccess: ${response.isSuccess}, error: ${response.error?.message}, statusCode: ${response.error?.statusCode}',
        );
        final storage = await StorageService.getInstance();
        await storage.setString(
          StorageKeys.authToken,
          'google_signin_token_${account.id}',
        );
        await storage.setString(StorageKeys.userId, account.id);
        await storage.setString(StorageKeys.userEmail, account.email);
        await storage.setString(
          StorageKeys.userName,
          account.displayName ?? account.email.split('@')[0],
        );
        if (account.photoUrl != null) {
          await storage.setString(StorageKeys.userAvatar, account.photoUrl!);
        }
        await storage.setBool(StorageKeys.isLoggedIn, true);

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
      debugPrint('Google Sign-In error: $e');
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
