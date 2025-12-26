/// User Remote Data Source - API calls for user profile
library;
import 'package:dio/dio.dart';
import '../../../core/network/dio_client.dart';
import '../../../core/constants/api_constants.dart';
import '../../../core/errors/exceptions.dart';
import '../../models/user/user_model.dart';

abstract class IUserRemoteDataSource {
  Future<UserModel> getProfile();
  Future<UserModel> updateProfile({
    String? name,
    String? phone,
    String? gender,
    DateTime? dateOfBirth,
  });
  Future<UserModel> updateAvatar(String imagePath);
  Future<UserModel> removeAvatar();
  Future<List<AddressModel>> getAddresses();
  Future<AddressModel> addAddress(AddressModel address);
  Future<AddressModel> updateAddress(AddressModel address);
  Future<void> deleteAddress(String addressId);
  Future<void> setDefaultAddress(String addressId);
}

class UserRemoteDataSource implements IUserRemoteDataSource {
  final DioClient _client;

  UserRemoteDataSource({required DioClient client}) : _client = client;

  @override
  Future<UserModel> getProfile() async {
    final response = await _client.get<Map<String, dynamic>>(
      ApiConstants.profile,
    );

    if (!response.isSuccess || response.data == null) {
      throw ServerException(
        message: response.message ?? 'Failed to fetch profile',
        statusCode: response.error?.statusCode,
      );
    }

    final data = response.data!;
    return UserModel.fromJson(data['user'] as Map<String, dynamic>? ?? data);
  }

  @override
  Future<UserModel> updateProfile({
    String? name,
    String? phone,
    String? gender,
    DateTime? dateOfBirth,
  }) async {
    final response = await _client.patch<Map<String, dynamic>>(
      ApiConstants.profile,
      data: {
        if (name != null) 'name': name,
        if (phone != null) 'phone': phone,
        if (gender != null) 'gender': gender,
        if (dateOfBirth != null) 'dateOfBirth': dateOfBirth.toIso8601String(),
      },
    );

    if (!response.isSuccess || response.data == null) {
      throw ServerException(
        message: response.message ?? 'Failed to update profile',
        statusCode: response.error?.statusCode,
      );
    }

    final data = response.data!;
    return UserModel.fromJson(data['user'] as Map<String, dynamic>? ?? data);
  }

  @override
  Future<UserModel> updateAvatar(String imagePath) async {
    final formData = FormData.fromMap({
      'avatar': await MultipartFile.fromFile(imagePath),
    });

    final response = await _client.upload<Map<String, dynamic>>(
      '${ApiConstants.profile}/avatar',
      data: formData,
    );

    if (!response.isSuccess || response.data == null) {
      throw ServerException(
        message: response.message ?? 'Failed to update avatar',
        statusCode: response.error?.statusCode,
      );
    }

    final data = response.data!;
    return UserModel.fromJson(data['user'] as Map<String, dynamic>? ?? data);
  }

  @override
  Future<UserModel> removeAvatar() async {
    final response = await _client.delete<Map<String, dynamic>>(
      '${ApiConstants.profile}/avatar',
    );

    if (!response.isSuccess || response.data == null) {
      throw ServerException(
        message: response.message ?? 'Failed to remove avatar',
        statusCode: response.error?.statusCode,
      );
    }

    final data = response.data!;
    return UserModel.fromJson(data['user'] as Map<String, dynamic>? ?? data);
  }

  @override
  Future<List<AddressModel>> getAddresses() async {
    final response = await _client.get<Map<String, dynamic>>(
      ApiConstants.addresses,
    );

    if (!response.isSuccess || response.data == null) {
      throw ServerException(
        message: response.message ?? 'Failed to fetch addresses',
        statusCode: response.error?.statusCode,
      );
    }

    final data = response.data!;
    return (data['addresses'] as List? ?? data['data'] as List? ?? [])
        .map((item) => AddressModel.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<AddressModel> addAddress(AddressModel address) async {
    final response = await _client.post<Map<String, dynamic>>(
      ApiConstants.addresses,
      data: address.toJson(),
    );

    if (!response.isSuccess || response.data == null) {
      throw ServerException(
        message: response.message ?? 'Failed to add address',
        statusCode: response.error?.statusCode,
      );
    }

    final data = response.data!;
    return AddressModel.fromJson(
      data['address'] as Map<String, dynamic>? ?? data,
    );
  }

  @override
  Future<AddressModel> updateAddress(AddressModel address) async {
    final response = await _client.patch<Map<String, dynamic>>(
      '${ApiConstants.addresses}/${address.id}',
      data: address.toJson(),
    );

    if (!response.isSuccess || response.data == null) {
      throw ServerException(
        message: response.message ?? 'Failed to update address',
        statusCode: response.error?.statusCode,
      );
    }

    final data = response.data!;
    return AddressModel.fromJson(
      data['address'] as Map<String, dynamic>? ?? data,
    );
  }

  @override
  Future<void> deleteAddress(String addressId) async {
    final response = await _client.delete<Map<String, dynamic>>(
      '${ApiConstants.addresses}/$addressId',
    );

    if (!response.isSuccess) {
      throw ServerException(
        message: response.message ?? 'Failed to delete address',
        statusCode: response.error?.statusCode,
      );
    }
  }

  @override
  Future<void> setDefaultAddress(String addressId) async {
    final response = await _client.patch<Map<String, dynamic>>(
      '${ApiConstants.addresses}/$addressId/default',
    );

    if (!response.isSuccess) {
      throw ServerException(
        message: response.message ?? 'Failed to set default address',
        statusCode: response.error?.statusCode,
      );
    }
  }
}
