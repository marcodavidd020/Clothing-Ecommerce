import 'package:flutter/material.dart';
import '../constants/constants.dart';

/// Define el tema global de la aplicación.
///
/// Incluye configuraciones para la familia de fuentes por defecto, esquema de colores,
/// color de fondo de Scaffold, y estilos para componentes como [InputDecorationTheme].
class AppTheme {
  /// Tema claro para la aplicación.
  static ThemeData get light => ThemeData(
    fontFamily: 'Gabarito',
    colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primary),
    scaffoldBackgroundColor: AppColors.white,
    textTheme: TextTheme(
      headlineSmall: AppTextStyles.heading,
      bodyMedium: AppTextStyles.inputHint,
      bodyLarge: AppTextStyles.button,
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.inputFill,
      hintStyle: AppTextStyles.inputHint,
      contentPadding: const EdgeInsets.symmetric(
        vertical: AppDimens.contentPaddingVertical,
        horizontal: AppDimens.contentPaddingHorizontal,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppDimens.buttonRadius / 12),
        borderSide: BorderSide.none,
      ),
    ),
  );
}
