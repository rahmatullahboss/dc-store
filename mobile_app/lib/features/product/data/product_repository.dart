import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../../../core/config/app_config.dart';
import '../domain/product_model.dart';

class ProductRepository {
  Future<List<Product>> getProducts() async {
    try {
      // Use the correct API endpoint: /api/products/search
      final response = await http.get(
        Uri.parse('${AppConfig.baseUrl}/api/products/search'),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        final List<dynamic> products = data['products'] ?? [];
        return products.map((json) => Product.fromJson(json)).toList();
      }
    } catch (e) {
      debugPrint('Error fetching products: $e');
    }

    // Fallback to dummy data if API fails
    return _getDummyProducts();
  }

  Future<Product?> getProductById(String id) async {
    try {
      // For now, get all products and filter
      final products = await getProducts();
      return products.firstWhere((p) => p.id == id || p.slug == id);
    } catch (e) {
      debugPrint('Error fetching product by ID: $e');
      return null;
    }
  }

  Future<List<Product>> searchProducts(String query) async {
    if (query.trim().isEmpty) {
      return [];
    }

    try {
      final response = await http.get(
        Uri.parse(
          '${AppConfig.baseUrl}/api/products/search?q=${Uri.encodeComponent(query)}',
        ),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        final List<dynamic> products = data['products'] ?? [];
        return products.map((json) => Product.fromJson(json)).toList();
      }
    } catch (e) {
      debugPrint('Error searching products: $e');
    }

    // Return empty list on search failure (don't show dummy data for search)
    return [];
  }

  Future<List<Product>> _getDummyProducts() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return List.generate(
      8,
      (index) => Product(
        id: "prod-$index",
        name: "Premium Product ${index + 1}",
        slug: "premium-product-${index + 1}",
        description:
            "This is a detailed description of the premium product. It features high quality materials and excellent craftsmanship. Perfect for your daily needs.",
        price: 99.99 + (index * 20),
        compareAtPrice: index % 2 == 0 ? 129.99 + (index * 20) : null,
        featuredImage:
            "https://images.unsplash.com/photo-1523275335684-37898b6baf30?auto=format&fit=crop&w=500&q=80",
        images: [
          "https://images.unsplash.com/photo-1523275335684-37898b6baf30?auto=format&fit=crop&w=500&q=80",
          "https://images.unsplash.com/photo-1505740420928-5e560c06d30e?auto=format&fit=crop&w=500&q=80",
        ],
        categoryId: "Electronics",
        isFeatured: index < 4,
        stock: 10,
      ),
    );
  }
}
