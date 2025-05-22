import 'package:flutter_application_ecommerce/features/home/domain/entities/category_api_model.dart';
import 'package:flutter_application_ecommerce/features/home/domain/entities/product_item_model.dart';
import 'home_state.dart';

/// Estado durante la carga de una categoría por ID
class CategoryByIdLoading extends HomeState {
  /// ID de la categoría
  final String categoryId;

  /// Crea una instancia de [CategoryByIdLoading]
  CategoryByIdLoading({required this.categoryId});
}

/// Estado cuando se ha cargado una categoría específica por ID
class CategoryByIdLoaded extends HomeState {
  /// ID de la categoría
  final String categoryId;

  /// La categoría cargada
  final CategoryApiModel category;

  /// Crea una instancia de [CategoryByIdLoaded]
  CategoryByIdLoaded({required this.categoryId, required this.category});
}

/// Estado de error al cargar una categoría específica por ID
class CategoryByIdError extends HomeState {
  /// ID de la categoría
  final String categoryId;

  /// Mensaje de error
  final String message;

  /// Crea una instancia de [CategoryByIdError]
  CategoryByIdError({required this.categoryId, required this.message});
}

/// Estado durante la carga de productos de una categoría
class CategoryProductsLoading extends HomeState {
  /// ID de la categoría
  final String categoryId;

  /// Crea una instancia de [CategoryProductsLoading]
  CategoryProductsLoading({required this.categoryId});
}

/// Estado cuando se han cargado los productos de una categoría correctamente
class CategoryProductsLoaded extends HomeState {
  /// ID de la categoría
  final String categoryId;

  /// Productos cargados
  final List<ProductItemModel> products;

  /// Crea una instancia de [CategoryProductsLoaded]
  CategoryProductsLoaded({required this.categoryId, required this.products});
}

/// Estado de error al cargar productos de una categoría
class CategoryProductsError extends HomeState {
  /// ID de la categoría
  final String categoryId;

  /// Mensaje de error
  final String message;

  /// Crea una instancia de [CategoryProductsError]
  CategoryProductsError({required this.categoryId, required this.message});
}
