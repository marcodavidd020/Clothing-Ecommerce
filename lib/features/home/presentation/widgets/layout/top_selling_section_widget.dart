import 'package:flutter/material.dart';
import 'package:flutter_application_ecommerce/core/constants/constants.dart';
import 'package:flutter_application_ecommerce/features/home/domain/domain.dart';
import 'package:flutter_application_ecommerce/features/home/presentation/presentation.dart';

/// Widget que muestra una sección horizontal de productos (Top Selling o New In)
class ProductHorizontalListSection extends StatelessWidget {
  /// Título de la sección
  final String title;

  /// Color del título
  final Color titleColor;

  /// Lista de productos a mostrar
  final List<ProductItemModel> products;

  /// Callback para el botón "Ver todos"
  final VoidCallback? onSeeAllPressed;

  /// Callback cuando se toca un producto
  final Function(ProductItemModel)? onProductTap;

  /// Callback cuando se cambia el estado de favorito de un producto
  final Function(ProductItemModel)? onFavoriteToggle;

  /// Constructor
  const ProductHorizontalListSection({
    super.key,
    required this.products,
    this.title = AppStrings.topSellingTitle,
    this.titleColor = AppColors.textDark,
    this.onSeeAllPressed,
    this.onProductTap,
    this.onFavoriteToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        HomeUIHelpers.buildSectionTitle(
          title: title,
          titleColor: titleColor,
          onSeeAllPressed: onSeeAllPressed,
        ),
        HomeUIHelpers.smallVerticalSpace,
        _buildProductsList(),
      ],
    );
  }

  /// Construye la lista horizontal de productos
  Widget _buildProductsList() {
    return SizedBox(
      height: AppDimens.topSellingSectionHeight,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: products.length,
        itemBuilder: (context, index) {
          final product = products[index];
          return ProductItemWidget(
            product: product,
            onTap: onProductTap,
            onFavoriteToggle: onFavoriteToggle,
          );
        },
        separatorBuilder:
            (context, index) => const SizedBox(width: AppDimens.vSpace16),
      ),
    );
  }
}
