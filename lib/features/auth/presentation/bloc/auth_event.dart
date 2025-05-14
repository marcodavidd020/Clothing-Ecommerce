part of 'auth_bloc.dart';

@immutable
abstract class AuthEvent {}

/// Evento para solicitar inicio de sesión
class SignInRequested extends AuthEvent {
  final SignInParams params;

  SignInRequested({required this.params});
}

/// Evento para solicitar registro
class RegisterRequested extends AuthEvent {
  final RegisterParams params;

  RegisterRequested({required this.params});
}

/// Evento para cerrar sesión
class SignOutRequested extends AuthEvent {}
