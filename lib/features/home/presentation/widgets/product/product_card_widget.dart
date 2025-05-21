import 'package:flutter/material.dart';
import 'package:flutter_application_ecommerce/core/constants/constants.dart';
import 'package:flutter_application_ecommerce/features/home/domain/entities/product_item_model.dart';

/// Widget que muestra una tarjeta de producto
class ProductCardWidget extends StatelessWidget {
  /// Datos del producto a mostrar
  final ProductItemModel product;

  /// Callback cuando se presiona la tarjeta
  final VoidCallback onTap;

  /// Callback cuando se presiona el botón de favorito
  final VoidCallback onFavoriteToggle;

  /// Constructor
  const ProductCardWidget({
    super.key,
    required this.product,
    required this.onTap,
    required this.onFavoriteToggle,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 160,
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Imagen del producto
            Stack(
              alignment: Alignment.topRight,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    product.imageUrl,
                    height: 120,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        height: 120,
                        width: double.infinity,
                        color: Colors.grey[300],
                        child: const Icon(
                          Icons.image_not_supported,
                          color: Colors.grey,
                        ),
                      );
                    },
                  ),
                ),
                // Botón de favorito
                _buildFavoriteButton(),
              ],
            ),
            const SizedBox(height: 8),
            // Nombre del producto
            Text(
              product.name,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: AppColors.textDark,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
            // Precio
            Text(
              '\$${product.price.toStringAsFixed(2)}',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),
            // Si hay un precio original, mostrar descuento
            if (product.originalPrice != null) ...[
              const SizedBox(height: 2),
              Row(
                children: [
                  Text(
                    '\$${product.originalPrice!.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 12,
                      decoration: TextDecoration.lineThrough,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 4,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.error,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      '-${_calculateDiscountPercent()}%',
                      style: const TextStyle(
                        fontSize: 10,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  /// Calcula el porcentaje de descuento
  int _calculateDiscountPercent() {
    if (product.originalPrice == null ||
        product.originalPrice! <= product.price) {
      return 0;
    }
    return ((1 - (product.price / product.originalPrice!)) * 100).round();
  }

  Widget _buildFavoriteButton() {
    return InkWell(
      onTap: onFavoriteToggle,
      child: Container(
        padding: const EdgeInsets.all(4),
        margin: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Icon(
          product.isFavorite ? Icons.favorite : Icons.favorite_border,
          color: product.isFavorite ? AppColors.error : Colors.grey,
          size: 20,
        ),
      ),
    );
  }
}
