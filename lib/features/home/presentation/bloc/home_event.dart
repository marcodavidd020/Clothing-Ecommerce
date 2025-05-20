part of 'home_bloc.dart';

/// Clase base para todos los eventos del HomeBloc
@immutable
abstract class HomeEvent {}

/// Evento para cargar todos los datos de la pantalla de inicio
class LoadHomeDataEvent extends HomeEvent {}

/// Evento para cargar solo las categorías
class LoadCategoriesEvent extends HomeEvent {}

/// Evento para cargar categorías desde la API
class LoadApiCategoriesTreeEvent extends HomeEvent {}

/// Evento para cargar solo los productos más vendidos
class LoadTopSellingProductsEvent extends HomeEvent {}

/// Evento para cargar solo los productos nuevos
class LoadNewInProductsEvent extends HomeEvent {}

/// Evento para cargar los productos de una categoría específica
class LoadProductsByCategoryEvent extends HomeEvent {
  /// ID de la categoría
  final String categoryId;

  /// Crea una instancia de [LoadProductsByCategoryEvent]
  LoadProductsByCategoryEvent({required this.categoryId});
}

/// Evento para seleccionar una categoría raíz
class SelectRootCategoryEvent extends HomeEvent {
  /// Categoría seleccionada
  final CategoryApiModel category;

  /// Crea una instancia de [SelectRootCategoryEvent]
  SelectRootCategoryEvent({required this.category});
}

/// Evento para alternar el estado favorito de un producto
class ToggleFavoriteEvent extends HomeEvent {
  /// ID del producto
  final String productId;

  /// Nuevo estado favorito
  final bool isFavorite;

  /// Crea una instancia de [ToggleFavoriteEvent]
  ToggleFavoriteEvent({required this.productId, required this.isFavorite});
}
