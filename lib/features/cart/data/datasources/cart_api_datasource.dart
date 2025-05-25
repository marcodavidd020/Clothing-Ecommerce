import 'package:flutter_application_ecommerce/core/constants/api_constants.dart';
import 'package:flutter_application_ecommerce/core/error/exceptions.dart';
import 'package:flutter_application_ecommerce/core/network/dio_client.dart';
import 'package:flutter_application_ecommerce/core/network/logger.dart';
import 'package:flutter_application_ecommerce/core/network/response_handler.dart';
import 'package:flutter_application_ecommerce/features/cart/data/models/cart_api_model.dart';

/// Define los métodos para acceder a los datos del carrito desde la API
abstract class CartApiDataSource {
  /// Obtiene el carrito del usuario actual
  Future<CartApiModel> getMyCart();

  /// Añade un item al carrito
  Future<CartApiModel> addItemToCart(String productVariantId, int quantity);

  /// Actualiza la cantidad de un item en el carrito
  Future<CartApiModel> updateCartItem(String itemId, int quantity);

  /// Elimina un item del carrito
  Future<CartApiModel> removeCartItem(String itemId);

  /// Vacía el carrito completamente
  Future<CartApiModel> clearCart();
}

/// Implementación que maneja el carrito desde la API remota
class CartApiRemoteDataSource implements CartApiDataSource {
  final DioClient _dioClient;

  CartApiRemoteDataSource({required DioClient dioClient})
      : _dioClient = dioClient;

  @override
  Future<CartApiModel> getMyCart() async {
    try {
      AppLogger.logInfo(
        'Llamando a getMyCart endpoint: ${ApiConstants.cartMyCartEndpoint}',
      );
      final response = await _dioClient.get(
        ApiConstants.cartMyCartEndpoint,
      );
      AppLogger.logInfo(
        'Respuesta recibida: statusCode=${response.statusCode}',
      );

      if (ResponseHandler.isSuccessfulResponse(response)) {
        final cartData = ResponseHandler.extractData(
          response,
          (json) => CartApiModel.fromJson(json),
        );
        if (cartData != null) {
          AppLogger.logSuccess(
            'Carrito obtenido: ${cartData.items.length} items, total: \$${cartData.total}',
          );
          return cartData;
        } else {
          AppLogger.logError(
            'ERROR: cartData es null después de extractData',
          );
          throw ServerException(
            message: 'No se pudo extraer datos del carrito',
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
      AppLogger.logError('Error al obtener carrito', e);
      AppLogger.logError('EXCEPTION en getMyCart: ${e.toString()}');
      throw ServerException(
        message: 'Error al obtener carrito: ${e.toString()}',
        statusCode: 0,
      );
    }
  }

  @override
  Future<CartApiModel> addItemToCart(String productVariantId, int quantity) async {
    try {
      AppLogger.logInfo(
        'Llamando a addItemToCart endpoint: ${ApiConstants.cartMyCartItemsEndpoint}',
      );
      
      final requestData = {
        'productVariantId': productVariantId,
        'quantity': quantity,
      };
      
      final response = await _dioClient.post(
        ApiConstants.cartMyCartItemsEndpoint,
        data: requestData,
      );
      AppLogger.logInfo(
        'Respuesta recibida: statusCode=${response.statusCode}',
      );

      if (ResponseHandler.isSuccessfulResponse(response)) {
        final cartData = ResponseHandler.extractData(
          response,
          (json) => CartApiModel.fromJson(json),
        );
        if (cartData != null) {
          AppLogger.logSuccess(
            'Item añadido al carrito: ${cartData.items.length} items, total: \$${cartData.total}',
          );
          return cartData;
        } else {
          AppLogger.logError(
            'ERROR: cartData es null después de extractData',
          );
          throw ServerException(
            message: 'No se pudo extraer datos del carrito',
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
      AppLogger.logError('Error al añadir item al carrito', e);
      AppLogger.logError('EXCEPTION en addItemToCart: ${e.toString()}');
      throw ServerException(
        message: 'Error al añadir item al carrito: ${e.toString()}',
        statusCode: 0,
      );
    }
  }

  @override
  Future<CartApiModel> updateCartItem(String itemId, int quantity) async {
    try {
      AppLogger.logInfo(
        'Llamando a updateCartItem endpoint: ${ApiConstants.getCartMyCartItemEndpoint(itemId)}',
      );
      
      final requestData = {
        'quantity': quantity,
      };
      
      final response = await _dioClient.put(
        ApiConstants.getCartMyCartItemEndpoint(itemId),
        data: requestData,
      );
      AppLogger.logInfo(
        'Respuesta recibida: statusCode=${response.statusCode}',
      );

      if (ResponseHandler.isSuccessfulResponse(response)) {
        final cartData = ResponseHandler.extractData(
          response,
          (json) => CartApiModel.fromJson(json),
        );
        if (cartData != null) {
          AppLogger.logSuccess(
            'Item actualizado en carrito: ${cartData.items.length} items, total: \$${cartData.total}',
          );
          return cartData;
        } else {
          AppLogger.logError(
            'ERROR: cartData es null después de extractData',
          );
          throw ServerException(
            message: 'No se pudo extraer datos del carrito',
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
      AppLogger.logError('Error al actualizar item del carrito', e);
      AppLogger.logError('EXCEPTION en updateCartItem: ${e.toString()}');
      throw ServerException(
        message: 'Error al actualizar item del carrito: ${e.toString()}',
        statusCode: 0,
      );
    }
  }

  @override
  Future<CartApiModel> removeCartItem(String itemId) async {
    try {
      AppLogger.logInfo(
        'Llamando a removeCartItem endpoint: ${ApiConstants.getCartMyCartItemEndpoint(itemId)}',
      );
      
      final response = await _dioClient.delete(
        ApiConstants.getCartMyCartItemEndpoint(itemId),
      );
      AppLogger.logInfo(
        'Respuesta recibida: statusCode=${response.statusCode}',
      );

      if (ResponseHandler.isSuccessfulResponse(response)) {
        final cartData = ResponseHandler.extractData(
          response,
          (json) => CartApiModel.fromJson(json),
        );
        if (cartData != null) {
          AppLogger.logSuccess(
            'Item eliminado del carrito: ${cartData.items.length} items, total: \$${cartData.total}',
          );
          return cartData;
        } else {
          AppLogger.logError(
            'ERROR: cartData es null después de extractData',
          );
          throw ServerException(
            message: 'No se pudo extraer datos del carrito',
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
      AppLogger.logError('Error al eliminar item del carrito', e);
      AppLogger.logError('EXCEPTION en removeCartItem: ${e.toString()}');
      throw ServerException(
        message: 'Error al eliminar item del carrito: ${e.toString()}',
        statusCode: 0,
      );
    }
  }

  @override
  Future<CartApiModel> clearCart() async {
    try {
      AppLogger.logInfo(
        'Llamando a clearCart endpoint: ${ApiConstants.getCartMyCartClearEndpoint()}',
      );
      
      final response = await _dioClient.delete(
        ApiConstants.getCartMyCartClearEndpoint(),
      );
      AppLogger.logInfo(
        'Respuesta recibida: statusCode=${response.statusCode}',
      );

      if (ResponseHandler.isSuccessfulResponse(response)) {
        final cartData = ResponseHandler.extractData(
          response,
          (json) => CartApiModel.fromJson(json),
        );
        if (cartData != null) {
          AppLogger.logSuccess(
            'Carrito vaciado: ${cartData.items.length} items, total: \$${cartData.total}',
          );
          return cartData;
        } else {
          AppLogger.logError(
            'ERROR: cartData es null después de extractData',
          );
          throw ServerException(
            message: 'No se pudo extraer datos del carrito',
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
      AppLogger.logError('Error al vaciar carrito', e);
      AppLogger.logError('EXCEPTION en clearCart: ${e.toString()}');
      throw ServerException(
        message: 'Error al vaciar carrito: ${e.toString()}',
        statusCode: 0,
      );
    }
  }
} 