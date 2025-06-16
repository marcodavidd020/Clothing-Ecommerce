part of 'coupon_bloc.dart';

@immutable
abstract class CouponEvent {}

/// Evento para cargar los cupones del usuario
class LoadMyCoupons extends CouponEvent {}

/// Evento para aplicar un cupón
class ApplyCoupon extends CouponEvent {
  final String code;

  ApplyCoupon({required this.code});
}

/// Evento para remover un cupón aplicado
class RemoveCoupon extends CouponEvent {
  final String couponId;

  RemoveCoupon({required this.couponId});
}

/// Evento para filtrar cupones por estado
class FilterCoupons extends CouponEvent {
  final CouponFilterType filterType;

  FilterCoupons({required this.filterType});
}

/// Tipo de filtro para cupones
enum CouponFilterType {
  all,
  available,
  used,
  expired,
} 