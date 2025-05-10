import 'package:flutter/material.dart';
import 'package:flutter_application_ecommerce/core/constants/constants.dart';
import 'package:flutter_application_ecommerce/core/widgets/widgets.dart';
import 'package:flutter_application_ecommerce/features/home/domain/domain.dart';
import 'package:flutter_application_ecommerce/features/product_detail/presentation/pages/product_detail_page.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ProductItemWidget extends StatelessWidget {
  final ProductItemModel product;
  final VoidCallback? onTap;
  final VoidCallback? onFavoriteToggle;

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
          onTap!();
        }
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductDetailPage(product: product),
          ),
        );
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
            Stack(
              children: [
                // Imagen del producto
                SizedBox(
                  height: AppDimens.productItemHeight,
                  width: double.infinity,
                  child: ClipRRect(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(AppDimens.productItemBorderRadius),
                    ),
                    child: NetworkImageWithPlaceholder(
                      imageUrl: product.imageUrl,
                      fit: BoxFit.cover,
                      shape: BoxShape.rectangle,
                    ),
                  ),
                ),
                // Botón de favorito
                Positioned(
                  top: AppDimens.heartPositionTop,
                  right: AppDimens.heartPositionRight,
                  child: GestureDetector(
                    onTap: onFavoriteToggle,
                    child: Container(
                      padding: const EdgeInsets.all(AppDimens.heartPadding),
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.white,
                      ),
                      child: SvgPicture.asset(
                        AppStrings.heartIcon,
                        colorFilter:
                            product.isFavorite
                                ? const ColorFilter.mode(
                                    AppColors.heartColor,
                                    BlendMode.srcIn,
                                  )
                                : null,
                        width: AppDimens.heartSizeIcon,
                        height: AppDimens.heartSizeIcon,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(AppDimens.vSpace12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    style: AppTextStyles.topSellingItemName,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: AppDimens.vSpace1),
                  // Fila para las estrellas y el número de reseñas
                  Row(
                    children: [
                      _buildStarRating(product.averageRating),
                      if (product.reviewCount != null)
                        Padding(
                          padding: const EdgeInsets.only(left: 4.0),
                          child: Text(
                            '(${product.reviewCount})',
                            style: TextStyle(
                              fontSize: 10,
                              color: Colors.grey[600],
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: AppDimens.vSpace1),
                  Row(
                    children: [
                      Text(
                        '\$${product.price.toStringAsFixed(2)}',
                        style: AppTextStyles.topSellingItem,
                      ),
                      if (product.originalPrice != null) ...[
                        const SizedBox(width: AppDimens.vSpace8),
                        Text(
                          '\$${product.originalPrice!.toStringAsFixed(2)}',
                          style: AppTextStyles.topSellingItemWithPrice,
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Función helper para construir las estrellas
  Widget _buildStarRating(double rating) {
    List<Widget> stars = [];
    int fullStars = rating.floor();
    bool halfStar = (rating - fullStars) >= 0.5;

    for (int i = 0; i < 5; i++) {
      if (i < fullStars) {
        stars.add(const Icon(Icons.star, color: AppColors.ratingColor, size: AppDimens.starRatingSize));
      } else if (i == fullStars && halfStar) {
        stars.add(const Icon(Icons.star_half, color: AppColors.ratingColor, size: AppDimens.starRatingSize));
      } else {
        stars.add(const Icon(Icons.star_border, color: AppColors.ratingColor, size: AppDimens.starRatingSize));
      }
    }
    return Row(children: stars);
  }
}
