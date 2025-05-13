import 'package:flutter_application_ecommerce/core/error/exceptions.dart';
import 'package:flutter_application_ecommerce/features/auth/data/models/user_model.dart'; // Importar UserModel

/// Define los métodos para acceder a los datos de autenticación
abstract class AuthDataSource {
  /// Intenta iniciar sesión.
  Future<UserModel> signIn({required String email, required String password});

  /// Intenta registrar un nuevo usuario.
  Future<UserModel> register({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
  });

  /// Intenta cerrar la sesión.
  Future<void> signOut();
}

/// Implementación simulada de la fuente de datos de autenticación
class AuthLocalDataSource implements AuthDataSource {
  // Simula una base de datos local o API con un usuario de ejemplo
  final UserModel _simulatedUser = UserModel(
    id: 'user123',
    email: 'test@example.com',
  );
  final String _simulatedPassword = 'password';

  @override
  Future<UserModel> signIn({
    required String email,
    required String password,
  }) async {
    // Simular retraso de red
    await Future.delayed(const Duration(seconds: 1));

    // Simular lógica de inicio de sesión
    if (email == _simulatedUser.email && password == _simulatedPassword) {
      return _simulatedUser; // Éxito
    } else {
      throw AuthenticationException(
        message: 'Credenciales inválidas',
      ); // Error simulado
    }
  }

  @override
  Future<UserModel> register({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
  }) async {
    // Simular retraso de red
    await Future.delayed(const Duration(seconds: 1));

    // Simular lógica de registro (ejemplo simple: cualquier email no vacío y password >= 6 es válido)
    if (email.isNotEmpty && password.length >= 6) {
      // Simular la creación de un nuevo usuario (usamos el email como parte del ID simple)
      final newUser = UserModel(id: 'user_${email.hashCode}', email: email);
      return newUser; // Éxito
    } else {
      throw AuthenticationException(
        message: 'Datos de registro inválidos',
      ); // Error simulado
    }
  }

  @override
  Future<void> signOut() async {
    // Simular retraso de red
    await Future.delayed(const Duration(seconds: 1));

    // Simular lógica de cierre de sesión (ej. limpiar token)
    print('Simulando cierre de sesión');
    // No se retorna nada en caso de éxito
  }
}
