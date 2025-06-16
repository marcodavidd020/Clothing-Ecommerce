import '../../domain/entities/payment_entity.dart';

/// Modelo para el pago obtenido desde la API
class PaymentApiModel {
  final String id;
  final String orderId;
  final double amount;
  final String currency;
  final String method;
  final String status;
  final String? transactionId;
  final String? gatewayResponse;
  final DateTime createdAt;
  final DateTime? paidAt;
  final DateTime? failedAt;

  PaymentApiModel({
    required this.id,
    required this.orderId,
    required this.amount,
    required this.currency,
    required this.method,
    required this.status,
    this.transactionId,
    this.gatewayResponse,
    required this.createdAt,
    this.paidAt,
    this.failedAt,
  });

  factory PaymentApiModel.fromJson(Map<String, dynamic> json) {
    return PaymentApiModel(
      id: json['id'] as String? ?? '',
      orderId: json['orderId'] as String? ?? '',
      amount: double.tryParse(json['amount']?.toString() ?? '0') ?? 0.0,
      currency: json['currency'] as String? ?? 'USD',
      method: json['method'] as String? ?? 'CARD',
      status: json['status'] as String? ?? 'PENDING',
      transactionId: json['transactionId'] as String?,
      gatewayResponse: json['gatewayResponse'] as String?,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : DateTime.now(),
      paidAt: json['paidAt'] != null
          ? DateTime.parse(json['paidAt'] as String)
          : null,
      failedAt: json['failedAt'] != null
          ? DateTime.parse(json['failedAt'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'orderId': orderId,
      'amount': amount,
      'currency': currency,
      'method': method,
      'status': status,
      'transactionId': transactionId,
      'gatewayResponse': gatewayResponse,
      'createdAt': createdAt.toIso8601String(),
      'paidAt': paidAt?.toIso8601String(),
      'failedAt': failedAt?.toIso8601String(),
    };
  }

  /// Convierte el modelo API a entidad de dominio
  PaymentEntity toEntity() {
    return PaymentEntity(
      id: id,
      orderId: orderId,
      amount: amount,
      currency: currency,
      method: _stringToPaymentMethod(method),
      status: _stringToPaymentStatus(status),
      transactionId: transactionId,
      gatewayResponse: gatewayResponse,
      createdAt: createdAt,
      paidAt: paidAt,
      failedAt: failedAt,
    );
  }

  /// Convierte string a PaymentMethod
  PaymentMethod _stringToPaymentMethod(String method) {
    switch (method.toUpperCase()) {
      case 'CARD':
        return PaymentMethod.card;
      case 'QR':
        return PaymentMethod.qr;
      case 'PAYPAL':
        return PaymentMethod.paypal;
      case 'BANK_TRANSFER':
        return PaymentMethod.bankTransfer;
      default:
        return PaymentMethod.card;
    }
  }

  /// Convierte string a PaymentStatus
  PaymentStatus _stringToPaymentStatus(String status) {
    switch (status.toUpperCase()) {
      case 'PENDING':
        return PaymentStatus.pending;
      case 'PROCESSING':
        return PaymentStatus.processing;
      case 'PAID':
        return PaymentStatus.paid;
      case 'FAILED':
        return PaymentStatus.failed;
      case 'CANCELLED':
        return PaymentStatus.cancelled;
      case 'REFUNDED':
        return PaymentStatus.refunded;
      default:
        return PaymentStatus.pending;
    }
  }

  /// Crea un modelo desde una entidad de dominio
  factory PaymentApiModel.fromEntity(PaymentEntity entity) {
    return PaymentApiModel(
      id: entity.id,
      orderId: entity.orderId,
      amount: entity.amount,
      currency: entity.currency,
      method: _paymentMethodToString(entity.method),
      status: _paymentStatusToString(entity.status),
      transactionId: entity.transactionId,
      gatewayResponse: entity.gatewayResponse,
      createdAt: entity.createdAt,
      paidAt: entity.paidAt,
      failedAt: entity.failedAt,
    );
  }

  /// Convierte PaymentMethod a string
  static String _paymentMethodToString(PaymentMethod method) {
    switch (method) {
      case PaymentMethod.card:
        return 'CARD';
      case PaymentMethod.qr:
        return 'QR';
      case PaymentMethod.paypal:
        return 'PAYPAL';
      case PaymentMethod.bankTransfer:
        return 'BANK_TRANSFER';
    }
  }

  /// Convierte PaymentStatus a string
  static String _paymentStatusToString(PaymentStatus status) {
    switch (status) {
      case PaymentStatus.pending:
        return 'PENDING';
      case PaymentStatus.processing:
        return 'PROCESSING';
      case PaymentStatus.paid:
        return 'PAID';
      case PaymentStatus.failed:
        return 'FAILED';
      case PaymentStatus.cancelled:
        return 'CANCELLED';
      case PaymentStatus.refunded:
        return 'REFUNDED';
    }
  }
}

/// Modelo para crear un nuevo pago
class CreatePaymentApiModel {
  final String orderId;
  final double amount;
  final String currency;
  final String method;

  CreatePaymentApiModel({
    required this.orderId,
    required this.amount,
    required this.currency,
    required this.method,
  });

  Map<String, dynamic> toJson() {
    return {
      'orderId': orderId,
      'amount': amount,
      'currency': currency,
      'method': method,
    };
  }
} 