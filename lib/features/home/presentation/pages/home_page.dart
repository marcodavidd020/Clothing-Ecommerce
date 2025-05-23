import 'package:flutter/material.dart';
import 'package:flutter_application_ecommerce/features/home/domain/domain.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_application_ecommerce/core/constants/constants.dart';
import 'package:flutter_application_ecommerce/core/network/logger.dart';
import 'package:flutter_application_ecommerce/features/home/domain/entities/category_api_model.dart';
import 'package:flutter_application_ecommerce/features/home/presentation/bloc/bloc.dart';
import 'package:flutter_application_ecommerce/features/home/presentation/helpers/helpers.dart';
import 'package:flutter_application_ecommerce/features/home/presentation/widgets/widgets.dart';

/// Página principal (Home) de la aplicación.
///
/// Muestra un selector de categorías en el AppBar, una barra de búsqueda,
/// una sección de categorías de productos y el contenido principal de la página,
// Todos con animaciones de entrada.
class HomePage extends StatefulWidget {
  /// Crea una instancia de [HomePage].
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

/// Estado para [HomePage] que maneja la lógica de la UI.
class _HomePageState extends State<HomePage> with WidgetsBindingObserver {
  /// Controller para el scroll
  final ScrollController _scrollController = ScrollController();

  /// Variable para seguir si ya intentamos cargar los datos
  bool _dataRequested = false;

  @override
  void initState() {
    super.initState();
    // Registrar como observador para detectar cuando la app vuelve al primer plano
    WidgetsBinding.instance.addObserver(this);
    // Solicitar datos cuando se crea la página
    _requestInitialDataWithDelay();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // También intentar cargar datos aquí por si el contexto no estaba listo en initState
    _requestInitialDataWithDelay();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // Si la app vuelve al primer plano, forzar recarga de datos
    if (state == AppLifecycleState.resumed) {
      AppLogger.logInfo('App resumed - recargando datos de Home');
      _forceReloadData();
    }
  }

  /// Solicita la carga inicial de datos usando el helper con un pequeño retraso
  void _requestInitialDataWithDelay() {
    if (_dataRequested) return;

    // Marcar que ya hemos solicitado datos
    _dataRequested = true;

    // Usar un pequeño retraso para asegurar que el BLoC está listo
    Future.delayed(const Duration(milliseconds: 100), () {
      if (!mounted) return;
      HomePageHelper.requestInitialData(context, false);
    });
  }

  /// Fuerza la recarga de datos, ignorando si ya se han solicitado
  void _forceReloadData() {
    _dataRequested = false;
    if (mounted) {
      HomePageHelper.requestInitialData(context, false);
      _dataRequested = true;
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeBloc, HomeState>(
      listener: _handleStateChanges,
      builder: (context, state) {
        // Solo cargar datos iniciales si estamos en estado inicial
        if (state is HomeInitial) {
          _requestInitialDataWithDelay();
        }

        // Extraer categorías raíz y categoría seleccionada del estado si están disponibles
        final List<CategoryApiModel> rootCategories =
            state is HomeLoaded ? state.apiCategories : [];

        final CategoryApiModel? selectedCategory =
            state is HomeLoaded ? state.selectedRootCategory : null;

        return Scaffold(
          appBar: _buildAppBar(rootCategories, selectedCategory),
          body: HomeStateHandlerWidget(
            scrollController: _scrollController,
            state: state,
          ),
        );
      },
    );
  }

  /// Construye el AppBar de la página Home
  PreferredSizeWidget _buildAppBar(
    List<CategoryApiModel> rootCategories,
    CategoryApiModel? selectedCategory,
  ) {
    return HomeAppBarWidget(
      rootCategories: rootCategories,
      selectedCategory: selectedCategory,
      onCategorySelected:
          (category) => HomeBlocHandler.selectRootCategory(context, category),
      onCategoryDisplay:
          () => CategorySelectorHandlerWidget.openCategorySelector(
            context,
            rootCategories,
            selectedCategory,
          ),
      onBagPressed: () => HomeNavigationHelper.goToCart(context),
      onProfilePressed: () => HomeNavigationHelper.goToProfile(context),
      profileImageUrl: AppStrings.userPlaceholderIcon,
    );
  }

  /// Maneja los cambios de estado del BLoC
  void _handleStateChanges(BuildContext context, HomeState state) {
    // Manejar feedback general
    HomeBlocHandler.handleHomeState(context, state);

    // Manejar navegación específica para estados de categorías
    _handleCategoryNavigation(context, state);

    // Recargar datos después de estados de categoría completados
    if (_shouldReloadDataAfterState(state)) {
      // Ponemos un pequeño delay para evitar conflictos de estado
      Future.delayed(Duration.zero, () {
        _forceReloadData();
      });
    }
  }

  /// Determina si se deben recargar los datos después de un estado
  bool _shouldReloadDataAfterState(HomeState state) {
    return state is CategoryProductsLoaded ||
        state is CategoryProductsError ||
        state is CategoryByIdLoaded ||
        state is CategoryByIdError;
  }

  /// Maneja la navegación basada en cambios de estado para categorías
  void _handleCategoryNavigation(BuildContext context, HomeState state) {
    // Manejar navegación cuando se completa la carga de una categoría
    if (state is CategoryByIdLoaded) {
      // Obtener todas las categorías para navegación y breadcrumbs
      List<CategoryApiModel> allCategories = [];
      final homeState = context.read<HomeBloc>().state;
      if (homeState is HomeLoaded) {
        allCategories = homeState.apiCategories;
      }

      HomePageHelper.handleCategoryLoaded(
        context,
        state.category,
        allCategories,
      );
    }
    // Manejar navegación cuando se cargan productos para una categoría
    else if (state is CategoryProductsLoaded) {
      HomePageHelper.handleProductsLoaded(
        context,
        state.categoryId,
        state.products,
      );
    }
  }
}
