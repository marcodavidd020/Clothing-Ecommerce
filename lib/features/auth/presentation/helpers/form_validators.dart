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
} 