import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:flutter_application_ecommerce/core/network/dio_client.dart';
import 'data/datasources/payment_api_datasource.dart';
import 'data/repositories/payment_repository_impl.dart';
import 'domain/repositories/payment_repository.dart';
import 'domain/usecases/create_payment_usecase.dart';

/// Contenedor de inyección de dependencias para el módulo de pagos
class PaymentDIContainer {
  /// Registra todas las dependencias del módulo de pagos
  static Future<void> register(GetIt sl) async {
    // DataSources
    sl.registerLazySingleton<PaymentApiDataSource>(
      () => PaymentApiRemoteDataSource(dioClient: sl<DioClient>()),
    );

    // Repositories
    sl.registerLazySingleton<PaymentRepository>(
      () => PaymentRepositoryImpl(dioClient: sl<DioClient>()),
    );

    // Use Cases
    sl.registerLazySingleton<CreatePaymentUseCase>(
      () => CreatePaymentUseCase(sl<PaymentRepository>()),
    );
  }

  /// Obtiene los providers de repositorio para el árbol de widgets
  static List<RepositoryProvider> getRepositoryProviders() {
    return [
      RepositoryProvider<PaymentRepository>(
        create: (context) => GetIt.instance<PaymentRepository>(),
      ),
    ];
  }
} 