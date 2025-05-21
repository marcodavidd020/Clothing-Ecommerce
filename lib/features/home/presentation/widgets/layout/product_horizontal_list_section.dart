import 'package:flutter/material.dart';
import 'package:flutter_application_ecommerce/core/constants/constants.dart';
import 'package:flutter_application_ecommerce/features/home/domain/domain.dart';
import 'package:flutter_application_ecommerce/features/home/presentation/widgets/widgets.dart';

/// Widget que muestra una sección de lista horizontal de productos
///
/// Utilizado para mostrar secciones como "Productos destacados" o "Nuevos productos"
class ProductHorizontalListSection extends StatelessWidget {
  /// Título de la sección
  final String? title;

  /// Color del título
  final Color titleColor;

  /// Lista de productos a mostrar
  final List<ProductItemModel> products;

  /// Callback cuando se presiona "Ver todos"
  final VoidCallback onSeeAllPressed;

  /// Callback cuando se presiona un producto
  final Function(ProductItemModel) onProductTap;

  /// Callback cuando se agrega o quita un producto de favoritos
  final Function(ProductItemModel) onFavoriteToggle;

  /// Constructor principal
  const ProductHorizontalListSection({
    super.key,
    this.title = AppStrings.topSellingTitle,
    this.titleColor = AppColors.textDark,
    required this.products,
    required this.onSeeAllPressed,
    required this.onProductTap,
    required this.onFavoriteToggle,
  });

  @override
  Widget build(BuildContext context) {
    if (products.isEmpty) {
      return _buildEmptySection();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader(),
        const SizedBox(height: AppDimens.vSpace8),
        SizedBox(
          height: 230.0, // Altura fija para la tarjeta de producto
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: products.length,
            separatorBuilder: (context, index) => const SizedBox(width: 16.0),
            itemBuilder: (context, index) {
              final product = products[index];
              return ProductCardWidget(
                product: product,
                onTap: () => onProductTap(product),
                onFavoriteToggle: () => onFavoriteToggle(product),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildSectionHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title!,
          style: AppTextStyles.sectionTitle.copyWith(color: titleColor),
        ),
        TextButton(
          onPressed: onSeeAllPressed,
          child: Text(AppStrings.seeAllLabel, style: AppTextStyles.seeAll),
        ),
      ],
    );
  }

  Widget _buildEmptySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title!,
          style: AppTextStyles.sectionTitle.copyWith(color: titleColor),
        ),
        const SizedBox(height: AppDimens.vSpace16),
        const Center(
          child: Text(
            'No hay productos disponibles',
            style: TextStyle(
              color: AppColors.textDark,
              fontStyle: FontStyle.italic,
            ),
          ),
        ),
      ],
    );
  }
}
