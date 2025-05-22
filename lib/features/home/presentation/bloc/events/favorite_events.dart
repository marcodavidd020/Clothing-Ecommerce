import 'home_event.dart';

/// Evento para alternar el estado favorito de un producto
class ToggleFavoriteEvent extends HomeEvent {
  /// ID del producto
  final String productId;

  /// Nuevo estado favorito
  final bool isFavorite;

  /// Crea una instancia de [ToggleFavoriteEvent]
  ToggleFavoriteEvent({required this.productId, required this.isFavorite});
}
