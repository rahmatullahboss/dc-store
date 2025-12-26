import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_model.freezed.dart';
part 'user_model.g.dart';

/// User Model - Represents authenticated user
@freezed
class UserModel with _$UserModel {
  const factory UserModel({
    required String id,
    required String email,
    String? name,
    String? phone,
    String? avatar,
    @Default(false) bool emailVerified,
    @Default(false) bool phoneVerified,
    String? gender,
    DateTime? dateOfBirth,
    @Default([]) List<AddressModel> addresses,
    String? defaultAddressId,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _UserModel;

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);
}

/// Address Model - User's delivery/billing address
@freezed
class AddressModel with _$AddressModel {
  const factory AddressModel({
    required String id,
    @Default('shipping') String type, // shipping, billing
    required String fullName,
    required String phone,
    required String street,
    String? apartment,
    required String city,
    required String state,
    required String postalCode,
    @Default('Bangladesh') String country,
    @Default(false) bool isDefault,
    double? latitude,
    double? longitude,
    String? label, // Home, Office, etc.
    String? instructions, // Delivery instructions
  }) = _AddressModel;

  factory AddressModel.fromJson(Map<String, dynamic> json) =>
      _$AddressModelFromJson(json);
}

/// Auth Response Model - Login/Register response
@freezed
class AuthResponseModel with _$AuthResponseModel {
  const factory AuthResponseModel({
    required UserModel user,
    required TokenModel tokens,
    String? message,
  }) = _AuthResponseModel;

  factory AuthResponseModel.fromJson(Map<String, dynamic> json) =>
      _$AuthResponseModelFromJson(json);
}

/// Token Model - Authentication tokens
@freezed
class TokenModel with _$TokenModel {
  const factory TokenModel({
    required String accessToken,
    String? refreshToken,
    DateTime? expiresAt,
    @Default('Bearer') String tokenType,
  }) = _TokenModel;

  factory TokenModel.fromJson(Map<String, dynamic> json) =>
      _$TokenModelFromJson(json);
}
