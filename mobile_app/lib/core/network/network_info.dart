import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Network Information Service
/// Provides connectivity checking and network type detection
class NetworkInfo {
  final Connectivity _connectivity;

  NetworkInfo({Connectivity? connectivity})
    : _connectivity = connectivity ?? Connectivity();

  /// Check if device has internet connection
  Future<bool> get isConnected async {
    final result = await _connectivity.checkConnectivity();
    return !result.contains(ConnectivityResult.none);
  }

  /// Get current connectivity type
  Future<NetworkType> get networkType async {
    final result = await _connectivity.checkConnectivity();

    if (result.contains(ConnectivityResult.wifi)) {
      return NetworkType.wifi;
    } else if (result.contains(ConnectivityResult.mobile)) {
      return NetworkType.mobile;
    } else if (result.contains(ConnectivityResult.ethernet)) {
      return NetworkType.ethernet;
    } else if (result.contains(ConnectivityResult.vpn)) {
      return NetworkType.vpn;
    } else {
      return NetworkType.none;
    }
  }

  /// Stream of connectivity changes
  Stream<bool> get onConnectivityChanged {
    return _connectivity.onConnectivityChanged.map((result) {
      return !result.contains(ConnectivityResult.none);
    });
  }

  /// Stream of network type changes
  Stream<NetworkType> get onNetworkTypeChanged {
    return _connectivity.onConnectivityChanged.map((result) {
      if (result.contains(ConnectivityResult.wifi)) {
        return NetworkType.wifi;
      } else if (result.contains(ConnectivityResult.mobile)) {
        return NetworkType.mobile;
      } else if (result.contains(ConnectivityResult.ethernet)) {
        return NetworkType.ethernet;
      } else if (result.contains(ConnectivityResult.vpn)) {
        return NetworkType.vpn;
      } else {
        return NetworkType.none;
      }
    });
  }
}

/// Network type enumeration
enum NetworkType {
  wifi,
  mobile,
  ethernet,
  vpn,
  none;

  bool get isConnected => this != NetworkType.none;

  String get displayName {
    switch (this) {
      case NetworkType.wifi:
        return 'WiFi';
      case NetworkType.mobile:
        return 'Mobile Data';
      case NetworkType.ethernet:
        return 'Ethernet';
      case NetworkType.vpn:
        return 'VPN';
      case NetworkType.none:
        return 'No Connection';
    }
  }
}

// ═══════════════════════════════════════════════════════════════
// PROVIDERS
// ═══════════════════════════════════════════════════════════════

final networkInfoProvider = Provider<NetworkInfo>((ref) {
  return NetworkInfo();
});

final isConnectedProvider = FutureProvider<bool>((ref) async {
  final networkInfo = ref.watch(networkInfoProvider);
  return networkInfo.isConnected;
});

final connectivityStreamProvider = StreamProvider<bool>((ref) {
  final networkInfo = ref.watch(networkInfoProvider);
  return networkInfo.onConnectivityChanged;
});

final networkTypeProvider = FutureProvider<NetworkType>((ref) async {
  final networkInfo = ref.watch(networkInfoProvider);
  return networkInfo.networkType;
});
