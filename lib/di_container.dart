import 'package:get_it/get_it.dart';
import 'package:flutter_application_ecommerce/features/home/di_container.dart';
import 'package:flutter_application_ecommerce/features/auth/di_container.dart';
import 'package:flutter_application_ecommerce/features/cart/di_container.dart';
import 'package:flutter_application_ecommerce/core/constants/api_constants.dart';
import 'package:flutter_application_ecommerce/core/di/modules/infrastructure_module.dart';
import 'package:flutter_application_ecommerce/core/di/modules/storage_module.dart';
import 'package:flutter_application_ecommerce/core/storage/auth_storage.dart';
import 'package:flutter_application_ecommerce/core/network/dio_client.dart';

/// Contenedor principal de inyección de dependencias
class DIContainer {
  /// Constructor privado para evitar instanciación
  DIContainer._();

  /// GetIt instance
  static final GetIt sl = GetIt.instance;

  /// Initialize all dependencies
  static Future<void> init() async {

    // 0. Mostrar URLs de API para diagnóstico
    ApiConstants.logEndpoints();

    // 1. Inicializar el módulo de almacenamiento (dependencia base)
    await StorageModule.register(sl);

    // 2. Cargar el módulo de infraestructura que proporciona servicios básicos
    //    (Dio, NetworkInfo, DioClient, InternetConnectionChecker, etc.)
    InfrastructureModule.register(sl);

    // 3. Configurar DioClient con AuthStorage
    if (sl.isRegistered<DioClient>() && sl.isRegistered<AuthStorage>()) {
      final dioClient = sl<DioClient>();
      final authStorage = sl<AuthStorage>();
      dioClient.setAuthStorage(authStorage);
    }

    // 4. Registrar módulos de características (con sus propios repositorios, casos de uso, etc.)
    //    Las dependencias básicas ya están disponibles gracias a los pasos anteriores
    await HomeDIContainer.register(sl);
    await AuthDIContainer.register(sl);
    await CartDIContainer.register(sl);
  }
}
