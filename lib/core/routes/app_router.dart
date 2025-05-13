import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_application_ecommerce/core/constants/app_routes.dart';
import 'package:flutter_application_ecommerce/features/home/presentation/pages/home_page.dart';
import 'package:flutter_application_ecommerce/features/cart/presentation/pages/cart_page.dart';
import 'package:flutter_application_ecommerce/features/product_detail/presentation/pages/product_detail_page.dart';
import 'package:flutter_application_ecommerce/features/splash/presentation/pages/splash_page.dart';
import 'package:flutter_application_ecommerce/features/shell/presentation/pages/main_shell_page.dart';
import 'package:flutter_application_ecommerce/features/home/domain/domain.dart';
import 'package:flutter_application_ecommerce/features/home/presentation/pages/all_categories_page.dart';

/// Configuración del sistema de rutas de la aplicación con GoRouter.
///
/// Siguiendo las mejores prácticas:
/// 1. Usar correcta nomenclatura de rutas
/// 2. No usar extras, sino parámetros de URL
/// 3. Abstraer y reutilizar rutas
/// 4. Usar nombres para las rutas
/// 5. Implementar métodos de navegación específicos
class AppRouter {
  /// Constructor privado para evitar instanciación
  AppRouter._();

  /// GlobalKey para el navegador que permite navegación sin contexto
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  /// Set para almacenar IDs de productos ya abiertos y prevenir duplicados
  static final Set<String> _openProductIds = <String>{};

  /// Configuración de GoRouter
  static final GoRouter router = GoRouter(
    navigatorKey: navigatorKey,
    debugLogDiagnostics: true,
    initialLocation: AppRoutes.splash,
    routes: [_splashRoute, _mainRoute, _productDetailRoute],
  );

  /// Ruta de splash
  static final GoRoute _splashRoute = GoRoute(
    path: AppRoutes.splash,
    name: AppRoutes.splashName,
    builder: (context, state) => const SplashPage(),
  );

  /// Ruta principal con shell
  static final GoRoute _mainRoute = GoRoute(
    path: AppRoutes.main,
    name: AppRoutes.mainName,
    builder: (context, state) => const MainShellPage(),
    routes: [_homeRoute, _cartRoute, _categoriesRoute],
  );

  /// Ruta de inicio
  static final GoRoute _homeRoute = GoRoute(
    path: 'home',
    name: AppRoutes.homeName,
    builder: (context, state) => const HomePage(),
  );

  /// Ruta de carrito
  static final GoRoute _cartRoute = GoRoute(
    path: 'cart',
    name: AppRoutes.cartName,
    builder: (context, state) => const CartPage(),
  );

  /// Ruta de categorías
  static final GoRoute _categoriesRoute = GoRoute(
    path: 'categories',
    name: AppRoutes.categoriesName,
    builder: (context, state) => const AllCategoriesPage(),
  );

  /// Ruta de detalle de producto
  static final GoRoute _productDetailRoute = GoRoute(
    path: AppRoutes.productDetail,
    name: AppRoutes.productDetailName,
    builder: (context, state) {
      // Obtenemos el producto completo desde extras
      final product = state.extra as ProductItemModel?;

      // Si no hay producto en extras, intentamos usar el ID del parámetro
      if (product == null) {
        // final productId = state.pathParameters[AppRoutes.productIdParam] ?? '';
        // En un caso real, aquí cargaríamos el producto desde un repositorio
        // Por ahora, mostramos un error
        return Scaffold(
          appBar: AppBar(title: const Text('Error')),
          body: const Center(child: Text('Producto no encontrado')),
        );
      }

      return ProductDetailPage(product: product);
    },
  );

  /// Métodos de navegación

  /// Navega a la página principal (reemplaza toda la pila)
  static void goToMain(BuildContext context) {
    context.goNamed(AppRoutes.mainName);
  }

  /// Navega a la página de inicio
  static void goToHome(BuildContext context) {
    context.goNamed(AppRoutes.homeName);
  }

  /// Navega a la página de carrito
  static void goToCart(BuildContext context) {
    context.goNamed(AppRoutes.cartName);
  }

  /// Empuja la página de carrito
  static void pushCart(BuildContext context) {
    context.pushNamed(AppRoutes.cartName);
  }

  /// Navega al detalle de un producto evitando duplicados
  static void goToProductDetail(
    BuildContext context, {
    required String productId,
    ProductItemModel? product,
  }) {
    // Cerramos cualquier instancia anterior del mismo producto
    if (_openProductIds.contains(productId)) {
      // Hacemos pop hasta encontrar una ruta que no sea la del mismo producto
      NavigatorState navigator = navigatorKey.currentState!;
      while (navigator.canPop()) {
        navigator.pop();
        if (!_openProductIds.contains(productId)) break;
      }
    }

    // Registramos el producto como abierto
    _openProductIds.add(productId);

    context.goNamed(
      AppRoutes.productDetailName,
      pathParameters: {AppRoutes.productIdParam: productId},
      extra: product,
    );
  }

  /// Navega a la página de categorias
  static void goToCategories(BuildContext context) {
    context.goNamed(AppRoutes.categoriesName);
  }

  /// Navega a la página de productos por categoria
  static void goToCategoryProducts(
    BuildContext context, {
    required String categoryId,
  }) {
    context.goNamed(
      AppRoutes.categoryProductsName,
      pathParameters: {AppRoutes.categoryIdParam: categoryId},
    );
  }

  /// Método para eliminar un ID de producto de la lista de abiertos
  static void removeOpenProductId(String productId) {
    _openProductIds.remove(productId);
  }
}
