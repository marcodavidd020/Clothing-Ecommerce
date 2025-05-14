/// Domain repositories for Auth feature
/// Define repository interfaces here.

import 'package:dartz/dartz.dart'; // Importar Either
import 'package:flutter_application_ecommerce/core/error/failures.dart'; // Importar Failure
import '../entities/user_entity.dart'; // Importar UserEntity

abstract class AuthRepository {
  /// Intenta iniciar sesión con email y contraseña.
  /// Retorna Right con UserEntity si tiene éxito, Left con Failure si falla.
  Future<Either<Failure, UserEntity>> signIn({
    required String email,
    required String password,
  });

  /// Intenta registrar un nuevo usuario.
  /// Retorna Right con UserEntity si tiene éxito, Left con Failure si falla.
  Future<Either<Failure, UserEntity>> register({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
    String? phone,
  });

  /// Intenta cerrar la sesión actual.
  /// Retorna Right<Failure, void> si tiene éxito, Left con Failure si falla.
  Future<Either<Failure, void>> signOut();
}
