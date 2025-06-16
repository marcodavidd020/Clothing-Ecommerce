import '../../domain/entities/coupon_entity.dart';

/// Modelo para el cupón obtenido desde la API
class CouponApiModel {
  final String id;
  final String code;
  final String name;
  final String description;
  final String type;
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

  CouponApiModel({
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

  factory CouponApiModel.fromJson(Map<String, dynamic> json) {
    return CouponApiModel(
      id: json['id'] as String? ?? '',
      code: json['code'] as String? ?? '',
      name: json['name'] as String? ?? '',
      description: json['description'] as String? ?? '',
      type: json['type'] as String? ?? 'percentage',
      value: double.tryParse(json['value']?.toString() ?? '0') ?? 0.0,
      minimumAmount: json['minimumAmount'] != null 
          ? double.tryParse(json['minimumAmount'].toString())
          : null,
      maxUses: json['maxUses'] as int?,
      currentUses: json['currentUses'] as int? ?? 0,
      validFrom: json['validFrom'] != null
          ? DateTime.parse(json['validFrom'] as String)
          : DateTime.now(),
      validUntil: json['validUntil'] != null
          ? DateTime.parse(json['validUntil'] as String)
          : DateTime.now().add(Duration(days: 30)),
      isActive: json['isActive'] as bool? ?? true,
      isUsed: json['isUsed'] as bool? ?? false,
      usedAt: json['usedAt'] != null
          ? DateTime.parse(json['usedAt'] as String)
          : null,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : DateTime.now(),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'] as String)
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'code': code,
      'name': name,
      'description': description,
      'type': type,
      'value': value,
      'minimumAmount': minimumAmount,
      'maxUses': maxUses,
      'currentUses': currentUses,
      'validFrom': validFrom.toIso8601String(),
      'validUntil': validUntil.toIso8601String(),
      'isActive': isActive,
      'isUsed': isUsed,
      'usedAt': usedAt?.toIso8601String(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  /// Convierte el modelo API a entidad de dominio
  CouponEntity toEntity() {
    return CouponEntity(
      id: id,
      code: code,
      name: name,
      description: description,
      type: _stringToCouponType(type),
      value: value,
      minimumAmount: minimumAmount,
      maxUses: maxUses,
      currentUses: currentUses,
      validFrom: validFrom,
      validUntil: validUntil,
      isActive: isActive,
      isUsed: isUsed,
      usedAt: usedAt,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  /// Convierte string a CouponType
  CouponType _stringToCouponType(String type) {
    switch (type.toLowerCase()) {
      case 'percentage':
        return CouponType.percentage;
      case 'fixed':
        return CouponType.fixed;
      default:
        return CouponType.percentage;
    }
  }

  /// Convierte CouponType a string
  static String _couponTypeToString(CouponType type) {
    switch (type) {
      case CouponType.percentage:
        return 'percentage';
      case CouponType.fixed:
        return 'fixed';
    }
  }

  /// Crea un modelo desde una entidad de dominio
  factory CouponApiModel.fromEntity(CouponEntity entity) {
    return CouponApiModel(
      id: entity.id,
      code: entity.code,
      name: entity.name,
      description: entity.description,
      type: _couponTypeToString(entity.type),
      value: entity.value,
      minimumAmount: entity.minimumAmount,
      maxUses: entity.maxUses,
      currentUses: entity.currentUses,
      validFrom: entity.validFrom,
      validUntil: entity.validUntil,
      isActive: entity.isActive,
      isUsed: entity.isUsed,
      usedAt: entity.usedAt,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }
} 