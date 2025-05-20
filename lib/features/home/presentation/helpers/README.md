# Home Module Helpers

Este directorio contiene clases auxiliares para el módulo Home que facilitan la reutilización de código y mejoran la mantenibilidad.

## HomeUIHelpers

Proporciona métodos para construir componentes de UI comunes en las pantallas del módulo Home:

- `buildSectionTitle`: Construye un título de sección con botón "Ver todos" opcional
- `smallVerticalSpace`, `mediumVerticalSpace`, `largeVerticalSpace`: Espaciadores verticales estándar
- `buildProductItemContainer`: Contenedor con estilo consistente para elementos de producto
- `loadingPlaceholder`: Indicador de carga estándar
- Métodos de formateo: `formatPrice`, `formatOriginalPrice`
- Métodos de utilidad para productos: `hasDiscount`, `calculateDiscountPercentage`

## HomeBlocHandler

Encapsula la interacción con HomeBloc y proporciona métodos para:

- `handleHomeState`: Maneja los estados del HomeBloc y muestra feedback al usuario
- `isLoading`: Verifica si el HomeBloc está en estado de carga
- `loadHomeData`, `loadApiCategories`, etc.: Despacha eventos comunes al HomeBloc
- `toggleFavorite`: Maneja la lógica para marcar/desmarcar favoritos con feedback visual
- `selectRootCategory`: Selecciona una categoría raíz con feedback visual

## HomeNavigationHelper

Encapsula la navegación específica del módulo Home con prevención de navegaciones duplicadas:

- `goToProductDetail`: Navega al detalle de un producto
- `goToCategoryProducts`: Navega a la página de productos por categoría
- `goToAllCategories`: Navega a la página de todas las categorías
- `goToSearch`, `goToCart`, `goToProfile`: Navega a otras páginas de la aplicación

## Uso

Importa estos helpers desde cualquier archivo del módulo Home:

```dart
import 'package:flutter_application_ecommerce/features/home/presentation/helpers/helpers.dart';
```

Ejemplos de uso:

```dart
// Construir un título de sección
HomeUIHelpers.buildSectionTitle(
  title: 'Productos destacados',
  onSeeAllPressed: () => print('Ver todos'),
);

// Despachar un evento al bloc
HomeBlocHandler.loadHomeData(context);

// Navegar a una página
HomeNavigationHelper.goToProductDetail(context, product);
``` 