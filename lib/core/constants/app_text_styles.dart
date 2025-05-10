import 'package:flutter/material.dart';
import 'app_colors.dart';

/// Define los estilos de texto reutilizables en la aplicación.
class AppTextStyles {
  /// Estilo para encabezados principales de pantalla o secciones importantes.
  static const TextStyle heading = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.bold,
    color: AppColors.black,
  );

  /// Estilo para el texto de placeholder (hint) en campos de entrada.
  static const TextStyle inputHint = TextStyle(
    fontSize: 12,
    color: Colors.grey,
  );

  /// Estilo para el texto dentro de los campos de entrada (cuando el usuario escribe).
  static const TextStyle inputText = TextStyle(
    fontSize: 12,
    color: AppColors.textDark,
    fontWeight: FontWeight.w300,
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

  /// Estilo para el título de la sección de categorías.
  static const TextStyle categorySectionTitle = TextStyle(
    fontSize: 13,
    color: AppColors.textDark,
    fontWeight: FontWeight.bold,
  );

  /// Estilo para el texto "See All" en la sección de categorías.
  static const TextStyle seeAll = TextStyle(
    fontSize: 13,
    color: AppColors.primary,
    fontWeight: FontWeight.bold,
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
}
