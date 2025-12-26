import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/models/user/user_model.dart';
import '../../../core/constants/storage_keys.dart';
import '../../../services/storage_service.dart';

part 'auth_event.dart';
part 'auth_state.dart';

/// AuthBloc - Handles authentication state management
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final StorageService? _storageService;

  AuthBloc({StorageService? storageService})
    : _storageService = storageService,
      super(const AuthInitial()) {
    on<AuthCheckRequested>(_onCheckRequested);
    on<AuthLoginRequested>(_onLoginRequested);
    on<AuthRegisterRequested>(_onRegisterRequested);
    on<AuthGoogleSignInRequested>(_onGoogleSignInRequested);
    on<AuthLogoutRequested>(_onLogoutRequested);
    on<AuthForgotPasswordRequested>(_onForgotPasswordRequested);
    on<AuthResetPasswordRequested>(_onResetPasswordRequested);
    on<AuthVerifyOtpRequested>(_onVerifyOtpRequested);
    on<AuthRefreshTokenRequested>(_onRefreshTokenRequested);
    on<AuthUserUpdated>(_onUserUpdated);
  }

  /// Check if user is authenticated
  Future<void> _onCheckRequested(
    AuthCheckRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading(message: 'Checking authentication...'));

    try {
      final token = _storageService?.getString(StorageKeys.authToken);

      if (token != null && token.isNotEmpty) {
        // TODO: Validate token with server and get user
        // For now, create a mock user from stored data
        final userId = _storageService?.getString(StorageKeys.userId);
        final userName = _storageService?.getString(StorageKeys.userName);
        final userEmail = _storageService?.getString(StorageKeys.userEmail);

        if (userId != null && userEmail != null) {
          final user = UserModel(id: userId, email: userEmail, name: userName);
          emit(AuthAuthenticated(user));
        } else {
          emit(const AuthUnauthenticated());
        }
      } else {
        emit(const AuthUnauthenticated());
      }
    } catch (e) {
      emit(AuthError(message: 'Authentication check failed: $e'));
    }
  }

  /// Handle login request
  Future<void> _onLoginRequested(
    AuthLoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading(message: 'Signing in...'));

    try {
      // TODO: Call auth repository/API
      // Simulated delay for now
      await Future.delayed(const Duration(seconds: 1));

      // Mock successful login
      final user = UserModel(
        id: 'user_${DateTime.now().millisecondsSinceEpoch}',
        email: event.email,
        name: event.email.split('@').first,
      );

      // Save auth data
      await _saveAuthData(user, 'mock_token');

      emit(AuthAuthenticated(user));
    } catch (e) {
      emit(AuthError(message: 'Login failed: ${e.toString()}'));
    }
  }

  /// Handle registration request
  Future<void> _onRegisterRequested(
    AuthRegisterRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading(message: 'Creating account...'));

    try {
      // TODO: Call auth repository/API
      await Future.delayed(const Duration(seconds: 1));

      final user = UserModel(
        id: 'user_${DateTime.now().millisecondsSinceEpoch}',
        email: event.email,
        name: event.name,
        phone: event.phone,
      );

      await _saveAuthData(user, 'mock_token');

      emit(AuthRegistrationSuccess(user: user, requiresVerification: false));
    } catch (e) {
      emit(AuthError(message: 'Registration failed: ${e.toString()}'));
    }
  }

  /// Handle Google sign-in
  Future<void> _onGoogleSignInRequested(
    AuthGoogleSignInRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading(message: 'Signing in with Google...'));

    try {
      // TODO: Implement Google Sign-In
      await Future.delayed(const Duration(seconds: 1));
      emit(const AuthError(message: 'Google Sign-In not implemented yet'));
    } catch (e) {
      emit(AuthError(message: 'Google Sign-In failed: ${e.toString()}'));
    }
  }

  /// Handle logout request
  Future<void> _onLogoutRequested(
    AuthLogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading(message: 'Signing out...'));

    try {
      // Clear stored auth data
      await _storageService?.remove(StorageKeys.authToken);
      await _storageService?.remove(StorageKeys.refreshToken);
      await _storageService?.remove(StorageKeys.userId);
      await _storageService?.remove(StorageKeys.userName);
      await _storageService?.remove(StorageKeys.userEmail);

      emit(const AuthUnauthenticated());
    } catch (e) {
      emit(AuthError(message: 'Logout failed: ${e.toString()}'));
    }
  }

  /// Handle forgot password
  Future<void> _onForgotPasswordRequested(
    AuthForgotPasswordRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading(message: 'Sending reset link...'));

    try {
      // TODO: Call forgot password API
      await Future.delayed(const Duration(seconds: 1));
      emit(AuthPasswordResetSent(event.email));
    } catch (e) {
      emit(AuthError(message: 'Failed to send reset link: ${e.toString()}'));
    }
  }

  /// Handle password reset
  Future<void> _onResetPasswordRequested(
    AuthResetPasswordRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading(message: 'Resetting password...'));

    try {
      // TODO: Call reset password API
      await Future.delayed(const Duration(seconds: 1));
      emit(const AuthUnauthenticated());
    } catch (e) {
      emit(AuthError(message: 'Password reset failed: ${e.toString()}'));
    }
  }

  /// Handle OTP verification
  Future<void> _onVerifyOtpRequested(
    AuthVerifyOtpRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading(message: 'Verifying OTP...'));

    try {
      // TODO: Call verify OTP API
      await Future.delayed(const Duration(seconds: 1));
      emit(const AuthUnauthenticated());
    } catch (e) {
      emit(AuthError(message: 'OTP verification failed: ${e.toString()}'));
    }
  }

  /// Handle token refresh
  Future<void> _onRefreshTokenRequested(
    AuthRefreshTokenRequested event,
    Emitter<AuthState> emit,
  ) async {
    try {
      // TODO: Call refresh token API
      final refreshToken = _storageService?.getString(StorageKeys.refreshToken);
      if (refreshToken == null) {
        emit(const AuthUnauthenticated());
        return;
      }
      // Refresh logic here
    } catch (e) {
      emit(const AuthUnauthenticated());
    }
  }

  /// Handle user update (from profile changes)
  void _onUserUpdated(AuthUserUpdated event, Emitter<AuthState> emit) {
    emit(AuthAuthenticated(event.user));
  }

  /// Save auth data to storage
  Future<void> _saveAuthData(UserModel user, String token) async {
    await _storageService?.setString(StorageKeys.authToken, token);
    await _storageService?.setString(StorageKeys.userId, user.id);
    if (user.name != null) {
      await _storageService?.setString(StorageKeys.userName, user.name!);
    }
    await _storageService?.setString(StorageKeys.userEmail, user.email);
  }
}
