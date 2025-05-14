import 'package:flutter_application_ecommerce/core/constants/app_strings.dart';

/// Clase auxiliar para validación de campos de formularios en el módulo de autenticación.
class AuthFormValidators {
  /// Constructor privado para prevenir instanciación
  AuthFormValidators._();

  /// Valida un campo de email
  ///
  /// Retorna mensaje de error si es inválido, null si es válido
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return AppStrings.enterEmailError;
    }

    final regex = RegExp(r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$");
    if (!regex.hasMatch(value)) {
      return AppStrings.invalidEmailError;
    }

    return null;
  }

  /// Valida un campo de contraseña
  ///
  /// Retorna mensaje de error si es inválido, null si es válido
  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return AppStrings.enterPasswordError;
    }

    if (value.length < 6) {
      return AppStrings.invalidPasswordError;
    }

    return null;
  }

  /// Valida un campo de nombre
  ///
  /// Retorna mensaje de error si está vacío, null si es válido
  static String? validateName(String? value) {
    return value == null || value.isEmpty
        ? AppStrings.enterFirstnameError
        : null;
  }

  /// Valida un campo de apellido
  ///
  /// Retorna mensaje de error si está vacío, null si es válido
  static String? validateLastName(String? value) {
    return value == null || value.isEmpty
        ? AppStrings.enterLastnameError
        : null;
  }

  /// Valida un campo de teléfono (opcional)
  ///
  /// Si está presente, verifica que tenga un formato válido
  /// Retorna mensaje de error si es inválido, null si es válido o está vacío
  static String? validatePhone(String? value) {
    // Si el teléfono está vacío, es válido porque es opcional
    if (value == null || value.isEmpty) {
      return null;
    }

    // Expresión regular para validar números de teléfono (permite formato internacional)
    final regex = RegExp(r'^\+?[0-9]{9,15}$');
    if (!regex.hasMatch(value)) {
      return AppStrings.invalidPhoneError;
    }

    return null;
  }
}
