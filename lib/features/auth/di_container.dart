import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:flutter_application_ecommerce/features/auth/presentation/bloc/bloc.dart';
import 'package:flutter_application_ecommerce/features/auth/data/data.dart'; // Importar capa de datos
import 'package:flutter_application_ecommerce/features/auth/domain/domain.dart'; // Importar capa de dominio
import 'package:flutter_application_ecommerce/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:flutter_application_ecommerce/core/storage/auth_storage.dart';
import 'package:flutter_application_ecommerce/features/auth/domain/usecases/check_auth_status_usecase.dart'; // Importar CheckAuthStatusUseCase

/// Configuración de inyección de dependencias para el módulo Auth
class AuthDIContainer {
  /// Constructor privado para evitar instanciación
  AuthDIContainer._();

  /// Registra las dependencias del módulo Auth
  static void register(GetIt sl) {
    // DataSources
    if (!sl.isRegistered<AuthDataSource>()) {
      sl.registerLazySingleton<AuthDataSource>(
        () => AuthRemoteDataSource(
          dioClient: sl(),
          authStorage: sl.isRegistered<AuthStorage>() ? sl<AuthStorage>() : null,
        ),
      );
    }

    // Repositories
    if (!sl.isRegistered<AuthRepository>()) {
      sl.registerLazySingleton<AuthRepository>(
        () => AuthRepositoryImpl(
          remoteDataSource: sl(),
          authStorage: sl.isRegistered<AuthStorage>() ? sl<AuthStorage>() : null,
        ),
      );
    }

    // UseCases
    if (!sl.isRegistered<SignInUseCase>()) {
      sl.registerLazySingleton(() => SignInUseCase(sl()));
    }

    if (!sl.isRegistered<RegisterUseCase>()) {
      sl.registerLazySingleton(() => RegisterUseCase(sl()));
    }

    if (!sl.isRegistered<SignOutUseCase>()) {
      sl.registerLazySingleton(() => SignOutUseCase(sl()));
    }

    if (!sl.isRegistered<CheckAuthStatusUseCase>()) { // Registrar CheckAuthStatusUseCase
      sl.registerLazySingleton(() => CheckAuthStatusUseCase(sl()));
    }

    // BLoC
    if (!sl.isRegistered<AuthBloc>()) {
      sl.registerFactory(
        () => AuthBloc(
          signInUseCase: sl(),
          registerUseCase: sl(),
          signOutUseCase: sl(),
          checkAuthStatusUseCase: sl(), // Inyectar CheckAuthStatusUseCase
        ),
      );
    }
  }

  /// Proporciona todos los providers de BLoC para el módulo Auth
  static List<BlocProvider> getBlocProviders(GetIt sl) {
    return [
      BlocProvider<AuthBloc>(
        create: (_) => sl<AuthBloc>(),
      ),
    ];
  }
}
