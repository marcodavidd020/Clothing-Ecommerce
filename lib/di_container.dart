import 'package:get_it/get_it.dart';
import 'package:flutter_application_ecommerce/features/home/di_container.dart';

/// Contenedor principal de inyección de dependencias
class DIContainer {
  /// Constructor privado para evitar instanciación
  DIContainer._();

  /// GetIt instance
  static final GetIt sl = GetIt.instance;

  /// Initialize all dependencies
  static Future<void> init() async {
    // Registrar módulos
    HomeDIContainer.register(sl);
    
    // Aquí se registrarán otros módulos en el futuro
    // AuthDIContainer.register(sl);
    // CartDIContainer.register(sl);
    // etc.
  }
} 