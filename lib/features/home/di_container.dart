import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:flutter_application_ecommerce/core/di/base_di_container.dart';
import 'package:flutter_application_ecommerce/features/home/data/data.dart';
import 'package:flutter_application_ecommerce/features/home/domain/domain.dart';
import 'package:flutter_application_ecommerce/features/home/presentation/bloc/bloc.dart';
import 'package:flutter_application_ecommerce/features/home/presentation/bloc/home_bloc.dart';

/// Configuración de inyección de dependencias para el módulo Home
class HomeDIContainer extends BaseDIContainer {
  /// Constructor privado para evitar instanciación
  HomeDIContainer._();

  /// Registra las dependencias del módulo Home
  static Future<void> register(GetIt sl) async {
    // Asegurar que las dependencias base estén registradas
    await registerCoreDependencies(sl);

    // DataSources
    registerDataSources(sl);

    // Repositories
    registerRepositories(sl);

    // UseCases
    registerUseCases(sl);

    // BLoC
    registerBlocs(sl);
  }

  /// Registra las dependencias core necesarias
  static Future<void> registerCoreDependencies(GetIt sl) async {
    // Si se requieren dependencias específicas, validarlas aquí
    // Por ahora esta función está vacía pero se mantiene para consistencia con
    // la estructura de otros contenedores DI y para futuras extensiones
  }

  /// Registra las fuentes de datos
  static void registerDataSources(GetIt sl) {
    if (!sl.isRegistered<CategoryDataSource>()) {
      sl.registerLazySingleton<CategoryDataSource>(
        () => CategoryLocalDataSource(),
      );
    } else {
      // Logging opcional para desarrollo/debugging
      // print('CategoryDataSource ya está registrado');
    }

    if (!sl.isRegistered<ProductDataSource>()) {
      sl.registerLazySingleton<ProductDataSource>(
        () => ProductLocalDataSource(),
      );
    } else {
      // Logging opcional para desarrollo/debugging
      // print('ProductDataSource ya está registrado');
    }
  }

  /// Registra los repositorios
  static void registerRepositories(GetIt sl) {
    // Validar que las dependencias requeridas estén registradas
    BaseDIContainer.checkDependencies(
      sl,
      [
        sl.isRegistered<CategoryDataSource>(),
        sl.isRegistered<ProductDataSource>(),
      ],
      'Las fuentes de datos CategoryDataSource y ProductDataSource deben estar registradas '
      'antes de registrar HomeRepository',
    );

    if (!sl.isRegistered<HomeRepository>()) {
      sl.registerLazySingleton<HomeRepository>(
        () => HomeRepositoryImpl(
          categoryDataSource: sl<CategoryDataSource>(),
          productDataSource: sl<ProductDataSource>(),
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

    if (!sl.isRegistered<GetCategoriesUseCase>()) {
      sl.registerLazySingleton(
        () => GetCategoriesUseCase(sl<HomeRepository>()),
      );
    }

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
  }

  /// Registra los BLoCs
  static void registerBlocs(GetIt sl) {
    // Validar que los casos de uso requeridos estén registrados
    BaseDIContainer.checkDependencies(
      sl,
      [
        sl.isRegistered<GetCategoriesUseCase>(),
        sl.isRegistered<GetTopSellingProductsUseCase>(),
        sl.isRegistered<GetNewInProductsUseCase>(),
        sl.isRegistered<GetProductsByCategoryUseCase>(),
      ],
      'Los casos de uso del módulo Home deben estar registrados antes de registrar HomeBloc',
    );

    if (!sl.isRegistered<HomeBloc>()) {
      sl.registerFactory(
        () => HomeBloc(
          getCategoriesUseCase: sl(),
          getTopSellingProductsUseCase: sl(),
          getNewInProductsUseCase: sl(),
          getProductsByCategoryUseCase: sl(),
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
