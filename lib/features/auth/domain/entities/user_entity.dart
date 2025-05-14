/// Representa la entidad de usuario en el dominio.
class UserEntity {
  /// ID único del usuario.
  final String id;

  /// Correo electrónico del usuario.
  final String email;

  /// Nombre de pila del usuario (opcional).
  final String? firstName;

  /// Apellido del usuario (opcional).
  final String? lastName;

  /// Número de teléfono del usuario (opcional).
  final String? phoneNumber;

  /// Indica si la cuenta del usuario está activa.
  final bool isActive;

  /// URL del avatar del usuario (opcional).
  final String? avatar;

  /// Fecha de creación de la cuenta (opcional).
  final DateTime? createdAt;

  /// Fecha de la última actualización de la cuenta (opcional).
  final DateTime? updatedAt;

  /// Token de acceso JWT (opcional, puede no estar siempre presente en la entidad).
  final String? accessToken;

  /// Token de refresco JWT (opcional).
  final String? refreshToken;

  /// Crea una instancia de [UserEntity].
  const UserEntity({
    required this.id,
    required this.email,
    this.firstName,
    this.lastName,
    this.phoneNumber,
    this.isActive = false,
    this.avatar,
    this.createdAt,
    this.updatedAt,
    this.accessToken,
    this.refreshToken,
  });

  /// Nombre completo del usuario, si están disponibles el nombre y el apellido.
  String? get fullName {
    if (firstName != null && lastName != null) {
      return '$firstName $lastName';
    } else if (firstName != null) {
      return firstName;
    } else if (lastName != null) {
      return lastName;
    }
    return null;
  }

  @override
  List<Object?> get props => [
        id,
        email,
        firstName,
        lastName,
        phoneNumber,
        isActive,
        avatar,
        createdAt,
        updatedAt,
        accessToken,
        refreshToken,
      ];

  // Para que Equatable funcione correctamente si se usa.
  // Si no usas Equatable, puedes quitar esto y el `extends Equatable` si lo tuvieras.
  // @override
  // bool get stringify => true; // Descomentar si se usa Equatable
}
