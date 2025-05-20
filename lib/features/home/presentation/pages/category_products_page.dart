import 'package:flutter/material.dart';
import 'package:flutter_application_ecommerce/core/constants/constants.dart';
import 'package:flutter_application_ecommerce/core/widgets/widgets.dart';
import 'package:flutter_application_ecommerce/features/home/domain/domain.dart';
import 'package:flutter_application_ecommerce/features/home/presentation/widgets/widgets.dart';
import 'package:flutter_application_ecommerce/features/home/presentation/helpers/helpers.dart';

/// Página que muestra los productos de una categoría específica
class CategoryProductsPage extends StatelessWidget {
  /// La categoría seleccionada
  final CategoryItemModel category;

  /// Lista de productos a mostrar
  final List<ProductItemModel> products;

  /// Constructor
  const CategoryProductsPage({
    super.key,
    required this.category,
    required this.products,
  });

  @override
  Widget build(BuildContext context) {
    final title = '${category.name} (${products.length})';

    return Scaffold(
      appBar: CustomAppBar(showBack: true, titleText: title),
      body: SafeArea(
        child:
            products.isEmpty ? _buildEmptyState() : _buildProductsGrid(context),
      ),
    );
  }

  /// Construye el estado vacío cuando no hay productos
  Widget _buildEmptyState() {
    return Center(
      child: Text(AppStrings.noProductsFound, style: AppTextStyles.inputText),
    );
  }

  /// Construye la cuadrícula de productos
  Widget _buildProductsGrid(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimens.screenPadding,
        vertical: AppDimens.vSpace16,
      ),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: AppDimens.screenPadding,
        mainAxisSpacing: AppDimens.screenPadding,
        childAspectRatio: AppDimens.categoryProductGridAspectRatio,
      ),
      itemCount: products.length,
      itemBuilder: (context, index) {
        final product = products[index];
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
}
