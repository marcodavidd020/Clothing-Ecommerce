import 'package:flutter/material.dart';
import 'package:flutter_application_ecommerce/features/home/core/constants/home_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_application_ecommerce/core/constants/constants.dart';
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

  /// Evita múltiples solicitudes de carga
  bool _loadingRequested = false;

  @override
  void initState() {
    super.initState();
    _loadCategoryProducts();
  }

  /// Carga los productos de esta categoría si tiene productos directos
  void _loadCategoryProducts() {
    // Solo cargar productos si la categoría debería tenerlos y no hemos solicitado la carga ya
    if (widget.category.hasProducts && !_loadingRequested) {
      setState(() => _isLoadingProducts = true);
      _loadingRequested = true;

      // Cargar productos usando el BloC
      final homeBloc = context.read<HomeBloc>();
      homeBloc.add(LoadProductsByCategoryEvent(categoryId: widget.category.id));
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
    if (state is CategoryProductsLoaded &&
        state.categoryId == widget.category.id) {
      setState(() {
        _products = state.products;
        _isLoadingProducts = false;
      });
    } else if (state is CategoryProductsError &&
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
      return CategoryUIHelper.buildLoadingIndicator();
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
    else if (widget.category.children.isEmpty && !_isLoadingProducts) {
      return EmptyStateWidget(message: CategoryUIHelper.noProductsMessage);
    }

    // Caso fallback (no debería llegar aquí normalmente)
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
            width:  HomeUI.productItemTrailingIconSize,
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
    CategoryNavigationHelper.navigateToCategory(
      context,
      category: category,
      currentCategory: widget.category,
      allCategories: widget.allCategories,
    );
  }
}
