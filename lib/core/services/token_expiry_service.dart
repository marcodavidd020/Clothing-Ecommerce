import 'dart:async';

/// Servicio para manejar la notificación de token expirado
class TokenExpiryService {
  static final TokenExpiryService _instance = TokenExpiryService._internal();
  factory TokenExpiryService() => _instance;
  TokenExpiryService._internal();

  final StreamController<bool> _tokenExpiredController =
      StreamController<bool>.broadcast();

  /// Stream que emite cuando el token expira
  Stream<bool> get tokenExpiredStream => _tokenExpiredController.stream;

  /// Notifica que el token ha expirado
  void notifyTokenExpired() {
    if (!_tokenExpiredController.isClosed) {
      _tokenExpiredController.add(true);
    }
  }

  /// Cierra el stream
  void dispose() {
    _tokenExpiredController.close();
  }
} 