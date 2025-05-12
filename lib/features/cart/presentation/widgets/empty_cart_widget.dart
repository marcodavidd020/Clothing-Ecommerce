import 'package:flutter/material.dart';
import 'package:flutter_application_ecommerce/core/constants/constants.dart';
import 'package:flutter_application_ecommerce/features/cart/core/core.dart';

/// Widget that displays the empty cart state.
class EmptyCartWidget extends StatelessWidget {
  /// Creates an instance of [EmptyCartWidget].
  const EmptyCartWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // TODO: Add a cart illustration or icon
          const Icon(
            Icons.shopping_cart_outlined,
            size: 80,
            color: AppColors.textLight,
          ),
          const SizedBox(height: AppDimens.vSpace16),
          Text(
            CartStrings.emptyCartTitle,
            style: AppTextStyles.heading.copyWith(color: AppColors.textDark),
          ),
          const SizedBox(height: AppDimens.vSpace8),
          Text(
            CartStrings.emptyCartMessage,
            style: AppTextStyles.body.copyWith(color: AppColors.textLight),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
