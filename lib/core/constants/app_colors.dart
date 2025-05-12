import 'package:flutter/material.dart';

/// Define la paleta de colores principal utilizada en la aplicación.
///
/// Incluye colores primarios, de acento, para fondos, texto, etc.
class AppColors {
  /// Color primario principal de la aplicación (ej. #8E6CEF).
  static const Color primary = Color(0xFF8E6CEF);

  /// Color de relleno para campos de entrada (ej. #F3F4F6).
  static const Color inputFill = Color(0xFFF3F4F6);

  /// Color de fondo para botones sociales (ej. #F4F4F4).
  static const Color socialBackground = Color(0xFFF4F4F4);

  /// Color oscuro para texto principal (ej. #1F2937).
  static const Color textDark = Color(0xFF1F2937);

  /// Color gris más claro para texto secundario (ej. #6B7280).
  static const Color textLight = Color(0xFF6B7280);

  /// Color blanco estándar.
  static const Color white = Colors.white;

  /// Color negro estándar.
  static const Color black = Colors.black;

  /// Color para enlaces, usualmente igual al primario.
  static const Color link = black;

  /// Color gris para texto secundario (ej. #808080).
  static const Color textGray = Color(0xFF808080);

  /// Color gris para fondo (ej. #F0F0F0).
  static const Color backgroundGray = Color(0xFFF0F0F0);

  // Color heart
  static const Color heartColor = Color(0xFFD32F2F);

  // Color rating
  static const Color ratingColor = Color(0xFFEEC73A);

  // Semantic Colors
  static const Color error = Colors.red; // Color estándar para errores

  // Option Selector Colors
  static const Color optionOrange = Color(0xFFFFA500);
  static const Color optionRed = Color(0xFFFF0000);
  static const Color optionYellow = Color(0xFFFFEB3B);
  static const Color optionBlue = Color(0xFF2196F3);
  static const Color optionUnselectedBackground = Color(0xFFF3F4F6); // Usando inputFill por defecto
  static const Color optionBorder = Color(0xFFE0E0E0); // Un gris claro para bordes
}
