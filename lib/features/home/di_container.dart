import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:flutter_application_ecommerce/core/di/base_di_container.dart';
import 'package:flutter_application_ecommerce/features/home/data/data.dart';
import 'package:flutter_application_ecommerce/features/home/domain/domain.dart';
import 'package:flutter_application_ecommerce/features/home/presentation/bloc/bloc.dart';
import 'package:flutter_application_ecommerce/features/home/presentation/bloc/home_bloc.dart';
import 'package:flutter_application_ecommerce/features/home/data/datasources/category_api_datasource.dart';
import 'package:flutter_application_ecommerce/core/network/dio_client.dart';
import 'package:flutter_application_ecommerce/core/network/network_info.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

/// Configuración de inyección de dependencias para el módulo Home
class HomeDIContainer extends BaseDIContainer {
  /// Constructor privado para evitar instanciación
  HomeDIContainer._();

  /// Registra las dependencias del módulo Home
  static Future<void> register(GetIt sl) async {
    // 1. PRIMERO asegurar que las dependencias core estén registradas
    await registerCoreDependencies(sl);

    // 2. Registrar datasources
    registerDataSources(sl);

    // 3. Registrar repositorios
    registerRepositories(sl);

    // 4. Registrar casos de uso
    registerUseCases(sl);

    // 5. Registrar BLoCs
    registerBlocs(sl);
  }

  /// Registra las dependencias core necesarias
  static Future<void> registerCoreDependencies(GetIt sl) async {
    // Registrar las dependencias básicas si no existen
    if (!sl.isRegistered<Dio>()) {
      sl.registerLazySingleton<Dio>(() => Dio());
    }

    if (!sl.isRegistered<InternetConnectionChecker>()) {
      sl.registerLazySingleton<InternetConnectionChecker>(
        () => InternetConnectionChecker.createInstance(),
      );
    }

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
    
    // Verificar que DioClient esté disponible
    BaseDIContainer.checkDependencies(sl, [
      sl.isRegistered<DioClient>(),
    ], 'DioClient debe estar registrado antes de registrar HomeDIContainer');
  }

  /// Registra las fuentes de datos
  static void registerDataSources(GetIt sl) {
    // Registrar CategoryApiDataSource
    if (!sl.isRegistered<CategoryApiDataSource>()) {
      sl.registerLazySingleton<CategoryApiDataSource>(
        () => CategoryApiRemoteDataSource(dioClient: sl<DioClient>()),
      );
    }
    
    // Registrar ProductDataSource
    if (!sl.isRegistered<ProductDataSource>()) {
      sl.registerLazySingleton<ProductDataSource>(
        () => ProductLocalDataSource(),
      );
    }
    
    // Validar que las dependencias estén registradas
    BaseDIContainer.checkDependencies(sl, [
      sl.isRegistered<CategoryApiDataSource>(),
      sl.isRegistered<ProductDataSource>(),
    ], 'CategoryApiDataSource y ProductDataSource deben estar registrados antes de continuar');
  }

  /// Registra los repositorios
  static void registerRepositories(GetIt sl) {
    // Validar que las dependencias requeridas estén registradas
    BaseDIContainer.checkDependencies(
      sl,
      [
        sl.isRegistered<ProductDataSource>(),
        sl.isRegistered<CategoryApiDataSource>(),
      ],
      'Las fuentes de datos ProductDataSource y CategoryApiDataSource deben estar registradas '
      'antes de registrar HomeRepository',
    );

    // Registrar HomeRepository con todas sus dependencias
    if (!sl.isRegistered<HomeRepository>()) {
      sl.registerLazySingleton<HomeRepository>(
        () => HomeRepositoryImpl(
          productDataSource: sl<ProductDataSource>(),
          categoryApiDataSource: sl<CategoryApiDataSource>(),
        ),
      );
    }
  }

  /// Registra los casos de uso
  static void registerUseCases(GetIt sl) {
    // Validar que el repositorio requerido esté registrado
    BaseDIContainer.checkDependencies(
      sl,
      [sl.isRegistered<HomeRepository>()],
      'HomeRepository debe estar registrado antes de registrar los casos de uso',
    );

    if (!sl.isRegistered<GetTopSellingProductsUseCase>()) {
      sl.registerLazySingleton(
        () => GetTopSellingProductsUseCase(sl<HomeRepository>()),
      );
    }

    if (!sl.isRegistered<GetNewInProductsUseCase>()) {
      sl.registerLazySingleton(
        () => GetNewInProductsUseCase(sl<HomeRepository>()),
      );
    }

    if (!sl.isRegistered<GetProductsByCategoryUseCase>()) {
      sl.registerLazySingleton(
        () => GetProductsByCategoryUseCase(sl<HomeRepository>()),
      );
    }

    // Registrar el caso de uso para categorías API
    if (!sl.isRegistered<GetApiCategoriesTreeUseCase>()) {
      sl.registerLazySingleton(
        () => GetApiCategoriesTreeUseCase(sl<HomeRepository>()),
      );
    }
    
    // Registrar el caso de uso para obtener categoría por ID
    if (!sl.isRegistered<GetCategoryByIdUseCase>()) {
      sl.registerLazySingleton(
        () => GetCategoryByIdUseCase(sl<HomeRepository>()),
      );
    }
  }

  /// Registra los BLoCs
  static void registerBlocs(GetIt sl) {
    // Validar que los casos de uso requeridos estén registrados
    BaseDIContainer.checkDependencies(
      sl,
      [
        sl.isRegistered<GetTopSellingProductsUseCase>(),
        sl.isRegistered<GetNewInProductsUseCase>(),
        sl.isRegistered<GetProductsByCategoryUseCase>(),
        sl.isRegistered<GetApiCategoriesTreeUseCase>(),
        sl.isRegistered<GetCategoryByIdUseCase>(),
      ],
      'Los casos de uso del módulo Home deben estar registrados antes de registrar HomeBloc',
    );

    if (!sl.isRegistered<HomeBloc>()) {
      sl.registerFactory(
        () => HomeBloc(
          getTopSellingProductsUseCase: sl(),
          getNewInProductsUseCase: sl(),
          getProductsByCategoryUseCase: sl(),
          getApiCategoriesTreeUseCase: sl(),
          getCategoryByIdUseCase: sl(),
        ),
      );
    }
  }

  /// Proporciona todos los providers de BLoC para el módulo Home
  static List<BlocProvider> getBlocProviders(GetIt sl) {
    return [
      BlocProvider<HomeBloc>(
        create: (_) => sl<HomeBloc>()..add(LoadHomeDataEvent()),
      ),
    ];
  }
}
