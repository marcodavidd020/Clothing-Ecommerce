import 'package:get_it/get_it.dart';
import 'package:flutter_application_ecommerce/features/home/di_container.dart';
import 'package:flutter_application_ecommerce/features/auth/di_container.dart';
import 'package:flutter_application_ecommerce/core/constants/api_constants.dart';
import 'package:flutter_application_ecommerce/core/di/modules/repository_module.dart';
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

    // Mostrar URLs de API para diagnóstico
    ApiConstants.logEndpoints();

    // 1. PRIMERO inicializar el módulo de almacenamiento
    await StorageModule.register(sl);

    // 2. Cargar el módulo de repositorio base que incluye DioClient
    RepositoryModule.register(sl);

    // 3. Configurar DioClient con AuthStorage
    if (sl.isRegistered<DioClient>() && sl.isRegistered<AuthStorage>()) {
      final dioClient = sl<DioClient>();
      final authStorage = sl<AuthStorage>();
      dioClient.setAuthStorage(authStorage);
    }

    // 4. DESPUÉS registrar módulos de funcionalidades
    await HomeDIContainer.register(sl);
    await AuthDIContainer.register(sl);
  }
}
