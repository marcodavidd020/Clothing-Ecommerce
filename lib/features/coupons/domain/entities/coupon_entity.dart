import 'package:equatable/equatable.dart';

/// Entidad que representa un cupón en el dominio
class CouponEntity extends Equatable {
  final String id;
  final String code;
  final String name;
  final String description;
  final CouponType type;
  final double value;
  final double? minimumAmount;
  final int? maxUses;
  final int currentUses;
  final DateTime validFrom;
  final DateTime validUntil;
  final bool isActive;
  final bool isUsed;
  final DateTime? usedAt;
  final DateTime createdAt;
  final DateTime updatedAt;

  const CouponEntity({
    required this.id,
    required this.code,
    required this.name,
    required this.description,
    required this.type,
    required this.value,
    this.minimumAmount,
    this.maxUses,
    required this.currentUses,
    required this.validFrom,
    required this.validUntil,
    required this.isActive,
    required this.isUsed,
    this.usedAt,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Verifica si el cupón está expirado
  bool get isExpired => DateTime.now().isAfter(validUntil);

  /// Verifica si el cupón es válido para usar
  bool get isValidForUse {
    final now = DateTime.now();
    return isActive &&
        !isUsed &&
        !isExpired &&
        now.isAfter(validFrom) &&
        (maxUses == null || currentUses < maxUses!);
  }

  /// Obtiene el estado actual del cupón
  CouponStatus get status {
    if (isUsed) return CouponStatus.used;
    if (isExpired) return CouponStatus.expired;
    if (!isActive) return CouponStatus.inactive;
    return CouponStatus.active;
  }

  /// Obtiene el texto de descuento formateado
  String get discountText {
    switch (type) {
      case CouponType.percentage:
        return '${value.toInt()}% OFF';
      case CouponType.fixed:
        return '\$${value.toStringAsFixed(2)} OFF';
    }
  }

  @override
  List<Object?> get props => [
        id,
        code,
        name,
        description,
        type,
        value,
        minimumAmount,
        maxUses,
        currentUses,
        validFrom,
        validUntil,
        isActive,
        isUsed,
        usedAt,
        createdAt,
        updatedAt,
      ];
}

/// Tipo de cupón
enum CouponType {
  percentage, // Porcentaje
  fixed, // Monto fijo
}

/// Estado del cupón
enum CouponStatus {
  active, // Activo
  used, // Usado
  expired, // Expirado
  inactive, // Inactivo
} 