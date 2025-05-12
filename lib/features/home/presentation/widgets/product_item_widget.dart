import 'package:flutter/material.dart';
import 'package:flutter_application_ecommerce/core/constants/constants.dart';
import 'package:flutter_application_ecommerce/core/widgets/widgets.dart';
import 'package:flutter_application_ecommerce/features/home/domain/domain.dart';
// import 'package:flutter_application_ecommerce/features/product_detail/presentation/pages/product_detail_page.dart';
import 'package:flutter_svg/flutter_svg.dart';

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
          children: [_buildProductImageSection(), _buildProductInfoSection()],
        ),
      ),
    );
  }

  /// Construye la sección de la imagen del producto con el botón de favorito
  Widget _buildProductImageSection() {
    return Stack(children: [_buildProductImage(), _buildFavoriteButton()]);
  }

  /// Construye la imagen del producto
  Widget _buildProductImage() {
    return SizedBox(
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
    );
  }

  /// Construye el botón de favorito
  Widget _buildFavoriteButton() {
    return Positioned(
      top: AppDimens.heartPositionTop,
      right: AppDimens.heartPositionRight,
      child: GestureDetector(
        onTap: () {
          if (onFavoriteToggle != null) {
            onFavoriteToggle!(product);
          }
        },
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
    );
  }

  /// Construye la sección de información del producto
  Widget _buildProductInfoSection() {
    return Padding(
      padding: const EdgeInsets.all(AppDimens.vSpace12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildProductName(),
          const SizedBox(height: AppDimens.vSpace1),
          _buildRatingSection(),
          const SizedBox(height: AppDimens.vSpace1),
          _buildPriceSection(),
        ],
      ),
    );
  }

  /// Construye el nombre del producto
  Widget _buildProductName() {
    return Text(
      product.name,
      style: AppTextStyles.topSellingItemName,
      overflow: TextOverflow.ellipsis,
    );
  }

  /// Construye la sección de calificación (estrellas y número de reseñas)
  Widget _buildRatingSection() {
    return Row(
      children: [
        _buildStarRating(product.averageRating),
        if (product.reviewCount != null)
          Padding(
            padding: const EdgeInsets.only(left: 4.0),
            child: Text(
              '(${product.reviewCount})',
              style: TextStyle(fontSize: 10, color: Colors.grey[600]),
            ),
          ),
      ],
    );
  }

  /// Construye la sección de precios (actual y original)
  Widget _buildPriceSection() {
    return Row(
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
    );
  }

  /// Construye la calificación en estrellas
  Widget _buildStarRating(double rating) {
    List<Widget> stars = [];
    int fullStars = rating.floor();
    bool halfStar = (rating - fullStars) >= 0.5;

    for (int i = 0; i < 5; i++) {
      if (i < fullStars) {
        stars.add(
          const Icon(
            Icons.star,
            color: AppColors.ratingColor,
            size: AppDimens.starRatingSize,
          ),
        );
      } else if (i == fullStars && halfStar) {
        stars.add(
          const Icon(
            Icons.star_half,
            color: AppColors.ratingColor,
            size: AppDimens.starRatingSize,
          ),
        );
      } else {
        stars.add(
          const Icon(
            Icons.star_border,
            color: AppColors.ratingColor,
            size: AppDimens.starRatingSize,
          ),
        );
      }
    }
    return Row(children: stars);
  }
}
