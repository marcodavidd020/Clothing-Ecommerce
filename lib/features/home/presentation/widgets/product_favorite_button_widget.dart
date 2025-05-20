import 'package:flutter/material.dart';
import 'package:flutter_application_ecommerce/core/constants/constants.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// Widget que muestra un botón de favorito para productos.
class ProductFavoriteButtonWidget extends StatelessWidget {
  /// Indica si el producto está marcado como favorito
  final bool isFavorite;

  /// Callback cuando se presiona el botón
  final VoidCallback? onPressed;

  /// Constructor principal
  const ProductFavoriteButtonWidget({
    super.key,
    required this.isFavorite,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: AppDimens.heartPositionTop,
      right: AppDimens.heartPositionRight,
      child: GestureDetector(
        onTap: onPressed,
        child: Container(
          padding: const EdgeInsets.all(AppDimens.heartPadding),
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.white,
          ),
          child: SvgPicture.asset(
            AppStrings.heartIcon,
            colorFilter:
                isFavorite
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
}
