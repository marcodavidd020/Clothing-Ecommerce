import 'package:flutter/material.dart';
import 'package:flutter_application_ecommerce/core/constants/constants.dart';
import 'package:flutter_application_ecommerce/core/widgets/widgets.dart';
import 'package:flutter_application_ecommerce/features/home/presentation/presentation.dart';

/// Widget que muestra la sección de imagen de un producto con un botón de favorito.
class ProductImageSectionWidget extends StatelessWidget {
  /// URL de la imagen del producto
  final String imageUrl;

  /// Indica si el producto está marcado como favorito
  final bool isFavorite;

  /// Callback cuando se presiona el botón de favorito
  final VoidCallback? onFavoritePressed;

  /// Constructor principal
  const ProductImageSectionWidget({
    super.key,
    required this.imageUrl,
    required this.isFavorite,
    this.onFavoritePressed,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        _buildProductImage(),
        ProductFavoriteButtonWidget(
          isFavorite: isFavorite,
          onPressed: onFavoritePressed,
        ),
      ],
    );
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
          imageUrl: imageUrl,
          fit: BoxFit.cover,
          shape: BoxShape.rectangle,
        ),
      ),
    );
  }
}
