import 'package:flutter/material.dart';
import 'package:flutter_application_ecommerce/core/helpers/navigation_helper.dart';
import 'package:flutter_application_ecommerce/core/network/logger.dart';
import 'package:flutter_application_ecommerce/features/home/domain/entities/category_api_model.dart';
import 'package:flutter_application_ecommerce/features/home/domain/entities/product_item_model.dart';
import 'package:flutter_application_ecommerce/core/constants/app_routes.dart';
import 'package:go_router/go_router.dart';

/// Clase auxiliar para encapsular la navegación específica del módulo Home
///
/// Extiende la funcionalidad de NavigationHelper con lógica específica para el módulo Home,
/// como carga de datos de estado, verificaciones de disponibilidad de datos, etc.
class HomeNavigationHelper {
  /// Constructor privado para prevenir instanciación
  HomeNavigationHelper._();

  /// Mecanismo para prevenir múltiples navegaciones simultáneas
  static bool _isNavigating = false;

  /// Navega al detalle de un producto con prevención de navegación múltiple
  static void goToProductDetail(
    BuildContext context,
    ProductItemModel product,
  ) {
    if (_isNavigating) return;

    _isNavigating = true;
    AppLogger.logInfo('Navegando a detalle de producto: ${product.name}');

    _safeNavigate(() {
      NavigationHelper.goToProductDetail(context, product);
    });

    _isNavigating = false;
  }

  /// Navegación después de cargar una categoría por ID (llamado desde los listeners de BLoC)
  static void navigateAfterCategoryLoaded(
    BuildContext context,
    CategoryApiModel category,
    List<CategoryApiModel> allCategories,
  ) {
    if (_isNavigating) return;

    _isNavigating = true;
    AppLogger.logInfo(
      'Navegando a categoría después de cargar: ${category.name}, hasProducts: ${category.hasProducts}, hijos: ${category.children.length}',
    );

    // Ejecutar en microtask para permitir que el frame actual se complete
    Future.microtask(() {
      if (!context.mounted) {
        _isNavigating = false;
        return;
      }
      try {
        // Usar pushNamed para preservar el historial de navegación
        context.pushNamed(
          AppRoutes.categoryDetailName,
          pathParameters: {AppRoutes.categoryIdParam: category.id},
          extra: {'allCategories': allCategories},
        );
      } catch (e) {
        AppLogger.logError('Error al navegar a categoría ${category.name}: $e');
        if (context.mounted) {
          NavigationHelper.goToHome(context);
        }
      }
      _isNavigating = false;
    });
  }

  /// Navega a la página de todas las categorías
  static void goToAllCategories(BuildContext context) {
    if (_isNavigating) return;

    _isNavigating = true;
    AppLogger.logInfo('Navegando a todas las categorías');
    // La página AllCategoriesPage ha sido eliminada, mostramos un mensaje temporal
    _showNotImplementedDialog(context, 'Vista completa de categorías');
    _isNavigating = false;
  }

  /// Navega a la página de búsqueda
  static void goToSearch(BuildContext context) {
    if (_isNavigating) return;

    _isNavigating = true;
    AppLogger.logInfo('Navegando a búsqueda');

    // Usar implementación específica cuando esté disponible
    // Por ahora, usamos un método temporal
    _showSearchNotImplementedDialog(context);
    _isNavigating = false;
  }

  /// Navega a la página de carrito
  static void goToCart(BuildContext context) {
    if (_isNavigating) return;

    _isNavigating = true;
    AppLogger.logInfo('Navegando al carrito');
    _safeNavigate(() {
      NavigationHelper.goToCart(context);
    });
    _isNavigating = false;
  }

  /// Navega a la página de perfil
  static void goToProfile(BuildContext context) {
    if (_isNavigating) return;

    _isNavigating = true;
    AppLogger.logInfo('Navegando al perfil');

    _safeNavigate(() {
      NavigationHelper.goToProfile(context);
    });
    _isNavigating = false;
  }

  /// Método auxiliar para realizar navegación de manera segura
  static void _safeNavigate(VoidCallback navigationAction) {
    try {
      navigationAction();
    } catch (e) {
      AppLogger.logError('Error durante la navegación: $e');
    }
  }

  /// Muestra un diálogo para características no implementadas
  static void _showSearchNotImplementedDialog(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Próximamente'),
            content: const Text(
              'La funcionalidad de búsqueda estará disponible pronto.',
            ),
            actions: [
              TextButton(
                onPressed: () => context.pop(),
                child: const Text('Aceptar'),
              ),
            ],
          ),
    );
  }

  /// Muestra un diálogo para características no implementadas
  static void _showNotImplementedDialog(BuildContext context, String feature) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Próximamente'),
            content: Text('La vista de $feature estará disponible pronto.'),
            actions: [
              TextButton(
                onPressed: () => context.pop(),
                child: const Text('Aceptar'),
              ),
            ],
          ),
    );
  }
}
