import 'package:flutter/material.dart';
import 'package:flutter_application_ecommerce/core/constants/constants.dart';
import 'package:flutter_application_ecommerce/core/widgets/widgets.dart';
import 'package:flutter_application_ecommerce/features/home/core/constants/home_ui.dart';
import 'package:flutter_application_ecommerce/features/home/domain/domain.dart';
import 'package:flutter_svg/flutter_svg.dart';
class CategoryListItemWidget extends StatelessWidget {
  final CategoryItemModel category;
  final VoidCallback? onTap;
  final Widget? trailingIcon;
  final Color? backgroundColor;
  final double? iconSize;

  const CategoryListItemWidget({
    super.key,
    required this.category,
    this.onTap,
    this.trailingIcon,
    this.backgroundColor,
    this.iconSize,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(HomeUI.subcategoriesPadding),
        decoration: BoxDecoration(
          color:
              backgroundColor ?? AppColors.inputFill, // Un color de fondo claro
          borderRadius: BorderRadius.circular(
            HomeUI.subcategoriesBorderRadius,
          ), // Bordes redondeados
        ),
        child: Row(
          children: [
            SizedBox(
              width: iconSize ?? 50, // Tamaño configurable para la imagen
              height: iconSize ?? 50,
              child: ClipRRect(
                // Envolver con ClipRRect para bordes redondeados
                borderRadius: BorderRadius.circular(AppDimens.buttonRadius / 5),
                child: NetworkImageWithPlaceholder(
                  imageUrl: category.imageUrl,
                  fit: BoxFit.contain, // Para que la imagen se vea completa
                  shape: BoxShape.rectangle,
                ),
              ),
            ),
            const SizedBox(width: AppDimens.contentPaddingHorizontal),
            Expanded(
              child: Text(
                category.name,
                style: AppTextStyles.inputText.copyWith(
                  fontWeight: FontWeight.w500,
                  color: AppColors.textDark,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            trailingIcon ??
                SvgPicture.asset(
                  AppStrings.arrowRightIcon,
                  width: 16,
                  height: 16,
                  color: AppColors.textDark,
                ),
          ],
        ),
      ),
    );
  }
}
