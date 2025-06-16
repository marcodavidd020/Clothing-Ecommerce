import 'package:dartz/dartz.dart';
import 'package:flutter_application_ecommerce/core/error/failures.dart';
import '../../domain/entities/coupon_entity.dart';
import '../../domain/repositories/coupon_repository.dart';
import '../datasources/coupon_api_datasource.dart';

class CouponRepositoryImpl implements CouponRepository {
  final CouponApiDataSource _apiDataSource;

  CouponRepositoryImpl({
    required CouponApiDataSource apiDataSource,
  }) : _apiDataSource = apiDataSource;

  @override
  Future<Either<Failure, List<CouponEntity>>> getMyCoupons() async {
    try {
      final couponsApiModels = await _apiDataSource.getMyCoupons();
      final coupons = couponsApiModels.map((model) => model.toEntity()).toList();
      return Right(coupons);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, CouponEntity>> applyCoupon(String code) async {
    try {
      final couponApiModel = await _apiDataSource.applyCoupon(code);
      final coupon = couponApiModel.toEntity();
      return Right(coupon);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> removeCoupon(String couponId) async {
    try {
      await _apiDataSource.removeCoupon(couponId);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
} 