import 'package:get_it/get_it.dart';
import 'package:flutter_application_ecommerce/features/home/di_container.dart';
import 'package:flutter_application_ecommerce/features/auth/di_container.dart';

/// Contenedor principal de inyección de dependencias
class DIContainer {
  /// Constructor privado para evitar instanciación
  DIContainer._();

  /// GetIt instance
  static final GetIt sl = GetIt.instance;

  /// Initialize all dependencies
  static Future<void> init() async {
    // Registrar módulos
    // Nota: El orden es importante para respetar dependencias entre módulos
    await HomeDIContainer.register(sl);
    await AuthDIContainer.register(sl);
  }
}
