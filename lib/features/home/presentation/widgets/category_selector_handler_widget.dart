import 'package:flutter/material.dart';
import 'package:flutter_application_ecommerce/features/home/domain/entities/category_api_model.dart';
import 'package:flutter_application_ecommerce/features/home/presentation/widgets/category_selector_modal.dart';
import 'package:flutter_application_ecommerce/features/home/presentation/helpers/helpers.dart';
import 'package:flutter_application_ecommerce/core/network/logger.dart';

/// Widget que maneja la selección de categorías y la interacción
/// con el selector de categorías en la página Home.
class CategorySelectorHandlerWidget {
  /// Constructor privado para evitar instanciación
  CategorySelectorHandlerWidget._();

  /// Muestra el selector de categorías modal
  static void openCategorySelector(
    BuildContext context,
    List<CategoryApiModel> categories,
    CategoryApiModel? selectedCategory,
  ) {
    CategorySelectorModal.show(
      context: context,
      categories: categories,
      selectedCategory: selectedCategory,
      onCategorySelected: (category) => _handleCategorySelection(
        context, 
        category, 
        categories,
        shouldNavigate: false, // No navegar cuando se selecciona desde el selector principal
      ),
    );
  }

  /// Maneja la selección de una categoría raíz
  /// 
  /// [shouldNavigate] controla si se debe navegar a la página de detalle de categoría
  /// o solo actualizar la categoría seleccionada en la página principal
  static void _handleCategorySelection(
    BuildContext context,
    CategoryApiModel category,
    List<CategoryApiModel> allCategories, {
    bool shouldNavigate = true,
  }) {
    // Marcar la categoría como seleccionada en el estado
    HomeBlocHandler.selectRootCategory(context, category);
    
    AppLogger.logInfo('Categoría seleccionada: ${category.name}, navegación: $shouldNavigate');

    // Si no se debe navegar, simplemente retornar para mantener al usuario en la página Home
    if (!shouldNavigate) return;

    // Usar microtask para asegurar que el frame actual termine
    // antes de iniciar la navegación
    Future.microtask(() {
      if (!context.mounted) return;

      // Si la categoría tiene subcategorías, navegamos a la página de detalle
      if (category.children.isNotEmpty) {
        HomeNavigationHelper.navigateAfterCategoryLoaded(
          context,
          category,
          allCategories,
        );
      }
      // Si solo tiene productos, cargamos los productos directamente
      else if (category.hasProducts) {
        HomeBlocHandler.loadProductsByCategory(context, category.id);
      }
    });
  }

  /// Navega al detalle de la categoría (para casos donde se quiere forzar la navegación)
  static void navigateToCategoryDetail(
    BuildContext context,
    CategoryApiModel category,
    List<CategoryApiModel> allCategories,
  ) {
    _handleCategorySelection(context, category, allCategories, shouldNavigate: true);
  }
}
