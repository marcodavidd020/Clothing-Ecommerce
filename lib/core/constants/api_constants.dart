class ApiConstants {
  static const String baseUrl = 'https://pokeapi.co/api/v2';
  static const String pokemonEndpoint = '/pokemon';
  static const String speciesEndpoint = '/pokemon-species';
  static const String evolutionChainEndpoint = '/evolution-chain';
  static const int connectTimeout = 15000;
  static const int receiveTimeout = 15000;
  static const Map<String, String> headers = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };
}
