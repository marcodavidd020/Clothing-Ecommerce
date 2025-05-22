import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_application_ecommerce/core/network/logger.dart';
import 'package:flutter_application_ecommerce/features/home/domain/entities/category_item_model.dart';
import 'package:flutter_application_ecommerce/features/home/domain/usecases/get_api_categories_tree_usecase.dart';

import '../events/home_event.dart';
import '../states/home_state.dart';
import '../states/loading_states.dart';

/// Manejadores para eventos relacionados con la página principal Home
mixin HomeEventHandlers {
  /// Caso de uso para obtener el árbol de categorías
  GetApiCategoriesTreeUseCase get getApiCategoriesTreeUseCase;

  /// Manejador para cargar todos los datos de la pantalla de inicio
  ///
  /// Carga categorías del API y configura el estado inicial de la aplicación
  Future<void> onLoadHomeData(
    LoadHomeDataEvent event,
    Emitter<HomeState> emit,
  ) async {
    emit(HomeLoading());
    AppLogger.logInfo('HomeBloc: Cargando datos iniciales');

    // Intentamos cargar categorías desde la API primero
    final apiTreeResult = await getApiCategoriesTreeUseCase.execute();

    // Usamos categorías de API si están disponibles, de lo contrario usamos las locales
    final List<CategoryItemModel> categories = [];

    // Si tenemos categorías del API, convertirlas a CategoryItemModel
    apiTreeResult.fold(
      (failure) {
        // Si falla API, usamos categorías locales
        AppLogger.logError(
          'HomeBloc: Error al cargar categorías API: ${failure.message}',
        );
      },
      (apiCategories) {
        // Convertimos categorías de API a formato compatible
        AppLogger.logSuccess(
          'HomeBloc: Categorías API cargadas: ${apiCategories.length}',
        );
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
}
