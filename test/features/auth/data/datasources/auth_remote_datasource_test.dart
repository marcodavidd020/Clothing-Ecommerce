import 'package:flutter_application_ecommerce/core/constants/api_constants.dart';
import 'package:flutter_application_ecommerce/core/error/exceptions.dart';
import 'package:flutter_application_ecommerce/core/network/dio_client.dart';
import 'package:flutter_application_ecommerce/core/network/logger.dart';
import 'package:flutter_application_ecommerce/features/auth/data/datasources/auth_datasource.dart';
import 'package:flutter_application_ecommerce/features/auth/data/models/models.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:dio/dio.dart';

// Generar mocks con: flutter pub run build_runner build --delete-conflicting-outputs
@GenerateMocks([DioClient])
import 'auth_remote_datasource_test.mocks.dart';

void main() {
  late AuthRemoteDataSource dataSource;
  late MockDioClient mockDioClient;

  setUp(() {
    mockDioClient = MockDioClient();
    dataSource = AuthRemoteDataSource(dioClient: mockDioClient);
  });

  final tSignInParams = SignInParams(
    email: 'marco@gmail.com',
    password: '12345678',
  );
  final tRegisterParams = RegisterParams(
    firstName: 'Test',
    lastName: 'User',
    email: 'test@example.com',
    password: 'password',
    phone: '1234567890',
  );
  final tUserModel = UserModel(
    id: '1',
    email: 'test@example.com',
    firstName: 'Test',
    lastName: 'User',
  );
  final tUserJson = {
    'id': '1',
    'email': 'test@example.com',
    'firstName': 'Test',
    'lastName': 'User',
  };
  final tSignInSuccessResponse = {'userId': '1', 'token': 'test_token'};

  group('signIn', () {
    test(
      'should return Map<String, dynamic> when the response code is 200 or 201',
      () async {
        // arrange
        when(
          mockDioClient.post(
            ApiConstants.loginEndpoint,
            data: tSignInParams.toJson(),
          ),
        ).thenAnswer(
          (_) async => Response(
            data: tSignInSuccessResponse,
            statusCode: 200,
            requestOptions: RequestOptions(path: ApiConstants.loginEndpoint),
          ),
        );
        // act
        final result = await dataSource.signIn(params: tSignInParams);
        // assert
        expect(result, equals(tSignInSuccessResponse));
        verify(
          mockDioClient.post(
            ApiConstants.loginEndpoint,
            data: tSignInParams.toJson(),
          ),
        );
        verifyNoMoreInteractions(mockDioClient);
      },
    );

    test(
      'should successfully authenticate user and return valid response',
      () async {
        // arrange
        final successResponse = {
          'data': {
            'userId': '123',
            'accessToken': 'valid_token_123',
            'refreshToken': 'refresh_token_123',
          },
          'message': 'Login successful',
          'statusCode': 200,
        };

        when(
          mockDioClient.post(
            ApiConstants.loginEndpoint,
            data: tSignInParams.toJson(),
          ),
        ).thenAnswer(
          (_) async => Response(
            data: successResponse,
            statusCode: 200,
            requestOptions: RequestOptions(path: ApiConstants.loginEndpoint),
          ),
        );

        // act
        final result = await dataSource.signIn(params: tSignInParams);
        AppLogger.logInfo('Test response: $result');
        // assert
        expect(result, equals(successResponse));
        expect(result['data']['userId'], equals('123'));
        expect(result['data']['accessToken'], equals('valid_token_123'));
        expect(result['data']['refreshToken'], equals('refresh_token_123'));
        expect(result['message'], equals('Login successful'));
        expect(result['statusCode'], equals(200));

        verify(
          mockDioClient.post(
            ApiConstants.loginEndpoint,
            data: tSignInParams.toJson(),
          ),
        );
        AppLogger.logSuccess('result: ${result['message']}');
        verifyNoMoreInteractions(mockDioClient);
      },
    );

    test(
      'should throw a ServerException when the response code is not 200 or 201',
      () async {
        // arrange
        when(
          mockDioClient.post(
            ApiConstants.loginEndpoint,
            data: tSignInParams.toJson(),
          ),
        ).thenAnswer(
          (_) async => Response(
            data: {'message': 'Error'},
            statusCode: 400,
            requestOptions: RequestOptions(path: ApiConstants.loginEndpoint),
          ),
        );
        // act
        final call = dataSource.signIn(params: tSignInParams);
        // assert
        expect(() => call, throwsA(isA<ServerException>()));
        verify(
          mockDioClient.post(
            ApiConstants.loginEndpoint,
            data: tSignInParams.toJson(),
          ),
        );
        verifyNoMoreInteractions(mockDioClient);
      },
    );

    test(
      'should throw a ServerException when DioClient throws DioException',
      () async {
        // arrange
        when(
          mockDioClient.post(
            ApiConstants.loginEndpoint,
            data: tSignInParams.toJson(),
          ),
        ).thenThrow(
          DioException(
            requestOptions: RequestOptions(path: ApiConstants.loginEndpoint),
            message: 'Dio error',
          ),
        );
        // act
        final call = dataSource.signIn(params: tSignInParams);
        // assert
        // ErrorHandler.handleError es estático y complejo de mockear directamente sin refactorizar ErrorHandler.
        // Testeamos que se lance una ServerException, que es el comportamiento esperado de ErrorHandler.
        expect(() => call, throwsA(isA<ServerException>()));
        verify(
          mockDioClient.post(
            ApiConstants.loginEndpoint,
            data: tSignInParams.toJson(),
          ),
        );
        verifyNoMoreInteractions(mockDioClient);
      },
    );
  });

  group('register', () {
    test(
      'should return UserModel when the response code is 200 or 201 and data is valid',
      () async {
        // arrange
        when(
          mockDioClient.post(
            ApiConstants.registerClientEndpoint,
            data: tRegisterParams.toJson(),
          ),
        ).thenAnswer(
          (_) async => Response(
            data:
                tUserJson, // Simular que la API devuelve el usuario directamente
            statusCode: 201,
            requestOptions: RequestOptions(
              path: ApiConstants.registerClientEndpoint,
            ),
          ),
        );
        // act
        final result = await dataSource.register(params: tRegisterParams);
        // assert
        expect(result, equals(tUserModel));
        verify(
          mockDioClient.post(
            ApiConstants.registerClientEndpoint,
            data: tRegisterParams.toJson(),
          ),
        );
        verifyNoMoreInteractions(mockDioClient);
      },
    );

    test(
      'should throw ServerException when UserModel.fromJson fails or data is not as expected',
      () async {
        // arrange
        when(
          mockDioClient.post(
            ApiConstants.registerClientEndpoint,
            data: tRegisterParams.toJson(),
          ),
        ).thenAnswer(
          (_) async => Response(
            data: {
              'unexpected_data': 'value',
            }, // Datos que no corresponden a UserModel
            statusCode: 201,
            requestOptions: RequestOptions(
              path: ApiConstants.registerClientEndpoint,
            ),
          ),
        );
        // act
        final call = dataSource.register(params: tRegisterParams);
        // assert
        expect(() => call, throwsA(isA<ServerException>()));
        verify(
          mockDioClient.post(
            ApiConstants.registerClientEndpoint,
            data: tRegisterParams.toJson(),
          ),
        );
        verifyNoMoreInteractions(mockDioClient);
      },
    );

    test(
      'should throw a ServerException when the response code is not 200 or 201',
      () async {
        // arrange
        when(
          mockDioClient.post(
            ApiConstants.registerClientEndpoint,
            data: tRegisterParams.toJson(),
          ),
        ).thenAnswer(
          (_) async => Response(
            data: {'message': 'Error'},
            statusCode: 400,
            requestOptions: RequestOptions(
              path: ApiConstants.registerClientEndpoint,
            ),
          ),
        );
        // act
        final call = dataSource.register(params: tRegisterParams);
        // assert
        expect(() => call, throwsA(isA<ServerException>()));
        verify(
          mockDioClient.post(
            ApiConstants.registerClientEndpoint,
            data: tRegisterParams.toJson(),
          ),
        );
        verifyNoMoreInteractions(mockDioClient);
      },
    );

    test(
      'should throw a ServerException when DioClient throws DioException',
      () async {
        // arrange
        when(
          mockDioClient.post(
            ApiConstants.registerClientEndpoint,
            data: tRegisterParams.toJson(),
          ),
        ).thenThrow(
          DioException(
            requestOptions: RequestOptions(
              path: ApiConstants.registerClientEndpoint,
            ),
            message: 'Dio error',
          ),
        );
        // act
        final call = dataSource.register(params: tRegisterParams);
        // assert
        expect(() => call, throwsA(isA<ServerException>()));
        verify(
          mockDioClient.post(
            ApiConstants.registerClientEndpoint,
            data: tRegisterParams.toJson(),
          ),
        );
        verifyNoMoreInteractions(mockDioClient);
      },
    );
  });

  group('signOut', () {
    test('should complete successfully', () async {
      // arrange
      // No hay llamadas a dioClient en la implementación actual de signOut
      // act
      final call = dataSource.signOut();
      // assert
      await expectLater(call, completes);
      verifyZeroInteractions(
        mockDioClient,
      ); // Asegurarse de que no se llamó a dioClient
    });

    // La implementación actual de signOut tiene un try-catch genérico Future.delayed
    // que luego llama a ErrorHandler. Si Future.delayed lanzara una excepción
    // (muy improbable por sí mismo), ErrorHandler la manejaría.
    // Para probar explícitamente ErrorHandler, necesitaríamos poder inyectar un error
    // en ese bloque, o refactorizar ErrorHandler para ser más mockeable.
    // Por ahora, el test de arriba cubre el flujo normal.
  });
}
