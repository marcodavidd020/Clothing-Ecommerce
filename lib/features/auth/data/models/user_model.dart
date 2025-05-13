import 'package:flutter_application_ecommerce/features/auth/domain/entities/user_entity.dart';

/// Modelo para mapear datos de usuario desde y hacia fuentes de datos.
class UserModel extends UserEntity {
  /// Crea una instancia de [UserModel].
  UserModel({required String id, required String email})
    : super(id: id, email: email);

  /// Crea una instancia de [UserModel] desde un mapa (por ejemplo, JSON).
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(id: json['id'] as String, email: json['email'] as String);
  }

  /// Convierte este modelo a un mapa (por ejemplo, para enviar a una API).
  Map<String, dynamic> toJson() {
    return {'id': id, 'email': email};
  }
}
