import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

import '../../core/di/di.dart';
import '../../core/network/dio_client.dart';
import '../../core/network/network_info.dart';

import 'data/repositories/order_repository_impl.dart';
import 'domain/repositories/order_repository.dart';
import 'domain/usecases/get_my_orders_usecase.dart';
import 'domain/usecases/create_order_usecase.dart';
import 'presentation/bloc/order_bloc.dart';

/// Configuración de inyección de dependencias para el módulo Orders
class OrderDIContainer extends BaseDIContainer {
  /// Constructor privado para evitar instanciación
  OrderDIContainer._();

  /// Registra las dependencias del módulo Orders
  static Future<void> register(GetIt sl) async {
    // 1. PRIMERO asegurar que las dependencias core estén registradas
    await registerCoreDependencies(sl);

    // 2. Registrar repositorios
    registerRepositories(sl);

    // 3. Registrar casos de uso
    registerUseCases(sl);

    // 4. Registrar BLoCs
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
    ], 'Las dependencias de infraestructura deben estar registradas antes de registrar OrderDIContainer');
  }

  /// Registra los repositorios
  static void registerRepositories(GetIt sl) {
    // Validar que las dependencias requeridas estén registradas
    BaseDIContainer.checkDependencies(
      sl,
      [
        sl.isRegistered<DioClient>(),
      ],
      'DioClient debe estar registrado antes de registrar OrderRepository',
    );

    // Registrar OrderRepository
    if (!sl.isRegistered<OrderRepository>()) {
      sl.registerLazySingleton<OrderRepository>(
        () => OrderRepositoryImpl(dioClient: sl<DioClient>()),
      );
    }
  }

  /// Registra los casos de uso
  static void registerUseCases(GetIt sl) {
    // Validar que el repositorio requerido esté registrado
    BaseDIContainer.checkDependencies(
      sl,
      [sl.isRegistered<OrderRepository>()],
      'OrderRepository debe estar registrado antes de registrar los casos de uso',
    );

    if (!sl.isRegistered<GetMyOrdersUseCase>()) {
      sl.registerLazySingleton<GetMyOrdersUseCase>(
        () => GetMyOrdersUseCase(sl<OrderRepository>()),
      );
    }

    if (!sl.isRegistered<CreateOrderUseCase>()) {
      sl.registerLazySingleton<CreateOrderUseCase>(
        () => CreateOrderUseCase(sl<OrderRepository>()),
      );
    }
  }

  /// Registra los BLoCs
  static void registerBlocs(GetIt sl) {
    // Validar que los casos de uso requeridos estén registrados
    BaseDIContainer.checkDependencies(
      sl,
      [
        sl.isRegistered<GetMyOrdersUseCase>(),
        sl.isRegistered<CreateOrderUseCase>(),
        sl.isRegistered<OrderRepository>(),
      ],
      'Los casos de uso del módulo Orders deben estar registrados antes de registrar OrderBloc',
    );

    if (!sl.isRegistered<OrderBloc>()) {
      sl.registerFactory<OrderBloc>(
        () => OrderBloc(
          getMyOrdersUseCase: sl<GetMyOrdersUseCase>(),
          createOrderUseCase: sl<CreateOrderUseCase>(),
          orderRepository: sl<OrderRepository>(),
        ),
      );
    }
  }

  /// Proporciona todos los providers de BLoC para el módulo Orders
  static List<BlocProvider> getBlocProviders(GetIt sl) {
    return [
      BlocProvider<OrderBloc>(
        create: (context) => sl<OrderBloc>(),
      ),
    ];
  }

  /// Proporciona todos los providers de repositorios para el módulo Orders
  static List<RepositoryProvider> getRepositoryProviders() {
    return [
      RepositoryProvider<OrderRepository>(
        create: (context) => GetIt.instance<OrderRepository>(),
      ),
    ];
  }
} 