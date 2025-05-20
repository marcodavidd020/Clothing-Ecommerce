import 'package:flutter/material.dart';
import 'package:flutter_application_ecommerce/core/constants/constants.dart';

/// Widget que muestra una calificación en estrellas.
class ProductStarRatingWidget extends StatelessWidget {
  /// Calificación a mostrar (entre 0.0 y 5.0)
  final double rating;

  /// Tamaño de las estrellas
  final double size;

  /// Color de las estrellas
  final Color color;

  /// Constructor principal
  const ProductStarRatingWidget({
    super.key,
    required this.rating,
    this.size = AppDimens.starRatingSize,
    this.color = AppColors.ratingColor,
  });

  @override
  Widget build(BuildContext context) {
    List<Widget> stars = [];
    int fullStars = rating.floor();
    bool halfStar = (rating - fullStars) >= 0.5;

    for (int i = 0; i < 5; i++) {
      if (i < fullStars) {
        stars.add(Icon(Icons.star, color: color, size: size));
      } else if (i == fullStars && halfStar) {
        stars.add(Icon(Icons.star_half, color: color, size: size));
      } else {
        stars.add(Icon(Icons.star_border, color: color, size: size));
      }
    }
    return Row(children: stars);
  }
}
