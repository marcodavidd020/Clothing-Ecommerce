import 'package:dartz/dartz.dart';
import 'package:flutter_application_ecommerce/core/error/failures.dart';
import '../repositories/repositories.dart';

/// Caso de uso para cerrar sesión
class SignOutUseCase {
  final AuthRepository repository;

  SignOutUseCase(this.repository);

  /// Ejecuta el caso de uso para cerrar sesión
  Future<Either<Failure, void>> execute() async {
    return await repository.signOut();
  }
}
