import 'package:flutter_application_ecommerce/core/network/logger.dart';

class ApiConstants {
  // Usamos una IP local para desarrollo - ajustar según el entorno
  static const String baseUrl = 'http://192.168.0.202:3000/api';

  // Logs para verificar que la URL se está construyendo correctamente
  static void logEndpoints() {
    AppLogger.logInfo('API URLs configuradas:');
    AppLogger.logInfo(' - Base URL: $baseUrl');
    AppLogger.logInfo(' - Categories URL: $categoriesEndpoint');
    AppLogger.logInfo(' - Categories Tree URL: $categoriesTreeEndpoint');
    AppLogger.logInfo(' - Category by ID URL (ejemplo): ${getCategoryByIdEndpoint('example-id')}');
  }

  // Auth endpoints
  static const String loginEndpoint = '$baseUrl/auth/login';
  static const String registerClientEndpoint = '$baseUrl/auth/register/client';
  static const String profileEndpoint = '$baseUrl/auth/profile';

  // Category endpoints
  static const String categoriesEndpoint = '$baseUrl/categories';
  static const String categoriesTreeEndpoint = '$baseUrl/categories/tree';
  static String getCategoryByIdEndpoint(String id) => '$categoriesEndpoint/$id';

  static const int connectTimeout = 15000;
  static const int receiveTimeout = 15000;
  static const Map<String, String> headers = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };
}
