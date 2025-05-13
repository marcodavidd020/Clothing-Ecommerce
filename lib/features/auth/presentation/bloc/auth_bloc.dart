import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart'; // Importar meta.dart
import '../../domain/domain.dart'; // Importar casos de uso y entidades (Ruta corregida)

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
    // Usar el caso de uso en lugar de la lógica simulada directa
    final result = await signInUseCase.execute(
      email: event.email,
      password: event.password,
    );

    result.fold(
      (failure) => emit(AuthError(message: failure.message)),
      (user) => emit(
        Authenticated(),
      ), // Opcional: Pasar el usuario al estado Authenticated
    );
  }

  Future<void> _onRegisterRequested(
    RegisterRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    // Usar el caso de uso de registro
    final result = await registerUseCase.execute(
      firstName: event.firstName,
      lastName: event.lastName,
      email: event.email,
      password: event.password,
    );

    result.fold(
      (failure) => emit(AuthError(message: failure.message)),
      (user) =>
          emit(Authenticated()), // Asumimos que registro exitoso autentica
    );
  }

  void _onSignOutRequested(
    SignOutRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    // Usar el caso de uso de cierre de sesión
    final result = await signOutUseCase.execute();

    result.fold(
      (failure) => emit(AuthError(message: failure.message)),
      (_) => emit(Unauthenticated()), // No se espera valor de retorno en éxito
    );
  }
}
