import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_application_ecommerce/core/network/logger.dart';
import 'package:flutter_application_ecommerce/features/home/domain/usecases/get_products_by_category_usecase.dart';
import 'package:flutter_application_ecommerce/features/home/domain/usecases/get_product_by_id_usecase.dart';

import '../events/product_events.dart';
import '../states/home_state.dart';
import '../states/product_states.dart';

/// Manejadores para eventos relacionados con productos
mixin ProductEventHandlers {
  /// Caso de uso para obtener productos por categoría
  GetProductsByCategoryUseCase get getProductsByCategoryUseCase;

  /// Caso de uso para obtener detalles de un producto
  GetProductByIdUseCase get getProductByIdUseCase;

  /// Manejador para cargar productos por categoría
  Future<void> onLoadProductsByCategory(
    LoadProductsByCategoryEvent event,
    Emitter<HomeState> emit,
  ) async {
    AppLogger.logInfo(
      'HomeBloc: Cargando productos por categoría: ${event.categoryId}',
    );

    // Reconstruir el estado de HomeLoaded desde cualquier estado previo
    HomeLoaded currentState;

    if (state is HomeLoaded) {
      currentState = state as HomeLoaded;
    } else if (state is ProductsByCategoryLoaded) {
      currentState = (state as ProductsByCategoryLoaded).previousState;
      AppLogger.logInfo(
        'HomeBloc: Recuperando estado previo de ProductsByCategoryLoaded',
      );
    } else if (state is ProductDetailLoaded) {
      currentState = (state as ProductDetailLoaded).previousState;
      AppLogger.logInfo(
        'HomeBloc: Recuperando estado previo de ProductDetailLoaded',
      );
    } else if (state is LoadingProductsByCategory) {
      // Si ya estamos cargando productos, recuperar el estado previo
      currentState = (state as LoadingProductsByCategory).previousState;
      AppLogger.logInfo(
        'HomeBloc: Ya estamos cargando productos. Usando estado anterior.',
      );
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
      AppLogger.logError(
        'HomeBloc: Estado inválido para cargar productos: ${state.runtimeType}',
      );
      emit(HomeError(message: 'Estado inválido para cargar productos'));
      return; // Salir para evitar continuar con un estado inválido
    }

    emit(
      LoadingProductsByCategory(
        categoryId: event.categoryId,
        previousState: currentState,
      ),
    );

    final result = await getProductsByCategoryUseCase.execute(event.categoryId);

    result.fold(
      (failure) {
        AppLogger.logError(
          'HomeBloc: Error al cargar productos: ${failure.message}',
        );

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
        AppLogger.logSuccess(
          'HomeBloc: Productos cargados exitosamente: ${products.length} productos',
        );

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

  /// Manejador para cargar detalles de un producto
  Future<void> onLoadProductById(
    LoadProductByIdEvent event,
    Emitter<HomeState> emit,
  ) async {
    AppLogger.logInfo(
      'HomeBloc: Cargando detalle de producto: ${event.productId}',
    );

    if (state is HomeLoaded) {
      final currentState = state as HomeLoaded;
      emit(
        LoadingProductDetail(
          productId: event.productId,
          previousState: currentState,
        ),
      );

      final result = await getProductByIdUseCase.execute(event.productId);

      result.fold(
        (failure) {
          AppLogger.logError(
            'HomeBloc: Error al cargar detalle de producto: ${failure.message}',
          );

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
          AppLogger.logSuccess(
            'HomeBloc: Detalle de producto cargado: ${product.name}',
          );

          emit(
            ProductDetailLoaded(product: product, previousState: currentState),
          );
        },
      );
    } else {
      AppLogger.logError(
        'HomeBloc: Estado inválido para cargar detalle de producto: ${state.runtimeType}',
      );

      emit(
        HomeError(message: 'Estado inválido para cargar detalles de producto'),
      );
    }
  }

  /// Estado actual del BLoC
  HomeState get state;
}
