import 'package:shared_preferences/shared_preferences.dart';

/// Local storage service for persisting data
class StorageService {
  static StorageService? _instance;
  static SharedPreferences? _prefs;

  StorageService._();

  static Future<StorageService> getInstance() async {
    _instance ??= StorageService._();
    _prefs ??= await SharedPreferences.getInstance();
    return _instance!;
  }

  // String operations
  Future<bool> setString(String key, String value) async {
    return await _prefs!.setString(key, value);
  }

  String? getString(String key) {
    return _prefs!.getString(key);
  }

  // Bool operations
  Future<bool> setBool(String key, bool value) async {
    return await _prefs!.setBool(key, value);
  }

  bool? getBool(String key) {
    return _prefs!.getBool(key);
  }

  // Int operations
  Future<bool> setInt(String key, int value) async {
    return await _prefs!.setInt(key, value);
  }

  int? getInt(String key) {
    return _prefs!.getInt(key);
  }

  // Double operations
  Future<bool> setDouble(String key, double value) async {
    return await _prefs!.setDouble(key, value);
  }

  double? getDouble(String key) {
    return _prefs!.getDouble(key);
  }

  // List operations
  Future<bool> setStringList(String key, List<String> value) async {
    return await _prefs!.setStringList(key, value);
  }

  List<String>? getStringList(String key) {
    return _prefs!.getStringList(key);
  }

  // Remove and clear
  Future<bool> remove(String key) async {
    return await _prefs!.remove(key);
  }

  Future<bool> clear() async {
    return await _prefs!.clear();
  }

  bool containsKey(String key) {
    return _prefs!.containsKey(key);
  }
}
