import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../core/constants/storage_keys.dart';
import '../core/constants/app_constants.dart';

/// CacheService - Handles data and image caching
class CacheService {
  static CacheService? _instance;
  late Box<String> _cacheBox;
  late Box<String> _metadataBox;

  CacheService._();

  static Future<CacheService> getInstance() async {
    if (_instance == null) {
      _instance = CacheService._();
      await _instance!._initialize();
    }
    return _instance!;
  }

  Future<void> _initialize() async {
    await Hive.initFlutter();
    _cacheBox = await Hive.openBox<String>(StorageKeys.cacheBox);
    _metadataBox = await Hive.openBox<String>('cache_metadata');
    debugPrint('CacheService initialized');
  }

  // ═══════════════════════════════════════════════════════════════
  // BASIC CACHE OPERATIONS
  // ═══════════════════════════════════════════════════════════════

  /// Store data in cache
  Future<void> set<T>({
    required String key,
    required T value,
    Duration? expiry,
  }) async {
    try {
      final jsonValue = jsonEncode(value);
      await _cacheBox.put(key, jsonValue);

      // Store expiry metadata if provided
      if (expiry != null) {
        final expiryTime = DateTime.now().add(expiry).toIso8601String();
        await _metadataBox.put('${key}_expiry', expiryTime);
      }
    } catch (e) {
      debugPrint('Cache set error: $e');
    }
  }

  /// Get data from cache
  T? get<T>(String key, {T Function(dynamic)? fromJson}) {
    try {
      // Check if expired
      if (_isExpired(key)) {
        remove(key);
        return null;
      }

      final jsonValue = _cacheBox.get(key);
      if (jsonValue == null) return null;

      final decoded = jsonDecode(jsonValue);
      if (fromJson != null) {
        return fromJson(decoded);
      }
      return decoded as T?;
    } catch (e) {
      debugPrint('Cache get error: $e');
      return null;
    }
  }

  /// Check if cache exists and is valid
  bool has(String key) {
    if (_isExpired(key)) {
      remove(key);
      return false;
    }
    return _cacheBox.containsKey(key);
  }

  /// Remove from cache
  Future<void> remove(String key) async {
    await _cacheBox.delete(key);
    await _metadataBox.delete('${key}_expiry');
  }

  /// Clear all cache
  Future<void> clear() async {
    await _cacheBox.clear();
    await _metadataBox.clear();
    debugPrint('Cache cleared');
  }

  bool _isExpired(String key) {
    final expiryValue = _metadataBox.get('${key}_expiry');
    if (expiryValue == null) return false;

    final expiryTime = DateTime.parse(expiryValue);
    return DateTime.now().isAfter(expiryTime);
  }

  // ═══════════════════════════════════════════════════════════════
  // TYPED CACHE HELPERS
  // ═══════════════════════════════════════════════════════════════

  /// Cache list data
  Future<void> setList<T>({
    required String key,
    required List<T> items,
    Duration? expiry,
  }) async {
    await set(
      key: key,
      value: items,
      expiry: expiry ?? AppConstants.defaultCacheDuration,
    );
  }

  /// Get cached list
  List<T>? getList<T>(String key, {T Function(dynamic)? itemFromJson}) {
    try {
      if (_isExpired(key)) {
        remove(key);
        return null;
      }

      final jsonValue = _cacheBox.get(key);
      if (jsonValue == null) return null;

      final decoded = jsonDecode(jsonValue) as List;
      if (itemFromJson != null) {
        return decoded.map((item) => itemFromJson(item)).toList();
      }
      return decoded.cast<T>();
    } catch (e) {
      debugPrint('Cache getList error: $e');
      return null;
    }
  }

  /// Cache API response
  Future<void> cacheResponse({
    required String endpoint,
    required dynamic data,
    Map<String, dynamic>? queryParams,
    Duration? expiry,
  }) async {
    final cacheKey = _generateCacheKey(endpoint, queryParams);
    await set(
      key: cacheKey,
      value: data,
      expiry: expiry ?? AppConstants.defaultCacheDuration,
    );
  }

  /// Get cached API response
  T? getCachedResponse<T>({
    required String endpoint,
    Map<String, dynamic>? queryParams,
    T Function(dynamic)? fromJson,
  }) {
    final cacheKey = _generateCacheKey(endpoint, queryParams);
    return get<T>(cacheKey, fromJson: fromJson);
  }

  String _generateCacheKey(String endpoint, Map<String, dynamic>? params) {
    if (params == null || params.isEmpty) return endpoint;
    final sortedParams = Map.fromEntries(
      params.entries.toList()..sort((a, b) => a.key.compareTo(b.key)),
    );
    return '$endpoint?${sortedParams.entries.map((e) => '${e.key}=${e.value}').join('&')}';
  }

  // ═══════════════════════════════════════════════════════════════
  // CACHE INVALIDATION
  // ═══════════════════════════════════════════════════════════════

  /// Invalidate cache by prefix
  Future<void> invalidateByPrefix(String prefix) async {
    final keysToDelete = _cacheBox.keys
        .where((key) => key.toString().startsWith(prefix))
        .toList();

    for (final key in keysToDelete) {
      await remove(key.toString());
    }
    debugPrint(
      'Invalidated ${keysToDelete.length} cache entries with prefix: $prefix',
    );
  }

  /// Invalidate product cache
  Future<void> invalidateProductCache() async {
    await invalidateByPrefix('/products');
    await invalidateByPrefix('products_');
  }

  /// Invalidate category cache
  Future<void> invalidateCategoryCache() async {
    await invalidateByPrefix('/categories');
    await invalidateByPrefix('categories_');
  }

  /// Invalidate user cache
  Future<void> invalidateUserCache() async {
    await invalidateByPrefix('/user');
    await invalidateByPrefix('user_');
  }

  /// Clear expired cache entries
  Future<int> clearExpired() async {
    int clearedCount = 0;
    final keys = _cacheBox.keys.toList();

    for (final key in keys) {
      if (_isExpired(key.toString())) {
        await remove(key.toString());
        clearedCount++;
      }
    }

    debugPrint('Cleared $clearedCount expired cache entries');
    return clearedCount;
  }

  // ═══════════════════════════════════════════════════════════════
  // CACHE STATS
  // ═══════════════════════════════════════════════════════════════

  /// Get cache statistics
  CacheStats getStats() {
    return CacheStats(
      entryCount: _cacheBox.length,
      sizeBytes: _estimateCacheSize(),
    );
  }

  int _estimateCacheSize() {
    int totalSize = 0;
    for (final key in _cacheBox.keys) {
      final value = _cacheBox.get(key);
      if (value != null) {
        totalSize += value.length * 2; // Approximate UTF-16 encoding
      }
    }
    return totalSize;
  }
}

// ═══════════════════════════════════════════════════════════════
// DATA CLASSES
// ═══════════════════════════════════════════════════════════════

class CacheStats {
  final int entryCount;
  final int sizeBytes;

  const CacheStats({required this.entryCount, required this.sizeBytes});

  String get sizeText {
    if (sizeBytes < 1024) return '$sizeBytes B';
    if (sizeBytes < 1024 * 1024) {
      return '${(sizeBytes / 1024).toStringAsFixed(1)} KB';
    }
    return '${(sizeBytes / (1024 * 1024)).toStringAsFixed(1)} MB';
  }
}
