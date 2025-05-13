import 'package:flutter/material.dart';
import 'package:flutter_application_ecommerce/core/routes/app_router.dart';
import 'package:flutter_application_ecommerce/features/home/domain/domain.dart';

/// Helper para gestionar la navegación en la aplicación.
///
/// Esta clase funciona como una capa de abstracción sobre el sistema de rutas
/// AppRouter, proporcionando métodos semánticos para la navegación.
class NavigationHelper {
  /// Clave de navegación global para poder navegar sin context
  static final GlobalKey<NavigatorState> navigatorKey = AppRouter.navigatorKey;

  /// Navegar a la página principal
  static void goToMainShell(BuildContext context) {
    AppRouter.goToMain(context);
  }

  /// Navegar a la página de inicio
  static void goToHome(BuildContext context) {
    AppRouter.goToHome(context);
  }

  /// Navegar a la página del carrito
  static void goToCart(BuildContext context) {
    AppRouter.goToCart(context);
  }

  /// Navegar a la página de detalle de producto
  /// Si ya existe una página para este producto, la anterior será cerrada
  /// y se abrirá una nueva
  static void goToProductDetail(
    BuildContext context,
    ProductItemModel product,
  ) {
    AppRouter.goToProductDetail(
      context,
      productId: product.id,
      product: product,
    );
  }

  /// Navegar a la página de categorias
  static void goToCategories(BuildContext context) {
    AppRouter.goToCategories(context);
  }

  /// Navegar a la página de productos por categoria
  static void goToCategoryProducts(BuildContext context, String categoryId) {
    AppRouter.goToCategoryProducts(context, categoryId: categoryId);
  }

  /// Navegar a la página de inicio de sesión
  static void goToSignIn(BuildContext context) {
    AppRouter.goToSignIn(context);
  }

  /// Navegar a la página de registro
  static void goToRegister(BuildContext context) {
    AppRouter.goToRegister(context);
  }
}
