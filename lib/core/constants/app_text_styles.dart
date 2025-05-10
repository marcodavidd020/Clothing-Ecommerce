import 'package:flutter/material.dart';
import 'app_colors.dart';
// import 'gabarito.dart'; // Eliminamos esta importación por ahora

/// Define los estilos de texto reutilizables en la aplicación.
/// Utiliza la fuente 'Gabarito' definida en pubspec.yaml.
class AppTextStyles {
  // --- Estilos Base --- //
  static const String _fontFamily = 'Gabarito';

  /// Estilo para el texto de encabezado principal.
  static const TextStyle heading = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 20,
    color: AppColors.textDark,
    fontWeight: FontWeight.bold,
  );

  /// Estilo para el texto de sub-encabezado o títulos secundarios.
  static const TextStyle subheading = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 16,
    color: AppColors.textDark,
    fontWeight: FontWeight.w600, // SemiBold
  );

  /// Estilo para el cuerpo de texto normal.
  static const TextStyle body = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 14,
    color: AppColors.textLight,
    fontWeight: FontWeight.normal,
  );

  /// Estilo para etiquetas o texto pequeño.
  static const TextStyle caption = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 12,
    color: AppColors.textLight,
    fontWeight: FontWeight.normal,
  );

  /// Estilo para el texto de los botones.
  static const TextStyle buttonLabel = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 16,
    color: AppColors.white,
    fontWeight: FontWeight.bold,
    letterSpacing: -0.295753,
  );

  /// Estilo para el texto de entrada (placeholder y texto ingresado).
  static const TextStyle inputText = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 14,
    color: AppColors.textDark, // Color para el texto ingresado
    fontWeight: FontWeight.normal,
  );

  /// Estilo para el texto "price" en product item.
  static const TextStyle productPrice = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 13,
    color: AppColors.primary,
    fontWeight: FontWeight.bold,
    letterSpacing: -0.295753,
  );

  /// Estilo para el texto "title" en product item.
  static const TextStyle productTitle = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 13,
    color: AppColors.textDark,
    fontWeight: FontWeight.normal,
    letterSpacing: -0.295753,
  );

  /// Estilo para el texto del título de la sección de categorías.
  static const TextStyle sectionTitle = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 13, // Ajustado para que sea más prominente
    color: AppColors.textDark,
    fontWeight: FontWeight.bold,
  );

  /// Estilo para el texto "See All" en la sección de categorías.
  static const TextStyle seeAll = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 13,
    color: AppColors.primary, // Usar el color primario para destacar
    fontWeight: FontWeight.w500, // Medium
    letterSpacing: -0.295753,
  );

  /// Estilo para el texto de placeholder (hint) en campos de entrada.
  static const TextStyle inputHint = TextStyle(
    fontSize: 12,
    color: Colors.grey,
  );

  /// Estilo para el texto en botones primarios.
  static const TextStyle button = TextStyle(
    fontWeight: FontWeight.w500,
    fontSize: 12,
    height: 1.6875,
    letterSpacing: -0.495753,
    color: AppColors.white,
  );

  /// Estilo para enlaces de texto.
  static const TextStyle link = TextStyle(
    fontSize: 14,
    color: AppColors.link,
    fontWeight: FontWeight.w500,
  );

  /// Estilo para el texto en botones sociales.
  static const TextStyle socialButton = TextStyle(
    fontWeight: FontWeight.w600,
    fontSize: 12,
    height: 1.6875,
    letterSpacing: -0.495753,
    color: AppColors.textDark,
  );

  /// Estilo para el nombre de cada ítem de categoría.
  static const TextStyle categoryItem = TextStyle(
    fontSize: 12,
    color: AppColors.textDark,
    fontWeight: FontWeight.w100, // El más ligero de Gabarito
    letterSpacing: -0.295753,
  );

  /// Estilo para el nombre de cada ítem de producto Top Selling con el precio tachado.
  static const TextStyle topSellingItemWithPrice = TextStyle(
    fontSize: 12,
    color: AppColors.textGray,
    fontWeight: FontWeight.w600, // El más ligero de Gabarito
    letterSpacing: -0.295753,
    decoration: TextDecoration.lineThrough,
    decorationColor: AppColors.textGray,
  );

  /// Estilo para el nombre de cada ítem de producto Top Selling con el precio original.
  static const TextStyle topSellingItem = TextStyle(
    fontSize: 12,
    color: AppColors.textDark,
    fontWeight: FontWeight.w600, // El más ligero de Gabarito
    letterSpacing: -0.295753,
  );

  // Estilo del texto del nombre del producto de top selling
  static const TextStyle topSellingItemName = TextStyle(
    fontSize: 12,
    color: AppColors.textDark,
    fontWeight: FontWeight.normal, // El más ligero de Gabarito
    letterSpacing: -0.295753,
  );

  // Error Text Style
  static const TextStyle errorText = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 14,
    color: AppColors.error, // Usar el color de error definido en AppColors
    fontWeight: FontWeight.normal,
  );
}
