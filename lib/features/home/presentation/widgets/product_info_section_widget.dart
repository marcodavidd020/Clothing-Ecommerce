import 'package:flutter/material.dart';
import 'package:flutter_application_ecommerce/core/constants/constants.dart';
import 'package:flutter_application_ecommerce/features/home/presentation/widgets/product_star_rating_widget.dart';

/// Widget que muestra la información del producto: nombre, calificación y precio.
class ProductInfoSectionWidget extends StatelessWidget {
  /// Nombre del producto
  final String name;

  /// Calificación promedio del producto (0.0 a 5.0)
  final double averageRating;

  /// Número de reseñas del producto (opcional)
  final int? reviewCount;

  /// Precio actual del producto
  final double price;

  /// Precio original del producto antes de descuento (opcional)
  final double? originalPrice;

  /// Constructor principal
  const ProductInfoSectionWidget({
    super.key,
    required this.name,
    required this.averageRating,
    this.reviewCount,
    required this.price,
    this.originalPrice,
  });

  @override
  Widget build(BuildContext context) {
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
      name,
      style: AppTextStyles.topSellingItemName,
      overflow: TextOverflow.ellipsis,
    );
  }

  /// Construye la sección de calificación (estrellas y número de reseñas)
  Widget _buildRatingSection() {
    return Row(
      children: [
        ProductStarRatingWidget(rating: averageRating),
        if (reviewCount != null)
          Padding(
            padding: const EdgeInsets.only(left: 4.0),
            child: Text(
              '($reviewCount)',
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
          '\$${price.toStringAsFixed(2)}',
          style: AppTextStyles.topSellingItem,
        ),
        if (originalPrice != null) ...[
          const SizedBox(width: AppDimens.vSpace8),
          Text(
            '\$${originalPrice!.toStringAsFixed(2)}',
            style: AppTextStyles.topSellingItemWithPrice,
          ),
        ],
      ],
    );
  }
}
