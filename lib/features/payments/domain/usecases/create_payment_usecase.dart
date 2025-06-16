import 'package:dartz/dartz.dart';
import 'package:flutter_application_ecommerce/core/error/failures.dart';
import '../entities/payment_entity.dart';
import '../repositories/payment_repository.dart';

class CreatePaymentUseCase {
  final PaymentRepository _repository;

  CreatePaymentUseCase(this._repository);

  Future<Either<Failure, PaymentEntity>> execute({
    required String orderId,
    required double amount,
    required PaymentMethod method,
  }) async {
    return await _repository.createPayment(
      orderId: orderId,
      amount: amount,
      method: method,
    );
  }
} 