part of 'auth_bloc.dart';

@immutable
abstract class AuthEvent {}

/// Evento para solicitar inicio de sesión
class SignInRequested extends AuthEvent {
  final String email;
  final String password;

  SignInRequested({required this.email, required this.password});
}

/// Evento para solicitar registro
class RegisterRequested extends AuthEvent {
  final String firstName;
  final String lastName;
  final String email;
  final String password;

  RegisterRequested({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.password,
  });
}

/// Evento para cerrar sesión
class SignOutRequested extends AuthEvent {}
