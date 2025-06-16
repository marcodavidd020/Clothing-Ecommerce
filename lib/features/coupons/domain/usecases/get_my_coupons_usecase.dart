import 'package:dartz/dartz.dart';
import 'package:flutter_application_ecommerce/core/error/failures.dart';
import '../entities/coupon_entity.dart';
import '../repositories/coupon_repository.dart';

/// Caso de uso para obtener los cupones del usuario
class GetMyCouponsUseCase {
  final CouponRepository _repository;

  GetMyCouponsUseCase(this._repository);

  /// Ejecuta el caso de uso para obtener todos los cupones del usuario
  Future<Either<Failure, List<CouponEntity>>> execute() async {
    return await _repository.getMyCoupons();
  }
} 