part of 'auth_bloc.dart';

/// Auth States
sealed class AuthState {
  const AuthState();
}

/// Initial state - checking auth status
final class AuthInitial extends AuthState {
  const AuthInitial();
}

/// Loading state
final class AuthLoading extends AuthState {
  final String? message;

  const AuthLoading({this.message});
}

/// Authenticated state - user is logged in
final class AuthAuthenticated extends AuthState {
  final UserModel user;

  const AuthAuthenticated(this.user);
}

/// Unauthenticated state - user is not logged in
final class AuthUnauthenticated extends AuthState {
  const AuthUnauthenticated();
}

/// Error state
final class AuthError extends AuthState {
  final String message;
  final String? code;

  const AuthError({required this.message, this.code});
}

/// Password reset email sent
final class AuthPasswordResetSent extends AuthState {
  final String email;

  const AuthPasswordResetSent(this.email);
}

/// OTP verification required
final class AuthOtpRequired extends AuthState {
  final String email;

  const AuthOtpRequired(this.email);
}

/// Registration success (may need email verification)
final class AuthRegistrationSuccess extends AuthState {
  final UserModel user;
  final bool requiresVerification;

  const AuthRegistrationSuccess({
    required this.user,
    this.requiresVerification = false,
  });
}
