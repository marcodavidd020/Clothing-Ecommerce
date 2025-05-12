import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_application_ecommerce/core/constants/constants.dart';

/// Widget that displays a cart icon in a circular container.
class CartIconWidget extends StatelessWidget {
  /// Creates an instance of [CartIconWidget].
  const CartIconWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: AppDimens.backButtonSize,
      height: AppDimens.backButtonSize,
      decoration: BoxDecoration(
        color: AppColors.inputFill,
        shape: BoxShape.circle,
      ),
      child: Center(
        child: SvgPicture.asset(
          AppStrings.bagIcon,
          width: AppDimens.iconSize,
          height: AppDimens.iconSize,
          colorFilter: const ColorFilter.mode(
            AppColors.primary,
            BlendMode.srcIn,
          ),
        ),
      ),
    );
  }
}
