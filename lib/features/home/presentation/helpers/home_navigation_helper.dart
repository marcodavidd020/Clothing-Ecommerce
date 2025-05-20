import 'package:flutter/material.dart';
import 'package:flutter_application_ecommerce/core/helpers/navigation_helper.dart';
import 'package:flutter_application_ecommerce/core/network/logger.dart';
import 'package:flutter_application_ecommerce/features/home/domain/entities/category_item_model.dart';
import 'package:flutter_application_ecommerce/features/home/domain/entities/product_item_model.dart';

/// Clase auxiliar para encapsular la navegación específica del módulo Home
class HomeNavigationHelper {
  /// Constructor privado para prevenir instanciación
  HomeNavigationHelper._();

  /// Mecanismo para prevenir múltiples navegaciones simultáneas
  static bool _isNavigating = false;

  /// Navega al detalle de un producto con prevención de navegación múltiple
  static void goToProductDetail(BuildContext context, ProductItemModel product) {
    if (_isNavigating) return;
    
    _isNavigating = true;
    AppLogger.logInfo('Navegando a detalle de producto: ${product.name}');
    NavigationHelper.goToProductDetail(context, product);
    _isNavigating = false;
  }

  /// Navega a la página de productos por categoría
  static void goToCategoryProducts(BuildContext context, CategoryItemModel category) {
    if (_isNavigating) return;
    
    _isNavigating = true;
    AppLogger.logInfo('Navegando a productos por categoría: ${category.name}');
    NavigationHelper.goToCategoryProducts(context, category.name);
    _isNavigating = false;
  }

  /// Navega a la página de todas las categorías
  static void goToAllCategories(BuildContext context) {
    if (_isNavigating) return;
    
    _isNavigating = true;
    AppLogger.logInfo('Navegando a todas las categorías');
    NavigationHelper.goToCategories(context);
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
    NavigationHelper.goToCart(context);
    _isNavigating = false;
  }

  /// Navega a la página de perfil
  static void goToProfile(BuildContext context) {
    if (_isNavigating) return;
    
    _isNavigating = true;
    AppLogger.logInfo('Navegando al perfil');
    NavigationHelper.goToProfile(context);
    _isNavigating = false;
  }

  /// Muestra un diálogo para características no implementadas
  static void _showSearchNotImplementedDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Próximamente'),
        content: const Text('La funcionalidad de búsqueda estará disponible pronto.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Aceptar'),
          ),
        ],
      ),
    );
  }
} 