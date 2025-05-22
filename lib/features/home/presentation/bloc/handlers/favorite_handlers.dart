import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_application_ecommerce/core/network/logger.dart';
import 'package:flutter_application_ecommerce/features/home/domain/entities/product_item_model.dart';

import '../events/favorite_events.dart';
import '../states/home_state.dart';

/// Manejadores para eventos relacionados con favoritos
mixin FavoriteEventHandlers {
  /// Manejador para alternar favoritos
  void onToggleFavorite(ToggleFavoriteEvent event, Emitter<HomeState> emit) {
    AppLogger.logInfo(
      'HomeBloc: Cambiando estado favorito de producto ${event.productId} a ${event.isFavorite}',
    );

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
    } else {
      AppLogger.logWarning(
        'HomeBloc: No se puede cambiar favorito en estado ${state.runtimeType}',
      );
    }
  }

  /// Método auxiliar para actualizar un producto como favorito en una lista
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

  /// Estado actual del BLoC
  HomeState get state;
}
