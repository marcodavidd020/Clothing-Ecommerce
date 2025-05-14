import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_application_ecommerce/core/constants/api_constants.dart';
import 'package:flutter_application_ecommerce/core/error/exceptions.dart';
import 'package:flutter_application_ecommerce/core/network/network_info.dart';
import 'package:flutter_application_ecommerce/core/storage/auth_storage.dart';

/// Cliente HTTP basado en Dio para realizar solicitudes a la API
class DioClient {
  final Dio dio;
  final NetworkInfo networkInfo;
  AuthStorage? _authStorage;

  // Modo de depuración para desactivar verificación de conexión en desarrollo
  final bool debugSkipConnectionCheck;

  DioClient({
    required this.dio,
    required this.networkInfo,
    AuthStorage? authStorage,
    this.debugSkipConnectionCheck = false,
  }) : _authStorage = authStorage {
    dio.options.baseUrl = ApiConstants.baseUrl;
    dio.options.connectTimeout = Duration(milliseconds: ApiConstants.connectTimeout);
    dio.options.receiveTimeout = Duration(milliseconds: ApiConstants.receiveTimeout);
    dio.options.headers = ApiConstants.headers;

    // Interceptor para añadir el token de autenticación
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: _onRequest,
      ),
    );
  }

  /// Configura el almacenamiento de autenticación
  void setAuthStorage(AuthStorage authStorage) {
    _authStorage = authStorage;
  }

  /// Interceptor que añade el token de autorización si está disponible
  Future<void> _onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    if (_authStorage != null) {
      final token = await _authStorage!.getAccessToken();
      if (token != null && token.isNotEmpty) {
        options.headers['Authorization'] = 'Bearer $token';
      }
    }
    return handler.next(options);
  }

  /// Comprueba la conexión a Internet antes de realizar una solicitud
  Future<void> _checkConnectivity() async {
    if (!await networkInfo.isConnected) {
      throw DioException(
        requestOptions: RequestOptions(path: ''),
        error: 'No hay conexión a Internet',
        type: DioExceptionType.connectionError,
      );
    }
  }

  /// Realiza una solicitud GET
  Future<Response> get(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onReceiveProgress,
  }) async {
    await _checkConnectivity();
    return dio.get(
      path,
      queryParameters: queryParameters,
      options: options,
      cancelToken: cancelToken,
      onReceiveProgress: onReceiveProgress,
    );
  }

  /// Realiza una solicitud POST
  Future<Response> post(
    String path, {
    data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    await _checkConnectivity();
    return dio.post(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
      cancelToken: cancelToken,
      onSendProgress: onSendProgress,
      onReceiveProgress: onReceiveProgress,
    );
  }

  /// Realiza una solicitud PUT
  Future<Response> put(
    String path, {
    data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    await _checkConnectivity();
    return dio.put(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
      cancelToken: cancelToken,
      onSendProgress: onSendProgress,
      onReceiveProgress: onReceiveProgress,
    );
  }

  /// Realiza una solicitud PATCH
  Future<Response> patch(
    String path, {
    data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    await _checkConnectivity();
    return dio.patch(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
      cancelToken: cancelToken,
      onSendProgress: onSendProgress,
      onReceiveProgress: onReceiveProgress,
    );
  }

  /// Realiza una solicitud DELETE
  Future<Response> delete(
    String path, {
    data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    await _checkConnectivity();
    return dio.delete(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
      cancelToken: cancelToken,
    );
  }

  Exception _handleDioError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return NetworkException(message: 'Tiempo de espera agotado');
      case DioExceptionType.badResponse:
        throw error;
      case DioExceptionType.cancel:
        return ServerException(message: 'Solicitud cancelada');
      case DioExceptionType.connectionError:
        return NetworkException(message: 'Error de conexión');
      case DioExceptionType.badCertificate:
        return ServerException(message: 'Certificado inválido');
      case DioExceptionType.unknown:
        if (error.error is SocketException) {
          return NetworkException(message: 'No hay conexión a internet');
        }
        return UnknownException(message: error.message ?? 'Error desconocido');
    }
  }
}
