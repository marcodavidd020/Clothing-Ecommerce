import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../constants/constants.dart';

class GenderSelectorButton extends StatelessWidget {
  final String selectedGender;
  final VoidCallback onPressed;

  const GenderSelectorButton({
    super.key,
    required this.selectedGender,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimens.genderSelectorPadding,
          vertical: AppDimens.genderSelectorPadding,
        ),
        decoration: BoxDecoration(
          color:
              AppColors
                  .inputFill, // Usando un color existente, puedes cambiarlo
          borderRadius: BorderRadius.circular(
            AppDimens.buttonRadius,
          ), // Usando radio de botón existente
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              selectedGender,
              style: AppTextStyles.inputText.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.textDark,
              ),
            ),
            const SizedBox(width: AppDimens.genderSelectorPadding),
            SvgPicture.asset(
              AppStrings.arrowDownIcon,
              width: 16,
              height: 16,
              colorFilter: const ColorFilter.mode(
                AppColors.textDark,
                BlendMode.srcIn,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
