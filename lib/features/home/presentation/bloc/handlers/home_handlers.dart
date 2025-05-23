import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_application_ecommerce/core/network/logger.dart';
import 'package:flutter_application_ecommerce/features/home/domain/domain.dart';
import 'package:flutter_application_ecommerce/features/home/core/core.dart';

import '../events/home_event.dart';
import '../states/home_state.dart';
import '../states/loading_states.dart';

/// Manejadores para eventos relacionados con la página principal Home
mixin HomeEventHandlers {
  /// Caso de uso para obtener el árbol de categorías
  GetApiCategoriesTreeUseCase get getApiCategoriesTreeUseCase;

  /// Caso de uso para obtener los productos más vendidos
  GetProductsByCategoryUseCase get getProductsBestSellersUseCase;

  /// Caso de uso para obtener los productos más nuevos
  GetProductsByCategoryUseCase get getProductsNewestUseCase;

  /// Servicio de almacenamiento de categorías
  CategoryStorage get categoryStorage;

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

    // Intentar recuperar la categoría guardada en preferencias
    final savedCategoryId = await categoryStorage.getSelectedCategoryId();

    // Usamos categorías de API si están disponibles, de lo contrario usamos las locales
    final List<CategoryItemModel> categories = [];

    List<ProductItemModel> productsBestSellers = [];
    List<ProductItemModel> productsNewest = [];

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

    // Buscar la categoría guardada si tenemos el ID
    CategoryApiModel? selectedRootCategory;

    if (savedCategoryId != null) {
      // Buscar la categoría guardada en las categorías cargadas
      apiTreeResult.fold((l) => null, (apiCategories) {
        if (apiCategories.isNotEmpty) {
          try {
            selectedRootCategory = apiCategories.firstWhere(
              (category) => category.id == savedCategoryId,
            );

            AppLogger.logInfo(
              'HomeBloc: Recuperada categoría guardada: ${selectedRootCategory!.name}',
            );
          } catch (e) {
            // Si no se encuentra la categoría, usar la primera
            selectedRootCategory = apiCategories.first;

            AppLogger.logWarning(
              'HomeBloc: No se encontró la categoría guardada, usando la primera',
            );
          }
        }
      });
    }

    // Si no se encontró una categoría guardada, usar la primera
    if (selectedRootCategory == null) {
      apiTreeResult.fold((l) => null, (r) {
        selectedRootCategory = r.isNotEmpty ? r.first : null;
      });
    }

    final result = await getProductsBestSellersUseCase.executeBestSellers(
      selectedRootCategory!.id,
    );

    result.fold(
      (failure) {
        AppLogger.logError(
          'HomeBloc: Error al cargar productos más vendidos: ${failure.message}',
        );
      },
      (products) {
        productsBestSellers = products;
        AppLogger.logSuccess(
          'HomeBloc: Productos más vendidos cargados: ${products.length}',
        );
      },
    );

    final resultNewest = await getProductsNewestUseCase.executeNewest(
      selectedRootCategory!.id,
    );

    resultNewest.fold(
      (failure) {
        AppLogger.logError(
          'HomeBloc: Error al cargar productos más nuevos: ${failure.message}',
        );
      },
      (products) {
        productsNewest = products;
        AppLogger.logSuccess(
          'HomeBloc: Productos más nuevos cargados: ${products.length}',
        );
      },
    );

    // Emitimos el estado de éxito con los datos cargados
    emit(
      HomeLoaded(
        categories: categories,
        apiCategories: apiTreeResult.fold((l) => [], (r) => r),
        selectedRootCategory: selectedRootCategory,
        productsBestSellers: productsBestSellers,
        productsNewest: productsNewest,
      ),
    );
  }
}
