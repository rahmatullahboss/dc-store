/// User Repository Implementation
library;
import '../../core/utils/either.dart';
import '../../core/errors/failures.dart';
import '../../core/errors/exceptions.dart';
import '../../core/network/network_info.dart';
import '../../domain/repositories/i_user_repository.dart';
import '../datasources/remote/user_remote_datasource.dart';
import '../datasources/local/user_local_datasource.dart';
import '../models/user/user_model.dart';

class UserRepository implements IUserRepository {
  final IUserRemoteDataSource _remoteDataSource;
  final IUserLocalDataSource _localDataSource;
  final NetworkInfo _networkInfo;

  UserRepository({
    required IUserRemoteDataSource remoteDataSource,
    required IUserLocalDataSource localDataSource,
    required NetworkInfo networkInfo,
  }) : _remoteDataSource = remoteDataSource,
       _localDataSource = localDataSource,
       _networkInfo = networkInfo;

  @override
  Future<Result<UserModel>> getProfile() async {
    return tryCatch(() async {
      final cached = await _localDataSource.getCachedProfile();

      if (await _networkInfo.isConnected) {
        final user = await _remoteDataSource.getProfile();
        await _localDataSource.cacheProfile(user);
        return user;
      } else if (cached != null) {
        return cached;
      }
      throw NetworkException.noConnection();
    }, onError: _handleError);
  }

  @override
  Future<Result<UserModel>> updateProfile({
    String? name,
    String? phone,
    String? gender,
    DateTime? dateOfBirth,
  }) async {
    return tryCatch(() async {
      if (!await _networkInfo.isConnected) {
        throw NetworkException.noConnection();
      }

      final user = await _remoteDataSource.updateProfile(
        name: name,
        phone: phone,
        gender: gender,
        dateOfBirth: dateOfBirth,
      );
      await _localDataSource.cacheProfile(user);
      return user;
    }, onError: _handleError);
  }

  @override
  Future<Result<UserModel>> updateAvatar(String imagePath) async {
    return tryCatch(() async {
      if (!await _networkInfo.isConnected) {
        throw NetworkException.noConnection();
      }

      final user = await _remoteDataSource.updateAvatar(imagePath);
      await _localDataSource.cacheProfile(user);
      return user;
    }, onError: _handleError);
  }

  @override
  Future<Result<UserModel>> removeAvatar() async {
    return tryCatch(() async {
      if (!await _networkInfo.isConnected) {
        throw NetworkException.noConnection();
      }

      final user = await _remoteDataSource.removeAvatar();
      await _localDataSource.cacheProfile(user);
      return user;
    }, onError: _handleError);
  }

  @override
  Future<Result<List<AddressModel>>> getAddresses() async {
    return tryCatch(() async {
      final cached = await _localDataSource.getCachedAddresses();

      if (await _networkInfo.isConnected) {
        final addresses = await _remoteDataSource.getAddresses();
        await _localDataSource.cacheAddresses(addresses);
        return addresses;
      } else if (cached != null) {
        return cached;
      }
      throw NetworkException.noConnection();
    }, onError: _handleError);
  }

  @override
  Future<Result<AddressModel>> addAddress(AddressModel address) async {
    return tryCatch(() async {
      if (!await _networkInfo.isConnected) {
        throw NetworkException.noConnection();
      }

      final newAddress = await _remoteDataSource.addAddress(address);

      // Update cached addresses
      final cached = await _localDataSource.getCachedAddresses() ?? [];
      await _localDataSource.cacheAddresses([...cached, newAddress]);

      return newAddress;
    }, onError: _handleError);
  }

  @override
  Future<Result<AddressModel>> updateAddress(AddressModel address) async {
    return tryCatch(() async {
      if (!await _networkInfo.isConnected) {
        throw NetworkException.noConnection();
      }

      final updated = await _remoteDataSource.updateAddress(address);

      // Update cached addresses
      final cached = await _localDataSource.getCachedAddresses() ?? [];
      final updatedList = cached
          .map((a) => a.id == updated.id ? updated : a)
          .toList();
      await _localDataSource.cacheAddresses(updatedList);

      return updated;
    }, onError: _handleError);
  }

  @override
  Future<Result<void>> deleteAddress(String addressId) async {
    return tryCatch(() async {
      if (!await _networkInfo.isConnected) {
        throw NetworkException.noConnection();
      }

      await _remoteDataSource.deleteAddress(addressId);

      // Update cached addresses
      final cached = await _localDataSource.getCachedAddresses() ?? [];
      final updated = cached.where((a) => a.id != addressId).toList();
      await _localDataSource.cacheAddresses(updated);
    }, onError: _handleError);
  }

  @override
  Future<Result<void>> setDefaultAddress(String addressId) async {
    return tryCatch(() async {
      if (!await _networkInfo.isConnected) {
        throw NetworkException.noConnection();
      }

      await _remoteDataSource.setDefaultAddress(addressId);

      // Update cached addresses
      final cached = await _localDataSource.getCachedAddresses() ?? [];
      final updated = cached
          .map((a) => a.copyWith(isDefault: a.id == addressId))
          .toList();
      await _localDataSource.cacheAddresses(updated);
    }, onError: _handleError);
  }

  @override
  Future<Result<void>> sendPhoneVerification() async {
    return tryCatch(() async {
      throw UnimplementedError('Phone verification not implemented');
    }, onError: _handleError);
  }

  @override
  Future<Result<void>> verifyPhone(String otp) async {
    return tryCatch(() async {
      throw UnimplementedError('Phone verification not implemented');
    }, onError: _handleError);
  }

  @override
  Future<Result<void>> deleteAccount({
    required String password,
    String? reason,
  }) async {
    return tryCatch(() async {
      throw UnimplementedError('Account deletion not implemented');
    }, onError: _handleError);
  }

  @override
  Future<Result<String>> exportData() async {
    return tryCatch(() async {
      throw UnimplementedError('Data export not implemented');
    }, onError: _handleError);
  }

  @override
  Future<void> refreshCache() async {
    await _localDataSource.clearCache();
  }

  @override
  Future<void> clearCache() async {
    await _localDataSource.clearCache();
  }

  Failure _handleError(Object error, StackTrace stack) {
    if (error is NetworkException) {
      return NetworkFailure(error.message);
    } else if (error is ServerException) {
      return ServerFailure(error.message);
    }
    return ServerFailure(error.toString());
  }
}
