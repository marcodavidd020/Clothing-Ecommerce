import 'package:equatable/equatable.dart';

/// Entidad que representa un pago en el dominio
class PaymentEntity extends Equatable {
  final String id;
  final String orderId;
  final double amount;
  final String currency;
  final PaymentMethod method;
  final PaymentStatus status;
  final String? transactionId;
  final String? gatewayResponse;
  final DateTime createdAt;
  final DateTime? paidAt;
  final DateTime? failedAt;

  const PaymentEntity({
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

  /// Verifica si el pago fue exitoso
  bool get isSuccessful => status == PaymentStatus.paid;

  /// Verifica si el pago está pendiente
  bool get isPending => status == PaymentStatus.pending;

  /// Verifica si el pago falló
  bool get isFailed => status == PaymentStatus.failed;

  /// Obtiene el texto del método de pago
  String get methodText {
    switch (method) {
      case PaymentMethod.card:
        return 'Tarjeta';
      case PaymentMethod.qr:
        return 'Código QR';
      case PaymentMethod.paypal:
        return 'PayPal';
      case PaymentMethod.bankTransfer:
        return 'Transferencia Bancaria';
    }
  }

  /// Obtiene el texto del estado
  String get statusText {
    switch (status) {
      case PaymentStatus.pending:
        return 'Pendiente';
      case PaymentStatus.processing:
        return 'Procesando';
      case PaymentStatus.paid:
        return 'Pagado';
      case PaymentStatus.failed:
        return 'Fallido';
      case PaymentStatus.cancelled:
        return 'Cancelado';
      case PaymentStatus.refunded:
        return 'Reembolsado';
    }
  }

  @override
  List<Object?> get props => [
        id,
        orderId,
        amount,
        currency,
        method,
        status,
        transactionId,
        gatewayResponse,
        createdAt,
        paidAt,
        failedAt,
      ];
}

/// Método de pago
/// Métodos de pago disponibles - Coincide con PaymentMethodEnum del backend
enum PaymentMethod {
  card('CARD'),
  qr('QR'),
  paypal('PAYPAL'),
  bankTransfer('BANK_TRANSFER');

  const PaymentMethod(this.value);
  final String value;
}

/// Estados del pago - Coincide con PaymentStatusEnum del backend
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