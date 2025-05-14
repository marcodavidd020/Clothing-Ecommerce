import 'package:dio/dio.dart';
import 'package:flutter_application_ecommerce/core/constants/api_constants.dart';
import 'package:flutter_application_ecommerce/core/error/exceptions.dart';
import 'package:flutter_application_ecommerce/core/network/dio_client.dart';
import 'package:flutter_application_ecommerce/features/auth/data/models/models.dart';

/// Define los métodos para acceder a los datos de autenticación
abstract class AuthDataSource {
  /// Intenta iniciar sesión.
  /// Devuelve un Map<String, dynamic> que representa el JSON de respuesta para la simulación.
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

  /// Maneja las excepciones de red y servidor de manera consistente
  Never _handleError(dynamic error, String operation) {
    if (error is DioException) {
      _logDioError(error, operation);
      final errorData = error.response?.data;

      if (errorData is Map<String, dynamic>) {
        if (_isAuthenticationError(errorData)) {
          throw AuthenticationException(
            message: errorData['message'] as String,
            statusCode: errorData['statusCode'] as int,
            errors:
                (errorData['errors'] as List)
                    .map((err) => err as Map<String, dynamic>)
                    .toList(),
          );
        }
        throw ServerException(
          message: errorData['message'] as String? ??
              'Error de red en $operation: ${error.message}',
        );
      }
      throw ServerException(
        message: _getNetworkErrorMessage(error, operation),
      );
    }

    if (error is ServerException || error is AuthenticationException) {
      throw error;
    }

    throw ServerException(
      message: 'Error inesperado en $operation: ${error.toString()}',
    );
  }

  /// Verifica si el error es de autenticación
  bool _isAuthenticationError(Map<String, dynamic> errorData) {
    return errorData.containsKey('message') &&
        errorData.containsKey('errors') &&
        errorData.containsKey('statusCode');
  }

  /// Obtiene un mensaje de error de red formateado
  String _getNetworkErrorMessage(DioException error, String operation) {
    String errorMessage = 'Error de red en $operation.';
    if (error.message?.isNotEmpty == true) {
      errorMessage += ' Detalles: ${error.message}';
    } else if (error.response?.statusMessage?.isNotEmpty == true) {
      errorMessage += ' Status: ${error.response!.statusMessage}';
    }
    return errorMessage;
  }

  /// Registra información detallada del error de Dio
  void _logDioError(DioException error, String operation) {
    print('[$operation] DioException: ${error.message}');
    print('[$operation] Response data: ${error.response?.data}');
    print('[$operation] Response status code: ${error.response?.statusCode}');
    if (error.response?.data is Map<String, dynamic>) {
      print('[$operation] Parsed errorData: ${error.response?.data}');
    }
  }

  /// Verifica si la respuesta es exitosa
  bool _isSuccessfulResponse(Response response) {
    return response.statusCode == 200 || response.statusCode == 201;
  }

  /// Extrae el mensaje de error de la respuesta
  String _extractErrorMessage(Response response) {
    if (response.data is Map<String, dynamic>) {
      return (response.data as Map<String, dynamic>)['message'] ??
          'Error en el servidor (status: ${response.statusCode})';
    }
    return 'Error en el servidor (status: ${response.statusCode})';
  }

  @override
  Future<Map<String, dynamic>> signIn({required SignInParams params}) async {
    try {
      final response = await dioClient.post(
        ApiConstants.loginEndpoint,
        data: params.toJson(),
      );

      if (_isSuccessfulResponse(response)) {
        return response.data as Map<String, dynamic>;
      }

      throw ServerException(
        message: _extractErrorMessage(response),
      );
    } catch (e) {
      _handleError(e, 'signIn');
    }
  }

  @override
  Future<UserModel> register({required RegisterParams params}) async {
    try {
      final response = await dioClient.post(
        ApiConstants.registerClientEndpoint,
        data: params.toJson(),
      );

      final responseData = response.data as Map<String, dynamic>?;

      if (_isSuccessfulResponse(response)) {
        if (responseData != null &&
            responseData['success'] == true &&
            responseData['data'] != null) {
          return UserModel.fromJson(responseData['data']);
        }
        throw ServerException(
          message: 'Error en el registro: Respuesta inesperada.',
        );
      }

      throw ServerException(
        message: _extractErrorMessage(response),
      );
    } catch (e) {
      _handleError(e, 'register');
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await Future.delayed(const Duration(milliseconds: 500));
    } catch (e) {
      _handleError(e, 'signOut');
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
    print('Simulando cierre de sesión desde AuthLocalDataSource');
  }
}
