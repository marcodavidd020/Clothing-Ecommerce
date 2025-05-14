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

  @override
  Future<Map<String, dynamic>> signIn({required SignInParams params}) async {
    try {
      final response = await dioClient.post(
        ApiConstants.loginEndpoint,
        data: params.toJson(),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return response.data as Map<String, dynamic>;
      } else {
        if (response.data is Map<String, dynamic>) {
          throw ServerException(
            (response.data as Map<String, dynamic>)['message'] ??
                'Error en el servidor (status: ${response.statusCode})',
          );
        }
        throw ServerException(
          'Error en el servidor (status: ${response.statusCode})',
        );
      }
    } on DioException catch (e) {
      print('[AuthRemoteDataSource] DioException: ${e.message}');
      print(
        '[AuthRemoteDataSource] DioException response data: ${e.response?.data}',
      );
      print(
        '[AuthRemoteDataSource] DioException response status code: ${e.response?.statusCode}',
      );
      if (e.response?.data is Map<String, dynamic>) {
        final errorData = e.response!.data as Map<String, dynamic>;
        print('[AuthRemoteDataSource] Parsed errorData: $errorData');
        if (errorData.containsKey('message')) {
          if (errorData.containsKey('errors') &&
              errorData.containsKey('statusCode')) {
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
            errorData['message'] as String? ??
                'Error de red en signIn: ${e.message}',
          );
        }
      }
      throw ServerException('Error de red en signIn: ${e.message}');
    } catch (e) {
      if (e is ServerException || e is AuthenticationException) rethrow;
      throw ServerException('Error inesperado en signIn: ${e.toString()}');
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

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (responseData != null &&
            responseData['success'] == true &&
            responseData['data'] != null) {
          return UserModel.fromJson(responseData['data']);
        } else {
          if (responseData != null && responseData.containsKey('message')) {
            if (responseData.containsKey('errors') &&
                responseData.containsKey('statusCode')) {
              throw AuthenticationException(
                message: responseData['message'] as String,
                statusCode: responseData['statusCode'] as int,
                errors:
                    (responseData['errors'] as List)
                        .map((e) => e as Map<String, dynamic>)
                        .toList(),
              );
            }
            throw ServerException(
              responseData['message'] as String? ?? 'Error en el registro',
            );
          }
          throw ServerException('Error en el registro: Respuesta inesperada.');
        }
      } else {
        if (responseData != null && responseData.containsKey('message')) {
          if (responseData.containsKey('errors') &&
              responseData.containsKey('statusCode')) {
            throw AuthenticationException(
              message: responseData['message'] as String,
              statusCode: responseData['statusCode'] as int,
              errors:
                  (responseData['errors'] as List)
                      .map((e) => e as Map<String, dynamic>)
                      .toList(),
            );
          }
          throw ServerException(
            responseData['message'] as String? ??
                'Error en el servidor (status: ${response.statusCode})',
          );
        }
        throw ServerException(
          'Error en el registro (status: ${response.statusCode})',
        );
      }
    } on DioException catch (e) {
      print('[AuthRemoteDataSource REGISTER] DioException: ${e.message}');
      print(
        '[AuthRemoteDataSource REGISTER] DioException response data: ${e.response?.data}',
      );
      print(
        '[AuthRemoteDataSource REGISTER] DioException response data TYPE: ${e.response?.data.runtimeType}',
      );
      print(
        '[AuthRemoteDataSource REGISTER] DioException response status code: ${e.response?.statusCode}',
      );
      if (e.response?.data is Map<String, dynamic>) {
        final errorData = e.response!.data as Map<String, dynamic>;
        print('[AuthRemoteDataSource REGISTER] Parsed errorData: $errorData');
        if (errorData.containsKey('message')) {
          if (errorData.containsKey('errors') &&
              errorData.containsKey('statusCode')) {
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
            errorData['message'] as String? ??
                'Error de red en registro: ${e.message}',
          );
        }
      }
      String errorMessage = 'Error de red en registro.';
      if (e.message != null && e.message!.isNotEmpty) {
        errorMessage += ' Detalles: ${e.message}';
      } else if (e.response?.statusMessage != null &&
          e.response!.statusMessage!.isNotEmpty) {
        errorMessage += ' Status: ${e.response!.statusMessage}';
      }
      throw ServerException(errorMessage);
    } catch (e) {
      if (e is ServerException || e is AuthenticationException) rethrow;
      throw ServerException('Error inesperado en register: ${e.toString()}');
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await Future.delayed(const Duration(milliseconds: 500));
    } catch (e) {
      throw ServerException('Error al cerrar sesión: ${e.toString()}');
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
    } else {
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
  }

  @override
  Future<UserModel> register({required RegisterParams params}) async {
    await Future.delayed(const Duration(seconds: 1));
    if (params.email.isNotEmpty && params.password.length >= 6) {
      final newUser = UserModel(
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
      return newUser;
    } else {
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
  }

  @override
  Future<void> signOut() async {
    await Future.delayed(const Duration(seconds: 1));
    print('Simulando cierre de sesión desde AuthLocalDataSource');
  }
}
