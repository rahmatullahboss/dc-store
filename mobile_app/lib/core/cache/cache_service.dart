/// Cache Service - Centralized caching with Hive
/// Features: TTL-based expiry, type-safe boxes, cache invalidation
library;

import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

/// Cache configuration
class CacheConfig {
  /// Default cache duration (5 minutes)
  static const Duration defaultTTL = Duration(minutes: 5);

  /// Product list cache duration
  static const Duration productListTTL = Duration(minutes: 5);

  /// Individual product cache duration
  static const Duration productDetailTTL = Duration(minutes: 10);

  /// Search results cache duration
  static const Duration searchTTL = Duration(minutes: 2);

  /// Category cache duration
  static const Duration categoryTTL = Duration(minutes: 30);

  /// User profile cache duration
  static const Duration userTTL = Duration(minutes: 15);

  /// Cart cache duration (short for real-time sync)
  static const Duration cartTTL = Duration(minutes: 1);

  /// Wishlist cache duration
  static const Duration wishlistTTL = Duration(minutes: 5);
}

/// Cache keys for different data types
class CacheKeys {
  static const String products = 'products';
  static const String productDetail = 'product_detail_';
  static const String featuredProducts = 'featured_products';
  static const String newArrivals = 'new_arrivals';
  static const String searchResults = 'search_';
  static const String categories = 'categories';
  static const String categoryProducts = 'category_products_';
  static const String user = 'user';
  static const String cart = 'cart';
  static const String wishlist = 'wishlist';
  static const String orders = 'orders';
  static const String orderDetail = 'order_detail_';
  static const String addresses = 'addresses';
  static const String reviews = 'reviews_';
  static const String cacheMeta = 'cache_meta';
}

/// Cache box names
class CacheBoxes {
  static const String products = 'products_cache';
  static const String categories = 'categories_cache';
  static const String user = 'user_cache';
  static const String cart = 'cart_cache';
  static const String orders = 'orders_cache';
  static const String meta = 'cache_meta';
}

/// Cache entry with metadata
class CacheEntry<T> {
  final T data;
  final DateTime cachedAt;
  final Duration ttl;

  CacheEntry({required this.data, required this.cachedAt, required this.ttl});

  bool get isExpired => DateTime.now().difference(cachedAt) > ttl;

  bool get isStale => DateTime.now().difference(cachedAt) > (ttl * 0.8);

  Map<String, dynamic> toJson(Object Function(T) dataToJson) => {
    'data': dataToJson(data),
    'cachedAt': cachedAt.toIso8601String(),
    'ttlMs': ttl.inMilliseconds,
  };

  factory CacheEntry.fromJson(
    Map<String, dynamic> json,
    T Function(Object) dataFromJson,
  ) {
    return CacheEntry(
      data: dataFromJson(json['data']),
      cachedAt: DateTime.parse(json['cachedAt'] as String),
      ttl: Duration(milliseconds: json['ttlMs'] as int),
    );
  }
}

/// Cache Service for managing all app caches
class CacheService {
  late Box<String> _metaBox;
  late Box<String> _productsBox;
  late Box<String> _categoriesBox;
  late Box<String> _userBox;
  late Box<String> _cartBox;
  late Box<String> _ordersBox;

  bool _initialized = false;

  /// Initialize all cache boxes
  Future<void> init() async {
    if (_initialized) return;

    await Hive.initFlutter();

    _metaBox = await Hive.openBox<String>(CacheBoxes.meta);
    _productsBox = await Hive.openBox<String>(CacheBoxes.products);
    _categoriesBox = await Hive.openBox<String>(CacheBoxes.categories);
    _userBox = await Hive.openBox<String>(CacheBoxes.user);
    _cartBox = await Hive.openBox<String>(CacheBoxes.cart);
    _ordersBox = await Hive.openBox<String>(CacheBoxes.orders);

    _initialized = true;
    debugPrint('CacheService initialized');
  }

  // ═══════════════════════════════════════════════════════════════
  // GENERIC CACHE OPERATIONS
  // ═══════════════════════════════════════════════════════════════

  /// Get cached data with expiry check
  Future<T?> get<T>({
    required String key,
    required String boxName,
    required T Function(Map<String, dynamic>) fromJson,
  }) async {
    try {
      final box = _getBox(boxName);
      final cached = box.get(key);

      if (cached == null) return null;

      final json = jsonDecode(cached) as Map<String, dynamic>;
      final entry = CacheEntry<Map<String, dynamic>>.fromJson(
        json,
        (data) => data as Map<String, dynamic>,
      );

      if (entry.isExpired) {
        await delete(key: key, boxName: boxName);
        return null;
      }

      return fromJson(entry.data);
    } catch (e) {
      debugPrint('Cache get error for $key: $e');
      return null;
    }
  }

  /// Get cached list data with expiry check
  Future<List<T>?> getList<T>({
    required String key,
    required String boxName,
    required T Function(Map<String, dynamic>) fromJson,
  }) async {
    try {
      final box = _getBox(boxName);
      final cached = box.get(key);

      if (cached == null) return null;

      final json = jsonDecode(cached) as Map<String, dynamic>;
      final cachedAt = DateTime.parse(json['cachedAt'] as String);
      final ttlMs = json['ttlMs'] as int;
      final ttl = Duration(milliseconds: ttlMs);

      if (DateTime.now().difference(cachedAt) > ttl) {
        await delete(key: key, boxName: boxName);
        return null;
      }

      final dataList = json['data'] as List;
      return dataList
          .map((item) => fromJson(item as Map<String, dynamic>))
          .toList();
    } catch (e) {
      debugPrint('Cache getList error for $key: $e');
      return null;
    }
  }

  /// Set cached data with TTL
  Future<void> set<T>({
    required String key,
    required String boxName,
    required T data,
    required Map<String, dynamic> Function(T) toJson,
    Duration ttl = CacheConfig.defaultTTL,
  }) async {
    try {
      final box = _getBox(boxName);
      final entry = {
        'data': toJson(data),
        'cachedAt': DateTime.now().toIso8601String(),
        'ttlMs': ttl.inMilliseconds,
      };
      await box.put(key, jsonEncode(entry));
    } catch (e) {
      debugPrint('Cache set error for $key: $e');
    }
  }

  /// Set cached list data with TTL
  Future<void> setList<T>({
    required String key,
    required String boxName,
    required List<T> data,
    required Map<String, dynamic> Function(T) toJson,
    Duration ttl = CacheConfig.defaultTTL,
  }) async {
    try {
      final box = _getBox(boxName);
      final entry = {
        'data': data.map((item) => toJson(item)).toList(),
        'cachedAt': DateTime.now().toIso8601String(),
        'ttlMs': ttl.inMilliseconds,
      };
      await box.put(key, jsonEncode(entry));
    } catch (e) {
      debugPrint('Cache setList error for $key: $e');
    }
  }

  /// Delete cache entry
  Future<void> delete({required String key, required String boxName}) async {
    try {
      final box = _getBox(boxName);
      await box.delete(key);
    } catch (e) {
      debugPrint('Cache delete error for $key: $e');
    }
  }

  /// Delete all entries matching a prefix
  Future<void> deleteByPrefix({
    required String prefix,
    required String boxName,
  }) async {
    try {
      final box = _getBox(boxName);
      final keysToDelete = box.keys
          .where((key) => key.toString().startsWith(prefix))
          .toList();

      for (final key in keysToDelete) {
        await box.delete(key);
      }
    } catch (e) {
      debugPrint('Cache deleteByPrefix error for $prefix: $e');
    }
  }

  /// Clear specific box
  Future<void> clearBox(String boxName) async {
    try {
      final box = _getBox(boxName);
      await box.clear();
    } catch (e) {
      debugPrint('Cache clear error for $boxName: $e');
    }
  }

  /// Clear all caches
  Future<void> clearAll() async {
    try {
      await _productsBox.clear();
      await _categoriesBox.clear();
      await _userBox.clear();
      await _cartBox.clear();
      await _ordersBox.clear();
      await _metaBox.clear();
      debugPrint('All caches cleared');
    } catch (e) {
      debugPrint('Clear all caches error: $e');
    }
  }

  // ═══════════════════════════════════════════════════════════════
  // CACHE STALENESS CHECK
  // ═══════════════════════════════════════════════════════════════

  /// Check if cache is stale (80% of TTL passed) but not expired
  Future<bool> isStale({required String key, required String boxName}) async {
    try {
      final box = _getBox(boxName);
      final cached = box.get(key);

      if (cached == null) return true;

      final json = jsonDecode(cached) as Map<String, dynamic>;
      final cachedAt = DateTime.parse(json['cachedAt'] as String);
      final ttlMs = json['ttlMs'] as int;
      final ttl = Duration(milliseconds: ttlMs);
      final staleTtl = Duration(milliseconds: (ttlMs * 0.8).round());

      final age = DateTime.now().difference(cachedAt);
      return age > staleTtl && age <= ttl;
    } catch (e) {
      return true;
    }
  }

  // ═══════════════════════════════════════════════════════════════
  // HELPER METHODS
  // ═══════════════════════════════════════════════════════════════

  Box<String> _getBox(String boxName) {
    switch (boxName) {
      case CacheBoxes.products:
        return _productsBox;
      case CacheBoxes.categories:
        return _categoriesBox;
      case CacheBoxes.user:
        return _userBox;
      case CacheBoxes.cart:
        return _cartBox;
      case CacheBoxes.orders:
        return _ordersBox;
      case CacheBoxes.meta:
        return _metaBox;
      default:
        throw ArgumentError('Unknown box name: $boxName');
    }
  }

  /// Get cache statistics
  Map<String, int> get stats => {
    'products': _productsBox.length,
    'categories': _categoriesBox.length,
    'user': _userBox.length,
    'cart': _cartBox.length,
    'orders': _ordersBox.length,
  };
}

// ═══════════════════════════════════════════════════════════════
// PROVIDER
// ═══════════════════════════════════════════════════════════════

final cacheServiceProvider = Provider<CacheService>((ref) {
  return CacheService();
});
