import 'package:get_it/get_it.dart';

/// Clase base abstracta para todos los contenedores de inyección de dependencias
/// Esta clase define la estructura común que deben seguir todos los contenedores DI
abstract class BaseDIContainer {
  /// Registra todas las dependencias del módulo
  static Future<void> register(GetIt sl) async {
    throw UnimplementedError('Cada contenedor DI debe implementar register()');
  }

  /// Registra las dependencias core necesarias para el módulo
  static Future<void> registerCoreDependencies(GetIt sl) async {
    throw UnimplementedError(
      'Cada contenedor DI debe implementar registerCoreDependencies()',
    );
  }

  /// Registra las fuentes de datos del módulo
  static void registerDataSources(GetIt sl) {
    throw UnimplementedError(
      'Cada contenedor DI debe implementar registerDataSources()',
    );
  }

  /// Registra los repositorios del módulo
  static void registerRepositories(GetIt sl) {
    throw UnimplementedError(
      'Cada contenedor DI debe implementar registerRepositories()',
    );
  }

  /// Registra los casos de uso del módulo
  static void registerUseCases(GetIt sl) {
    throw UnimplementedError(
      'Cada contenedor DI debe implementar registerUseCases()',
    );
  }

  /// Registra los BLoCs del módulo
  static void registerBlocs(GetIt sl) {
    throw UnimplementedError(
      'Cada contenedor DI debe implementar registerBlocs()',
    );
  }

  /// Verifica que todas las dependencias requeridas estén registradas
  /// @param sl Localizador de servicios GetIt
  /// @param dependencies Lista de verificaciones de registro usando funciones
  /// @param message Mensaje de error personalizado
  static void checkDependencies(
    GetIt sl,
    List<bool> dependencies,
    String message,
  ) {
    if (dependencies.any((registered) => !registered)) {
      throw StateError(message);
    }
  }

  /// Método de utilidad para verificar si un tipo está registrado
  /// @param sl Localizador de servicios GetIt
  /// @return true si el tipo está registrado, false en caso contrario
  static bool isRegistered<T extends Object>(GetIt sl) {
    return sl.isRegistered<T>();
  }
}
