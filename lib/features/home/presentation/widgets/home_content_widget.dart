import 'package:flutter/material.dart';
import 'package:flutter_application_ecommerce/core/constants/constants.dart';
import 'package:flutter_application_ecommerce/core/widgets/widgets.dart';
import 'package:flutter_application_ecommerce/features/home/domain/domain.dart';
import 'package:flutter_application_ecommerce/features/home/presentation/presentation.dart';

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
  final VoidCallback onSeeAllTopSellingPressed;

  /// Callback cuando se presiona ver todos los productos nuevos
  final VoidCallback onSeeAllNewInPressed;

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
    required this.onSeeAllTopSellingPressed,
    required this.onSeeAllNewInPressed,
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
                _buildSearchBar(),
                const SizedBox(height: AppDimens.vSpace16),
                _buildCategoriesSection(),
                const SizedBox(height: AppDimens.vSpace16),
                _buildTopSellingSection(),
                const SizedBox(height: AppDimens.vSpace16),
                _buildNewInSection(),
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

  Widget _buildSearchBar() {
    return SearchBarWidget(onTap: widget.onSearchTapped);
  }

  Widget _buildCategoriesSection() {
    return CategoriesSectionWidget(
      categories: widget.state.categories,
      onSeeAllPressed: widget.onSeeAllCategoriesPressed,
      onCategoryTap: widget.onCategoryTapped,
    );
  }

  Widget _buildTopSellingSection() {
    return ProductHorizontalListSection(
      products: widget.state.topSellingProducts,
      onSeeAllPressed: widget.onSeeAllTopSellingPressed,
      onProductTap: widget.onProductTapped,
      onFavoriteToggle: widget.onToggleFavorite,
    );
  }

  Widget _buildNewInSection() {
    return ProductHorizontalListSection(
      title: AppStrings.newInTitle,
      titleColor: AppColors.primary,
      products: widget.state.newInProducts,
      onSeeAllPressed: widget.onSeeAllNewInPressed,
      onProductTap: widget.onProductTapped,
      onFavoriteToggle: widget.onToggleFavorite,
    );
  }
}
