import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_application_ecommerce/core/widgets/feedback_util.dart';
import 'package:flutter_application_ecommerce/features/home/domain/entities/category_api_model.dart';
import 'package:flutter_application_ecommerce/features/home/presentation/bloc/home_bloc.dart';

/// Clase auxiliar para manejar interacciones comunes con HomeBloc
class HomeBlocHandler {
  /// Constructor privado para prevenir instanciación
  HomeBlocHandler._();

  /// Escucha cambios en el HomeBloc y ejecuta acciones correspondientes
  ///
  /// Muestra mensajes de error cuando hay fallos y maneja estados de carga
  static void handleHomeState(BuildContext context, HomeState state) {
    if (state is HomeError) {
      FeedbackUtil.showErrorMessage(context, state.message);
    } else if (state is CategoryProductsError) {
      FeedbackUtil.showErrorMessage(
        context,
        'Error al cargar productos: ${state.message}',
      );
    } else if (state is CategoryProductsLoaded) {
      FeedbackUtil.showSuccessMessage(context, 'Productos cargados');
    } else if (state is CategoryByIdError) {
      FeedbackUtil.showErrorMessage(
        context,
        'Error al cargar categoría: ${state.message}',
      );
    } else if (state is CategoryByIdLoaded) {
      FeedbackUtil.showSuccessMessage(
        context,
        'Categoría cargada: ${state.category.name}',
      );
    }
  }

  /// Verifica si el HomeBloc está en estado de carga
  static bool isLoading(HomeState state) =>
      state is HomeLoading ||
      state is HomeLoadingPartial ||
      state is CategoryProductsLoading ||
      state is CategoryByIdLoading;

  /// Despacha evento para cargar datos iniciales
  static void loadHomeData(BuildContext context) {
    final homeBloc = context.read<HomeBloc>();
    homeBloc.add(LoadHomeDataEvent());
  }

  /// Despacha evento para actualizar categorías desde API
  static void loadApiCategories(BuildContext context) {
    final homeBloc = context.read<HomeBloc>();
    homeBloc.add(LoadApiCategoriesTreeEvent());
  }

  /// Despacha evento para cargar productos por categoría
  static void loadProductsByCategory(BuildContext context, String categoryId) {
    final homeBloc = context.read<HomeBloc>();
    homeBloc.add(LoadProductsByCategoryEvent(categoryId: categoryId));

    // Mostrar mensaje de carga
    FeedbackUtil.showUpdatingMessage(
      context,
      customMessage: 'Cargando productos...',
    );
  }

  /// Despacha evento para cargar una categoría específica por ID
  static void loadCategoryById(BuildContext context, String categoryId) {
    final homeBloc = context.read<HomeBloc>();
    homeBloc.add(LoadCategoryByIdEvent(categoryId: categoryId));

    // Mostrar mensaje de carga
    FeedbackUtil.showUpdatingMessage(
      context,
      customMessage: 'Cargando categoría...',
    );
  }

  /// Despacha evento para alternar estado de favorito
  static void toggleFavorite(
    BuildContext context,
    String productId,
    bool isFavorite,
  ) {
    final homeBloc = context.read<HomeBloc>();
    homeBloc.add(
      ToggleFavoriteEvent(productId: productId, isFavorite: isFavorite),
    );

    // Mostrar feedback adecuado
    final message =
        isFavorite ? 'Añadido a favoritos' : 'Eliminado de favoritos';

    final color = isFavorite ? Colors.pink[400]! : Colors.grey[700]!;

    FeedbackUtil.showSnackBar(
      context: context,
      message: message,
      backgroundColor: color,
    );
  }

  /// Despacha evento para seleccionar categoría raíz
  static void selectRootCategory(
    BuildContext context,
    CategoryApiModel category,
  ) {
    final homeBloc = context.read<HomeBloc>();
    homeBloc.add(SelectRootCategoryEvent(category: category));

    // Mostrar feedback
    FeedbackUtil.showUpdatingMessage(
      context,
      customMessage: 'Mostrando ${category.name}',
    );
  }

  /// Despacha evento para cargar productos más vendidos
  static void loadTopSellingProducts(BuildContext context) {
    final homeBloc = context.read<HomeBloc>();
    homeBloc.add(LoadTopSellingProductsEvent());
  }

  /// Despacha evento para cargar productos nuevos
  static void loadNewInProducts(BuildContext context) {
    final homeBloc = context.read<HomeBloc>();
    homeBloc.add(LoadNewInProductsEvent());
  }
}
