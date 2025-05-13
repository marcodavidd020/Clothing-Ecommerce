/// Entidad de dominio para representar un usuario.
class UserEntity {
  final String id;
  final String email;
  // Puedes añadir más propiedades como nombre, etc.

  UserEntity({required this.id, required this.email});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserEntity && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}
