import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_text_styles.dart';

/// Un [TextFormField] personalizado y reutilizable con un estilo predefinido.
///
/// Simplifica la creación de campos de texto consistentes en la aplicación.
class CustomTextField extends StatelessWidget {
  /// Controlador para el campo de texto.
  final TextEditingController controller;

  /// Texto que se muestra como placeholder cuando el campo está vacío.
  final String hintText;

  /// Tipo de teclado que se mostrará.
  final TextInputType? keyboardType;

  /// Si es `true`, el texto se ofuscará (útil para contraseñas).
  final bool obscureText;

  /// Función validadora para el campo de texto.
  final String? Function(String?)? validator;

  /// Crea una instancia de [CustomTextField].
  const CustomTextField({
    super.key,
    required this.controller,
    required this.hintText,
    this.keyboardType,
    this.obscureText = false,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      style: AppTextStyles.inputText,
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText,
      validator: validator,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: AppTextStyles.inputHint,
        filled: true,
        fillColor: AppColors.inputFill,
        contentPadding: const EdgeInsets.symmetric(
          vertical: 16,
          horizontal: 16,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
