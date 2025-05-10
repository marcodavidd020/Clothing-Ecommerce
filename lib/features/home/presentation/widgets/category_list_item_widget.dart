import 'package:flutter/material.dart';
import 'package:flutter_application_ecommerce/core/constants/constants.dart';
import 'package:flutter_application_ecommerce/core/widgets/widgets.dart';
import 'package:flutter_application_ecommerce/features/home/domain/domain.dart';

class CategoryListItemWidget extends StatelessWidget {
  final CategoryItemModel category;
  final VoidCallback? onTap;

  const CategoryListItemWidget({
    super.key,
    required this.category,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: AppDimens.vSpace12),
        padding: const EdgeInsets.all(AppDimens.contentPaddingHorizontal),
        decoration: BoxDecoration(
          color: AppColors.inputFill, // Un color de fondo claro
          borderRadius: BorderRadius.circular(AppDimens.buttonRadius / 4), // Bordes redondeados
        ),
        child: Row(
          children: [
            SizedBox(
              width: 50, // Tamaño fijo para la imagen
              height: 50,
              child: ClipRRect( // Envolver con ClipRRect para bordes redondeados
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
            const Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: AppColors.textDark,
            )
          ],
        ),
      ),
    );
  }
} 