import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:flutter_application_ecommerce/core/network/dio_client.dart';
import 'data/datasources/coupon_api_datasource.dart';
import 'data/repositories/coupon_repository_impl.dart';
import 'domain/repositories/coupon_repository.dart';
import 'domain/usecases/get_my_coupons_usecase.dart';
import 'domain/usecases/apply_coupon_usecase.dart';
import 'presentation/bloc/coupon_bloc.dart';

/// Contenedor de inyección de dependencias para el módulo de cupones
class CouponDIContainer {
  /// Registra todas las dependencias del módulo de cupones
  static Future<void> register(GetIt sl) async {
    // DataSources
    sl.registerLazySingleton<CouponApiDataSource>(
      () => CouponApiRemoteDataSource(dioClient: sl<DioClient>()),
    );

    // Repositories
    sl.registerLazySingleton<CouponRepository>(
      () => CouponRepositoryImpl(apiDataSource: sl<CouponApiDataSource>()),
    );

    // Use Cases
    sl.registerLazySingleton<GetMyCouponsUseCase>(
      () => GetMyCouponsUseCase(sl<CouponRepository>()),
    );

    sl.registerLazySingleton<ApplyCouponUseCase>(
      () => ApplyCouponUseCase(sl<CouponRepository>()),
    );

    // BLoCs
    sl.registerFactory<CouponBloc>(
      () => CouponBloc(
        getMyCouponsUseCase: sl<GetMyCouponsUseCase>(),
        applyCouponUseCase: sl<ApplyCouponUseCase>(),
      ),
    );
  }

  /// Obtiene los providers de repositorio para el árbol de widgets
  static List<RepositoryProvider> getRepositoryProviders() {
    return [
      RepositoryProvider<CouponRepository>(
        create: (context) => GetIt.instance<CouponRepository>(),
      ),
    ];
  }

  /// Obtiene los providers de BLoC para el árbol de widgets
  static List<BlocProvider> getBlocProviders() {
    return [
      BlocProvider<CouponBloc>(
        create: (context) => GetIt.instance<CouponBloc>(),
      ),
    ];
  }
} 