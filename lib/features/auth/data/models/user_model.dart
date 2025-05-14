import 'package:flutter_application_ecommerce/features/auth/domain/entities/user_entity.dart';

/// Modelo para mapear datos de usuario desde y hacia fuentes de datos.
class UserModel extends UserEntity {
  /// Crea una instancia de [UserModel].
  UserModel({
    required String id,
    required String email,
    String? firstName,
    String? lastName,
    String? phoneNumber,
    bool isActive = false,
    String? avatar,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? accessToken,
    String? refreshToken,
  }) : super(
          id: id,
          email: email,
          firstName: firstName,
          lastName: lastName,
          phoneNumber: phoneNumber,
          isActive: isActive,
          avatar: avatar,
          createdAt: createdAt,
          updatedAt: updatedAt,
          accessToken: accessToken,
          refreshToken: refreshToken,
        );

  /// Crea una instancia de [UserModel] desde un mapa (por ejemplo, JSON de perfil de usuario).
  /// Este factory es para un JSON que describe al usuario, no la respuesta de login.
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      email: json['email'] as String,
      firstName: json['firstName'] as String?,
      lastName: json['lastName'] as String?,
      phoneNumber: json['phoneNumber'] as String?,
      isActive: json['isActive'] as bool? ?? false,
      avatar: json['avatar'] as String?,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'] as String)
          : null,
      accessToken: json['accessToken'] as String?,
      refreshToken: json['refreshToken'] as String?,
    );
  }

  /// Crea una instancia de [UserModel] a partir de la respuesta de la API de inicio de sesión.
  factory UserModel.fromLoginResponse(
      Map<String, dynamic> loginResponseJson, String emailForUser) {
    final data = loginResponseJson['data'] as Map<String, dynamic>?;
    return UserModel(
      id: data?['userId']?.toString() ?? emailForUser.split('@')[0],
      email: emailForUser,
      accessToken: data?['accessToken'] as String?,
      refreshToken: data?['refreshToken'] as String?,
      isActive: true,
    );
  }

  /// Convierte este modelo a un mapa (por ejemplo, para enviar a una API).
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      if (firstName != null) 'firstName': firstName,
      if (lastName != null) 'lastName': lastName,
      if (phoneNumber != null) 'phoneNumber': phoneNumber,
      'isActive': isActive,
      if (avatar != null) 'avatar': avatar,
      if (createdAt != null) 'createdAt': createdAt!.toIso8601String(),
      if (updatedAt != null) 'updatedAt': updatedAt!.toIso8601String(),
      if (accessToken != null) 'accessToken': accessToken,
      if (refreshToken != null) 'refreshToken': refreshToken,
    };
  }
}
