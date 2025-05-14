import 'package:dartz/dartz.dart';
import 'package:flutter_application_ecommerce/core/error/exceptions.dart';
import 'package:flutter_application_ecommerce/core/error/failures.dart';
import 'package:flutter_application_ecommerce/features/auth/data/datasources/auth_datasource.dart';
import 'package:flutter_application_ecommerce/features/auth/data/models/models.dart'; // Importa UserMode y los Params
import 'package:flutter_application_ecommerce/features/auth/domain/entities/user_entity.dart';
import 'package:flutter_application_ecommerce/features/auth/domain/repositories/repositories.dart';

/// Implementación del repositorio de autenticación
class AuthRepositoryImpl implements AuthRepository {
  final AuthDataSource dataSource;

  AuthRepositoryImpl({required this.dataSource});

  @override
  Future<Either<Failure, UserEntity>> signIn({required SignInParams params}) async {
    try {
      final Map<String, dynamic> responseData = await dataSource.signIn(params: params);
      final userModel = UserModel.fromLoginResponse(responseData, params.email);
      return Right(userModel);
    } on AuthenticationException catch (e) {
      String errorMessage = e.message;
      if (e.errors != null && e.errors!.isNotEmpty) {
        final firstError = e.errors!.first;
        if (firstError['errors'] is List &&
            (firstError['errors'] as List).isNotEmpty) {
          errorMessage = (firstError['errors'] as List).first as String;
        }
      }
      return Left(AuthenticationFailure(message: errorMessage));
    } on ServerException catch (e) {
      return Left(
        ServerFailure(message: e.message ?? 'Error del servidor'),
      );
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message ?? 'Error de red'));
    } catch (e) {
      return Left(
        UnknownFailure(
          message:
              "Error inesperado durante el inicio de sesión: ${e.toString()}",
        ),
      );
    }
  }

  @override
  Future<Either<Failure, UserEntity>> register({required RegisterParams params}) async {
    try {
      final userModel = await dataSource.register(params: params);
      return Right(userModel);
    } on AuthenticationException catch (e) {
      String errorMessage = e.message;
      if (e.errors != null && e.errors!.isNotEmpty) {
        final firstError = e.errors!.first;
        if (firstError['errors'] is List &&
            (firstError['errors'] as List).isNotEmpty) {
          errorMessage = (firstError['errors'] as List).first as String;
        }
      }
      return Left(AuthenticationFailure(message: errorMessage));
    } on ServerException catch (e) {
      return Left(
        ServerFailure(
          message: e.message ?? 'Error del servidor al registrar',
        ),
      );
    } on NetworkException catch (e) {
      return Left(
        NetworkFailure(
          message: e.message ?? 'Error de red al registrar',
        ),
      );
    } catch (e) {
      return Left(
        UnknownFailure(
          message: "Error inesperado durante el registro: ${e.toString()}",
        ),
      );
    }
  }

  @override
  Future<Either<Failure, void>> signOut() async {
    try {
      await dataSource.signOut();
      return const Right(null);
    } on AuthenticationException catch (e) { // Se mantiene como AuthenticationFailure porque es específico de auth
      return Left(AuthenticationFailure(message: e.message));
    } on ServerException catch (e) {
      return Left(
        ServerFailure(
          message: e.message ?? 'Error del servidor al cerrar sesión',
        ),
      );
    } on NetworkException catch (e) {
      return Left(
        NetworkFailure(
          message: e.message ?? 'Error de red al cerrar sesión',
        ),
      );
    } catch (e) {
      return Left(
        UnknownFailure(
          message:
              "Error inesperado durante el cierre de sesión: ${e.toString()}",
        ),
      );
    }
  }
}
