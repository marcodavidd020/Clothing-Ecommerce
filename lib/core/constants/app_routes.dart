/// Constantes para las rutas de la aplicación.
class AppRoutes {
  /// Constantes no instanciables
  const AppRoutes._();

  /// Ruta raíz de la aplicación
  static const String splash = '/';

  /// Ruta para la página principal (shell)
  static const String main = '/main';

  /// Ruta para la página de inicio
  static const String home = '/home';

  /// Ruta para la página de carrito
  static const String cart = '/cart';

  /// Ruta para la página de perfil
  static const String profile = '/profile';

  /// Ruta para las categorias
  static const String categories = '/categories';

  /// Ruta para detalle de categoría
  static const String categoryDetail = '/category/:categoryId';

  /// Ruta para subcategorías (como subruta de categoría)
  static const String subcategory = 'subcategory/:subCategoryId';

  /// Lista de productos por categoria (obsoleta, usar categoryDetail)
  @Deprecated('Use categoryDetail instead')
  static const String categoryProducts = '/category-products/:categoryId';

  /// Ruta para la página de detalle de producto
  static const String productDetail = '/product-detail/:productId';

  /// Rutas de autenticación
  static const String signIn = '/auth/signin';
  static const String register = '/auth/register';
  static const String resetPassword = '/auth/reset-password';

  /// Nombres de rutas para usar con GoRouter
  static const String splashName = 'splash';
  static const String mainName = 'main';
  static const String homeName = 'home';
  static const String cartName = 'cart';
  static const String profileName = 'profile';
  static const String productDetailName = 'product-detail';
  static const String categoriesName = 'categories';
  static const String categoryDetailName = 'category-detail';
  static const String subcategoryName = 'subcategory';

  /// Obsoleto, usar categoryDetailName
  @Deprecated('Use categoryDetailName instead')
  static const String categoryProductsName = 'category-products';

  /// Nombres de rutas de autenticación
  static const String signInName = 'signin';
  static const String registerName = 'register';
  static const String resetPasswordName = 'reset-password';

  /// Parámetros
  static const String productIdParam = 'productId';
  static const String categoryIdParam = 'categoryId';
  static const String subCategoryIdParam = 'subCategoryId';
}
