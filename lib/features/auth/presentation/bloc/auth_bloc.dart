import 'package:flutter_application_ecommerce/features/auth/data/models/models.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart'; // Importar meta.dart
import '../../domain/domain.dart'; // Importar casos de uso y entidades (Ruta corregida)
import 'package:flutter_application_ecommerce/features/auth/data/models/request/request.dart'; // Importar los modelos de parámetros
import 'package:flutter_application_ecommerce/core/network/logger.dart'; // Ruta correcta para AppLogger
import 'package:flutter_application_ecommerce/features/auth/domain/usecases/check_auth_status_usecase.dart'; // Importar CheckAuthStatusUseCase

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  // Declarar las dependencias de los casos de uso
  final SignInUseCase signInUseCase;
  final RegisterUseCase registerUseCase;
  final SignOutUseCase signOutUseCase;
  final CheckAuthStatusUseCase checkAuthStatusUseCase; // Añadir caso de uso

  // Modificar el constructor para aceptar las dependencias
  AuthBloc({
    required this.signInUseCase,
    required this.registerUseCase,
    required this.signOutUseCase,
    required this.checkAuthStatusUseCase, // Añadir al constructor
  }) : super(AuthInitial()) {
    on<SignInRequested>(_onSignInRequested);
    on<RegisterRequested>(_onRegisterRequested);
    on<SignOutRequested>(_onSignOutRequested);
    on<CheckInitialAuthStatus>(_onCheckInitialAuthStatus); // Registrar manejador
  }

  Future<void> _onCheckInitialAuthStatus(
    CheckInitialAuthStatus event,
    Emitter<AuthState> emit,
  ) async {
    // No emitimos AuthLoading aquí para no interrumpir la UI de Splash si ya está visible.
    // La SplashPage se encargará de mostrar su propio indicador.
    AppLogger.logInfo('[AuthBloc] Checking initial auth status...');
    final result = await checkAuthStatusUseCase.execute();
    result.fold(
      (failure) {
        AppLogger.logError('[AuthBloc] Error checking auth status: ${failure.message}', failure);
        emit(Unauthenticated()); // En caso de error, asumir no autenticado
      },
      (isAuthenticated) {
        if (isAuthenticated) {
          AppLogger.logInfo('[AuthBloc] User is authenticated. Emitting Authenticated.');
          emit(Authenticated());
        } else {
          AppLogger.logInfo('[AuthBloc] User is not authenticated. Emitting Unauthenticated.');
          emit(Unauthenticated());
        }
      },
    );
  }

  Future<void> _onSignInRequested(
    SignInRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    // Usar el caso de uso con event.params
    final result = await signInUseCase.execute(
      params: event.params, // Usar el objeto params directamente
    );

    result.fold((failure) => emit(AuthError(message: failure.message)), (user) {
      AppLogger.logSuccess('Usuario autenticado exitosamente: ${user.email}');
      // Asumimos que si el inicio de sesión es exitoso, siempre hay tokens.
      emit(Authenticated());
    });
  }

  Future<void> _onRegisterRequested(
    RegisterRequested event,
    Emitter<AuthState> emit,
  ) async {
    AppLogger.logInfo('[AuthBloc] Emitting AuthLoading');
    emit(AuthLoading());
    AppLogger.logInfo('[AuthBloc] Calling registerUseCase.execute');
    final result = await registerUseCase.execute(params: event.params);
    AppLogger.logInfo('[AuthBloc] registerUseCase.execute completed');

    result.fold(
      (failure) {
        AppLogger.logError('[AuthBloc] Emitting AuthError', failure.message);
        emit(AuthError(message: failure.message));
      },
      (user) {
        // Verificar si el usuario tiene tokens
        if (user.accessToken != null && user.accessToken!.isNotEmpty) {
          AppLogger.logSuccess(
            'Usuario registrado y autenticado exitosamente (con tokens): ${user.email}',
          );
          AppLogger.logInfo('[AuthBloc] Emitting Authenticated');
          emit(Authenticated());
        } else {
          AppLogger.logInfo(
            'Usuario registrado exitosamente (sin tokens): ${user.email}. Necesita iniciar sesión.',
          );
          AppLogger.logInfo('[AuthBloc] Emitting RegistrationSuccessNeedSignIn');
          emit(RegistrationSuccessNeedSignIn());
        }
      },
    );
  }

  void _onSignOutRequested(
    SignOutRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    // Usar el caso de uso de cierre de sesión
    final result = await signOutUseCase.execute();

    result.fold((failure) => emit(AuthError(message: failure.message)), (_) {
      AppLogger.logSuccess('Usuario cerró sesión exitosamente.');
      emit(Unauthenticated());
    });
  }
}
