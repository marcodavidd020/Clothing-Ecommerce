import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:flutter_application_ecommerce/features/home/data/data.dart';
import 'package:flutter_application_ecommerce/features/home/domain/domain.dart';
import 'package:flutter_application_ecommerce/features/home/presentation/bloc/bloc.dart';
import 'package:flutter_application_ecommerce/features/home/domain/usecases/get_categories_usecase.dart';
import 'package:flutter_application_ecommerce/features/home/domain/usecases/get_new_in_products_usecase.dart';
import 'package:flutter_application_ecommerce/features/home/domain/usecases/get_products_by_category_usecase.dart';
import 'package:flutter_application_ecommerce/features/home/domain/usecases/get_top_selling_products_usecase.dart';
import 'package:flutter_application_ecommerce/features/home/domain/repositories/home_repository.dart';
import 'package:flutter_application_ecommerce/features/home/presentation/bloc/home_bloc.dart';

/// Configuración de inyección de dependencias para el módulo Home
class HomeDIContainer {
  /// Constructor privado para evitar instanciación
  HomeDIContainer._();

  /// Registra las dependencias del módulo Home
  static void register(GetIt sl) {
    // DataSources
    if (!sl.isRegistered<CategoryDataSource>()) {
      sl.registerLazySingleton<CategoryDataSource>(
        () => CategoryLocalDataSource(),
      );
    }

    if (!sl.isRegistered<ProductDataSource>()) {
      sl.registerLazySingleton<ProductDataSource>(
        () => ProductLocalDataSource(),
      );
    }

    // Repositories
    if (!sl.isRegistered<HomeRepository>()) {
      sl.registerLazySingleton<HomeRepository>(
        () => HomeRepositoryImpl(
          categoryDataSource: sl<CategoryDataSource>(),
          productDataSource: sl<ProductDataSource>(),
        ),
      );
    }

    // UseCases
    if (!sl.isRegistered<GetCategoriesUseCase>()) {
      sl.registerLazySingleton(() => GetCategoriesUseCase(sl<HomeRepository>()));
    }

    if (!sl.isRegistered<GetTopSellingProductsUseCase>()) {
      sl.registerLazySingleton(() => GetTopSellingProductsUseCase(sl<HomeRepository>()));
    }

    if (!sl.isRegistered<GetNewInProductsUseCase>()) {
      sl.registerLazySingleton(() => GetNewInProductsUseCase(sl<HomeRepository>()));
    }

    if (!sl.isRegistered<GetProductsByCategoryUseCase>()) {
      sl.registerLazySingleton(() => GetProductsByCategoryUseCase(sl<HomeRepository>()));
    }

    // BLoC
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
