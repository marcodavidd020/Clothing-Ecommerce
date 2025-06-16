import 'package:dartz/dartz.dart';
import 'package:flutter_application_ecommerce/core/error/failures.dart';
import '../entities/order_entity.dart';
import '../repositories/order_repository.dart';
import '../../../addresses/domain/entities/address_entity.dart' as address_entities;

class CreateOrderUseCase {
  final OrderRepository _repository;

  CreateOrderUseCase(this._repository);

  Future<Either<Failure, OrderEntity>> execute({
    required List<OrderItemEntity> items,
    required address_entities.AddressEntity shippingAddress,
    address_entities.AddressEntity? billingAddress,
    String? couponCode,
  }) async {
    return await _repository.createOrder(
      items: items,
      shippingAddress: shippingAddress,
      billingAddress: billingAddress,
      couponCode: couponCode,
    );
  }
} 