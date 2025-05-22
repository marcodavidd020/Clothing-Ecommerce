import 'package:dio/dio.dart';
import 'package:flutter_application_ecommerce/core/constants/api_constants.dart';
import 'package:flutter_application_ecommerce/core/network/network_info.dart';
import 'package:flutter_application_ecommerce/core/storage/auth_storage.dart';
import 'package:flutter_application_ecommerce/core/network/logger.dart';

/// Cliente HTTP basado en Dio para realizar solicitudes a la API
class DioClient {
  final Dio dio;
  final NetworkInfo networkInfo;
  AuthStorage? _authStorage;
  bool _isRefreshing = false;
  final Dio _tokenDio = Dio();

  // Modo de depuración para desactivar verificación de conexión en desarrollo
  final bool debugSkipConnectionCheck;

  DioClient({
    required this.dio,
    required this.networkInfo,
    AuthStorage? authStorage,
    this.debugSkipConnectionCheck = false,
  }) : _authStorage = authStorage {
    dio.options.baseUrl = ApiConstants.baseUrl;
    dio.options.connectTimeout = Duration(
      milliseconds: ApiConstants.connectTimeout,
    );
    dio.options.receiveTimeout = Duration(
      milliseconds: ApiConstants.receiveTimeout,
    );
    dio.options.headers = ApiConstants.headers;

    // Interceptor para añadir el token de autenticación y manejo básico de errores de Dio
    dio.interceptors.add(
      InterceptorsWrapper(onRequest: _onRequest, onError: _onError),
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

  /// Interceptor para manejar errores, especialmente el 401 (No autorizado)
  Future<void> _onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    // Si es un error 401 y tenemos AuthStorage, intentamos renovar el token
    if (err.response?.statusCode == 401 && _authStorage != null) {
      // Evitar múltiples intentos de renovación simultáneos
      if (!_isRefreshing) {
        try {
          _isRefreshing = true;

          // Intentar renovar el token
          final newTokens = await _refreshToken();
          if (newTokens) {
            // Token renovado exitosamente, reintentar la solicitud original
            final newToken = await _authStorage!.getAccessToken();
            final options = err.requestOptions;
            options.headers['Authorization'] = 'Bearer $newToken';

            // Ejecutar nuevamente la solicitud con el nuevo token
            final response = await dio.fetch(options);
            return handler.resolve(response);
          }
        } catch (e) {
          AppLogger.logError('Error al renovar token: $e');
        } finally {
          _isRefreshing = false;
        }
      }
    }

    // Si no se pudo renovar el token o no es un error 401, continuar con el error
    return handler.next(err);
  }

  /// Intenta renovar el token usando el refreshToken
  Future<bool> _refreshToken() async {
    try {
      final refreshToken = await _authStorage?.getRefreshToken();

      if (refreshToken == null || refreshToken.isEmpty) {
        AppLogger.logError('No hay refresh token disponible');
        return false;
      }

      AppLogger.logInfo('Intentando renovar token con refreshToken');

      // Realizar solicitud para renovar token
      final response = await _tokenDio.post(
        '${ApiConstants.baseUrl}/auth/refresh-token',
        data: {'refreshToken': refreshToken},
      );

      if (response.statusCode == 200 && response.data['success'] == true) {
        final data = response.data['data'];
        final newAccessToken = data['accessToken'];
        final newRefreshToken = data['refreshToken'];

        // Guardar los nuevos tokens
        await _authStorage?.saveTokens(
          accessToken: newAccessToken,
          refreshToken: newRefreshToken,
        );

        AppLogger.logSuccess('Token renovado exitosamente');
        return true;
      }

      return false;
    } catch (e) {
      AppLogger.logError('Error al renovar token: $e');
      return false;
    }
  }

  /// Comprueba la conexión a Internet antes de realizar una solicitud
  Future<void> _checkConnectivity() async {
    if (!debugSkipConnectionCheck && !await networkInfo.isConnected) {
      throw DioException(
        requestOptions: RequestOptions(path: ''),
        error: 'No hay conexión a Internet',
        type:
            DioExceptionType
                .connectionError, // Usar un tipo específico de DioException
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
    try {
      return await dio.get(
        path,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onReceiveProgress: onReceiveProgress,
      );
    } on DioException {
      // Relanzar DioException para que ErrorHandler la procese
      rethrow;
    }
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
    try {
      return await dio.post(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
    } on DioException {
      // Relanzar DioException para que ErrorHandler la procese
      rethrow;
    }
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
    try {
      return await dio.put(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
    } on DioException {
      // Relanzar DioException para que ErrorHandler la procese
      rethrow;
    }
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
    try {
      return await dio.patch(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
    } on DioException {
      // Relanzar DioException para que ErrorHandler la procese
      rethrow;
    }
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
    try {
      return await dio.delete(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
    } on DioException {
      // Relanzar DioException para que ErrorHandler la procese
      rethrow;
    }
  }

  // _handleDioError ya no es necesario aquí, ErrorHandler lo maneja en la capa de DataSource.
}
