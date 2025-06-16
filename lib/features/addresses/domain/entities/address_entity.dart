import 'package:equatable/equatable.dart';

/// Entidad que representa una dirección en el dominio
/// Coincide con la estructura del backend Address entity
class AddressEntity extends Equatable {
  final String id;
  final String fullName;
  final String phoneNumber;
  final double latitude;
  final double longitude;
  final String street;
  final String city;
  final String department;
  final String postalCode;
  final bool isDefault;
  final bool isActive;
  final String userId;
  final DateTime createdAt;
  final DateTime updatedAt;

  const AddressEntity({
    required this.id,
    required this.fullName,
    required this.phoneNumber,
    required this.latitude,
    required this.longitude,
    required this.street,
    required this.city,
    required this.department,
    required this.postalCode,
    required this.isDefault,
    required this.isActive,
    required this.userId,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Obtiene la dirección completa formateada
  String get fullAddress {
    return '$street, $city, $department $postalCode';
  }

  /// Obtiene la dirección corta
  String get shortAddress {
    return '$city, $department';
  }

  /// Verifica si la dirección tiene coordenadas válidas
  bool get hasValidCoordinates {
    return latitude != 0.0 && longitude != 0.0;
  }

  @override
  List<Object?> get props => [
        id,
        fullName,
        phoneNumber,
        latitude,
        longitude,
        street,
        city,
        department,
        postalCode,
        isDefault,
        isActive,
        userId,
        createdAt,
        updatedAt,
      ];
} 