/// Auth Remote Data Source - API calls for authentication
import '../../../core/network/dio_client.dart';
import '../../../core/constants/api_constants.dart';
import '../../../core/errors/exceptions.dart';
import '../../models/user/user_model.dart';

abstract class IAuthRemoteDataSource {
  Future<AuthResponseModel> login(String email, String password);
  Future<AuthResponseModel> register({
    required String name,
    required String email,
    required String password,
    String? phone,
  });
  Future<AuthResponseModel> loginWithGoogle(String idToken);
  Future<AuthResponseModel> loginWithFacebook(String accessToken);
  Future<void> logout(String token);
  Future<TokenModel> refreshToken(String refreshToken);
  Future<void> forgotPassword(String email);
  Future<void> resetPassword(String token, String newPassword);
  Future<void> verifyEmail(String otp);
  Future<void> resendVerificationEmail();
  Future<void> changePassword(String currentPassword, String newPassword);
}

class AuthRemoteDataSource implements IAuthRemoteDataSource {
  final DioClient _client;

  AuthRemoteDataSource({required DioClient client}) : _client = client;

  @override
  Future<AuthResponseModel> login(String email, String password) async {
    final response = await _client.post<Map<String, dynamic>>(
      ApiConstants.login,
      data: {'email': email, 'password': password},
    );

    if (!response.isSuccess || response.data == null) {
      throw UnauthorizedException(
        message: response.message ?? 'Invalid credentials',
      );
    }

    return AuthResponseModel.fromJson(response.data!);
  }

  @override
  Future<AuthResponseModel> register({
    required String name,
    required String email,
    required String password,
    String? phone,
  }) async {
    final response = await _client.post<Map<String, dynamic>>(
      ApiConstants.register,
      data: {
        'name': name,
        'email': email,
        'password': password,
        if (phone != null) 'phone': phone,
      },
    );

    if (!response.isSuccess || response.data == null) {
      throw ServerException(
        message: response.message ?? 'Registration failed',
        statusCode: response.error?.statusCode,
      );
    }

    return AuthResponseModel.fromJson(response.data!);
  }

  @override
  Future<AuthResponseModel> loginWithGoogle(String idToken) async {
    final response = await _client.post<Map<String, dynamic>>(
      '${ApiConstants.login}/google',
      data: {'idToken': idToken},
    );

    if (!response.isSuccess || response.data == null) {
      throw UnauthorizedException(
        message: response.message ?? 'Google login failed',
      );
    }

    return AuthResponseModel.fromJson(response.data!);
  }

  @override
  Future<AuthResponseModel> loginWithFacebook(String accessToken) async {
    final response = await _client.post<Map<String, dynamic>>(
      '${ApiConstants.login}/facebook',
      data: {'accessToken': accessToken},
    );

    if (!response.isSuccess || response.data == null) {
      throw UnauthorizedException(
        message: response.message ?? 'Facebook login failed',
      );
    }

    return AuthResponseModel.fromJson(response.data!);
  }

  @override
  Future<void> logout(String token) async {
    await _client.post<void>(ApiConstants.logout, data: {'token': token});
  }

  @override
  Future<TokenModel> refreshToken(String refreshToken) async {
    final response = await _client.post<Map<String, dynamic>>(
      ApiConstants.refreshToken,
      data: {'refreshToken': refreshToken},
    );

    if (!response.isSuccess || response.data == null) {
      throw UnauthorizedException.sessionExpired();
    }

    return TokenModel.fromJson(response.data!);
  }

  @override
  Future<void> forgotPassword(String email) async {
    final response = await _client.post<Map<String, dynamic>>(
      ApiConstants.forgotPassword,
      data: {'email': email},
    );

    if (!response.isSuccess) {
      throw ServerException(
        message: response.message ?? 'Failed to send reset email',
        statusCode: response.error?.statusCode,
      );
    }
  }

  @override
  Future<void> resetPassword(String token, String newPassword) async {
    final response = await _client.post<Map<String, dynamic>>(
      ApiConstants.resetPassword,
      data: {'token': token, 'password': newPassword},
    );

    if (!response.isSuccess) {
      throw ServerException(
        message: response.message ?? 'Password reset failed',
        statusCode: response.error?.statusCode,
      );
    }
  }

  @override
  Future<void> verifyEmail(String otp) async {
    final response = await _client.post<Map<String, dynamic>>(
      ApiConstants.verifyEmail,
      data: {'otp': otp},
    );

    if (!response.isSuccess) {
      throw ServerException(
        message: response.message ?? 'Email verification failed',
        statusCode: response.error?.statusCode,
      );
    }
  }

  @override
  Future<void> resendVerificationEmail() async {
    final response = await _client.post<Map<String, dynamic>>(
      '${ApiConstants.verifyEmail}/resend',
    );

    if (!response.isSuccess) {
      throw ServerException(
        message: response.message ?? 'Failed to resend verification email',
        statusCode: response.error?.statusCode,
      );
    }
  }

  @override
  Future<void> changePassword(
    String currentPassword,
    String newPassword,
  ) async {
    final response = await _client.post<Map<String, dynamic>>(
      ApiConstants.changePassword,
      data: {'currentPassword': currentPassword, 'newPassword': newPassword},
    );

    if (!response.isSuccess) {
      throw ServerException(
        message: response.message ?? 'Password change failed',
        statusCode: response.error?.statusCode,
      );
    }
  }
}
