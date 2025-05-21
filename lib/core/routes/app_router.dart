import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_application_ecommerce/core/constants/app_routes.dart';
import 'package:flutter_application_ecommerce/features/home/presentation/pages/home_page.dart';
import 'package:flutter_application_ecommerce/features/cart/presentation/pages/cart_page.dart';
import 'package:flutter_application_ecommerce/features/product_detail/presentation/pages/product_detail_page.dart';
import 'package:flutter_application_ecommerce/features/splash/presentation/pages/splash_page.dart';
import 'package:flutter_application_ecommerce/features/shell/presentation/pages/main_shell_page.dart';
import 'package:flutter_application_ecommerce/features/home/presentation/pages/category_detail_page.dart';
import 'package:flutter_application_ecommerce/features/home/domain/domain.dart';
import 'package:flutter_application_ecommerce/features/auth/presentation/presentation.dart';
import 'package:flutter_application_ecommerce/features/profile/presentation/pages/profile_page.dart';

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
    routes: [
      _splashRoute,
      _mainRoute,
      _productDetailRoute,
      _signInRoute,
      _registerRoute,
      _categoryDetailRoute,
    ],
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
    routes: [_homeRoute, _cartRoute, _profileRoute, _categoriesRoute],
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

  /// Ruta de perfil
  static final GoRoute _profileRoute = GoRoute(
    path: 'profile',
    name: AppRoutes.profileName,
    builder: (context, state) => const ProfilePage(),
  );

  /// Ruta de categorías
  static final GoRoute _categoriesRoute = GoRoute(
    path: 'categories',
    name: AppRoutes.categoriesName,
    redirect:
        (context, state) =>
            '/main/home', // Redirigir a home donde están las categorías
  );

  /// Ruta de detalle de categoría
  static final GoRoute _categoryDetailRoute = GoRoute(
    path: AppRoutes.categoryDetail,
    name: AppRoutes.categoryDetailName,
    builder: (context, state) {
      final categoryId = state.pathParameters['categoryId'] ?? '';
      final extra = state.extra as Map<String, dynamic>?;
      final allCategories =
          extra?['allCategories'] as List<CategoryApiModel>? ?? [];

      // Buscar la categoría seleccionada
      CategoryApiModel? selectedCategory;
      if (allCategories.isNotEmpty) {
        // Buscar la categoría en la lista plana de todas las categorías
        for (final category in allCategories) {
          if (category.id == categoryId) {
            selectedCategory = category;
            break;
          }

          // Buscar en subcategorías
          final flattenedCategories = category.getAllCategories();
          for (final subCategory in flattenedCategories) {
            if (subCategory.id == categoryId) {
              selectedCategory = subCategory;
              break;
            }
          }

          if (selectedCategory != null) break;
        }
      }

      // Si no encontramos la categoría, mostrar mensaje de error
      if (selectedCategory == null) {
        return Scaffold(
          appBar: AppBar(title: const Text('Categoría')),
          body: const Center(child: Text('Categoría no encontrada')),
        );
      }

      // Mostrar la página de detalle de categoría
      return CategoryDetailPage(
        category: selectedCategory,
        allCategories: allCategories,
      );
    },
    // Ahora subcategory es una subruta de category
    routes: [
      // Ruta para subcategorías como subruta de categoria
      GoRoute(
        path: 'subcategory/:subCategoryId',
        name: AppRoutes.subcategoryName,
        builder: (context, state) {
          final parentCategoryId = state.pathParameters['categoryId'] ?? '';
          final subCategoryId = state.pathParameters['subCategoryId'] ?? '';
          final extra = state.extra as Map<String, dynamic>?;
          final allCategories = extra?['allCategories'] as List<CategoryApiModel>? ?? [];

          // Buscar primero la categoría padre
          CategoryApiModel? parentCategory;
          if (allCategories.isNotEmpty) {
            for (final category in allCategories) {
              if (category.id == parentCategoryId) {
                parentCategory = category;
                break;
              }
            }
          }

          // Buscar la subcategoría
          CategoryApiModel? subcategory;
          if (parentCategory != null) {
            // Buscar directamente en los hijos de la categoría padre
            subcategory = parentCategory.children.firstWhere(
              (sub) => sub.id == subCategoryId,
              orElse: () => CategoryApiModel(id: subCategoryId, name: 'Subcategoría'),
            );
          } else {
            // Si no encontramos el padre, buscar la subcategoría en toda la lista
            for (final category in allCategories) {
              final flattenedSubcategories = category.getAllCategories();
              for (final sub in flattenedSubcategories) {
                if (sub.id == subCategoryId) {
                  subcategory = sub;
                  break;
                }
              }
              if (subcategory != null) break;
            }
          }

          if (subcategory == null) {
            return Scaffold(
              appBar: AppBar(title: const Text('Subcategoría')),
              body: const Center(child: Text('Subcategoría no encontrada')),
            );
          }

          return CategoryDetailPage(
            category: subcategory,
            allCategories: allCategories,
          );
        },
      ),
    ],
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

  /// Ruta de inicio de sesión
  static final GoRoute _signInRoute = GoRoute(
    path: AppRoutes.signIn,
    name: AppRoutes.signInName,
    builder: (context, state) => const SignInPage(),
  );

  /// Ruta de registro
  static final GoRoute _registerRoute = GoRoute(
    path: AppRoutes.register,
    name: AppRoutes.registerName,
    builder: (context, state) => const RegisterPage(),
  );

  /// Métodos de navegación

  /// Navega a la página principal (reemplaza toda la pila)
  static void goToMain(BuildContext context) {
    try {
      context.goNamed(AppRoutes.mainName);
    } catch (e) {
      debugPrint('Error navegando a main: $e');
    }
  }

  /// Navega a la página de inicio
  static void goToHome(BuildContext context) {
    try {
      context.goNamed(AppRoutes.homeName);
    } catch (e) {
      debugPrint('Error navegando a home: $e');
    }
  }

  /// Navega a la página de carrito
  static void goToCart(BuildContext context) {
    try {
      context.goNamed(AppRoutes.cartName);
    } catch (e) {
      debugPrint('Error navegando a carrito: $e');
    }
  }

  /// Navega a la página de perfil
  static void goToProfile(BuildContext context) {
    try {
      context.goNamed(AppRoutes.profileName);
    } catch (e) {
      debugPrint('Error navegando a perfil: $e');
    }
  }

  /// Empuja la página de carrito
  static void pushCart(BuildContext context) {
    try {
      context.pushNamed(AppRoutes.cartName);
    } catch (e) {
      debugPrint('Error empujando carrito: $e');
    }
  }

  /// Navega al detalle de un producto evitando duplicados
  static void goToProductDetail(
    BuildContext context, {
    required String productId,
    ProductItemModel? product,
  }) {
    try {
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
    } catch (e) {
      debugPrint('Error navegando a detalle de producto $productId: $e');
    }
  }

  /// Navega a la página de categorias
  static void goToCategories(BuildContext context) {
    try {
      context.goNamed(AppRoutes.categoriesName);
    } catch (e) {
      debugPrint('Error navegando a categorías: $e');
    }
  }

  /// Navega a la página de inicio de sesión
  static void goToSignIn(BuildContext context) {
    try {
      context.goNamed(AppRoutes.signInName);
    } catch (e) {
      debugPrint('Error navegando a inicio de sesión: $e');
    }
  }

  /// Navega a la página de registro
  static void goToRegister(BuildContext context) {
    try {
      context.goNamed(AppRoutes.registerName);
    } catch (e) {
      debugPrint('Error navegando a registro: $e');
    }
  }

  /// Método para eliminar un ID de producto de la lista de abiertos
  static void removeOpenProductId(String productId) {
    _openProductIds.remove(productId);
  }
}
