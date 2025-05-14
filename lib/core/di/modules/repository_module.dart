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
    sl.registerLazySingleton<Dio>(() => Dio());
    sl.registerLazySingleton<Connectivity>(() => Connectivity());
    sl.registerLazySingleton<InternetConnectionChecker>(
      () => InternetConnectionChecker.createInstance(),
    );

    // Registrar servicios core
    sl.registerLazySingleton<NetworkInfo>(
      () => NetworkInfoImpl(sl<InternetConnectionChecker>()),
    );

    sl.registerLazySingleton<DioClient>(
      () => DioClient(dio: sl<Dio>(), networkInfo: sl<NetworkInfo>()),
    );

    // Registrar fuentes de datos
    sl.registerLazySingleton<CategoryLocalDataSource>(
      () => CategoryLocalDataSource(),
    );

    sl.registerLazySingleton<ProductLocalDataSource>(
      () => ProductLocalDataSource(),
    );

    // Registrar repositorios
    sl.registerLazySingleton<HomeRepository>(
      () => HomeRepositoryImpl(
        categoryDataSource: sl<CategoryLocalDataSource>(),
        productDataSource: sl<ProductLocalDataSource>(),
      ),
    );
  }

  /// Proporciona todos los providers de Repository para MultiRepositoryProvider
  static List<RepositoryProvider> providers = [
    RepositoryProvider<HomeRepository>(
      create:
          (context) => HomeRepositoryImpl(
            categoryDataSource: CategoryLocalDataSource(),
            productDataSource: ProductLocalDataSource(),
          ),
    ),
    // Aquí se pueden agregar más repositorios a medida que la aplicación crezca
  ];
}
