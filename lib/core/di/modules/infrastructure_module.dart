import 'package:dio/dio.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:flutter_application_ecommerce/core/network/dio_client.dart';
import 'package:flutter_application_ecommerce/core/network/network_info.dart';
import 'package:get_it/get_it.dart';

/// Módulo para la inyección de servicios de infraestructura y core
class InfrastructureModule {
  /// Registra los repositorios en GetIt
  static void register(GetIt sl) {
    // Registrar servicios externos
    _registerExternalServices(sl);

    // Registrar servicios core
    _registerCoreServices(sl);
  }

  /// Registra servicios externos como Dio, Connectivity, etc.
  static void _registerExternalServices(GetIt sl) {
    if (!sl.isRegistered<Dio>()) {
      sl.registerLazySingleton<Dio>(() => Dio());
    }

    if (!sl.isRegistered<Connectivity>()) {
      sl.registerLazySingleton<Connectivity>(() => Connectivity());
    }

    if (!sl.isRegistered<InternetConnectionChecker>()) {
      sl.registerLazySingleton<InternetConnectionChecker>(
        () => InternetConnectionChecker.createInstance(),
      );
    }
  }

  /// Registra servicios core como NetworkInfo, DioClient, etc.
  static void _registerCoreServices(GetIt sl) {
    if (!sl.isRegistered<NetworkInfo>()) {
      sl.registerLazySingleton<NetworkInfo>(
        () => NetworkInfoImpl(sl<InternetConnectionChecker>(), sl<Dio>()),
      );
    }

    if (!sl.isRegistered<DioClient>()) {
      sl.registerLazySingleton<DioClient>(
        () => DioClient(dio: sl<Dio>(), networkInfo: sl<NetworkInfo>()),
      );
    }
  }
}
