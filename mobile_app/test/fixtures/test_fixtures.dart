// Common test fixtures as JSON data

/// Sample product JSON
const sampleProductJson = {
  'id': 'product_1',
  'name': 'Test Product',
  'slug': 'test-product',
  'description': 'A test product description',
  'price': 1000.0,
  'salePrice': 800.0,
  'stock': 50,
  'categoryId': 'cat_1',
  'images': [
    {
      'id': 'img_1',
      'url': 'https://example.com/product.jpg',
      'alt': 'Product image',
      'isDefault': true,
    },
  ],
  'isFeatured': true,
  'isActive': true,
  'rating': 4.5,
  'reviewCount': 25,
  'createdAt': '2024-01-01T00:00:00Z',
  'updatedAt': '2024-01-01T00:00:00Z',
};

/// Sample product list JSON
const sampleProductsJson = {
  'data': [
    sampleProductJson,
    {
      'id': 'product_2',
      'name': 'Another Product',
      'slug': 'another-product',
      'description': 'Another product description',
      'price': 1500.0,
      'stock': 30,
      'categoryId': 'cat_1',
      'images': <Map<String, dynamic>>[],
      'isFeatured': false,
      'isActive': true,
      'rating': 4.0,
      'reviewCount': 10,
      'createdAt': '2024-01-01T00:00:00Z',
      'updatedAt': '2024-01-01T00:00:00Z',
    },
  ],
  'pagination': {'currentPage': 1, 'lastPage': 5, 'perPage': 20, 'total': 100},
};

/// Sample user JSON
const sampleUserJson = {
  'id': 'user_1',
  'email': 'test@example.com',
  'name': 'Test User',
  'phone': '+8801700000000',
  'avatar': 'https://example.com/avatar.jpg',
};

/// Sample auth response JSON
const sampleAuthResponseJson = {
  'user': sampleUserJson,
  'tokens': {
    'accessToken': 'mock_access_token',
    'refreshToken': 'mock_refresh_token',
    'expiresAt': '2024-01-01T01:00:00Z',
  },
};

/// Sample category JSON
const sampleCategoryJson = {
  'id': 'cat_1',
  'name': 'Electronics',
  'slug': 'electronics',
  'description': 'Electronics category',
  'image': 'https://example.com/category.jpg',
  'parentId': null,
  'productCount': 50,
  'isActive': true,
};

/// Sample cart JSON
const sampleCartJson = {
  'items': [
    {
      'id': 'cart_item_1',
      'productId': 'product_1',
      'productName': 'Test Product',
      'productImage': 'https://example.com/product.jpg',
      'price': 1000.0,
      'quantity': 2,
      'variantId': null,
      'variantName': null,
    },
  ],
  'coupon': null,
};

/// Sample order JSON
const sampleOrderJson = {
  'id': 'order_1',
  'orderNumber': 'ORD-2024-001',
  'status': 'pending',
  'items': [
    {
      'id': 'item_1',
      'productId': 'product_1',
      'productName': 'Test Product',
      'productImage': 'https://example.com/product.jpg',
      'price': 1000.0,
      'quantity': 2,
      'total': 2000.0,
    },
  ],
  'shippingAddress': {
    'id': 'addr_1',
    'fullName': 'Test User',
    'phone': '+8801700000000',
    'street': '123 Test Street',
    'city': 'Dhaka',
    'state': 'Dhaka',
    'postalCode': '1212',
    'isDefault': true,
  },
  'totals': {
    'subtotal': 2000.0,
    'discount': 0.0,
    'shipping': 100.0,
    'tax': 0.0,
    'total': 2100.0,
  },
  'paymentMethod': 'cod',
  'paymentStatus': 'pending',
  'createdAt': '2024-01-01T00:00:00Z',
  'updatedAt': '2024-01-01T00:00:00Z',
};

/// Sample address JSON
const sampleAddressJson = {
  'id': 'addr_1',
  'fullName': 'Test User',
  'phone': '+8801700000000',
  'street': '123 Test Street',
  'city': 'Dhaka',
  'state': 'Dhaka',
  'postalCode': '1212',
  'isDefault': true,
};

/// Sample error response JSON
const sampleErrorJson = {
  'message': 'An error occurred',
  'code': 'ERROR_001',
  'errors': {
    'email': ['Email is required'],
    'password': ['Password must be at least 8 characters'],
  },
};

/// Sample validation error JSON
const sampleValidationErrorJson = {
  'message': 'Validation failed',
  'errors': {
    'email': ['Invalid email format'],
  },
};
