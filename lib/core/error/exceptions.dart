/// Clase base para todas las excepciones de la aplicación.
abstract class AppException implements Exception {
  final String message;
  final int? statusCode;
  final dynamic data;

  const AppException({required this.message, this.statusCode, this.data});

  @override
  String toString() =>
      '$runtimeType: $message${statusCode != null ? ' (Status Code: $statusCode)' : ''}';
}

/// Excepción para errores del servidor.
class ServerException extends AppException {
  const ServerException({required super.message, super.statusCode, super.data});
}

/// Excepción para errores de red.
class NetworkException extends AppException {
  const NetworkException({
    required super.message,
    super.statusCode,
    super.data,
  });
}

/// Excepción para errores de caché.
class CacheException extends AppException {
  const CacheException({required super.message, super.statusCode, super.data});
}

/// Excepción para errores desconocidos.
class UnknownException extends AppException {
  const UnknownException({
    required super.message,
    super.statusCode,
    super.data,
  });
}

/// Excepción específica para errores de autenticación.
class AuthenticationException extends AppException {
  final List<Map<String, dynamic>>? errors;

  const AuthenticationException({
    required super.message,
    super.statusCode,
    this.errors,
    super.data,
  });

  @override
  String toString() {
    final base = super.toString();
    if (errors != null && errors!.isNotEmpty) {
      return '$base\nErrores: ${errors!.map((e) => e.toString()).join(', ')}';
    }
    return base;
  }
}

/// Excepción para errores de validación.
class ValidationException extends AppException {
  final Map<String, List<String>> fieldErrors;

  const ValidationException({
    required super.message,
    required this.fieldErrors,
    super.statusCode,
    super.data,
  });

  @override
  String toString() {
    final base = super.toString();
    if (fieldErrors.isNotEmpty) {
      return '$base\nErrores de validación: ${fieldErrors.toString()}';
    }
    return base;
  }
}

/// Excepción para errores de permisos.
class PermissionException extends AppException {
  const PermissionException({
    required super.message,
    super.statusCode,
    super.data,
  });
}

/// Excepción para errores de recursos no encontrados.
class NotFoundException extends AppException {
  const NotFoundException({
    required super.message,
    super.statusCode,
    super.data,
  });
}
