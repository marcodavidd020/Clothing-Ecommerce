import 'package:flutter/material.dart';
import 'package:flutter_application_ecommerce/core/routes/app_router.dart';
import 'package:flutter_application_ecommerce/features/home/domain/domain.dart';
import 'package:flutter_application_ecommerce/core/constants/app_routes.dart';
import 'package:flutter_application_ecommerce/core/network/logger.dart';
import 'package:go_router/go_router.dart';

/// Helper para gestionar la navegación en la aplicación.
///
/// Esta clase funciona como una capa de abstracción sobre el sistema de rutas
/// AppRouter, proporcionando métodos semánticos para la navegación.
class NavigationHelper {
  /// Constructor privado para prevenir instanciación
  NavigationHelper._();

  /// Clave de navegación global para poder navegar sin context
  static final GlobalKey<NavigatorState> navigatorKey = AppRouter.navigatorKey;

  /// Mecanismo para prevenir múltiples navegaciones simultáneas
  static bool _isNavigating = false;

  /// Navegar a la página principal
  static void goToMainShell(BuildContext context) {
    if (_isNavigating) return;

    _isNavigating = true;
    AppLogger.logInfo('Navegando a página principal (shell)');

    _safeNavigate(() {
      AppRouter.goToMain(context);
    });

    _isNavigating = false;
  }

  /// Navegar a la página de inicio
  static void goToHome(BuildContext context) {
    if (_isNavigating) return;

    _isNavigating = true;
    AppLogger.logInfo('Navegando a página de inicio');

    _safeNavigate(() {
      AppRouter.goToMain(context);
    });

    _isNavigating = false;
  }

  /// Navegar a la página del carrito
  static void goToCart(BuildContext context) {
    if (_isNavigating) return;

    _isNavigating = true;
    AppLogger.logInfo('Navegando a carrito');

    _safeNavigate(() {
      AppRouter.goToCart(context);
    });

    _isNavigating = false;
  }

  /// Navegar a la página de perfil
  static void goToProfile(BuildContext context) {
    if (_isNavigating) return;

    _isNavigating = true;
    AppLogger.logInfo('Navegando a perfil');

    _safeNavigate(() {
      AppRouter.goToProfile(context);
    });

    _isNavigating = false;
  }

  /// Navegar a la página de detalle de producto
  /// Si ya existe una página para este producto, la anterior será cerrada
  /// y se abrirá una nueva
  static void goToProductDetail(
    BuildContext context,
    ProductItemModel product,
  ) {
    if (_isNavigating) return;

    _isNavigating = true;
    AppLogger.logInfo('Navegando a detalle de producto: ${product.name}');

    _safeNavigate(() {
      AppRouter.goToProductDetail(
        context,
        productId: product.id,
        product: product,
      );
    });

    _isNavigating = false;
  }

  /// Navegar a la página de categorias
  static void goToCategories(BuildContext context) {
    if (_isNavigating) return;

    _isNavigating = true;
    AppLogger.logInfo('Navegando a categorías');

    _safeNavigate(() {
      AppRouter.goToCategories(context);
    });

    _isNavigating = false;
  }

  /// Navega hacia atrás de manera segura, usando GoRouter en lugar de Navigator.pop()
  static void goBack(BuildContext context) {
    if (_isNavigating) return;

    _isNavigating = true;
    AppLogger.logInfo('Navegando hacia atrás');

    try {
      // Verificamos primero si podemos hacer pop de manera segura
      if (AppRouter.router.canPop()) {
        context.pop();
        _isNavigating = false;
        return;
      }

      // Si no podemos hacer pop, programamos la navegación a home con un pequeño retraso
      // para evitar conflictos con los eventos del frame actual
      AppLogger.logInfo('No se puede navegar hacia atrás, yendo a home');

      // Usamos un pequeño retraso en lugar de microtask para evitar conflictos
      // con los eventos en el frame actual (especialmente eventos de mouse)
      Future.delayed(const Duration(milliseconds: 100), () {
        if (!context.mounted) {
          _isNavigating = false;
          return;
        }

        // Navegación directa a Home para evitar problemas con la pila de navegación
        try {
          context.goNamed(AppRoutes.mainName);
        } catch (e) {
          AppLogger.logError('Error navegando a home desde goBack: $e');
          // Intento final usando el navigator global
          try {
            navigatorKey.currentState?.pushNamedAndRemoveUntil(
              '/${AppRoutes.main}/home',
              (route) => false,
            );
          } catch (e) {
            AppLogger.logError('Error fallback de navegación a home: $e');
          }
        }

        _isNavigating = false;
      });
    } catch (e) {
      AppLogger.logError('Error en goBack: $e');
      // Retrasar reset de bandera para evitar problemas con eventos pendientes
      Future.delayed(const Duration(milliseconds: 200), () {
        _isNavigating = false;
      });
    }
  }

  /// Navegar a la página de productos por categoría (usando ID)
  ///
  /// Este método es un adaptador para mantener compatibilidad con código existente.
  /// Internamente intenta obtener el estado de categorías y navegar a la vista correcta.
  static void goToCategoryProducts(BuildContext context, String categoryId) {
    if (_isNavigating) return;

    _isNavigating = true;
    AppLogger.logInfo('Navegando a productos por categoría: $categoryId');

    // Uso básico, sin verificar estado. En caso de navegación más compleja,
    // es preferible usar HomeNavigationHelper.goToCategoryDetailById que verifica
    // disponibilidad de datos.
    try {
      // Verificar si estamos en una ruta que ya contiene una categoría
      final location = GoRouterState.of(context).uri.toString();
      final bool isInCategoryRoute =
          location.contains('/category/') &&
          !location.contains('/subcategory/');

      // Usar microtask para permitir que el frame actual termine
      Future.microtask(() {
        if (!context.mounted) {
          _isNavigating = false;
          return;
        }

        try {
          if (isInCategoryRoute) {
            // Si ya estamos en una ruta de categoría, extraer el ID de la categoría actual
            final currentCategoryId =
                location.split('/category/').last.split('/').first;

            // Navegar como subcategoría si es posible
            context.goNamed(
              AppRoutes.subcategoryName,
              pathParameters: {
                AppRoutes.categoryIdParam: currentCategoryId,
                AppRoutes.subCategoryIdParam: categoryId,
              },
            );
          } else {
            // Navegar como categoría normal
            context.goNamed(
              AppRoutes.categoryDetailName,
              pathParameters: {AppRoutes.categoryIdParam: categoryId},
            );
          }
        } catch (e) {
          AppLogger.logError('Error navegando a categoría $categoryId: $e');
          if (context.mounted) {
            goToHome(context);
          }
        }

        _isNavigating = false;
      });
    } catch (e) {
      AppLogger.logError('Error navegando a categoría $categoryId: $e');
      if (context.mounted) {
        goToHome(context);
      }
      _isNavigating = false;
    }
  }

  /// Navegar a la página de detalle de categoría usando su ID
  static void goToCategoryDetail(
    BuildContext context, {
    required String categoryId,
    required List<CategoryApiModel> allCategories,
  }) {
    if (_isNavigating) return;

    _isNavigating = true;
    AppLogger.logInfo('Navegando a detalle de categoría: $categoryId');

    _safeNavigate(() {
      context.goNamed(
        AppRoutes.categoryDetailName,
        pathParameters: {AppRoutes.categoryIdParam: categoryId},
        extra: {'allCategories': allCategories},
      );
    });

    _isNavigating = false;
  }

  /// Navegar a la página de subcategoría usando su ID
  static void goToSubcategory(
    BuildContext context, {
    required String categoryId,
    required String subCategoryId,
    required List<CategoryApiModel> allCategories,
  }) {
    if (_isNavigating) return;

    _isNavigating = true;
    AppLogger.logInfo(
      'Navegando a subcategoría: $subCategoryId (padre: $categoryId)',
    );

    _safeNavigate(() {
      context.goNamed(
        AppRoutes.subcategoryName,
        pathParameters: {
          AppRoutes.categoryIdParam: categoryId,
          AppRoutes.subCategoryIdParam: subCategoryId,
        },
        extra: {'allCategories': allCategories},
      );
    });

    _isNavigating = false;
  }

  /// Navegar a la página de inicio de sesión
  static void goToSignIn(BuildContext context) {
    if (_isNavigating) return;

    _isNavigating = true;
    AppLogger.logInfo('Navegando a inicio de sesión');

    _safeNavigate(() {
      AppRouter.goToSignIn(context);
    });

    _isNavigating = false;
  }

  /// Navegar a la página de registro
  static void goToRegister(BuildContext context) {
    if (_isNavigating) return;

    _isNavigating = true;
    AppLogger.logInfo('Navegando a registro');

    _safeNavigate(() {
      AppRouter.goToRegister(context);
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
}
