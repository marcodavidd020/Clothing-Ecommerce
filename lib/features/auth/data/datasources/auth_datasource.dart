import 'package:flutter_application_ecommerce/core/constants/api_constants.dart';
import 'package:flutter_application_ecommerce/core/error/exceptions.dart';
import 'package:flutter_application_ecommerce/core/network/dio_client.dart';
import 'package:flutter_application_ecommerce/features/auth/data/models/user_model.dart';

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
    String? phone,
  });

  /// Intenta cerrar la sesión.
  Future<void> signOut();
}

/// Implementación de la fuente de datos de autenticación que se comunica con la API real
class AuthRemoteDataSource implements AuthDataSource {
  final DioClient dioClient;

  AuthRemoteDataSource({required this.dioClient});

  @override
  Future<UserModel> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final response = await dioClient.post(
        '/api/auth/login',
        data: {'email': email, 'password': password},
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = response.data;
        if (data['success'] == true && data['data'] != null) {
          return UserModel.fromJson(data['data']);
        } else {
          throw ServerException(
            message: data['message'] ?? 'Error al iniciar sesión',
            statusCode: response.statusCode,
          );
        }
      } else {
        throw ServerException(
          message: 'Error al iniciar sesión',
          statusCode: response.statusCode,
        );
      }
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<UserModel> register({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
    String? phone,
  }) async {
    try {
      final data = {
        'email': email,
        'firstName': firstName,
        'lastName': lastName,
        'password': password,
      };

      // Añadir teléfono solo si se proporciona
      if (phone != null && phone.isNotEmpty) {
        data['phone'] = phone;
      }

      final response = await dioClient.post(
        ApiConstants.registerClientEndpoint,
        data: data,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseData = response.data;
        if (responseData['success'] == true && responseData['data'] != null) {
          return UserModel.fromJson(responseData['data']);
        } else {
          throw ServerException(
            message: responseData['message'] ?? 'Error en el registro',
            statusCode: response.statusCode,
          );
        }
      } else {
        throw ServerException(
          message: 'Error en el registro',
          statusCode: response.statusCode,
        );
      }
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<void> signOut() async {
    // Implementación futura para cerrar sesión con la API
    try {
      // Aquí iría la llamada a la API para cerrar sesión
      await Future.delayed(const Duration(milliseconds: 500));
    } catch (e) {
      throw ServerException(message: 'Error al cerrar sesión');
    }
  }
}

/// Implementación simulada de la fuente de datos de autenticación (temporal para desarrollo)
class AuthLocalDataSource implements AuthDataSource {
  // Simula una base de datos local o API con un usuario de ejemplo
  final UserModel _simulatedUser = UserModel(
    id: 'user123',
    email: 'test@example.com',
    firstName: 'Usuario',
    lastName: 'Simulado',
    isActive: true,
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
    String? phone,
  }) async {
    // Simular retraso de red
    await Future.delayed(const Duration(seconds: 1));

    // Simular lógica de registro (ejemplo simple: cualquier email no vacío y password >= 6 es válido)
    if (email.isNotEmpty && password.length >= 6) {
      // Simular la creación de un nuevo usuario
      final newUser = UserModel(
        id: 'user_${DateTime.now().millisecondsSinceEpoch}',
        email: email,
        firstName: firstName,
        lastName: lastName,
        phoneNumber: phone,
        isActive: true,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
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
