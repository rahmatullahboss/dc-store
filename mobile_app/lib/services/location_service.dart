import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:url_launcher/url_launcher.dart';
import '../core/config/white_label_config.dart';

/// LocationService - Handles location and geocoding
/// Uses geolocator, geocoding, and url_launcher packages
class LocationService {
  static LocationService? _instance;
  StreamSubscription<Position>? _positionStreamSubscription;

  LocationService._();

  static LocationService get instance {
    _instance ??= LocationService._();
    return _instance!;
  }

  /// Initialize location service
  Future<void> initialize() async {
    debugPrint('LocationService initialized');
  }

  // ═══════════════════════════════════════════════════════════════
  // PERMISSIONS
  // ═══════════════════════════════════════════════════════════════

  /// Request location permission
  Future<bool> requestPermission() async {
    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        debugPrint('Location permissions are denied');
        return false;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      debugPrint('Location permissions are permanently denied');
      return false;
    }

    return true;
  }

  // ═══════════════════════════════════════════════════════════════
  // CURRENT LOCATION
  // ═══════════════════════════════════════════════════════════════

  /// Check if location services are enabled
  Future<bool> isLocationServiceEnabled() async {
    return await Geolocator.isLocationServiceEnabled();
  }

  /// Get current location
  Future<LocationData?> getCurrentLocation() async {
    try {
      final hasPermission = await requestPermission();
      if (!hasPermission) {
        debugPrint('Location permission not granted');
        return null;
      }

      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          timeLimit: Duration(seconds: 10),
        ),
      );

      return LocationData(
        latitude: position.latitude,
        longitude: position.longitude,
        accuracy: position.accuracy,
        altitude: position.altitude,
        timestamp: position.timestamp,
      );
    } catch (e) {
      debugPrint('Error getting location: $e');
      return null;
    }
  }

  /// Get last known location
  Future<LocationData?> getLastKnownLocation() async {
    try {
      final position = await Geolocator.getLastKnownPosition();
      if (position == null) return null;

      return LocationData(
        latitude: position.latitude,
        longitude: position.longitude,
        accuracy: position.accuracy,
        altitude: position.altitude,
        timestamp: position.timestamp,
      );
    } catch (e) {
      debugPrint('Error getting last known location: $e');
      return null;
    }
  }

  /// Stream location updates
  Stream<LocationData> getLocationStream() {
    return Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 10, // Update every 10 meters
      ),
    ).map(
      (position) => LocationData(
        latitude: position.latitude,
        longitude: position.longitude,
        accuracy: position.accuracy,
        altitude: position.altitude,
        timestamp: position.timestamp,
      ),
    );
  }

  /// Stop listening to location updates
  void stopLocationStream() {
    _positionStreamSubscription?.cancel();
    _positionStreamSubscription = null;
  }

  // ═══════════════════════════════════════════════════════════════
  // GEOCODING
  // ═══════════════════════════════════════════════════════════════

  /// Get address from coordinates (reverse geocoding)
  Future<AddressInfo?> getAddressFromCoordinates(
    double latitude,
    double longitude,
  ) async {
    try {
      final placemarks = await placemarkFromCoordinates(latitude, longitude);
      if (placemarks.isNotEmpty) {
        final place = placemarks.first;
        return AddressInfo(
          street: place.street,
          city: place.locality,
          state: place.administrativeArea,
          country: place.country,
          postalCode: place.postalCode,
          formattedAddress: _formatPlacemark(place),
        );
      }
      return null;
    } catch (e) {
      debugPrint('Error getting address: $e');
      return null;
    }
  }

  String _formatPlacemark(Placemark place) {
    final parts = <String>[];
    if (place.street != null && place.street!.isNotEmpty) {
      parts.add(place.street!);
    }
    if (place.locality != null && place.locality!.isNotEmpty) {
      parts.add(place.locality!);
    }
    if (place.administrativeArea != null &&
        place.administrativeArea!.isNotEmpty) {
      parts.add(place.administrativeArea!);
    }
    if (place.postalCode != null && place.postalCode!.isNotEmpty) {
      parts.add(place.postalCode!);
    }
    return parts.join(', ');
  }

  /// Get coordinates from address (forward geocoding)
  Future<LocationData?> getCoordinatesFromAddress(String address) async {
    try {
      final locations = await locationFromAddress(address);
      if (locations.isNotEmpty) {
        return LocationData(
          latitude: locations.first.latitude,
          longitude: locations.first.longitude,
        );
      }
      return null;
    } catch (e) {
      debugPrint('Error geocoding address: $e');
      return null;
    }
  }

  // ═══════════════════════════════════════════════════════════════
  // DISTANCE CALCULATION
  // ═══════════════════════════════════════════════════════════════

  /// Calculate distance between two points (in km)
  double calculateDistance({
    required double startLat,
    required double startLng,
    required double endLat,
    required double endLng,
  }) {
    const double earthRadius = 6371; // km

    final dLat = _degToRad(endLat - startLat);
    final dLng = _degToRad(endLng - startLng);

    final a =
        math.sin(dLat / 2) * math.sin(dLat / 2) +
        math.cos(_degToRad(startLat)) *
            math.cos(_degToRad(endLat)) *
            math.sin(dLng / 2) *
            math.sin(dLng / 2);

    final c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));

    return earthRadius * c;
  }

  double _degToRad(double deg) => deg * (math.pi / 180);

  /// Calculate distance from current location
  Future<double?> calculateDistanceFromCurrent({
    required double destinationLat,
    required double destinationLng,
  }) async {
    final currentLocation = await getCurrentLocation();
    if (currentLocation == null) return null;

    return calculateDistance(
      startLat: currentLocation.latitude,
      startLng: currentLocation.longitude,
      endLat: destinationLat,
      endLng: destinationLng,
    );
  }

  // ═══════════════════════════════════════════════════════════════
  // STORE LOCATOR
  // ═══════════════════════════════════════════════════════════════

  /// Find nearby stores
  Future<List<StoreLocation>> findNearbyStores({
    double? latitude,
    double? longitude,
    double radiusKm = 10,
  }) async {
    // Get current location if not provided
    if (latitude == null || longitude == null) {
      final current = await getCurrentLocation();
      if (current == null) return [];
      latitude = current.latitude;
      longitude = current.longitude;
    }

    // TODO: Fetch stores from API and filter by distance
    // Mock stores
    return [
      StoreLocation(
        id: 'store_1',
        name: '${WhiteLabelConfig.appName} - Gulshan',
        address: 'Road 11, Gulshan-2, Dhaka',
        latitude: 23.7925,
        longitude: 90.4078,
        distance: calculateDistance(
          startLat: latitude,
          startLng: longitude,
          endLat: 23.7925,
          endLng: 90.4078,
        ),
        phone: '01700000001',
        openingHours: '10:00 AM - 10:00 PM',
      ),
      StoreLocation(
        id: 'store_2',
        name: '${WhiteLabelConfig.appName} - Dhanmondi',
        address: 'Road 27, Dhanmondi, Dhaka',
        latitude: 23.7461,
        longitude: 90.3742,
        distance: calculateDistance(
          startLat: latitude,
          startLng: longitude,
          endLat: 23.7461,
          endLng: 90.3742,
        ),
        phone: '01700000002',
        openingHours: '10:00 AM - 10:00 PM',
      ),
    ]..sort((a, b) => a.distance.compareTo(b.distance));
  }

  /// Open in maps app
  Future<void> openInMaps(double latitude, double longitude) async {
    final url = Uri.parse(
      'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude',
    );

    try {
      if (await canLaunchUrl(url)) {
        await launchUrl(url, mode: LaunchMode.externalApplication);
      } else {
        debugPrint('Could not launch maps');
      }
    } catch (e) {
      debugPrint('Error opening maps: $e');
    }
  }

  /// Get directions
  Future<void> openDirections({
    required double destinationLat,
    required double destinationLng,
    double? originLat,
    double? originLng,
  }) async {
    // Try to get current location for origin if not provided
    String origin = '';
    if (originLat != null && originLng != null) {
      origin = '$originLat,$originLng';
    } else {
      final currentLocation = await getCurrentLocation();
      if (currentLocation != null) {
        origin = '${currentLocation.latitude},${currentLocation.longitude}';
      }
    }

    final baseUrl = 'https://www.google.com/maps/dir/?api=1';
    final destination = 'destination=$destinationLat,$destinationLng';
    final originParam = origin.isNotEmpty ? '&origin=$origin' : '';

    final url = Uri.parse('$baseUrl&$destination$originParam');

    try {
      if (await canLaunchUrl(url)) {
        await launchUrl(url, mode: LaunchMode.externalApplication);
      } else {
        debugPrint('Could not launch maps for directions');
      }
    } catch (e) {
      debugPrint('Error opening directions: $e');
    }
  }
}

// ═══════════════════════════════════════════════════════════════
// DATA CLASSES
// ═══════════════════════════════════════════════════════════════

class LocationData {
  final double latitude;
  final double longitude;
  final double? accuracy;
  final double? altitude;
  final DateTime? timestamp;

  const LocationData({
    required this.latitude,
    required this.longitude,
    this.accuracy,
    this.altitude,
    this.timestamp,
  });
}

class AddressInfo {
  final String? street;
  final String? city;
  final String? state;
  final String? country;
  final String? postalCode;
  final String? formattedAddress;

  const AddressInfo({
    this.street,
    this.city,
    this.state,
    this.country,
    this.postalCode,
    this.formattedAddress,
  });

  String get displayAddress {
    final parts = [
      street,
      city,
      state,
      postalCode,
    ].where((p) => p != null && p.isNotEmpty).toList();
    return parts.join(', ');
  }
}

class StoreLocation {
  final String id;
  final String name;
  final String address;
  final double latitude;
  final double longitude;
  final double distance;
  final String? phone;
  final String? openingHours;
  final bool isOpen;

  const StoreLocation({
    required this.id,
    required this.name,
    required this.address,
    required this.latitude,
    required this.longitude,
    required this.distance,
    this.phone,
    this.openingHours,
    this.isOpen = true,
  });

  String get distanceText {
    if (distance < 1) {
      return '${(distance * 1000).round()} m';
    }
    return '${distance.toStringAsFixed(1)} km';
  }
}
