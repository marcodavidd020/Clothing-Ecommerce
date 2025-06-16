part of 'order_bloc.dart';

abstract class OrderState {
  const OrderState();
}

/// Estado inicial
class OrderInitial extends OrderState {
  const OrderInitial();
}

/// Estado de carga
class OrderLoading extends OrderState {
  const OrderLoading();
}

/// Estado con órdenes cargadas exitosamente
class OrderLoaded extends OrderState {
  final List<OrderEntity> orders;

  const OrderLoaded({required this.orders});
}

/// Estado de orden creada exitosamente
class OrderCreated extends OrderState {
  final OrderEntity order;
  final String message;

  const OrderCreated({
    required this.order,
    required this.message,
  });
}

/// Estado de orden cancelada exitosamente
class OrderCancelled extends OrderState {
  final String message;

  const OrderCancelled({required this.message});
}

/// Estado de error
class OrderError extends OrderState {
  final String message;

  const OrderError({required this.message});
} 