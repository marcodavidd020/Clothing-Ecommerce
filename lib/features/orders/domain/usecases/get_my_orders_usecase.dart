import 'package:dartz/dartz.dart';
import 'package:flutter_application_ecommerce/core/error/failures.dart';
import '../entities/order_entity.dart';
import '../repositories/order_repository.dart';

class GetMyOrdersUseCase {
  final OrderRepository _repository;

  GetMyOrdersUseCase(this._repository);

  Future<Either<Failure, List<OrderEntity>>> execute() async {
    return await _repository.getMyOrders();
  }
} 