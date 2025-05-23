import 'package:flutter/material.dart';
import 'package:flutter_application_ecommerce/features/home/domain/entities/product_item_model.dart';
import 'package:flutter_application_ecommerce/features/home/presentation/helpers/category_ui_helper.dart';
import 'package:flutter_application_ecommerce/features/home/presentation/widgets/common/empty_state_widget.dart';
import 'package:flutter_application_ecommerce/features/home/presentation/widgets/product/product_item_widget.dart';
import 'package:flutter_application_ecommerce/features/home/presentation/widgets/skeleton/products_grid_skeleton_widget.dart';

/// Widget para mostrar una sección de productos con título
class ProductsGridSectionWidget extends StatelessWidget {
  /// Lista de productos a mostrar
  final List<ProductItemModel> products;

  /// Si se están cargando los productos
  final bool isLoading;

  /// Si debe mostrar mensaje vacío cuando no hay productos
  final bool showEmptyState;

  /// Callback cuando se selecciona un producto
  final void Function(ProductItemModel)? onProductSelected;

  /// Callback cuando se cambia el estado de favorito
  final void Function(ProductItemModel)? onFavoriteToggle;

  /// Constructor
  const ProductsGridSectionWidget({
    super.key,
    required this.products,
    this.isLoading = false,
    this.showEmptyState = true,
    this.onProductSelected,
    this.onFavoriteToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CategoryUIHelper.buildSectionHeader(CategoryUIHelper.productosTitle),
        CategoryUIHelper.mediumVerticalSpacer(),
        _buildContent(context),
      ],
    );
  }

  /// Construye el contenido según el estado (cargando, con productos o vacío)
  Widget _buildContent(BuildContext context) {
    if (isLoading) {
      // Usar el widget de esqueleto con shimmer durante la carga
      return const ProductsGridSkeletonWidget();
    } else if (products.isNotEmpty) {
      return _buildProductsGrid(context);
    } else if (showEmptyState) {
      return const EmptyStateWidget(
        message: 'No hay productos disponibles en esta categoría',
        icon: Icons.inventory_2_outlined,
      );
    }

    return const SizedBox.shrink();
  }

  /// Construye la cuadrícula de productos con un diseño responsivo
  Widget _buildProductsGrid(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.zero,
      gridDelegate: CategoryUIHelper.getResponsiveGridDelegate(context),
      itemCount: products.length,
      itemBuilder: (context, index) {
        final product = products[index];
        return ProductItemWidget(
          product: product,
          onTap: onProductSelected,
          onFavoriteToggle: onFavoriteToggle,
        );
      },
    );
  }
}
