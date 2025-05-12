import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:http/http.dart' as http;

abstract class NetworkInfo {
  Future<bool> get isConnected;
}

class NetworkInfoImpl implements NetworkInfo {
  final InternetConnectionChecker connectionChecker;
  final Connectivity connectivity;

  NetworkInfoImpl(this.connectionChecker) : connectivity = Connectivity();

  @override
  Future<bool> get isConnected async {
    try {
      // Primero verificamos si hay una conexión de red activa
      var connectivityResult = await connectivity.checkConnectivity();
      if (connectivityResult == ConnectivityResult.none) {
        return false;
      }

      // Si hay una conexión de red, intentamos una petición real para verificar internet
      try {
        final response = await http
            .get(Uri.parse('https://pokeapi.co/api/v2/pokemon/1'))
            .timeout(const Duration(seconds: 3));

        // Si la petición fue exitosa, definitivamente hay internet
        if (response.statusCode >= 200 && response.statusCode < 300) {
          return true;
        }
      } catch (_) {
        // Si la petición falló, verificamos con connectionChecker como plan B
        return await connectionChecker.hasConnection;
      }

      // Si la prueba con http no fue concluyente, volvemos al verificador original
      return await connectionChecker.hasConnection;
    } catch (_) {
      // En caso de error en la verificación, asumimos que hay internet
      // para evitar falsos negativos (mejor permitir que la petición falle
      // que bloquearla prematuramente)
      return true;
    }
  }
}
