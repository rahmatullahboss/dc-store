import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_app/data/models/models.dart';
import '../../fixtures/test_fixtures.dart';

void main() {
  group('ProductModel', () {
    test('fromJson creates valid ProductModel', () {
      final product = ProductModel.fromJson(sampleProductJson);

      expect(product.id, equals('product_1'));
      expect(product.name, equals('Test Product'));
      expect(product.price, equals(1000.0));
      expect(product.salePrice, equals(800.0));
      expect(product.stock, equals(50));
      expect(product.isFeatured, isTrue);
      expect(product.images, isNotEmpty);
    });

    test('toJson creates valid JSON', () {
      final product = ProductModel.fromJson(sampleProductJson);
      final json = product.toJson();

      expect(json['id'], equals('product_1'));
      expect(json['name'], equals('Test Product'));
      expect(json['price'], equals(1000.0));
    });

    test('isOnSale returns true when salePrice is set', () {
      final product = ProductModel.fromJson(sampleProductJson);
      expect(product.isOnSale, isTrue);
    });

    test('effectivePrice returns salePrice when available', () {
      final product = ProductModel.fromJson(sampleProductJson);
      expect(product.effectivePrice, equals(800.0));
    });

    test('inStock returns true when stock > 0', () {
      final product = ProductModel.fromJson(sampleProductJson);
      expect(product.inStock, isTrue);
    });
  });

  group('UserModel', () {
    test('fromJson creates valid UserModel', () {
      final user = UserModel.fromJson(sampleUserJson);

      expect(user.id, equals('user_1'));
      expect(user.email, equals('test@example.com'));
      expect(user.name, equals('Test User'));
      expect(user.phone, equals('+8801700000000'));
    });

    test('toJson creates valid JSON', () {
      final user = UserModel.fromJson(sampleUserJson);
      final json = user.toJson();

      expect(json['id'], equals('user_1'));
      expect(json['email'], equals('test@example.com'));
    });
  });

  group('AuthResponseModel', () {
    test('fromJson creates valid AuthResponseModel', () {
      final authResponse = AuthResponseModel.fromJson(sampleAuthResponseJson);

      expect(authResponse.user.id, equals('user_1'));
      expect(authResponse.tokens.accessToken, equals('mock_access_token'));
      expect(authResponse.tokens.refreshToken, equals('mock_refresh_token'));
    });
  });

  group('CategoryModel', () {
    test('fromJson creates valid CategoryModel', () {
      final category = CategoryModel.fromJson(sampleCategoryJson);

      expect(category.id, equals('cat_1'));
      expect(category.name, equals('Electronics'));
      expect(category.productCount, equals(50));
    });

    test('isRoot returns true when parentId is null', () {
      final category = CategoryModel.fromJson(sampleCategoryJson);
      expect(category.isRoot, isTrue);
    });
  });

  group('CartItemModel', () {
    test('fromJson creates valid CartItemModel', () {
      final cartItem = CartItemModel.fromJson(
        (sampleCartJson['items'] as List).first as Map<String, dynamic>,
      );

      expect(cartItem.id, equals('cart_item_1'));
      expect(cartItem.productId, equals('product_1'));
      expect(cartItem.quantity, equals(2));
    });

    test('lineTotal calculates correctly', () {
      final cartItem = CartItemModel.fromJson(
        (sampleCartJson['items'] as List).first as Map<String, dynamic>,
      );
      // price * quantity = 1000 * 2 = 2000
      expect(cartItem.lineTotal, equals(2000.0));
    });
  });

  group('OrderModel', () {
    test('fromJson creates valid OrderModel', () {
      final order = OrderModel.fromJson(sampleOrderJson);

      expect(order.id, equals('order_1'));
      expect(order.orderNumber, equals('ORD-2024-001'));
      expect(order.status, equals(OrderStatus.pending));
      expect(order.items, isNotEmpty);
    });

    test('status enum maps correctly', () {
      final order = OrderModel.fromJson(sampleOrderJson);
      expect(order.status, equals(OrderStatus.pending));
    });

    test('shippingAddress is valid', () {
      final order = OrderModel.fromJson(sampleOrderJson);
      expect(order.shippingAddress.city, equals('Dhaka'));
    });

    test('totals are calculated correctly', () {
      final order = OrderModel.fromJson(sampleOrderJson);
      expect(order.totals.subtotal, equals(2000.0));
      expect(order.totals.shipping, equals(100.0));
      expect(order.totals.total, equals(2100.0));
    });
  });

  group('AddressModel', () {
    test('fromJson creates valid AddressModel', () {
      final address = AddressModel.fromJson(sampleAddressJson);

      expect(address.id, equals('addr_1'));
      expect(address.city, equals('Dhaka'));
      expect(address.isDefault, isTrue);
    });
  });
}
