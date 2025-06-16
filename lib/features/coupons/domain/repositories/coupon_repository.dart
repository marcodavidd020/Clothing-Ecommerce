import 'package:dartz/dartz.dart';
import 'package:flutter_application_ecommerce/core/error/failures.dart';
import '../entities/coupon_entity.dart';

abstract class CouponRepository {
  Future<Either<Failure, List<CouponEntity>>> getMyCoupons();
  Future<Either<Failure, CouponEntity>> applyCoupon(String code);
  Future<Either<Failure, void>> removeCoupon(String couponId);
} 