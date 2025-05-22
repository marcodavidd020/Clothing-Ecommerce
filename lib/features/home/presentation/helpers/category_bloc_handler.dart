import 'package:flutter/material.dart';
import 'package:flutter_application_ecommerce/features/home/domain/entities/product_item_model.dart';
import 'package:flutter_application_ecommerce/features/home/presentation/bloc/bloc.dart';

/// Helper para manejar estados del BLoC en páginas de categoría
class CategoryBlocHandler {
  /// Maneja los cambios de estado del BLoC para la pantalla de detalle de categoría
  ///
  /// Retorna true si el estado fue manejado, false en caso contrario
  static bool handleCategoryDetailState({
    required BuildContext context,
    required HomeState state,
    required String categoryId,
    required void Function(List<ProductItemModel>) onProductsLoaded,
    required void Function(bool) onLoadingChanged,
    required void Function(String) onError,
  }) {
    // Manejar la respuesta de carga de productos
    if ((state is CategoryProductsLoaded && state.categoryId == categoryId) ||
        (state is ProductsByCategoryLoaded && state.categoryId == categoryId)) {
      final products =
          state is CategoryProductsLoaded
              ? state.products
              : (state as ProductsByCategoryLoaded).products;

      onProductsLoaded(products);
      onLoadingChanged(false);
      return true;
    }
    // Manejar estado de carga
    else if (state is LoadingProductsByCategory &&
        state.categoryId == categoryId) {
      onLoadingChanged(true);
      return true;
    }
    // Manejar estado de error específico de categoría
    else if (state is CategoryProductsError && state.categoryId == categoryId) {
      onLoadingChanged(false);
      onError(state.message);
      return true;
    }
    // Manejar error general
    else if (state is HomeError) {
      onLoadingChanged(false);
      onError(state.message);
      return true;
    }

    return false;
  }

  /// Muestra un SnackBar de error
  static void showErrorSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Error: $message'),
        backgroundColor: Colors.red.shade700,
      ),
    );
  }
}
