import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:flutter_application_ecommerce/core/network/dio_client.dart';
import 'package:flutter_application_ecommerce/core/network/network_info.dart';
import 'package:flutter_application_ecommerce/features/home/data/datasources/category_datasource.dart';
import 'package:flutter_application_ecommerce/features/home/data/datasources/product_datasource.dart';
import 'package:flutter_application_ecommerce/features/home/data/repositories/home_repository_impl.dart';
import 'package:flutter_application_ecommerce/features/home/domain/repositories/home_repository.dart';
import 'package:get_it/get_it.dart';

/// Módulo para la inyección de repositorios
class RepositoryModule {
  /// Registra los repositorios en GetIt
  static void register(GetIt sl) {
    // Registrar servicios externos
    if (!sl.isRegistered<Dio>()) { // Verificar antes de registrar
      sl.registerLazySingleton<Dio>(() => Dio());
    }
    if (!sl.isRegistered<Connectivity>()) { // Verificar antes de registrar
      sl.registerLazySingleton<Connectivity>(() => Connectivity());
    }
    if (!sl.isRegistered<InternetConnectionChecker>()) { // Verificar antes de registrar
      sl.registerLazySingleton<InternetConnectionChecker>(
        () => InternetConnectionChecker.createInstance(),
      );
    }

    // Registrar servicios core
    if (!sl.isRegistered<NetworkInfo>()) { // Verificar antes de registrar
      sl.registerLazySingleton<NetworkInfo>(
        () => NetworkInfoImpl(sl<InternetConnectionChecker>()),
      );
    }
    if (!sl.isRegistered<DioClient>()) { // Verificar antes de registrar
      sl.registerLazySingleton<DioClient>(
        () => DioClient(dio: sl<Dio>(), networkInfo: sl<NetworkInfo>()),
      );
    }

    // Registrar fuentes de datos
    if (!sl.isRegistered<CategoryLocalDataSource>()) { // Verificar antes de registrar
      sl.registerLazySingleton<CategoryLocalDataSource>(
        () => CategoryLocalDataSource(),
      );
    }
    if (!sl.isRegistered<ProductLocalDataSource>()) { // Verificar antes de registrar
      sl.registerLazySingleton<ProductLocalDataSource>(
        () => ProductLocalDataSource(),
      );
    }

    // Registrar repositorios
    if (!sl.isRegistered<HomeRepository>()) { // Verificar antes de registrar
      sl.registerLazySingleton<HomeRepository>(
        () => HomeRepositoryImpl(
          categoryDataSource: sl<CategoryLocalDataSource>(),
          productDataSource: sl<ProductLocalDataSource>(),
        ),
      );
    }
  }

  /// Proporciona todos los providers de Repository para MultiRepositoryProvider
  static List<RepositoryProvider> providers = [
    RepositoryProvider<HomeRepository>(
      create: (context) => GetIt.instance<HomeRepository>(), // Obtener de GetIt
    ),
    // Aquí se pueden agregar más repositorios a medida que la aplicación crezca
  ];
}
