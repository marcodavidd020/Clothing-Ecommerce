import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

import 'package:flutter_application_ecommerce/core/di/di.dart';
import 'package:flutter_application_ecommerce/core/storage/storage_service.dart';
import 'package:flutter_application_ecommerce/core/network/dio_client.dart';
import 'package:flutter_application_ecommerce/core/network/network_info.dart';

import 'package:flutter_application_ecommerce/features/auth/data/data.dart';
import 'package:flutter_application_ecommerce/features/auth/domain/domain.dart';
import 'package:flutter_application_ecommerce/core/network/logger.dart';
import 'package:flutter_application_ecommerce/core/storage/auth_storage.dart';
import 'package:flutter_application_ecommerce/features/auth/presentation/bloc/bloc.dart';

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

    // En desarrollo, simular un token para pruebas
    await mockAuthentication(sl);
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

    // Verificar que las dependencias de infraestructura ya están registradas
    BaseDIContainer.checkDependencies(sl, [
      sl.isRegistered<Dio>(),
      sl.isRegistered<InternetConnectionChecker>(),
      sl.isRegistered<NetworkInfo>(),
      sl.isRegistered<DioClient>(),
    ], 'Las dependencias de infraestructura deben estar registradas antes de registrar AuthDIContainer');
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

  /// Proporciona todos los providers de repositorios para el módulo Auth
  static List<RepositoryProvider> getRepositoryProviders() {
    return [
      RepositoryProvider<AuthRepository>(
        create: (context) => GetIt.instance<AuthRepository>(),
      ),
    ];
  }

  /// Para desarrollo: simular autenticación con token
  static Future<void> mockAuthentication(GetIt sl) async {
    // Solo realizar esta simulación en desarrollo
    const bool isDevelopment = true;
    if (isDevelopment && sl.isRegistered<AuthStorage>()) {
      final authStorage = sl<AuthStorage>();
      final token = await authStorage.getAccessToken();

      // Si no hay token, simular uno para desarrollo
      if (token == null || token.isEmpty) {
        // print('🔐 DESARROLLO: Simulando autenticación con token de prueba');
        AppLogger.logSuccess('🔐 DESARROLLO: Simulando autenticación con token de prueba');
        await authStorage.saveTokens(
          accessToken:
              'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxMjM0NTY3ODkwIiwibmFtZSI6IkRlc2Fycm9sbGFkb3IgZGUgUHJ1ZWJhIiwiaWF0IjoxNTE2MjM5MDIyfQ.SflKxwRJSMeKKF2QT4fwpMeJf36POk6yJV_adQssw5c',
          refreshToken: 'refresh_test_token',
        );
        AppLogger.logSuccess('🔐 DESARROLLO: Token simulado guardado');
      } else {
        AppLogger.logWarning('🔐 Ya existe un token. No se simulará autenticación.');
      }
    }
  }
}
