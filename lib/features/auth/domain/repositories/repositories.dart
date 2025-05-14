import 'package:dartz/dartz.dart'; // Importar Either
import 'package:flutter_application_ecommerce/core/error/failures.dart'; // Importar Failure
import '../entities/user_entity.dart'; // Importar UserEntity
import 'package:flutter_application_ecommerce/features/auth/data/models/request/request.dart'; // Importar params

abstract class AuthRepository {
  /// Intenta iniciar sesión con email y contraseña.
  /// Retorna Right con UserEntity si tiene éxito, Left con Failure si falla.
  Future<Either<Failure, UserEntity>> signIn({required SignInParams params});

  /// Intenta registrar un nuevo usuario.
  /// Retorna Right con UserEntity si tiene éxito, Left con Failure si falla.
  Future<Either<Failure, UserEntity>> register({required RegisterParams params});

  /// Intenta cerrar la sesión actual.
  /// Retorna `Right<Failure, void>` si tiene éxito, Left con Failure si falla.
  Future<Either<Failure, void>> signOut();
}
