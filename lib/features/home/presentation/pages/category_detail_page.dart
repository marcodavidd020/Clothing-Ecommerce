import 'package:flutter/material.dart';
import 'package:flutter_application_ecommerce/core/constants/constants.dart';
import 'package:flutter_application_ecommerce/features/home/domain/domain.dart';
import 'package:flutter_application_ecommerce/features/home/presentation/bloc/bloc.dart';
import 'package:flutter_application_ecommerce/features/home/presentation/helpers/helpers.dart';
import 'package:flutter_application_ecommerce/features/home/presentation/widgets/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
      setState(() => _isLoadingProducts = true);

      // Solicitar carga de productos
      context.read<HomeBloc>().add(
        LoadProductsByCategoryEvent(categoryId: widget.category.id),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CategoryDetailAppBar(
        category: widget.category,
        allCategories: widget.allCategories,
        onCategoryTap: _navigateToCategory,
      ),
      body: BlocConsumer<HomeBloc, HomeState>(
        listener: _handleBlocStateChanges,
        builder: (context, state) => _buildBody(),
      ),
    );
  }

  /// Maneja los cambios de estado del BLoC para actualizar la UI
  void _handleBlocStateChanges(BuildContext context, HomeState state) {
    CategoryBlocHandler.handleCategoryDetailState(
      context: context,
      state: state,
      categoryId: widget.category.id,
      onProductsLoaded: (products) {
        setState(() {
          _products = products;
          _isLoadingProducts = false;
        });
      },
      onLoadingChanged: (isLoading) {
        setState(() => _isLoadingProducts = isLoading);
      },
      onError: (message) {
        CategoryBlocHandler.showErrorSnackBar(context, message);
      },
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
              CategorySectionWidget(
                subcategories: widget.category.children,
                onCategorySelected: _navigateToCategory,
              ),

              // Sección de productos
              ProductsGridSectionWidget(
                products: _products,
                isLoading: _isLoadingProducts,
                showEmptyState: widget.category.children.isEmpty,
                onProductSelected:
                    (product) => HomeNavigationHelper.goToProductDetail(
                      context,
                      product,
                    ),
                onFavoriteToggle:
                    (product) => HomeBlocHandler.toggleFavorite(
                      context,
                      product.id,
                      !product.isFavorite,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Navega a una categoría específica usando el helper de navegación
  void _navigateToCategory(CategoryApiModel category) {
    HomeNavigationHelper.navigateAfterCategoryLoaded(
      context,
      category,
      widget.allCategories,
    );
  }
}
