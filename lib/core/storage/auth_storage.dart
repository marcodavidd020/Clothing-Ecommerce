import 'package:flutter_application_ecommerce/features/auth/data/models/user_model.dart';
import 'storage_service.dart';

/// Claves para almacenar datos de autenticación
class AuthStorageKeys {
  static const String accessToken = 'auth_access_token';
  static const String refreshToken = 'auth_refresh_token';
  static const String userId = 'auth_user_id';
  static const String userEmail = 'auth_user_email';
  static const String firstName = 'auth_user_first_name';
  static const String lastName = 'auth_user_last_name';
  static const String isLoggedIn = 'auth_is_logged_in';
  static const String avatar = 'auth_user_avatar';
}

/// Servicio para manejar el almacenamiento de datos de autenticación
class AuthStorage {
  final StorageService _storage;

  AuthStorage(this._storage);

  /// Guarda los tokens de autenticación
  Future<void> saveTokens({
    required String accessToken,
    required String refreshToken,
  }) async {
    await _storage.setString(AuthStorageKeys.accessToken, accessToken);
    await _storage.setString(AuthStorageKeys.refreshToken, refreshToken);
  }

  /// Obtiene el token de acceso
  Future<String?> getAccessToken() async {
    return await _storage.getString(AuthStorageKeys.accessToken);
  }

  /// Obtiene el token de refresco
  Future<String?> getRefreshToken() async {
    return await _storage.getString(AuthStorageKeys.refreshToken);
  }

  /// Guarda los datos del usuario
  Future<void> saveUserData(UserModel user) async {
    await _storage.setString(AuthStorageKeys.userId, user.id);
    await _storage.setString(AuthStorageKeys.userEmail, user.email);

    if (user.firstName != null) {
      await _storage.setString(AuthStorageKeys.firstName, user.firstName!);
    }

    if (user.lastName != null) {
      await _storage.setString(AuthStorageKeys.lastName, user.lastName!);
    }

    if (user.avatar != null) {
      await _storage.setString(AuthStorageKeys.avatar, user.avatar!);
    }

    await _storage.setBool(AuthStorageKeys.isLoggedIn, true);
  }

  /// Obtiene un modelo del usuario almacenado
  Future<UserModel?> getUserData() async {
    final id = await _storage.getString(AuthStorageKeys.userId);
    final email = await _storage.getString(AuthStorageKeys.userEmail);

    if (id == null || email == null) return null;

    final firstName = await _storage.getString(AuthStorageKeys.firstName);
    final lastName = await _storage.getString(AuthStorageKeys.lastName);
    final avatar = await _storage.getString(AuthStorageKeys.avatar);
    final accessToken = await getAccessToken();
    final refreshToken = await getRefreshToken();

    return UserModel(
      id: id,
      email: email,
      firstName: firstName,
      lastName: lastName,
      avatar: avatar,
      accessToken: accessToken,
      refreshToken: refreshToken,
      isActive: true,
    );
  }

  /// Verifica si el usuario está logueado
  Future<bool> isLoggedIn() async {
    return await _storage.getBool(
      AuthStorageKeys.isLoggedIn,
      defaultValue: false,
    );
  }

  /// Limpia todos los datos de autenticación
  Future<void> clearAuth() async {
    await _storage.remove(AuthStorageKeys.accessToken);
    await _storage.remove(AuthStorageKeys.refreshToken);
    await _storage.remove(AuthStorageKeys.userId);
    await _storage.remove(AuthStorageKeys.userEmail);
    await _storage.remove(AuthStorageKeys.firstName);
    await _storage.remove(AuthStorageKeys.lastName);
    await _storage.remove(AuthStorageKeys.avatar);
    await _storage.setBool(AuthStorageKeys.isLoggedIn, false);
  }
}
