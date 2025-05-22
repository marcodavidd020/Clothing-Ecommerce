import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart'; // Importar GetIt
import 'modules/repository_module.dart';
import 'modules/bloc_module.dart';
import 'modules/storage_module.dart';
import 'package:flutter_application_ecommerce/features/home/di_container.dart'; // Importar HomeDIContainer
import 'package:flutter_application_ecommerce/features/auth/di_container.dart'; // Importar AuthDIContainer
import 'package:flutter_application_ecommerce/core/network/dio_client.dart';
import 'package:flutter_application_ecommerce/core/storage/auth_storage.dart';

/// Clase para gestionar la inyección de dependencias en la aplicación
class InjectionContainer {
  /// Constructor privado para evitar instanciación
  InjectionContainer._();

  /// Instancia de GetIt
  static final GetIt sl = GetIt.instance;

  /// Indica si la inicialización se ha completado
  static bool _initialized = false;

  /// Inicializa el contenedor de inyección de dependencias
  static Future<Widget> initAsync({required Widget child}) async {
    if (!_initialized) {
      // Registrar servicios de almacenamiento primero
      await StorageModule.register(sl);

      // Registrar dependencias básicas (network, repository, etc.)
      RepositoryModule.register(sl);

      // Registrar todos los módulos de características en GetIt
      await HomeDIContainer.register(sl);
      await AuthDIContainer.register(sl);

      // Configurar el cliente Dio para usar el almacenamiento de autenticación
      if (sl.isRegistered<DioClient>() && sl.isRegistered<AuthStorage>()) {
        final dioClient = sl<DioClient>();
        final authStorage = sl<AuthStorage>();
        dioClient.setAuthStorage(authStorage);
      }

      _initialized = true;
    }

    // Envolver la aplicación con los providers necesarios
    return MultiRepositoryProvider(
      providers: repositoryProviders,
      child: Builder(
        builder: (context) {
          return MultiBlocProvider(
            providers: BlocModule.providers(context, sl),
            child: child,
          );
        },
      ),
    );
  }

  /// Inicialización síncrona (para retrocompatibilidad)
  /// Preferir usar initAsync para inicialización completa
  static Widget init({required Widget child}) {
    if (!_initialized) {
      // Registrar dependencias básicas que no requieren inicialización asíncrona
      RepositoryModule.register(sl);
      HomeDIContainer.register(sl);

      // Advertir que no se está inicializando AuthDIContainer correctamente
      debugPrint(
        'ADVERTENCIA: Se está usando init() en lugar de initAsync(). '
        'Algunas dependencias como AuthDIContainer no se inicializarán correctamente.',
      );
    }

    // Envolver la aplicación con los providers necesarios
    return MultiRepositoryProvider(
      providers: repositoryProviders,
      child: Builder(
        builder: (context) {
          return MultiBlocProvider(
            providers: BlocModule.providers(context, sl),
            child: child,
          );
        },
      ),
    );
  }

  /// Obtiene todos los providers de repositorios para MultiRepositoryProvider
  static List<RepositoryProvider> get repositoryProviders =>
      RepositoryModule.providers;

  // Método para resetear el contenedor (útil para pruebas)
  static Future<void> reset() async {
    await sl.reset();
    _initialized = false;
  }
}
