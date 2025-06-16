import 'package:dartz/dartz.dart';
import 'package:flutter_application_ecommerce/core/error/failures.dart';
import '../entities/coupon_entity.dart';
import '../repositories/coupon_repository.dart';

/// Caso de uso para aplicar un cupón
class ApplyCouponUseCase {
  final CouponRepository _repository;

  ApplyCouponUseCase(this._repository);

  /// Ejecuta el caso de uso para aplicar un cupón
  Future<Either<Failure, CouponEntity>> execute(String code) async {
    return await _repository.applyCoupon(code);
  }
} 