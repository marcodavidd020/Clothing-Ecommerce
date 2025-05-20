import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:flutter_application_ecommerce/core/di/base_di_container.dart';
import 'package:flutter_application_ecommerce/core/di/modules/storage_module.dart';
import 'package:flutter_application_ecommerce/core/network/dio_client.dart';
import 'package:flutter_application_ecommerce/core/storage/auth_storage.dart';
import 'package:flutter_application_ecommerce/core/storage/storage_service.dart';
import 'package:flutter_application_ecommerce/features/auth/data/data.dart';
import 'package:flutter_application_ecommerce/features/auth/domain/domain.dart';
import 'package:flutter_application_ecommerce/features/auth/presentation/bloc/bloc.dart';
import 'package:flutter_application_ecommerce/features/auth/domain/usecases/check_auth_status_usecase.dart'; // Importar CheckAuthStatusUseCase

/// Contenedor de inyección de dependencias para el módulo Auth
class AuthDIContainer extends BaseDIContainer {
  /// Constructor privado para evitar instanciación
  AuthDIContainer._();

  /// Registra las dependencias del módulo Auth
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
    // Asegurar que tenemos StorageService y AuthStorage registrados
    // mediante StorageModule antes de continuar
    if (!sl.isRegistered<StorageService>() || !sl.isRegistered<AuthStorage>()) {
      await StorageModule.register(sl);
    }

    // Verificamos que AuthStorage esté disponible (sin registrarlo de nuevo)
    BaseDIContainer.checkDependencies(
      sl,
      [sl.isRegistered<AuthStorage>()],
      'AuthStorage debe estar registrado por StorageModule antes de registrar AuthDIContainer',
    );

    // Asegurar que DioClient está registrado
    BaseDIContainer.checkDependencies(sl, [
      sl.isRegistered<DioClient>(),
    ], 'DioClient debe estar registrado antes de registrar AuthDIContainer');
  }

  /// Registra las fuentes de datos
  static void registerDataSources(GetIt sl) {
    // Validar que las dependencias requeridas estén registradas
    BaseDIContainer.checkDependencies(
      sl,
      [sl.isRegistered<DioClient>(), sl.isRegistered<AuthStorage>()],
      'DioClient y AuthStorage deben estar registrados antes de registrar AuthDataSource',
    );

    if (!sl.isRegistered<AuthDataSource>()) {
      sl.registerLazySingleton<AuthDataSource>(
        () => AuthRemoteDataSource(dioClient: sl(), authStorage: sl()),
      );
    }
  }

  /// Registra los repositorios
  static void registerRepositories(GetIt sl) {
    // Validar que las dependencias requeridas estén registradas
    BaseDIContainer.checkDependencies(
      sl,
      [sl.isRegistered<AuthDataSource>(), sl.isRegistered<AuthStorage>()],
      'AuthDataSource y AuthStorage deben estar registrados antes de registrar AuthRepository',
    );

    if (!sl.isRegistered<AuthRepository>()) {
      sl.registerLazySingleton<AuthRepository>(
        () => AuthRepositoryImpl(remoteDataSource: sl(), authStorage: sl()),
      );
    }
  }

  /// Registra los casos de uso
  static void registerUseCases(GetIt sl) {
    // Validar que el repositorio requerido esté registrado
    BaseDIContainer.checkDependencies(sl, [
      sl.isRegistered<AuthRepository>(),
    ], 'AuthRepository debe estar registrado antes de registrar casos de uso');

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
  static void registerBlocs(GetIt sl) {
    // Validar que los casos de uso requeridos estén registrados
    BaseDIContainer.checkDependencies(sl, [
      sl.isRegistered<SignInUseCase>(),
      sl.isRegistered<RegisterUseCase>(),
      sl.isRegistered<SignOutUseCase>(),
      sl.isRegistered<CheckAuthStatusUseCase>(),
    ], 'Los casos de uso deben estar registrados antes de registrar AuthBloc');

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
