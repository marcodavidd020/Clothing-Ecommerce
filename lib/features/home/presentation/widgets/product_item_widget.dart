import 'package:flutter/material.dart';
import 'package:flutter_application_ecommerce/core/constants/constants.dart';
import 'package:flutter_application_ecommerce/features/home/domain/domain.dart';
import 'package:flutter_application_ecommerce/features/home/presentation/widgets/product_image_section_widget.dart';
import 'package:flutter_application_ecommerce/features/home/presentation/widgets/product_info_section_widget.dart';

/// Widget que representa un ítem de producto en las listas de la aplicación.
///
/// Muestra la imagen del producto, un botón de favorito, el nombre,
/// la calificación en estrellas, el número de reseñas y el precio.
class ProductItemWidget extends StatelessWidget {
  /// Modelo de datos del producto a mostrar
  final ProductItemModel product;

  /// Callback cuando se toca el producto
  final Function(ProductItemModel)? onTap;

  /// Callback cuando se toca el botón de favorito
  final Function(ProductItemModel)? onFavoriteToggle;

  /// Crea una instancia de [ProductItemWidget].
  const ProductItemWidget({
    super.key,
    required this.product,
    this.onTap,
    this.onFavoriteToggle,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (onTap != null) {
          onTap!(product);
        }
      },
      child: Container(
        width: AppDimens.productItemWidth,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(
            AppDimens.productItemBorderRadius,
          ),
          color: AppColors.backgroundGray,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ProductImageSectionWidget(
              imageUrl: product.imageUrl,
              isFavorite: product.isFavorite,
              onFavoritePressed:
                  onFavoriteToggle != null
                      ? () => onFavoriteToggle!(product)
                      : null,
            ),
            ProductInfoSectionWidget(
              name: product.name,
              averageRating: product.averageRating,
              reviewCount: product.reviewCount,
              price: product.price,
              originalPrice: product.originalPrice,
            ),
          ],
        ),
      ),
    );
  }
}
