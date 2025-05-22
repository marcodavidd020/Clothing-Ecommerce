import 'package:flutter_application_ecommerce/core/constants/api_constants.dart';
import 'package:flutter_application_ecommerce/core/error/exceptions.dart';
import 'package:flutter_application_ecommerce/core/network/dio_client.dart';
import 'package:flutter_application_ecommerce/core/network/logger.dart';
import 'package:flutter_application_ecommerce/core/network/response_handler.dart';
import 'package:flutter_application_ecommerce/features/home/domain/entities/category_api_model.dart';

/// Define los métodos para acceder a los datos de las categorías desde la API
abstract class CategoryApiDataSource {
  /// Obtiene una lista plana de categorías
  Future<List<CategoryApiModel>> getCategories();

  /// Obtiene un árbol jerárquico de categorías
  Future<List<CategoryApiModel>> getCategoryTree();

  /// Obtiene una categoría específica por su ID
  Future<CategoryApiModel> getCategoryById(String id);
}

/// Implementación que carga las categorías desde la API remota
class CategoryApiRemoteDataSource implements CategoryApiDataSource {
  final DioClient _dioClient;

  CategoryApiRemoteDataSource({required DioClient dioClient})
    : _dioClient = dioClient;

  @override
  Future<List<CategoryApiModel>> getCategories() async {
    try {
      final response = await _dioClient.get(ApiConstants.categoriesEndpoint);
      AppLogger.logInfo(
        'Respuesta recibida: statusCode=${response.statusCode}',
      );

      if (ResponseHandler.isSuccessfulResponse(response)) {
        final categoryList = ResponseHandler.extractDataList<CategoryApiModel>(
          response,
          (json) => CategoryApiModel.fromJson(json),
        );

        if (categoryList != null) {
          AppLogger.logSuccess('Categorías obtenidas: ${categoryList.length}');
          return categoryList;
        } else {
          AppLogger.logError(
            'ERROR: categoryList es null después de extractDataList',
          );
        }
      } else {
        AppLogger.logError(
          'ERROR: Respuesta no exitosa, statusCode=${response.statusCode}',
        );
      }

      throw ServerException(
        message: ResponseHandler.extractErrorMessage(response),
        statusCode: response.statusCode,
      );
    } catch (e) {
      AppLogger.logError('Error al obtener categorías', e);
      AppLogger.logError('EXCEPTION en getCategories: ${e.toString()}');
      // Si hay un error de conectividad, usar datos mock
      AppLogger.logInfo('Usando categorías mock como fallback');
      return _getMockCategories();
    }
  }

  @override
  Future<List<CategoryApiModel>> getCategoryTree() async {
    try {
      AppLogger.logInfo(
        'Llamando a getCategoryTree endpoint: ${ApiConstants.categoriesTreeEndpoint}',
      );
      final response = await _dioClient.get(
        ApiConstants.categoriesTreeEndpoint,
      );
      AppLogger.logInfo(
        'Respuesta recibida: statusCode=${response.statusCode}',
      );

      if (ResponseHandler.isSuccessfulResponse(response)) {
        final categoryList = ResponseHandler.extractDataList<CategoryApiModel>(
          response,
          (json) => CategoryApiModel.fromJson(json),
        );

        if (categoryList != null) {
          AppLogger.logSuccess(
            'Árbol de categorías obtenido: ${categoryList.length} categorías raíz',
          );
          for (var category in categoryList) {
            AppLogger.logInfo(
              ' - Categoría: ${category.name} (${category.children.length} subcategorías)',
            );
          }
          return categoryList;
        } else {
          AppLogger.logError(
            'ERROR: categoryList es null después de extractDataList',
          );
        }
      } else {
        AppLogger.logError(
          'ERROR: Respuesta no exitosa, statusCode=${response.statusCode}',
        );
      }

      throw ServerException(
        message: ResponseHandler.extractErrorMessage(response),
        statusCode: response.statusCode,
      );
    } catch (e) {
      AppLogger.logError('Error al obtener árbol de categorías', e);
      AppLogger.logError('EXCEPTION en getCategoryTree: ${e.toString()}');
      // Si hay un error de conectividad, usar datos mock
      AppLogger.logInfo('Usando categorías mock como fallback');
      return _getMockCategories();
    }
  }

  @override
  Future<CategoryApiModel> getCategoryById(String id) async {
    try {
      AppLogger.logInfo(
        'Llamando a getCategoryById endpoint: ${ApiConstants.getCategoryByIdEndpoint(id)}',
      );
      final response = await _dioClient.get(
        ApiConstants.getCategoryByIdEndpoint(id),
      );
      AppLogger.logInfo(
        'Respuesta recibida: statusCode=${response.statusCode}',
      );

      if (ResponseHandler.isSuccessfulResponse(response)) {
        final categoryData = ResponseHandler.extractData(
          response,
          (json) => CategoryApiModel.fromJson(json),
        );
        if (categoryData != null) {
          AppLogger.logSuccess(
            'Categoría obtenida: ${categoryData.name} (${categoryData.children.length} subcategorías, ${categoryData.products.length} productos)',
          );
          return categoryData;
        } else {
          AppLogger.logError(
            'ERROR: categoryData es null después de extractData',
          );
          throw ServerException(
            message: 'No se pudo extraer datos de categoría',
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
      AppLogger.logError('Error al obtener categoría por ID', e);
      AppLogger.logError('EXCEPTION en getCategoryById: ${e.toString()}');
      // Para este caso, no usamos datos mock, ya que esperamos un ID específico
      throw ServerException(
        message: 'Error al obtener categoría: ${e.toString()}',
        statusCode: 0,
      );
    }
  }

  // Para pruebas o desarrollo, usar datos locales si la API no está disponible
  List<CategoryApiModel> _getMockCategories() {
    final jsonData = {
      "data": [
        {
          "id": "cd2083b1-db20-4d67-a09b-087e24115216",
          "name": "Ropa",
          "slug": "ropa",
          "image":
              "https://images.unsplash.com/photo-1445205170230-053b83016050?w=800",
          "children": [
            {
              "id": "e847397e-df5d-4de1-bce8-fa34a8a86712",
              "name": "Ropa de Hombre",
              "slug": "ropa-hombre",
              "image":
                  "https://images.unsplash.com/photo-1617137968427-85924c800a22?w=800",
              "children": [],
            },
            {
              "id": "482f3a7d-5009-4991-a805-050b69cf29ee",
              "name": "Ropa de Mujer",
              "slug": "ropa-mujer",
              "image":
                  "https://images.unsplash.com/photo-1581044777550-4cfa60707c03?w=800",
              "children": [],
            },
          ],
        },
        {
          "id": "dffa8757-5ed1-4bdc-a69f-72b405be09d4",
          "name": "Accesorios",
          "slug": "accesorios",
          "image":
              "https://images.unsplash.com/photo-1584917865442-de89df76afd3?w=800",
          "children": [],
        },
      ],
    };

    return (jsonData['data'] as List<dynamic>)
        .map((categoryJson) => CategoryApiModel.fromJson(categoryJson))
        .toList();
  }
}
