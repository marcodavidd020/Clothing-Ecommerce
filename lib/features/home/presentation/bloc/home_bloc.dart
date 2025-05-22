import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_application_ecommerce/core/error/failures.dart';
import 'package:flutter_application_ecommerce/features/home/domain/domain.dart';
import 'package:flutter_application_ecommerce/features/home/data/datasources/product_api_datasource.dart';
import 'package:flutter_application_ecommerce/features/home/data/models/product_detail_model.dart';
import 'package:meta/meta.dart';
import 'package:flutter_application_ecommerce/core/network/logger.dart';

part 'home_event.dart';
part 'home_state.dart';

/// BLoC para manejar el estado de la pantalla de inicio
class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final GetProductsByCategoryUseCase _getProductsByCategoryUseCase;
  final GetApiCategoriesTreeUseCase _getApiCategoriesTreeUseCase;
  final GetCategoryByIdUseCase _getCategoryByIdUseCase;
  final GetProductByIdUseCase _getProductByIdUseCase;

  HomeBloc({
    required GetProductsByCategoryUseCase getProductsByCategoryUseCase,
    required GetApiCategoriesTreeUseCase getApiCategoriesTreeUseCase,
    required GetCategoryByIdUseCase getCategoryByIdUseCase,
    required GetProductByIdUseCase getProductByIdUseCase,
  }) : _getProductsByCategoryUseCase = getProductsByCategoryUseCase,
       _getApiCategoriesTreeUseCase = getApiCategoriesTreeUseCase,
       _getCategoryByIdUseCase = getCategoryByIdUseCase,
       _getProductByIdUseCase = getProductByIdUseCase,
       super(HomeInitial()) {
    // Eventos para cargar datos al iniciar
    on<LoadHomeDataEvent>(_onLoadHomeData);

    // Eventos para cargar datos específicos
    on<LoadCategoriesEvent>(_onLoadCategories);
    on<LoadApiCategoriesTreeEvent>(_onLoadApiCategoriesTree);
    on<LoadProductsByCategoryEvent>(_onLoadProductsByCategory);
    on<LoadCategoryByIdEvent>(_onLoadCategoryById);
    on<LoadProductByIdEvent>(_onLoadProductById);

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

    // Emitimos el estado de éxito con los datos cargados
    emit(
      HomeLoaded(
        categories: categories,
        apiCategories: apiTreeResult.fold((l) => [], (r) => r),
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
          isLoadingCategories: true,
          selectedRootCategory: currentState.selectedRootCategory,
        ),
      );
    } else {
      emit(HomeError(message: 'Estado inválido para cargar categorías'));
    }

    final result = await _getApiCategoriesTreeUseCase.execute();

    result.fold(
      (failure) {
        if (state is HomeLoadingPartial) {
          final currentState = state as HomeLoadingPartial;
          emit(
            HomeError(
              message: failure.message,
              categories: currentState.categories,
              apiCategories: [],
            ),
          );
        } else {
          emit(HomeError(message: failure.message));
        }
      },
      (apiCategories) {
        if (state is HomeLoadingPartial) {
          final currentState = state as HomeLoadingPartial;
          emit(
            HomeLoaded(
              categories: currentState.categories,
              apiCategories: apiCategories,
              selectedRootCategory:
                  apiCategories.isNotEmpty ? apiCategories[0] : null,
            ),
          );
        } else {
          emit(
            HomeLoaded(
              categories: [],
              apiCategories: apiCategories,
              selectedRootCategory:
                  apiCategories.isNotEmpty ? apiCategories[0] : null,
            ),
          );
        }
      },
    );
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
          isLoadingCategories: true,
          selectedRootCategory: currentState.selectedRootCategory,
        ),
      );
    } else {
      emit(
        HomeLoadingPartial(
          categories: [],
          apiCategories: [],
          isLoadingCategories: true,
        ),
      );
    }

    // Realizamos la llamada al caso de uso
  }

  // Manejador para cargar productos por categoría
  Future<void> _onLoadProductsByCategory(
    LoadProductsByCategoryEvent event,
    Emitter<HomeState> emit,
  ) async {
    // Reconstruir el estado de HomeLoaded desde cualquier estado previo 
    HomeLoaded currentState;
    
    if (state is HomeLoaded) {
      currentState = state as HomeLoaded;
    } else if (state is ProductsByCategoryLoaded) {
      currentState = (state as ProductsByCategoryLoaded).previousState;
      AppLogger.logInfo('HomeBloc: Recuperando estado previo de ProductsByCategoryLoaded');
    } else if (state is ProductDetailLoaded) {
      currentState = (state as ProductDetailLoaded).previousState;
      AppLogger.logInfo('HomeBloc: Recuperando estado previo de ProductDetailLoaded');
    } else if (state is LoadingProductsByCategory) {
      // Si ya estamos cargando productos, recuperar el estado previo
      currentState = (state as LoadingProductsByCategory).previousState;
      AppLogger.logInfo('HomeBloc: Ya estamos cargando productos. Usando estado anterior.');
      return; // Salimos para evitar sobrecargar con múltiples peticiones
    } else if (state is HomeError) {
      // Si el estado actual es HomeError, intentamos reconstruir un HomeLoaded básico
      AppLogger.logInfo('HomeBloc: Recuperando desde estado de error');
      
      // Construir un estado HomeLoaded con los datos que tengamos disponibles del error
      final errorState = state as HomeError;
      currentState = HomeLoaded(
        categories: errorState.categories ?? [],
        apiCategories: errorState.apiCategories ?? [],
        selectedRootCategory: errorState.selectedRootCategory,
      );
    } else {
      AppLogger.logError('HomeBloc: Estado inválido para cargar productos: ${state.runtimeType}');
      emit(HomeError(message: 'Estado inválido para cargar productos'));
      return; // Salir para evitar continuar con un estado inválido
    }
    
    AppLogger.logInfo('HomeBloc: Emitiendo LoadingProductsByCategory para categoría ${event.categoryId}');
    
    emit(
      LoadingProductsByCategory(
        categoryId: event.categoryId,
        previousState: currentState,
      ),
    );

    final result = await _getProductsByCategoryUseCase.execute(
      event.categoryId,
    );

    result.fold(
      (failure) {
        AppLogger.logError('HomeBloc: Error al cargar productos: ${failure.message}');
        
        emit(
          HomeError(
            message: 'Error al cargar productos: ${failure.message}',
            categories: currentState.categories,
            apiCategories: currentState.apiCategories,
            selectedRootCategory: currentState.selectedRootCategory,
          ),
        );
      },
      (products) {
        AppLogger.logSuccess('HomeBloc: Productos cargados exitosamente: ${products.length} productos');
        
        emit(
          ProductsByCategoryLoaded(
            categoryId: event.categoryId,
            products: products,
            previousState: currentState,
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
    final result = await _getCategoryByIdUseCase.execute(event.categoryId);

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
        if (state is HomeLoaded) {
          final currentState = state as HomeLoaded;
          emit(
            currentState.copyWith(
              selectedCategory: category,
              productsByCategory: category.products,
            ),
          );
        } else {
          emit(
            HomeLoaded(
              categories: [],
              apiCategories: [],
              selectedCategory: category,
              productsByCategory: category.products,
            ),
          );
        }
      },
    );
  }

  // Manejador para cargar detalles de un producto
  Future<void> _onLoadProductById(
    LoadProductByIdEvent event,
    Emitter<HomeState> emit,
  ) async {
    if (state is HomeLoaded) {
      final currentState = state as HomeLoaded;
      emit(
        LoadingProductDetail(
          productId: event.productId,
          previousState: currentState,
        ),
      );

      final result = await _getProductByIdUseCase.execute(event.productId);

      result.fold(
        (failure) {
          emit(
            HomeError(
              message: 'Error al cargar el producto: ${failure.message}',
              categories: currentState.categories,
              apiCategories: currentState.apiCategories,
              selectedRootCategory: currentState.selectedRootCategory,
            ),
          );
        },
        (product) {
          emit(
            ProductDetailLoaded(product: product, previousState: currentState),
          );
        },
      );
    } else {
      emit(
        HomeError(message: 'Estado inválido para cargar detalles de producto'),
      );
    }
  }

  // Manejador para alternar favoritos
  void _onToggleFavorite(ToggleFavoriteEvent event, Emitter<HomeState> emit) {
    if (state is HomeLoaded) {
      final currentState = state as HomeLoaded;

      // Actualizar listas con el producto favorito actualizado
      final updatedProducts = _updateFavoriteInList(
        currentState.productsByCategory,
        event.productId,
        event.isFavorite,
      );

      emit(
        HomeLoaded(
          categories: currentState.categories,
          apiCategories: currentState.apiCategories,
          selectedRootCategory: currentState.selectedRootCategory,
          productsByCategory: updatedProducts,
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
