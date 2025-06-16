import 'package:dartz/dartz.dart';
import 'package:flutter_application_ecommerce/core/error/failures.dart';
import '../entities/order_entity.dart';
import '../../../addresses/domain/entities/address_entity.dart' as address_entities;

/// Repositorio abstracto para manejar órdenes
abstract class OrderRepository {
  /// Obtiene todas las órdenes del usuario
  Future<Either<Failure, List<OrderEntity>>> getMyOrders();

  /// Obtiene una orden por su ID
  Future<Either<Failure, OrderEntity>> getOrder(String orderId);

  /// Crea una nueva orden
  Future<Either<Failure, OrderEntity>> createOrder({
    required List<OrderItemEntity> items,
    required address_entities.AddressEntity shippingAddress,
    address_entities.AddressEntity? billingAddress,
    String? couponCode,
  });

  /// Cancela una orden
  Future<Either<Failure, OrderEntity>> cancelOrder(String orderId);

  /// Rastrea una orden
  Future<Either<Failure, List<OrderTrackingEntity>>> trackOrder(String orderId);
}

/// Entidad para el seguimiento de órdenes
class OrderTrackingEntity {
  final String status;
  final String description;
  final DateTime timestamp;

  const OrderTrackingEntity({
    required this.status,
    required this.description,
    required this.timestamp,
  });
} 