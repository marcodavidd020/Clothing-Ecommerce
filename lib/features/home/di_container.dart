import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

import '../../core/di/base_di_container.dart';
import '../../core/storage/storage_service.dart';
import '../../core/network/dio_client.dart';
import '../../core/network/network_info.dart';

import 'data/datasources/category_api_datasource.dart';
import 'data/datasources/product_api_datasource.dart';
import 'data/repositories/home_repository_impl.dart';
import 'domain/repositories/home_repository.dart';
import 'domain/usecases/get_api_categories_tree_usecase.dart';
import 'domain/usecases/get_category_by_id_usecase.dart';
import 'domain/usecases/get_product_by_id_usecase.dart';
import 'domain/usecases/get_products_by_category_usecase.dart';
import 'presentation/bloc/home_bloc.dart';
import 'presentation/bloc/events/home_event.dart';
import 'core/core.dart';

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

    // Registrar CategoryStorage
    if (!sl.isRegistered<CategoryStorage>()) {
      sl.registerLazySingleton<CategoryStorage>(
        () => CategoryStorage(sl<StorageService>()),
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

    // Registrar ProductApiDataSource
    if (!sl.isRegistered<ProductApiDataSource>()) {
      sl.registerLazySingleton<ProductApiDataSource>(
        () => ProductApiRemoteDataSource(dioClient: sl<DioClient>()),
      );
    }

    // Validar que las dependencias estén registradas
    BaseDIContainer.checkDependencies(
      sl,
      [
        sl.isRegistered<CategoryApiDataSource>(),
        sl.isRegistered<ProductApiDataSource>(),
      ],
      'CategoryApiDataSource y ProductDataSource deben estar registrados antes de continuar',
    );
  }

  /// Registra los repositorios
  static void registerRepositories(GetIt sl) {
    // Validar que las dependencias requeridas estén registradas
    BaseDIContainer.checkDependencies(
      sl,
      [
        sl.isRegistered<CategoryApiDataSource>(),
        sl.isRegistered<ProductApiDataSource>(),
      ],
      'Las fuentes de datos ProductDataSource, CategoryApiDataSource y ProductApiDataSource deben estar registradas '
      'antes de registrar HomeRepository',
    );

    // Registrar HomeRepository con todas sus dependencias
    if (!sl.isRegistered<HomeRepository>()) {
      sl.registerLazySingleton<HomeRepository>(
        () => HomeRepositoryImpl(
          categoryApiDataSource: sl<CategoryApiDataSource>(),
          productApiDataSource: sl<ProductApiDataSource>(),
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

    if (!sl.isRegistered<GetProductByIdUseCase>()) {
      sl.registerLazySingleton(
        () => GetProductByIdUseCase(sl<HomeRepository>()),
      );
    }
  }

  /// Registra los BLoCs
  static void registerBlocs(GetIt sl) {
    // Validar que los casos de uso requeridos estén registrados
    BaseDIContainer.checkDependencies(
      sl,
      [
        sl.isRegistered<GetProductsByCategoryUseCase>(),
        sl.isRegistered<GetApiCategoriesTreeUseCase>(),
        sl.isRegistered<GetCategoryByIdUseCase>(),
        sl.isRegistered<GetProductByIdUseCase>(),
        sl.isRegistered<CategoryStorage>(),
      ],
      'Los casos de uso del módulo Home deben estar registrados antes de registrar HomeBloc',
    );

    if (!sl.isRegistered<HomeBloc>()) {
      sl.registerFactory(
        () => HomeBloc(
          getProductsByCategoryUseCase: sl(),
          getApiCategoriesTreeUseCase: sl(),
          getCategoryByIdUseCase: sl(),
          getProductByIdUseCase: sl(),
          categoryStorage: sl(),
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
