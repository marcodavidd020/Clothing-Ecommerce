import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_application_ecommerce/core/constants/constants.dart';
import 'package:flutter_application_ecommerce/core/network/logger.dart';
import 'package:flutter_application_ecommerce/features/home/domain/domain.dart';
import 'package:flutter_application_ecommerce/features/home/presentation/bloc/home_bloc.dart';
import 'package:flutter_application_ecommerce/features/home/presentation/widgets/widgets.dart';
import 'package:flutter_application_ecommerce/features/home/presentation/helpers/helpers.dart';

/// Página principal (Home) de la aplicación.
///
/// Muestra un selector de categorías en el AppBar, una barra de búsqueda,
/// una sección de categorías de productos y el contenido principal de la página,
/// todos con animaciones de entrada.
class HomePage extends StatefulWidget {
  /// Crea una instancia de [HomePage].
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

/// Estado para [HomePage] que maneja la lógica de la UI.
class _HomePageState extends State<HomePage> {
  final ScrollController _scrollController = ScrollController();

  /// Variable para seguir si ya intentamos cargar los datos
  bool _dataRequested = false;

  @override
  void initState() {
    super.initState();
    _loadInitialData();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // También intentar cargar datos aquí por si el contexto no estaba listo en initState
    _loadInitialData();
  }

  /// Carga los datos iniciales si aún no se han cargado
  void _loadInitialData() {
    if (!_dataRequested) {
      AppLogger.logInfo('Solicitando carga de datos iniciales para HomeBloc');
      final homeBloc = context.read<HomeBloc>();

      // Verificar el estado actual del bloc
      final currentState = homeBloc.state;
      if (currentState is! HomeLoaded) {
        HomeBlocHandler.loadHomeData(context);
      }

      // Siempre intentamos cargar las categorías del API para tener los datos más recientes
      HomeBlocHandler.loadApiCategories(context);

      _dataRequested = true;
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  /// Abre el selector de categorías
  void _openCategorySelector(
    List<CategoryApiModel> categories,
    CategoryApiModel? selectedCategory,
  ) {
    CategorySelectorModal.show(
      context: context,
      categories: categories,
      selectedCategory: selectedCategory,
      onCategorySelected: (category) => HomeBlocHandler.selectRootCategory(context, category),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeBloc, HomeState>(
      listener: HomeBlocHandler.handleHomeState,
      builder: (context, state) {
        // Si el estado es inicial o cargando y no hemos solicitado datos, intentar cargarlos
        if ((state is HomeInitial || state is HomeLoading) && !_dataRequested) {
          _loadInitialData();
        }

        // Extraer categorías raíz y categoría seleccionada del estado si están disponibles
        final List<CategoryApiModel> rootCategories =
            state is HomeLoaded ? state.apiCategories : [];

        final CategoryApiModel? selectedCategory =
            state is HomeLoaded ? state.selectedRootCategory : null;

        return Scaffold(
          appBar: HomeAppBarWidget(
            rootCategories: rootCategories,
            selectedCategory: selectedCategory,
            onCategorySelected: (category) => HomeBlocHandler.selectRootCategory(context, category),
            onCategoryDisplay:
                () => _openCategorySelector(rootCategories, selectedCategory),
            onBagPressed: () => HomeNavigationHelper.goToCart(context),
            onProfilePressed: () => HomeNavigationHelper.goToProfile(context),
            profileImageUrl: AppStrings.userPlaceholderIcon,
          ),
          body: _buildBody(state),
        );
      },
    );
  }

  Widget _buildBody(HomeState state) {
    if (HomeBlocHandler.isLoading(state)) {
      // Usar esqueleto de carga
      return const HomeSkeleton();
    }

    if (state is HomeError) {
      return ErrorContentWidget(
        message: state.message,
        onRetry: () {
          _dataRequested = false;
          _loadInitialData();
        },
      );
    }

    if (state is HomeLoaded) {
      return HomeContentWidget(
        state: state,
        scrollController: _scrollController,
        onSearchTapped: () => HomeNavigationHelper.goToSearch(context),
        onSeeAllCategoriesPressed: () => HomeNavigationHelper.goToAllCategories(context),
        onSeeAllTopSellingPressed: () {
          // TODO: Implementar navegación a todos los productos más vendidos
          AppLogger.logInfo('Ver todos los productos más vendidos - no implementado');
        },
        onSeeAllNewInPressed: () {
          // TODO: Implementar navegación a todos los productos nuevos
          AppLogger.logInfo('Ver todos los productos nuevos - no implementado');
        },
        onCategoryTapped: (category) => HomeBlocHandler.loadProductsByCategory(context, category.name),
        onProductTapped: (product) => HomeNavigationHelper.goToProductDetail(context, product),
        onToggleFavorite: (product) => HomeBlocHandler.toggleFavorite(context, product.id, !product.isFavorite),
      );
    }

    // Para cualquier otro estado no manejado, mostrar el esqueleto de carga
    AppLogger.logWarning('Estado no manejado: ${state.runtimeType}');
    return const HomeSkeleton();
  }
}
