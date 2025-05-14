import 'package:dartz/dartz.dart';
import 'package:flutter_application_ecommerce/core/error/failures.dart';
import 'package:flutter_application_ecommerce/features/auth/data/data.dart';
import '../entities/user_entity.dart';
import '../repositories/repositories.dart';

/// Caso de uso para iniciar sesión
class SignInUseCase {
  final AuthRepository repository;

  SignInUseCase(this.repository);

  /// Ejecuta el caso de uso para iniciar sesión
  Future<Either<Failure, UserEntity>> execute({
    required SignInParams params,
  }) async {
    return await repository.signIn(
      params: params,
    );
  }
}
