import 'package:flutter_application_ecommerce/core/constants/api_constants.dart';
import 'package:flutter_application_ecommerce/core/network/dio_client.dart';
import 'package:flutter_application_ecommerce/core/network/logger.dart';
import '../models/order_api_model.dart';

/// Fuente de datos remota para órdenes
abstract class OrderApiDataSource {
  Future<List<OrderApiModel>> getMyOrders();
  Future<OrderApiModel> createOrder(CreateOrderApiModel order);
  Future<OrderApiModel> getOrderById(String orderId);
  Future<void> cancelOrder(String orderId);
  Future<OrderApiModel> trackOrder(String orderId);
}

/// Implementación de la fuente de datos remota para órdenes
class OrderApiRemoteDataSource implements OrderApiDataSource {
  final DioClient _dioClient;

  OrderApiRemoteDataSource({required DioClient dioClient})
      : _dioClient = dioClient;

  @override
  Future<List<OrderApiModel>> getMyOrders() async {
    try {
      AppLogger.logInfo('Llamando a getMyOrders endpoint: ${ApiConstants.myOrdersEndpoint}');
      
      final response = await _dioClient.get(ApiConstants.myOrdersEndpoint);

      if (response.data['success'] == true) {
        final List<dynamic> ordersData = response.data['data'] ?? [];
        
        final List<OrderApiModel> orders = ordersData
            .map((orderJson) => OrderApiModel.fromJson(orderJson))
            .toList();

        AppLogger.logSuccess('Órdenes obtenidas exitosamente: ${orders.length} órdenes');
        return orders;
      } else {
        final errorMessage = response.data['message'] ?? 'Error desconocido al obtener órdenes';
        AppLogger.logError('Error en respuesta: $errorMessage');
        throw Exception('Error al obtener órdenes: $errorMessage');
      }
    } catch (e) {
      AppLogger.logError('EXCEPTION en getMyOrders: $e');
      throw Exception('Error al obtener órdenes: $e');
    }
  }

  @override
  Future<OrderApiModel> createOrder(CreateOrderApiModel order) async {
    try {
      AppLogger.logInfo('Llamando a createOrder endpoint: ${ApiConstants.createOrderEndpoint}');
      
      final response = await _dioClient.post(
        ApiConstants.createOrderEndpoint,
        data: order.toJson(),
      );

      if (response.data['success'] == true) {
        final orderData = response.data['data'];
        final orderModel = OrderApiModel.fromJson(orderData);
        
        AppLogger.logSuccess('Orden creada exitosamente: ${orderModel.id}');
        return orderModel;
      } else {
        final errorMessage = response.data['message'] ?? 'Error desconocido al crear orden';
        AppLogger.logError('Error en respuesta: $errorMessage');
        throw Exception('Error al crear orden: $errorMessage');
      }
    } catch (e) {
      AppLogger.logError('EXCEPTION en createOrder: $e');
      throw Exception('Error al crear orden: $e');
    }
  }

  @override
  Future<OrderApiModel> getOrderById(String orderId) async {
    try {
      AppLogger.logInfo('Llamando a getOrderById endpoint: ${ApiConstants.getOrderEndpoint(orderId)}');
      
      final response = await _dioClient.get(ApiConstants.getOrderEndpoint(orderId));

      if (response.data['success'] == true) {
        final orderData = response.data['data'];
        final orderModel = OrderApiModel.fromJson(orderData);
        
        AppLogger.logSuccess('Orden obtenida exitosamente: ${orderModel.id}');
        return orderModel;
      } else {
        final errorMessage = response.data['message'] ?? 'Error desconocido al obtener orden';
        AppLogger.logError('Error en respuesta: $errorMessage');
        throw Exception('Error al obtener orden: $errorMessage');
      }
    } catch (e) {
      AppLogger.logError('EXCEPTION en getOrderById: $e');
      throw Exception('Error al obtener orden: $e');
    }
  }

  @override
  Future<void> cancelOrder(String orderId) async {
    try {
      AppLogger.logInfo('Llamando a cancelOrder endpoint: ${ApiConstants.cancelOrderEndpoint(orderId)}');
      
      final response = await _dioClient.post(ApiConstants.cancelOrderEndpoint(orderId));

      if (response.data['success'] == true) {
        AppLogger.logSuccess('Orden cancelada exitosamente: $orderId');
      } else {
        final errorMessage = response.data['message'] ?? 'Error desconocido al cancelar orden';
        AppLogger.logError('Error en respuesta: $errorMessage');
        throw Exception('Error al cancelar orden: $errorMessage');
      }
    } catch (e) {
      AppLogger.logError('EXCEPTION en cancelOrder: $e');
      throw Exception('Error al cancelar orden: $e');
    }
  }

  @override
  Future<OrderApiModel> trackOrder(String orderId) async {
    try {
      AppLogger.logInfo('Llamando a trackOrder endpoint: ${ApiConstants.getOrderEndpoint(orderId)}');
      
      final response = await _dioClient.get('${ApiConstants.getOrderEndpoint(orderId)}/track');

      if (response.data['success'] == true) {
        final orderData = response.data['data'];
        final orderModel = OrderApiModel.fromJson(orderData);
        
        AppLogger.logSuccess('Orden rastreada exitosamente: ${orderModel.id}');
        return orderModel;
      } else {
        final errorMessage = response.data['message'] ?? 'Error desconocido al rastrear orden';
        AppLogger.logError('Error en respuesta: $errorMessage');
        throw Exception('Error al rastrear orden: $errorMessage');
      }
    } catch (e) {
      AppLogger.logError('EXCEPTION en trackOrder: $e');
      throw Exception('Error al rastrear orden: $e');
    }
  }
} 