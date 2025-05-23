import 'package:flutter_application_ecommerce/features/home/domain/entities/category_api_model.dart';
import 'package:flutter_application_ecommerce/features/home/domain/entities/category_item_model.dart';
import 'package:flutter_application_ecommerce/features/home/domain/entities/product_item_model.dart';
import 'home_state.dart';

/// Estado durante la carga inicial
class HomeLoading extends HomeState {}

/// Estado durante la carga parcial (solo algunas secciones)
class HomeLoadingPartial extends HomeState {
  /// Categorías actuales
  final List<CategoryItemModel> categories;

  /// Categorías de la API
  final List<CategoryApiModel> apiCategories;

  /// Si se están cargando las categorías
  final bool isLoadingCategories;

  /// Categoría raíz seleccionada actualmente
  final CategoryApiModel? selectedRootCategory;

  /// Si se están cargando los detalles de producto
  final bool isLoadingProductDetail;

  /// ID del producto de detalle actual
  final String? productDetailId;

  /// Productos más vendidos cargados
  final List<ProductItemModel> productsBestSellers;

  /// Productos más nuevos cargados
  final List<ProductItemModel> productsNewest;

  /// Crea una instancia de [HomeLoadingPartial]
  HomeLoadingPartial({
    required this.categories,
    required this.apiCategories,
    this.isLoadingCategories = false,
    this.selectedRootCategory,
    this.isLoadingProductDetail = false,
    this.productDetailId,
    this.productsBestSellers = const [],
    this.productsNewest = const [],
  });
}
