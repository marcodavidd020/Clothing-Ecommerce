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
