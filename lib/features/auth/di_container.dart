import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:flutter_application_ecommerce/features/auth/presentation/bloc/bloc.dart';
import 'package:flutter_application_ecommerce/features/auth/data/data.dart'; // Importar capa de datos
import 'package:flutter_application_ecommerce/features/auth/domain/domain.dart'; // Importar capa de dominio

/// Configuración de inyección de dependencias para el módulo Auth
class AuthDIContainer {
  /// Constructor privado para evitar instanciación
  AuthDIContainer._();

  /// Registra las dependencias del módulo Auth
  static void register(GetIt sl) {
    // DataSources
    if (!sl.isRegistered<AuthDataSource>()) {
      sl.registerLazySingleton<AuthDataSource>(
        () => AuthLocalDataSource(), // Usar la implementación simulada
      );
    }

    // Repositories
    if (!sl.isRegistered<AuthRepository>()) {
      sl.registerLazySingleton<AuthRepository>(
        () => AuthRepositoryImpl(localDataSource: sl()), // Inyectar DataSource
      );
    }

    // UseCases
    if (!sl.isRegistered<SignInUseCase>()) {
      sl.registerLazySingleton(
        () => SignInUseCase(sl()), // Inyectar Repositorio
      );
    }
    
    if (!sl.isRegistered<RegisterUseCase>()) {
      sl.registerLazySingleton(
        () => RegisterUseCase(sl()), // Inyectar Repositorio
      );
    }
    
    if (!sl.isRegistered<SignOutUseCase>()) {
      sl.registerLazySingleton(
        () => SignOutUseCase(sl()), // Inyectar Repositorio
      );
    }

    // BLoC
    if (!sl.isRegistered<AuthBloc>()) {
      sl.registerFactory(
        () => AuthBloc(
          signInUseCase: sl(), // Inyectar UseCase de inicio de sesión
          registerUseCase: sl(), // Inyectar UseCase de registro
          signOutUseCase: sl(), // Inyectar UseCase de cierre de sesión
        ),
      );
    }
  }

  /// Proporciona todos los providers de BLoC para el módulo Auth
  static List<BlocProvider> getBlocProviders(GetIt sl) {
    return [
      BlocProvider<AuthBloc>(
        create: (_) => sl<AuthBloc>(), // Crear el BLoC usando GetIt
      ),
    ];
  }
}
