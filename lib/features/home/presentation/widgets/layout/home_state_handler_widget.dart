import 'package:flutter/material.dart';
import 'package:flutter_application_ecommerce/core/network/logger.dart';
import 'package:flutter_application_ecommerce/features/home/presentation/bloc/home_bloc.dart';
import 'package:flutter_application_ecommerce/features/home/presentation/bloc/states/category_states.dart';
import 'package:flutter_application_ecommerce/features/home/presentation/bloc/states/home_state.dart';
import 'package:flutter_application_ecommerce/features/home/presentation/bloc/states/loading_states.dart';
import 'package:flutter_application_ecommerce/features/home/presentation/bloc/states/product_states.dart';
import 'package:flutter_application_ecommerce/features/home/presentation/helpers/helpers.dart';
import 'package:flutter_application_ecommerce/features/home/presentation/widgets/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Widget que maneja los diferentes estados de la página Home
/// para determinar qué contenido mostrar.
///
/// Esto permite simplificar la lógica del widget principal de HomePage,
/// separando la responsabilidad de determinar qué mostrar según el estado.
class HomeStateHandlerWidget extends StatelessWidget {
  /// Controller para el scroll
  final ScrollController scrollController;

  /// Estado actual del BLoC
  final HomeState state;

  /// Constructor
  const HomeStateHandlerWidget({
    super.key,
    required this.scrollController,
    required this.state,
  });

  @override
  Widget build(BuildContext context) {
    // Manejar cada estado específico según su tipo
    if (state is HomeInitial ||
        state is HomeLoading ||
        state is HomeLoadingPartial) {
      return const HomeSkeleton();
    }

    if (state is HomeError) {
      return _buildErrorState(context, state as HomeError);
    }

    if (state is HomeLoaded) {
      return _buildLoadedState(context, state as HomeLoaded);
    }

    // Manejar explícitamente el estado ProductsByCategoryLoaded
    if (state is ProductsByCategoryLoaded) {
      return _buildProductsByCategoryLoadedState(
        context,
        state as ProductsByCategoryLoaded,
      );
    }

    // Manejar específicamente los estados relacionados con categorías
    if (_isCategoryRelatedState(state)) {
      return _buildCategoryRelatedState(context);
    }

    // Caso por defecto cuando no hay un estado específico manejado
    AppLogger.logWarning('Estado no manejado: ${state.runtimeType}');
    return const HomeSkeleton();
  }

  /// Verifica si el estado está relacionado con categorías
  bool _isCategoryRelatedState(HomeState state) {
    return state is CategoryProductsLoaded ||
        state is CategoryProductsError ||
        state is CategoryByIdLoaded ||
        state is CategoryByIdError ||
        state is LoadingProductsByCategory ||
        state is LoadingProductDetail ||
        state is ProductDetailLoaded;
  }

  /// Construye la UI para el estado de error
  Widget _buildErrorState(BuildContext context, HomeError state) {
    return ErrorContentWidget(
      message: state.message,
      onRetry: () {
        // Restablecer carga de datos
        HomePageHelper.requestInitialData(context, false);
      },
    );
  }

  /// Construye la UI para el estado cargado
  Widget _buildLoadedState(BuildContext context, HomeLoaded state) {
    return HomeContentWidget(
      state: state,
      scrollController: scrollController,
      onSearchTapped: () => HomeNavigationHelper.goToSearch(context),
      onSeeAllCategoriesPressed: () {
        HomePageHelper.handleSeeAllCategories(
          context,
          state.selectedRootCategory,
          state.apiCategories,
        );
      },
      onCategoryTapped: (_) {},
      onProductTapped:
          (product) => HomeNavigationHelper.goToProductDetail(context, product),
      onToggleFavorite:
          (product) => HomeBlocHandler.toggleFavorite(
            context,
            product.id,
            !product.isFavorite,
          ),
    );
  }

  /// Construye la UI para estados de carga de productos por categoría
  Widget _buildProductsByCategoryLoadedState(
    BuildContext context,
    ProductsByCategoryLoaded state,
  ) {
    // Usar el estado anterior que ya existe en el estado ProductsByCategoryLoaded
    AppLogger.logInfo('Recuperando desde ProductsByCategoryLoaded');

    // Si estamos viendo la página de home, cargar home de nuevo para refrescar
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (context.mounted) {
        HomeBlocHandler.loadHomeData(context);
      }
    });

    return _buildLoadedState(context, state.previousState);
  }

  /// Construye la UI para estados relacionados con categorías
  Widget _buildCategoryRelatedState(BuildContext context) {
    // Intentar recuperar el estado HomeLoaded anterior
    final homeBloc = context.read<HomeBloc>();
    final previousState = homeBloc.state;

    // Forzar carga de datos de home después de que se muestre la UI
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (context.mounted) {
        HomeBlocHandler.loadHomeData(context);
      }
    });

    if (previousState is HomeLoaded) {
      // Tenemos datos anteriores para mostrar
      return _buildLoadedState(context, previousState);
    } else if (previousState is ProductsByCategoryLoaded) {
      // Si estamos en ProductsByCategoryLoaded, usar su estado previo
      return _buildLoadedState(context, previousState.previousState);
    } else {
      // Si no tenemos datos anteriores, forzar recarga y mostrar esqueleto
      return const HomeSkeleton();
    }
  }
}
