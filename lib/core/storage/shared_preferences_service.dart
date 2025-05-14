import 'package:shared_preferences/shared_preferences.dart';
import 'storage_service.dart';

/// Implementación de [StorageService] utilizando SharedPreferences
class SharedPreferencesService implements StorageService {
  /// Instancia de SharedPreferences
  SharedPreferences? _preferences;

  /// Indica si el servicio está inicializado
  bool get isInitialized => _preferences != null;

  @override
  Future<void> init() async {
    _preferences = await SharedPreferences.getInstance();
  }

  void _checkInitialized() {
    if (!isInitialized) {
      throw StateError(
        'SharedPreferencesService no inicializado. Llame a init() primero.',
      );
    }
  }

  @override
  Future<bool> setString(String key, String value) async {
    _checkInitialized();
    return await _preferences!.setString(key, value);
  }

  @override
  Future<String?> getString(String key, {String? defaultValue}) async {
    _checkInitialized();
    return _preferences!.getString(key) ?? defaultValue;
  }

  @override
  Future<bool> setBool(String key, bool value) async {
    _checkInitialized();
    return await _preferences!.setBool(key, value);
  }

  @override
  Future<bool> getBool(String key, {bool defaultValue = false}) async {
    _checkInitialized();
    return _preferences!.getBool(key) ?? defaultValue;
  }

  @override
  Future<bool> setInt(String key, int value) async {
    _checkInitialized();
    return await _preferences!.setInt(key, value);
  }

  @override
  Future<int> getInt(String key, {int defaultValue = 0}) async {
    _checkInitialized();
    return _preferences!.getInt(key) ?? defaultValue;
  }

  @override
  Future<bool> setDouble(String key, double value) async {
    _checkInitialized();
    return await _preferences!.setDouble(key, value);
  }

  @override
  Future<double> getDouble(String key, {double defaultValue = 0.0}) async {
    _checkInitialized();
    return _preferences!.getDouble(key) ?? defaultValue;
  }

  @override
  Future<bool> setStringList(String key, List<String> value) async {
    _checkInitialized();
    return await _preferences!.setStringList(key, value);
  }

  @override
  Future<List<String>> getStringList(
    String key, {
    List<String> defaultValue = const [],
  }) async {
    _checkInitialized();
    return _preferences!.getStringList(key) ?? defaultValue;
  }

  @override
  Future<bool> containsKey(String key) async {
    _checkInitialized();
    return _preferences!.containsKey(key);
  }

  @override
  Future<bool> remove(String key) async {
    _checkInitialized();
    return await _preferences!.remove(key);
  }

  @override
  Future<bool> clear() async {
    _checkInitialized();
    return await _preferences!.clear();
  }
} 