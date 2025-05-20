import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  final String message;

  const Failure(this.message);

  @override
  List<Object> get props => [message];
}

class ServerFailure extends Failure {
  final int? statusCode;

  const ServerFailure({required String message, this.statusCode})
    : super(message);

  @override
  List<Object> get props => [message, statusCode ?? 0];
}

class NetworkFailure extends Failure {
  const NetworkFailure({required String message}) : super(message);
}

class CacheFailure extends Failure {
  const CacheFailure({required String message}) : super(message);
}

class UnknownFailure extends Failure {
  const UnknownFailure({required String message}) : super(message);
}

/// Falla específica para errores de autenticación
class AuthenticationFailure extends Failure {
  const AuthenticationFailure({required String message}) : super(message);
}

/// Falla específica para errores de validación
class ValidationFailure extends Failure {
  final Map<String, List<String>>? fieldErrors;

  const ValidationFailure({
    required String message,
    this.fieldErrors,
  }) : super(message);

  @override
  List<Object> get props => [message, fieldErrors ?? {}];
}
