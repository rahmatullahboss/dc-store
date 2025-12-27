import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../../../core/config/app_config.dart';
import '../domain/product_model.dart';

class ProductRepository {
  Future<List<Product>> getProducts() async {
    try {
      final response = await http.get(
        Uri.parse('${AppConfig.baseUrl}/api/products/search'),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        final List<dynamic> products = data['products'] ?? [];
        return products.map((json) => Product.fromJson(json)).toList();
      } else {
        debugPrint('Failed to fetch products: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      debugPrint('Error fetching products: $e');
      return [];
    }
  }

  Future<Product?> getProductById(String id) async {
    try {
      final response = await http.get(
        Uri.parse('${AppConfig.baseUrl}/api/products/$id'),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['product'] != null) {
          return Product.fromJson(data['product']);
        }
      }

      // Fallback: Get all products and filter
      final products = await getProducts();
      try {
        return products.firstWhere((p) => p.id == id || p.slug == id);
      } catch (_) {
        return null;
      }
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

    return [];
  }

  Future<List<Product>> getProductsByCategory(String categoryId) async {
    try {
      final response = await http.get(
        Uri.parse(
          '${AppConfig.baseUrl}/api/products/search?category=$categoryId',
        ),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        final List<dynamic> products = data['products'] ?? [];
        return products.map((json) => Product.fromJson(json)).toList();
      }
    } catch (e) {
      debugPrint('Error fetching products by category: $e');
    }

    return [];
  }

  Future<List<Product>> getFeaturedProducts() async {
    try {
      final response = await http.get(
        Uri.parse('${AppConfig.baseUrl}/api/products/search?featured=true'),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        final List<dynamic> products = data['products'] ?? [];
        return products.map((json) => Product.fromJson(json)).toList();
      }
    } catch (e) {
      debugPrint('Error fetching featured products: $e');
    }

    return [];
  }
}
