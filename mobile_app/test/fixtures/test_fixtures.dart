// Common test fixtures as JSON data

/// Sample product JSON
const sampleProductJson = {
  'id': 'product_1',
  'name': 'Test Product',
  'slug': 'test-product',
  'description': 'A test product description',
  'price': 1000.0,
  'sale_price': 800.0,
  'stock': 50,
  'category_id': 'cat_1',
  'images': [
    {
      'id': 'img_1',
      'url': 'https://example.com/product.jpg',
      'alt': 'Product image',
      'is_primary': true,
    },
  ],
  'is_featured': true,
  'is_active': true,
  'rating': 4.5,
  'review_count': 25,
  'created_at': '2024-01-01T00:00:00Z',
  'updated_at': '2024-01-01T00:00:00Z',
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
      'category_id': 'cat_1',
      'images': [],
      'is_featured': false,
      'is_active': true,
      'rating': 4.0,
      'review_count': 10,
      'created_at': '2024-01-01T00:00:00Z',
      'updated_at': '2024-01-01T00:00:00Z',
    },
  ],
  'pagination': {
    'current_page': 1,
    'last_page': 5,
    'per_page': 20,
    'total': 100,
  },
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
    'access_token': 'mock_access_token',
    'refresh_token': 'mock_refresh_token',
    'expires_in': 3600,
  },
};

/// Sample category JSON
const sampleCategoryJson = {
  'id': 'cat_1',
  'name': 'Electronics',
  'slug': 'electronics',
  'description': 'Electronics category',
  'image': 'https://example.com/category.jpg',
  'parent_id': null,
  'product_count': 50,
  'is_active': true,
};

/// Sample cart JSON
const sampleCartJson = {
  'items': [
    {
      'id': 'cart_item_1',
      'product_id': 'product_1',
      'product_name': 'Test Product',
      'product_image': 'https://example.com/product.jpg',
      'price': 1000.0,
      'quantity': 2,
      'variant_id': null,
      'variant_name': null,
    },
  ],
  'applied_coupon': null,
};

/// Sample order JSON
const sampleOrderJson = {
  'id': 'order_1',
  'order_number': 'ORD-2024-001',
  'status': 'pending',
  'items': [
    {
      'id': 'item_1',
      'product_id': 'product_1',
      'product_name': 'Test Product',
      'product_image': 'https://example.com/product.jpg',
      'price': 1000.0,
      'quantity': 2,
    },
  ],
  'shipping_address': {
    'id': 'addr_1',
    'name': 'Test User',
    'phone': '+8801700000000',
    'address': '123 Test Street',
    'city': 'Dhaka',
    'area': 'Gulshan',
    'post_code': '1212',
    'is_default': true,
  },
  'totals': {
    'subtotal': 2000.0,
    'discount': 0.0,
    'shipping': 100.0,
    'tax': 0.0,
    'total': 2100.0,
  },
  'payment_method': 'cod',
  'payment_status': 'pending',
  'created_at': '2024-01-01T00:00:00Z',
  'updated_at': '2024-01-01T00:00:00Z',
};

/// Sample address JSON
const sampleAddressJson = {
  'id': 'addr_1',
  'name': 'Test User',
  'phone': '+8801700000000',
  'address': '123 Test Street',
  'city': 'Dhaka',
  'area': 'Gulshan',
  'post_code': '1212',
  'is_default': true,
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
