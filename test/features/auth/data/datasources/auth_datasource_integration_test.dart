import 'package:flutter_application_ecommerce/core/error/exceptions.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_application_ecommerce/core/network/dio_client.dart';
import 'package:flutter_application_ecommerce/features/auth/data/datasources/auth_datasource.dart';
import 'package:flutter_application_ecommerce/features/auth/data/models/models.dart';
import 'package:flutter_application_ecommerce/core/network/logger.dart';
import 'package:dio/dio.dart';
import 'package:flutter_application_ecommerce/core/network/network_info.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

void main() {
  late AuthRemoteDataSource dataSource;
  late DioClient dioClient;

  setUp(() {
    final dio = Dio();
    final networkInfo = NetworkInfoImpl(
      InternetConnectionChecker.createInstance(),
    );
    dioClient = DioClient(dio: dio, networkInfo: networkInfo);
    dataSource = AuthRemoteDataSource(dioClient: dioClient);
  });

  group('AuthRemoteDataSource Integration Tests', () {
    test('should successfully sign in with real API', () async {
      // arrange
      final signInParams = SignInParams(
        email: 'marco@gmail.com',
        password: '12345678',
      );

      // act
      final result = await dataSource.signIn(params: signInParams);
      AppLogger.logInfo('Test response: $result');
      // assert
      expect(result, isA<Map<String, dynamic>>());
      expect(result['data'], isNotNull);
      expect(result['data']['accessToken'], isNotNull);
      expect(result['data']['refreshToken'], isNotNull);

      AppLogger.logSuccess('Login exitoso: ${result['message']}');
    });

    // * Test failed
    test('should fail to sign in with real API', () async {
      // arrange
      final signInParams = SignInParams(
        email: 'invalid@email.com',
        password: 'wrongpassword',
      );

      // act & assert
      expect(
        () => dataSource.signIn(params: signInParams),
        throwsA(isA<AuthenticationException>()),
      );

      AppLogger.logError('Login fallido: Credenciales inválidas');
    });

    test('should successfully register with real API', () async {
      // arrange
      final registerParams = RegisterParams(
        firstName: 'Test',
        lastName: 'User',
        email: 'test${DateTime.now().millisecondsSinceEpoch}@example.com',
        password: '12345678',
        phone: '1234567890',
      );

      // act
      final result = await dataSource.register(params: registerParams);

      // assert
      expect(result, isA<UserModel>());
      expect(result.email, equals(registerParams.email));
      expect(result.firstName, equals(registerParams.firstName));
      expect(result.lastName, equals(registerParams.lastName));

      AppLogger.logSuccess('Registro exitoso para: ${result.email}');
    });

    test('should fail to register with real API', () async {
      // arrange
      final registerParams = RegisterParams(
        firstName: 'Test',
        lastName: 'User',
        email: 'invalid@email.com', // Email inválido
        password: '123', // Contraseña muy corta
        phone: '123', // Teléfono inválido
      );

      // act & assert
      expect(
        () => dataSource.register(params: registerParams),
        throwsA(isA<ServerException>()),
      );

      AppLogger.logError('Registro fallido: Datos de registro inválidos');
    });

    test('should successfully get user profile', () async {
      // Primero hacemos login para obtener el token
      final signInParams = SignInParams(
        email: 'marco@gmail.com',
        password: '12345678',
      );

      await dataSource.signIn(params: signInParams);

      // Luego obtenemos el perfil
      final profile = await dataSource.getProfile();

      // assert
      expect(profile, isA<UserModel>());
      expect(profile.email, equals(signInParams.email));
      expect(profile.firstName, isNotNull);
      expect(profile.lastName, isNotNull);
      expect(profile.isActive, isTrue);

      AppLogger.logSuccess('Perfil obtenido exitosamente: ${profile.email}');
    });

    test('should fail to get profile without authentication', () async {
      // Crear una nueva instancia sin token
      final newDioClient = DioClient(
        dio: Dio(),
        networkInfo: NetworkInfoImpl(InternetConnectionChecker.createInstance()),
      );
      final newDataSource = AuthRemoteDataSource(dioClient: newDioClient);

      // act & assert
      expect(
        () => newDataSource.getProfile(),
        throwsA(isA<AuthenticationException>()),
      );

      AppLogger.logError('Error al obtener perfil: No autenticado');
    });
  });
}
