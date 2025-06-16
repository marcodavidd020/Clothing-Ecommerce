part of 'order_bloc.dart';

abstract class OrderEvent {
  const OrderEvent();
}

/// Evento para cargar las órdenes del usuario
class LoadMyOrders extends OrderEvent {
  const LoadMyOrders();
}

/// Evento para crear una nueva orden
class CreateOrder extends OrderEvent {
  final List<OrderItemEntity> items;
  final address_entities.AddressEntity shippingAddress;
  final address_entities.AddressEntity? billingAddress;
  final String? couponCode;

  const CreateOrder({
    required this.items,
    required this.shippingAddress,
    this.billingAddress,
    this.couponCode,
  });
}

/// Evento para cancelar una orden
class CancelOrder extends OrderEvent {
  final String orderId;

  const CancelOrder(this.orderId);
}

/// Evento para obtener detalles de una orden
class GetOrderDetails extends OrderEvent {
  final String orderId;

  const GetOrderDetails(this.orderId);
} 