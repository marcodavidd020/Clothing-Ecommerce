part of 'auth_bloc.dart';

@immutable
abstract class AuthState {}

/// Estado inicial
class AuthInitial extends AuthState {}

/// Estado durante la carga (ej. iniciando sesión, registrando)
class AuthLoading extends AuthState {}

/// Estado cuando el usuario está autenticado
class Authenticated extends AuthState {
  // Podríamos incluir datos del usuario aquí si fuera necesario
}

/// Estado cuando el usuario no está autenticado
class Unauthenticated extends AuthState {}

/// Nuevo estado para cuando el registro es exitoso pero se necesita iniciar sesión
class RegistrationSuccessNeedSignIn extends AuthState {}

/// Estado de error
class AuthError extends AuthState {
  final String message;

  AuthError({required this.message});
}
