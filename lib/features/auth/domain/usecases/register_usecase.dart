import 'package:dartz/dartz.dart';
import 'package:flutter_application_ecommerce/core/error/failures.dart';
import 'package:flutter_application_ecommerce/features/auth/data/data.dart';
import '../entities/user_entity.dart';
import '../repositories/repositories.dart';

/// Caso de uso para registrar un nuevo usuario
class RegisterUseCase {
  final AuthRepository repository;

  RegisterUseCase(this.repository);

  /// Ejecuta el caso de uso para registrar un nuevo usuario
  Future<Either<Failure, UserEntity>> execute({
    required RegisterParams params,
  }) async {
    return await repository.register(
      params: params,
    );
  }
}
