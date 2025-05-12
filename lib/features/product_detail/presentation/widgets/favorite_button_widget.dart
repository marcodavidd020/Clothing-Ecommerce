import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_application_ecommerce/core/constants/constants.dart';
import 'package:flutter_application_ecommerce/features/product_detail/core/core.dart';

/// A button widget for toggling favorite status of a product.
class FavoriteButtonWidget extends StatelessWidget {
  /// Whether the product is marked as favorite.
  final bool isFavorite;

  /// Callback function when the favorite button is tapped.
  final VoidCallback onTap;

  /// Creates an instance of [FavoriteButtonWidget].
  const FavoriteButtonWidget({
    super.key,
    required this.isFavorite,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: AppDimens.backButtonSize,
        height: AppDimens.backButtonSize,
        decoration: BoxDecoration(
          color: AppColors.inputFill,
          shape: BoxShape.circle,
        ),
        child: Center(
          child: SvgPicture.asset(
            ProductDetailStrings.heartIcon,
            width: AppDimens.iconSize * 0.8,
            height: AppDimens.iconSize * 0.8,
            colorFilter: ColorFilter.mode(
              isFavorite ? AppColors.primary : AppColors.textDark,
              BlendMode.srcIn,
            ),
          ),
        ),
      ),
    );
  }
}
