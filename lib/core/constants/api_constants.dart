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
    AppLogger.logInfo(' - Products URL: $productsEndpoint');
    AppLogger.logInfo(' - Product by ID URL (ejemplo): ${getProductByIdEndpoint('example-id')}');
    AppLogger.logInfo(' - Products by Category URL (ejemplo): ${getProductsByCategoryEndpoint('example-id')}');
  }

  // Auth endpoints
  static const String loginEndpoint = '$baseUrl/auth/login';
  static const String registerClientEndpoint = '$baseUrl/auth/register/client';
  static const String profileEndpoint = '$baseUrl/auth/profile';

  // Category endpoints
  static const String categoriesEndpoint = '$baseUrl/categories';
  static const String categoriesTreeEndpoint = '$baseUrl/categories/tree';
  static String getCategoryByIdEndpoint(String id) => '$categoriesEndpoint/$id';

  // Product endpoints
  static const String productsEndpoint = '$baseUrl/products';
  static String getProductByIdEndpoint(String id) => '$productsEndpoint/$id';
  static String getProductsByCategoryEndpoint(String categoryId) => '$productsEndpoint/by-category/$categoryId';
  static String getPrdouctsBestSellersEndpoint(String categoryId) => '$productsEndpoint/best-sellers/by-category/$categoryId';
  static String getPrdouctsNewestEndpoint(String categoryId) => '$productsEndpoint/newest/by-category/$categoryId';

  static const int connectTimeout = 15000;
  static const int receiveTimeout = 15000;
  static const Map<String, String> headers = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };
}
