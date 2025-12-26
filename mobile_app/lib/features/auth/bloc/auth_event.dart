part of 'auth_bloc.dart';

/// Auth Events
sealed class AuthEvent {
  const AuthEvent();
}

/// Check current authentication status
final class AuthCheckRequested extends AuthEvent {
  const AuthCheckRequested();
}

/// Login with email/password
final class AuthLoginRequested extends AuthEvent {
  final String email;
  final String password;
  final bool rememberMe;

  const AuthLoginRequested({
    required this.email,
    required this.password,
    this.rememberMe = false,
  });
}

/// Register new user
final class AuthRegisterRequested extends AuthEvent {
  final String name;
  final String email;
  final String password;
  final String? phone;

  const AuthRegisterRequested({
    required this.name,
    required this.email,
    required this.password,
    this.phone,
  });
}

/// Google sign-in
final class AuthGoogleSignInRequested extends AuthEvent {
  const AuthGoogleSignInRequested();
}

/// Logout
final class AuthLogoutRequested extends AuthEvent {
  const AuthLogoutRequested();
}

/// Forgot password
final class AuthForgotPasswordRequested extends AuthEvent {
  final String email;

  const AuthForgotPasswordRequested({required this.email});
}

/// Reset password
final class AuthResetPasswordRequested extends AuthEvent {
  final String token;
  final String newPassword;

  const AuthResetPasswordRequested({
    required this.token,
    required this.newPassword,
  });
}

/// Verify OTP
final class AuthVerifyOtpRequested extends AuthEvent {
  final String email;
  final String otp;

  const AuthVerifyOtpRequested({required this.email, required this.otp});
}

/// Refresh token
final class AuthRefreshTokenRequested extends AuthEvent {
  const AuthRefreshTokenRequested();
}

/// Update user after profile change
final class AuthUserUpdated extends AuthEvent {
  final UserModel user;

  const AuthUserUpdated(this.user);
}
