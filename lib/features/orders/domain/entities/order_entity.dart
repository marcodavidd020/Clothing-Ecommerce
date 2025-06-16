import 'package:equatable/equatable.dart';

/// Entidad que representa una orden en el dominio
class OrderEntity extends Equatable {
  final String id;
  final String userId;
  final String orderNumber;
  final List<OrderItemEntity> items;
  final double subtotal;
  final double discount;
  final double tax;
  final double shippingCost;
  final double total;
  final OrderStatus status;
  final PaymentStatus paymentStatus;
  final String? couponCode;
  final AddressEntity shippingAddress;
  final AddressEntity? billingAddress;
  final DateTime createdAt;
  final DateTime? shippedAt;
  final DateTime? deliveredAt;
  final DateTime? cancelledAt;

  const OrderEntity({
    required this.id,
    required this.userId,
    required this.orderNumber,
    required this.items,
    required this.subtotal,
    required this.discount,
    required this.tax,
    required this.shippingCost,
    required this.total,
    required this.status,
    required this.paymentStatus,
    this.couponCode,
    required this.shippingAddress,
    this.billingAddress,
    required this.createdAt,
    this.shippedAt,
    this.deliveredAt,
    this.cancelledAt,
  });

  /// Verifica si la orden puede ser cancelada
  bool get canBeCancelled {
    return status == OrderStatus.pendingPayment || status == OrderStatus.processing;
  }

  /// Verifica si la orden está completada
  bool get isCompleted => status == OrderStatus.delivered || status == OrderStatus.completed;

  /// Obtiene el número total de items
  int get totalItems {
    return items.fold(0, (sum, item) => sum + item.quantity);
  }

  /// Obtiene el texto del estado de la orden
  String get statusText {
    switch (status) {
      case OrderStatus.pendingPayment:
        return 'Esperando Pago';
      case OrderStatus.processing:
        return 'Procesando';
      case OrderStatus.shipped:
        return 'Enviada';
      case OrderStatus.delivered:
        return 'Entregada';
      case OrderStatus.cancelled:
        return 'Cancelada';
      case OrderStatus.failed:
        return 'Fallida';
      case OrderStatus.completed:
        return 'Completada';
      case OrderStatus.refunded:
        return 'Reembolsada';
    }
  }

  /// Obtiene el texto del estado de pago
  String get paymentStatusText {
    switch (paymentStatus) {
      case PaymentStatus.pending:
        return 'Pendiente';
      case PaymentStatus.paid:
        return 'Pagada';
      case PaymentStatus.failed:
        return 'Fallo en Pago';
      case PaymentStatus.cancelled:
        return 'Cancelada';
      case PaymentStatus.refunded:
        return 'Reembolsada';
      case PaymentStatus.processing:
        return 'Procesando';
    }
  }

  @override
  List<Object?> get props => [
        id,
        userId,
        orderNumber,
        items,
        subtotal,
        discount,
        tax,
        shippingCost,
        total,
        status,
        paymentStatus,
        couponCode,
        shippingAddress,
        billingAddress,
        createdAt,
        shippedAt,
        deliveredAt,
        cancelledAt,
      ];
}

/// Item de una orden
class OrderItemEntity extends Equatable {
  final String id;
  final String productId;
  final String name;
  final String? image;
  final double price;
  final int quantity;
  final double total;

  const OrderItemEntity({
    required this.id,
    required this.productId,
    required this.name,
    this.image,
    required this.price,
    required this.quantity,
    required this.total,
  });

  @override
  List<Object?> get props => [
        id,
        productId,
        name,
        image,
        price,
        quantity,
        total,
      ];
}

/// Dirección de una orden
class AddressEntity extends Equatable {
  final String id;
  final String firstName;
  final String lastName;
  final String street;
  final String city;
  final String state;
  final String zipCode;
  final String country;
  final String? phone;

  const AddressEntity({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.street,
    required this.city,
    required this.state,
    required this.zipCode,
    required this.country,
    this.phone,
  });

  /// Obtiene la dirección completa formateada
  String get fullAddress {
    return '$street, $city, $state $zipCode, $country';
  }

  /// Obtiene el nombre completo
  String get fullName {
    return '$firstName $lastName';
  }

  @override
  List<Object?> get props => [
        id,
        firstName,
        lastName,
        street,
        city,
        state,
        zipCode,
        country,
        phone,
      ];
}

/// Estados de la orden - Coincide con OrderStatusEnum del backend
enum OrderStatus {
  pendingPayment('PENDING_PAYMENT'),
  processing('PROCESSING'),
  shipped('SHIPPED'),
  delivered('DELIVERED'),
  cancelled('CANCELLED'),
  failed('FAILED'),
  completed('COMPLETED'),
  refunded('REFUNDED');

  const OrderStatus(this.value);
  final String value;
}

/// Estados de pago - Coincide con PaymentStatusEnum del backend
enum PaymentStatus {
  pending('PENDING'),
  paid('PAID'),
  failed('FAILED'),
  cancelled('CANCELLED'),
  refunded('REFUNDED'),
  processing('PROCESSING');

  const PaymentStatus(this.value);
  final String value;
}

/// Métodos de pago - Coincide con PaymentMethodEnum del backend
enum PaymentMethod {
  card('CARD'),
  qr('QR'),
  paypal('PAYPAL'),
  bankTransfer('BANK_TRANSFER');

  const PaymentMethod(this.value);
  final String value;
} 