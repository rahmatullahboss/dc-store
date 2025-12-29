import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:dc_store/data/address_repository.dart';
import 'package:dc_store/data/datasources/remote/address_remote_datasource.dart';
import 'package:dc_store/data/models/address/address_model.dart';
import 'package:dc_store/core/errors/exceptions.dart';

class MockAddressRemoteDataSource extends Mock
    implements AddressRemoteDataSource {}

void main() {
  late AddressRepository repository;
  late MockAddressRemoteDataSource mockDataSource;

  setUp(() {
    mockDataSource = MockAddressRemoteDataSource();
    repository = AddressRepository(mockDataSource);
    registerFallbackValue(
      AddressModel(
        id: '1',
        userId: 'user1',
        name: 'Test',
        phone: '123',
        addressLine1: 'Line 1',
        city: 'City',
        state: 'State',
        zipCode: '12345',
        country: 'Country',
        type: AddressType.home,
      ),
    );
  });

  group('AddressRepository Error Handling', () {
    test('getAddresses should rethrow exception from dataSource', () async {
      when(
        () => mockDataSource.getAddresses(),
      ).thenThrow(ServerException(message: 'Error'));

      expect(() => repository.getAddresses(), throwsA(isA<ServerException>()));
    });

    test('addAddress should rethrow exception from dataSource', () async {
      final address = AddressModel(
        id: '1',
        userId: 'user1',
        name: 'Test',
        phone: '123',
        addressLine1: 'Line 1',
        city: 'City',
        state: 'State',
        zipCode: '12345',
        country: 'Country',
        type: AddressType.home,
      );
      when(
        () => mockDataSource.addAddress(any()),
      ).thenThrow(ServerException(message: 'Error'));

      expect(
        () => repository.addAddress(address),
        throwsA(isA<ServerException>()),
      );
    });

    test('updateAddress should rethrow exception from dataSource', () async {
      final address = AddressModel(
        id: '1',
        userId: 'user1',
        name: 'Test',
        phone: '123',
        addressLine1: 'Line 1',
        city: 'City',
        state: 'State',
        zipCode: '12345',
        country: 'Country',
        type: AddressType.home,
      );
      when(
        () => mockDataSource.updateAddress(any()),
      ).thenThrow(ServerException(message: 'Error'));

      expect(
        () => repository.updateAddress(address),
        throwsA(isA<ServerException>()),
      );
    });

    test('deleteAddress should rethrow exception from dataSource', () async {
      when(
        () => mockDataSource.deleteAddress(any()),
      ).thenThrow(ServerException(message: 'Error'));

      expect(
        () => repository.deleteAddress('1'),
        throwsA(isA<ServerException>()),
      );
    });
  });
}
