import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_application_ecommerce/core/error/failures.dart';
import 'package:flutter_application_ecommerce/features/home/domain/domain.dart';
import 'package:meta/meta.dart';

part 'home_event.dart';
part 'home_state.dart';

/// BLoC para manejar el estado de la pantalla de inicio
class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final GetTopSellingProductsUseCase _getTopSellingProductsUseCase;
  final GetNewInProductsUseCase _getNewInProductsUseCase;
  final GetProductsByCategoryUseCase _getProductsByCategoryUseCase;
  final GetApiCategoriesTreeUseCase _getApiCategoriesTreeUseCase;
  final GetCategoryByIdUseCase _getCategoryByIdUseCase;

  HomeBloc({
    required GetTopSellingProductsUseCase getTopSellingProductsUseCase,
    required GetNewInProductsUseCase getNewInProductsUseCase,
    required GetProductsByCategoryUseCase getProductsByCategoryUseCase,
    required GetApiCategoriesTreeUseCase getApiCategoriesTreeUseCase,
    required GetCategoryByIdUseCase getCategoryByIdUseCase,
  }) : _getTopSellingProductsUseCase = getTopSellingProductsUseCase,
       _getNewInProductsUseCase = getNewInProductsUseCase,
       _getProductsByCategoryUseCase = getProductsByCategoryUseCase,
       _getApiCategoriesTreeUseCase = getApiCategoriesTreeUseCase,
       _getCategoryByIdUseCase = getCategoryByIdUseCase,
       super(HomeInitial()) {
    // Eventos para cargar datos al iniciar
    on<LoadHomeDataEvent>(_onLoadHomeData);

    // Eventos para cargar datos específicos
    on<LoadCategoriesEvent>(_onLoadCategories);
    on<LoadApiCategoriesTreeEvent>(_onLoadApiCategoriesTree);
    on<LoadTopSellingProductsEvent>(_onLoadTopSellingProducts);
    on<LoadNewInProductsEvent>(_onLoadNewInProducts);
    on<LoadProductsByCategoryEvent>(_onLoadProductsByCategory);
    on<LoadCategoryByIdEvent>(_onLoadCategoryById);

    // Eventos de favoritos
    on<ToggleFavoriteEvent>(_onToggleFavorite);

    // Eventos de selección de categoría raíz
    on<SelectRootCategoryEvent>(_onSelectRootCategory);
  }

  // Nuevo manejador para seleccionar una categoría raíz
  void _onSelectRootCategory(
    SelectRootCategoryEvent event,
    Emitter<HomeState> emit,
  ) {
    if (state is HomeLoaded) {
      final currentState = state as HomeLoaded;
      emit(
        HomeLoaded(
          categories: currentState.categories,
          apiCategories: currentState.apiCategories,
          topSellingProducts: currentState.topSellingProducts,
          newInProducts: currentState.newInProducts,
          selectedRootCategory: event.category,
        ),
      );
    }
  }

  // Manejador para cargar todos los datos de la pantalla de inicio
  Future<void> _onLoadHomeData(
    LoadHomeDataEvent event,
    Emitter<HomeState> emit,
  ) async {
    emit(HomeLoading());

    // Intentamos cargar categorías desde la API primero
    final apiTreeResult = await _getApiCategoriesTreeUseCase.execute();
    final topSellingResult = await _getTopSellingProductsUseCase.execute();
    final newInResult = await _getNewInProductsUseCase.execute();

    // Usamos categorías de API si están disponibles, de lo contrario usamos las locales
    final List<CategoryItemModel> categories = [];

    // Si tenemos categorías del API, convertirlas a CategoryItemModel
    apiTreeResult.fold(
      (failure) {
        // Si falla API, usamos categorías locales
      },
      (apiCategories) {
        // Convertimos categorías de API a formato compatible
        for (var category in apiCategories) {
          categories.add(category.toCategoryItemModel());
          // También podríamos agregar categorías hijas si queremos mostrarlas
          for (var child in category.children) {
            categories.add(child.toCategoryItemModel());
          }
        }
      },
    );

    // Verificamos si hay errores en productos
    if (topSellingResult.isLeft() || newInResult.isLeft()) {
      // Obtenemos el primer error que encontremos
      late Failure failure;

      if (topSellingResult.isLeft()) {
        topSellingResult.fold((l) => failure = l, (r) => null);
      } else {
        newInResult.fold((l) => failure = l, (r) => null);
      }

      emit(HomeError(message: failure.message, categories: categories));
      return;
    }

    // Extraemos los datos de productos
    late final List<ProductItemModel> topSellingProducts;
    late final List<ProductItemModel> newInProducts;

    topSellingResult.fold(
      (l) => topSellingProducts = [],
      (r) => topSellingProducts = r,
    );

    newInResult.fold((l) => newInProducts = [], (r) => newInProducts = r);

    // Emitimos el estado de éxito con los datos cargados
    emit(
      HomeLoaded(
        categories: categories,
        apiCategories: apiTreeResult.fold((l) => [], (r) => r),
        topSellingProducts: topSellingProducts,
        newInProducts: newInProducts,
        selectedRootCategory: apiTreeResult.fold(
          (l) => null,
          (r) => r.isNotEmpty ? r[0] : null,
        ),
      ),
    );
  }

  // Manejador para cargar las categorías de la API
  Future<void> _onLoadApiCategoriesTree(
    LoadApiCategoriesTreeEvent event,
    Emitter<HomeState> emit,
  ) async {
    if (state is HomeLoaded) {
      final currentState = state as HomeLoaded;

      emit(
        HomeLoadingPartial(
          categories: currentState.categories,
          apiCategories: [],
          topSellingProducts: currentState.topSellingProducts,
          newInProducts: currentState.newInProducts,
          isLoadingCategories: true,
          isLoadingTopSelling: false,
          isLoadingNewIn: false,
          selectedRootCategory: currentState.selectedRootCategory,
        ),
      );
      print('Emitido estado HomeLoadingPartial');
    } else {
      print('Estado actual no es HomeLoaded, sino: ${state.runtimeType}');
    }

    print('Llamando a GetApiCategoriesTreeUseCase.execute()');
    final result = await _getApiCategoriesTreeUseCase.execute();
    print('GetApiCategoriesTreeUseCase.execute() completado');

    result.fold(
      (failure) {
        print('Error en carga de categorías API: ${failure.message}');
        if (state is HomeLoadingPartial) {
          final currentState = state as HomeLoadingPartial;
          emit(
            HomeError(
              message: failure.message,
              categories: currentState.categories,
              apiCategories: [],
              topSellingProducts: currentState.topSellingProducts,
              newInProducts: currentState.newInProducts,
            ),
          );
        } else {
          emit(HomeError(message: failure.message));
        }
      },
      (apiCategories) {
        print('Categorías API cargadas exitosamente: ${apiCategories.length}');
        if (state is HomeLoadingPartial) {
          final currentState = state as HomeLoadingPartial;
          emit(
            HomeLoaded(
              categories: currentState.categories,
              apiCategories: apiCategories,
              topSellingProducts: currentState.topSellingProducts,
              newInProducts: currentState.newInProducts,
              selectedRootCategory:
                  apiCategories.isNotEmpty ? apiCategories[0] : null,
            ),
          );
          print('Emitido estado HomeLoaded desde HomeLoadingPartial');
        } else {
          emit(
            HomeLoaded(
              categories: [],
              apiCategories: apiCategories,
              topSellingProducts: [],
              newInProducts: [],
              selectedRootCategory:
                  apiCategories.isNotEmpty ? apiCategories[0] : null,
            ),
          );
          print('Emitido estado HomeLoaded desde otro estado');
        }
      },
    );
    print('HomeBloc._onLoadApiCategoriesTree completado');
  }

  // Manejador para cargar solo las categorías
  Future<void> _onLoadCategories(
    LoadCategoriesEvent event,
    Emitter<HomeState> emit,
  ) async {
    // Conservamos el estado actual para los demás datos si estamos en HomeLoaded
    if (state is HomeLoaded) {
      final currentState = state as HomeLoaded;
      emit(
        HomeLoadingPartial(
          categories: [],
          apiCategories: currentState.apiCategories,
          topSellingProducts: currentState.topSellingProducts,
          newInProducts: currentState.newInProducts,
          isLoadingCategories: true,
          isLoadingTopSelling: false,
          isLoadingNewIn: false,
          selectedRootCategory: currentState.selectedRootCategory,
        ),
      );
    } else {
      emit(
        HomeLoadingPartial(
          categories: [],
          apiCategories: [],
          topSellingProducts: [],
          newInProducts: [],
          isLoadingCategories: true,
          isLoadingTopSelling: false,
          isLoadingNewIn: false,
        ),
      );
    }

    // Realizamos la llamada al caso de uso
  }

  // Manejador para cargar solo los productos más vendidos
  Future<void> _onLoadTopSellingProducts(
    LoadTopSellingProductsEvent event,
    Emitter<HomeState> emit,
  ) async {
    // Similar a _onLoadCategories pero para productos más vendidos
    if (state is HomeLoaded) {
      final currentState = state as HomeLoaded;
      emit(
        HomeLoadingPartial(
          categories: currentState.categories,
          apiCategories: currentState.apiCategories,
          topSellingProducts: [],
          newInProducts: currentState.newInProducts,
          isLoadingCategories: false,
          isLoadingTopSelling: true,
          isLoadingNewIn: false,
          selectedRootCategory: currentState.selectedRootCategory,
        ),
      );
    } else {
      emit(
        HomeLoadingPartial(
          categories: [],
          apiCategories: [],
          topSellingProducts: [],
          newInProducts: [],
          isLoadingCategories: false,
          isLoadingTopSelling: true,
          isLoadingNewIn: false,
        ),
      );
    }

    final result = await _getTopSellingProductsUseCase.execute();

    result.fold(
      (failure) {
        if (state is HomeLoadingPartial) {
          final currentState = state as HomeLoadingPartial;
          emit(
            HomeError(
              message: failure.message,
              categories: currentState.categories,
              apiCategories: currentState.apiCategories,
              topSellingProducts: currentState.topSellingProducts,
              newInProducts: currentState.newInProducts,
            ),
          );
        } else {
          emit(HomeError(message: failure.message));
        }
      },
      (products) {
        if (state is HomeLoadingPartial) {
          final currentState = state as HomeLoadingPartial;
          emit(
            HomeLoaded(
              categories: currentState.categories,
              apiCategories: currentState.apiCategories,
              topSellingProducts: products,
              newInProducts: currentState.newInProducts,
              selectedRootCategory: currentState.selectedRootCategory,
            ),
          );
        } else {
          emit(
            HomeLoaded(
              categories: [],
              apiCategories: [],
              topSellingProducts: products,
              newInProducts: [],
              selectedRootCategory: null,
            ),
          );
        }
      },
    );
  }

  // Manejador para cargar solo los productos nuevos
  Future<void> _onLoadNewInProducts(
    LoadNewInProductsEvent event,
    Emitter<HomeState> emit,
  ) async {
    // Similar a _onLoadTopSellingProducts pero para productos nuevos
    if (state is HomeLoaded) {
      final currentState = state as HomeLoaded;
      emit(
        HomeLoadingPartial(
          categories: currentState.categories,
          apiCategories: currentState.apiCategories,
          topSellingProducts: currentState.topSellingProducts,
          newInProducts: [],
          isLoadingCategories: false,
          isLoadingTopSelling: false,
          isLoadingNewIn: true,
          selectedRootCategory: currentState.selectedRootCategory,
        ),
      );
    } else {
      emit(
        HomeLoadingPartial(
          categories: [],
          apiCategories: [],
          topSellingProducts: [],
          newInProducts: [],
          isLoadingCategories: false,
          isLoadingTopSelling: false,
          isLoadingNewIn: true,
        ),
      );
    }

    final result = await _getNewInProductsUseCase.execute();

    result.fold(
      (failure) {
        if (state is HomeLoadingPartial) {
          final currentState = state as HomeLoadingPartial;
          emit(
            HomeError(
              message: failure.message,
              categories: currentState.categories,
              apiCategories: currentState.apiCategories,
              topSellingProducts: currentState.topSellingProducts,
              newInProducts: currentState.newInProducts,
            ),
          );
        } else {
          emit(HomeError(message: failure.message));
        }
      },
      (products) {
        if (state is HomeLoadingPartial) {
          final currentState = state as HomeLoadingPartial;
          emit(
            HomeLoaded(
              categories: currentState.categories,
              apiCategories: currentState.apiCategories,
              topSellingProducts: currentState.topSellingProducts,
              newInProducts: products,
              selectedRootCategory: currentState.selectedRootCategory,
            ),
          );
        } else {
          emit(
            HomeLoaded(
              categories: [],
              apiCategories: [],
              topSellingProducts: [],
              newInProducts: products,
              selectedRootCategory: null,
            ),
          );
        }
      },
    );
  }

  // Manejador para cargar productos por categoría
  Future<void> _onLoadProductsByCategory(
    LoadProductsByCategoryEvent event,
    Emitter<HomeState> emit,
  ) async {
    // Emitimos un estado de carga parcial para la categoría específica
    emit(CategoryProductsLoading(categoryId: event.categoryId));

    // Llamamos al caso de uso
    final result = await _getProductsByCategoryUseCase.execute(
      event.categoryId,
    );

    result.fold(
      (failure) {
        emit(
          CategoryProductsError(
            categoryId: event.categoryId,
            message: failure.message,
          ),
        );
      },
      (products) {
        emit(
          CategoryProductsLoaded(
            categoryId: event.categoryId,
            products: products,
          ),
        );
      },
    );
  }

  // Manejador para cargar una categoría específica por ID
  Future<void> _onLoadCategoryById(
    LoadCategoryByIdEvent event,
    Emitter<HomeState> emit,
  ) async {
    // Emitimos un estado de carga específico para la categoría
    emit(CategoryByIdLoading(categoryId: event.categoryId));

    // Llamamos al caso de uso
    final result = await _getCategoryByIdUseCase.execute(
      event.categoryId,
    );

    result.fold(
      (failure) {
        emit(
          CategoryByIdError(
            categoryId: event.categoryId,
            message: failure.message,
          ),
        );
      },
      (category) {
        emit(
          CategoryByIdLoaded(
            categoryId: event.categoryId,
            category: category,
          ),
        );
      },
    );
  }

  // Manejador para alternar favoritos
  void _onToggleFavorite(ToggleFavoriteEvent event, Emitter<HomeState> emit) {
    if (state is HomeLoaded) {
      final currentState = state as HomeLoaded;

      // Actualizar listas con el producto favorito actualizado
      final updatedTopSellingProducts = _updateFavoriteInList(
        currentState.topSellingProducts,
        event.productId,
        event.isFavorite,
      );

      final updatedNewInProducts = _updateFavoriteInList(
        currentState.newInProducts,
        event.productId,
        event.isFavorite,
      );

      emit(
        HomeLoaded(
          categories: currentState.categories,
          apiCategories: currentState.apiCategories,
          topSellingProducts: updatedTopSellingProducts,
          newInProducts: updatedNewInProducts,
          selectedRootCategory: currentState.selectedRootCategory,
        ),
      );
    }
  }

  // Método auxiliar para actualizar un producto como favorito en una lista
  List<ProductItemModel> _updateFavoriteInList(
    List<ProductItemModel> products,
    String productId,
    bool isFavorite,
  ) {
    return products.map((product) {
      if (product.id == productId) {
        // Crear un nuevo producto con el estado de favorito actualizado
        return ProductItemModel(
          id: product.id,
          name: product.name,
          imageUrl: product.imageUrl,
          additionalImageUrls: product.additionalImageUrls,
          price: product.price,
          originalPrice: product.originalPrice,
          isFavorite: isFavorite,
          averageRating: product.averageRating,
          reviewCount: product.reviewCount,
          description: product.description,
          availableSizes: product.availableSizes,
          availableColors: product.availableColors,
        );
      }
      return product;
    }).toList();
  }
}
