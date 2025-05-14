import 'package:dio/dio.dart';
import 'package:flutter_application_ecommerce/core/error/exceptions.dart';
import 'package:flutter_application_ecommerce/core/network/logger.dart';

/// Clase para manejar errores de manera consistente en toda la aplicación.
class ErrorHandler {
  /// Maneja las excepciones de red y servidor de manera consistente
  static Never handleError(dynamic error, String operation) {
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
          message:
              errorData['message'] as String? ??
              'Error de red en $operation: ${error.message}',
        );
      }
      throw ServerException(message: _getNetworkErrorMessage(error, operation));
    }

    if (error is ServerException || error is AuthenticationException) {
      throw error;
    }

    throw ServerException(
      message: 'Error inesperado en $operation: ${error.toString()}',
    );
  }

  /// Verifica si el error es de autenticación
  static bool _isAuthenticationError(Map<String, dynamic> errorData) {
    return errorData.containsKey('message') &&
        errorData.containsKey('errors') &&
        errorData.containsKey('statusCode');
  }

  /// Obtiene un mensaje de error de red formateado
  static String _getNetworkErrorMessage(DioException error, String operation) {
    String errorMessage = 'Error de red en $operation.';
    if (error.message?.isNotEmpty == true) {
      errorMessage += ' Detalles: ${error.message}';
    } else if (error.response?.statusMessage?.isNotEmpty == true) {
      errorMessage += ' Status: ${error.response!.statusMessage}';
    }
    return errorMessage;
  }

  /// Registra información detallada del error de Dio
  static void _logDioError(DioException error, String operation) {
    AppLogger.logNetworkError(error);
  }
}
