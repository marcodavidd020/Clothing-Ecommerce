import 'package:flutter/material.dart';
import 'package:flutter_application_ecommerce/core/constants/constants.dart';
import 'package:flutter_application_ecommerce/core/widgets/widgets.dart';
import 'package:flutter_application_ecommerce/features/home/domain/domain.dart';
import 'package:flutter_application_ecommerce/features/home/presentation/presentation.dart';
import 'package:flutter_application_ecommerce/core/network/logger.dart';

/// Widget que implementa el contenido principal de la página Home.
///
/// Muestra una barra de búsqueda, categorías y secciones de productos.
class HomeContentWidget extends StatefulWidget {
  /// Estado cargado con los datos del Home
  final HomeLoaded state;

  /// Controller para el scroll
  final ScrollController scrollController;

  /// Callback cuando se presiona ver todas las categorías
  final VoidCallback onSeeAllCategoriesPressed;

  /// Callback cuando se presiona ver todos los productos destacados
  // final VoidCallback onSeeAllTopSellingPressed;

  /// Callback cuando se presiona ver todos los productos nuevos
  // final VoidCallback onSeeAllNewInPressed;

  /// Callback cuando se presiona la barra de búsqueda
  final VoidCallback onSearchTapped;

  /// Callback cuando se selecciona una categoría
  final Function(CategoryItemModel) onCategoryTapped;

  /// Callback cuando se selecciona un producto
  final Function(ProductItemModel) onProductTapped;

  /// Callback cuando se agrega o quita un producto de favoritos
  final Function(ProductItemModel) onToggleFavorite;

  /// Constructor principal
  const HomeContentWidget({
    super.key,
    required this.state,
    required this.scrollController,
    required this.onSeeAllCategoriesPressed,
    required this.onSearchTapped,
    required this.onCategoryTapped,
    required this.onProductTapped,
    required this.onToggleFavorite,
  });

  @override
  State<HomeContentWidget> createState() => _HomeContentWidgetState();
}

class _HomeContentWidgetState extends State<HomeContentWidget> {
  bool _showFade = true;

  @override
  void initState() {
    super.initState();
    widget.scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    // No llamamos dispose al controller porque lo maneja el padre
    widget.scrollController.removeListener(_scrollListener);
    super.dispose();
  }

  void _scrollListener() {
    const double scrollThreshold = 10.0;
    bool isAtBottom =
        widget.scrollController.position.pixels >=
        widget.scrollController.position.maxScrollExtent - scrollThreshold;

    if (isAtBottom && _showFade) {
      setState(() {
        _showFade = false;
      });
    } else if (!isAtBottom && !_showFade) {
      setState(() {
        _showFade = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ShaderMask(
        shaderCallback: _buildShaderCallback,
        blendMode: BlendMode.dstIn,
        child: SingleChildScrollView(
          controller: widget.scrollController,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppDimens.screenPadding,
              vertical: AppDimens.vSpace16,
            ),
            child: AnimatedStaggeredList(
              children: [
                SearchBarWidget(onTap: widget.onSearchTapped),
                const SizedBox(height: AppDimens.vSpace16),
                HomeCategoriesSection(
                  selectedRootCategory: widget.state.selectedRootCategory,
                  allCategories: widget.state.apiCategories,
                  onSeeAllPressed: widget.onSeeAllCategoriesPressed,
                ),
                const SizedBox(height: AppDimens.vSpace16),
                // ProductHorizontalListSection(
                //   products: widget.state.topSellingProducts,
                //   onSeeAllPressed: widget.onSeeAllTopSellingPressed,
                //   onProductTap: widget.onProductTapped,
                //   onFavoriteToggle: widget.onToggleFavorite,
                // ),
                const SizedBox(height: AppDimens.vSpace16),
                // ProductHorizontalListSection(
                //   title: AppStrings.newInTitle,
                //   titleColor: AppColors.primary,
                //   products: widget.state.newInProducts,
                //   onSeeAllPressed: widget.onSeeAllNewInPressed,
                //   onProductTap: widget.onProductTapped,
                //   onFavoriteToggle: widget.onToggleFavorite,
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Shader _buildShaderCallback(Rect bounds) {
    return LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors:
          _showFade
              ? [Colors.white, Colors.white.withAlpha(0)]
              : [Colors.white, Colors.white],
      stops:
          _showFade
              ? const [
                AppDimens.homeContentFadeStart,
                AppDimens.homeContentFadeEnd,
              ]
              : null,
    ).createShader(bounds);
  }
}

/// Widget para mostrar la sección de categorías en la página Home
class HomeCategoriesSection extends StatelessWidget {
  /// Categoría raíz seleccionada
  final CategoryApiModel? selectedRootCategory;
  
  /// Lista de todas las categorías
  final List<CategoryApiModel> allCategories;
  
  /// Callback cuando se presiona "Ver todas"
  final VoidCallback onSeeAllPressed;

  /// Constructor
  const HomeCategoriesSection({
    super.key,
    required this.selectedRootCategory,
    required this.allCategories,
    required this.onSeeAllPressed,
  });

  @override
  Widget build(BuildContext context) {
    if (selectedRootCategory == null) {
      return const SizedBox.shrink();
    }

    // Obtenemos las subcategorías directamente del modelo API
    final List<CategoryApiModel> childCategories =
        selectedRootCategory!.children;

    // Si no hay categorías hijas, mostrar un mensaje
    if (childCategories.isEmpty) {
      return _buildEmptyCategoriesSection();
    }

    // Crear la UI para mostrar las categorías en formato carrusel
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                'Subcategorías de ${selectedRootCategory!.name}',
                style: AppTextStyles.sectionTitle,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            TextButton(
              onPressed: onSeeAllPressed,
              child: Text(
                AppStrings.seeAllLabel,
                style: AppTextStyles.seeAll,
              ),
            ),
          ],
        ),
        SizedBox(
          height: AppDimens.categoriesItemHeight,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: childCategories.length,
            itemBuilder: (context, index) {
              return _buildCategoryItem(context, childCategories[index]);
            },
            separatorBuilder:
                (context, index) => const SizedBox(width: AppDimens.vSpace16),
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyCategoriesSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppDimens.vSpace16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Subcategorías de ${selectedRootCategory!.name}',
                style: AppTextStyles.sectionTitle,
              ),
            ],
          ),
          const SizedBox(height: AppDimens.vSpace16),
          const Center(
            child: Text(
              'No hay subcategorías disponibles',
              style: TextStyle(
                color: AppColors.textDark,
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryItem(BuildContext context, CategoryApiModel apiCategory) {
    // Creamos un CategoryItemModel solo para presentación, pero guardamos el original
    final displayCategory = CategoryItemModel(
      imageUrl:
          apiCategory.imageUrl ?? 'https://via.placeholder.com/150',
      name: apiCategory.name,
    );

    return CategoryItemWidget(
      category: displayCategory,
      onTap: () {
        // Verificamos si tiene hijos directamente mirando la lista de hijos
        if (apiCategory.children.isNotEmpty) {
          // Si tiene subcategorías, navegamos a la vista de categoría
          AppLogger.logInfo('Navegando a subcategoría con hijos: ${apiCategory.name}');
          HomeNavigationHelper.navigateAfterCategoryLoaded(
            context,
            apiCategory,
            allCategories,
          );
        } else {
          // Si no tiene subcategorías, cargamos sus productos y luego navegamos
          AppLogger.logInfo('Cargando productos de categoría sin hijos: ${apiCategory.name}');
          
          // Solo navegamos directamente - el CategoryDetailPage se encargará de cargar los productos
          HomeNavigationHelper.navigateAfterCategoryLoaded(
            context,
            apiCategory,
            allCategories,
          );
        }
      },
    );
  }
}
