import 'home_event.dart';

/// Evento para cargar los productos de una categoría específica
class LoadProductsByCategoryEvent extends HomeEvent {
  /// ID de la categoría
  final String categoryId;

  /// Crea una instancia de [LoadProductsByCategoryEvent]
  LoadProductsByCategoryEvent({required this.categoryId});
}

/// Evento para cargar detalles de un producto específico
class LoadProductByIdEvent extends HomeEvent {
  /// ID del producto
  final String productId;

  /// Crea una instancia de [LoadProductByIdEvent]
  LoadProductByIdEvent({required this.productId});
}

// Evento para cargar los productos más vendidos
class LoadProductsBestSellersEvent extends HomeEvent {
  /// ID de la categoría
  final String categoryId;

  /// Crea una instancia de [LoadProductsBestSellersEvent]
  LoadProductsBestSellersEvent({required this.categoryId});
}

/// Evento para cargar los productos más nuevos
class LoadProductsNewestEvent extends HomeEvent {
  /// ID de la categoría
  final String categoryId;

  /// Crea una instancia de [LoadProductsNewestEvent]
  LoadProductsNewestEvent({required this.categoryId});
}
