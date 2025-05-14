class ApiConstants {
  static const String baseUrl = 'http://192.168.0.202:3000/api';

  // Auth endpoints
  static const String loginEndpoint = '$baseUrl/auth/login';
  static const String registerClientEndpoint = '$baseUrl/auth/register/client';
  static const String profileEndpoint = '$baseUrl/auth/profile';

  static const int connectTimeout = 15000;
  static const int receiveTimeout = 15000;
  static const Map<String, String> headers = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };
}
