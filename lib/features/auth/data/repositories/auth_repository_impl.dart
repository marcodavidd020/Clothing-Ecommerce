import 'package:dartz/dartz.dart';
import 'package:flutter_application_ecommerce/core/error/exceptions.dart';
import 'package:flutter_application_ecommerce/core/error/failures.dart';
import 'package:flutter_application_ecommerce/features/auth/data/datasources/auth_datasource.dart';
import 'package:flutter_application_ecommerce/features/auth/data/models/models.dart'; // Importa UserMode y los Params
import 'package:flutter_application_ecommerce/features/auth/domain/entities/user_entity.dart';
import 'package:flutter_application_ecommerce/features/auth/domain/repositories/repositories.dart';
import 'package:flutter_application_ecommerce/core/storage/auth_storage.dart';

/// Implementación del repositorio de autenticación
class AuthRepositoryImpl implements AuthRepository {
  final AuthDataSource remoteDataSource;
  final AuthStorage? authStorage;

  AuthRepositoryImpl({required this.remoteDataSource, this.authStorage});

  @override
  Future<Either<Failure, UserEntity>> signIn({
    required SignInParams params,
  }) async {
    try {
      final response = await remoteDataSource.signIn(params: params);

      // Si la respuesta es exitosa, intentamos obtener el perfil del usuario
      try {
        final userData = await remoteDataSource.getProfile();
        return Right(userData);
      } catch (e) {
        // Si no se puede obtener el perfil, usamos los datos de la respuesta de login
        final Map<String, dynamic> data =
            response['data'] as Map<String, dynamic>;
        final UserModel user = UserModel.fromLoginResponse(
          response,
          params.email,
        );
        return Right(user);
      }
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on AuthenticationException catch (e) {
      return Left(AuthenticationFailure(message: e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message));
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> register({
    required RegisterParams params,
  }) async {
    try {
      final user = await remoteDataSource.register(params: params);
      return Right(user);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on AuthenticationException catch (e) {
      return Left(AuthenticationFailure(message: e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message));
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> signOut() async {
    try {
      await remoteDataSource.signOut();
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> isAuthenticated() async {
    try {
      if (authStorage != null) {
        return Right(await authStorage!.isLoggedIn());
      }
      return const Right(false);
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> getCurrentUser() async {
    try {
      if (authStorage != null) {
        final user = await authStorage!.getUserData();
        if (user != null) {
          return Right(user);
        }
      }

      // Si no hay usuario en almacenamiento local, intentamos obtenerlo de la API
      try {
        final userData = await remoteDataSource.getProfile();
        return Right(userData);
      } catch (e) {
        return Left(AuthenticationFailure(message: 'Usuario no autenticado'));
      }
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }
}
