import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../data/models/user/user_model.dart';

part 'profile_state.dart';

/// UserProfileCubit - Manages user profile state
class UserProfileCubit extends Cubit<ProfileState> {
  UserProfileCubit() : super(const ProfileState());

  /// Fetch user profile
  Future<void> fetchProfile() async {
    emit(state.copyWith(status: ProfileStatus.loading));

    try {
      // TODO: Fetch from API
      await Future.delayed(const Duration(milliseconds: 500));

      // Mock user
      const user = UserModel(
        id: 'user_1',
        email: 'user@example.com',
        name: 'John Doe',
        phone: '01712345678',
      );

      emit(state.copyWith(status: ProfileStatus.loaded, user: user));
    } catch (e) {
      emit(
        state.copyWith(status: ProfileStatus.error, errorMessage: e.toString()),
      );
    }
  }

  /// Update profile
  Future<void> updateProfile({
    String? name,
    String? phone,
    String? avatar,
    String? gender,
    DateTime? dateOfBirth,
  }) async {
    if (state.user == null) return;

    emit(state.copyWith(updateStatus: ProfileUpdateStatus.updating));

    try {
      await Future.delayed(const Duration(milliseconds: 500));

      final updatedUser = state.user!.copyWith(
        name: name ?? state.user!.name,
        phone: phone ?? state.user!.phone,
        avatar: avatar ?? state.user!.avatar,
        gender: gender ?? state.user!.gender,
        dateOfBirth: dateOfBirth ?? state.user!.dateOfBirth,
      );

      emit(
        state.copyWith(
          user: updatedUser,
          updateStatus: ProfileUpdateStatus.updated,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          updateStatus: ProfileUpdateStatus.error,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  /// Add new address
  Future<void> addAddress(AddressModel address) async {
    emit(state.copyWith(addressStatus: AddressStatus.saving));

    try {
      await Future.delayed(const Duration(milliseconds: 500));

      final updatedAddresses = [...state.addresses, address];

      emit(
        state.copyWith(
          addresses: updatedAddresses,
          addressStatus: AddressStatus.saved,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          addressStatus: AddressStatus.error,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  /// Update address
  Future<void> updateAddress(AddressModel address) async {
    emit(state.copyWith(addressStatus: AddressStatus.saving));

    try {
      await Future.delayed(const Duration(milliseconds: 500));

      final updatedAddresses = state.addresses.map((a) {
        if (a.id == address.id) return address;
        return a;
      }).toList();

      emit(
        state.copyWith(
          addresses: updatedAddresses,
          addressStatus: AddressStatus.saved,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          addressStatus: AddressStatus.error,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  /// Delete address
  Future<void> deleteAddress(String addressId) async {
    emit(state.copyWith(addressStatus: AddressStatus.deleting));

    try {
      await Future.delayed(const Duration(milliseconds: 300));

      final updatedAddresses = state.addresses
          .where((a) => a.id != addressId)
          .toList();

      emit(
        state.copyWith(
          addresses: updatedAddresses,
          addressStatus: AddressStatus.saved,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          addressStatus: AddressStatus.error,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  /// Set default address
  Future<void> setDefaultAddress(String addressId) async {
    try {
      final updatedAddresses = state.addresses.map((a) {
        return a.copyWith(isDefault: a.id == addressId);
      }).toList();

      emit(state.copyWith(addresses: updatedAddresses));
    } catch (e) {
      emit(state.copyWith(errorMessage: e.toString()));
    }
  }

  /// Change password
  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    emit(state.copyWith(passwordStatus: PasswordStatus.changing));

    try {
      // TODO: Call API to change password
      await Future.delayed(const Duration(milliseconds: 500));

      emit(state.copyWith(passwordStatus: PasswordStatus.changed));
    } catch (e) {
      emit(
        state.copyWith(
          passwordStatus: PasswordStatus.error,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  /// Upload avatar
  Future<void> uploadAvatar(String imagePath) async {
    emit(state.copyWith(avatarStatus: AvatarStatus.uploading));

    try {
      // TODO: Upload image and get URL
      await Future.delayed(const Duration(seconds: 1));

      final updatedUser = state.user?.copyWith(
        avatar: 'https://placehold.co/150x150',
      );

      emit(
        state.copyWith(user: updatedUser, avatarStatus: AvatarStatus.uploaded),
      );
    } catch (e) {
      emit(
        state.copyWith(
          avatarStatus: AvatarStatus.error,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  /// Reset states
  void resetUpdateStatus() {
    emit(state.copyWith(updateStatus: ProfileUpdateStatus.initial));
  }

  void resetPasswordStatus() {
    emit(state.copyWith(passwordStatus: PasswordStatus.initial));
  }

  void resetAddressStatus() {
    emit(state.copyWith(addressStatus: AddressStatus.initial));
  }
}
