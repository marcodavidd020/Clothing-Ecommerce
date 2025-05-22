import 'package:flutter/material.dart';
import 'package:flutter_application_ecommerce/core/constants/app_routes.dart';
import 'package:flutter_application_ecommerce/core/network/logger.dart';
import 'package:flutter_application_ecommerce/features/home/domain/entities/category_api_model.dart';
import 'package:go_router/go_router.dart';

/// Helper para gestionar la navegación específica entre categorías y subcategorías
///
/// Proporciona métodos para navegar entre categorías y subcategorías,
/// manteniendo la lógica de navegación coherente en toda la aplicación.
class CategoryNavigationHelper {
  /// Constructor privado para prevenir instanciación
  CategoryNavigationHelper._();

  /// Navega a una categoría específica determinando si es subcategoría o categoría principal
  ///
  /// Decide automáticamente si usar la ruta de categoría o subcategoría en función de la relación
  /// entre la categoría actual y la categoría destino.
  static void navigateToCategory(
    BuildContext context, {
    required CategoryApiModel category,
    required CategoryApiModel currentCategory,
    required List<CategoryApiModel> allCategories,
  }) {
    try {
      // Identificar si la categoría a la que vamos es una subcategoría de la actual
      final bool isSubcategoryOfCurrent = currentCategory.children.any(
        (c) => c.id == category.id,
      );

      if (isSubcategoryOfCurrent) {
        // Si es una subcategoría de la actual, usar la ruta anidada
        AppLogger.logInfo(
          'Navegando a subcategoría: ${category.name} desde ${currentCategory.name}',
        );

        context.goNamed(
          AppRoutes.subcategoryName,
          pathParameters: {
            AppRoutes.categoryIdParam: currentCategory.id,
            AppRoutes.subCategoryIdParam: category.id,
          },
          extra: {'allCategories': allCategories},
        );
      } else {
        // Si no es una subcategoría directa, usar la ruta normal de categoría
        AppLogger.logInfo('Navegando a categoría: ${category.name}');

        context.goNamed(
          AppRoutes.categoryDetailName,
          pathParameters: {AppRoutes.categoryIdParam: category.id},
          extra: {'allCategories': allCategories},
        );
      }
    } catch (e) {
      AppLogger.logError('Error navegando a categoría ${category.name}: $e');
    }
  }

  /// Navega a una subcategoría específica dentro de una categoría padre
  static void navigateToSubcategory(
    BuildContext context, {
    required String parentCategoryId,
    required String subcategoryId,
    required List<CategoryApiModel> allCategories,
  }) {
    try {
      AppLogger.logInfo(
        'Navegando a subcategoría ID: $subcategoryId (padre: $parentCategoryId)',
      );

      context.goNamed(
        AppRoutes.subcategoryName,
        pathParameters: {
          AppRoutes.categoryIdParam: parentCategoryId,
          AppRoutes.subCategoryIdParam: subcategoryId,
        },
        extra: {'allCategories': allCategories},
      );
    } catch (e) {
      AppLogger.logError('Error navegando a subcategoría $subcategoryId: $e');
    }
  }

  /// Navega directamente a una categoría por su ID
  static void navigateToCategoryById(
    BuildContext context, {
    required String categoryId,
    required List<CategoryApiModel> allCategories,
  }) {
    try {
      AppLogger.logInfo('Navegando a categoría ID: $categoryId');

      context.goNamed(
        AppRoutes.categoryDetailName,
        pathParameters: {AppRoutes.categoryIdParam: categoryId},
        extra: {'allCategories': allCategories},
      );
    } catch (e) {
      AppLogger.logError('Error navegando a categoría $categoryId: $e');
    }
  }
}
