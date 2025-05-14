import 'package:flutter_application_ecommerce/core/constants/api_constants.dart';
import 'package:flutter_application_ecommerce/core/error/exceptions.dart';
import 'package:flutter_application_ecommerce/core/network/dio_client.dart';
import 'package:flutter_application_ecommerce/features/auth/data/models/models.dart';
import 'package:flutter_application_ecommerce/core/error/error_handler.dart';
import 'package:flutter_application_ecommerce/core/network/logger.dart';
import 'package:flutter_application_ecommerce/core/network/response_handler.dart';
import 'package:flutter_application_ecommerce/core/storage/auth_storage.dart';

/// Define los métodos para acceder a los datos de autenticación
abstract class AuthDataSource {
  /// Intenta iniciar sesión.
  /// Devuelve un `Map<String, dynamic>` que representa el JSON de respuesta para la simulación.
  Future<Map<String, dynamic>> signIn({required SignInParams params});

  /// Intenta registrar un nuevo usuario.
  Future<UserModel> register({required RegisterParams params});

  /// Intenta cerrar la sesión.
  Future<void> signOut();

  /// Obtiene el perfil del usuario autenticado.
  Future<UserModel> getProfile();
}

/// Implementación de la fuente de datos de autenticación que se comunica con la API real
class AuthRemoteDataSource implements AuthDataSource {
  final DioClient dioClient;
  final AuthStorage? authStorage;

  AuthRemoteDataSource({required this.dioClient, this.authStorage});

  @override
  Future<Map<String, dynamic>> signIn({required SignInParams params}) async {
    try {
      final response = await dioClient.post(
        ApiConstants.loginEndpoint,
        data: params.toJson(),
      );

      if (ResponseHandler.isSuccessfulResponse(response)) {
        final result = response.data as Map<String, dynamic>;

        // Extraer tokens de la respuesta
        if (authStorage != null && result['data'] != null) {
          final data = result['data'] as Map<String, dynamic>;
          final accessToken = data['accessToken'] as String?;
          final refreshToken = data['refreshToken'] as String?;

          if (accessToken != null && refreshToken != null) {
            // Guardar tokens
            await authStorage!.saveTokens(
              accessToken: accessToken,
              refreshToken: refreshToken,
            );

            // Obtener perfil del usuario y guardarlo
            try {
              final userProfile = await getProfile();
              await authStorage!.saveUserData(userProfile);
              AppLogger.logSuccess('Datos de usuario guardados localmente');
            } catch (e) {
              AppLogger.logError('Error al obtener perfil: ${e.toString()}');
            }
          }
        }

        return result;
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

        // Si hay tokens en la respuesta, guardarlos
        if (authStorage != null &&
            userData.accessToken != null &&
            userData.refreshToken != null) {
          await authStorage!.saveTokens(
            accessToken: userData.accessToken!,
            refreshToken: userData.refreshToken!,
          );
          await authStorage!.saveUserData(userData);
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
      // Limpiar datos locales
      if (authStorage != null) {
        await authStorage!.clearAuth();
      }

      // En una implementación real, llamaríamos a un endpoint de logout
      await Future.delayed(const Duration(milliseconds: 500));

      AppLogger.logSuccess('Sesión cerrada correctamente');
    } catch (e) {
      AppLogger.logError('Error en signOut', e);
      throw ErrorHandler.handleError(e, 'signOut');
    }
  }

  @override
  Future<UserModel> getProfile() async {
    try {
      final response = await dioClient.get(ApiConstants.profileEndpoint);

      if (ResponseHandler.isSuccessfulResponse(response)) {
        final data = response.data as Map<String, dynamic>;
        if (data['data'] == null) {
          throw ServerException(
            message: 'Error al obtener el perfil: Datos no encontrados',
            statusCode: response.statusCode ?? 400,
          );
        }

        final userData = UserModel.fromJson(
          data['data'] as Map<String, dynamic>,
        );

        // Si hay un authStorage, guardar los datos del usuario
        if (authStorage != null) {
          await authStorage!.saveUserData(userData);
        }

        AppLogger.logSuccess('Perfil obtenido exitosamente: ${userData.email}');
        return userData;
      }

      throw ServerException(
        message: ResponseHandler.extractErrorMessage(response),
        statusCode: response.statusCode,
      );
    } catch (e) {
      AppLogger.logError('Error al obtener el perfil', e);
      throw ErrorHandler.handleError(e, 'getProfile');
    }
  }
}
