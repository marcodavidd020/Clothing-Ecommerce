import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:flutter_application_ecommerce/core/di/modules/storage_module.dart';
import 'package:flutter_application_ecommerce/core/network/dio_client.dart';
import 'package:flutter_application_ecommerce/core/storage/auth_storage.dart';
import 'package:flutter_application_ecommerce/core/storage/storage_service.dart';
import 'package:flutter_application_ecommerce/features/auth/data/data.dart';
import 'package:flutter_application_ecommerce/features/auth/domain/domain.dart';
import 'package:flutter_application_ecommerce/features/auth/presentation/bloc/bloc.dart';
import 'package:flutter_application_ecommerce/features/auth/domain/usecases/check_auth_status_usecase.dart'; // Importar CheckAuthStatusUseCase

/// Contenedor de inyección de dependencias para el módulo Auth
class AuthDIContainer {
  /// Constructor privado para evitar instanciación
  const AuthDIContainer._();

  /// Registra las dependencias del módulo Auth
  static Future<void> register(GetIt sl) async {
    // Asegurar que las dependencias base estén registradas
    await _registerCoreDependencies(sl);

    // DataSources
    _registerDataSources(sl);

    // Repositories
    _registerRepositories(sl);

    // UseCases
    _registerUseCases(sl);

    // BLoC
    _registerBlocs(sl);
  }

  /// Registra las dependencias core necesarias
  static Future<void> _registerCoreDependencies(GetIt sl) async {
    // Asegurar que AuthStorage está registrado
    if (!sl.isRegistered<AuthStorage>()) {
      // Registrar servicio de almacenamiento si es necesario
      if (!sl.isRegistered<StorageService>()) {
        await StorageModule.register(sl);
      }

      sl.registerLazySingleton<AuthStorage>(() => AuthStorage(sl()));
    }

    // Asegurar que DioClient está registrado
    if (!sl.isRegistered<DioClient>()) {
      throw StateError(
        'DioClient debe estar registrado antes de registrar AuthDIContainer',
      );
    }
  }

  /// Registra las fuentes de datos
  static void _registerDataSources(GetIt sl) {
    if (!sl.isRegistered<AuthDataSource>()) {
      sl.registerLazySingleton<AuthDataSource>(
        () => AuthRemoteDataSource(dioClient: sl(), authStorage: sl()),
      );
    }
  }

  /// Registra los repositorios
  static void _registerRepositories(GetIt sl) {
    if (!sl.isRegistered<AuthRepository>()) {
      sl.registerLazySingleton<AuthRepository>(
        () => AuthRepositoryImpl(remoteDataSource: sl(), authStorage: sl()),
      );
    }
  }

  /// Registra los casos de uso
  static void _registerUseCases(GetIt sl) {
    if (!sl.isRegistered<SignInUseCase>()) {
      sl.registerLazySingleton(() => SignInUseCase(sl()));
    }

    if (!sl.isRegistered<RegisterUseCase>()) {
      sl.registerLazySingleton(() => RegisterUseCase(sl()));
    }

    if (!sl.isRegistered<SignOutUseCase>()) {
      sl.registerLazySingleton(() => SignOutUseCase(sl()));
    }

    if (!sl.isRegistered<CheckAuthStatusUseCase>()) {
      sl.registerLazySingleton(() => CheckAuthStatusUseCase(sl()));
    }
  }

  /// Registra los BLoCs
  static void _registerBlocs(GetIt sl) {
    if (!sl.isRegistered<AuthBloc>()) {
      sl.registerFactory(
        () => AuthBloc(
          signInUseCase: sl(),
          registerUseCase: sl(),
          signOutUseCase: sl(),
          checkAuthStatusUseCase: sl(),
        ),
      );
    }
  }

  /// Proporciona todos los providers de BLoC para el módulo Auth
  static List<BlocProvider> getBlocProviders(GetIt sl) {
    return [BlocProvider<AuthBloc>(create: (_) => sl<AuthBloc>())];
  }
}
