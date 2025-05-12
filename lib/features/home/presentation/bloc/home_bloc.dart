import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_application_ecommerce/core/error/failures.dart';
import 'package:flutter_application_ecommerce/features/home/domain/domain.dart';
import 'package:meta/meta.dart';

part 'home_event.dart';
part 'home_state.dart';

/// BLoC para manejar el estado de la pantalla de inicio
class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final GetCategoriesUseCase _getCategoriesUseCase;
  final GetTopSellingProductsUseCase _getTopSellingProductsUseCase;
  final GetNewInProductsUseCase _getNewInProductsUseCase;
  final GetProductsByCategoryUseCase _getProductsByCategoryUseCase;

  HomeBloc({
    required GetCategoriesUseCase getCategoriesUseCase,
    required GetTopSellingProductsUseCase getTopSellingProductsUseCase,
    required GetNewInProductsUseCase getNewInProductsUseCase,
    required GetProductsByCategoryUseCase getProductsByCategoryUseCase,
  }) : _getCategoriesUseCase = getCategoriesUseCase,
       _getTopSellingProductsUseCase = getTopSellingProductsUseCase,
       _getNewInProductsUseCase = getNewInProductsUseCase,
       _getProductsByCategoryUseCase = getProductsByCategoryUseCase,
       super(HomeInitial()) {
    // Eventos para cargar datos al iniciar
    on<LoadHomeDataEvent>(_onLoadHomeData);

    // Eventos para cargar datos específicos
    on<LoadCategoriesEvent>(_onLoadCategories);
    on<LoadTopSellingProductsEvent>(_onLoadTopSellingProducts);
    on<LoadNewInProductsEvent>(_onLoadNewInProducts);
    on<LoadProductsByCategoryEvent>(_onLoadProductsByCategory);

    // Eventos de favoritos
    on<ToggleFavoriteEvent>(_onToggleFavorite);
  }

  // Manejador para cargar todos los datos de la pantalla de inicio
  Future<void> _onLoadHomeData(
    LoadHomeDataEvent event,
    Emitter<HomeState> emit,
  ) async {
    emit(HomeLoading());

    // Obtener datos directamente sin usar Future.wait
    final categoriesResult = await _getCategoriesUseCase.execute();
    final topSellingResult = await _getTopSellingProductsUseCase.execute();
    final newInResult = await _getNewInProductsUseCase.execute();

    // Verificamos si hay errores
    if (categoriesResult.isLeft() ||
        topSellingResult.isLeft() ||
        newInResult.isLeft()) {
      // Obtenemos el primer error que encontremos
      late Failure failure;

      categoriesResult.fold((l) => failure = l, (r) => null);

      if (categoriesResult.isRight()) {
        topSellingResult.fold((l) => failure = l, (r) => null);
      }

      if (categoriesResult.isRight() && topSellingResult.isRight()) {
        newInResult.fold((l) => failure = l, (r) => null);
      }

      emit(HomeError(message: failure.message));
      return;
    }

    // Extraemos los datos si no hay errores
    late final List<CategoryItemModel> categories;
    late final List<ProductItemModel> topSellingProducts;
    late final List<ProductItemModel> newInProducts;

    categoriesResult.fold((l) => categories = [], (r) => categories = r);

    topSellingResult.fold(
      (l) => topSellingProducts = [],
      (r) => topSellingProducts = r,
    );

    newInResult.fold((l) => newInProducts = [], (r) => newInProducts = r);

    // Emitimos el estado de éxito con los datos cargados
    emit(
      HomeLoaded(
        categories: categories,
        topSellingProducts: topSellingProducts,
        newInProducts: newInProducts,
      ),
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
          topSellingProducts: currentState.topSellingProducts,
          newInProducts: currentState.newInProducts,
          isLoadingCategories: true,
          isLoadingTopSelling: false,
          isLoadingNewIn: false,
        ),
      );
    } else {
      emit(
        HomeLoadingPartial(
          categories: [],
          topSellingProducts: [],
          newInProducts: [],
          isLoadingCategories: true,
          isLoadingTopSelling: false,
          isLoadingNewIn: false,
        ),
      );
    }

    // Realizamos la llamada al caso de uso
    final result = await _getCategoriesUseCase.execute();

    result.fold(
      (failure) {
        // En caso de error, emitimos el estado de error pero mantenemos los datos anteriores
        if (state is HomeLoadingPartial) {
          final currentState = state as HomeLoadingPartial;
          emit(
            HomeError(
              message: failure.message,
              categories: currentState.categories,
              topSellingProducts: currentState.topSellingProducts,
              newInProducts: currentState.newInProducts,
            ),
          );
        } else {
          emit(HomeError(message: failure.message));
        }
      },
      (categories) {
        // En caso de éxito, actualizamos el estado con las nuevas categorías
        if (state is HomeLoadingPartial) {
          final currentState = state as HomeLoadingPartial;
          emit(
            HomeLoaded(
              categories: categories,
              topSellingProducts: currentState.topSellingProducts,
              newInProducts: currentState.newInProducts,
            ),
          );
        } else {
          emit(
            HomeLoaded(
              categories: categories,
              topSellingProducts: [],
              newInProducts: [],
            ),
          );
        }
      },
    );
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
          topSellingProducts: [],
          newInProducts: currentState.newInProducts,
          isLoadingCategories: false,
          isLoadingTopSelling: true,
          isLoadingNewIn: false,
        ),
      );
    } else {
      emit(
        HomeLoadingPartial(
          categories: [],
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
              topSellingProducts: products,
              newInProducts: currentState.newInProducts,
            ),
          );
        } else {
          emit(
            HomeLoaded(
              categories: [],
              topSellingProducts: products,
              newInProducts: [],
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
          topSellingProducts: currentState.topSellingProducts,
          newInProducts: [],
          isLoadingCategories: false,
          isLoadingTopSelling: false,
          isLoadingNewIn: true,
        ),
      );
    } else {
      emit(
        HomeLoadingPartial(
          categories: [],
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
              topSellingProducts: currentState.topSellingProducts,
              newInProducts: products,
            ),
          );
        } else {
          emit(
            HomeLoaded(
              categories: [],
              topSellingProducts: [],
              newInProducts: products,
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
          topSellingProducts: updatedTopSellingProducts,
          newInProducts: updatedNewInProducts,
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
