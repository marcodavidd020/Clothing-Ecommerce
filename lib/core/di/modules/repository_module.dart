import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:flutter_application_ecommerce/core/network/dio_client.dart';
import 'package:flutter_application_ecommerce/core/network/network_info.dart';
import 'package:flutter_application_ecommerce/features/home/data/datasources/product_datasource.dart';
import 'package:flutter_application_ecommerce/features/home/domain/repositories/home_repository.dart';
import 'package:get_it/get_it.dart';

/// Módulo para la inyección de repositorios
class RepositoryModule {
  /// Registra los repositorios en GetIt
  static void register(GetIt sl) {
    // Registrar servicios externos
    _registerExternalServices(sl);
    
    // Registrar servicios core
    _registerCoreServices(sl);
    
    // Registrar datasources
    _registerDataSources(sl);
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
        () => NetworkInfoImpl(sl<InternetConnectionChecker>()),
      );
    }
    
    if (!sl.isRegistered<DioClient>()) {
      sl.registerLazySingleton<DioClient>(
        () => DioClient(dio: sl<Dio>(), networkInfo: sl<NetworkInfo>()),
      );
    }
  }
  
  /// Registra datasources
  static void _registerDataSources(GetIt sl) {
    if (!sl.isRegistered<ProductLocalDataSource>()) {
      sl.registerLazySingleton<ProductLocalDataSource>(
        () => ProductLocalDataSource(),
      );
    }
  }

  /// Proporciona todos los providers de Repository para MultiRepositoryProvider
  static List<RepositoryProvider> get providers => [
    RepositoryProvider<HomeRepository>(
      create: (context) => GetIt.instance<HomeRepository>(),
    ),
    // Aquí se pueden agregar más repositorios a medida que la aplicación crezca
  ];
}
