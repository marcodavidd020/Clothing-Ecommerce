import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

import '../../core/di/di.dart';
import '../../core/network/dio_client.dart';
import '../../core/network/network_info.dart';

import 'data/data.dart';
import 'domain/domain.dart';
import 'presentation/bloc/bloc.dart';

/// Configuración de inyección de dependencias para el módulo Cart
class CartDIContainer extends BaseDIContainer {
  /// Constructor privado para evitar instanciación
  CartDIContainer._();

  /// Registra las dependencias del módulo Cart
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
    // Verificar que las dependencias de infraestructura ya están registradas
    BaseDIContainer.checkDependencies(sl, [
      sl.isRegistered<Dio>(),
      sl.isRegistered<InternetConnectionChecker>(),
      sl.isRegistered<NetworkInfo>(),
      sl.isRegistered<DioClient>(),
    ], 'Las dependencias de infraestructura deben estar registradas antes de registrar CartDIContainer');
  }

  /// Registra las fuentes de datos
  static void registerDataSources(GetIt sl) {
    // Registrar CartApiDataSource
    if (!sl.isRegistered<CartApiDataSource>()) {
      sl.registerLazySingleton<CartApiDataSource>(
        () => CartApiRemoteDataSource(dioClient: sl<DioClient>()),
      );
    }

    // Validar que las dependencias estén registradas
    BaseDIContainer.checkDependencies(
      sl,
      [
        sl.isRegistered<CartApiDataSource>(),
      ],
      'CartApiDataSource debe estar registrado antes de continuar',
    );
  }

  /// Registra los repositorios
  static void registerRepositories(GetIt sl) {
    // Validar que las dependencias requeridas estén registradas
    BaseDIContainer.checkDependencies(
      sl,
      [
        sl.isRegistered<CartApiDataSource>(),
      ],
      'CartApiDataSource debe estar registrado antes de registrar CartRepository',
    );

    // Registrar CartRepository
    if (!sl.isRegistered<CartRepository>()) {
      sl.registerLazySingleton<CartRepository>(
        () => CartRepositoryImpl(
          cartApiDataSource: sl<CartApiDataSource>(),
        ),
      );
    }
  }

  /// Registra los casos de uso
  static void registerUseCases(GetIt sl) {
    // Validar que el repositorio requerido esté registrado
    BaseDIContainer.checkDependencies(
      sl,
      [sl.isRegistered<CartRepository>()],
      'CartRepository debe estar registrado antes de registrar los casos de uso',
    );

    if (!sl.isRegistered<GetMyCartUseCase>()) {
      sl.registerLazySingleton(
        () => GetMyCartUseCase(sl<CartRepository>()),
      );
    }

    if (!sl.isRegistered<AddItemToCartUseCase>()) {
      sl.registerLazySingleton(
        () => AddItemToCartUseCase(sl<CartRepository>()),
      );
    }

    if (!sl.isRegistered<UpdateCartItemUseCase>()) {
      sl.registerLazySingleton(
        () => UpdateCartItemUseCase(sl<CartRepository>()),
      );
    }

    if (!sl.isRegistered<RemoveCartItemUseCase>()) {
      sl.registerLazySingleton(
        () => RemoveCartItemUseCase(sl<CartRepository>()),
      );
    }

    if (!sl.isRegistered<ClearCartUseCase>()) {
      sl.registerLazySingleton(
        () => ClearCartUseCase(sl<CartRepository>()),
      );
    }
  }

  /// Registra los BLoCs
  static void registerBlocs(GetIt sl) {
    // Validar que los casos de uso requeridos estén registrados
    BaseDIContainer.checkDependencies(
      sl,
      [
        sl.isRegistered<GetMyCartUseCase>(),
        sl.isRegistered<AddItemToCartUseCase>(),
        sl.isRegistered<UpdateCartItemUseCase>(),
        sl.isRegistered<RemoveCartItemUseCase>(),
        sl.isRegistered<ClearCartUseCase>(),
      ],
      'Los casos de uso del módulo Cart deben estar registrados antes de registrar CartBloc',
    );

    if (!sl.isRegistered<CartBloc>()) {
      sl.registerFactory(
        () => CartBloc(
          getMyCartUseCase: sl(),
          addItemToCartUseCase: sl(),
          updateCartItemUseCase: sl(),
          removeCartItemUseCase: sl(),
          clearCartUseCase: sl(),
        ),
      );
    }
  }

  /// Proporciona todos los providers de BLoC para el módulo Cart
  static List<BlocProvider> getBlocProviders(GetIt sl) {
    return [
      BlocProvider<CartBloc>(
        create: (context) => sl<CartBloc>(),
      ),
    ];
  }

  /// Proporciona todos los providers de repositorios para el módulo Cart
  static List<RepositoryProvider> getRepositoryProviders() {
    return [
      RepositoryProvider<CartRepository>(
        create: (context) => GetIt.instance<CartRepository>(),
      ),
    ];
  }
} 