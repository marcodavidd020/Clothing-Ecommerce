import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/network/dio_client.dart';
import '../../../../core/constants/api_constants.dart';
import '../../domain/entities/order_entity.dart';
import '../../domain/repositories/order_repository.dart';
import '../models/order_api_model.dart';
import '../models/create_order_request_model.dart';
import '../../../addresses/domain/entities/address_entity.dart' as address_entities;
import 'package:flutter/foundation.dart';

class OrderRepositoryImpl implements OrderRepository {
  final DioClient _dioClient;

  OrderRepositoryImpl({required DioClient dioClient}) : _dioClient = dioClient;

  @override
  Future<Either<Failure, List<OrderEntity>>> getMyOrders() async {
    try {
      final response = await _dioClient.get(
        ApiConstants.myOrdersEndpoint,
        queryParameters: {
          'page': 1,
          'limit': 50,
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = response.data;
        final List<dynamic> ordersData = responseData['data'] ?? [];
        
        final orders = ordersData
            .map((orderJson) => OrderApiModel.fromJson(orderJson).toEntity())
            .toList();

        return Right(orders);
      } else {
        return Left(ServerFailure(message: 'Error al obtener órdenes: ${response.statusMessage}'));
      }
    } catch (e) {
      return Left(ServerFailure(message: 'Error de conexión: $e'));
    }
  }

  @override
  Future<Either<Failure, OrderEntity>> getOrder(String orderId) async {
    try {
      final response = await _dioClient.get(
        ApiConstants.getMyOrderEndpoint(orderId),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = response.data;
        final orderData = responseData['data'];
        
        final order = OrderApiModel.fromJson(orderData).toEntity();
        return Right(order);
      } else {
        return Left(ServerFailure(message: 'Error al obtener orden: ${response.statusMessage}'));
      }
    } catch (e) {
      return Left(ServerFailure(message: 'Error de conexión: $e'));
    }
  }

  @override
  Future<Either<Failure, OrderEntity>> createOrder({
    required List<OrderItemEntity> items,
    required address_entities.AddressEntity shippingAddress,
    address_entities.AddressEntity? billingAddress,
    String? couponCode,
  }) async {
    try {
      // Convertir los items del dominio al formato requerido por la API
      final apiItems = items.map((item) => OrderItemCreateModel(
        productVariantId: item.productId,
        quantity: item.quantity,
      )).toList();

      final createOrderRequest = CreateOrderRequestModel(
        addressId: shippingAddress.id,
        paymentMethod: 'CARD',
        items: apiItems,
        couponCode: couponCode,
      );

      // Logging detallado para debug
      debugPrint('🔍 === CREAR ORDEN - DATOS ENVIADOS ===');
      debugPrint('📍 Address ID: ${shippingAddress.id}');
      debugPrint('💳 Payment Method: CARD');
      debugPrint('🎫 Coupon Code: ${couponCode ?? 'null'}');
      debugPrint('📦 Items (${items.length}):');
      for (int i = 0; i < items.length; i++) {
        final item = items[i];
        debugPrint('   Item $i:');
        debugPrint('     - Product ID: ${item.productId}');
        debugPrint('     - Name: ${item.name}');
        debugPrint('     - Quantity: ${item.quantity}');
        debugPrint('     - Price: ${item.price}');
      }
      
      final jsonData = createOrderRequest.toJson();
      debugPrint('📤 JSON Final enviado:');
      debugPrint(jsonData.toString());
      debugPrint('🔍 === FIN DATOS ENVIADOS ===');

      final response = await _dioClient.post(
        ApiConstants.ordersEndpoint,
        data: jsonData,
      );

      if (response.statusCode == 201) {
        final Map<String, dynamic> responseData = response.data;
        final orderData = responseData['data'];
        
        final order = OrderApiModel.fromJson(orderData).toEntity();
        debugPrint('✅ Orden creada exitosamente: ${order.id}');
        return Right(order);
      } else {
        debugPrint('❌ Error HTTP: ${response.statusCode} - ${response.statusMessage}');
        return Left(ServerFailure(message: 'Error al crear orden: ${response.statusMessage}'));
      }
    } catch (e) {
      debugPrint('❌ Error en createOrder: $e');
      if (e.toString().contains('400')) {
        debugPrint('🚨 Error 400 Bad Request - Revisar datos enviados arriba');
      }
      return Left(ServerFailure(message: 'Error de conexión: $e'));
    }
  }

  @override
  Future<Either<Failure, OrderEntity>> cancelOrder(String orderId) async {
    try {
      final response = await _dioClient.patch(
        ApiConstants.cancelMyOrderEndpoint(orderId),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = response.data;
        final orderData = responseData['data'];
        
        final order = OrderApiModel.fromJson(orderData).toEntity();
        return Right(order);
      } else {
        return Left(ServerFailure(message: 'Error al cancelar orden: ${response.statusMessage}'));
      }
    } catch (e) {
      return Left(ServerFailure(message: 'Error de conexión: $e'));
    }
  }

  @override
  Future<Either<Failure, List<OrderTrackingEntity>>> trackOrder(String orderId) async {
    try {
      final orderResult = await getOrder(orderId);
      
      return orderResult.fold(
        (failure) => Left(failure),
        (order) {
          final trackingList = <OrderTrackingEntity>[
            OrderTrackingEntity(
              status: order.status.name,
              description: order.statusText,
              timestamp: order.createdAt,
            ),
          ];
          return Right(trackingList);
        },
      );
    } catch (e) {
      return Left(ServerFailure(message: 'Error de conexión: $e'));
    }
  }
} 