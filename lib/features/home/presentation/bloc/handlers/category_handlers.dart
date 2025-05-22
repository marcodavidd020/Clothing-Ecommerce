import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_application_ecommerce/core/network/logger.dart';
import 'package:flutter_application_ecommerce/features/home/domain/usecases/get_api_categories_tree_usecase.dart';
import 'package:flutter_application_ecommerce/features/home/domain/usecases/get_category_by_id_usecase.dart';
import 'package:flutter_application_ecommerce/features/home/core/core.dart';
import 'package:flutter_application_ecommerce/features/home/domain/entities/category_api_model.dart';

import '../events/category_events.dart';
import '../states/home_state.dart';
import '../states/loading_states.dart';
import '../states/category_states.dart';

/// Manejadores para eventos relacionados con categorías
mixin CategoryEventHandlers {
  /// Caso de uso para obtener el árbol de categorías
  GetApiCategoriesTreeUseCase get getApiCategoriesTreeUseCase;

  /// Caso de uso para obtener una categoría por su ID
  GetCategoryByIdUseCase get getCategoryByIdUseCase;

  /// Servicio de almacenamiento de categorías
  CategoryStorage get categoryStorage;

  /// Manejador para seleccionar una categoría raíz
  Future<void> onSelectRootCategory(
    SelectRootCategoryEvent event,
    Emitter<HomeState> emit,
  ) async {
    if (state is HomeLoaded) {
      final currentState = state as HomeLoaded;
      AppLogger.logInfo(
        'HomeBloc: Seleccionando categoría raíz: ${event.category.name}',
      );

      // Guardar la categoría seleccionada en SharedPreferences
      await categoryStorage.saveSelectedCategory(event.category);

      emit(
        HomeLoaded(
          categories: currentState.categories,
          apiCategories: currentState.apiCategories,
          selectedRootCategory: event.category,
        ),
      );
    } else {
      AppLogger.logWarning(
        'HomeBloc: No se puede seleccionar categoría raíz en estado ${state.runtimeType}',
      );
    }
  }

  /// Manejador para cargar el árbol de categorías del API
  Future<void> onLoadApiCategoriesTree(
    LoadApiCategoriesTreeEvent event,
    Emitter<HomeState> emit,
  ) async {
    if (state is HomeLoaded) {
      final currentState = state as HomeLoaded;
      AppLogger.logInfo('HomeBloc: Cargando árbol de categorías API');

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
      return;
    }

    final result = await getApiCategoriesTreeUseCase.execute();

    result.fold(
      (failure) {
        AppLogger.logError(
          'HomeBloc: Error al cargar categorías API: ${failure.message}',
        );

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
      (apiCategories) async {
        AppLogger.logSuccess(
          'HomeBloc: Categorías API cargadas: ${apiCategories.length}',
        );

        // Intentar recuperar la categoría previamente seleccionada
        CategoryApiModel? selectedRootCategory;

        // Primero tratamos de obtener la categoría guardada
        final savedCategory = await categoryStorage.getSelectedCategory();

        if (savedCategory != null && apiCategories.isNotEmpty) {
          // Buscar la categoría completa en la lista que acabamos de cargar
          final savedCategoryId = savedCategory.id;
          try {
            selectedRootCategory = apiCategories.firstWhere(
              (category) => category.id == savedCategoryId,
            );

            AppLogger.logInfo(
              'HomeBloc: Recuperada categoría guardada: ${selectedRootCategory.name}',
            );
          } catch (e) {
            // Si no se encuentra la categoría, usar la primera
            selectedRootCategory = apiCategories.first;

            AppLogger.logWarning(
              'HomeBloc: No se encontró la categoría guardada, usando la primera',
            );
          }
        } else {
          // Si no hay categoría guardada, usar la primera como predeterminada
          selectedRootCategory =
              apiCategories.isNotEmpty ? apiCategories.first : null;
        }

        if (state is HomeLoadingPartial) {
          final currentState = state as HomeLoadingPartial;
          emit(
            HomeLoaded(
              categories: currentState.categories,
              apiCategories: apiCategories,
              selectedRootCategory: selectedRootCategory,
            ),
          );
        } else {
          emit(
            HomeLoaded(
              categories: [],
              apiCategories: apiCategories,
              selectedRootCategory: selectedRootCategory,
            ),
          );
        }
      },
    );
  }

  /// Manejador para cargar solo las categorías
  Future<void> onLoadCategories(
    LoadCategoriesEvent event,
    Emitter<HomeState> emit,
  ) async {
    AppLogger.logInfo('HomeBloc: Cargando categorías');

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

    // Aquí iría la implementación para cargar categorías locales si fuera necesario
  }

  /// Manejador para cargar una categoría específica por ID
  Future<void> onLoadCategoryById(
    LoadCategoryByIdEvent event,
    Emitter<HomeState> emit,
  ) async {
    AppLogger.logInfo(
      'HomeBloc: Cargando categoría por ID: ${event.categoryId}',
    );

    // Emitimos un estado de carga específico para la categoría
    emit(CategoryByIdLoading(categoryId: event.categoryId));

    // Llamamos al caso de uso
    final result = await getCategoryByIdUseCase.execute(event.categoryId);

    result.fold(
      (failure) {
        AppLogger.logError(
          'HomeBloc: Error al cargar categoría: ${failure.message}',
        );

        emit(
          CategoryByIdError(
            categoryId: event.categoryId,
            message: failure.message,
          ),
        );
      },
      (category) {
        AppLogger.logSuccess('HomeBloc: Categoría cargada: ${category.name}');

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

  /// Estado actual del BLoC
  HomeState get state;
}
