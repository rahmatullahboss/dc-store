/// Auth Repository Implementation
library;
import '../../core/utils/either.dart';
import '../../core/errors/failures.dart';
import '../../core/errors/exceptions.dart';
import '../../core/constants/storage_keys.dart';
import '../../services/storage_service.dart';
import '../../domain/repositories/i_auth_repository.dart';
import '../datasources/remote/auth_remote_datasource.dart';
import '../models/user/user_model.dart';

class AuthRepository implements IAuthRepository {
  final IAuthRemoteDataSource _remoteDataSource;
  final StorageService _storageService;

  AuthRepository({
    required IAuthRemoteDataSource remoteDataSource,
    required StorageService storageService,
  }) : _remoteDataSource = remoteDataSource,
       _storageService = storageService;

  @override
  Future<Result<AuthResponseModel>> login({
    required String email,
    required String password,
  }) async {
    return tryCatch(() async {
      final response = await _remoteDataSource.login(email, password);
      await _saveTokens(response.tokens);
      return response;
    }, onError: _handleError);
  }

  @override
  Future<Result<AuthResponseModel>> register({
    required String name,
    required String email,
    required String password,
    String? phone,
  }) async {
    return tryCatch(() async {
      final response = await _remoteDataSource.register(
        name: name,
        email: email,
        password: password,
        phone: phone,
      );
      await _saveTokens(response.tokens);
      return response;
    }, onError: _handleError);
  }

  @override
  Future<Result<AuthResponseModel>> loginWithGoogle() async {
    return tryCatch(() async {
      // In a real app, get the ID token from Google Sign-In
      throw UnimplementedError('Google Sign-In not implemented');
    }, onError: _handleError);
  }

  @override
  Future<Result<AuthResponseModel>> loginWithFacebook() async {
    return tryCatch(() async {
      throw UnimplementedError('Facebook Sign-In not implemented');
    }, onError: _handleError);
  }

  @override
  Future<Result<void>> logout() async {
    return tryCatch(() async {
      final token = _storageService.getString(StorageKeys.authToken);
      if (token != null) {
        await _remoteDataSource.logout(token);
      }
      await _clearTokens();
    }, onError: _handleError);
  }

  @override
  Future<Result<TokenModel>> refreshToken() async {
    return tryCatch(() async {
      final refreshToken = _storageService.getString(StorageKeys.refreshToken);
      if (refreshToken == null) {
        throw UnauthorizedException.sessionExpired();
      }

      final tokens = await _remoteDataSource.refreshToken(refreshToken);
      await _saveTokens(tokens);
      return tokens;
    }, onError: _handleError);
  }

  @override
  Future<Result<void>> forgotPassword({required String email}) async {
    return tryCatch(() async {
      await _remoteDataSource.forgotPassword(email);
    }, onError: _handleError);
  }

  @override
  Future<Result<void>> resetPassword({
    required String token,
    required String newPassword,
  }) async {
    return tryCatch(() async {
      await _remoteDataSource.resetPassword(token, newPassword);
    }, onError: _handleError);
  }

  @override
  Future<Result<void>> verifyEmail({required String otp}) async {
    return tryCatch(() async {
      await _remoteDataSource.verifyEmail(otp);
    }, onError: _handleError);
  }

  @override
  Future<Result<void>> resendVerificationEmail() async {
    return tryCatch(() async {
      await _remoteDataSource.resendVerificationEmail();
    }, onError: _handleError);
  }

  @override
  Future<Result<bool>> isAuthenticated() async {
    return tryCatch(() async {
      final token = _storageService.getString(StorageKeys.authToken);
      return token != null && token.isNotEmpty;
    }, onError: _handleError);
  }

  @override
  Future<Result<String?>> getToken() async {
    return tryCatch(() async {
      return _storageService.getString(StorageKeys.authToken);
    }, onError: _handleError);
  }

  @override
  Future<Result<void>> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    return tryCatch(() async {
      await _remoteDataSource.changePassword(currentPassword, newPassword);
    }, onError: _handleError);
  }

  Future<void> _saveTokens(TokenModel tokens) async {
    await _storageService.setString(StorageKeys.authToken, tokens.accessToken);
    if (tokens.refreshToken != null) {
      await _storageService.setString(
        StorageKeys.refreshToken,
        tokens.refreshToken!,
      );
    }
  }

  Future<void> _clearTokens() async {
    await _storageService.remove(StorageKeys.authToken);
    await _storageService.remove(StorageKeys.refreshToken);
  }

  Failure _handleError(Object error, StackTrace stack) {
    if (error is UnauthorizedException) {
      return AuthFailure(error.message);
    } else if (error is ServerException) {
      return ServerFailure(error.message);
    }
    return ServerFailure(error.toString());
  }
}
