/// Define cadenas de texto (literales) utilizadas en toda la aplicación.
///
/// Centralizar los strings facilita la localización y el mantenimiento.
class AppStrings {
  // --- Títulos de Pantalla --- ///
  static const String signInTitle = 'Sign in';
  static const String registerTitle = 'Create Account';

  // --- Textos de Botones y Acciones --- ///
  static const String continueLabel = 'Continue';
  static const String createAccountLabel = 'Create One';
  static const String forgotPasswordLabel = 'Forgot Password ? ';
  static const String resetLabel = 'Reset';
  static const String dontHaveAccount = 'Dont have an Account ? ';
  static const String seeAllLabel = 'See All';

  // --- Textos para Botones Sociales --- ///
  static const String continueWithApple = 'Continue With Apple';
  static const String continueWithGoogle = 'Continue With Google';
  static const String continueWithFacebook = 'Continue With Facebook';

  // --- Rutas de Iconos (considerar mover a una clase AppAssets si crece) --- ///
  /// Ruta al icono de retroceso.
  static const String backIcon = 'assets/icons/back.svg';
  /// Ruta al icono de flecha hacia abajo.
  static const String arrowDownIcon = 'assets/icons/arrowdown.svg';
  /// Ruta al icono de bolsa de compras.
  static const String bagIcon = 'assets/icons/bag.svg';
  /// Ruta al icono de búsqueda.
  static const String searchIcon = 'assets/icons/search.svg';
  /// Ruta al icono placeholder para la imagen de perfil del usuario.
  static const String userPlaceholderIcon = 'assets/icons/user_placeholder.png';
  /// Ruta al icono de home para la barra de navegación.
  static const String homeIcon = 'assets/icons/home.svg';
  /// Ruta al icono de notificación para la barra de navegación.
  static const String notificationIcon = 'assets/icons/notification.svg';
  /// Ruta al icono de recibo/factura para la barra de navegación.
  static const String receiptIcon = 'assets/icons/receip.svg';
  /// Ruta al icono de perfil para la barra de navegación.
  static const String profileIcon = 'assets/icons/profile.svg';
  /// Ruta al icono de corazón.
  static const String heartIcon = 'assets/icons/heart.svg';

  // --- Textos Placeholder/Hints para Campos de Formulario --- ///
  static const String emailHint = 'Email Address';
  static const String passwordHint = 'Password';
  static const String firstnameHint = 'Firstname';
  static const String lastnameHint = 'Lastname';
  // static const String searchHint = 'Search...'; // Ejemplo si se necesita para SearchBarWidget

  // --- Mensajes de Validación de Formularios --- ///
  static const String enterEmailError = 'Por favor ingresa Email Address';
  static const String invalidEmailError = 'Por favor ingresa un email válido';
  static const String enterPasswordError = 'Por favor ingresa Password';
  static const String invalidPasswordError = 'La contraseña debe tener al menos 6 caracteres';
  static const String enterFirstnameError = 'Por favor ingresa Firstname';
  static const String enterLastnameError = 'Por favor ingresa Lastname';

  // --- Categorías (ejemplos, podrían venir de un backend) --- ///
  static const String categoriesTitle = 'Categories';
  static const String hoodiesLabel = 'Hoodies';
  static const String shortsLabel = 'Shorts';
  static const String shoesLabel = 'Shoes';
  static const String bagLabel = 'Bag';
  static const String accessoriesLabel = 'Accessories';

  // Icons
  static const String logo = 'assets/logo.png';
  static const String appleIcon = 'assets/icons/apple.png';
  static const String googleIcon = 'assets/icons/google.png';
  static const String facebookIcon = 'assets/icons/facebook.png';

  // Home
  static const String homeTitle = 'Home';
  static const String menTitle = 'Men';
  static const String womenTitle = 'Women';
  static const String kidsTitle = 'Kids';

  // Search
  static const String homeSearchHint = 'Search';

  // Top Selling
  static const String topSellingTitle = 'Top Selling';
  static const String seeAllTopSelling = 'See All';

  // New In
  static const String newInTitle = 'New In';

  // All Categories Page
  static const String shopByCategoriesTitle = 'Shop by Categories';
  static const String noCategoriesFound = 'No categories found.';

  // Category Products Page
  static const String noProductsFound = 'No products found in this category.';

  // Product Detail Page
  // static const String quantityLabel = 'Quantity';
  // static const String noImageAvailable = 'No Image';
  // static const String defaultColorName = 'Default';
  // static const String notAvailableSize = 'N/A';

  // Generic Error
  static const String somethingWentWrong = 'Something went wrong. Please try again.';
}
