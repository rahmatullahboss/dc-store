import 'package:mobile_app/data/models/models.dart';

/// Factory for creating mock Product data
class ProductFactory {
  static ProductModel create({
    String? id,
    String? name,
    String? description,
    double? price,
    double? salePrice,
    int? stock,
    String? categoryId,
    List<ProductImageModel>? images,
    bool? isFeatured,
    double? rating,
    int? reviewCount,
  }) {
    return ProductModel(
      id: id ?? 'product_${DateTime.now().millisecondsSinceEpoch}',
      name: name ?? 'Test Product',
      slug: 'test-product',
      description: description ?? 'This is a test product description',
      price: price ?? 1000.0,
      salePrice: salePrice,
      stock: stock ?? 100,
      categoryId: categoryId ?? 'cat_1',
      images:
          images ??
          [
            const ProductImageModel(
              id: 'img_1',
              url: 'https://example.com/image.jpg',
              alt: 'Product Image',
              isDefault: true,
            ),
          ],
      isFeatured: isFeatured ?? false,
      isActive: true,
      rating: rating ?? 4.5,
      reviewCount: reviewCount ?? 10,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
  }

  static List<ProductModel> createList(int count) {
    return List.generate(
      count,
      (index) => create(
        id: 'product_$index',
        name: 'Test Product $index',
        price: 1000.0 + (index * 100),
      ),
    );
  }
}

/// Factory for creating mock User data
class UserFactory {
  static UserModel create({
    String? id,
    String? email,
    String? name,
    String? phone,
    String? avatar,
  }) {
    return UserModel(
      id: id ?? 'user_${DateTime.now().millisecondsSinceEpoch}',
      email: email ?? 'test@example.com',
      name: name ?? 'Test User',
      phone: phone,
      avatar: avatar,
    );
  }
}

/// Factory for creating mock Address data
class AddressFactory {
  static AddressModel create({
    String? id,
    String? fullName,
    String? phone,
    String? street,
    String? city,
    String? state,
    String? postalCode,
    bool? isDefault,
  }) {
    return AddressModel(
      id: id ?? 'addr_${DateTime.now().millisecondsSinceEpoch}',
      fullName: fullName ?? 'Test User',
      phone: phone ?? '+8801700000000',
      street: street ?? '123 Test Street',
      city: city ?? 'Dhaka',
      state: state ?? 'Dhaka',
      postalCode: postalCode ?? '1212',
      isDefault: isDefault ?? false,
    );
  }

  static List<AddressModel> createList(int count) {
    return List.generate(
      count,
      (index) => create(
        id: 'addr_$index',
        fullName: 'User $index',
        isDefault: index == 0,
      ),
    );
  }
}

/// Factory for creating mock Category data
class CategoryFactory {
  static CategoryModel create({
    String? id,
    String? name,
    String? description,
    String? image,
    String? parentId,
    int? productCount,
  }) {
    return CategoryModel(
      id: id ?? 'cat_${DateTime.now().millisecondsSinceEpoch}',
      name: name ?? 'Test Category',
      slug: 'test-category',
      description: description ?? 'Test category description',
      image: image ?? 'https://example.com/category.jpg',
      parentId: parentId,
      productCount: productCount ?? 10,
      isActive: true,
    );
  }

  static List<CategoryModel> createList(int count) {
    return List.generate(
      count,
      (index) => create(id: 'cat_$index', name: 'Category $index'),
    );
  }
}

/// Factory for creating mock Cart data
class CartFactory {
  static CartItemModel createItem({
    String? id,
    String? productId,
    String? productName,
    double? price,
    int? quantity,
    String? image,
  }) {
    return CartItemModel(
      id: id ?? 'cart_item_${DateTime.now().millisecondsSinceEpoch}',
      productId: productId ?? 'product_1',
      productName: productName ?? 'Test Product',
      productImage: image ?? 'https://example.com/product.jpg',
      price: price ?? 1000.0,
      quantity: quantity ?? 1,
    );
  }

  static CartModel createCart({
    List<CartItemModel>? items,
    CouponModel? coupon,
  }) {
    final cartItems =
        items ??
        [createItem(), createItem(id: 'item_2', productId: 'product_2')];
    return CartModel(items: cartItems, coupon: coupon);
  }

  static CouponModel createCoupon({
    String? code,
    double? discountPercent,
    double? discountAmount,
  }) {
    return CouponModel(
      code: code ?? 'TEST10',
      type: 'percentage',
      value: discountPercent ?? 10.0,
      minOrderAmount: 500.0,
      maxDiscount: discountAmount,
    );
  }
}

/// Factory for creating mock Order data
class OrderFactory {
  static OrderModel create({
    String? id,
    OrderStatus? status,
    List<OrderItemModel>? items,
    AddressModel? shippingAddress,
    double? total,
  }) {
    return OrderModel(
      id: id ?? 'order_${DateTime.now().millisecondsSinceEpoch}',
      orderNumber: 'ORD-${DateTime.now().year}-001',
      status: status ?? OrderStatus.pending,
      items:
          items ??
          [
            const OrderItemModel(
              id: 'item_1',
              productId: 'product_1',
              productName: 'Test Product',
              productImage: 'https://example.com/product.jpg',
              price: 1000.0,
              quantity: 2,
              total: 2000.0,
            ),
          ],
      shippingAddress: shippingAddress ?? AddressFactory.create(),
      totals: OrderTotalsModel(
        subtotal: 2000.0,
        discount: 0.0,
        shipping: 100.0,
        tax: 0.0,
        total: total ?? 2100.0,
      ),
      paymentMethod: 'cod',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
  }

  static List<OrderModel> createList(int count) {
    return List.generate(
      count,
      (index) => create(
        id: 'order_$index',
        status: OrderStatus.values[index % OrderStatus.values.length],
      ),
    );
  }
}

/// Factory for creating mock Auth Response
class AuthFactory {
  static AuthResponseModel createAuthResponse({
    UserModel? user,
    String? accessToken,
    String? refreshToken,
  }) {
    return AuthResponseModel(
      user: user ?? UserFactory.create(),
      tokens: TokenModel(
        accessToken:
            accessToken ??
            'mock_access_token_${DateTime.now().millisecondsSinceEpoch}',
        refreshToken: refreshToken ?? 'mock_refresh_token',
        expiresAt: DateTime.now().add(const Duration(hours: 1)),
      ),
    );
  }
}
