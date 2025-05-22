import 'package:flutter_application_ecommerce/features/home/data/models/product_detail_model.dart';
import 'package:flutter_application_ecommerce/features/home/domain/entities/product_item_model.dart';
import 'home_state.dart';

/// Estado cuando hay carga de productos por categoría
class LoadingProductsByCategory extends HomeState {
  final String categoryId;
  final HomeLoaded previousState;

  LoadingProductsByCategory({
    required this.categoryId,
    required this.previousState,
  });
}

/// Estado cuando hay carga de detalle de producto
class LoadingProductDetail extends HomeState {
  final String productId;
  final HomeLoaded previousState;

  LoadingProductDetail({required this.productId, required this.previousState});
}

/// Estado cuando se carga correctamente el detalle de un producto
class ProductDetailLoaded extends HomeState {
  final ProductDetailModel product;
  final HomeLoaded previousState;

  ProductDetailLoaded({required this.product, required this.previousState});
}

/// Estado cuando se cargan correctamente los productos por categoría
class ProductsByCategoryLoaded extends HomeState {
  final String categoryId;
  final List<ProductItemModel> products;
  final HomeLoaded previousState;

  ProductsByCategoryLoaded({
    required this.categoryId,
    required this.products,
    required this.previousState,
  });
}
