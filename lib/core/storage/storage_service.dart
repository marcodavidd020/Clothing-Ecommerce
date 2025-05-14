/// Interfaz abstracta para el servicio de almacenamiento local
///
/// Define métodos para guardar y recuperar datos de manera persistente
/// independientemente de la implementación subyacente.
abstract class StorageService {
  /// Inicializa el servicio de almacenamiento
  Future<void> init();

  /// Guarda un valor String con la clave especificada
  Future<bool> setString(String key, String value);

  /// Recupera un valor String con la clave especificada
  /// Si la clave no existe, devuelve null o el valor por defecto proporcionado
  Future<String?> getString(String key, {String? defaultValue});

  /// Guarda un valor bool con la clave especificada
  Future<bool> setBool(String key, bool value);

  /// Recupera un valor bool con la clave especificada
  /// Si la clave no existe, devuelve false o el valor por defecto proporcionado
  Future<bool> getBool(String key, {bool defaultValue = false});

  /// Guarda un valor int con la clave especificada
  Future<bool> setInt(String key, int value);

  /// Recupera un valor int con la clave especificada
  /// Si la clave no existe, devuelve 0 o el valor por defecto proporcionado
  Future<int> getInt(String key, {int defaultValue = 0});

  /// Guarda un valor double con la clave especificada
  Future<bool> setDouble(String key, double value);

  /// Recupera un valor double con la clave especificada
  /// Si la clave no existe, devuelve 0.0 o el valor por defecto proporcionado
  Future<double> getDouble(String key, {double defaultValue = 0.0});

  /// Guarda una lista de strings con la clave especificada
  Future<bool> setStringList(String key, List<String> value);

  /// Recupera una lista de strings con la clave especificada
  /// Si la clave no existe, devuelve una lista vacía o el valor por defecto proporcionado
  Future<List<String>> getStringList(String key, {List<String> defaultValue = const []});

  /// Comprueba si una clave existe en el almacenamiento
  Future<bool> containsKey(String key);

  /// Elimina un valor del almacenamiento
  Future<bool> remove(String key);

  /// Elimina todos los valores del almacenamiento
  Future<bool> clear();
} 