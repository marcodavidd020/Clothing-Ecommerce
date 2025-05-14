import 'package:dio/dio.dart';

/// Clase para manejar respuestas de la API de manera consistente.
class ResponseHandler {
  /// Verifica si la respuesta es exitosa
  static bool isSuccessfulResponse(Response response) {
    return response.statusCode == 200 || response.statusCode == 201;
  }

  /// Extrae el mensaje de error de la respuesta
  static String extractErrorMessage(Response response) {
    if (response.data is Map<String, dynamic>) {
      return (response.data as Map<String, dynamic>)['message'] ??
          'Error en el servidor (status: ${response.statusCode})';
    }
    return 'Error en el servidor (status: ${response.statusCode})';
  }

  /// Verifica si la respuesta contiene datos válidos
  static bool hasValidData(Response response) {
    if (response.data is Map<String, dynamic>) {
      final data = response.data as Map<String, dynamic>;
      return data['success'] == true && data['data'] != null;
    }
    return false;
  }

  /// Extrae los datos de la respuesta
  static T? extractData<T>(
    Response response,
    T Function(Map<String, dynamic>) fromJson,
  ) {
    if (hasValidData(response)) {
      final data = response.data as Map<String, dynamic>;
      return fromJson(data['data']);
    }
    return null;
  }
}
