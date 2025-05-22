import 'package:flutter_application_ecommerce/core/constants/api_constants.dart';
import 'package:flutter_application_ecommerce/core/error/exceptions.dart';
import 'package:flutter_application_ecommerce/core/network/dio_client.dart';
import 'package:flutter_application_ecommerce/core/network/logger.dart';
import 'package:flutter_application_ecommerce/core/network/response_handler.dart';
import 'package:flutter_application_ecommerce/features/home/data/models/product_detail_model.dart';

/// Define los métodos para acceder a los datos de los productos desde la API
abstract class ProductApiDataSource {
  /// Obtiene un producto por su ID
  Future<ProductDetailModel> getProductById(String id);

  /// Obtiene productos por categoría
  Future<List<ProductDetailModel>> getProductsByCategory(String categoryId);
}

/// Implementación que carga los productos desde la API remota
class ProductApiRemoteDataSource implements ProductApiDataSource {
  final DioClient _dioClient;

  ProductApiRemoteDataSource({required DioClient dioClient})
    : _dioClient = dioClient;

  @override
  Future<ProductDetailModel> getProductById(String id) async {
    try {
      AppLogger.logInfo(
        'Llamando a getProductById endpoint: ${ApiConstants.getProductByIdEndpoint(id)}',
      );
      final response = await _dioClient.get(
        ApiConstants.getProductByIdEndpoint(id),
      );
      AppLogger.logInfo(
        'Respuesta recibida: statusCode=${response.statusCode}',
      );

      if (ResponseHandler.isSuccessfulResponse(response)) {
        final productData = ResponseHandler.extractData(
          response,
          (json) => ProductDetailModel.fromJson(json),
        );
        if (productData != null) {
          AppLogger.logSuccess('Producto obtenido: ${productData.name}');
          return productData;
        } else {
          AppLogger.logError(
            'ERROR: productData es null después de extractData',
          );
          throw ServerException(
            message: 'No se pudo extraer datos del producto',
            statusCode: response.statusCode,
          );
        }
      } else {
        final errorMessage = ResponseHandler.extractErrorMessage(response);
        AppLogger.logError(
          'ERROR: Respuesta no exitosa, statusCode=${response.statusCode}, mensaje=$errorMessage',
        );
        throw ServerException(
          message: errorMessage,
          statusCode: response.statusCode,
        );
      }
    } catch (e) {
      AppLogger.logError('Error al obtener producto por ID', e);
      AppLogger.logError('EXCEPTION en getProductById: ${e.toString()}');
      throw ServerException(
        message: 'Error al obtener producto: ${e.toString()}',
        statusCode: 0,
      );
    }
  }

  @override
  Future<List<ProductDetailModel>> getProductsByCategory(String categoryId) async {
    try {
      AppLogger.logInfo(
        'Llamando a getProductsByCategory endpoint: ${ApiConstants.getProductsByCategoryEndpoint(categoryId)}',
      );
      final response = await _dioClient.get(
        ApiConstants.getProductsByCategoryEndpoint(categoryId),
      );
      AppLogger.logInfo(
        'Respuesta recibida: statusCode=${response.statusCode}',
      );

      if (ResponseHandler.isSuccessfulResponse(response)) {
        // Usamos extractDataList para obtener la lista de productos
        final productsList = ResponseHandler.extractDataList<ProductDetailModel>(
          response,
          (json) => ProductDetailModel.fromJson(json),
        );

        if (productsList != null) {
          AppLogger.logSuccess(
            'Productos obtenidos: ${productsList.length} productos',
          );
          return productsList;
        } else {
          AppLogger.logError(
            'ERROR: productsList es null después de extractDataList',
          );
          throw ServerException(
            message: 'No se pudieron extraer productos de la respuesta',
            statusCode: response.statusCode,
          );
        }
      } else {
        AppLogger.logError(
          'ERROR: Respuesta no exitosa, statusCode=${response.statusCode}',
        );
        throw ServerException(
          message: ResponseHandler.extractErrorMessage(response),
          statusCode: response.statusCode,
        );
      }
    } catch (e) {
      AppLogger.logError('Error al obtener productos por categoría', e);
      AppLogger.logError('EXCEPTION en getProductsByCategory: ${e.toString()}');
      // Relanzar la excepción en lugar de silenciarla
      if (e is ServerException) {
        throw e;
      }
      throw ServerException(
        message: 'Error al obtener productos: ${e.toString()}',
        statusCode: 0,
      );
    }
  }
}
