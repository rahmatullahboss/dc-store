/// Address Repository - Business logic layer for addresses
library;

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/errors/failures.dart';
import '../core/network/dio_client.dart';
import 'datasources/remote/address_remote_datasource.dart';
import 'models/address/address_model.dart';

/// Address repository provider
final addressRepositoryProvider = Provider<AddressRepository>((ref) {
  final client = ref.watch(dioClientProvider);
  final dataSource = AddressRemoteDataSource(client);
  return AddressRepository(dataSource);
});

/// Addresses state provider - fetches and caches user addresses
final addressesProvider = FutureProvider<List<AddressModel>>((ref) async {
  final repository = ref.watch(addressRepositoryProvider);
  return repository.getAddresses();
});

/// Address Repository
class AddressRepository {
  final AddressRemoteDataSource _dataSource;

  AddressRepository(this._dataSource);

  /// Get all addresses for the current user
  Future<List<AddressModel>> getAddresses() async {
    try {
      return await _dataSource.getAddresses();
    } catch (e) {
      debugPrint('Failed to fetch addresses: $e');
      rethrow;
    }
  }

  /// Add a new address
  Future<AddressModel> addAddress(AddressModel address) async {
    try {
      return await _dataSource.addAddress(address);
    } catch (e) {
      debugPrint('Failed to add address: $e');
      rethrow;
    }
  }

  /// Update an existing address
  Future<AddressModel> updateAddress(AddressModel address) async {
    try {
      return await _dataSource.updateAddress(address);
    } catch (e) {
      debugPrint('Failed to update address: $e');
      rethrow;
    }
  }

  /// Delete an address
  Future<void> deleteAddress(String id) async {
    try {
      await _dataSource.deleteAddress(id);
    } catch (e) {
      debugPrint('Failed to delete address: $e');
      rethrow;
    }
  }
}
