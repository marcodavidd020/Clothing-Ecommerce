import 'package:flutter/material.dart';
import 'package:flutter_application_ecommerce/core/constants/constants.dart';
import 'package:flutter_application_ecommerce/core/widgets/widgets.dart';

/// Clase auxiliar para construir componentes de UI comunes en pantallas de autenticación
class AuthUIHelpers {
  /// Constructor privado para prevenir instanciación
  AuthUIHelpers._();

  /// Construye un título de pantalla de autenticación
  static Widget buildAuthTitle(String title) {
    return Text(title, style: AppTextStyles.heading);
  }

  /// Construye un espacio vertical estándar pequeño
  static Widget get smallVerticalSpace =>
      const SizedBox(height: AppDimens.vSpace16);

  /// Construye un espacio vertical estándar mediano
  static Widget get mediumVerticalSpace =>
      const SizedBox(height: AppDimens.vSpace32);

  /// Construye un botón primario para acciones de autenticación
  static Widget buildPrimaryButton({
    required String label,
    required VoidCallback onPressed,
    bool isLoading = false,
  }) {
    return PrimaryButton(
      label: label,
      onPressed: onPressed,
      isLoading: isLoading,
    );
  }

  /// Construye un indicador de carga centrado
  static Widget get loadingIndicator =>
      const Center(child: CircularProgressIndicator());

  /// Muestra un mensaje de error
  static void showErrorMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.redAccent,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  /// Construye un campo de texto para email
  static Widget buildEmailField({
    required TextEditingController controller,
    required String? Function(String?) validator,
    bool enabled = true,
  }) {
    return CustomTextField(
      controller: controller,
      hintText: AppStrings.emailHint,
      keyboardType: TextInputType.emailAddress,
      validator: validator,
      enabled: enabled,
    );
  }

  /// Construye un campo de texto para contraseña
  static Widget buildPasswordField({
    required TextEditingController controller,
    required String? Function(String?) validator,
    bool enabled = true,
  }) {
    return CustomTextField(
      controller: controller,
      hintText: AppStrings.passwordHint,
      obscureText: true,
      validator: validator,
      enabled: enabled,
    );
  }
}
