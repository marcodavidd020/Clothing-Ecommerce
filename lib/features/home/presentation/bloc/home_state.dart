part of 'home_bloc.dart';

/// Clase base para todos los estados del HomeBloc
@immutable
abstract class HomeState {}

/// Estado inicial
class HomeInitial extends HomeState {}

/// Estado durante la carga inicial
class HomeLoading extends HomeState {}

/// Estado durante la carga parcial (solo algunas secciones)
class HomeLoadingPartial extends HomeState {
  /// Categorías actuales
  final List<CategoryItemModel> categories;

  /// Productos más vendidos actuales
  final List<ProductItemModel> topSellingProducts;

  /// Productos nuevos actuales
  final List<ProductItemModel> newInProducts;

  /// Si se están cargando las categorías
  final bool isLoadingCategories;

  /// Si se están cargando los productos más vendidos
  final bool isLoadingTopSelling;

  /// Si se están cargando los productos nuevos
  final bool isLoadingNewIn;

  /// Crea una instancia de [HomeLoadingPartial]
  HomeLoadingPartial({
    required this.categories,
    required this.topSellingProducts,
    required this.newInProducts,
    this.isLoadingCategories = false,
    this.isLoadingTopSelling = false,
    this.isLoadingNewIn = false,
  });
}

/// Estado cuando se han cargado los datos correctamente
class HomeLoaded extends HomeState {
  /// Categorías cargadas
  final List<CategoryItemModel> categories;

  /// Productos más vendidos cargados
  final List<ProductItemModel> topSellingProducts;

  /// Productos nuevos cargados
  final List<ProductItemModel> newInProducts;

  /// Crea una instancia de [HomeLoaded]
  HomeLoaded({
    required this.categories,
    required this.topSellingProducts,
    required this.newInProducts,
  });
}

/// Estado de error
class HomeError extends HomeState {
  /// Mensaje de error
  final String message;

  /// Categorías actuales (si hay)
  final List<CategoryItemModel>? categories;

  /// Productos más vendidos actuales (si hay)
  final List<ProductItemModel>? topSellingProducts;

  /// Productos nuevos actuales (si hay)
  final List<ProductItemModel>? newInProducts;

  /// Crea una instancia de [HomeError]
  HomeError({
    required this.message,
    this.categories,
    this.topSellingProducts,
    this.newInProducts,
  });
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
