import 'package:dartz/dartz.dart';
import 'package:flutter_application_ecommerce/core/error/exceptions.dart';
import 'package:flutter_application_ecommerce/core/error/failures.dart';
import '../datasources/auth_datasource.dart'; // Importar AuthDataSource
import '../models/user_model.dart'; // Importar UserModel
import '../../domain/entities/user_entity.dart'; // Importar UserEntity
import '../../domain/repositories/repositories.dart'; // Importar AuthRepository contrato

/// Implementación del repositorio de autenticación
class AuthRepositoryImpl implements AuthRepository {
  final AuthDataSource localDataSource; // Usamos la fuente de datos local simulada

  AuthRepositoryImpl({required this.localDataSource});

  @override
  Future<Either<Failure, UserEntity>> signIn({required String email, required String password}) async {
    try {
      final userModel = await localDataSource.signIn(email: email, password: password);
      return Right(userModel); // Retornar el UserModel que extiende UserEntity
    } on AuthenticationException catch (e) {
      return Left(AuthenticationFailure(message: e.message)); // Mapear excepción a Failure
    } catch (e) {
      return Left(UnknownFailure(message: e.toString())); // Otros errores inesperados
    }
  }

  @override
  Future<Either<Failure, UserEntity>> register({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
  }) async {
    try {
      final userModel = await localDataSource.register(
        firstName: firstName,
        lastName: lastName,
        email: email,
        password: password,
      );
      return Right(userModel); // Retornar el UserModel que extiende UserEntity
    } on AuthenticationException catch (e) {
      return Left(AuthenticationFailure(message: e.message)); // Mapear excepción a Failure
    } catch (e) {
      return Left(UnknownFailure(message: e.toString())); // Otros errores inesperados
    }
  }

  @override
  Future<Either<Failure, void>> signOut() async {
    try {
      await localDataSource.signOut();
      return const Right(null); // Operación exitosa no retorna valor
    } on AuthenticationException catch (e) {
      return Left(AuthenticationFailure(message: e.message)); // Mapear excepción a Failure
    } catch (e) {
      return Left(UnknownFailure(message: e.toString())); // Otros errores inesperados
    }
  }
} 