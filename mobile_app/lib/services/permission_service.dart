import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:permission_handler/permission_handler.dart';

/// PermissionService - Handles all app permissions
class PermissionService {
  static PermissionService? _instance;

  PermissionService._();

  static PermissionService get instance {
    _instance ??= PermissionService._();
    return _instance!;
  }

  // ═══════════════════════════════════════════════════════════════
  // CAMERA PERMISSION
  // ═══════════════════════════════════════════════════════════════

  /// Request camera permission
  Future<bool> requestCamera() async {
    return await _requestPermission(
      Permission.camera,
      'Camera access is needed to take product photos and scan QR codes.',
    );
  }

  /// Check camera permission
  Future<bool> hasCamera() async {
    return await Permission.camera.isGranted;
  }

  // ═══════════════════════════════════════════════════════════════
  // STORAGE PERMISSION
  // ═══════════════════════════════════════════════════════════════

  /// Request storage permission (for saving images)
  Future<bool> requestStorage() async {
    if (Platform.isAndroid) {
      // Android 13+ doesn't need storage permission for media
      final sdkVersion = await _getAndroidSdkVersion();
      if (sdkVersion >= 33) {
        return await _requestPermission(
          Permission.photos,
          'Photo access is needed to select images.',
        );
      }
      return await _requestPermission(
        Permission.storage,
        'Storage access is needed to save and select files.',
      );
    } else if (Platform.isIOS) {
      return await _requestPermission(
        Permission.photos,
        'Photo access is needed to select images.',
      );
    }
    return true;
  }

  /// Check storage permission
  Future<bool> hasStorage() async {
    if (Platform.isAndroid) {
      final sdkVersion = await _getAndroidSdkVersion();
      if (sdkVersion >= 33) {
        return await Permission.photos.isGranted;
      }
      return await Permission.storage.isGranted;
    }
    return await Permission.photos.isGranted;
  }

  // ═══════════════════════════════════════════════════════════════
  // LOCATION PERMISSION
  // ═══════════════════════════════════════════════════════════════

  /// Request location permission
  Future<bool> requestLocation() async {
    return await _requestPermission(
      Permission.location,
      'Location access is needed to show nearby stores and calculate delivery estimates.',
    );
  }

  /// Request precise location (for better accuracy)
  Future<bool> requestPreciseLocation() async {
    final hasBasic = await requestLocation();
    if (!hasBasic) return false;

    return await _requestPermission(
      Permission.locationWhenInUse,
      'Precise location is needed for accurate store finder and delivery estimates.',
    );
  }

  /// Check location permission
  Future<bool> hasLocation() async {
    return await Permission.location.isGranted;
  }

  /// Check if location services are enabled
  Future<bool> isLocationServiceEnabled() async {
    return await Permission.location.serviceStatus.isEnabled;
  }

  // ═══════════════════════════════════════════════════════════════
  // NOTIFICATION PERMISSION
  // ═══════════════════════════════════════════════════════════════

  /// Request notification permission
  Future<bool> requestNotification() async {
    if (Platform.isAndroid) {
      // Android 13+ requires explicit notification permission
      final sdkVersion = await _getAndroidSdkVersion();
      if (sdkVersion >= 33) {
        return await _requestPermission(
          Permission.notification,
          'Notifications help you stay updated on orders and promotions.',
        );
      }
      return true; // Pre-Android 13 doesn't need explicit permission
    } else if (Platform.isIOS) {
      return await _requestPermission(
        Permission.notification,
        'Notifications help you stay updated on orders and promotions.',
      );
    }
    return true;
  }

  /// Check notification permission
  Future<bool> hasNotification() async {
    if (Platform.isAndroid) {
      final sdkVersion = await _getAndroidSdkVersion();
      if (sdkVersion >= 33) {
        return await Permission.notification.isGranted;
      }
      return true;
    }
    return await Permission.notification.isGranted;
  }

  // ═══════════════════════════════════════════════════════════════
  // CONTACTS PERMISSION
  // ═══════════════════════════════════════════════════════════════

  /// Request contacts permission
  Future<bool> requestContacts() async {
    return await _requestPermission(
      Permission.contacts,
      'Contact access is needed to quickly fill delivery addresses.',
    );
  }

  /// Check contacts permission
  Future<bool> hasContacts() async {
    return await Permission.contacts.isGranted;
  }

  // ═══════════════════════════════════════════════════════════════
  // PHONE PERMISSION
  // ═══════════════════════════════════════════════════════════════

  /// Request phone permission (for calling support)
  Future<bool> requestPhone() async {
    return await _requestPermission(
      Permission.phone,
      'Phone access is needed to directly call customer support.',
    );
  }

  /// Check phone permission
  Future<bool> hasPhone() async {
    return await Permission.phone.isGranted;
  }

  // ═══════════════════════════════════════════════════════════════
  // HELPERS
  // ═══════════════════════════════════════════════════════════════

  Future<bool> _requestPermission(
    Permission permission,
    String rationale,
  ) async {
    final status = await permission.status;

    if (status.isGranted) {
      return true;
    }

    if (status.isDenied) {
      debugPrint('Permission rationale: $rationale');
      final result = await permission.request();
      return result.isGranted;
    }

    if (status.isPermanentlyDenied) {
      // Open app settings
      debugPrint('Permission permanently denied. Opening settings...');
      await openAppSettings();
      return false;
    }

    return false;
  }

  Future<int> _getAndroidSdkVersion() async {
    if (!Platform.isAndroid) return 0;
    // Would need device_info_plus package for accurate version
    // For now, assume modern Android
    return 33;
  }

  /// Check all essential permissions
  Future<PermissionStatus> checkEssentialPermissions() async {
    final hasNotif = await hasNotification();
    final hasLoc = await hasLocation();

    if (hasNotif && hasLoc) {
      return PermissionStatus.allGranted;
    } else if (hasNotif || hasLoc) {
      return PermissionStatus.partial;
    }
    return PermissionStatus.denied;
  }

  /// Request all essential permissions
  Future<void> requestEssentialPermissions() async {
    await requestNotification();
    await requestLocation();
  }

  /// Open app settings
  Future<bool> openSettings() async {
    return await openAppSettings();
  }
}

// ═══════════════════════════════════════════════════════════════
// ENUMS
// ═══════════════════════════════════════════════════════════════

enum PermissionStatus {
  allGranted,
  partial,
  denied;

  bool get isAllGranted => this == PermissionStatus.allGranted;
}
