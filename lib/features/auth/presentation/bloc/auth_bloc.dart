import 'package:flutter_application_ecommerce/features/auth/data/models/models.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart'; // Importar meta.dart
import '../../domain/domain.dart'; // Importar casos de uso y entidades (Ruta corregida)
import 'package:flutter_application_ecommerce/features/auth/data/models/request/request.dart'; // Importar los modelos de parámetros
import 'package:flutter_application_ecommerce/core/network/logger.dart'; // Ruta correcta para AppLogger

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  // Declarar las dependencias de los casos de uso
  final SignInUseCase signInUseCase;
  final RegisterUseCase registerUseCase;
  final SignOutUseCase signOutUseCase;

  // Modificar el constructor para aceptar las dependencias
  AuthBloc({
    required this.signInUseCase,
    required this.registerUseCase,
    required this.signOutUseCase,
  }) : super(AuthInitial()) {
    on<SignInRequested>(_onSignInRequested);
    on<RegisterRequested>(_onRegisterRequested);
    on<SignOutRequested>(_onSignOutRequested);
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
      emit(Authenticated());
    });
  }

  Future<void> _onRegisterRequested(
    RegisterRequested event,
    Emitter<AuthState> emit,
  ) async {
    AppLogger.logInfo('[AuthBloc] Emitting AuthLoading');
    emit(AuthLoading());
    // DESCOMENTA LA SIGUIENTE LÍNEA PARA FORZAR LA VISUALIZACIÓN DEL LOADER:
    // await Future.delayed(const Duration(seconds: 3));
    AppLogger.logInfo('[AuthBloc] Calling registerUseCase.execute');
    final result = await registerUseCase.execute(params: event.params);
    AppLogger.logInfo('[AuthBloc] registerUseCase.execute completed');

    result.fold(
      (failure) {
        AppLogger.logError('[AuthBloc] Emitting AuthError', failure.message);
        emit(AuthError(message: failure.message));
      },
      (user) {
        AppLogger.logSuccess(
          'Usuario registrado y autenticado exitosamente: ${user.email}',
        );
        AppLogger.logInfo('[AuthBloc] Emitting Authenticated');
        emit(Authenticated());
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
