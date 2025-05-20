import 'package:flutter/material.dart';
import 'package:flutter_application_ecommerce/core/constants/constants.dart';
import 'package:flutter_svg/flutter_svg.dart';

class OptionSelectorWidget extends StatelessWidget {
  final String label;
  final Widget valueDisplay;
  final VoidCallback? onTap;

  const OptionSelectorWidget({
    super.key,
    required this.label,
    required this.valueDisplay,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimens.contentPaddingHorizontal,
          vertical: AppDimens.contentPaddingVertical,
        ),
        decoration: BoxDecoration(
          color: AppColors.inputFill,
          borderRadius: BorderRadius.circular(AppDimens.buttonRadius / 4),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: AppTextStyles.inputText.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
            Row(
              children: [
                valueDisplay,
                const SizedBox(width: AppDimens.vSpace24),
                if (onTap != null) // Solo mostrar flecha si es tappable
                  SvgPicture.asset(
                    AppStrings.arrowDownIcon,
                    width: AppDimens.optionSelectorArrowSize,
                    height: AppDimens.optionSelectorArrowSize,
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
