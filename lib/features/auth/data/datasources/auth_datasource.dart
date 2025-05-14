import 'package:flutter_application_ecommerce/core/constants/api_constants.dart';
import 'package:flutter_application_ecommerce/core/error/exceptions.dart';
import 'package:flutter_application_ecommerce/core/network/dio_client.dart';
import 'package:flutter_application_ecommerce/features/auth/data/models/models.dart';
import 'package:flutter_application_ecommerce/core/error/error_handler.dart';
import 'package:flutter_application_ecommerce/core/network/logger.dart';
import 'package:flutter_application_ecommerce/core/network/response_handler.dart';

/// Define los métodos para acceder a los datos de autenticación
abstract class AuthDataSource {
  /// Intenta iniciar sesión.
  /// Devuelve un `Map<String, dynamic>` que representa el JSON de respuesta para la simulación.
  Future<Map<String, dynamic>> signIn({required SignInParams params});

  /// Intenta registrar un nuevo usuario.
  Future<UserModel> register({required RegisterParams params});

  /// Intenta cerrar la sesión.
  Future<void> signOut();
}

/// Implementación de la fuente de datos de autenticación que se comunica con la API real
class AuthRemoteDataSource implements AuthDataSource {
  final DioClient dioClient;

  AuthRemoteDataSource({required this.dioClient});

  @override
  Future<Map<String, dynamic>> signIn({required SignInParams params}) async {
    try {
      final response = await dioClient.post(
        ApiConstants.loginEndpoint,
        data: params.toJson(),
      );

      if (ResponseHandler.isSuccessfulResponse(response)) {
        return response.data as Map<String, dynamic>;
      }

      throw ServerException(
        message: ResponseHandler.extractErrorMessage(response),
        statusCode: response.statusCode,
      );
    } catch (e) {
      AppLogger.logError('Error en signIn', e);
      throw ErrorHandler.handleError(e, 'signIn');
    }
  }

  @override
  Future<UserModel> register({required RegisterParams params}) async {
    try {
      final response = await dioClient.post(
        ApiConstants.registerClientEndpoint,
        data: params.toJson(),
      );

      if (ResponseHandler.isSuccessfulResponse(response)) {
        final userData = ResponseHandler.extractData<UserModel>(
          response,
          (json) => UserModel.fromJson(json),
        );

        if (userData == null) {
          throw ServerException(
            message: 'Error en el registro: Respuesta inesperada.',
            statusCode: response.statusCode,
          );
        }

        return userData;
      }

      throw ServerException(
        message: ResponseHandler.extractErrorMessage(response),
        statusCode: response.statusCode,
      );
    } catch (e) {
      AppLogger.logError('Error en register', e);
      throw ErrorHandler.handleError(e, 'register');
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await Future.delayed(const Duration(milliseconds: 500));
    } catch (e) {
      AppLogger.logError('Error en signOut', e);
      throw ErrorHandler.handleError(e, 'signOut');
    }
  }
}

/// Implementación simulada de la fuente de datos de autenticación (temporal para desarrollo)
class AuthLocalDataSource implements AuthDataSource {
  @override
  Future<Map<String, dynamic>> signIn({required SignInParams params}) async {
    await Future.delayed(const Duration(seconds: 1));

    if (params.email == 'usuario@ejemplo.com' &&
        params.password == 'contraseña123') {
      return {
        "success": true,
        "message": "Inicio de sesión exitoso",
        "data": {
          "accessToken": "fake_access_token",
          "refreshToken": "fake_refresh_token",
        },
        "timestamp": DateTime.now().toIso8601String(),
      };
    }

    throw AuthenticationException(
      message: 'Credenciales inválidas',
      statusCode: 401,
      errors: [
        {
          "field": "general",
          "errors": ["El email o la contraseña son incorrectos"],
          "value": null,
        },
      ],
    );
  }

  @override
  Future<UserModel> register({required RegisterParams params}) async {
    await Future.delayed(const Duration(seconds: 1));

    if (params.email.isNotEmpty && params.password.length >= 6) {
      return UserModel(
        id: 'user_${DateTime.now().millisecondsSinceEpoch}',
        email: params.email,
        firstName: params.firstName,
        lastName: params.lastName,
        phoneNumber: params.phone,
        isActive: true,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        accessToken:
            "fake_reg_access_token_${DateTime.now().millisecondsSinceEpoch}",
        refreshToken:
            "fake_reg_refresh_token_${DateTime.now().millisecondsSinceEpoch}",
      );
    }

    throw AuthenticationException(
      message: 'Datos de registro inválidos',
      statusCode: 400,
      errors: [
        {
          "field": "password",
          "errors": ["La contraseña debe tener al menos 6 caracteres"],
          "value": params.password,
        },
      ],
    );
  }

  @override
  Future<void> signOut() async {
    await Future.delayed(const Duration(seconds: 1));
    AppLogger.logInfo('Simulando cierre de sesión desde AuthLocalDataSource');
  }
}
