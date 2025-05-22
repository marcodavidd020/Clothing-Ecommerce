import 'package:flutter/material.dart';
import 'package:flutter_application_ecommerce/core/constants/constants.dart';
import 'package:flutter_application_ecommerce/core/widgets/widgets.dart';
import 'package:flutter_application_ecommerce/features/home/domain/domain.dart';
import 'package:flutter_application_ecommerce/features/home/presentation/bloc/states/home_state.dart';
import 'package:flutter_application_ecommerce/features/home/presentation/widgets/widgets.dart';

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
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: FadeEdgeScrollWidget(
        scrollController: widget.scrollController,
        child: SingleChildScrollView(
          controller: widget.scrollController,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppDimens.screenPadding,
              vertical: AppDimens.vSpace16,
            ),
            child: _buildContent(),
          ),
        ),
      ),
    );
  }

  /// Construye el contenido principal de la página
  Widget _buildContent() {
    return AnimatedStaggeredList(
      children: [
        // Barra de búsqueda
        SearchBarWidget(onTap: widget.onSearchTapped),
        const SizedBox(height: AppDimens.vSpace16),

        // Sección de categorías
        HomeCategoriesSection(
          selectedRootCategory: widget.state.selectedRootCategory,
          allCategories: widget.state.apiCategories,
          onSeeAllPressed: widget.onSeeAllCategoriesPressed,
        ),

        // Espaciador para separar secciones
        const SizedBox(height: AppDimens.vSpace16),
      ],
    );
  }
}
