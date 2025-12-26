/// Sync Queue Service
/// Handles offline operations by queuing them and syncing when back online.

import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/network/network_info.dart';
import '../../core/cache/cache_service.dart';

/// Types of syncable operations
enum SyncOperationType {
  addToCart,
  removeFromCart,
  updateCartQuantity,
  addToWishlist,
  removeFromWishlist,
  updateProfile,
}

/// A queued operation waiting to be synced
class SyncOperation {
  final String id;
  final SyncOperationType type;
  final Map<String, dynamic> payload;
  final DateTime createdAt;
  final int retryCount;

  const SyncOperation({
    required this.id,
    required this.type,
    required this.payload,
    required this.createdAt,
    this.retryCount = 0,
  });

  SyncOperation copyWith({
    String? id,
    SyncOperationType? type,
    Map<String, dynamic>? payload,
    DateTime? createdAt,
    int? retryCount,
  }) {
    return SyncOperation(
      id: id ?? this.id,
      type: type ?? this.type,
      payload: payload ?? this.payload,
      createdAt: createdAt ?? this.createdAt,
      retryCount: retryCount ?? this.retryCount,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'type': type.name,
    'payload': payload,
    'createdAt': createdAt.toIso8601String(),
    'retryCount': retryCount,
  };

  factory SyncOperation.fromJson(Map<String, dynamic> json) {
    return SyncOperation(
      id: json['id'] as String,
      type: SyncOperationType.values.byName(json['type'] as String),
      payload: json['payload'] as Map<String, dynamic>,
      createdAt: DateTime.parse(json['createdAt'] as String),
      retryCount: json['retryCount'] as int? ?? 0,
    );
  }
}

/// Callback for executing sync operations
typedef SyncExecutor = Future<bool> Function(SyncOperation operation);

/// Sync Queue Service - manages offline operations
class SyncQueueService {
  final CacheService _cacheService;
  final NetworkInfo _networkInfo;

  static const _queueKey = 'sync_queue';
  static const _boxName = 'sync';
  static const _maxRetries = 3;

  StreamSubscription? _connectivitySubscription;
  final Map<SyncOperationType, SyncExecutor> _executors = {};

  SyncQueueService({
    required CacheService cacheService,
    required NetworkInfo networkInfo,
  }) : _cacheService = cacheService,
       _networkInfo = networkInfo;

  /// Register an executor for a specific operation type
  void registerExecutor(SyncOperationType type, SyncExecutor executor) {
    _executors[type] = executor;
  }

  /// Start listening for connectivity changes
  void startListening() {
    _connectivitySubscription?.cancel();
    _connectivitySubscription = _networkInfo.onConnectivityChanged.listen((
      isConnected,
    ) {
      if (isConnected) {
        syncAll();
      }
    });
  }

  /// Stop listening for connectivity changes
  void stopListening() {
    _connectivitySubscription?.cancel();
    _connectivitySubscription = null;
  }

  /// Add an operation to the queue
  Future<void> enqueue(SyncOperation operation) async {
    final queue = await _getQueue();
    queue.add(operation);
    await _saveQueue(queue);

    // Try to sync immediately if online
    if (await _networkInfo.isConnected) {
      await syncAll();
    }
  }

  /// Add a cart operation
  Future<void> enqueueCartOperation({
    required SyncOperationType type,
    required String productId,
    int? quantity,
    String? variantId,
  }) async {
    await enqueue(
      SyncOperation(
        id: _generateId(),
        type: type,
        payload: {
          'productId': productId,
          if (quantity != null) 'quantity': quantity,
          if (variantId != null) 'variantId': variantId,
        },
        createdAt: DateTime.now(),
      ),
    );
  }

  /// Add a wishlist operation
  Future<void> enqueueWishlistOperation({
    required SyncOperationType type,
    required String productId,
  }) async {
    await enqueue(
      SyncOperation(
        id: _generateId(),
        type: type,
        payload: {'productId': productId},
        createdAt: DateTime.now(),
      ),
    );
  }

  /// Sync all queued operations
  Future<SyncResult> syncAll() async {
    if (!await _networkInfo.isConnected) {
      return SyncResult(total: 0, synced: 0, failed: 0, pending: 0);
    }

    final queue = await _getQueue();
    if (queue.isEmpty) {
      return SyncResult(total: 0, synced: 0, failed: 0, pending: 0);
    }

    int synced = 0;
    int failed = 0;
    final pending = <SyncOperation>[];

    for (final operation in queue) {
      final executor = _executors[operation.type];
      if (executor == null) {
        // No executor registered, keep in queue
        pending.add(operation);
        continue;
      }

      try {
        final success = await executor(operation);
        if (success) {
          synced++;
        } else if (operation.retryCount < _maxRetries) {
          pending.add(operation.copyWith(retryCount: operation.retryCount + 1));
        } else {
          failed++;
        }
      } catch (e) {
        if (operation.retryCount < _maxRetries) {
          pending.add(operation.copyWith(retryCount: operation.retryCount + 1));
        } else {
          failed++;
        }
      }
    }

    await _saveQueue(pending);

    return SyncResult(
      total: queue.length,
      synced: synced,
      failed: failed,
      pending: pending.length,
    );
  }

  /// Get pending operations count
  Future<int> getPendingCount() async {
    final queue = await _getQueue();
    return queue.length;
  }

  /// Clear all pending operations
  Future<void> clearQueue() async {
    await _saveQueue([]);
  }

  /// Get the current queue
  Future<List<SyncOperation>> _getQueue() async {
    try {
      final rawList = await _cacheService.get<List<dynamic>>(
        key: _queueKey,
        boxName: _boxName,
        fromJson: (json) => json as List<dynamic>,
      );

      if (rawList == null) return [];

      return rawList
          .map((item) => SyncOperation.fromJson(item as Map<String, dynamic>))
          .toList();
    } catch (e) {
      return [];
    }
  }

  /// Save the queue
  Future<void> _saveQueue(List<SyncOperation> queue) async {
    final jsonList = queue.map((op) => op.toJson()).toList();
    await _cacheService.set<List<dynamic>>(
      key: _queueKey,
      boxName: _boxName,
      data: jsonList,
      toJson: (data) => {'items': data},
    );
  }

  String _generateId() {
    return '${DateTime.now().millisecondsSinceEpoch}_${_queueKey.hashCode}';
  }
}

/// Result of a sync operation
class SyncResult {
  final int total;
  final int synced;
  final int failed;
  final int pending;

  const SyncResult({
    required this.total,
    required this.synced,
    required this.failed,
    required this.pending,
  });

  bool get isComplete => pending == 0 && failed == 0;
  bool get hasFailures => failed > 0;
}

/// Provider for SyncQueueService
final syncQueueServiceProvider = Provider<SyncQueueService>((ref) {
  final cacheService = ref.watch(cacheServiceProvider);
  final networkInfo = ref.watch(networkInfoProvider);

  final service = SyncQueueService(
    cacheService: cacheService,
    networkInfo: networkInfo,
  );

  service.startListening();

  ref.onDispose(() {
    service.stopListening();
  });

  return service;
});
