part of 'profile_cubit.dart';

/// Profile loading status
enum ProfileStatus { initial, loading, loaded, error }

/// Profile update status
enum ProfileUpdateStatus { initial, updating, updated, error }

/// Address operation status
enum AddressStatus { initial, loading, saving, deleting, saved, error }

/// Password change status
enum PasswordStatus { initial, changing, changed, error }

/// Avatar upload status
enum AvatarStatus { initial, uploading, uploaded, error }

/// Profile State
class ProfileState extends Equatable {
  final ProfileStatus status;
  final ProfileUpdateStatus updateStatus;
  final AddressStatus addressStatus;
  final PasswordStatus passwordStatus;
  final AvatarStatus avatarStatus;
  final UserModel? user;
  final List<AddressModel> addresses;
  final String? errorMessage;

  const ProfileState({
    this.status = ProfileStatus.initial,
    this.updateStatus = ProfileUpdateStatus.initial,
    this.addressStatus = AddressStatus.initial,
    this.passwordStatus = PasswordStatus.initial,
    this.avatarStatus = AvatarStatus.initial,
    this.user,
    this.addresses = const [],
    this.errorMessage,
  });

  /// Get default address
  AddressModel? get defaultAddress {
    try {
      return addresses.firstWhere((a) => a.isDefault);
    } catch (_) {
      return addresses.isNotEmpty ? addresses.first : null;
    }
  }

  /// Get shipping addresses
  List<AddressModel> get shippingAddresses {
    return addresses.where((a) => a.type == 'shipping').toList();
  }

  /// Get billing addresses
  List<AddressModel> get billingAddresses {
    return addresses.where((a) => a.type == 'billing').toList();
  }

  ProfileState copyWith({
    ProfileStatus? status,
    ProfileUpdateStatus? updateStatus,
    AddressStatus? addressStatus,
    PasswordStatus? passwordStatus,
    AvatarStatus? avatarStatus,
    UserModel? user,
    List<AddressModel>? addresses,
    String? errorMessage,
  }) {
    return ProfileState(
      status: status ?? this.status,
      updateStatus: updateStatus ?? this.updateStatus,
      addressStatus: addressStatus ?? this.addressStatus,
      passwordStatus: passwordStatus ?? this.passwordStatus,
      avatarStatus: avatarStatus ?? this.avatarStatus,
      user: user ?? this.user,
      addresses: addresses ?? this.addresses,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
    status,
    updateStatus,
    addressStatus,
    passwordStatus,
    avatarStatus,
    user,
    addresses,
    errorMessage,
  ];
}
