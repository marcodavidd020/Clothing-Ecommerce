import 'package:dartz/dartz.dart';
import 'package:flutter_application_ecommerce/core/error/failures.dart';
import '../entities/payment_entity.dart';

/// Repositorio abstracto para manejar pagos
abstract class PaymentRepository {
  /// Crea un nuevo pago
  Future<Either<Failure, PaymentEntity>> createPayment({
    required String orderId,
    required double amount,
    required PaymentMethod method,
  });

  /// Obtiene los métodos de pago disponibles
  Future<Either<Failure, List<PaymentMethod>>> getPaymentMethods();

  /// Obtiene un pago por su ID
  Future<Either<Failure, PaymentEntity>> getPayment(String paymentId);

  /// Procesa un pago
  Future<Either<Failure, PaymentEntity>> processPayment({
    required String paymentId,
    required Map<String, dynamic> paymentData,
  });

  /// Obtiene el historial de pagos del usuario
  Future<Either<Failure, List<PaymentEntity>>> getMyPayments();
} 