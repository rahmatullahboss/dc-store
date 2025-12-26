/// User Repository Interface - Domain Layer
/// Defines all user profile and address operations

import '../../core/utils/either.dart';
import '../../data/models/user/user_model.dart';

abstract class IUserRepository {
  /// Get current user profile
  Future<Result<UserModel>> getProfile();

  /// Update user profile
  Future<Result<UserModel>> updateProfile({
    String? name,
    String? phone,
    String? gender,
    DateTime? dateOfBirth,
  });

  /// Update user avatar
  Future<Result<UserModel>> updateAvatar(String imagePath);

  /// Remove user avatar
  Future<Result<UserModel>> removeAvatar();

  /// Get user addresses
  Future<Result<List<AddressModel>>> getAddresses();

  /// Add new address
  Future<Result<AddressModel>> addAddress(AddressModel address);

  /// Update address
  Future<Result<AddressModel>> updateAddress(AddressModel address);

  /// Delete address
  Future<Result<void>> deleteAddress(String addressId);

  /// Set default address
  Future<Result<void>> setDefaultAddress(String addressId);

  /// Verify phone number
  Future<Result<void>> sendPhoneVerification();

  /// Confirm phone verification
  Future<Result<void>> verifyPhone(String otp);

  /// Delete user account
  Future<Result<void>> deleteAccount({
    required String password,
    String? reason,
  });

  /// Export user data (GDPR)
  Future<Result<String>> exportData();

  /// Refresh user cache
  Future<void> refreshCache();

  /// Clear user cache
  Future<void> clearCache();
}
