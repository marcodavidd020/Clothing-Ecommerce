import 'package:flutter_application_ecommerce/features/home/domain/entities/category_api_model.dart';
import 'package:flutter_application_ecommerce/features/home/domain/entities/category_item_model.dart';
import 'package:flutter_application_ecommerce/features/home/domain/entities/product_item_model.dart';
import 'package:flutter_application_ecommerce/features/home/data/models/product_detail_model.dart';
import 'package:meta/meta.dart';

/// Clase base para todos los estados del HomeBloc
@immutable
abstract class HomeState {}

/// Estado inicial
class HomeInitial extends HomeState {}

/// Estado cuando se han cargado los datos correctamente
class HomeLoaded extends HomeState {
  /// Categorías cargadas
  final List<CategoryItemModel> categories;

  /// Categorías de la API en estructura de árbol
  final List<CategoryApiModel> apiCategories;

  /// Categoría raíz seleccionada actualmente
  final CategoryApiModel? selectedRootCategory;

  /// Categoría seleccionada actualmente
  final CategoryApiModel? selectedCategory;

  /// Productos por categoría cargados
  final List<ProductItemModel> productsByCategory;

  /// Detalle del producto actual
  final ProductDetailModel? productDetail;

  /// Productos más vendidos cargados
  final List<ProductItemModel> productsBestSellers;

  /// Productos más nuevos cargados
  final List<ProductItemModel> productsNewest;

  /// Crea una instancia de [HomeLoaded]
  HomeLoaded({
    required this.categories,
    this.apiCategories = const [],
    this.selectedRootCategory,
    this.selectedCategory,
    this.productsByCategory = const [],
    this.productDetail,
    this.productsBestSellers = const [],
    this.productsNewest = const [],
  });

  /// Crea una copia de este estado con los valores proporcionados
  HomeLoaded copyWith({
    List<CategoryItemModel>? categories,
    List<CategoryApiModel>? apiCategories,
    CategoryApiModel? selectedRootCategory,
    CategoryApiModel? selectedCategory,
    List<ProductItemModel>? productsByCategory,
    ProductDetailModel? productDetail,
    List<ProductItemModel>? productsBestSellers,
    List<ProductItemModel>? productsNewest,
  }) {
    return HomeLoaded(
      categories: categories ?? this.categories,
      apiCategories: apiCategories ?? this.apiCategories,
      selectedRootCategory: selectedRootCategory ?? this.selectedRootCategory,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      productsByCategory: productsByCategory ?? this.productsByCategory,
      productDetail: productDetail ?? this.productDetail,
      productsBestSellers: productsBestSellers ?? this.productsBestSellers,
      productsNewest: productsNewest ?? this.productsNewest,
    );
  }
}

/// Estado de error
class HomeError extends HomeState {
  /// Mensaje de error
  final String message;

  /// Categorías actuales (si hay)
  final List<CategoryItemModel>? categories;

  /// Categorías de la API (si hay)
  final List<CategoryApiModel>? apiCategories;

  /// Categoría raíz seleccionada actualmente (si hay)
  final CategoryApiModel? selectedRootCategory;

  /// Productos más vendidos cargados
  final List<ProductItemModel>? productsBestSellers;

  /// Productos más nuevos cargados
  final List<ProductItemModel>? productsNewest;

  /// Detalle del producto actual (si hay)
  final ProductDetailModel? productDetail;

  /// Crea una instancia de [HomeError]
  HomeError({
    required this.message,
    this.categories,
    this.apiCategories,
    this.selectedRootCategory,
    this.productDetail,
    this.productsBestSellers,
    this.productsNewest,
  });
}
