class ApiConstants {
  static const String baseUrl = 'http://192.168.0.202:3000';
  static const String pokemonEndpoint = '/pokemon';
  static const String speciesEndpoint = '/pokemon-species';
  static const String evolutionChainEndpoint = '/evolution-chain';
  
  // Auth endpoints
  static const String authEndpoint = '/api/auth';
  static const String registerClientEndpoint = '$authEndpoint/register/client';
  
  static const int connectTimeout = 15000;
  static const int receiveTimeout = 15000;
  static const Map<String, String> headers = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };
}
