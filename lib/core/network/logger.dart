import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

/// Clase para manejar el logging de manera consistente en toda la aplicación.
class AppLogger {
  static final _logger = Logger(
    printer: PrettyPrinter(
      methodCount: 0,
      errorMethodCount: 5,
      lineLength: 120,
      colors: true,
      printEmojis: true,
      dateTimeFormat: DateTimeFormat.onlyTimeAndSinceStart,
    ),
  );

  /// Log de errores de red
  static void logNetworkError(DioException error) {
    if (kDebugMode) {
      final errorDetails = {
        'URL': error.requestOptions.uri.toString(),
        'Method': error.requestOptions.method,
        'Status Code': error.response?.statusCode,
        'Message': error.message,
        'Response Data': error.response?.data,
      };
      _logger.e(
        '🌐 Network Error:',
        error: errorDetails,
        stackTrace: error.stackTrace,
      );
    }
  }

  /// Log de errores de servidor
  static void logServerError(Response response) {
    if (kDebugMode) {
      final serverErrorDetails = {
        'URL': response.requestOptions.uri.toString(),
        'Method': response.requestOptions.method,
        'Status Code': response.statusCode,
        'Response Data': response.data,
      };
      _logger.e('🔴 Server Error:', error: serverErrorDetails);
    }
  }

  /// Log de errores de validación
  static void logValidationError(Map<String, dynamic> errors) {
    if (kDebugMode) {
      _logger.w('⚠️ Validation Error:', error: errors);
    }
  }

  /// Log de errores generales
  static void logError(
    String message, [
    dynamic error,
    StackTrace? stackTrace,
  ]) {
    if (kDebugMode) {
      _logger.e('❌ Error: $message', error: error, stackTrace: stackTrace);
    }
  }

  /// Log de información
  static void logInfo(String message) {
    if (kDebugMode) {
      _logger.i('ℹ️ Info: $message');
    }
  }

  /// Log de éxito
  static void logSuccess(String message) {
    if (kDebugMode) {
      _logger.i('✅ Success: $message');
    }
  }

  /// Log de advertencia
  static void logWarning(String message) {
    if (kDebugMode) {
      _logger.w('⚠️ Warning: $message');
    }
  }
}
