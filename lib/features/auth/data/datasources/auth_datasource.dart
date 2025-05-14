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
