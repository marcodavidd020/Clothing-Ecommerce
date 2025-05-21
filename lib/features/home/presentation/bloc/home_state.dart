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

  /// Categorías de la API
  final List<CategoryApiModel> apiCategories;

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

  /// Categoría raíz seleccionada actualmente
  final CategoryApiModel? selectedRootCategory;

  /// Si se están cargando los detalles de producto
  final bool isLoadingProductDetail;

  /// ID del producto de detalle actual
  final String? productDetailId;

  /// Crea una instancia de [HomeLoadingPartial]
  HomeLoadingPartial({
    required this.categories,
    required this.apiCategories,
    required this.topSellingProducts,
    required this.newInProducts,
    this.isLoadingCategories = false,
    this.isLoadingTopSelling = false,
    this.isLoadingNewIn = false,
    this.selectedRootCategory,
    this.isLoadingProductDetail = false,
    this.productDetailId,
  });
}

/// Estado cuando se han cargado los datos correctamente
class HomeLoaded extends HomeState {
  /// Categorías cargadas
  final List<CategoryItemModel> categories;

  /// Categorías de la API en estructura de árbol
  final List<CategoryApiModel> apiCategories;

  /// Productos más vendidos cargados
  final List<ProductItemModel> topSellingProducts;

  /// Productos nuevos cargados
  final List<ProductItemModel> newInProducts;

  /// Categoría raíz seleccionada actualmente
  final CategoryApiModel? selectedRootCategory;

  /// Categoría seleccionada actualmente
  final CategoryApiModel? selectedCategory;

  /// Productos por categoría cargados
  final List<ProductItemModel> productsByCategory;

  /// Detalle del producto actual
  final ProductDetailModel? productDetail;

  /// Crea una instancia de [HomeLoaded]
  HomeLoaded({
    required this.categories,
    this.apiCategories = const [],
    required this.topSellingProducts,
    required this.newInProducts,
    this.selectedRootCategory,
    this.selectedCategory,
    this.productsByCategory = const [],
    this.productDetail,
  });

  /// Crea una copia de este estado con los valores proporcionados
  HomeLoaded copyWith({
    List<CategoryItemModel>? categories,
    List<CategoryApiModel>? apiCategories,
    List<ProductItemModel>? topSellingProducts,
    List<ProductItemModel>? newInProducts,
    CategoryApiModel? selectedRootCategory,
    CategoryApiModel? selectedCategory,
    List<ProductItemModel>? productsByCategory,
    ProductDetailModel? productDetail,
  }) {
    return HomeLoaded(
      categories: categories ?? this.categories,
      apiCategories: apiCategories ?? this.apiCategories,
      topSellingProducts: topSellingProducts ?? this.topSellingProducts,
      newInProducts: newInProducts ?? this.newInProducts,
      selectedRootCategory: selectedRootCategory ?? this.selectedRootCategory,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      productsByCategory: productsByCategory ?? this.productsByCategory,
      productDetail: productDetail ?? this.productDetail,
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

  /// Productos más vendidos actuales (si hay)
  final List<ProductItemModel>? topSellingProducts;

  /// Productos nuevos actuales (si hay)
  final List<ProductItemModel>? newInProducts;

  /// Categoría raíz seleccionada actualmente (si hay)
  final CategoryApiModel? selectedRootCategory;

  /// Detalle del producto actual (si hay)
  final ProductDetailModel? productDetail;

  /// Crea una instancia de [HomeError]
  HomeError({
    required this.message,
    this.categories,
    this.apiCategories,
    this.topSellingProducts,
    this.newInProducts,
    this.selectedRootCategory,
    this.productDetail,
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

// Estados para la carga de una categoría específica por ID
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
