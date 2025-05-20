import 'package:dartz/dartz.dart';
import 'package:flutter_application_ecommerce/core/error/failures.dart';
import 'package:flutter_application_ecommerce/features/auth/domain/repositories/repositories.dart';
import 'package:flutter_application_ecommerce/features/auth/domain/entities/user_entity.dart';

class CheckAuthStatusUseCase {
  final AuthRepository repository;

  CheckAuthStatusUseCase(this.repository);

  /// Verifica si el usuario está actualmente autenticado.
  /// Retorna Right(true) si está autenticado y tiene tokens válidos (o UserEntity si se prefiere).
  /// Retorna Right(false) si no está autenticado.
  /// Retorna Left(Failure) si ocurre un error durante la verificación.
  Future<Either<Failure, bool>> execute() async {
    // Primero, verificamos si el almacenamiento local indica que está logueado
    final isAuthenticatedResult = await repository.isAuthenticated();

    return isAuthenticatedResult.fold(
      (failure) => Left(failure), // Propagar el error si la comprobación falla
      (isLoggedIn) async {
        if (isLoggedIn) {
          // Si el almacenamiento dice que está logueado, opcionalmente podríamos
          // verificar si el token sigue siendo válido o refrescarlo aquí,
          // o simplemente confiar en el almacenamiento local para el chequeo inicial.
          // Por simplicidad, si isLoggedIn es true, intentamos obtener el usuario.
          final userResult = await repository.getCurrentUser();
          return userResult.fold(
            (failure) => const Right(
              false,
            ), // Si no se puede obtener el usuario, tratamos como no autenticado
            (user) =>
                Right(user.accessToken != null && user.accessToken!.isNotEmpty),
          );
        }
        return const Right(false); // No está logueado según el almacenamiento
      },
    );
  }

  /// Alternativa: Si solo se necesita UserEntity para popular el AuthBloc
  Future<Either<Failure, UserEntity?>> executeGetUser() async {
    final isAuthenticatedResult = await repository.isAuthenticated();
    if (isAuthenticatedResult.isLeft() ||
        !isAuthenticatedResult.getOrElse(() => false)) {
      return const Right(null); // No autenticado o error al chequear
    }
    return repository.getCurrentUser();
  }
}
