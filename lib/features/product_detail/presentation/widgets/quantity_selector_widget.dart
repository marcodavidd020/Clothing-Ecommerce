import 'package:flutter/material.dart';
import 'package:flutter_application_ecommerce/core/constants/constants.dart';
import 'package:flutter_application_ecommerce/features/product_detail/product_detail.dart';

class QuantitySelectorWidget extends StatelessWidget {
  final int quantity;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;

  const QuantitySelectorWidget({
    super.key,
    required this.quantity,
    required this.onIncrement,
    required this.onDecrement,
  });

  Widget _buildQuantityButton({
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return InkWell(
      onTap: onPressed,
      customBorder: const CircleBorder(),
      child: Container(
        padding: const EdgeInsets.all(AppDimens.quantityButtonPadding),
        decoration: const BoxDecoration(
          color: AppColors.primary,
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          color: AppColors.white,
          size: AppDimens.quantityButtonIconSize,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimens.contentPaddingHorizontal,
        vertical: AppDimens.contentPaddingVertical,
      ),
      // margin: const EdgeInsets.only(bottom: AppDimens.vSpace12),
      decoration: BoxDecoration(
        color: AppColors.inputFill,
        borderRadius: BorderRadius.circular(AppDimens.buttonRadius / 4),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            ProductDetailStrings.quantityLabel,
            style: AppTextStyles.inputText.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
          Row(
            children: [
              _buildQuantityButton(icon: Icons.remove, onPressed: onDecrement),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppDimens.vSpace24,
                ),
                child: Text(
                  '$quantity',
                  style: AppTextStyles.heading.copyWith(
                    fontSize: AppDimens.quantitySelectorFontSize,
                  ),
                ),
              ),
              _buildQuantityButton(icon: Icons.add, onPressed: onIncrement),
            ],
          ),
        ],
      ),
    );
  }
}
