import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:flutter_application_ecommerce/features/home/data/data.dart';
import 'package:flutter_application_ecommerce/features/home/domain/domain.dart';
import 'package:flutter_application_ecommerce/features/home/presentation/bloc/bloc.dart';

/// Configuración de inyección de dependencias para el módulo Home
class HomeDIContainer {
  /// Constructor privado para evitar instanciación
  HomeDIContainer._();

  /// Registra las dependencias del módulo Home
  static void register(GetIt sl) {
    // DataSources
    sl.registerLazySingleton<CategoryDataSource>(
      () => CategoryLocalDataSource(),
    );
    sl.registerLazySingleton<ProductDataSource>(
      () => ProductLocalDataSource(),
    );

    // Repositories
    sl.registerLazySingleton<HomeRepository>(
      () => HomeRepositoryImpl(
        categoryDataSource: sl<CategoryDataSource>(),
        productDataSource: sl<ProductDataSource>(),
      ),
    );

    // UseCases
    sl.registerLazySingleton(
      () => GetCategoriesUseCase(sl<HomeRepository>()),
    );
    sl.registerLazySingleton(
      () => GetTopSellingProductsUseCase(sl<HomeRepository>()),
    );
    sl.registerLazySingleton(
      () => GetNewInProductsUseCase(sl<HomeRepository>()),
    );
    sl.registerLazySingleton(
      () => GetProductsByCategoryUseCase(sl<HomeRepository>()),
    );

    // BLoC
    sl.registerFactory(
      () => HomeBloc(
        getCategoriesUseCase: sl<GetCategoriesUseCase>(),
        getTopSellingProductsUseCase: sl<GetTopSellingProductsUseCase>(),
        getNewInProductsUseCase: sl<GetNewInProductsUseCase>(),
        getProductsByCategoryUseCase: sl<GetProductsByCategoryUseCase>(),
      ),
    );
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