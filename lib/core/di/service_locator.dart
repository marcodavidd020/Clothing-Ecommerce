import 'package:get_it/get_it.dart';
import 'package:flutter_application_ecommerce/core/di/modules/repository_module.dart';
import 'package:flutter_application_ecommerce/core/di/modules/storage_module.dart';
import 'package:flutter_application_ecommerce/core/storage/auth_storage.dart';
import 'package:flutter_application_ecommerce/core/network/dio_client.dart';
import 'package:flutter_application_ecommerce/features/auth/di_container.dart';
import 'package:flutter_application_ecommerce/features/home/di_container.dart';

/// Servicio localizador para gestionar dependencias
class ServiceLocator {
  static final GetIt sl = GetIt.instance;

  /// Inicializa todas las dependencias necesarias
  static Future<void> init({bool initializeStorage = false}) async {
    // Inicializar módulo de almacenamiento si se requiere
    if (initializeStorage) {
      await StorageModule.register(sl);
    }

    // Inicializar el resto de módulos sin await ya que son síncronos
    RepositoryModule.register(sl);
    AuthDIContainer.register(sl);
    HomeDIContainer.register(sl);

    // Configurar el cliente Dio para usar el almacenamiento de autenticación
    if (sl.isRegistered<DioClient>() && sl.isRegistered<AuthStorage>()) {
      final dioClient = sl<DioClient>();
      final authStorage = sl<AuthStorage>();
      dioClient.setAuthStorage(authStorage);
    }
  }
}
