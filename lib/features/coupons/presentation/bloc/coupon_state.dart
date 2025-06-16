part of 'coupon_bloc.dart';

@immutable
abstract class CouponState {}

/// Estado inicial
class CouponInitial extends CouponState {}

/// Estado de carga
class CouponLoading extends CouponState {}

/// Estado con cupones cargados exitosamente
class CouponLoaded extends CouponState {
  final List<CouponEntity> coupons;
  final List<CouponEntity> filteredCoupons;
  final CouponFilterType currentFilter;
  final String? appliedCouponCode;

  CouponLoaded({
    required this.coupons,
    required this.filteredCoupons,
    required this.currentFilter,
    this.appliedCouponCode,
  });

  /// Crea una copia del estado con nuevos valores
  CouponLoaded copyWith({
    List<CouponEntity>? coupons,
    List<CouponEntity>? filteredCoupons,
    CouponFilterType? currentFilter,
    String? appliedCouponCode,
    bool clearAppliedCoupon = false,
  }) {
    return CouponLoaded(
      coupons: coupons ?? this.coupons,
      filteredCoupons: filteredCoupons ?? this.filteredCoupons,
      currentFilter: currentFilter ?? this.currentFilter,
      appliedCouponCode: clearAppliedCoupon ? null : (appliedCouponCode ?? this.appliedCouponCode),
    );
  }

  /// Obtiene cupones disponibles
  List<CouponEntity> get availableCoupons {
    return coupons.where((coupon) => coupon.isValidForUse).toList();
  }

  /// Obtiene cupones usados
  List<CouponEntity> get usedCoupons {
    return coupons.where((coupon) => coupon.isUsed).toList();
  }

  /// Obtiene cupones expirados
  List<CouponEntity> get expiredCoupons {
    return coupons.where((coupon) => coupon.isExpired).toList();
  }
}

/// Estado de aplicación de cupón exitosa
class CouponApplied extends CouponState {
  final CouponEntity appliedCoupon;
  final String message;

  CouponApplied({
    required this.appliedCoupon,
    required this.message,
  });
}

/// Estado de cupón removido exitosamente
class CouponRemoved extends CouponState {
  final String message;

  CouponRemoved({required this.message});
}

/// Estado de error
class CouponError extends CouponState {
  final String message;

  CouponError({required this.message});
} 