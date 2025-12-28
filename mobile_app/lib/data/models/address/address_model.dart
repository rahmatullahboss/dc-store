import 'package:freezed_annotation/freezed_annotation.dart';

part 'address_model.freezed.dart';
part 'address_model.g.dart';

/// Address type enum matching backend
enum AddressType {
  @JsonValue('home')
  home,
  @JsonValue('office')
  office,
  @JsonValue('other')
  other,
}

/// Address model for user shipping addresses
@freezed
class AddressModel with _$AddressModel {
  const factory AddressModel({
    required String id,
    required String userId,
    required String name,
    required String phone,
    required String addressLine1,
    String? addressLine2,
    required String city,
    String? state,
    String? zipCode,
    @Default('Bangladesh') String country,
    @Default(AddressType.home) AddressType type,
    @Default(false) bool isDefault,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _AddressModel;

  factory AddressModel.fromJson(Map<String, dynamic> json) =>
      _$AddressModelFromJson(json);
}
