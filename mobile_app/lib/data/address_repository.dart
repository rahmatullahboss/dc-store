/// Address Repository - Business logic layer for addresses
library;

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/errors/failures.dart';
import '../core/errors/exceptions.dart';
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
    } on ServerException catch (e) {
      debugPrint('Failed to fetch addresses: ${e.message}');
      return [];
    } catch (e) {
      debugPrint('Failed to fetch addresses: $e');
      return [];
    }
  }

  /// Add a new address
  Future<AddressModel?> addAddress(AddressModel address) async {
    try {
      return await _dataSource.addAddress(address);
    } on ServerException catch (e) {
      debugPrint('Failed to add address: ${e.message}');
      return null;
    } catch (e) {
      debugPrint('Failed to add address: $e');
      return null;
    }
  }

  /// Update an existing address
  Future<AddressModel?> updateAddress(AddressModel address) async {
    try {
      return await _dataSource.updateAddress(address);
    } on ServerException catch (e) {
      debugPrint('Failed to update address: ${e.message}');
      return null;
    } catch (e) {
      debugPrint('Failed to update address: $e');
      return null;
    }
  }

  /// Delete an address
  Future<bool> deleteAddress(String id) async {
    try {
      await _dataSource.deleteAddress(id);
      return true;
    } on ServerException catch (e) {
      debugPrint('Failed to delete address: ${e.message}');
      return false;
    } catch (e) {
      debugPrint('Failed to delete address: $e');
      return false;
    }
  }
}
