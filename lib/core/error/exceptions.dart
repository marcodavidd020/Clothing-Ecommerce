class ServerException implements Exception {
  final String? message;
  ServerException([this.message]);
}

class NetworkException implements Exception {
  final String? message;
  NetworkException([this.message]);
}

class CacheException implements Exception {
  final String? message;
  CacheException([this.message]);
}

class UnknownException implements Exception {
  final String message;

  UnknownException({required this.message});
}

/// Excepción específica para errores de autenticación
class AuthenticationException implements Exception {
  final String message;
  final int? statusCode;
  final List<Map<String, dynamic>>? errors;

  AuthenticationException({
    required this.message,
    this.statusCode,
    this.errors,
  });

  @override
  String toString() {
    return 'AuthenticationException: $message (Status Code: $statusCode)';
  }
}
