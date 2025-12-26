/// Auth Repository Interface - Domain Layer
/// Defines all authentication-related operations
library;

import '../../core/utils/either.dart';
import '../../data/models/user/user_model.dart';

abstract class IAuthRepository {
  /// Login with email and password
  Future<Result<AuthResponseModel>> login({
    required String email,
    required String password,
  });

  /// Register new user
  Future<Result<AuthResponseModel>> register({
    required String name,
    required String email,
    required String password,
    String? phone,
  });

  /// Login with Google OAuth
  Future<Result<AuthResponseModel>> loginWithGoogle();

  /// Login with Facebook OAuth
  Future<Result<AuthResponseModel>> loginWithFacebook();

  /// Logout current user
  Future<Result<void>> logout();

  /// Refresh authentication tokens
  Future<Result<TokenModel>> refreshToken();

  /// Send password reset email
  Future<Result<void>> forgotPassword({required String email});

  /// Reset password with token
  Future<Result<void>> resetPassword({
    required String token,
    required String newPassword,
  });

  /// Verify email with OTP
  Future<Result<void>> verifyEmail({required String otp});

  /// Resend verification email
  Future<Result<void>> resendVerificationEmail();

  /// Check if user is authenticated
  Future<Result<bool>> isAuthenticated();

  /// Get current auth token
  Future<Result<String?>> getToken();

  /// Change password
  Future<Result<void>> changePassword({
    required String currentPassword,
    required String newPassword,
  });
}
