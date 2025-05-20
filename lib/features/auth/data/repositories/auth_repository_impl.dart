import 'package:dartz/dartz.dart';
import 'package:flutter_application_ecommerce/core/error/exceptions.dart';
import 'package:flutter_application_ecommerce/core/error/failures.dart';
import 'package:flutter_application_ecommerce/core/network/logger.dart';
import 'package:flutter_application_ecommerce/features/auth/core/core.dart';
import 'package:flutter_application_ecommerce/features/auth/data/datasources/auth_datasource.dart';
import 'package:flutter_application_ecommerce/features/auth/data/models/models.dart';
import 'package:flutter_application_ecommerce/features/auth/domain/entities/user_entity.dart';
import 'package:flutter_application_ecommerce/features/auth/domain/repositories/repositories.dart';
import 'package:flutter_application_ecommerce/core/storage/auth_storage.dart';

/// Implementación del repositorio de autenticación
class AuthRepositoryImpl implements AuthRepository {
  final AuthDataSource remoteDataSource;
  final AuthStorage authStorage;

  AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.authStorage,
  });

  @override
  Future<Either<Failure, UserEntity>> signIn({
    required SignInParams params,
  }) async {
    try {
      // Validación básica
      if (params.email.isEmpty || params.password.isEmpty) {
        return Left(ValidationFailure(message: AuthStrings.invalidCredentials));
      }

      final response = await remoteDataSource.signIn(params: params);

      // Intentar obtener el perfil completo del usuario
      try {
        final userData = await remoteDataSource.getProfile();

        // Guardar datos del usuario en almacenamiento local
        await _saveUserData(userData);

        return Right(userData);
      } catch (e) {
        // Si no se puede obtener el perfil, usar datos de la respuesta de login
        final UserModel user = UserModel.fromLoginResponse(
          response,
          params.email,
        );

        // Guardar datos del usuario en almacenamiento local
        await _saveUserData(user);

        return Right(user);
      }
    } on ServerException catch (e) {
      AppLogger.logError('Login server error', e);
      return Left(ServerFailure(message: e.message));
    } on AuthenticationException catch (e) {
      AppLogger.logError('Login authentication error', e);
      return Left(AuthenticationFailure(message: e.message));
    } on NetworkException catch (e) {
      AppLogger.logError('Login network error', e);
      return Left(NetworkFailure(message: AuthStrings.networkError));
    } catch (e) {
      AppLogger.logError('Login unknown error', e);
      return Left(UnknownFailure(message: AuthStrings.unknownError));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> register({
    required RegisterParams params,
  }) async {
    try {
      // Validación básica
      if (params.email.isEmpty ||
          params.password.isEmpty ||
          params.firstName.isEmpty ||
          params.lastName.isEmpty) {
        return Left(ValidationFailure(message: AuthStrings.registrationError));
      }

      // Validación de seguridad de contraseña
      if (params.password.length < AuthUI.minPasswordLength) {
        return Left(
          ValidationFailure(
            message:
                'La contraseña debe tener al menos ${AuthUI.minPasswordLength} caracteres',
          ),
        );
      }

      final user = await remoteDataSource.register(params: params);

      // Guardar datos del usuario en almacenamiento local
      await _saveUserData(user);

      return Right(user);
    } on ServerException catch (e) {
      AppLogger.logError('Register server error', e);
      return Left(ServerFailure(message: e.message));
    } on AuthenticationException catch (e) {
      AppLogger.logError('Register authentication error', e);
      return Left(AuthenticationFailure(message: e.message));
    } on NetworkException catch (e) {
      AppLogger.logError('Register network error', e);
      return Left(NetworkFailure(message: AuthStrings.networkError));
    } catch (e) {
      AppLogger.logError('Register unknown error', e);
      return Left(UnknownFailure(message: AuthStrings.registrationError));
    }
  }

  @override
  Future<Either<Failure, void>> signOut() async {
    try {
      await remoteDataSource.signOut();

      // Limpiar datos del usuario del almacenamiento local
      await authStorage.clearAuth();

      return const Right(null);
    } on ServerException catch (e) {
      AppLogger.logError('Logout server error', e);
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      AppLogger.logError('Logout unknown error', e);
      // Intentar limpiar el almacenamiento local de todos modos
      try {
        await authStorage.clearAuth();
      } catch (_) {}

      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> isAuthenticated() async {
    try {
      final isLoggedIn = await authStorage.isLoggedIn();

      // Verificar también que exista un token válido
      if (isLoggedIn) {
        final token = await authStorage.getAccessToken();
        return Right(token != null && token.isNotEmpty);
      }

      return Right(false);
    } catch (e) {
      AppLogger.logError('Authentication check error', e);
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> getCurrentUser() async {
    try {
      // Verificar autenticación
      final authResult = await isAuthenticated();
      final bool isAuth = authResult.fold(
        (failure) => false,
        (isAuthenticated) => isAuthenticated,
      );

      if (!isAuth) {
        return Left(AuthenticationFailure(message: 'Usuario no autenticado'));
      }

      // Intentar obtener usuario del almacenamiento local
      final localUser = await authStorage.getUserData();
      if (localUser != null) {
        return Right(localUser);
      }

      // Si no hay usuario en almacenamiento local, intentar obtenerlo de la API
      try {
        final userData = await remoteDataSource.getProfile();
        // Guardar en almacenamiento local para futuras consultas
        await _saveUserData(userData);
        return Right(userData);
      } catch (e) {
        AppLogger.logError('Get user profile error', e);
        return Left(
          AuthenticationFailure(
            message: 'No se pudo obtener el perfil del usuario',
          ),
        );
      }
    } catch (e) {
      AppLogger.logError('Get current user error', e);
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  /// Guarda los datos del usuario en el almacenamiento local
  Future<void> _saveUserData(UserModel user) async {
    try {
      if (user.accessToken != null && user.refreshToken != null) {
        await authStorage.saveTokens(
          accessToken: user.accessToken!,
          refreshToken: user.refreshToken!,
        );
      }

      await authStorage.saveUserData(user);
    } catch (e) {
      // Solo log, no interrumpir el flujo principal
      AppLogger.logError('Error saving user data', e);
    }
  }
}
