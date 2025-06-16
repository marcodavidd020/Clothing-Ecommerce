import '../../domain/entities/order_entity.dart';

/// Modelo para la orden obtenida desde la API
class OrderApiModel {
  final String id;
  final String userId;
  final List<OrderItemApiModel> items;
  final String shippingAddressId;
  final String billingAddressId;
  final double subtotal;
  final double taxAmount;
  final double shippingAmount;
  final double discountAmount;
  final double totalAmount;
  final String status;
  final String paymentStatus;
  final String? paymentMethod;
  final String? notes;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? shippedAt;
  final DateTime? deliveredAt;

  OrderApiModel({
    required this.id,
    required this.userId,
    required this.items,
    required this.shippingAddressId,
    required this.billingAddressId,
    required this.subtotal,
    required this.taxAmount,
    required this.shippingAmount,
    required this.discountAmount,
    required this.totalAmount,
    required this.status,
    required this.paymentStatus,
    this.paymentMethod,
    this.notes,
    required this.createdAt,
    required this.updatedAt,
    this.shippedAt,
    this.deliveredAt,
  });

  factory OrderApiModel.fromJson(Map<String, dynamic> json) {
    final itemsList = json['items'] != null
        ? (json['items'] as List)
            .map((i) => OrderItemApiModel.fromJson(i))
            .toList()
        : <OrderItemApiModel>[];

    return OrderApiModel(
      id: json['id'] as String? ?? '',
      userId: json['userId'] as String? ?? '',
      items: itemsList,
      shippingAddressId: json['shippingAddressId'] as String? ?? '',
      billingAddressId: json['billingAddressId'] as String? ?? '',
      subtotal: double.tryParse(json['subtotal']?.toString() ?? '0') ?? 0.0,
      taxAmount: double.tryParse(json['taxAmount']?.toString() ?? '0') ?? 0.0,
      shippingAmount: double.tryParse(json['shippingAmount']?.toString() ?? '0') ?? 0.0,
      discountAmount: double.tryParse(json['discountAmount']?.toString() ?? '0') ?? 0.0,
      totalAmount: double.tryParse(json['totalAmount']?.toString() ?? '0') ?? 0.0,
      status: json['status'] as String? ?? 'PENDING_PAYMENT',
      paymentStatus: json['paymentStatus'] as String? ?? 'PENDING',
      paymentMethod: json['paymentMethod'] as String?,
      notes: json['notes'] as String?,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : DateTime.now(),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'] as String)
          : DateTime.now(),
      shippedAt: json['shippedAt'] != null
          ? DateTime.parse(json['shippedAt'] as String)
          : null,
      deliveredAt: json['deliveredAt'] != null
          ? DateTime.parse(json['deliveredAt'] as String)
          : null,
    );
  }

  /// Convierte el modelo API a entidad de dominio
  OrderEntity toEntity() {
    return OrderEntity(
      id: id,
      userId: userId,
      orderNumber: 'ORD-$id',
      items: items.map((item) => item.toEntity()).toList(),
      subtotal: subtotal,
      discount: discountAmount,
      tax: taxAmount,
      shippingCost: shippingAmount,
      total: totalAmount,
      status: _stringToOrderStatus(status),
      paymentStatus: _stringToPaymentStatus(paymentStatus),
      couponCode: null,
      shippingAddress: AddressEntity(
        id: shippingAddressId,
        firstName: 'Usuario',
        lastName: 'Cliente',
        street: 'Dirección de envío',
        city: 'Ciudad',
        state: 'Estado',
        zipCode: '00000',
        country: 'País',
      ),
      billingAddress: AddressEntity(
        id: billingAddressId,
        firstName: 'Usuario',
        lastName: 'Cliente',
        street: 'Dirección de facturación',
        city: 'Ciudad',
        state: 'Estado',
        zipCode: '00000',
        country: 'País',
      ),
      createdAt: createdAt,
      shippedAt: shippedAt,
      deliveredAt: deliveredAt,
    );
  }

  OrderStatus _stringToOrderStatus(String status) {
    switch (status.toUpperCase()) {
      case 'PENDING_PAYMENT':
        return OrderStatus.pendingPayment;
      case 'PROCESSING':
        return OrderStatus.processing;
      case 'SHIPPED':
        return OrderStatus.shipped;
      case 'DELIVERED':
        return OrderStatus.delivered;
      case 'CANCELLED':
        return OrderStatus.cancelled;
      case 'FAILED':
        return OrderStatus.failed;
      case 'COMPLETED':
        return OrderStatus.completed;
      case 'REFUNDED':
        return OrderStatus.refunded;
      default:
        return OrderStatus.pendingPayment;
    }
  }

  PaymentStatus _stringToPaymentStatus(String status) {
    switch (status.toUpperCase()) {
      case 'PENDING':
        return PaymentStatus.pending;
      case 'PAID':
        return PaymentStatus.paid;
      case 'FAILED':
        return PaymentStatus.failed;
      case 'CANCELLED':
        return PaymentStatus.cancelled;
      case 'REFUNDED':
        return PaymentStatus.refunded;
      case 'PROCESSING':
        return PaymentStatus.processing;
      default:
        return PaymentStatus.pending;
    }
  }
}

/// Modelo para item de orden desde la API
class OrderItemApiModel {
  final String id;
  final String productVariantId;
  final String productName;
  final String productImage;
  final String? color;
  final String? size;
  final double price;
  final int quantity;
  final double total;

  OrderItemApiModel({
    required this.id,
    required this.productVariantId,
    required this.productName,
    required this.productImage,
    this.color,
    this.size,
    required this.price,
    required this.quantity,
    required this.total,
  });

  factory OrderItemApiModel.fromJson(Map<String, dynamic> json) {
    return OrderItemApiModel(
      id: json['id'] as String? ?? '',
      productVariantId: json['productVariantId'] as String? ?? '',
      productName: json['productName'] as String? ?? '',
      productImage: json['productImage'] as String? ?? '',
      color: json['color'] as String?,
      size: json['size'] as String?,
      price: double.tryParse(json['price']?.toString() ?? '0') ?? 0.0,
      quantity: json['quantity'] as int? ?? 1,
      total: double.tryParse(json['total']?.toString() ?? '0') ?? 0.0,
    );
  }

  /// Convierte el modelo API a entidad de dominio
  OrderItemEntity toEntity() {
    return OrderItemEntity(
      id: id,
      productId: productVariantId,
      name: productName,
      image: productImage,
      price: price,
      quantity: quantity,
      total: total,
    );
  }
}

/// Modelo para crear una nueva orden
class CreateOrderApiModel {
  final List<CreateOrderItemApiModel> items;
  final String shippingAddressId;
  final String billingAddressId;
  final String? paymentMethod;
  final String? notes;
  final String? couponCode;

  CreateOrderApiModel({
    required this.items,
    required this.shippingAddressId,
    required this.billingAddressId,
    this.paymentMethod,
    this.notes,
    this.couponCode,
  });

  Map<String, dynamic> toJson() {
    return {
      'items': items.map((item) => item.toJson()).toList(),
      'shippingAddressId': shippingAddressId,
      'billingAddressId': billingAddressId,
      'paymentMethod': paymentMethod,
      'notes': notes,
      'couponCode': couponCode,
    };
  }
}

/// Modelo para item de orden a crear
class CreateOrderItemApiModel {
  final String productVariantId;
  final int quantity;

  CreateOrderItemApiModel({
    required this.productVariantId,
    required this.quantity,
  });

  Map<String, dynamic> toJson() {
    return {
      'productVariantId': productVariantId,
      'quantity': quantity,
    };
  }
} 