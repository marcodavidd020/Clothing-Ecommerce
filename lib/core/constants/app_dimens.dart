import 'package:flutter/material.dart';

/// Define dimensiones y espaciados estándar utilizados en la aplicación.
///
/// Ayuda a mantener la consistencia en el diseño de la interfaz de usuario.
class AppDimens {
  // --- Paddings --- ///

  /// Padding estándar para los bordes de la pantalla.
  static const double screenPadding = 24.0;

  /// Padding vertical para el contenido dentro de contenedores o campos.
  static const double contentPaddingVertical = 16.0;

  /// Padding horizontal para el contenido dentro de contenedores o campos.
  static const double contentPaddingHorizontal = 16.0;

  /// Padding izquierdo para el icono en botones sociales.
  static const double socialButtonIconLeft = 19.42;

  /// Padding vertical para botones sociales.
  static const double socialButtonPaddingVertical = 11.0;

  // --- Spacing --- ///

  /// Espacio vertical de 1 unidad lógica.
  static const double vSpace1 = 1.0;

  /// Espacio vertical de 2 unidades lógicas.
  static const double vSpace2 = 2.0;

  /// Espacio vertical de 4 unidades lógicas.
  static const double vSpace4 = 4.0;

  /// Espacio vertical de 8 unidades lógicas, comúnmente la mitad de vSpace16.
  static const double vSpace8 = 8.0;

  /// Espacio vertical de 12 unidades lógicas.
  static const double vSpace12 = 12.0;

  /// Espacio vertical de 16 unidades lógicas.
  static const double vSpace16 = 16.0;

  /// Espacio vertical de 24 unidades lógicas.
  static const double vSpace24 = 24.0;

  /// Espacio vertical de 32 unidades lógicas.
  static const double vSpace32 = 32.0;

  // --- Button --- ///

  /// Altura estándar para botones primarios.
  static const double buttonHeight = 49.0;

  /// Radio de borde estándar para botones (especialmente los redondeados).
  static const double buttonRadius = 100.0;

  // --- Icon --- ///

  /// Tamaño estándar para iconos.
  static const double iconSize = 24.0;

  /// Espacio entre un icono y su etiqueta de texto.
  static const double iconLabelGap = 12.15;

  // --- Back button --- ///

  /// Tamaño (ancho y alto) del botón de retroceso circular.
  static const double backButtonSize = 50.0;

  /// Tamaño del icono dentro del botón de retroceso.
  static const double backIconSize = 20.0;

  // --- Gender Selector Button --- ///

  /// Padding/espaciado unificado para el botón selector de género.
  static const double genderSelectorPadding = 12.0;

  // Search Bar
  static const double homeSearchPaddingHorizontal = 22.0;
  static const double homeSearchPaddingVertical = 12.0;

  //logo
  static const double logoWidth = 175.0;
  static const double logoHeight = 80.0;

  // Pading Categories why categories item
  static const double categoriesItemPadding = 16.0;

  // Size height
  static const double categoriesItemHeight = 105.0;

  // Image
  static const double categoriesItemImageSize = 70.0;

  // Heart position
  static const double heartPositionTop = 8.0;
  static const double heartPositionRight = 8.0;

  // Heart padding
  static const double heartPadding = 6.0;

  // Heart size
  static const double heartSizeIcon = 16.0;

  // Product item
  static const double productItemWidth = 180.0;
  static const double productItemHeight = 220.0;

  // Product item border radius
  static const double productItemBorderRadius = 12.0;

  // Top selling section
  static const double topSellingSectionHeight = 320.0;

  // Star rating
  static const double starRatingSize = 14.0;

  // Category Products Page
  static const double categoryProductGridAspectRatio = 0.62;

  // Product Detail Page
  static const double productDetailCarouselHeight = 300.0;
  static const double carouselIndicatorSize = 8.0;
  static const double carouselIndicatorVerticalMargin = 10.0;
  static const double carouselIndicatorHorizontalMargin = 2.0;
  static const double optionSelectorArrowSize = 22.0;
  static const double colorPickerAvatarRadius = 12.0;
  static const double quantitySelectorFontSize = 16.0;
  static const double quantityButtonIconSize = 18.0;
  static const double appBarActionRightPadding = 14.0; // screenPadding (24) - 10
  static const double productDetailNameFontSize = 16.0;
  static const double productDetailPriceFontSize = 16.0;
  static const double colorSelectorValueAvatarRadius = 8.0;
  static const double descriptionTitleFontSize = 16.0;
  static const double descriptionLineHeight = 1.5;
  static const double quantityButtonPadding = 8.0; // AppDimens.vSpace8 / 2

  // Home Page Content Fade Effect
  static const double homeContentFadeStart = 0.85; // Punto donde comienza el difuminado
  static const double homeContentFadeEnd = 1.0;   // Punto donde el difuminado es completo (transparente)

  static const double bottomNavBarIconSize = 24.0;
  static const double bottomNavBarElevation = 0.0; // Sin elevación

  // Dimensiones para el Selector de Opciones (Color/Talla)
  static const double optionItemBorderRadius = 25.0; // Radio de borde para cada ítem
  static const double optionColorCircleSize = 24.0; // Tamaño del círculo de color
  static const double optionTextIconSpacing = 16.0; // Espacio entre texto y círculo/icono
  static const EdgeInsets optionItemPadding = EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0);
  static const EdgeInsets optionListPadding = EdgeInsets.symmetric(vertical: 8.0); // Padding para la lista de opciones

  // Splash Page
  static const double splashLogoHeight = 100.0;
}
