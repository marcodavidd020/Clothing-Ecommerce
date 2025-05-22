import 'package:flutter/material.dart';
import 'package:flutter_application_ecommerce/features/home/core/constants/home_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_application_ecommerce/core/constants/constants.dart';
import 'package:flutter_application_ecommerce/core/network/logger.dart';
import 'package:flutter_application_ecommerce/core/widgets/widgets.dart';
import 'package:flutter_application_ecommerce/features/home/domain/domain.dart';
import 'package:flutter_application_ecommerce/features/home/presentation/bloc/home_bloc.dart';
import 'package:flutter_application_ecommerce/features/home/presentation/widgets/widgets.dart';
import 'package:flutter_application_ecommerce/features/home/presentation/helpers/helpers.dart';
import 'package:flutter_svg/svg.dart';

/// Página que muestra el detalle de una categoría con sus subcategorías y/o productos.
///
/// Esta página es el componente central del flujo de navegación entre categorías,
/// permitiendo navegar en la jerarquía de categorías y mostrando productos cuando
/// se llega a una categoría hoja.
class CategoryDetailPage extends StatefulWidget {
  /// La categoría actual que se está visualizando
  final CategoryApiModel category;

  /// Lista completa de categorías para poder construir breadcrumbs
  final List<CategoryApiModel> allCategories;

  /// Constructor
  const CategoryDetailPage({
    super.key,
    required this.category,
    required this.allCategories,
  });

  @override
  State<CategoryDetailPage> createState() => _CategoryDetailPageState();
}

class _CategoryDetailPageState extends State<CategoryDetailPage> {
  /// Lista de productos de la categoría actual (si los tiene)
  List<ProductItemModel> _products = [];

  /// Indicador de carga de productos
  bool _isLoadingProducts = false;

  @override
  void initState() {
    super.initState();
    _loadCategoryProducts();
  }

  @override
  void didUpdateWidget(CategoryDetailPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Si la categoría cambió, volver a cargar productos
    if (oldWidget.category.id != widget.category.id) {
      setState(() {
        _products = [];
        _isLoadingProducts = false;
      });
      _loadCategoryProducts();
    }
  }

  /// Carga los productos de esta categoría si tiene productos directos
  void _loadCategoryProducts() {
    // Solo cargar productos si la categoría debería tenerlos
    if (widget.category.hasProducts) {
      AppLogger.logInfo(
        'Cargando productos para categoría: ${widget.category.id}',
      );
      setState(() => _isLoadingProducts = true);

      // Cargar productos usando el BloC
      final homeBloc = context.read<HomeBloc>();
      final currentState = homeBloc.state;
      AppLogger.logInfo(
        'Estado actual del HomeBloc: ${currentState.runtimeType}',
      );

      homeBloc.add(LoadProductsByCategoryEvent(categoryId: widget.category.id));
      AppLogger.logInfo(
        'Evento LoadProductsByCategoryEvent enviado para: ${widget.category.id}',
      );
    } else {
      AppLogger.logInfo(
        'La categoría ${widget.category.id} no tiene productos directos, no se cargarán',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: BlocConsumer<HomeBloc, HomeState>(
        listener: _handleBlocStateChanges,
        builder: (context, state) => _buildBody(),
      ),
    );
  }

  /// Maneja los cambios de estado del BLoC para actualizar la UI
  void _handleBlocStateChanges(BuildContext context, HomeState state) {
    // Manejar la respuesta de carga de productos
    if ((state is CategoryProductsLoaded &&
            state.categoryId == widget.category.id) ||
        (state is ProductsByCategoryLoaded &&
            state.categoryId == widget.category.id)) {
      setState(() {
        _products =
            state is CategoryProductsLoaded
                ? state.products
                : (state as ProductsByCategoryLoaded).products;
        _isLoadingProducts = false;
      });
      AppLogger.logInfo(
        'Actualizados productos de categoría ${widget.category.id}: ${_products.length} productos',
      );
    }
    // Manejar estado de carga
    else if (state is LoadingProductsByCategory &&
        state.categoryId == widget.category.id) {
      setState(() => _isLoadingProducts = true);
      AppLogger.logInfo(
        'Iniciada carga de productos para categoría ${widget.category.id}',
      );
    }
    // Manejar estado de error
    else if (state is CategoryProductsError &&
        state.categoryId == widget.category.id) {
      setState(() => _isLoadingProducts = false);

      // Mostrar un snackbar con el error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error al cargar productos: ${state.message}'),
          backgroundColor: Colors.red.shade700,
        ),
      );
    }
    // Manejar error general
    else if (state is HomeError) {
      setState(() => _isLoadingProducts = false);

      // Mostrar mensaje de error genérico
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: ${state.message}'),
          backgroundColor: Colors.red.shade700,
        ),
      );
    }
  }

  /// Construye el AppBar con el título y breadcrumbs si es necesario
  PreferredSizeWidget _buildAppBar() {
    // Obtener la ruta de categorías para mostrar breadcrumbs si hay más de un nivel
    final categoryPath = widget.category.getPathFromRoot(widget.allCategories);
    final bool showBreadcrumbs = categoryPath.length > 1;

    return CustomAppBar(
      showBack: true,
      titleText: widget.category.name,
      toolbarHeight: showBreadcrumbs ? kToolbarHeight + 40 : kToolbarHeight,
      actions:
          showBreadcrumbs
              ? [
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: CategoryBreadcrumbsWidget(
                    path: categoryPath,
                    onCategoryTap: (category) => _navigateToCategory(category),
                  ),
                ),
              ]
              : null,
    );
  }

  /// Construye el cuerpo principal con subcategorías y/o productos
  Widget _buildBody() {
    return SafeArea(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimens.screenPadding,
            vertical: AppDimens.vSpace16,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Sección de subcategorías (si existen)
              if (widget.category.children.isNotEmpty)
                _buildSubcategoriesSection(),

              // Sección de productos (cargando, con productos o vacía)
              _buildProductsSection(),
            ],
          ),
        ),
      ),
    );
  }

  /// Construye la sección de subcategorías
  Widget _buildSubcategoriesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CategoryUIHelper.buildSectionHeader(
          CategoryUIHelper.subcategoriasTitle,
        ),
        CategoryUIHelper.mediumVerticalSpacer(),
        _buildSubcategoriesList(),
        CategoryUIHelper.largeVerticalSpacer(),
      ],
    );
  }

  /// Construye la sección de productos según el estado (cargando/con productos/vacía)
  Widget _buildProductsSection() {
    // Si está cargando productos, mostrar indicador
    if (_isLoadingProducts) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CategoryUIHelper.buildSectionHeader(CategoryUIHelper.productosTitle),
          CategoryUIHelper.mediumVerticalSpacer(),
          CategoryUIHelper.buildLoadingIndicator(),
        ],
      );
    }
    // Si hay productos, mostrar la cuadrícula
    else if (_products.isNotEmpty) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CategoryUIHelper.buildSectionHeader(CategoryUIHelper.productosTitle),
          CategoryUIHelper.mediumVerticalSpacer(),
          _buildProductsGrid(),
        ],
      );
    }
    // Si no hay productos ni subcategorías, mostrar mensaje de estado vacío
    else if (widget.category.children.isEmpty) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CategoryUIHelper.buildSectionHeader(CategoryUIHelper.productosTitle),
          CategoryUIHelper.mediumVerticalSpacer(),
          const EmptyStateWidget(
            message: 'No hay productos disponibles en esta categoría',
            icon: Icons.inventory_2_outlined,
          ),
        ],
      );
    }

    // Si hay subcategorías pero no productos, no mostrar esta sección
    return const SizedBox.shrink();
  }

  /// Construye una lista vertical de subcategorías
  Widget _buildSubcategoriesList() {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: widget.category.children.length,
      padding: EdgeInsets.zero,
      separatorBuilder: (_, __) => CategoryUIHelper.smallVerticalSpacer(),
      itemBuilder: (context, index) {
        final subcategory = widget.category.children[index];
        return CategoryListItemWidget(
          category: CategoryItemModel(
            imageUrl: CategoryUIHelper.getCategoryImageUrl(subcategory),
            name: subcategory.name,
          ),
          onTap: () => _navigateToCategory(subcategory),
          backgroundColor: AppColors.backgroundGray.withOpacity(0.5),
          trailingIcon: SvgPicture.asset(
            AppStrings.arrowRightIcon,
            width: HomeUI.productItemTrailingIconSize,
            height: HomeUI.productItemTrailingIconSize,
          ),
        );
      },
    );
  }

  /// Construye la cuadrícula de productos con un diseño responsivo
  Widget _buildProductsGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.zero,
      gridDelegate: CategoryUIHelper.getResponsiveGridDelegate(context),
      itemCount: _products.length,
      itemBuilder: (context, index) {
        final product = _products[index];
        return ProductItemWidget(
          product: product,
          onTap:
              (product) =>
                  HomeNavigationHelper.goToProductDetail(context, product),
          onFavoriteToggle:
              (product) => HomeBlocHandler.toggleFavorite(
                context,
                product.id,
                !product.isFavorite,
              ),
        );
      },
    );
  }

  /// Navega a una categoría específica usando el helper de navegación
  void _navigateToCategory(CategoryApiModel category) {
    // Usar el helper de navegación para mantener consistencia en toda la app
    HomeNavigationHelper.navigateAfterCategoryLoaded(
      context,
      category,
      widget.allCategories,
    );
  }
}
