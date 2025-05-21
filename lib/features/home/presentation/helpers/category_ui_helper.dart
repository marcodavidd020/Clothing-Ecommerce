import 'package:flutter/material.dart';
import 'package:flutter_application_ecommerce/core/constants/constants.dart';
import 'package:flutter_application_ecommerce/features/home/core/constants/home_ui.dart';
import 'package:flutter_application_ecommerce/features/home/domain/entities/category_api_model.dart';

/// Helper para componentes de UI específicos para la vista de categorías
///
/// Proporciona métodos para crear encabezados, secciones y otros elementos
/// visuales específicos para la vista de categorías.
class CategoryUIHelper {
  /// Constructor privado para prevenir instanciación
  CategoryUIHelper._();

  /// Constantes para textos usados en la UI
  static const String subcategoriasTitle = 'Subcategorías';
  static const String productosTitle = 'Productos';
  static const String noProductsMessage =
      'No hay productos disponibles en esta categoría';

  /// Crea un encabezado para una sección dentro de una vista de categoría
  static Widget buildSectionHeader(String title, {Color? color}) {
    return Text(
      title,
      style: AppTextStyles.heading.copyWith(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: color ?? AppColors.textDark,
      ),
    );
  }

  /// Crea un indicador de estado de carga
  static Widget buildLoadingIndicator() {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(24.0),
        child: CircularProgressIndicator(color: AppColors.primary),
      ),
    );
  }

  /// Calcula el número de columnas para la cuadrícula de productos basado en el ancho de pantalla
  static int getGridColumnCount(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    if (screenWidth > 900) {
      return 4; // Para pantallas muy grandes
    } else if (screenWidth > 600) {
      return 3; // Para tablets
    } else {
      return 2; // Para teléfonos
    }
  }

  /// Genera un aspecto ratio apropiado para los elementos de la cuadrícula de productos
  static double getProductItemAspectRatio(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    // Ajustar la proporción según el tamaño de pantalla para mejor visualización
    if (screenWidth > 900) {
      return 0.8; // Más alto para pantallas grandes
    } else {
      return 0.7; // Proporción estándar para productos
    }
  }

  /// Obtiene un DefaultSliverGridDelegate para una cuadrícula responsiva
  static SliverGridDelegate getResponsiveGridDelegate(BuildContext context) {
    return SliverGridDelegateWithFixedCrossAxisCount(
      mainAxisExtent: HomeUI.topSellingSectionHeight,
      crossAxisCount: getGridColumnCount(context),
      crossAxisSpacing: HomeUI.productItemSpacing,
      mainAxisSpacing: HomeUI.productItemSpacing,
      childAspectRatio: getProductItemAspectRatio(context),
    );
  }

  /// Obtiene la URL de la imagen para una categoría, o una imagen predeterminada si no tiene
  static String getCategoryImageUrl(CategoryApiModel category) {
    return category.imageUrl ?? 'https://via.placeholder.com/150';
  }

  /// Genera espaciadores verticales con alturas consistentes
  static Widget smallVerticalSpacer() =>
      const SizedBox(height: HomeUI.smallVerticalSpacer);
  static Widget mediumVerticalSpacer() =>
      const SizedBox(height: HomeUI.mediumVerticalSpacer);
  static Widget largeVerticalSpacer() =>
      const SizedBox(height: HomeUI.largeVerticalSpacer);
}
