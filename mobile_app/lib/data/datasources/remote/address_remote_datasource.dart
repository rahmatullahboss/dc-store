/// Address Remote Data Source - API calls for user addresses
library;

import '../../../core/network/dio_client.dart';
import '../../../core/constants/api_constants.dart';
import '../../../core/errors/exceptions.dart';
import '../../models/address/address_model.dart';

/// Abstract interface for address data operations
abstract class AddressRemoteDataSourceBase {
  Future<List<AddressModel>> getAddresses();
  Future<AddressModel> addAddress(AddressModel address);
  Future<AddressModel> updateAddress(AddressModel address);
  Future<void> deleteAddress(String id);
}

/// Implementation of address remote data source
class AddressRemoteDataSource implements AddressRemoteDataSourceBase {
  final DioClient _client;

  AddressRemoteDataSource(this._client);

  @override
  Future<List<AddressModel>> getAddresses() async {
    final response = await _client.get<Map<String, dynamic>>(
      ApiConstants.userAddresses,
    );

    if (!response.isSuccess || response.data == null) {
      throw ServerException(
        message: response.message ?? 'Failed to fetch addresses',
        statusCode: response.error?.statusCode,
      );
    }

    final data = response.data!;
    final addressesList = data['addresses'] as List? ?? [];
    return addressesList
        .map((item) => AddressModel.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<AddressModel> addAddress(AddressModel address) async {
    final response = await _client.post<Map<String, dynamic>>(
      ApiConstants.userAddresses,
      data: {
        'name': address.name,
        'phone': address.phone,
        'addressLine1': address.addressLine1,
        'addressLine2': address.addressLine2,
        'city': address.city,
        'state': address.state,
        'zipCode': address.zipCode,
        'country': address.country,
        'type': address.type.name,
        'isDefault': address.isDefault,
      },
    );

    if (!response.isSuccess || response.data == null) {
      throw ServerException(
        message: response.message ?? 'Failed to add address',
        statusCode: response.error?.statusCode,
      );
    }

    final data = response.data!;
    return AddressModel.fromJson(data['address'] as Map<String, dynamic>);
  }

  @override
  Future<AddressModel> updateAddress(AddressModel address) async {
    final response = await _client.put<Map<String, dynamic>>(
      ApiConstants.userAddresses,
      data: {
        'id': address.id,
        'name': address.name,
        'phone': address.phone,
        'addressLine1': address.addressLine1,
        'addressLine2': address.addressLine2,
        'city': address.city,
        'state': address.state,
        'zipCode': address.zipCode,
        'country': address.country,
        'type': address.type.name,
        'isDefault': address.isDefault,
      },
    );

    if (!response.isSuccess || response.data == null) {
      throw ServerException(
        message: response.message ?? 'Failed to update address',
        statusCode: response.error?.statusCode,
      );
    }

    final data = response.data!;
    return AddressModel.fromJson(data['address'] as Map<String, dynamic>);
  }

  @override
  Future<void> deleteAddress(String id) async {
    final response = await _client.delete<Map<String, dynamic>>(
      '${ApiConstants.userAddresses}?id=$id',
    );

    if (!response.isSuccess) {
      throw ServerException(
        message: response.message ?? 'Failed to delete address',
        statusCode: response.error?.statusCode,
      );
    }
  }
}
