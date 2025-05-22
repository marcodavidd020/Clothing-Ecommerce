import 'package:flutter_application_ecommerce/features/home/domain/entities/category_api_model.dart';
import 'home_event.dart';

/// Evento para cargar solo las categorías
class LoadCategoriesEvent extends HomeEvent {}

/// Evento para cargar categorías desde la API
class LoadApiCategoriesTreeEvent extends HomeEvent {}

/// Evento para cargar una categoría específica por su ID
class LoadCategoryByIdEvent extends HomeEvent {
  /// ID de la categoría a cargar
  final String categoryId;

  /// Constructor del evento
  LoadCategoryByIdEvent({required this.categoryId});
}

/// Evento para seleccionar una categoría raíz
class SelectRootCategoryEvent extends HomeEvent {
  /// Categoría seleccionada
  final CategoryApiModel category;

  /// Crea una instancia de [SelectRootCategoryEvent]
  SelectRootCategoryEvent({required this.category});
}
