import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_application_ecommerce/core/constants/api_constants.dart';
import 'package:flutter_application_ecommerce/core/error/exceptions.dart';
import 'package:flutter_application_ecommerce/core/network/network_info.dart';

class DioClient {
  final Dio _dio;
  final NetworkInfo networkInfo;

  // Modo de depuración para desactivar verificación de conexión en desarrollo
  final bool debugSkipConnectionCheck;

  DioClient({
    required Dio dio,
    required this.networkInfo,
    this.debugSkipConnectionCheck = false,
  }) : _dio = dio {
    _dio.options = BaseOptions(
      baseUrl: ApiConstants.baseUrl,
      connectTimeout: const Duration(milliseconds: ApiConstants.connectTimeout),
      receiveTimeout: const Duration(milliseconds: ApiConstants.receiveTimeout),
      headers: ApiConstants.headers,
      responseType: ResponseType.json,
    );

    _dio.interceptors.add(
      LogInterceptor(
        request: true,
        requestHeader: true,
        requestBody: true,
        responseHeader: true,
        responseBody: true,
        error: true,
      ),
    );
  }

  Future<Response> get(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    bool shouldProceed = true;

    // Solo verificamos conexión si no estamos en modo debug
    if (!debugSkipConnectionCheck) {
      try {
        shouldProceed = await networkInfo.isConnected;
      } catch (e) {
        // Si la verificación falla, intentamos la petición de todas formas
        shouldProceed = true;
      }
    }

    if (!shouldProceed) {
      throw NetworkException(message: 'No hay conexión a internet');
    }

    try {
      final response = await _dio.get(
        path,
        queryParameters: queryParameters,
        options: options,
      );

      return response;
    } on DioException catch (e) {
      throw _handleDioError(e);
    } on SocketException {
      throw NetworkException(message: 'No hay conexión a internet');
    } catch (e) {
      throw UnknownException(message: e.toString());
    }
  }

  Future<Response> post(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    bool shouldProceed = true;

    // Solo verificamos conexión si no estamos en modo debug
    if (!debugSkipConnectionCheck) {
      try {
        shouldProceed = await networkInfo.isConnected;
      } catch (e) {
        // Si la verificación falla, intentamos la petición de todas formas
        shouldProceed = true;
      }
    }

    if (!shouldProceed) {
      throw NetworkException(message: 'No hay conexión a internet');
    }

    try {
      final response = await _dio.post(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );

      return response;
    } on DioException catch (e) {
      throw _handleDioError(e);
    } on SocketException {
      throw NetworkException(message: 'No hay conexión a internet');
    } catch (e) {
      throw UnknownException(message: e.toString());
    }
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
